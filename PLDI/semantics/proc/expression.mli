(* Interface for the proc language expression module.
   First-class functions (closures) but no recursion. *)
type expr =
  | Id        of string
  | IntConst  of int
  | Add       of expr * expr
  | Sub       of expr * expr
  | If        of expr * expr * expr
  | Let       of string * expr * expr
  | BoolConst of bool
  | Not       of expr
  | Or        of expr * expr
  | And       of expr * expr
  | Equals    of expr * expr
  | Closure   of string * expr * env   (* runtime closure *)
  | FunDef    of string * expr         (* syntactic function definition *)
  | FunApp    of expr * expr           (* function application *)
and env =
    EmptyEnv
  | NonEmptyEnv of (string * expr) * env

val string_of_expr : expr -> string
val emptyEnv : unit -> env
val addBinding : string -> expr -> env -> env
val apply : string -> env -> expr
