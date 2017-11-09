(* Test cases *)
assert (run "30 + 6 * 2" = 42);;
assert (run "3 + 4 + 5 + 6" = 18);;
assert (run "5 * 2 / 3" = 3);;
assert (run "5 - 2 - 3" = 0);;
assert (run "let a = 5 in a + 4" = 9);;
assert (run "let x = 7 
             in let s = x * x
                in let q = s * s
                   in q * q" = 5764801);;
assert (run "let a = 3
             in let b = 3
                in let c = 5
                   in 7 * a - 9 / b + c" = 23);;
assert (run "(let c = 3 in c + c) + (let c = 5 in c * c)" = 31);;
assert (run "let a = 5
             in (let b = 3 in a + b) + (let b = 9 in a * b)" = 48);;
assert (run "let x =
               let a = 5
               in let b = 8
                  in a + b
             in x * 2" = 26);;
assert (run "let x = 4
             in if x + 1 >= 0 then 42 else x * 8" = 42);;
assert (run "let x = 4
             in if x < 4 then 42 else x + 8" = 12);;
assert (run "if true then 42 else 8" = 42);;
assert (run "if false then 42 else 8" = 8);;
