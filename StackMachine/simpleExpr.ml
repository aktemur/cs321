type expr = CstI of int
          | Prim of string * expr * expr

(* eval: expr -> int *)
let rec eval e =
  match e with
  | CstI i -> i
  | Prim(op, e1, e2) ->
     let (i1, i2) = (eval e1, eval e2) in
     (match op with
      | "+" -> i1 + i2
      | "-" -> i1 - i2
      | "*" -> i1 * i2
      | "/" -> i1 / i2
      | _ -> failwith "Unrecognized operator."
     )

(* compile: expr -> (stackInstruction list) *)
let rec compile e =
  match e with
  | CstI i -> [Int i]
  | Prim(op, e1, e2) ->
     let opCode =
       match op with
       | "+" -> Add
       | "-" -> Subt
       | "*" -> Mult
       | "/" -> Divide
     in (compile e1)@(compile e2)@[opCode]


(* 4 + 5 *)                                                 
let e0 = Prim("+", CstI 4, CstI 5)

(* (4+5)-(2*5) *)                                    
let e1 = Prim("-", Prim("+", CstI 4, CstI 5),
               Prim("*", CstI 2, CstI 5))

(* 4 - 5 * 2 *)
let e2 = Prim("-", CstI 4, Prim("*", CstI 5, CstI 2))

(* 15 - 6 - 3 - 4 *)
let e3 = Prim("-", 
             Prim("-", 
                 Prim("-", CstI 15, CstI 6),
                 CstI 3),
             CstI 4)

(* 15 - (6 - (3 - 4)) *)
let e4 = Prim("-", CstI 15,
               Prim("-", CstI 6,
                     Prim("-", CstI 3, CstI 4)))


              
