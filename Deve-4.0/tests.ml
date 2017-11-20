(* Test cases *)
assert (fst(parseType (scan "int")) = IntTy);;
assert (fst(parseType (scan "bool")) = BoolTy);;
assert (fst(parseType (scan "int * bool")) = PairTy(IntTy, BoolTy));;
assert (fst(parseType (scan "int -> bool")) = FunTy(IntTy, BoolTy));;
assert (fst(parseType (scan "int * bool -> bool")) = FunTy(PairTy(IntTy, BoolTy), BoolTy));;
assert (fst(parseType (scan "int -> bool * bool")) = FunTy(IntTy, PairTy(BoolTy, BoolTy)));;
assert (fst(parseType (scan "int -> bool -> bool")) = FunTy(IntTy, FunTy(BoolTy, BoolTy)));;
assert (typeCheckAndRunBare "42" = (IntTy, Int 42));;
assert (typeCheckAndRunBare "true" = (BoolTy, Bool true));;
assert (typeCheckAndRunBare "false" = (BoolTy, Bool false));;
assert (typeCheckAndRunBare "30 + 6" = (IntTy, Int 36));;
assert (typeCheckAndRunBare "30 - 6" = (IntTy, Int 24));;
assert (typeCheckAndRunBare "30 * 6" = (IntTy, Int 180));;
assert (typeCheckAndRunBare "30 / 6" = (IntTy, Int 5));;
assert (typeCheckAndRunBare "3 + 4 + 5 + 6" = (IntTy, Int 18));;
assert (typeCheckAndRunBare "30 + 6 * 2" = (IntTy, Int 42));;
assert (typeCheckAndRunBare "5 * 2 / 3" = (IntTy, Int 3));;
assert (typeCheckAndRunBare "5 - 2 - 3" = (IntTy, Int 0));;
assert (typeCheckAndRunBare "let a = 5 in a + 4" = (IntTy, Int 9));;
assert (typeCheckAndRunBare
            "let x = 7 
             in let s = x * x
                in let q = s * s
                   in q * q" = (IntTy, Int 5764801));;
assert (typeCheckAndRunBare
            "let a = 3
             in let b = 3
                in let c = 5
                   in 7 * a - 9 / b + c" = (IntTy, Int 23));;
assert (typeCheckAndRunBare
            "let x =
               let a = 5
               in let b = 8
                  in a + b
             in x * 2" = (IntTy, Int 26));;
assert (typeCheckAndRunBare "if true then 42 else 8" = (IntTy, Int 42));;
assert (typeCheckAndRunBare "if false then 42 else 8" = (IntTy, Int 8));;
assert (typeCheckAndRunBare "(30 + 6) * 2" = (IntTy, Int 72));;
assert (typeCheckAndRunBare "(let c = 3 in c + c) + (let c = 5 in c * c)" = (IntTy, Int 31));;
assert (typeCheckAndRunBare "let a = 5
             in (let b = 3 in a + b) + (let b = 9 in a * b)" = (IntTy, Int 53));;
assert (typeCheckAndRunBare "4 < 5" = (BoolTy, Bool true));;
assert (typeCheckAndRunBare "4 < 4" = (BoolTy, Bool false));;
assert (typeCheckAndRunBare "5 < 4" = (BoolTy, Bool false));;
assert (typeCheckAndRunBare "4 <= 5" = (BoolTy, Bool true));;
assert (typeCheckAndRunBare "4 <= 4" = (BoolTy, Bool true));;
assert (typeCheckAndRunBare "5 <= 4" = (BoolTy, Bool false));;
assert (typeCheckAndRunBare "let x = 4
             in if x + 1 <= 10 then 42 else x * 8" = (IntTy, Int 42));;
assert (typeCheckAndRunBare "let x = 4
             in if x + 1 < 4 then 42 else x + 8" = (IntTy, Int 12));;
assert (typeCheckAndRunBare "(3,4)" = (PairTy(IntTy, IntTy), Pair(Int 3, Int 4)));;
assert (typeCheckAndRunBare "(3 + 5, 4 < 8)" = (PairTy(IntTy, BoolTy), Pair(Int 8, Bool true)));;
assert (typeCheckAndRunBare "(3 + 5, (4 < 8, 9))" =
            (PairTy(IntTy, PairTy(BoolTy, IntTy)), Pair(Int 8, Pair(Bool true, Int 9))));;
assert (typeCheckAndRun "fst (3 + 5, 4 + 8)" = (IntTy, Int 8));;
assert (typeCheckAndRun "snd (3 + 5, 4 + 8)" = (IntTy, Int 12));;

assert (typeCheckAndRunBare "if 4 >= 5 then 42 else 8" = (IntTy, Int 8));;
assert (typeCheckAndRunBare "if 4 >= 4 then 42 else 8" = (IntTy, Int 42));;
assert (typeCheckAndRunBare "if 5 >= 4 then 42 else 8" = (IntTy, Int 42));;
assert (typeCheckAndRun "let p = (6+8, 9-5) in fst(p) + snd(p)" = (IntTy, Int 18));;
assert (typeCheckAndRun "let p = (6+8, 9-5) in (snd(p), fst(p))" = (PairTy(IntTy, IntTy), Pair (Int 4, Int 14)));;
assert (typeCheckAndRun "let p = (6+8, 9-5) in (snd(p), (fst(p) < 10, 5))" =
            (PairTy(IntTy, PairTy(BoolTy, IntTy)), Pair (Int 4, Pair (Bool false, Int 5))));;
assert (typeCheckAndRunBare "match (5+6, 2*3) with (f,s) -> f + s" = (IntTy, Int 17));;
assert (typeCheckAndRun "not(false)" = (BoolTy, Bool true));;
assert (typeCheckAndRun "not(true)" = (BoolTy, Bool false));;
assert (typeCheckAndRunBare "4 >= 5" = (BoolTy, Bool false));;
assert (typeCheckAndRunBare "4 >= 4" = (BoolTy, Bool true));;
assert (typeCheckAndRunBare "5 >= 4" = (BoolTy, Bool true));;
assert (typeCheckAndRunBare "fun (x:int) -> 42" = (FunTy(IntTy, IntTy), Closure("x", CstI 42, [])));;
assert (typeCheckAndRunBare "let y = 2+3 in fun (x:int) -> 42" =
            (FunTy(IntTy, IntTy), Closure("x", CstI 42, [("y", Int 5)])));;
assert (typeCheckAndRunBare "let f (x:bool) = 42 in f" =
            (FunTy(BoolTy, IntTy), Closure("x", CstI 42, [])));;
assert (typeCheckAndRunBare
            "let y = 5
             in let f (x:int) = x + y
                in f" =
          (FunTy(IntTy, IntTy), Closure("x", Binary("+", Var "x", Var "y"), [("y", Int 5)])));;
assert (typeCheckAndRunBare
            "let x = 12
             in let f (y:int) = x + y
                in let x = 99
                   in f" =
          (FunTy(IntTy, IntTy), Closure ("y", Binary ("+", Var "x", Var "y"), [("x", Int 12)])));;
assert (parse "x y z" = App(App(Var "x", Var "y"), Var "z"));;
assert (parse "f 3 + 1" = Binary("+", App(Var "f", CstI 3), CstI 1));;
assert (parse "3 + f 1" = Binary("+", CstI 3, App(Var "f", CstI 1)));;
assert (parse "f let x = 5 in x" = App(Var "f", LetIn("x", CstI 5, Var "x")));;
assert (parse "let x = 5 in f x" = LetIn("x", CstI 5, App(Var "f", Var "x")));;
assert (parse "let x = 5 in f 3 + 1" = LetIn("x", CstI 5,
                                             Binary("+", App(Var "f", CstI 3), CstI 1)));;
assert (parse "let x = 5 in 3 + f 1" = LetIn("x", CstI 5,
                                             Binary("+", CstI 3, App(Var "f", CstI 1))));;
assert (typeCheckAndRunBare "let f (x:int) = 42 in f 9" = (IntTy, Int 42));;
assert (typeCheckAndRunBare "let f (x:int) = x + 30 in f 12" = (IntTy, Int 42));;
assert (typeCheckAndRunBare "let f = fun (x:int) -> fun (y:int) -> x + y 
             in f 30 12" = (IntTy, Int 42));;
assert (typeCheckAndRunBare "let f = fun (x:int) -> fun (y:int) -> x + y in f 30" =
            (FunTy(IntTy, IntTy), Closure ("y", Binary ("+", Var "x", Var "y"), [("x", Int 30)])));;
assert (typeCheckAndRunBare
            "let x = 12
             in let f (y:int) = x + y
                in let x = 99
                   in f (x + 1)" = (IntTy, Int 112));;
assert (typeCheckAndRunBare "let rec f (x:int) : int = x + 5 in f 37" = (IntTy, Int 42));;
assert (typeCheckAndRunBare
            "let rec fact (n:int) : int =
               if n <= 0 then 1 else n * fact (n-1)
             in fact 5" = (IntTy, Int 120));;
assert (typeCheckAndRunBare
            "let rec fib (n:int) : int =
               if n <= 0 then 1 
               else if n <= 1 then 1
               else fib (n-1) + fib (n-2)
             in (fib 5, (fib 6, fib 7))" =
          (PairTy(IntTy, PairTy(IntTy, IntTy)), Pair (Int 8, Pair (Int 13, Int 21))));;
assert (typeCheckAndRunBare
            "let rec power (x:int) : int -> int = fun (n:int) ->
               if n <= 0 then 1 else x * power x (n-1)
             in power 3 4" = (IntTy, Int 81));;

    
