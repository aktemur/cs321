module Exp

(* To run in fsharpi:

> #load "exp.fs";;
...
> #load "exp-examples.fs";;
...
> open Exp;;
> open ExpExamples;;

> eval example1 [];;
val it : int = 42
> eval example4 initialEnv;;
val it : int = 21

*)

type exp = CstI of int
         | Prim of string * exp * exp
         | Var of string

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
    | Prim(_, e1, e2) -> failwith "Operator no recognized."
    
            
