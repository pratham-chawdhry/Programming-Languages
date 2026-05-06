(* Parser for lambda calculus expressions.
   Lambda calculus has only three constructs:
     1. Identifier:   x
     2. Abstraction:  lambda x body    (define a function with parameter x)
     3. Application:  (e1 e2)          (apply function e1 to argument e2)

   This is a recursive-descent parser that works on a pre-tokenised list.
   It is self-contained — no build step needed.
   Load in the OCaml REPL:  #use "parse-lambda.ml";;
*)

exception Parse_error of string

(* Token types produced by the (hypothetical) lexer *)
type token =
    IDENTIFIER of string    (* a variable name like "x", "y" *)
  | LPAREN                  (* ( *)
  | RPAREN                  (* ) *)
  | LAMBDA                  (* the keyword "lambda" *)

(* AST (Abstract Syntax Tree) for lambda expressions *)
type lambda =
    Identifier of string                 (* a variable reference *)
  | Abstraction of (string * lambda)     (* function: parameter name + body *)
  | Application of (lambda * lambda)     (* function application: function + argument *)

(* Main parser: tries each form in order (abstraction, identifier, application).
   Returns (ast, remaining_tokens).
   Uses backtracking via try/with — if one form fails, tries the next. *)
let rec parse_lambda lst =
  try
    parse_abstraction lst          (* try: lambda x body *)
  with
  Failure(_) ->
    try
      parse_identifier lst         (* try: x *)
    with
  Failure(_) ->
    try
      parse_application lst        (* try: (e1 e2) *)
    with
      Failure(_) -> failwith ""

(* Parse an abstraction: LAMBDA IDENTIFIER body
   e.g. [LAMBDA; IDENTIFIER("x"); ...] -> Abstraction("x", parsed_body) *)
and    parse_abstraction = function
    LAMBDA :: IDENTIFIER(s) :: t ->
      let ast, lst' = parse_lambda t in
      Abstraction(s, ast), lst'
  | _ -> failwith ""

(* Parse a single identifier: just consume the IDENTIFIER token *)
and    parse_identifier = function
    IDENTIFIER(s) :: t ->
      Identifier(s), t
  | _ -> failwith ""

(* Parse an application: LPAREN e1 e2 RPAREN
   e.g. [LPAREN; IDENTIFIER("x"); IDENTIFIER("y"); RPAREN] -> Application(x, y) *)
and    parse_application = function
    h :: t when h = LPAREN ->
      let ast, lst' = parse_lambda t in        (* parse the function part *)
      let ast', lst'' = parse_lambda lst' in   (* parse the argument part *)
      (
        match lst'' with
          h' :: t' when h' = RPAREN ->         (* expect closing paren *)
            Application(ast, ast'), t'
        | _ -> failwith ""                     (* missing closing paren *)
      )
  | _ -> failwith ""


(* ── Test cases ──────────────────────────────────────────────────── *)

(* t1: empty input -> should fail *)
let t1 () =
  let l = [ ] in
  parse_lambda l

(* t2: "x" -> Identifier("x") *)
let t2 () =
  let l = [ IDENTIFIER("x") ] in
  parse_lambda l

(* t3: "(x y)" -> Application(Identifier("x"), Identifier("y")) *)
let t3 () =
  let l = [ LPAREN; IDENTIFIER("x"); IDENTIFIER("y"); RPAREN ] in
  parse_lambda l

(* t4: "lambda x (x y)" -> Abstraction("x", Application(x, y)) *)
let t4 () =
  let l = [ LAMBDA; IDENTIFIER("x"); LPAREN; IDENTIFIER("x"); IDENTIFIER("y"); RPAREN ] in
  parse_lambda l

(* t5: "lambda x (x lambda y y)" -> nested abstraction inside application *)
let t5 () =
  let l = [ LAMBDA; IDENTIFIER("x"); LPAREN; IDENTIFIER("x"); LAMBDA; IDENTIFIER("y"); IDENTIFIER("y"); RPAREN ] in
  parse_lambda l

(* t6: "lambda x (x lambda y y" -> ERROR: missing closing ) *)
let t6 () =
  let l = [ LAMBDA; IDENTIFIER("x"); LPAREN; IDENTIFIER("x"); LAMBDA; IDENTIFIER("y"); IDENTIFIER("y") ] in
  parse_lambda l
