(* Adapted from:
   http://www.cs.cornell.edu/Courses/cs3110/2011sp/lectures/lec24-streams/streams.htm
*)

type 'a stream = Cons of 'a * (unit -> 'a stream)

let rec naturalsFrom n = Cons(n, fun () -> naturalsFrom (n+1));;

let naturals = naturalsFrom 0;;

(* head: 'a stream -> 'a *)
let head st =
    match st with
    | Cons(v, _) -> v

(* tail: 'a stream -> 'a stream *)
let tail st =
    match st with
    | Cons(_, f) -> f()

(* Examples:
 head naturals;;
 tail naturals;;
 head (tail (tail (tail naturals)));;
*)

(* Take the first n elements of st *)
(* take: int -> 'a stream -> 'a list *)
let rec take n st =
    if n = 0 then []
    else (head st)::(take (n-1) (tail st)) 

(* Examples:
  take 5 naturals;;
  take 5 (tail (tail naturals))
*)

(* map: ('a -> 'b) -> 'a stream -> 'b stream *)
let rec map f st =
    Cons(f(head st), fun () -> map f (tail st))
    
(* Examples:
  take 5 (map (fun n -> n + 2) naturals);;
  take 5 (map (fun n -> n * n) naturals);;
*)

(* Take the elements that satisfy p *)
(* filter: ('a -> bool) -> 'a stream -> 'a stream *)
let rec filter p st =
    if p(head st)
    then Cons(head st, fun () -> filter p (tail st))
    else filter p (tail st)

(* Examples:
  take 5 (filter (fun n -> n mod 3 = 0) naturals);;
  take 5 (filter (fun n -> n mod 5 = 0) naturals);;
*)  

(* fibonacci numbers given the first two numbers, a and b *)
let rec fibonacci a b =
    Cons(a, fun () -> fibonacci b (a+b))

let fibs = fibonacci 1 1

(* Examples:
  take 10 fibs;;
*)

let rec map2 f st1 st2 =
    Cons(f (head st1) (head st2),
         fun () -> map2 f (tail st1) (tail st2))

(* Examples:
  take 10 (map2 (fun n m -> n + m) naturals naturals);;
  take 10 (map2 (fun n m -> n + m) naturals (naturalsFrom 5));
*)

(* Alternative definition of fibonacci numbers *)
let rec altFibs =
    Cons(1,
         fun () -> Cons(1,
                        fun () -> map2 (+) altFibs (tail altFibs)));;

(* Examples:
  take 10 altFibs;;
*)

(* More examples ... *)

(* Negative integers: *)

let negs = map (fun n -> -1 * n) (tail naturals);;
(*
  take 10 negs;;
  - val it : int list = [-1; -2; -3; -4; -5; -6; -7; -8; -9; -10]
*)


(* Take every nth element of a stream *)
let rec nthElements n st =
  let rec helper k st =
    if k = n then Cons(head st, fun () -> helper 1 (tail st))
    else helper (k+1) (tail st)
  in helper 1 st

(*
  take 10 (nthElements 6 naturals);;
  - val it : int list = [5; 11; 17; 23; 29; 35; 41; 47; 53; 59]
*)
  
(* Defining positive even integers in several ways *)
let evens1 = nthElements 2 (tail naturals)

let evens2 = filter (fun n -> n mod 2 = 0) (tail naturals)

let evens3 = map (fun n -> n * 2) (tail naturals)

let evens4 = map2 (+) (tail naturals) (tail naturals)

(* Let's define the stream of prime numbers using the
   sieve algorithm of Eratosthenes.
   http://en.wikipedia.org/wiki/Eratosthenes#Prime_numbers
*)
let deleteMultiplesOf n st =
    filter (fun m -> not(m mod n = 0)) st

(*
   take 15 (deleteMultiplesOf 3 naturals);;
   - val it : int list = [1; 2; 4; 5; 7; 8; 10; 11; 13; 14; 16; 17; 19; 20; 22]
*)

let rec sieve st =                                                
  Cons(head st,
       fun () -> sieve (deleteMultiplesOf (head st) (tail st)))
  
let primes = sieve (naturalsFrom 2)     


(*
   take 50 primes;;
   - val it : int list = [2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47; 53; 59; 61; 67; 71;
   73; 79; 83; 89; 97; 101; 103; 107; 109; 113; 127; 131; 137; 139; 149; 151;
   157; 163; 167; 173; 179; 181; 191; 193; 197; 199; 211; 223; 227; 229]
*)
