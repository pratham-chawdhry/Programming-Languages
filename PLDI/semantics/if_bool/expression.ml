(* AST and evaluator for the "if_bool" language.
   Extends "if" with: boolean expressions (and, or, not) as first-class conditions.
   Now the condition in if-then-else can be a compound boolean expression,
   not just a literal true/false. *)

(* Boolean expression AST — separate from integer expressions *)
type bool_expr =
  | Boolean of bool                       (* literal true or false *)
  | And of bool_expr * bool_expr          (* b1 and b2 *)
  | Or of bool_expr * bool_expr           (* b1 or b2 *)
  | Not of bool_expr                      (* not b *)

(* Integer expression AST *)
type expr =
  | Const of int                          (* integer literal *)
  | Add   of expr * expr                  (* e1 + e2 *)
  | Subtract   of expr * expr             (* e1 - e2 *)
  | IfExpr of bool_expr * expr * expr     (* if bool_expr then e1 else e2 *)

(* Evaluate a boolean expression to an OCaml bool *)
let rec bool_eval e =
  match e with
  | Boolean(b) -> b
  | And(b1, b2) -> (bool_eval b1) && (bool_eval b2)
  | Or(b1, b2) -> (bool_eval b1) || (bool_eval b2)
  | Not(b) -> not (bool_eval b)

(* Evaluate an integer expression to an int *)
let rec eval e =
  match e with
  | Const(c) -> c
  | Add(e1, e2) ->
      let i1 = (eval e1) and i2 = (eval e2) in
      i1 + i2
  | Subtract(e1, e2) ->
      let i1 = (eval e1) and i2 = (eval e2) in
      i1 - i2
  | IfExpr(b, e1, e2) -> if (bool_eval b) = true then (eval e1) else (eval e2)
