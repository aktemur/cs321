type tip = IntTy
         | BoolTy
         | FunTy of tip * tip
         | PairTy of tip * tip
         | Alpha of int

type typeEnvironment = (string * tip) list

type expr = CstI of int
          | Var of string
          | Unary of string * expr
          | Prim of string * expr * expr 
          | Let of string * expr * expr
          | If of expr * expr * expr
          | MatchPair of expr * string * string * expr
          | Fun of string * expr
          | App of expr * expr

type value = Int of int
           | Bool of bool
           | Pair of value * value
           | Closure of string * expr * environment

and environment = (string * value) list
                            

let rec lookup x env =
  match env with
  | [] -> failwith ("Name '" ^ x ^ "' not found :(")
  | (y,i)::rest -> if y = x then i
                   else lookup x rest
              
(* eval: expr -> environment -> value *)
let rec eval e env =
  match e with
  | CstI i -> Int(i)
  | Var x -> lookup x env
  | Unary(op, e1) ->
     let v = eval e1 env in
     (match op, v with
      | "not", Bool(b) -> Bool(not b)
      | "fst", Pair(v1,v2) -> v1
      | "snd", Pair(v1,v2) -> v2
      | _ -> failwith "Eval error: Unrecognized Unary operator or bad value."
     )
  | Prim(op, e1, e2) ->
     let (v1, v2) = (eval e1 env, eval e2 env) in
     (match op, v1, v2 with
      | "+", Int(i1), Int(i2) -> Int(i1 + i2)
      | "-", Int(i1), Int(i2) -> Int(i1 - i2)
      | "*", Int(i1), Int(i2) -> Int(i1 * i2)
      | "/", Int(i1), Int(i2) -> Int(i1 / i2)
      | "=", Int(i1), Int(i2) -> if i1 = i2 then Bool(true) else Bool(false)
      | "<", Int(i1), Int(i2) -> if i1 < i2 then Bool(true) else Bool(false)
      | "min", Int(i1), Int(i2) -> if i1 < i2 then Int(i1) else Int(i2)
      | "max", Int(i1), Int(i2) -> if i1 < i2 then Int(i2) else Int(i1)
      | ",", v1, v2 -> Pair(v1, v2)
      | _ -> failwith "Eval error: Unrecognized Prim operator or bad values."
     )
  | Let(x, e1, e2) -> let i = eval e1 env in
                      let newEnv = (x, i)::env in
                      eval e2 newEnv
  | If(c, e1, e2) -> (match eval c env with
                      | Bool(true) -> eval e1 env
                      | Bool(false) -> eval e2 env
                      | _ -> failwith "Eval error: If-condition not a bool.")
  | MatchPair(e1, x, y, e2) ->
     (match eval e1 env with
      | Pair(v1,v2) ->
         let newEnv = (x,v1)::(y,v2)::env in
         eval e2 newEnv
      | _ -> failwith "Eval error: Match works for Pairs only."
     )
  | Fun(x, body) -> Closure(x, body, env)
  | App(e1, e2) ->
     (match eval e1 env with
      | Closure(x, body, fEnv) ->
         let arg = eval e2 env in
         eval body ((x,arg)::fEnv)
      | _ -> failwith "Eval error: Closure needed in application."
     )


(* Mutable value to generate fresh type variables *)
let counter = ref 0
let freshTyVar() =
  let i = !counter in counter := i + 1; Alpha(i)
                                        
type typeConstraint = tip * tip

(* (===): tip -> tip -> typeConstraint 
   This is a user-defined infix operator. 
   Defined for convenience.
*)                              
let (===) t1 t2 = (t1,t2)

(* infer: expr -> typeEnvironment -> (tip * (typeConstraint list)) *)
let rec infer e tyEnv =
  match e with
  | CstI _ -> (IntTy, [])
  | Var x -> (lookup x tyEnv, []) 
  | Unary (op, e1) ->
     let (t1, c1) = infer e1 tyEnv in
     (match op with
      | "not" -> (BoolTy, (t1 === BoolTy)::c1)
      | "fst" -> let (alpha, beta) = (freshTyVar(), freshTyVar()) in
                 (alpha, (t1 === PairTy(alpha, beta))::c1)
      | "snd" -> let (alpha, beta) = (freshTyVar(), freshTyVar()) in
                 (beta, (t1 === PairTy(alpha, beta))::c1)
      | _ -> failwith "Type error: Unrecognized Unary operator or bad type."
     )
  | Prim (op, e1, e2) ->
     let ((t1, c1), (t2, c2)) = (infer e1 tyEnv, infer e2 tyEnv)
     in (match op with
         | "+" -> (IntTy, (t1 === IntTy)::(t2 === IntTy)::(c1@c2))
         | "*" -> (IntTy, (t1 === IntTy)::(t2 === IntTy)::(c1@c2))
         | "-" -> (IntTy, (t1 === IntTy)::(t2 === IntTy)::(c1@c2))
         | "/" -> (IntTy, (t1 === IntTy)::(t2 === IntTy)::(c1@c2))
         | "=" -> (BoolTy, (t1 === IntTy)::(t2 === IntTy)::(c1@c2))
         | "<" -> (BoolTy, (t1 === IntTy)::(t2 === IntTy)::(c1@c2))
         | "min" -> (IntTy, (t1 === IntTy)::(t2 === IntTy)::(c1@c2))
         | "max" -> (IntTy, (t1 === IntTy)::(t2 === IntTy)::(c1@c2))
         | "," -> (PairTy(t1, t2), (c1@c2))
         | _ -> failwith "Type error: Bad Prim case"
        )
  | Let (x, e1, e2) ->
     let (t1, c1) = infer e1 tyEnv in
     let newEnv = (x, t1)::tyEnv in
     let (t2, c2) = infer e2 newEnv in
     (t2, c1@c2)
  | If (c, e1, e2) ->
     let (ct, cc) = infer c tyEnv in
     let (t1, c1) = infer e1 tyEnv in
     let (t2, c2) = infer e2 tyEnv in
     (t1, (t1 === t2)::(ct === BoolTy)::(cc@c1@c2))
  | MatchPair (e1, x, y, e2) ->
     let (t1, c1) = infer e1 tyEnv in
     let (alpha, beta) = (freshTyVar(), freshTyVar()) in
     let newEnv = (x, alpha)::(y, beta)::tyEnv in
     let (t2, c2) = infer e2 newEnv in
     (t2, (t1 === PairTy(alpha, beta))::(c1@c2))
  | Fun (x, body) ->
     let alpha = freshTyVar() in
     let (t2, c2) = infer body ((x, alpha)::tyEnv) in
     (FunTy(alpha, t2), c2)
  | App (e1, e2) ->
     let (t1, c1) = infer e1 tyEnv in
     let (t2, c2) = infer e2 tyEnv in
     let beta = freshTyVar() in
     (beta, (t1 === FunTy(t2, beta))::(c1@c2))

(* occurs: int -> tip -> bool
   occurs i t: Does type variable i occur in type t?
*) 
let rec occurs i t =
  match t with
  | IntTy -> false
  | BoolTy -> false
  | PairTy(t1, t2) -> occurs i t1 || occurs i t2
  | FunTy(t1, t2) -> occurs i t1 || occurs i t2
  | Alpha(j) -> i = j

type substitution = int -> tip

let identitySub = fun i -> Alpha(i)

(* substInType: tip -> substitution -> tip *)
let rec substInType t sub =
  match t with
  | IntTy -> IntTy
  | BoolTy -> BoolTy
  | PairTy(t1, t2) ->
     PairTy(substInType t1 sub, substInType t2 sub)
  | FunTy(t1, t2) ->
     FunTy(substInType t1 sub, substInType t2 sub)
  | Alpha(i) -> sub(i)

let substInConstraints cs sub =
  List.map (fun (t1,t2) -> (substInType t1 sub, substInType t2 sub)) cs

(* unify: constraint list -> substitution *)
let rec unify cs =
  match cs with
  | [] -> identitySub
  (* Delete *)
  | (t1, t2)::cs' when t1 = t2 -> unify cs'
  (* Decompose *)
  | (PairTy(t11, t12), PairTy(t21, t22))::cs' -> unify ((t11 === t21)::(t12 === t22)::cs')
  | (FunTy(t11, t12), FunTy(t21, t22))::cs' -> unify ((t11 === t21)::(t12 === t22)::cs')
  (* Eliminate *)
  | (Alpha(i), t)::cs' when not(occurs i t) ->
     let sub = (fun j -> if j = i then t else identitySub j) in
     let newCs = substInConstraints cs' sub in
     let sigma = unify newCs in
     (fun j -> if j = i then substInType t sigma else sigma j)
  (* Orient *)
  | (t, Alpha(i))::cs' -> unify ((Alpha(i), t)::cs')
  | _ -> failwith "Cannot unify."
