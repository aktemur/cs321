type tip = IntTy
         | BoolTy
         | FunTy of tip * tip
         | PairTy of tip * tip

type typeEnvironment = (string * tip) list

type expr = CstI of int
          | Var of string
          | Unary of string * expr
          | Prim of string * expr * expr 
          | Let of string * expr * expr
          | If of expr * expr * expr
          | MatchPair of expr * string * string * expr
          | Fun of string * tip * expr
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
      | _ -> failwith "Unrecognized Unary operator or bad value."
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
      | _ -> failwith "Unrecognized Prim operator or bad values."
     )
  | Let(x, e1, e2) -> let i = eval e1 env in
                      let newEnv = (x, i)::env in
                      eval e2 newEnv
  | If(c, e1, e2) -> (match eval c env with
                      | Bool(true) -> eval e1 env
                      | Bool(false) -> eval e2 env
                      | _ -> failwith "WTF!")
  | MatchPair(e1, x, y, e2) ->
     (match eval e1 env with
      | Pair(v1,v2) ->
         let newEnv = (x,v1)::(y,v2)::env in
         eval e2 newEnv
      | _ -> failwith "Match works for Pairs only you idiot"
     )
  | Fun(x, t, body) -> Closure(x, body, env)
  | App(e1, e2) ->
     (match eval e1 env with
      | Closure(x, body, fEnv) ->
         let arg = eval e2 env in
         eval body ((x,arg)::fEnv)
      | _ -> failwith "Whoa"
     )

(* typeOf: expr -> typeEnvironment -> tip *)
let rec typeOf e tyEnv =
  match e with
  | CstI _ -> IntTy
  | Var x -> lookup x tyEnv 
  | Unary (op, e1) ->
     let t = typeOf e1 tyEnv in
     (match op, t with
      | "not", BoolTy -> BoolTy
      | "fst", PairTy(t1, t2) -> t1
      | "snd", PairTy(t1, t2) -> t2
      | _ -> failwith "Unrecognized Unary operator or bad type."
     )
  | Prim (op, e1, e2) ->
     let (t1,t2) = (typeOf e1 tyEnv, typeOf e2 tyEnv)
     in (match op, t1, t2 with
         | "+", IntTy, IntTy -> IntTy
         | "-", IntTy, IntTy -> IntTy
         | "*", IntTy, IntTy -> IntTy
         | "/", IntTy, IntTy -> IntTy
         | "=", IntTy, IntTy -> BoolTy
         | "<", IntTy, IntTy -> BoolTy
         | "min", IntTy, IntTy -> IntTy
         | "max", IntTy, IntTy -> IntTy
         | ",", t1, t2 -> PairTy(t1, t2)
         | _ -> failwith "Bad Prim case"
        )
  | Let (x, e1, e2) ->
     let t1 = typeOf e1 tyEnv in
     let newEnv = (x, t1)::tyEnv in
     typeOf e2 newEnv
  | If (c, e1, e2) ->
     (match typeOf c tyEnv with
      | BoolTy -> let (t1, t2) = (typeOf e1 tyEnv, typeOf e2 tyEnv)
                  in if t1 = t2 then t1
                     else failwith "Branch types should agree."
      | _ -> failwith "Condition of 'if' should be a boolean."
     )
  | MatchPair (e1, x, y, e2) ->
     (match typeOf e1 tyEnv with
      | PairTy(t1,t2) ->
         let newEnv = (x,t1)::(y,t2)::tyEnv in
         typeOf e2 newEnv
      | _ -> failwith "Match works for Pairs only."
     )
  | Fun (x, t1, e1) ->
     failwith "TODO"
  | App (e1, e2) ->
     (match typeOf e1 tyEnv with
      | FunTy(t1, t2) ->
         let t3 = typeOf e2 tyEnv
         in if t1 = t3 then t2
            else failwith "Function's input type and argument type do not agree."
      | _ -> failwith "Function application of a non-function type"
     )
