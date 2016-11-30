#use "lambda.ml";;
#use "grammar.ml";;
#use "lexer.ml";;

let parse s = main tokenize (Lexing.from_string s)

let run s = eval (parse s)

