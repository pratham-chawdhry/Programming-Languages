(* Interface for the const language expression module.
   Exposes the AST type and the evaluator. *)
type expr =
  | Const of int               (* integer literal *)
  | Add   of expr * expr       (* addition *)
  | Subtract   of expr * expr  (* subtraction *)

(* Evaluate an expression tree to an integer *)
val eval : expr -> int
