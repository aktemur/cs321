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
let example1 = Prim("+", CstI(17),
                         Prim("/",
                              CstI(50),
                              CstI(2)))

let example2 = Prim("+", CstI(17),
                         Prim("/",
                              CstI(50),
                              CstI(0)))

let example3 = Prim("*", CstI 17, CstI 25)

let example4 = Prim("+", CstI(17),
                         Prim("/",
                              Var "a",
                              Var "b"))

let example5 = Let("a",
                   CstI 36,
                   Let("b",
                       CstI 4,
                       Prim("+",
                            CstI 17,
                            Prim("/",
                                 Var "a",
                                 Var "b"))))

let example6 = Prim("+",
                    CstI 17,
                    Let("x",
                        CstI 5,
                        Prim("*",
                             CstI 5,
                             Var "x")))

let initialEnv = [("a", 36); ("b", 9); ("z", 34)]
