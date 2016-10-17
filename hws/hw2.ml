
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
    BTLeaf v -> if p v then [v] else []
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
