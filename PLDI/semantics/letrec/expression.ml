(*
  Defines the AST (Abstract Syntax Tree) types and the environment for the letrec language.

  Every expression in the language corresponds to one constructor of the 'expr' type.
  The evaluator (interpreter.ml) pattern-matches on these constructors.
*)

(* ── Expression AST ─────────────────────────────────────────────────── *)
type expr =
  | Id        of string            (* A variable name, e.g. x, fact, n *)
  | IntConst  of int               (* An integer literal, e.g. 42 *)
  | Add       of expr * expr       (* e1 + e2 *)
  | Sub       of expr * expr       (* e1 - e2 *)
  | Multiply  of expr * expr       (* e1 * e2 *)
  | If        of expr * expr * expr (* if b then e1 else e2 *)
  | Let       of string * expr * expr (* let x = e1 in e2 *)
  | BoolConst of bool              (* true or false *)
  | Not       of expr              (* not e *)
  | Or        of expr * expr       (* e1 || e2 *)
  | And       of expr * expr       (* e1 && e2 *)
  | Equals    of expr * expr       (* e1 = e2 *)
  | Closure   of string * expr * env
    (* A runtime value: the result of evaluating "fun x -> body" in environment env.
       Bundles (parameter, body, captured_env) together. This is a normal form — it
       cannot be reduced further, like IntConst or BoolConst. *)
  | FunDef    of string * expr
    (* The syntactic form "fun x -> body" as it appears in source code.
       Does NOT yet contain the environment — that is captured when FunDef is evaluated. *)
  | FunApp    of expr * expr
    (* Function application: (e1 e2) — apply function e1 to argument e2 *)
  | RecFunDef   of string * expr
    (* Like FunDef but for "let rec f = fun x -> body" — the name f will refer to itself *)
  | RecClosure  of string * expr * env
    (* Like Closure but for recursive functions. When looked up in the environment,
       the apply function re-adds the binding so recursive calls can find f. *)

(* ── Environment ─────────────────────────────────────────────────────── *)
(* The environment maps variable names to their values.
   It's a linked list of (name, value) pairs, searched from front to back. *)
and env =
    EmptyEnv
  | NonEmptyEnv of (string * expr) * env

(* ── Pretty-printing ─────────────────────────────────────────────────── *)
(* Converts an expression back to a readable string (useful for debugging) *)
let rec string_of_expr = function
  | Id(vname)             -> vname
  | IntConst(n)           -> string_of_int n
  | Add(e1, e2)           -> (string_of_expr e1) ^ " + " ^ (string_of_expr e2)
  | Sub(e1, e2)           -> (string_of_expr e1) ^ " - " ^ (string_of_expr e2)
  | Multiply(e1, e2)      -> (string_of_expr e1) ^ " * " ^ (string_of_expr e2)
  | If(b, e1, e2)         -> "if (" ^ (string_of_expr b) ^ ") then (" ^ (string_of_expr e1) ^ ") else (" ^ (string_of_expr e2) ^ ")"
  | Let(vname, e1, e2)    -> "let " ^ vname ^ " = (" ^ (string_of_expr e1) ^ ") in (" ^ (string_of_expr e2) ^ ")"
  | BoolConst(b)          -> string_of_bool b
  | Not(e)                -> "not(" ^ string_of_expr e ^ ")"
  | Or(e1, e2)            -> "(" ^ (string_of_expr e1) ^ ") or (" ^ (string_of_expr e2) ^ ")"
  | And(e1, e2)           -> "(" ^ (string_of_expr e1) ^ ") and (" ^ (string_of_expr e2) ^ ")"
  | Equals(e1, e2)        -> "(" ^ (string_of_expr e1) ^ ") = (" ^ (string_of_expr e2) ^ ")"
  | Closure(vname, e, env)
  | RecClosure(vname, e, env) -> "(fun " ^ vname ^ "->" ^ (string_of_expr e) ^") " ^ (string_of_env env)
  | FunDef(vname, e)      -> "fun " ^ vname ^ " -> " ^ (string_of_expr e)
  | FunApp(e1, e2)        -> "(" ^ (string_of_expr e1) ^ ") (" ^ (string_of_expr e2) ^ ")"
  | RecFunDef(vname, e)   -> "fun " ^ vname ^ " -> " ^ (string_of_expr e)

(* Prints the environment as a list of bindings, e.g. [x=3; y=true] *)
and string_of_env env =
  let rec iter = function
      EmptyEnv -> ""
    | NonEmptyEnv((vname, value), env') -> "(" ^ vname ^ "=" ^ (string_of_expr value) ^ "); " ^ (string_of_env env')
  in
  "[" ^ (iter env) ^ "]"

(* ── Value extractors ────────────────────────────────────────────────── *)
(* These unwrap a normal-form expression and get the underlying OCaml value.
   They raise an exception if the expression is not in the expected normal form. *)

let getIntConstValue e =
  match e with
    IntConst(c) -> c
  | _ -> raise (Failure (("getIntConstValue: The expression is not in IntConst normal form.") ^ (string_of_expr e)))

let getBoolConstValue e =
  match e with
    BoolConst(b) -> b
  | _ -> raise (Failure (("getBoolConstValue: The expression is not in BoolConst normal form.") ^ (string_of_expr e)))

(* Returns (parameter, body, captured_env) from a Closure or RecClosure.
   Both Closure and RecClosure share the same three-tuple structure. *)
let getClosureValue e =
  match e with
    Closure(par, body, env)    -> (par, body, env)
  | RecClosure(par, body, env) -> (par, body, env)
  | _ -> raise (Failure "getClosureValue: The expression is not in FunClosure normal form.")

(* ── Environment operations ──────────────────────────────────────────── *)

(* Returns an empty environment (no bindings) *)
let emptyEnv () = EmptyEnv

(* Adds a new binding (x -> v) at the front of the environment.
   This shadows any previous binding for x (lexical scoping). *)
let addBinding x v env =
  NonEmptyEnv((x, v), env)

(* Looks up variable x in the environment.
   Searches from front (most recent binding) to back.

   Special case for RecClosure:
     When a recursive function f is looked up, it's stored as a RecClosure.
     We need to make recursion work, so we re-add f to the closure's own
     captured environment before returning it as a regular Closure.
     This way, when the function body calls f, it can find itself. *)
let rec apply x env =
  match env with
    EmptyEnv -> raise Not_found            (* variable not found: unbound variable error *)
  | NonEmptyEnv((vname, value), env') ->
    if x = vname then
    (
      match value with
        | RecClosure(_, _, _) ->
            (* Re-inject f into its own environment so recursive calls work *)
            let (par, body, env'') = getClosureValue(value) in
            let env''' = (addBinding vname (RecClosure(par, body, env'')) env'') in
              Closure(par, body, env''')
        | _ -> value                       (* normal (non-recursive) value: return directly *)
    )
    else (apply x env')                    (* not this binding: keep searching *)
