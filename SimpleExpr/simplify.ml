let rec simplify e =
  match e with
  | CstI i -> e
  | Var x -> e
  | Unary(op, e1) -> Unary(op, simplify e1)
  | Prim(op, e1, e2) ->
     let (e1', e2') = (simplify e1, simplify e2) in
     (match op, e1', e2' with
      | "+", CstI 0, _ -> e2'
      | "+", _, CstI 0 -> e1'
      | "-", _, CstI 0 -> e1'
      | "*", CstI 1, _ -> e2'
      | "*", _, CstI 1 -> e1'
      | "*", CstI 0, _ -> CstI 0
      | "*", _, CstI 0 -> CstI 0
      | "-", _, _ -> if e1' = e2' then CstI 0
                     else Prim("-", e1', e2')
      | _ -> Prim(op, e1', e2')
     )
  | Let(x, e1, e2) -> Let(x, simplify e1, simplify e2)
  | If(c, e1, e2) -> If(simplify c, simplify e1, simplify e2)
  | MatchPair(e1, x, y, e2) -> MatchPair(simplify e1, x, y, simplify e2)

                               
