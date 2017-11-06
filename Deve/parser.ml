(* parseExp: token list -> (exp, token list) 
   Parses an exp out of the given token list,
   returns that exp together with the unconsumed tokens.
 *)
let rec parseExp tokens =
  match tokens with
  | INT i :: rest -> (CstI i, rest)
  | NAME x :: rest -> (Var x, rest)
  | LET::(NAME x)::EQUALS::rest ->
     (match parseExp rest with
      | (e1, IN::rest1) -> let (e2, rest2) = parseExp rest1
                           in (LetIn(x, e1, e2), rest2)
      | (e1, _) -> failwith "I was expecting to see an IN."
     )

(* parseMain: token list -> exp *)
let parseMain tokens =
  match parseExp tokens with
  | (e, [EOF]) -> e
  | _ -> failwith "I was expecting to see an EOF."

(* parse: string -> exp *)
let rec parse s =
  parseMain (scan s)
