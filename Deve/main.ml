#use "deve.ml";;
#use "lexer.ml";;
#use "parser.ml";;

let run code =
  eval (parse code) []
;;

