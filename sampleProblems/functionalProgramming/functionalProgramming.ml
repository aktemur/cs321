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
