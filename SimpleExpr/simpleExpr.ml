type expr = CstI of int
          | Var of string
          | Plus of expr * expr
          | Star of expr * expr
          | Minus of expr * expr
          | Slash of expr * expr
          | Let of string * expr * expr

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
  | Plus(e1, e2) -> eval e1 env + eval e2 env
  | Minus(e1, e2) -> eval e1 env - eval e2 env
  | Star(e1, e2) -> eval e1 env * eval e2 env
  | Slash(e1, e2) -> eval e1 env / eval e2 env
  | Let(x, e1, e2) -> let i = eval e1 env in
                      let newEnv = (x, i)::env in
                      eval e2 newEnv

let e1 = Minus(Plus(CstI 4, Var "a"), CstI 5)

let e2 = Minus(Slash(Star(Var "x", CstI 30),
                     Var "w"),
               Var "k")
let e3 = Let("a",
             Plus(CstI 30, CstI 5),
             Plus(Var "a", CstI 12))

let e4 = Let("a", CstI 30,
             Let("b", CstI 12,
                 Plus(Var "a",
                      Plus(Var "b", CstI 3))))
