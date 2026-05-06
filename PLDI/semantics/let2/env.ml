(* Environment module for the let2 language.
   Like let/env.ml but stores Expression.expr values instead of ints,
   preparing for languages where variables can hold closures. *)

type env =
    EmptyEnv
  | NonEmptyEnv of (string * Expression.expr) * env  (* maps names to expr values *)

(* Create an empty environment *)
let emptyEnv () = EmptyEnv

(* Add a new binding at the front (shadows any previous binding for x) *)
let addBinding x v env =
  NonEmptyEnv((x, v), env)

(* Look up variable x — returns the Expression.expr value.
   Searches front to back. Raises Not_found if missing. *)
let rec apply x env =
  match env with
    EmptyEnv -> raise Not_found
  | NonEmptyEnv((vname, value), env') ->
    if x = vname then value
    else (apply x env')
