(* Interpreter for the let2 language.
   Same logic as let/expression.ml's eval, but refactored into its own module
   and operates on Expression.expr values instead of raw ints.

   Key difference: eval now returns Expression.expr (IntConst or BoolConst)
   instead of int. This change prepares the code structure for adding
   closures in the proc and letrec versions. *)

exception TypeError of string

(* Convert an expression AST back to a readable string (for debugging/output) *)
let rec string_of_expr = function
  | Expression.Id(vname)           -> vname
  | Expression.IntConst(n)         -> string_of_int n
  | Expression.Add(e1, e2)         -> (string_of_expr e1) ^ " + " ^ (string_of_expr e2)
  | Expression.Sub(e1, e2)         -> (string_of_expr e1) ^ " - " ^ (string_of_expr e2)
  | Expression.If(b, e1, e2)       -> "if (" ^ (string_of_expr b) ^ ") then (" ^ (string_of_expr e1) ^ ") else (" ^ (string_of_expr e2) ^ ")"
  | Expression.Let(vname, e1, e2)  -> "let " ^ vname ^ " = (" ^ (string_of_expr e1) ^ ") in (" ^ (string_of_expr e2) ^ ")"
  | Expression.BoolConst(b)        -> string_of_bool b
  | Expression.Not(e)              -> "not(" ^ string_of_expr e ^ ")"
  | Expression.Or(e1, e2)          -> "(" ^ (string_of_expr e1) ^ ") or (" ^ (string_of_expr e2) ^ ")"
  | Expression.And(e1, e2)         -> "(" ^ (string_of_expr e1) ^ ") and (" ^ (string_of_expr e2) ^ ")"
  | Expression.Equals(e1, e2)      -> "(" ^ (string_of_expr e1) ^ ") = (" ^ (string_of_expr e2) ^ ")"

(* Extract the int from an IntConst, or raise TypeError *)
let getIntConstValue e =
  match e with
    Expression.IntConst(c) -> c
  | _        -> raise (TypeError (("getIntConstValue: The expression is not in IntConst normal form.") ^ (string_of_expr e)))

(* Extract the bool from a BoolConst, or raise TypeError *)
let getBoolConstValue e =
  match e with
    Expression.BoolConst(b) -> b
  | _            -> raise (TypeError (("getBoolConstValue: The expression is not in BoolConst normal form.") ^ (string_of_expr e)))

(* Big-step evaluator: reduces an expression + environment to a value (IntConst or BoolConst) *)
let rec eval e env : Expression.expr =
  match e with
  | Expression.Id(vname)          -> Env.apply vname env     (* look up variable *)
  | Expression.IntConst(_)        -> e                       (* already a value *)
  | Expression.BoolConst(_)       -> e                       (* already a value *)
  | Expression.Add(e1, e2)        ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
        let i1 = (getIntConstValue e1') and i2 = (getIntConstValue e2') in
        Expression.IntConst(i1 + i2)
  | Expression.Sub(e1, e2)        ->
      let e1' = (eval e1 env) and e2' = (eval e2 env) in
        let i1 = (getIntConstValue e1') and i2 = (getIntConstValue e2') in
        Expression.IntConst(i1 - i2)
  | Expression.If(b, e1, e2)      -> if (getBoolConstValue (eval b env)) then (eval e1 env) else (eval e2 env)
  | Expression.Let(vname, e1, e2) ->
      let env' = (Env.addBinding vname (eval e1 env) env) in
      (eval e2 env')
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
        | _                            ->
            raise (TypeError "evaluate.Equals: both e1 and e2 should evaluate to expressions of the same type")
      )
