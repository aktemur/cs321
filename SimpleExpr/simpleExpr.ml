type expr = CstI of int
          | Var of string
          | Unary of string * expr
          | Prim of string * expr * expr 
          | Let of string * expr * expr
          | If of expr * expr * expr

type value = Int of int
           | Bool of bool

let rec lookup x env =
  match env with
  | [] -> failwith ("Name '" ^ x ^ "' not found :(")
  | (y,i)::rest -> if y = x then i
                   else lookup x rest
              
(* eval: expr -> (string * int) list -> value *)
let rec eval e env =
  match e with
  | CstI i -> Int(i)
  | Var x -> lookup x env
  | Unary(op, e1) ->
     let v = eval e1 env in
     (match op, v with
      | "not", Bool(b) -> Bool(not b)
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
      | _ -> failwith "Unrecognized Prim operator or bad values."
     )
  | Let(x, e1, e2) -> let i = eval e1 env in
                      let newEnv = (x, i)::env in
                      eval e2 newEnv
  | If(c, e1, e2) -> (match eval c env with
                      | Bool(true) -> eval e1 env
                      | Bool(false) -> eval e2 env
                      | _ -> failwith "WTF!")

let e1 = Prim("-", Prim("+", CstI 4, Var "a"), CstI 5)

let e2 = Prim("-", Prim("/", Prim("*", Var "x", CstI 30),
                     Var "w"),
               Var "k")
let e3 = Let("a",
             Prim("+", CstI 30, CstI 5),
             Prim("+", Var "a", CstI 12))

let e4 = Let("a", CstI 30,
             Let("b", CstI 12,
                 Prim("+", Var "a",
                      Prim("+", Var "b", CstI 3))))
