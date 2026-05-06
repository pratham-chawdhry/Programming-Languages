(* AST and evaluator for the "if" language.
   Extends const with: if-then-else (condition is a boolean literal). *)

type expr =
  | Const of int                        (* integer literal *)
  | Add   of expr * expr                (* e1 + e2 *)
  | Subtract   of expr * expr           (* e1 - e2 *)
  | IfExpr of bool * expr * expr        (* if bool then e1 else e2 *)

(* Interpreter: evaluate an expression to an integer.
   if-then-else picks the right branch based on the boolean value. *)
let rec eval e =
  match e with
  | Const(c) -> c
  | Add(e1, e2) ->
      let i1 = (eval e1) and i2 = (eval e2) in
      i1 + i2
  | Subtract(e1, e2) ->
      let i1 = (eval e1) and i2 = (eval e2) in
      i1 - i2
  | IfExpr(b, e1, e2) -> if b = true then (eval e1) else (eval e2)
    (* Note: the condition b is a literal bool here, not an expression.
       In later language versions (if_bool, let, etc.) the condition becomes evaluable. *)
