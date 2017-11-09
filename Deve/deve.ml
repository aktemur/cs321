type exp = CstI of int
         | CstB of bool
         | Var of string
         | Add of exp * exp
         | Mult of exp * exp
         | Subt of exp * exp
         | Div of exp * exp
         | Less of exp * exp
         | GreaterOrEq of exp * exp
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
  | Add(e1, e2)  -> eval e1 env + eval e2 env
  | Mult(e1, e2) -> eval e1 env * eval e2 env
  | Subt(e1, e2) -> eval e1 env - eval e2 env
  | Div(e1, e2)  -> eval e1 env / eval e2 env
  | Less(e1, e2) -> if (eval e1 env) < (eval e2 env) then 1 else 0
  | GreaterOrEq(e1, e2) -> if (eval e1 env) >= (eval e2 env) then 1 else 0
  | LetIn(x, e1, e2) -> let v = eval e1 env
                        in let env' = (x, v)::env
                           in eval e2 env'
  | If(e1, e2, e3) -> (match eval e1 env with
                       | 0 -> eval e3 env
                       | m -> eval e2 env)
  

