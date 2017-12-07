type token = NAME of string
           | LAMBDA
           | DOT
           | LPAR | RPAR
           | ERROR of char
           | EOF
;;

let isLowercaseLetter c = 'a' <= c && c <= 'z'

let isUppercaseLetter c = 'A' <= c && c <= 'Z'

let isLetter c = isLowercaseLetter c || isUppercaseLetter c

let charToString c = String.make 1 c                                 
                                                       
let keyword s =
  match s with
  | "lambda" -> LAMBDA
  | _ -> NAME s
  
(*  tokenize: char list -> token list  *)
let rec tokenize chars =
  match chars with
  | [] -> [EOF]
  | '.'::rest -> DOT::(tokenize rest)
  | ' '::rest -> tokenize rest
  | '\t'::rest -> tokenize rest
  | '\n'::rest -> tokenize rest
  | '('::rest  -> LPAR::(tokenize rest)
  | ')'::rest  -> RPAR::(tokenize rest)
  | c::rest when isLowercaseLetter(c) ->
     tokenizeName rest (charToString c)
  | c::rest -> (ERROR c)::(tokenize rest)

and tokenizeName chars s =
  match chars with
  | c::rest when isLetter(c) ->
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
