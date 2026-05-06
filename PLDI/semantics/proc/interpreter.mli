(* Interface for the proc interpreter module. *)
exception TypeError of string

val getIntConstValue : Expression.expr -> int
val getBoolConstValue : Expression.expr -> bool
val getClosureValue : Expression.expr -> string * Expression.expr * Expression.env

(* Big-step evaluator: expression + environment -> value *)
val eval : Expression.expr -> Expression.env -> Expression.expr
