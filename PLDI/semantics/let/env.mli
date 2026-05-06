(* Interface for the "let" language environment module.
   Maps variable names to integer values. *)
type env =
    EmptyEnv
  | NonEmptyEnv of (string * int) * env

(* Create an empty environment *)
val emptyEnv : unit -> env

(* Add binding: addBinding "x" 42 env -> env with x=42 at the front *)
val addBinding : string -> int -> env -> env

(* Look up variable: apply "x" env -> value of x. Raises Not_found if missing. *)
val apply : string -> env -> int
