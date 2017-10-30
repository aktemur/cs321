type exp = CstI of int
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

(* let a = 5 in a + 4 *)
let e5 = LetIn("a", CstI 5, Add(Var "a", CstI 4))

(* let x = 7
   in let s = x * x
      in let q = s * s
         in q * q
*)
let e6 = LetIn("x", CstI 7,
               LetIn("s", Mult(Var "x", Var "x"),
                     LetIn("q", Mult(Var "s", Var "s"),
                           Mult(Var "q", Var "q"))))
(* let a = 3
   in let b = 3
      in let c = 5
         in 7 * a - 9 / b + c
*)
let e7 = LetIn("a", CstI 3,
               LetIn("b", CstI 3,
                     LetIn("c", CstI 5,
                           Add(Subt(Mult(CstI 7, Var "a"),
                                    Div(CstI 9, Var "b")),
                               Var "c"))))
;;

(* (let c = 3 in c + c) + (let c = 5 in c * c) *)
let e8 = Add(LetIn("c", CstI 3, Add(Var "c", Var "c")),
             LetIn("c", CstI 5, Mult(Var "c", Var "c")))
;;

(* let a = 5
   in (let b = 3 in a + b) + (let b = 9 in a * b) *)
let e9 = LetIn("a", CstI 5,
               Add(LetIn("b", CstI 3, Add(Var "a", Var "b")),
                   LetIn("b", CstI 9, Mult(Var "a", Var "b"))))
(* let x =
       let a = 5
       in let b = 8
          in a + b
   in x * 2
*)
let e10 = LetIn("x", LetIn("a", CstI 5,
                           LetIn("b", CstI 8,
                                 Add(Var "a", Var "b"))),
                Mult(Var "x", CstI 2))
;;
              
(* let x = 4
   in if x + 1 >= 0 then 42 else x * 8
 *)
let e11 = LetIn("x", CstI 4,
                If(GreaterOrEq(Add(Var "x", CstI 1), CstI 0),
                   CstI 42,
                   Mult(Var "x", CstI 8)))
;; (* EXPECTED: 42 *)

(* let x = 4
   in if x < 4 then 42 else x + 8
 *)
let e12 = LetIn("x", CstI 4,
                If(Less(Var "x", CstI 4),
                   CstI 42,
                   Add(Var "x", CstI 8)))
;; (* EXPECTED: 12 *)
