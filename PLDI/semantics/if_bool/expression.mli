(* Interface for the if_bool language expression module. *)
type bool_expr =
  | Boolean of bool                       (* boolean literal *)
  | And of bool_expr * bool_expr          (* logical and *)
  | Or of bool_expr * bool_expr           (* logical or *)
  | Not of bool_expr                      (* logical not *)

type expr =
  | Const of int                          (* integer literal *)
  | Add   of expr * expr                  (* addition *)
  | Subtract   of expr * expr             (* subtraction *)
  | IfExpr of bool_expr * expr * expr     (* if-then-else with boolean expression condition *)

val eval : expr -> int
val bool_eval : bool_expr -> bool
