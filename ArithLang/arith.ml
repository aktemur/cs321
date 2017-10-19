type exp = CstI of int
         | Var of string
         | Add of exp * exp
         | Mult of exp * exp
         | Subt of exp * exp
         | Div of exp * exp

let rec lookup x env =
  match env with
  | [] -> failwith ("Unbound name " ^ x)
  | (y,i)::rest -> if x = y then i
                   else lookup x rest

let env1 = [("a", 5); ("b", 8); ("zzz", 13)]

let env2 = ("b", 99)::env1

(* eval: exp -> (string * int) list -> int *)
let rec eval e env =
  match e with
  | CstI i -> i
  | Var x -> lookup x env
  | Add(e1, e2)  -> eval e1 env + eval e2 env
  | Mult(e1, e2) -> eval e1 env * eval e2 env
  | Subt(e1, e2) -> eval e1 env - eval e2 env
  | Div(e1, e2)  -> eval e1 env / eval e2 env
  
(* 30 + 6 * 2 *)
let e1 = Add(CstI(30),
             Mult(CstI(6), CstI(2)))
(* 3 + 4 + 5 + 6 *)
let e2 = Add(Add(Add(CstI(3), CstI(4)),
                 CstI(5)),
             CstI(6))

(* 5 * 2 / 3 *)
let e3 = Div(Mult(CstI(5), CstI(2)),
             CstI(3))

(* 5 - 2 - 3 *)
let e4 = Subt(Subt(CstI(5), CstI(2)),
              CstI(3))

(* a - 2 - b *)
let e4 = Subt(Subt(Var("a"),
                   CstI(2)),
              Var("b"))
              
