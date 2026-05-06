(* AST and evaluator for the "let" language.
   Extends if_bool with: variables and let-bindings.
   Now you can write:  let x = 3 in x + 4
   This introduces the concept of an ENVIRONMENT — a mapping from
   variable names to their values. *)

(* Boolean expression AST (same as if_bool) *)
type bool_expr =
  | Boolean of bool
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr
  | Not of bool_expr

(* Integer expression AST — now includes Id and LetExpr *)
type expr =
  | Id       of string                    (* NEW: variable reference, e.g. x *)
  | Const    of int                       (* integer literal *)
  | Add      of expr * expr               (* e1 + e2 *)
  | Subtract of expr * expr               (* e1 - e2 *)
  | IfExpr   of bool_expr * expr * expr   (* if b then e1 else e2 *)
  | LetExpr  of string * expr * expr      (* NEW: let vname = e1 in e2 *)

(* Evaluate boolean expressions (unchanged from if_bool) *)
let rec bool_eval e =
  match e with
  | Boolean(b) -> b
  | And(b1, b2) -> (bool_eval b1) && (bool_eval b2)
  | Or(b1, b2) -> (bool_eval b1) || (bool_eval b2)
  | Not(b) -> not (bool_eval b)

(* Evaluate an expression to an integer.
   NOW TAKES AN ENVIRONMENT (env) so we can look up variable values. *)
let rec eval e env =
  match e with
  | Id(s) -> Env.apply s env              (* look up variable in the environment *)
  | Const(c) -> c
  | Add(e1, e2) ->
      let i1 = (eval e1 env) and i2 = (eval e2 env) in
      i1 + i2
  | Subtract(e1, e2) ->
      let i1 = (eval e1 env) and i2 = (eval e2 env) in
      i1 - i2
  | IfExpr(b, e1, e2) -> if (bool_eval b) = true then (eval e1  env) else (eval e2 env)
  | LetExpr(vname, e1, e2) ->
      (* Evaluate e1, bind the result to vname, then evaluate e2 in the new env *)
      let env' = (Env.addBinding vname (eval e1 env) env) in
      (eval e2 env')
