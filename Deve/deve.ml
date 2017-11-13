type exp = CstI of int
         | CstB of bool
         | Var of string
         | Binary of string * exp * exp
         | LetIn of string * exp * exp
         | If of exp * exp * exp

let rec lookup x env =
  match env with
  | [] -> failwith ("Unbound name " ^ x)
  | (y,i)::rest -> if x = y then i
                   else lookup x rest

(* eval: exp -> (string * int) list -> int *)
let rec eval e env =
  match e with
  | CstI i -> i
  | CstB b -> if b then 1 else 0
  | Var x -> lookup x env
  | Binary(op, e1, e2)  ->
     let i1 = eval e1 env in
     let i2 = eval e2 env in
     (match op with
      | "+" -> i1 + i2
      | "-" -> i1 - i2
      | "*" -> i1 * i2
      | "/" -> i1 / i2
     )
  | LetIn(x, e1, e2) -> let v = eval e1 env
                        in let env' = (x, v)::env
                           in eval e2 env'
  | If(e1, e2, e3) -> (match eval e1 env with
                       | 0 -> eval e3 env
                       | m -> eval e2 env)
  

