module Exp

(* To run, do in the terminal:

$ make

This will compile the files and start an fsharpi
session with necessary files loaded.

In the fsharpi prompt:

> open ExpExamples;;
> open Exp;;
> tokenize "17 + let x = 5 in x * x end";;
val it : Parser.token list =
  [CSTINT 17; PLUS; LET; NAME "x"; EQ; CSTINT 5; IN; NAME "x"; TIMES; NAME "x";
   END; EOF]
> fromString "17 + let x = 5 in x * x end";;
val it : Exp.exp =
  Prim ("+",CstI 17,Let ("x",CstI 5,Prim ("*",Var "x",Var "x")))
> run "17 + let x = 5 in x * x end";;       
val it : int = 42

> typeOf (fromString "4 + 6") [];;
val it : typ = TypI
> typeOf (fromString typeEx1) [];;
val it : typ = TypI
> typeOf (fromString typeEx2) [];;
val it : typ = TypI
> typeOf (fromString typeEx3) [];;
val it : typ = TypB
> typeOf (fromString typeEx4) [];;
val it : typ = TypF (TypI,TypB)
*)

type typ = TypI
         | TypB
         | TypF of typ * typ

type exp = CstI of int
         | CstB of bool
         | Prim of string * exp * exp
         | Var of string
         | Let of string * exp * exp
         | LetFun of string * string * typ * typ * exp * exp
         | If of exp * exp * exp
         | Call of string * exp

type value = Int of int
           | Bool of bool
           | Closure of string * string * exp * ((string * value) list)

let rec lookup x env =
    match env with
    | [] -> failwith ("Name " + x + " not found!!!")
    | (y, v)::env' -> if x = y then v
                      else lookup x env'

let rec eval e env =
    match e with
    | CstI i -> Int(i)
    | CstB b -> Bool(b)
    | Var x -> lookup x env
    | Prim("+", e1, e2) -> match eval e1 env, eval e2 env with
                           | Int(i1), Int(i2) -> Int(i1+i2)
                           | _,_ -> failwith "Need an integer for +."
    | Prim("-", e1, e2) -> match eval e1 env, eval e2 env with
                           | Int(i1), Int(i2) -> Int(i1-i2)
                           | _,_ -> failwith "Need an integer for -."
    | Prim("*", e1, e2) -> match eval e1 env, eval e2 env with
                           | Int(i1), Int(i2) -> Int(i1*i2)
                           | _,_ -> failwith "Need an integer for *."
    | Prim("/", e1, e2) -> match eval e1 env, eval e2 env with
                           | Int(i1), Int(i2) -> Int(i1/i2)
                           | _,_ -> failwith "Need an integer for /."
    | Prim("minimum", e1, e2) -> match eval e1 env, eval e2 env with
                                 | Int(i1), Int(i2) -> Int(min i1 i2)
                                 | _,_ -> failwith "Need an integer for min."
    | Prim("<", e1, e2) -> match eval e1 env, eval e2 env with
                           | Int(i1), Int(i2) -> Bool(i1 < i2)
                           | _,_ -> failwith "Need an integer for <."
    | Prim("&&", e1, e2) -> match eval e1 env with
                            | Bool(false) -> Bool(false)
                            | Bool(b1) -> match eval e2 env with
                                          | Bool(b2) -> Bool(b2)
                                          | _ -> failwith "Need a boolean for &&."
                            | _ -> failwith "Need a boolean for &&."
    | Prim("||", e1, e2) -> match eval e1 env with
                            | Bool(true) -> Bool(true)
                            | Bool(b1) -> match eval e2 env with
                                          | Bool(b2) -> Bool(b2)
                                          | _ -> failwith "Need a boolean for ||."
                            | _ -> failwith "Need a boolean for ||."
    | Prim(_, e1, e2) -> failwith "Operator no recognized."
    | If(e1,e2,e3) -> match eval e1 env with
                      | Bool(true) -> eval e2 env
                      | Bool(false) -> eval e3 env
                      | _ -> failwith "If's condition must be a bool." 
    | Let(x, e1, e2) -> let v = eval e1 env
                        let env' = (x, v)::env
                        eval e2 env'    
    | LetFun(f, x, tx, tf, e1, e2) ->
                        let clos = Closure(f, x, e1, env)
                        let env' = (f, clos)::env
                        eval e2 env'
    | Call(f, e1) -> match lookup f env with
                     | Closure(f,x,eBody,fEnv) ->
                         let argument = eval e1 env
                         let env' = (f, Closure(f,x,eBody,fEnv))::(x, argument)::fEnv
                         eval eBody env'
                     | _ -> failwith "Must get Closure in function call."


        
let rec typeOf e env =
    match e with
    | CstI i -> TypI
    | CstB b -> TypB
    | Var x -> lookup x env
    | Prim("+", e1, e2) -> match typeOf e1 env, typeOf e2 env with
                           | TypI, TypI -> TypI
                           | _,_ -> failwith "int + int !!!"
    | Prim("-", e1, e2) -> match typeOf e1 env, typeOf e2 env with
                           | TypI, TypI -> TypI
                           | _,_ -> failwith "int - int !!!"
    | Prim("*", e1, e2) -> match typeOf e1 env, typeOf e2 env with
                           | TypI, TypI -> TypI
                           | _,_ -> failwith "int * int !!!"
    | Prim("/", e1, e2) -> match typeOf e1 env, typeOf e2 env with
                           | TypI, TypI -> TypI
                           | _,_ -> failwith "int / int !!!"
    | Prim("minimum", e1, e2) -> match typeOf e1 env, typeOf e2 env with
                                 | TypI, TypI -> TypI
                                 | _,_ -> failwith "min(int,int) !!!"
    | Prim("<", e1, e2) -> match typeOf e1 env, typeOf e2 env with
                           | TypI, TypI -> TypB
                           | _,_ -> failwith "int < int !!!"
    | Prim("&&", e1, e2) -> match typeOf e1 env, typeOf e2 env with
                            | TypB, TypB -> TypB
                            | _,_ -> failwith "bool && bool !!!"
    | Prim("||", e1, e2) -> match typeOf e1 env, typeOf e2 env with
                            | TypB, TypB -> TypB
                            | _,_ -> failwith "bool || bool !!!"
    | Prim(_, e1, e2) -> failwith "Operator no recognized."

    | If(e1,e2,e3) -> match typeOf e1 env, typeOf e2 env, typeOf e3 env with
                      | TypB, t2, t3 -> if t2 = t3 then t2
                                        else failwith "If-branches must agree"
                      | _,_,_ -> failwith "If-cond must be a bool"
    | Let(x, e1, e2) -> let tr = typeOf e1 env
                        let env' = (x, tr)::env
                        typeOf e2 env'
    | LetFun(f, x, tx, tr, e1, e2) ->
        let t1 = typeOf e1 ((f,TypF(tx,tr))::(x, tx)::env)
        if t1 = tr then
            let t = typeOf e2 ((f,TypF(tx,tr))::env)
            t
        else
            failwith "tx and tr must have been the same"
    | Call(f, e1) ->
        match lookup f env with
        | TypF(tx,tr) -> let t1 = typeOf e1 env
                         if t1 = tx then tr
                         else failwith "Argument type and input type must match"
        | _ -> failwith "f must be a function."
