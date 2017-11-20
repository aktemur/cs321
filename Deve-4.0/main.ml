#use "deve.ml";;
#use "lexer.ml";;
#use "parser.ml";;

open Printf

let wrapStdlib code =
  "let fst (p: int*int) = match p with (x,y) -> x in
   let snd (p: int*int) = match p with (x,y) -> y in
   let not (b: bool) = if b then false else true
   in " ^ code
;;

let run code =
  eval (parse (wrapStdlib code)) []
;;

let runBare code =
  eval (parse code) []
;;

let typeCheck code =
  typeOf (parse (wrapStdlib code)) []
;;

let typeCheckBare code =
  typeOf (parse code) []
;;

let typeCheckAndRun code =
  let t = typeCheck code in
  let v = run code in
  (t, v)

let typeCheckAndRunBare code =
  let t = typeCheckBare code in
  let v = runBare code in
  (t, v)

let rec valToString v =
  match v with
  | Int i -> string_of_int i
  | Bool b -> string_of_bool b
  | Pair(v1, v2) -> "(" ^ valToString(v1) ^ "," ^ valToString(v2) ^ ")"
  | Closure(x,e,env) -> "<fun>"
  | RecClosure(f,x,e,env) -> "<fun>"

let rec typToString t =
  match t with
  | IntTy -> "int"
  | BoolTy -> "bool"
  | PairTy(t1, t2) -> "(" ^ typToString(t1) ^ "*" ^ typToString(t2) ^ ")"
  | FunTy(t1, t2) -> "(" ^ typToString(t1) ^ "->" ^ typToString(t2) ^ ")"

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
