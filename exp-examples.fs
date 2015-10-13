module ExpExamples

open Exp

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
