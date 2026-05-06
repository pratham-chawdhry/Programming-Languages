(* Interface for the let2 language expression module.
   Defines the unified AST — booleans and integers share the same expr type. *)
type expr =
  | Id        of string            (* variable reference *)
  | IntConst  of int               (* integer literal *)
  | Add       of expr * expr       (* addition *)
  | Sub       of expr * expr       (* subtraction *)
  | If        of expr * expr * expr (* if-then-else *)
  | Let       of string * expr * expr (* let binding *)
  | BoolConst of bool              (* boolean literal *)
  | Not       of expr              (* logical not *)
  | Or        of expr * expr       (* logical or *)
  | And       of expr * expr       (* logical and *)
  | Equals    of expr * expr       (* equality *)
