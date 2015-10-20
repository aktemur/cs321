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
    | Prim("minimum", e1, e2) -> let v1, v2 = (eval e1 env), (eval e2 env)
                                 if v1 < v2 then v1 else v2
    | Prim("<", e1, e2) -> let v1, v2 = (eval e1 env), (eval e2 env)
                           if v1 < v2 then 1 else 0
    | Prim(_, e1, e2) -> failwith "Operator no recognized."
    | If(e1,e2,e3) -> if (eval e1 env) = 0 then eval e3 env else eval e2 env
    | Let(x, e1, e2) -> let v = eval e1 env
                        let env' = (x, v)::env
                        eval e2 env'    
