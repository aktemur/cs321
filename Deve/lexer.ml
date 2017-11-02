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

(*  tokenize: char list -> token list  *)
let rec tokenize chars =
  match chars with
  | [] -> [EOF]
  | '+'::rest -> PLUS::(tokenize rest)
  | '*'::rest -> STAR::(tokenize rest)
  | '-'::rest -> MINUS::(tokenize rest)
  | '/'::rest -> SLASH::(tokenize rest)
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


  
