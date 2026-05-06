(* AST type and evaluator for simple arithmetic expressions.
   Used by the auto-generated parser in parsing/auto/. *)

(* The expression tree (AST) *)
type expr_type =
    Num of int                           (* integer literal, e.g. 42 *)
  | Add of expr_type * expr_type         (* addition: left + right *)
  | Mul of expr_type * expr_type         (* multiplication: left * right *)

(* Convert an expression tree to a readable infix string.
   e.g. Add(Num(1), Mul(Num(2), Num(3))) -> "1 + 2 * 3" *)
let rec string_of_expr = function
    Num(n) -> string_of_int n
  | Add(l, r) -> (string_of_expr l) ^ " + " ^ (string_of_expr r)
  | Mul(l, r) -> (string_of_expr l) ^ " * " ^ (string_of_expr r)

(* Evaluate an expression tree to an integer.
   Recursively evaluates sub-expressions and applies the operator. *)
let rec val_of_expr = function
    Num(n) -> n
  | Add(l, r) -> (val_of_expr l) +  (val_of_expr r)
  | Mul(l, r) -> (val_of_expr l) * (val_of_expr r)
