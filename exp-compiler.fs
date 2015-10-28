module ExpCompiler

open Exp
open Stack

let rec compile e =
    match e with
    | CstI i -> [RInt i]
    | Var x -> failwith "Var's cannot be compiled."       
    | Prim(op, e1, e2) ->
        let opSymbol = match op with
                       | "+" -> RPlus
                       | "*" -> RStar
                       | "/" -> RDiv
                       | "-" -> RMinus            
                       | "min" -> RMin
                       | "max" -> RMax
                       | "=" -> REq
                       | ">" -> RGreater
        compile e1 @ compile e2 @ [opSymbol]
    | Let(x, e1, e2) -> failwith "Let-in cannot be compiled."
