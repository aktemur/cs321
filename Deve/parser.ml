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
  match tokens with
  | LET::rest -> parseLetIn tokens
  | IF::rest -> parseIfThenElse tokens
  | _ -> parseLevel2Exp tokens

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
    | PLUS::tok::rest ->
       (match tok with
        | LET -> let (e2, tokens2) = parseLetIn (tok::rest)
                 in (Binary("+", e1, e2), tokens2)
        | IF  -> let (e2, tokens2) = parseIfThenElse (tok::rest)
                 in (Binary("+", e1, e2), tokens2)
        | t   -> let (e2, tokens2) = parseLevel3Exp (tok::rest)
                 in helper tokens2 (Binary("+", e1, e2))
       )
    | MINUS::tok::rest ->
       (match tok with
        | LET -> let (e2, tokens2) = parseLetIn (tok::rest)
                 in (Binary("-", e1, e2), tokens2)
        | IF  -> let (e2, tokens2) = parseIfThenElse (tok::rest)
                 in (Binary("-", e1, e2), tokens2)
        | t   -> let (e2, tokens2) = parseLevel3Exp (tok::rest)
                 in helper tokens2 (Binary("-", e1, e2))
       )
    | _ -> (e1, tokens)
  in let (e1, tokens1) = parseLevel3Exp tokens in
     helper tokens1 e1

and parseLevel3Exp tokens =
  let rec helper tokens e1 =
    match tokens with
    | STAR::tok::rest ->
       (match tok with
        | LET -> let (e2, tokens2) = parseLetIn (tok::rest)
                 in (Binary("*", e1, e2), tokens2)
        | IF  -> let (e2, tokens2) = parseIfThenElse (tok::rest)
                 in (Binary("*", e1, e2), tokens2)
        | t   -> let (e2, tokens2) = parseLevel4Exp (tok::rest)
                 in helper tokens2 (Binary("*", e1, e2))
       )
    | SLASH::tok::rest ->
       (match tok with
        | LET -> let (e2, tokens2) = parseLetIn (tok::rest)
                 in (Binary("/", e1, e2), tokens2)
        | IF  -> let (e2, tokens2) = parseIfThenElse (tok::rest)
                 in (Binary("/", e1, e2), tokens2)
        | t   -> let (e2, tokens2) = parseLevel4Exp (tok::rest)
                 in helper tokens2 (Binary("/", e1, e2))
       )
    | _ -> (e1, tokens)
  in let (e1, tokens1) = parseLevel4Exp tokens in
     helper tokens1 e1

and parseLevel4Exp tokens =
  match tokens with
  | INT i :: rest -> (CstI i, rest)
  | NAME x :: rest -> (Var x, rest)
  | BOOL b :: rest -> (CstB b, rest)
  | LPAR::rest ->
     let (e, tokens1) = parseExp rest in
     let rest1 = consume RPAR tokens1 in
     (e, rest1)
  | t::rest -> failwith ("Unsupported token: " ^ toString(t))

(* parseMain: token list -> exp *)
let parseMain tokens =
  let (e, tokens1) = parseExp tokens in
  let tokens2 = consume EOF tokens1 in
  if tokens2 = [] then e
  else failwith "Oops."

(* parse: string -> exp *)
let rec parse s =
  parseMain (scan s)
