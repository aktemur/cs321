#use "lambda.ml";;
#use "lexer.ml";;
#load "str.cma";; (* For Str.global_replace in the parse function *)
#use "parser.ml";;

open Printf

let run code =
  eval (parse code)
;;

  (*
let deveREPL() =
  let rec readInput() =
    let s = String.trim(read_line()) in
    let len = String.length s in
    if len >= 2 && (String.sub s (len - 2) 2) = ";;"
    then (String.sub s 0 (len - 2))
    else s ^ "\n" ^ readInput()
  in
  let rec loop() =
    print_string "D> ";
    let s = readInput() in
    if s = "#exit" then
      printf "Bye... see you soon.\n"
    else
      try
        let (t,v) = typeCheckAndRun s in
        printf "-: %s = %s\n" (typToString t) (valToString v);
        loop()
      with Failure f ->
        printf "Problem: %s\n" f;
        loop()
  in loop()      
   *)
