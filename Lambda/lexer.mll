{
(* The part between braces is regular OCaml code.
   We typically define helper functions here.
   You can use these definitions in the action
   parts of regular expression rules below.
*)

open Lexing

let incr_lineno lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <- { pos with
                           pos_lnum = pos.pos_lnum + 1;
                           pos_bol = pos.pos_cnum;
                           }

(* Distinguish keywords from identifiers.
   No keywords yet.
*)
let keyword s =
    match s with
    | "zero"  -> ZERO
    | "one"   -> ONE
    | "two"   -> TWO
    | "three" -> THREE
    | "four"  -> FOUR
    | "succ"  -> SUCC
    | "add"   -> ADD
    | "mult"  -> MULT
    | "pred"  -> PRED
    | "if"    -> IF
    | "true"  -> TRUE
    | "false" -> FALSE
    | "isZero" -> ISZERO
    | _       -> NAME s
}

rule tokenize = parse
  | [' ' '\t' '\r'] { tokenize lexbuf (* Eat up whitespace *) }
  | '\n'            { incr_lineno lexbuf; tokenize lexbuf }
  | ['a'-'z''A'-'Z']['a'-'z''A'-'Z''0'-'9']*
                    { keyword (lexeme lexbuf) }
  | '.'             { DOT }                     
  | '\\'             { LAMBDA }
  | '('             { LPAR }
  | ')'             { RPAR }
  | eof             { EOF }
  | _               { failwith "Lexer error: illegal symbol" }


