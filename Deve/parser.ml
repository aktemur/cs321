(* parseExp: token list -> (exp, token list) 
   Parses an exp out of the iven token list,
   returns that exp together with the unconsumed tokens.
 *)
let parseExp tokens =
  match tokens with
  | INT i :: rest -> (CstI i, rest)
  | NAME x :: rest -> (Var x, rest)

(* parse: string -> exp *)
let rec parse s =
  let tokens = scan s in
  match parseExp tokens with
  | (e, [EOF]) -> e
  | _ -> failwith "I was expecting to see an EOF."
