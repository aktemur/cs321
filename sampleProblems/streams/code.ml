type 'a stream = Cons of 'a * (unit -> 'a stream)

let head st =
  match st with
  | Cons(a, f) -> a;;
  
let tail st =
  match st with
  | Cons(a, f) -> f();;

let rec take n st =
    if n = 0 then []
    else (head st)::(take (n-1) (tail st)) 
;;
(**************************************************************)

let rec squaresFrom n = Cons(n*n, fun() -> squaresFrom (n+1));;

let squares = squaresFrom 1;;

let cycle lst =                                                       
  let rec helper items = 
    match items with
    | [] -> helper lst
    | x::xs -> Cons(x, fun () -> helper xs)
  in helper lst
;;

let takeWhile p st =
  let rec helper st acc =
    let x = head st
    in if p x then helper (tail st) (x::acc) else acc
  in List.rev(helper st [])
;;

let enumerate st =
  let rec helper n st =
    Cons((n, head st), fun() -> helper (n+1) (tail st))
  in helper 0 st
;;

let rec merge st1 st2 =
  Cons(head st1, fun() ->
                 Cons(head st2, fun() ->
                                merge (tail st1) (tail st2)))
;;
  
