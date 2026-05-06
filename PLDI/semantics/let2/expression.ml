(* AST for the "let2" language.
   Same language features as "let", but restructured: the evaluator is
   moved to a separate Interpreter module, and values are now expr
   (not just int) to prepare for adding closures in later versions.

   The key difference from let/expression.ml:
   - eval returns Expression.expr instead of int
   - No bool_expr type — booleans are unified into the expr type
   - Adds Equals for comparison *)

type expr =
  | Id        of string            (* variable reference *)
  | IntConst  of int               (* integer literal *)
  | Add       of expr * expr       (* e1 + e2 *)
  | Sub       of expr * expr       (* e1 - e2 *)
  | If        of expr * expr * expr (* if e then e1 else e2 *)
  | Let       of string * expr * expr (* let x = e1 in e2 *)
  | BoolConst of bool              (* boolean literal *)
  | Not       of expr              (* logical not *)
  | Or        of expr * expr       (* logical or *)
  | And       of expr * expr       (* logical and *)
  | Equals    of expr * expr       (* equality comparison: e1 = e2 *)
