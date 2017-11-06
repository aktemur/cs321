(* parseExp: token list -> (exp, token list) 
   Parses an exp out of the given token list,
   returns that exp together with the unconsumed tokens.
 *)
let parseExp tokens =
  match tokens with
  | INT i :: rest -> (CstI i, rest)
  | NAME x :: rest -> (Var x, rest)

(* parseMain: token list -> exp *)
let parseMain tokens =
  match parseExp tokens with
  | (e, [EOF]) -> e
  | _ -> failwith "I was expecting to see an EOF."

(* parse: string -> exp *)
let rec parse s =
  parseMain (scan s)
