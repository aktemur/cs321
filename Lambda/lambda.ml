type expr = Var of string
          | App of expr * expr
          | Lambda of string * expr

let rec isReducible e =
  match e with
  | Var x -> false
  | App(Lambda(x, e1), e2) -> true
  | App(e1, e2) -> isReducible e1 || isReducible e2
  | Lambda(x, e1) -> isReducible e1

(* subst x e2 e1: Substitute occurrences of 'x' with e2 in e1. *)
let rec subst x e2 e1 =
  match e1 with
  | Var y -> if x = y then e2 else Var y
  | App(e1', e2') -> App(subst x e2 e1', subst x e2 e2')
  | Lambda(y, e1') -> if x = y then Lambda(y, e1')
                      else Lambda(y, subst x e2 e1')
  
(* reduce: Apply beta-reduction on the given expression *)
let rec reduce e =
  match e with
  | Var x -> Var x
  | App(Lambda(x,e1), e2) -> subst x e2 e1
  | App(e1, e2) -> App(reduce e1, reduce e2)
  | Lambda(x, e1) -> Lambda(x, reduce e1)

(* eval: Reduce the given expression as much as possible,
   until we reach the normal form.
   If there is no normal form, eval will not terminate.
   E.g. try "omega": parse "(\x.x x)(\x.x x)"
*)
let rec eval e =
  if isReducible e then
    eval (reduce e)
  else e

(* str: Convert the given expression to string *)
let rec str e =
  match e with
  | Var x -> x
  | App(e1, e2) -> "(" ^ str e1 ^ " " ^ str e2 ^ ")"
  | Lambda(x, e1) -> "(lambda " ^ x ^ "." ^ str e1 ^ ")"
