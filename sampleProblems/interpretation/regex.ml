let chars_of_string s =
  let rec helper n acc =
    if n = String.length s
    then List.rev acc
    else let c = String.get s n
         in helper (n+1) (c::acc)
  in helper 0 []
;;

let rec lexer chars =
  match chars with
  | [] -> true
  | 'a'::'a'::rest -> false
  | _::rest -> lexer rest
;;
