(*
  The interpreter for the letrec language — this is the core evaluator.

  eval : expr -> env -> expr
    Takes an expression and an environment (variable bindings), and returns
    the expression's value (always an IntConst, BoolConst, or Closure).

  The evaluator uses "big-step operational semantics": it takes a whole
  expression and reduces it directly to a final value, rather than reducing
  one small step at a time.

  The environment (env) is a linked list of (variable_name, value) pairs.
  When we see a variable, we look it up in the environment to get its value.
*)

exception TypeError of string

(* Main evaluator — pattern matches on the shape of the expression *)
let rec eval e env : Expression.expr =
  match e with

  (* A variable: look it up in the environment.
     Special case: if it's bound to a RecClosure, the apply function in
     Expression automatically re-adds the binding so recursion works. *)
  | Expression.Id(vname)            -> Expression.apply vname env

  (* Constants and closures are already values — return them as-is *)
  | Expression.IntConst(_)          -> e
  | Expression.BoolConst(_)         -> e
  | Expression.Closure(_, _, _)
  | Expression.RecClosure(_, _, _) -> e

  (* Arithmetic: evaluate both sides, extract the int values, combine *)
  | Expression.Add(e1, e2)          ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
      let i1 = (Expression.getIntConstValue e1') and i2 = (Expression.getIntConstValue e2') in
        Expression.IntConst(i1 + i2)

  | Expression.Sub(e1, e2)          ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
      let i1 = (Expression.getIntConstValue e1') and i2 = (Expression.getIntConstValue e2') in
        Expression.IntConst(i1 - i2)

  | Expression.Multiply(e1, e2)     ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
      let i1 = (Expression.getIntConstValue e1') and i2 = (Expression.getIntConstValue e2') in
        Expression.IntConst(i1 * i2)

  (* if-then-else: evaluate the condition, pick the right branch *)
  | Expression.If(b, e1, e2)        ->
      if (Expression.getBoolConstValue (eval b env))
      then (eval e1 env)
      else (eval e2 env)

  (* let x = e1 in e2:
     - evaluate e1 to get its value
     - add (x -> value) to the environment
     - evaluate e2 in the new environment *)
  | Expression.Let(vname, e1, e2)   ->
      let env' = (Expression.addBinding vname (eval e1 env) env) in
      (eval e2 env')

  (* Boolean operators: evaluate both sides, extract bools, combine *)
  | Expression.Not(e)               ->
      let e' = (eval e env) in
      let b' = (Expression.getBoolConstValue e') in
        Expression.BoolConst(not b')

  | Expression.Or(e1, e2)           ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
      let b1' = (Expression.getBoolConstValue e1') and b2' = (Expression.getBoolConstValue e2') in
        Expression.BoolConst(b1' || b2')

  | Expression.And(e1, e2)          ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
      let b1' = (Expression.getBoolConstValue e1') and b2' = (Expression.getBoolConstValue e2') in
        Expression.BoolConst(b1' && b2')

  (* Equality: both sides must be the same type (both int or both bool) *)
  | Expression.Equals(e1, e2)       ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
      (
        match(e1', e2') with
          (Expression.BoolConst(_), Expression.BoolConst(_)) ->
            let b1' = (Expression.getBoolConstValue e1') and b2' = (Expression.getBoolConstValue e2')
            in
            Expression.BoolConst(b1' = b2')
        | (Expression.IntConst(_), Expression.IntConst(_))   ->
            let i1' = (Expression.getIntConstValue e1') and i2' = (Expression.getIntConstValue e2')
            in
            Expression.BoolConst(i1' = i2')
        | _ ->
            raise (TypeError "evaluate.Equals: both e1 and e2 should evaluate to expressions of the same type")
      )

  (* fun x -> body:
     Evaluating a function definition creates a Closure, which packages together:
       - the parameter name (x)
       - the body expression
       - a snapshot of the current environment
     The environment snapshot is what lets the function "remember" variables
     from the scope where it was defined. *)
  | Expression.FunDef(par, body)   -> Expression.Closure(par, body, env)

  (* Function application: (f arg)
     1. Evaluate f to get a Closure(par, body, env')
     2. Evaluate arg to get its value (arg')
     3. Extend the closure's captured environment with (par -> arg')
     4. Evaluate body in that extended environment *)
  | Expression.FunApp(f, arg)      ->
      let e' = (eval f env) in
      let (par, body, env') = (Expression.getClosureValue e') and arg' = (eval arg env) in
      let env'' = (Expression.addBinding par arg' env') in
        (eval body env'')

  (* let rec f = fun x -> body:
     Like FunDef but creates a RecClosure instead of a Closure.
     When f is looked up later, apply() in Expression will automatically
     re-add f to the closure's environment so the recursive call works. *)
  | Expression.RecFunDef(par, body) -> Expression.RecClosure(par, body, env)
