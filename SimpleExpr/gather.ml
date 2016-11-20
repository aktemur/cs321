#use "simpleExpr.ml";;
#use "grammar.ml";;
#use "lexer.ml";;

let parse s = main tokenize (Lexing.from_string s)

let typeOf e =
  let (t, cs) = infer e [] in
  let subs = unify cs in
  substInType t subs

let run s =
  let e = parse s in
  let t = typeOf e in
  (t, eval e [])


