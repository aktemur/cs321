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
         | CstB of bool
         | Prim of string * exp * exp
         | Unary of string * exp
         | Var of string
         | Let of string * exp * exp
         | LetFun of string * string * exp * exp
         | If of exp * exp * exp
         | Call of string * exp

type value = Int of int
           | Bool of bool
           | Pair of value * value
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
    | Unary("not", e1) -> match eval e1 env with
                          | Bool b -> Bool (not b)
                          | _ -> failwith "Boolean negation needs a bool value."
    | Unary("fst", e1) -> match eval e1 env with
                          | Pair(v1, v2) -> v1
                          | _ -> failwith "fst needs a pair of values."
    | Unary("snd", e1) -> match eval e1 env with
                          | Pair(v1, v2) -> v2
                          | _ -> failwith "snd needs a pair of values."
    | Unary(_, e1) -> failwith "Unary operator not recognized."
    | Prim("(,)", e1, e2) -> Pair(eval e1 env, eval e2 env)
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
    | Prim(_, e1, e2) -> failwith "Prim operator not recognized."
    | If(e1,e2,e3) -> match eval e1 env with
                      | Bool(true) -> eval e2 env
                      | Bool(false) -> eval e3 env
                      | _ -> failwith "If's condition must be a bool." 
    | Let(x, e1, e2) -> let v = eval e1 env
                        let env' = (x, v)::env
                        eval e2 env'    
    | LetFun(f, x, e1, e2) -> let clos = Closure(f, x, e1, env)
                              let env' = (f, clos)::env
                              eval e2 env'
    | Call(f, e1) -> match lookup f env with
                     | Closure(f,x,eBody,fEnv) ->
                         let argument = eval e1 env
                         let env' = (f, Closure(f,x,eBody,fEnv))::(x, argument)::fEnv
                         eval eBody env'
                     | _ -> failwith "Must get Closure in function call."


        
