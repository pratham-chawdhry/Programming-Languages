(* AST and evaluator for the simplest language: just integers and arithmetic.
   Supported: integer constants, addition (+), subtraction (-).
   No variables, no booleans, no functions. *)

(* Expression AST *)
type expr =
  | Const of int               (* an integer literal, e.g. 42 *)
  | Add   of expr * expr       (* e1 + e2 *)
  | Subtract   of expr * expr  (* e1 - e2 *)

(* Interpreter: evaluate an expression tree down to an integer.
   This is the simplest possible evaluator — no environment needed
   because there are no variables. *)
let rec eval e =
  match e with
  | Const(c) -> c                                  (* a number is already a value *)
  | Add(e1, e2) ->
      let i1 = (eval e1) and i2 = (eval e2) in    (* evaluate both sides *)
      i1 + i2                                      (* add the results *)
  | Subtract(e1, e2) ->
      let i1 = (eval e1) and i2 = (eval e2) in
      i1 - i2
