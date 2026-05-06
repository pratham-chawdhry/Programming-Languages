(* Interface for the letrec language expression module.
   Extends let2 with: closures, function definitions, function application,
   and recursive closures (RecClosure) for let rec.
   See expression.ml for detailed comments on each constructor. *)
type expr =
  | Id        of string                (* variable reference *)
  | IntConst  of int                   (* integer literal *)
  | Add       of expr * expr           (* addition *)
  | Sub       of expr * expr           (* subtraction *)
  | Multiply  of expr * expr           (* multiplication *)
  | If        of expr * expr * expr    (* if-then-else *)
  | Let       of string * expr * expr  (* let binding *)
  | BoolConst of bool                  (* boolean literal *)
  | Not       of expr                  (* logical not *)
  | Or        of expr * expr           (* logical or *)
  | And       of expr * expr           (* logical and *)
  | Equals    of expr * expr           (* equality comparison *)
  | Closure   of string * expr * env   (* runtime closure: (param, body, captured_env) *)
  | FunDef    of string * expr         (* syntactic function: fun param -> body *)
  | FunApp    of expr * expr           (* function application: e1 e2 *)
  | RecFunDef   of string * expr       (* recursive function definition *)
  | RecClosure  of string * expr * env (* recursive closure — re-injects itself on lookup *)
and env =
    EmptyEnv
  | NonEmptyEnv of (string * expr) * env

val getIntConstValue : expr -> int
val getBoolConstValue : expr -> bool
val getClosureValue : expr -> string * expr * env

val string_of_expr : expr -> string

val emptyEnv : unit -> env
val addBinding : string -> expr -> env -> env

(* Looks up a variable. Special handling for RecClosure — see expression.ml *)
val apply : string -> env -> expr
