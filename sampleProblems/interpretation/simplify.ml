let rec simplify e =
  match e with
  | CstI i -> e
  | Var x -> e
  | Add(e1, e2) ->
     (match (simplify e1, simplify e2) with
      | CstI 0, e2' -> e2'
      | e1', CstI 0 -> e1'
      | e1', e2'    -> Add(e1', e2'))
  | Subt(e1, e2) ->
     (match (simplify e1, simplify e2) with
      | e1', CstI 0 -> e1'
      | e1', e2'    -> if e1' = e2' then CstI 0
                       else Subt(e1', e2'))
  | Mult(e1, e2) ->
     (match (simplify e1, simplify e2) with
      | CstI 1, e2' -> e2'
      | e1', CstI 1 -> e1'
      | CstI 0, e2' -> CstI 0
      | e1', CstI 0 -> CstI 0
      | e1', e2'    -> Mult(e1', e2'))
  | Div(e1, e2) -> Div(simplify e1, simplify e2)
  | LetIn(x, e1, e2) -> LetIn(x, simplify e1, simplify e2)

                               
