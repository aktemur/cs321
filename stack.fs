module Stack

type rexp = RInt of int
          | RPlus
          | RStar
          | RDiv
          | RMinus

let rec exec rlist st = 
  match rlist with
  | RInt(i)::rlist' -> exec rlist' (i::st)
  | RPlus::rlist' ->
      match st with
      | i1::i2::st' -> exec rlist' ((i1 + i2)::st')
      | _ -> failwith "Stack must have at least two elements"
  | RStar::rlist' ->
      match st with
      | i1::i2::st' -> exec rlist' ((i1 * i2)::st')
      | _ -> failwith "Stack must have at least two elements"
  | RMinus::rlist' ->
      match st with
      | i1::i2::st' -> exec rlist' ((i2 - i1)::st')
      | _ -> failwith "Stack must have at least two elements"
  | RDiv::rlist' ->
      match st with
      | i1::i2::st' -> exec rlist' ((i2 / i1)::st')
      | _ -> failwith "Stack must have at least two elements"      
  | [] ->
      match st with
      | i::st' -> i
      | _ -> failwith "Stack must have had a final value."
