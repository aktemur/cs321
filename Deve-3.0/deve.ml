type exp = CstI of int
         | CstB of bool
         | Var of string
         | Unary of string * exp
         | Binary of string * exp * exp
         | LetIn of string * exp * exp
         | LetRec of string * string * exp * exp
         | If of exp * exp * exp
         | MatchPair of exp * string * string * exp
         | Fun of string * exp
         | App of exp * exp

type value = Int of int
           | Bool of bool
           | Pair of value * value
           | Closure of string * exp * ((string * value) list)  (* parameter, body, environment *)
           | RecClosure of string * string * exp * ((string * value) list) (* also contains the function name *)

let rec lookup x env =
  match env with
  | [] -> failwith ("Unbound name " ^ x)
  | (y,i)::rest -> if x = y then i
                   else lookup x rest

(* eval: exp -> (string * value) list -> value *)
let rec eval e env =
  match e with
  | CstI i -> Int i
  | CstB b -> Bool b
  | Var x -> lookup x env
  | Unary(op, e) ->
     let v = eval e env in
     (match op, v with
      | "fst", Pair(v1, v2) -> v1
      | "snd", Pair(v1, v2) -> v2
      | "not", Bool b -> Bool (not b)
     )
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
  | LetRec(f, x, e1, e2) ->
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
  | Fun(x, e) -> Closure(x, e, env)
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

