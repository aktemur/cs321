module ExpExamples

open System
open System.IO
open System.Text
open Microsoft.FSharp.Text.Lexing
open Parser
open Exp

(* Plain parsing from a string, with poor error reporting *)
let fromString (str : string) : exp =
    let lexbuf = Lexing.LexBuffer<char>.FromString(str)
    try 
      Parser.Main Lexer.Token lexbuf
    with 
      | exn -> let pos = lexbuf.EndPos 
               failwithf "%s near line %d, column %d\n" 
                  (exn.Message) (pos.Line+1) pos.Column

let tokenize str =
    let lexbuf = Lexing.LexBuffer<char>.FromString(str)
    let rec helper () = 
      let tok = Lexer.Token lexbuf  
      if tok = EOF then [EOF] else tok::helper()  
    helper();;

let run s = eval (fromString s) []

(* Examples *)
let ex1 = "let f n = n * 5 in f(6) end"

let recursiveEx = @"let fact n = if n < 1 then 1 else n * fact(n-1)
                    in fact(6) end"


let notEx = "not(3 < 4)"
