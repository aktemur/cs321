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
    | "let"   -> LET
    | "in"    -> IN
    | "if"    -> IF
    | "then"  -> THEN
    | "else"  -> ELSE 
    | "not"   -> NOT
    | "min"   -> MIN
    | "max"   -> MAX
    | "fst"   -> FST
    | "snd"   -> SND
    | "match" -> MATCH
    | "with"  -> WITH
    | "fun"   -> FUN
    | _       -> NAME s
}

rule tokenize = parse
  | [' ' '\t' '\r'] { tokenize lexbuf (* Eat up whitespace *) }
  | '\n'            { incr_lineno lexbuf; tokenize lexbuf }
  | ['0'-'9']+      { INTEGER (int_of_string (lexeme lexbuf)) }
  | ['a'-'z''A'-'Z']['a'-'z''A'-'Z''0'-'9']*
                    { keyword (lexeme lexbuf) }
  | '+'             { PLUS }                     
  | '-'             { MINUS }                     
  | '*'             { STAR }                     
  | '/'             { SLASH }                     
  | '='             { EQ }
  | '<'             { LEFTANGLE }
  | ">="            { GTEQ }
  | '('             { LPAR }
  | ')'             { RPAR }
  | ','             { COMMA }
  | "->"            { ARROW }
  | eof             { EOF }
  | _               { failwith "Lexer error: illegal symbol" }


