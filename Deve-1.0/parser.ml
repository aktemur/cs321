(* A helper function to convert a token to a string *)
let toString tok =
  match tok with
  | INT i -> "INT(" ^ string_of_int i ^ ")"
  | BOOL b -> "BOOL(" ^ string_of_bool b ^ ")"
  | NAME x -> "NAME(\"" ^ x ^ "\")"
  | PLUS -> "PLUS"
  | STAR -> "STAR"
  | MINUS -> "MINUS"
  | SLASH -> "SLASH"
  | LET -> "LET"
  | EQUALS -> "EQUALS"
  | IN -> "IN"
  | IF -> "IF"
  | THEN -> "THEN"
  | ELSE -> "ELSE"
  | ERROR c -> "ERROR('" ^ (charToString c) ^ "')"
  | EOF -> "EOF"

(* consume: token -> token list -> token list
   Enforces that the given token list's head is the given token;
   returns the tail.
*)
let consume tok tokens =
  match tokens with
  | [] -> failwith ("I was expecting to see a " ^ (toString tok))
  | t::rest when t = tok -> rest
  | t::rest -> failwith ("I was expecting a " ^ (toString tok) ^
                         ", but I found a " ^ toString(t))

(* parseExp: token list -> (exp, token list) 
   Parses an exp out of the given token list,
   returns that exp together with the unconsumed tokens.
 *)
let rec parseExp tokens =
  parseLevel1Exp tokens

and parseLevel1Exp tokens =
  parseLETorIForOther parseLevel2Exp tokens

and parseLETorIForOther otherParseFun tokens =
  match tokens with
  | LET::rest -> let (e, tokens2) = parseLetIn tokens
                 in (e, tokens2)
  | IF::rest  -> let (e, tokens2) = parseIfThenElse tokens
                 in (e, tokens2)
  | _         -> let (e, tokens2) = otherParseFun tokens
                 in (e, tokens2)

and parseLetIn tokens =
  match tokens with
  | LET::NAME(x)::EQUALS::rest ->
     let (e1, tokens1) = parseExp rest in
     let tokens2 = consume IN tokens1 in
     let (e2, tokens3) = parseExp tokens2 in
     (LetIn(x, e1, e2), tokens3)
  | _ -> failwith "Should not be possible."

and parseIfThenElse tokens =
  let rest = consume IF tokens in
  let (e1, tokens1) = parseExp rest in
  let tokens2 = consume THEN tokens1 in
  let (e2, tokens3) = parseExp tokens2 in
  let tokens4 = consume ELSE tokens3 in
  let (e3, tokens5) = parseExp tokens4 in
  (If(e1, e2, e3), tokens5)
  
and parseLevel2Exp tokens =
  let rec helper tokens e1 =
    match tokens with
    | PLUS::rest ->
       let (e2, tokens2) = parseLETorIForOther parseLevel3Exp rest
       in helper tokens2 (Add(e1, e2))
    | MINUS::rest ->
       let (e2, tokens2) = parseLETorIForOther parseLevel3Exp rest
       in helper tokens2 (Subt(e1, e2))
    | _ -> (e1, tokens)
  in let (e1, tokens1) = parseLevel3Exp tokens in
     helper tokens1 e1

and parseLevel3Exp tokens =
  let rec helper tokens e1 =
    match tokens with
    | STAR::rest ->
       let (e2, tokens2) = parseLETorIForOther parseLevel4Exp rest
       in helper tokens2 (Mult(e1, e2))
    | SLASH::rest ->
       let (e2, tokens2) = parseLETorIForOther parseLevel4Exp rest
       in helper tokens2 (Div(e1, e2))
    | _ -> (e1, tokens)
  in let (e1, tokens1) = parseLevel4Exp tokens in
     helper tokens1 e1

and parseLevel4Exp tokens =
  match tokens with
  | INT i :: rest -> (CstI i, rest)
  | NAME x :: rest -> (Var x, rest)
  | BOOL b :: rest -> (CstB b, rest)
  | t::rest -> failwith ("Unsupported token: " ^ toString(t))
  | [] -> failwith "No more tokens???"

(* parseMain: token list -> exp *)
let parseMain tokens =
  let (e, tokens1) = parseExp tokens in
  let tokens2 = consume EOF tokens1 in
  if tokens2 = [] then e
  else failwith "Oops."

(* parse: string -> exp *)
let rec parse s =
  parseMain (scan s)
