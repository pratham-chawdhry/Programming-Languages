(* Interface for the "if" language expression module. *)
type expr =
  | Const of int                        (* integer literal *)
  | Add   of expr * expr                (* addition *)
  | Subtract   of expr * expr           (* subtraction *)
  | IfExpr of bool * expr * expr        (* if-then-else with boolean literal condition *)

val eval : expr -> int
