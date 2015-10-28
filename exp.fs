module Exp

(* To run, do in the terminal:

$ make

This will compile the files and start an fsharpi
session with necessary files loaded.

In the fsharpi prompt:

> open ExpExamples;;
> tokenize "17 + let x = 5 in x * x end";;
val it : Parser.token list =
  [CSTINT 17; PLUS; LET; NAME "x"; EQ; CSTINT 5; IN; NAME "x"; TIMES; NAME "x";
   END; EOF]
> fromString "17 + let x = 5 in x * x end";;
val it : Exp.exp =
  Prim ("+",CstI 17,Let ("x",CstI 5,Prim ("*",Var "x",Var "x")))
> run "17 + let x = 5 in x * x end";;       
val it : int = 42

*)

type exp = CstI of int
         | Prim of string * exp * exp
         | Var of string
         | Let of string * exp * exp
         | If of exp * exp * exp

let rec lookup x env =
    match env with
    | [] -> failwith ("Name " + x + " not found!!!")
    | (y, v)::env' -> if x = y then v
                      else lookup x env'

let rec eval e env =
    match e with
    | CstI i -> i
    | Var x -> lookup x env 
    | Prim("+", e1, e2) -> eval e1 env + eval e2 env
    | Prim("-", e1, e2) -> eval e1 env - eval e2 env
    | Prim("*", e1, e2) -> eval e1 env * eval e2 env
    | Prim("/", e1, e2) -> let v1, v2 = eval e1 env, eval e2 env
                           if v2 = 0 then failwith "You gave me a ZERO!!!"
                           else v1 / v2
    | Prim("min", e1, e2) -> min (eval e1 env) (eval e2 env)
    | Prim("max", e1, e2) -> max (eval e1 env) (eval e2 env)
    | Prim("=", e1, e2) -> let v1, v2 = eval e1 env, eval e2 env
                           if v1 = v2 then 1 else 0
    | Prim(">", e1, e2) -> let v1, v2 = eval e1 env, eval e2 env
                           if v1 > v2 then 1 else 0
    | Prim(_, e1, e2) -> failwith "Operator no recognized."
    | Let(x, e1, e2) -> let v = eval e1 env
                        let env' = (x, v)::env
                        eval e2 env'    
    | If(e1, e2, e3) -> if (eval e1 env) = 1
                        then eval e2 env
                        else eval e3 env

let rec simplify e =
  match e with
  | CstI i -> CstI i
  | Var x -> Var x
  | Prim("+",e1,e2) -> match (simplify e1, simplify e2) with
                       | CstI 0, e2' -> e2'
                       | e1', CstI 0 -> e1'
                       | e1',e2' -> Prim("+",e1',e2')
  | Prim("-",e1,e2) -> match (simplify e1, simplify e2) with
                       | e1', CstI 0 -> e1'
                       | e1',e2' when e1'=e2' -> CstI 0
                       | e1',e2' -> Prim("-",e1',e2')
  | Prim("*",e1,e2) -> match (simplify e1, simplify e2) with
                       | CstI 0, e2' -> CstI 0
                       | e1', CstI 0 -> CstI 0
                       | CstI 1, e2' -> e2'
                       | e1', CstI 1 -> e1'
                       | e1',e2' -> Prim("*",e1',e2')
  | Prim("/",e1,e2) -> Prim("/", simplify e1, simplify e2)
  | Prim("min",e1,e2) -> Prim("min", simplify e1, simplify e2)
  | Prim("max",e1,e2) -> Prim("max", simplify e1, simplify e2)
  | Prim("=",e1,e2) -> Prim("=", simplify e1, simplify e2)
  | Prim(">",e1,e2) -> Prim(">", simplify e1, simplify e2)
  | Prim(_,e1,e2) -> failwith "simplify: unknown prim op."
  | If(e1,e2,e3) -> If(simplify e1, simplify e2, simplify e3)
  | Let(x, e1, e2) -> Let(x, simplify e1, simplify e2)
