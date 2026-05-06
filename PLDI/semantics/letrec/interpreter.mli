(* Interface for the letrec interpreter module. *)
exception TypeError of string

(* Big-step evaluator: expression + environment -> value *)
val eval : Expression.expr -> Expression.env -> Expression.expr
