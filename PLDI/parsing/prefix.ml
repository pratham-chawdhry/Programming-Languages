(* Parser for prefix-notation arithmetic expressions.
   In prefix notation, the operator comes BEFORE its operands:
     + 1 2      means  1 + 2
     / + 3 4 2  means  (3 + 4) / 2

   This file is self-contained — no build step needed.
   Load it in the OCaml REPL:  #use "prefix.ml";;
*)

exception ParseError of string

(* Supported operators *)
type op =
    PLUS
  | DIV

(* Token types: either an operator or a number *)
type token =
    Op of op
  | NUM of int

(* AST (Abstract Syntax Tree) for expressions *)
type expr =
    Num of int                     (* a number literal *)
  | BinTerm of op * expr * expr    (* operator applied to two sub-expressions *)

(* Convert a list of strings to a single semicolon-separated string (for debugging) *)
let rec string_of_list = function
    [] -> ""
  | h :: t -> h ^ "; " ^ (string_of_list t)

(* Recursive-descent parser.
   Takes a token list, returns (parsed_expression, remaining_tokens).

   How it works:
   - If the head is an operator, parse two sub-expressions after it
     and combine them into a BinTerm.
   - If the head is a number, return it immediately as a Num leaf.
   - If the list is empty, raise an error. *)
let rec parse_prefix p =
  match p with
    [] -> raise (ParseError "premature end of string")
  | h :: t ->
    match h with
      Op(o) ->
        let (p', t') = parse_prefix t in       (* parse first operand *)
        let (p'', t'') = parse_prefix t' in    (* parse second operand *)
        (BinTerm(o, p', p''), t'')             (* combine into operator node *)
    | NUM(n) ->
        (Num(n), t)                            (* number: leaf node *)

(* Convert an operator to its string symbol *)
let string_of_op = function
    PLUS -> "+"
  | DIV  -> "/"

(* Convert an expression tree back to normal infix notation with parentheses.
   e.g. BinTerm(PLUS, Num(1), Num(2)) -> "(1+2)" *)
let rec infix_of_exp = function
    Num(n) -> string_of_int n
  | BinTerm(o, e1, e2) ->
      "(" ^ (infix_of_exp e1) ^
      (string_of_op o) ^
      (infix_of_exp e2) ^ ")"

(* Evaluate an expression tree to an integer result.
   Recursively evaluates sub-expressions, then applies the operator. *)
let rec evaluate = function
    Num(n) -> n
  | BinTerm(o, e1, e2) ->
    (
      match o with
        DIV -> (evaluate e1) / (evaluate e2)
      | PLUS -> (evaluate e1) + (evaluate e2)
    )

(* Test helper: parse, print infix form, and print computed value *)
let t e =
  let (ast, _) = parse_prefix e in
  let infix = infix_of_exp ast in (print_endline ("infix = " ^ infix));
  let value = evaluate ast in (print_endline ("value = " ^ (string_of_int value)))

(* Test case: + 1 2  ->  infix = (1+2), value = 3 *)
let t1 () =
  let e = [Op(PLUS); NUM(1); NUM(2)] in (t e)
