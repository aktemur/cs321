type expr = CstI of int
          | Plus of expr * expr
          | Star of expr * expr
          | Minus of expr * expr
          | Slash of expr * expr

(* eval: expr -> int *)
let rec eval e =
  match e with
  | CstI i -> i
  | Plus(e1, e2) -> eval e1 + eval e2
  | Minus(e1, e2) -> eval e1 - eval e2
  | Star(e1, e2) -> eval e1 * eval e2
  | Slash(e1, e2) -> eval e1 / eval e2

(* compile: expr -> (stackInstruction list) *)
let rec compile e =
  match e with
  | CstI i -> [Int i]
  | Plus(e1, e2)  -> (compile e1)@(compile e2)@[Add]
  | Minus(e1, e2) -> (compile e1)@(compile e2)@[Subt]
  | Star(e1, e2)  -> (compile e1)@(compile e2)@[Mult]
  | Slash(e1, e2) -> (compile e1)@(compile e2)@[Divide]


(* 4 + 5 *)                                                 
let e0 = Plus(CstI 4, CstI 5)

(* (4+5)-(2*5) *)                                    
let e1 = Minus(Plus(CstI 4, CstI 5),
               Star(CstI 2, CstI 5))

(* 4 - 5 * 2 *)
let e2 = Minus(CstI 4, Star(CstI 5, CstI 2))

(* 15 - 6 - 3 - 4 *)
let e3 = Minus(
             Minus(
                 Minus(CstI 15, CstI 6),
                 CstI 3),
             CstI 4)

(* 15 - (6 - (3 - 4)) *)
let e4 = Minus(CstI 15,
               Minus(CstI 6,
                     Minus(CstI 3, CstI 4)))


              
