type exp = CstI of int
         | Add of exp * exp
         | Mult of exp * exp
         | Subt of exp * exp
         | Div of exp * exp


(* eval: exp -> int *)                          
let rec eval e =
  match e with
  | CstI i -> i
  | Add(e1, e2)  -> eval e1 + eval e2
  | Mult(e1, e2) -> eval e1 * eval e2
  | Subt(e1, e2) -> eval e1 - eval e2
  | Div(e1, e2)  -> eval e1 / eval e2

  
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
              
