(* AST, environment, and pretty-printer for the "proc" language.
   Like letrec but WITHOUT RecClosure/RecFunDef — only non-recursive
   first-class functions (closures).

   This is the language where functions become values:
     let f = fun x -> x + 1 in (f 5)  evaluates to 6 *)

(* Expression AST *)
type expr =
  | Id        of string            (* variable reference *)
  | IntConst  of int               (* integer literal *)
  | Add       of expr * expr       (* e1 + e2 *)
  | Sub       of expr * expr       (* e1 - e2 *)
  | If        of expr * expr * expr (* if e then e1 else e2 *)
  | Let       of string * expr * expr (* let x = e1 in e2 *)
  | BoolConst of bool              (* boolean literal *)
  | Not       of expr              (* logical not *)
  | Or        of expr * expr       (* logical or *)
  | And       of expr * expr       (* logical and *)
  | Equals    of expr * expr       (* equality comparison *)
  | Closure   of string * expr * env (* Result of 'fun x -> x'. AST: Closure("x", Id "x", EmptyEnv) *)
  | FunDef    of string * expr     (* Code: 'fun x -> x + 1'. AST: FunDef("x", Add(Id "x", IntConst 1)) *)
  | FunApp    of expr * expr       (* Code: 'f 10'. AST: FunApp(Id "f", IntConst 10) *)

(* Environment: linked list of (name, value) pairs *)
and env =
    EmptyEnv
  | NonEmptyEnv of (string * expr) * env

(* Convert an expression back to readable string (for debugging/output) *)
let rec string_of_expr = function
  | Id(vname)             -> vname
  | IntConst(n)           -> string_of_int n
  | Add(e1, e2)           -> (string_of_expr e1) ^ " + " ^ (string_of_expr e2)
  | Sub(e1, e2)           -> (string_of_expr e1) ^ " - " ^ (string_of_expr e2)
  | If(b, e1, e2)         -> "if (" ^ (string_of_expr b) ^ ") then (" ^ (string_of_expr e1) ^ ") else (" ^ (string_of_expr e2) ^ ")"
  | Let(vname, e1, e2)    -> "let " ^ vname ^ " = (" ^ (string_of_expr e1) ^ ") in (" ^ (string_of_expr e2) ^ ")"
  | BoolConst(b)          -> string_of_bool b
  | Not(e)                -> "not(" ^ string_of_expr e ^ ")"
  | Or(e1, e2)            -> "(" ^ (string_of_expr e1) ^ ") or (" ^ (string_of_expr e2) ^ ")"
  | And(e1, e2)           -> "(" ^ (string_of_expr e1) ^ ") and (" ^ (string_of_expr e2) ^ ")"
  | Equals(e1, e2)        -> "(" ^ (string_of_expr e1) ^ ") = (" ^ (string_of_expr e2) ^ ")"
  | Closure(vname, e, env) -> "(fun " ^ vname ^ "->" ^ (string_of_expr e) ^") " ^ (string_of_env env)
  | FunDef(vname, e)      -> "fun " ^ vname ^ " -> " ^ (string_of_expr e)
  | FunApp(e1, e2)        -> "(" ^ (string_of_expr e1) ^ ") (" ^ (string_of_expr e2) ^ ")"

(* Print environment as a list of bindings *)
and string_of_env env =
  let rec iter = function
      EmptyEnv -> ""
    | NonEmptyEnv((vname, value), env') -> "(" ^ vname ^ "=" ^ (string_of_expr value) ^ "); " ^ (string_of_env env')
  in
  "[" ^ (iter env) ^ "]"

(* Create an empty environment *)
let emptyEnv () = EmptyEnv

(* Add a binding at the front (shadows previous bindings for the same name) *)
let addBinding x v env =
  NonEmptyEnv((x, v), env)

(* Look up a variable. No special RecClosure handling here — that's only in letrec. *)
let rec apply x env =
  match env with
    EmptyEnv -> raise Not_found
  | NonEmptyEnv((vname, value), env') ->
    if x = vname then value
    else (apply x env')
