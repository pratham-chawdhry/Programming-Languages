(* Interface for the "let" language expression module. *)
type bool_expr =
  | Boolean of bool
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr
  | Not of bool_expr

type expr =
  | Id       of string                    (* variable reference *)
  | Const    of int                       (* integer literal *)
  | Add      of expr * expr               (* addition *)
  | Subtract of expr * expr               (* subtraction *)
  | IfExpr   of bool_expr * expr * expr   (* if-then-else *)
  | LetExpr  of string * expr * expr      (* let binding *)

(* Evaluate expression in an environment -> integer *)
val eval : expr -> Env.env -> int

val bool_eval : bool_expr -> bool
