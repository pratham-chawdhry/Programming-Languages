(* Interpreter for the proc language.
   Like letrec/interpreter.ml but WITHOUT RecClosure handling.
   Supports first-class functions (closures) but NOT recursion. *)

exception TypeError of string

(* Extract the int from an IntConst value *)
let getIntConstValue e =
  match e with
    Expression.IntConst(c) -> c
  | _ -> raise (TypeError (("getIntConstValue: The expression is not in IntConst normal form.") ^ (Expression.string_of_expr e)))

(* Extract the bool from a BoolConst value *)
let getBoolConstValue e =
  match e with
    Expression.BoolConst(b) -> b
  | _ -> raise (TypeError (("getBoolConstValue: The expression is not in BoolConst normal form.") ^ (Expression.string_of_expr e)))

(* Extract (param, body, env) from a Closure value *)
let getClosureValue e =
  match e with
    Expression.Closure(par, body, env) -> (par, body, env)
  | _ -> raise (TypeError "getFunDefValue: The expression is not in FunDef normal form.")

(* Big-step evaluator *)
let rec eval e env : Expression.expr =
  match e with
  | Expression.Id(vname)          -> Expression.apply vname env  (* look up variable *)
  | Expression.IntConst(_)        -> e                           (* already a value *)
  | Expression.BoolConst(_)       -> e
  | Expression.Closure(_, _, _)   -> e                           (* closure is already a value *)

  (* Arithmetic *)
  | Expression.Add(e1, e2)        ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
        let i1 = (getIntConstValue e1') and i2 = (getIntConstValue e2') in
        Expression.IntConst(i1 + i2)
  | Expression.Sub(e1, e2)        ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
        let i1 = (getIntConstValue e1') and i2 = (getIntConstValue e2') in
        Expression.IntConst(i1 - i2)

  (* Conditional *)
  | Expression.If(b, e1, e2)      -> if (getBoolConstValue (eval b env)) then (eval e1 env) else (eval e2 env)

  (* Let binding *)
  | Expression.Let(vname, e1, e2) ->
      let env' = (Expression.addBinding vname (eval e1 env) env) in
      (eval e2 env')

  (* Boolean operators *)
  | Expression.Not(e)             ->
      let e' = (eval e env) in
        let b' = (getBoolConstValue e') in
        Expression.BoolConst(not b')
  | Expression.Or(e1, e2)         ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
        let b1' = (getBoolConstValue e1') and b2' = (getBoolConstValue e2') in
        Expression.BoolConst(b1' || b2')
  | Expression.And(e1, e2)        ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
        let b1' = (getBoolConstValue e1') and b2' = (getBoolConstValue e2') in
        Expression.BoolConst(b1' && b2')

  (* Equality *)
  | Expression.Equals(e1, e2)     ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
      (
        match(e1', e2') with
          (Expression.BoolConst(_), Expression.BoolConst(_)) ->
            let b1' = (getBoolConstValue e1') and b2' = (getBoolConstValue e2') in
            Expression.BoolConst(b1' = b2')
        | (Expression.IntConst(_), Expression.IntConst(_))   ->
            let i1' = (getIntConstValue e1') and i2' = (getIntConstValue e2') in
            Expression.BoolConst(i1' = i2')
        | _ ->
            raise (TypeError "evaluate.Equals: both e1 and e2 should evaluate to expressions of the same type")
      )

  (* Function definition: capture the current environment to form a closure *)
  | Expression.FunDef(par, body) -> Expression.Closure(par, body, env)

  (* Function application:
     1. Evaluate f to get Closure(par, body, env')
     2. Evaluate arg
     3. Extend the closure's environment with (par -> arg_value)
     4. Evaluate body in that extended environment *)
  | Expression.FunApp(f, arg) ->
      let e' = (eval f env) in
        let (par, body, env') = (getClosureValue e') and arg' = (eval arg env) in
          let env'' = (Expression.addBinding par arg' env') in
          (eval body env'')
