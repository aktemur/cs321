let rec stringy lst =
  match lst with
  | [] -> []
  | x::xs -> (x, String.length x)::stringy xs

let rec positivesOf lst =
  match lst with
  | [] -> []
  | x::xs -> if x > 0 then x::positivesOf xs
             else positivesOf xs

let rec gotcha p lst =
  match lst with
  | [] -> failwith "No soup for you!"
  | x::xs -> if p x then x
             else gotcha p xs

let rec allUntil p lst =
  match lst with
  | [] -> []
  | x::xs -> if p x then x::(allUntil p xs)
             else []

let rec interleave lst1 lst2 =
  match lst1, lst2 with
  | ([], []) -> ([], [])
  | (x::xs, y::ys) ->
     let (left, right) = interleave xs ys
     in (y::right, x::left)

let enumerate lst =
  let rec aux lst index =
    match lst with
    | [] -> []
    | x::xs -> (x, index)::aux xs (index+1)
  in aux lst 0

let stringyWithMap lst =
  List.map (fun s -> (s, String.length s)) lst

let stringyWithFoldRight lst =
  List.fold_right (fun s acc -> (s, String.length s)::acc) lst []

let stringyWithFoldLeft lst =
  List.fold_left (fun acc s -> acc@[(s, String.length s)]) [] lst

let positivesOfWithFoldRight lst =
  List.fold_right (fun x acc -> if x > 0 then x::acc else acc) lst []

let positivesOfWithFoldLeft lst =
  List.fold_left (fun acc x -> if x > 0 then acc@[x] else acc) [] lst

let enumerateWithFoldLeft lst =
  let f acc x =
    let (lst, index) = acc
    in (lst@[x,index], index+1)
  in fst(List.fold_left f ([], 0) lst)         

let positivesOf lst =
  let rec aux lst acc =
    match lst with
    | [] -> acc
    | x::xs -> aux xs (if x > 0 then x::acc else acc)
  in List.rev(aux lst [])

let enumerate lst =
  let rec aux lst acc =
    match lst with
    | [] -> acc
    | x::xs -> let (eList, index) = acc
               in aux xs ((x, index)::eList, index+1)
  in List.rev(fst(aux lst ([], 0)))

let rec pick n lst =
  match lst with
  | [] -> []
  | x::xs -> if n <= 0 then []
             else x::pick (n-1) xs

let rec assoc a lst =
  let rec helper lst acc =
    match lst with
    | [] -> (match acc with
             | [] -> failwith "Not found"
             | b::bs -> b)
    | (x,b)::xs -> helper xs (if x = a then b::acc else acc)
  in helper lst []

let flatten lsts =
  List.fold_right (fun lst a -> lst@a) lsts []

let sums lst =
  List.rev (snd(List.fold_left (fun a x -> (fst a + x, (fst a + x)::snd a)) (0, []) lst))

(* DATA TYPES *)

type suit = Club | Spade | Diamond | Heart

type card = Ace of suit
          | King of suit
          | Queen of suit
          | Jack of suit
          | Ordinary of suit * int
  
(* Alternatively: 

type rank = Ace | King | Queen | Jack | Ordinary of int

type card = Card of suit * rank

*)

type number = Real of int * int * int
            | Rational of int * int
            | Complex of float * float

(* **************************************************** *)
type 'a binTree = BTLeaf of 'a
                | BTNode of 'a * 'a binTree * 'a binTree

let rec areIsomorphic t1 t2 =
  match t1, t2 with
  | BTLeaf v1, BTLeaf v2 -> true
  | BTLeaf v1, _ -> false
  | _, BTLeaf v2 -> false
  | BTNode(v1,t11,t12), BTNode(v2,t21,t22) -> areIsomorphic t11 t21 && areIsomorphic t12 t22

let rec collect t p =
  match t with
  | BTLeaf v -> if p v then [v] else []
  | BTNode (v, t1, t2) -> (if p v then [v] else []) @ collect t1 p @ collect t2 p

let rec isBST t =
  let rec flatten t =
    match t with
    | BTLeaf v -> [v]
    | BTNode(v,t1,t2) -> flatten t1 @ [v] @ flatten t2
  in let rec isSorted lst =
    match lst with
    | [] -> true
    | [x] -> true
    | x::y::rest -> x < y && isSorted (y::rest)
  in isSorted (flatten t)

let rec gotcha p bt =
  match bt with
  | BTLeaf v -> if p v then Some v else None
  | BTNode (v, bt1, bt2) ->
     (match gotcha p bt1 with
      | Some v' -> Some v'
      | None -> if p v then Some v else gotcha p bt2)
                                               
(* ***************************************************** *)
type cutelist = Empty
              | Cons of int * cutelist

let toCList lst =
  List.fold_right (fun x acc -> Cons(x,acc)) lst Empty

let rec reverse clst =
  let rec helper clst acc =
    match clst with
    | Empty -> acc
    | Cons(x,rest) -> helper rest (Cons(x,acc))
  in helper clst Empty
