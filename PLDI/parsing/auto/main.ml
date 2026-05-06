(* Test harness for the auto-generated parser.
   Parses and evaluates a list of arithmetic expressions,
   printing each result. Catches parse errors and prints "false". *)

(* Test expressions — some valid, some intentionally broken *)
let tss = [
  "1"        ;       (* simple number *)
  "1 + 2"    ;       (* addition *)
  "1 + 2 + 3";       (* chained addition *)
  "1 + 2 + " ;       (* <error> trailing operator *)
  "1 * 2"    ;       (* multiplication *)
  "1 + 2 * 3";       (* precedence test: * before + -> 7 *)
  "1 * 2 + 3";       (* precedence test: * before + -> 5 *)
  "1 2"      ;       (* <error> two numbers, no operator *)
  "1 * 2 + " ;       (* <error> trailing operator *)
  "1 + 2 * " ;       (* <error> trailing operator *)
]

(* Parse one string: lex it, parse the tokens, evaluate, and print.
   If parsing fails, catch the error and print "false". *)
let test_parser s =
  try
    let lexbuf = Lexing.from_string s in
    let result = (Parser.expr Lexer.scan lexbuf) in
    Printf.printf "%s -> %d\n" s (Expr_type.val_of_expr result)
  with Parsing.Parse_error ->
    Printf.printf "%s -> false\n" s

(* Run all test cases *)
let test_all () =
  List.iter test_parser tss

let _ = test_all ()
