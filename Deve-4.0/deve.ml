type typ = IntTy
         | BoolTy
         | PairTy of typ * typ
         | FunTy of typ * typ

type param = string * typ

type exp = CstI of int
         | CstB of bool
         | Var of string
         | Binary of string * exp * exp
         | LetIn of string * exp * exp
         | LetRec of string * param * typ * exp * exp
         | If of exp * exp * exp
         | MatchPair of exp * string * string * exp
         | Fun of param * exp
         | App of exp * exp

let rec lookup x env =
  match env with
  | [] -> failwith ("Unbound name " ^ x)
  | (y,i)::rest -> if x = y then i
                   else lookup x rest

(* typeOf: exp -> (string * typ) list -> typ *)
let rec typeOf e tyEnv =
  match e with
  | CstI i -> IntTy
  | CstB b -> BoolTy
  | Var x -> lookup x tyEnv
  | Binary(op, e1, e2)  ->
     let t1 = typeOf e1 tyEnv in
     let t2 = typeOf e2 tyEnv in
     (match op, t1, t2 with
      | "+", IntTy, IntTy -> IntTy
      | "-", IntTy, IntTy -> IntTy
      | "*", IntTy, IntTy -> IntTy
      | "/", IntTy, IntTy -> IntTy
      | "<", IntTy, IntTy -> BoolTy
      | "<=", IntTy, IntTy -> BoolTy
      | ",", _, _ -> PairTy(t1, t2)
      | _ -> failwith ("Bad use of the binary operator: " ^ op)
     )
  | LetIn(x, e1, e2) ->
     let t = typeOf e1 tyEnv
     in let tyEnv' = (x, t)::tyEnv
        in typeOf e2 tyEnv'
  | LetRec(f, (x,t1), retTy, e1, e2) ->
     let tBody = typeOf e1 ((f, FunTy(t1,retTy))::(x,t1)::tyEnv)
     in if tBody = retTy then
          typeOf e2 ((f, FunTy(t1,retTy))::tyEnv)
        else failwith "Return type of the rec. function should agree with the type of the bofy."
  | If(e1, e2, e3) -> (match typeOf e1 tyEnv with
                       | BoolTy -> let t2 = typeOf e2 tyEnv in
                                   let t3 = typeOf e3 tyEnv in
                                   if t2 = t3 then t2
                                   else failwith "Branch types of an if-then-else must agree." 
                       | _ -> failwith "Condition should be a bool.")
  | MatchPair(e1, x, y, e2) ->
     (match typeOf e1 tyEnv with
      | PairTy(t1, t2) -> typeOf e2 ((x,t1)::(y,t2)::tyEnv)
      | _ -> failwith "Pair pattern matching works on pair values only (obviously)!"
     )
  | Fun((x, t), e) ->
     let tBody = typeOf e ((x,t)::tyEnv)
     in FunTy(t, tBody)
  | App(e1, e2) ->
     (match typeOf e1 tyEnv with
      | FunTy(t2, t1) ->
         if t2 = typeOf e2 tyEnv then t1
         else failwith "Function parameter type should agree with the argument type."
      | _ -> failwith "Application wants to see a function!"
     )

type value = Int of int
           | Bool of bool
           | Pair of value * value
           | Closure of string * exp * ((string * value) list)  (* parameter, body, environment *)
           | RecClosure of string * string * exp * ((string * value) list) (* also contains the function name *)

(* eval: exp -> (string * value) list -> value *)
let rec eval e env =
  match e with
  | CstI i -> Int i
  | CstB b -> Bool b
  | Var x -> lookup x env
  | Binary(op, e1, e2)  ->
     let v1 = eval e1 env in
     let v2 = eval e2 env in
     (match op, v1, v2 with
      | "+", Int i1, Int i2 -> Int(i1 + i2)
      | "-", Int i1, Int i2 -> Int(i1 - i2)
      | "*", Int i1, Int i2 -> Int(i1 * i2)
      | "/", Int i1, Int i2 -> Int(i1 / i2)
      | "<", Int i1, Int i2 -> Bool(i1 < i2)
      | "<=", Int i1, Int i2 -> Bool(i1 <= i2)
      | ",", _, _ -> Pair(v1, v2)
     )
  | LetIn(x, e1, e2) -> let v = eval e1 env
                        in let env' = (x, v)::env
                           in eval e2 env'
  | LetRec(f, (x, t), retTy, e1, e2) ->
     let closure = RecClosure(f, x, e1, env)
     in eval e2 ((f, closure)::env)
  | If(e1, e2, e3) -> (match eval e1 env with
                       | Bool true -> eval e2 env
                       | Bool false -> eval e3 env
                       | _ -> failwith "Condition should be a Bool.")
  | MatchPair(e1, x, y, e2) ->
     (match eval e1 env with
      | Pair(v1, v2) -> eval e2 ((x,v1)::(y,v2)::env)
      | _ -> failwith "Pair pattern matching works on pair values only (obviously)!"
     )
  | Fun((x, t), e) -> Closure(x, e, env)
  | App(e1, e2) ->
     let closure = eval e1 env in
     (match closure with
      | Closure(x, funBody, funEnv) ->
         let v2 = eval e2 env
         in eval funBody ((x, v2)::funEnv)
      | RecClosure(f, x, funBody, funEnv) ->
         let v2 = eval e2 env
         in eval funBody ((f,closure)::(x, v2)::funEnv)
      | _ -> failwith "Application wants to see a closure!"
     )

