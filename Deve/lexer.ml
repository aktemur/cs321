(* This is the lexer.
   The goal of the lexer is to take a string
   and recognize the tokens in it.
   A "token" is a categorized unit
   of input, such as "an integer", "the plus operator",
   "a name", etc.
 *)
type token = INT of int
           | BOOL of bool
           | NAME of string
           | PLUS | STAR | MINUS | SLASH
           | LESS | LESSEQ | GREATEREQ
           | LET | REC | EQUALS | IN
           | IF | THEN | ELSE
           | LPAR | RPAR
           | COMMA | FST | SND
           | MATCH | WITH | ARROW | END
           | NOT
           | ERROR of char
           | EOF
;;

let isDigit c = '0' <= c && c <= '9'

let digitToInt c = int_of_char c - int_of_char '0'

let isLowercaseLetter c = 'a' <= c && c <= 'z'

let isUppercaseLetter c = 'A' <= c && c <= 'Z'

let isLetter c = isLowercaseLetter c || isUppercaseLetter c

let charToString c = String.make 1 c                                 
                                                       
let keyword s =
  match s with
  | "let" -> LET
  | "rec" -> REC
  | "in" -> IN
  | "if" -> IF
  | "then" -> THEN
  | "else" -> ELSE
  | "true" -> BOOL true
  | "false" -> BOOL false
  | "fst" -> FST
  | "snd" -> SND
  | "match" -> MATCH
  | "with" -> WITH
  | "end" -> END
  | "not" -> NOT
  | _ -> NAME s
  
(*  tokenize: char list -> token list  *)
let rec tokenize chars =
  match chars with
  | [] -> [EOF]
  | '-'::'>'::rest -> ARROW::(tokenize rest)
  | '+'::rest -> PLUS::(tokenize rest)
  | '*'::rest -> STAR::(tokenize rest)
  | '-'::rest -> MINUS::(tokenize rest)
  | '/'::rest -> SLASH::(tokenize rest)
  | '='::rest -> EQUALS::(tokenize rest)
  | '<'::'='::rest -> LESSEQ::(tokenize rest)
  | '<'::rest -> LESS::(tokenize rest)
  | '>'::'='::rest -> GREATEREQ::(tokenize rest)
  | ' '::rest -> tokenize rest
  | '\t'::rest -> tokenize rest
  | '\n'::rest -> tokenize rest
  | '('::rest  -> LPAR::(tokenize rest)
  | ')'::rest  -> RPAR::(tokenize rest)
  | ','::rest  -> COMMA::(tokenize rest)
  | c::rest when isDigit(c) ->
     tokenizeInt rest (digitToInt c)
  | c::rest when isLowercaseLetter(c) ->
     tokenizeName rest (charToString c)
  | c::rest -> (ERROR c)::(tokenize rest)

and tokenizeInt chars n =
  match chars with
  | c::rest when isDigit(c) ->
     tokenizeInt rest (n * 10 + (digitToInt c))
  | _ -> (INT n)::(tokenize chars)

and tokenizeName chars s =
  match chars with
  | c::rest when isLetter(c) || isDigit(c) ->
     tokenizeName rest (s ^ (charToString c))
  | _ -> (keyword s)::(tokenize chars)
;;

let chars_of_string s =
  let rec helper n acc =
    if n = String.length s
    then List.rev acc
    else let c = String.get s n
         in helper (n+1) (c::acc)
  in helper 0 []
;;

let scan s =
  tokenize (chars_of_string s)
;;


  
