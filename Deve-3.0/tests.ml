(* Test cases *)
assert (run "42" = Int 42);;
assert (run "true" = Bool true);;
assert (run "false" = Bool false);;
assert (run "30 + 6" = Int 36);;
assert (run "30 - 6" = Int 24);;
assert (run "30 * 6" = Int 180);;
assert (run "30 / 6" = Int 5);;
assert (run "3 + 4 + 5 + 6" = Int 18);;
assert (run "30 + 6 * 2" = Int 42);;
assert (run "5 * 2 / 3" = Int 3);;
assert (run "5 - 2 - 3" = Int 0);;
assert (run "let a = 5 in a + 4" = Int 9);;
assert (run "let x = 7 
             in let s = x * x
                in let q = s * s
                   in q * q" = Int 5764801);;
assert (run "let a = 3
             in let b = 3
                in let c = 5
                   in 7 * a - 9 / b + c" = Int 23);;
assert (run "let x =
               let a = 5
               in let b = 8
                  in a + b
             in x * 2" = Int 26);;
assert (run "if true then 42 else 8" = Int 42);;
assert (run "if false then 42 else 8" = Int 8);;
assert (run "(30 + 6) * 2" = Int 72);;
assert (run "(let c = 3 in c + c) + (let c = 5 in c * c)" = Int 31);;
assert (run "let a = 5
             in (let b = 3 in a + b) + (let b = 9 in a * b)" = Int 53);;
assert (run "4 < 5" = Bool true);;
assert (run "4 < 4" = Bool false);;
assert (run "5 < 4" = Bool false);;
assert (run "4 <= 5" = Bool true);;
assert (run "4 <= 4" = Bool true);;
assert (run "5 <= 4" = Bool false);;
assert (run "let x = 4
             in if x + 1 <= 10 then 42 else x * 8" = Int 42);;
assert (run "let x = 4
             in if x + 1 < 4 then 42 else x + 8" = Int 12);;
assert (run "(3,4)" = Pair(Int 3, Int 4));;
assert (run "(3 + 5, 4 < 8)" = Pair(Int 8, Bool true));;
assert (run "(3 + 5, (4 < 8, 9))" = Pair(Int 8, Pair(Bool true, Int 9)));;
assert (run "fst((3 + 5, (4 < 8, 9)))" = Int 8);;
assert (run "snd((3 + 5, (4 < 8, 9)))" = Pair(Bool true, Int 9));;

assert (run "if 4 >= 5 then 42 else 8" = Int 8);;
assert (run "if 4 >= 4 then 42 else 8" = Int 42);;
assert (run "if 5 >= 4 then 42 else 8" = Int 42);;
assert (run "let p = (6+8, 9-5) in fst(p) + snd(p)" = Int 18);;
assert (run "let p = (6+8, 9-5) in (snd(p), fst(p))" = Pair (Int 4, Int 14));;
assert (run "let p = (6+8, 9-5) in (snd(p), (fst(p) < 10, 5))" = Pair (Int 4, Pair (Bool false, Int 5)));;
assert (run "match (5+6, 2*3) with (f,s) -> f + s" = Int 17);;
assert (run "not(false)" = Bool true);;
assert (run "not(true)" = Bool false);;
assert (run "4 >= 5" = Bool false);;
assert (run "4 >= 4" = Bool true);;
assert (run "5 >= 4" = Bool true);;
assert (run "fun x -> 42" = Closure("x", CstI 42, []));;
assert (run "let y = 2+3 in fun x -> 42" = Closure("x", CstI 42, [("y", Int 5)]));;
assert (run "let f x = 42 in f" = Closure("x", CstI 42, []));;
assert (run "let y = 5
             in let f x = x + y
                in f" =
          Closure("x", Binary("+", Var "x", Var "y"), [("y", Int 5)]));;
