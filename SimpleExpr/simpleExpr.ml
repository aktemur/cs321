type expr = CstI of int
          | Var of string
          | Prim of string * expr * expr 
          | Let of string * expr * expr
          | If of expr * expr * expr

let rec lookup x env =
  match env with
  | [] -> failwith ("Name '" ^ x ^ "' not found :(")
  | (y,i)::rest -> if y = x then i
                   else lookup x rest
              
(* eval: expr -> (string * int) list -> int *)
let rec eval e env =
  match e with
  | CstI i -> i
  | Var x -> lookup x env
  | Prim(op, e1, e2) ->
     let (i1, i2) = (eval e1 env, eval e2 env) in
     (match op with
      | "+" -> i1 + i2
      | "-" -> i1 - i2
      | "*" -> i1 * i2
      | "/" -> i1 / i2
      | "=" -> if i1 = i2 then 1 else 0
      | "<" -> if i1 < i2 then 1 else 0
      | _ -> failwith "Unrecognized Prim operator"
     )
  | Let(x, e1, e2) -> let i = eval e1 env in
                      let newEnv = (x, i)::env in
                      eval e2 newEnv
  | If(c, e1, e2) -> (match eval c env with
                      | 1 -> eval e1 env
                      | 0 -> eval e2 env
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
