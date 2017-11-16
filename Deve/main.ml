#use "deve.ml";;
#use "lexer.ml";;
#use "parser.ml";;

open Printf

let run code =
  eval (parse code) []
;;

let rec valToString v =
  match v with
  | Int i -> string_of_int i
  | Bool b -> string_of_bool b
  | Pair(v1, v2) -> "(" ^ valToString(v1) ^ "," ^ valToString(v2) ^ ")"
  | Closure(f, ps, e1, env) -> "<fun>"

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
    let v = run s in
    printf "val: %s\n" (valToString v);
    loop()
  in loop()      
