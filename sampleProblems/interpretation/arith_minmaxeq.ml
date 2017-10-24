type exp = CstI of int
         | Var of string
         | Add of exp * exp
         | Mult of exp * exp
         | Subt of exp * exp
         | Div of exp * exp
         | Min of exp * exp
         | Max of exp * exp
         | Eq of exp * exp
         | LetIn of string * exp * exp

(* lookup: string -> (string * int) list -> int *)
let rec lookup x env =
  match env with
  | [] -> failwith ("Unbound name " ^ x)
  | (y,i)::rest -> if x = y then i
                   else lookup x rest

(* eval: exp -> (string * int) list -> int *)
let rec eval e env =
  match e with
  | CstI i -> i
  | Var x -> lookup x env
  | Add(e1, e2)  -> eval e1 env + eval e2 env
  | Mult(e1, e2) -> eval e1 env * eval e2 env
  | Subt(e1, e2) -> eval e1 env - eval e2 env
  | Div(e1, e2)  -> eval e1 env / eval e2 env
  | Min(e1, e2)  -> let v1 = eval e1 env
                    in let v2 = eval e2 env
                       in if v1 < v2 then v1 else v2
  | Max(e1, e2)  -> let v1 = eval e1 env
                    in let v2 = eval e2 env
                       in if v1 > v2 then v1 else v2
  | Eq(e1, e2)   -> let v1 = eval e1 env
                    in let v2 = eval e2 env
                       in if v1 = v2 then 1 else 0
  | LetIn(x, e1, e2) -> let v = eval e1 env
                        in let env' = (x, v)::env
                           in eval e2 env'
