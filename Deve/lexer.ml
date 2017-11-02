(* This is the lexer.
   The goal of the lexer is to take a string
   and recognize the tokens in it.
   A "token" is a categorized unit
   of input, such as "an integer", "the plus operator",
   "a name", etc.
 *)
type token = INT of int
           | PLUS | STAR | MINUS | SLASH
           | EOF
;;

let isDigit c = '0' <= c && c <= '9'

let digitToInt c = int_of_char c - int_of_char '0'

(*  tokenize: char list -> token list  *)
let rec tokenize chars =
  match chars with
  | [] -> [EOF]
  | '+'::rest -> PLUS::(tokenize rest)
  | '*'::rest -> STAR::(tokenize rest)
  | '-'::rest -> MINUS::(tokenize rest)
  | '/'::rest -> SLASH::(tokenize rest)
  | ' '::rest -> tokenize rest
  | '\t'::rest -> tokenize rest
  | '\n'::rest -> tokenize rest
  | c::rest when isDigit(c) ->
     tokenizeInt rest (digitToInt c)

and tokenizeInt chars n =
  match chars with
  | c::rest when isDigit(c) ->
     tokenizeInt rest (n * 10 + (digitToInt c))
  | _ -> (INT n)::(tokenize chars)
;;

let chars_of_string s =
  let rec helper n acc =
    if n = String.length s
    then List.rev acc
    else let c = String.get s n
         in helper (n+1) (c::acc)
  in helper 0 []
;;

let allTokens s =
  tokenize (chars_of_string s)
;;


  
