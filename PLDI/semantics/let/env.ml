(* Environment module for the "let" language.
   The environment maps variable names (strings) to integer values.
   It is implemented as a linked list of (name, value) pairs.

   When you do "let x = 3 in ...", a new binding (x, 3) is added
   to the front of the list. Looking up a variable searches from
   front to back, so newer bindings shadow older ones. *)

type env =
    EmptyEnv                              (* no bindings *)
  | NonEmptyEnv of (string * int) * env   (* (name, value) :: rest *)

(* Create an empty environment *)
let emptyEnv () = EmptyEnv

(* Add a new binding to the front of the environment *)
let addBinding x v env =
  NonEmptyEnv((x, v), env)

(* Look up a variable in the environment.
   Searches from front (most recent) to back (oldest).
   Raises Not_found if the variable doesn't exist. *)
let rec apply x env : int =
  match env with
    EmptyEnv -> raise Not_found
  | NonEmptyEnv((vname, value), env') ->
    if x = vname then value
    else (apply x env')
