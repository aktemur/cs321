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
  | LESS -> "LESS"
  | LESSEQ -> "LESSEQ"
  | GREATEREQ -> "GREATEREQ"
  | LPAR -> "LPAR"
  | RPAR -> "RPAR"
  | COMMA -> "COMMA"
  | MATCH -> "MATCH"
  | WITH -> "WITH"
  | ARROW -> "ARROW"
  | FUN -> "FUN"
  | REC -> "REC"
  | INTTY -> "INTTY"
  | BOOLTY -> "BOOLTY"
  | COLON -> "COLON"

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

(* parseType: token list -> (typ * token list) *)
let rec parseType tokens =
  parseLevel1Type tokens

and parseLevel1Type tokens = (* function types. e.g. int -> bool -> int *)
  let (t1, tokens1) = parseLevel2Type tokens in
  match tokens1 with
  | ARROW::rest ->
     let (t2, tokens2) = parseLevel1Type rest in
     (FunTy(t1, t2), tokens2)
  | _ -> (t1, tokens1)

and parseLevel2Type tokens = (* pair types. e.g int * bool *)
  let (t1, tokens1) = parseLevel3Type tokens in
  match tokens1 with
  | STAR::rest -> 
     let (t2, tokens2) = parseLevel3Type rest in
     (PairTy(t1, t2), tokens2)
  | _ -> (t1, tokens1)

and parseLevel3Type tokens = (* ground types (i.e. int, bool) and parenthesized types *)
  match tokens with
  | INTTY::rest -> (IntTy, rest)
  | BOOLTY::rest -> (BoolTy, rest)
  | LPAR::rest ->
     let (t, tokens1) = parseType rest in
     let tokens2 = consume RPAR tokens1 in
     (t, tokens2)
  | t::_ -> failwith ("Unsupported token " ^ toString(t) ^ " while parsing a type.")
  | [] -> failwith ("No more tokens, while parsing a type???")

(* parseParam: token list -> ((string * typ) * token list) *)
let rec parseParam tokens =
  let rest = consume LPAR tokens in
  match rest with
  | NAME(x)::COLON::rest2 ->
     let (t, tokens1) = parseType rest2 in
     let tokens2 = consume RPAR tokens1 in
     ((x, t), tokens2)
  | _ -> failwith "Badly formed parameter."

(* parseExp: token list -> (exp, token list) 
   Parses an exp out of the given token list,
   returns that exp together with the unconsumed tokens.
 *)
let rec parseExp tokens =
  parseLevel1ExpOrOther parseLevel1_5Exp tokens

and parseLevel1ExpOrOther otherParseFun tokens =
  match tokens with
  | LET::rest -> let (e, tokens2) = parseLetIn tokens
                 in (e, tokens2)
  | IF::rest  -> let (e, tokens2) = parseIfThenElse tokens
                 in (e, tokens2)
  | MATCH::rest -> let (e, tokens2) = parseMatchPair tokens
                   in (e, tokens2)
  | FUN::rest -> let (e, tokens2) = parseFun tokens
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
  | LET::NAME(f)::rest ->
     let (param, tokens0) = parseParam rest in
     let rest2 = consume EQUALS tokens0 in
     let (e1, tokens1) = parseExp rest2 in
     let tokens2 = consume IN tokens1 in
     let (e2, tokens3) = parseExp tokens2 in
     (LetIn(f, Fun(param, e1), e2), tokens3)
  | LET::REC::NAME(f)::rest ->
     let (param, tokens0) = parseParam rest in
     let rest2 = consume COLON tokens0 in
     let (retTy, tokens1) = parseType rest2 in
     let rest3 = consume EQUALS tokens1 in
     let (e1, tokens2) = parseExp rest3 in
     let rest4 = consume IN tokens2 in
     let (e2, tokens4) = parseExp rest4 in
     (LetRec(f, param, retTy, e1, e2), tokens4)
  | _ -> failwith "Badly formed let expression"  

and parseIfThenElse tokens =
  let rest = consume IF tokens in
  let (e1, tokens1) = parseExp rest in
  let tokens2 = consume THEN tokens1 in
  let (e2, tokens3) = parseExp tokens2 in
  let tokens4 = consume ELSE tokens3 in
  let (e3, tokens5) = parseExp tokens4 in
  (If(e1, e2, e3), tokens5)
  
and parseMatchPair tokens =
  let rest = consume MATCH tokens in
  let (e1, tokens1) = parseExp rest in
  match tokens1 with
  | WITH::LPAR::NAME(x)::COMMA::NAME(y)::RPAR::ARROW::rest1 ->
     let (e2, tokens2) = parseExp rest1 in
     (MatchPair(e1, x, y, e2), tokens2)
  | _ -> failwith "Badly formed match expression."

and parseFun tokens =
  match tokens with
  | FUN::tokens0 ->
     let (param, rest) = parseParam tokens0 in
     let rest2 = consume ARROW rest in
     let (e, tokens1) = parseExp rest2 in
     (Fun(param, e), tokens1)
  | _ -> failwith "Badly formed fun definition."

and parseLevel1_5Exp tokens =
  let rec helper tokens e1 =
    match tokens with
    | LESS::rest ->
       let (e2, tokens2) = parseLevel1ExpOrOther parseLevel2Exp rest
       in helper tokens2 (Binary("<", e1, e2))
    | LESSEQ::rest ->
       let (e2, tokens2) = parseLevel1ExpOrOther parseLevel2Exp rest
       in helper tokens2 (Binary("<=", e1, e2))
    | GREATEREQ::rest ->
       let (e2, tokens2) = parseLevel1ExpOrOther parseLevel2Exp rest
       in helper tokens2 (If(Binary("<", e1, e2), CstB false, CstB true))
    | _ -> (e1, tokens)
  in let (e1, tokens1) = parseLevel2Exp tokens in
     helper tokens1 e1

and parseLevel2Exp tokens =
  let rec helper tokens e1 =
    match tokens with
    | PLUS::rest ->
       let (e2, tokens2) = parseLevel1ExpOrOther parseLevel3Exp rest
       in helper tokens2 (Binary("+", e1, e2))
    | MINUS::rest ->
       let (e2, tokens2) = parseLevel1ExpOrOther parseLevel3Exp rest
       in helper tokens2 (Binary("-", e1, e2))
    | _ -> (e1, tokens)
  in let (e1, tokens1) = parseLevel3Exp tokens in
     helper tokens1 e1

and parseLevel3Exp tokens =
  let rec helper tokens e1 =
    match tokens with
    | STAR::rest ->
       let (e2, tokens2) = parseLevel1ExpOrOther parseLevel4Exp rest
       in helper tokens2 (Binary("*", e1, e2))
    | SLASH::rest ->
       let (e2, tokens2) = parseLevel1ExpOrOther parseLevel4Exp rest
       in helper tokens2 (Binary("/", e1, e2))
    | _ -> (e1, tokens)
  in let (e1, tokens1) = parseLevel4Exp tokens in
     helper tokens1 e1

and parseLevel4Exp tokens =
  let rightHandSideExists token =
    match token with
    (* tokens that are the beginning of an atom *)
    | INT _ | NAME _ | BOOL _ | LPAR -> true
    (* other tokens that may start the right-hand-side exp *)
    | LET | IF | MATCH | FUN -> true
    | _ -> false
  in
  let rec helper tokens e1 =
    match tokens with
    | tok::rest when rightHandSideExists(tok) ->
       let (e2, tokens2) = parseLevel1ExpOrOther parseAtomExp tokens
       in helper tokens2 (App(e1, e2))
    | _ ->
       (e1, tokens)
  in let (e1, tokens1) = parseAtomExp tokens in
     helper tokens1 e1

and parseAtomExp tokens =
  match tokens with
  | INT i :: rest -> (CstI i, rest)
  | NAME x :: rest -> (Var x, rest)
  | BOOL b :: rest -> (CstB b, rest)
  | LPAR::rest ->
     let (e1, tokens1) = parseExp rest in
     (match tokens1 with
      | RPAR::rest1 -> (e1, rest1)
      | COMMA::rest1 ->
         let (e2, tokens2) = parseExp rest1 in
         let rest2 = consume RPAR tokens2 in
         (Binary(",", e1, e2), rest2)
      | _ -> failwith "Badly formed parethesized exp."
     )
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
