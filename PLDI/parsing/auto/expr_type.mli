(* Interface for the Expr_type module.
   Defines the expression AST and two operations on it. *)

type expr_type =
    Num of int                          (* integer literal *)
  | Add of expr_type * expr_type        (* addition *)
  | Mul of expr_type * expr_type        (* multiplication *)

(* Convert an expression tree to a readable string *)
val string_of_expr : expr_type -> string

(* Evaluate an expression tree to its integer value *)
val val_of_expr : expr_type -> int
