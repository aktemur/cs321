type stackInstruction =
  | Int of int
  | Add
  | Mult
  | Subt
  | Divide

(* exec: (stackInstruction list) -> int list -> int *)
let rec exec insts stack =
  match insts with
  | [] -> List.hd stack
  | Int(i)::rest -> let newStack = i::stack in
                    exec rest newStack
  | Add::rest -> let i1::i2::restOfStack = stack in
                 let newStack = (i2 + i1)::restOfStack in
                 exec rest newStack
  | Mult::rest -> let i1::i2::restOfStack = stack in
                  let newStack = (i2 * i1)::restOfStack in
                  exec rest newStack
  | Subt::rest -> let i1::i2::restOfStack = stack in
                  let newStack = (i2 - i1)::restOfStack in
                  exec rest newStack
  | Divide::rest -> let i1::i2::restOfStack = stack in
                    let newStack = (i2 / i1)::restOfStack in
                    exec rest newStack

