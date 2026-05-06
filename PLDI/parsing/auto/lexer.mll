(* ocamllex specification for the arithmetic expression lexer.
   Reads input text and produces tokens for the parser.

   This file is processed by ocamllex to generate lexer.ml.
   Do NOT edit lexer.ml directly — edit this file instead.

   Tokens produced: NUM(int), ADD, MUL, EOF
   Whitespace and unknown characters are silently skipped. *)
{
exception Lexer_exception of string
}

(* Regular expression definitions *)
let digit = ['0'-'9']              (* a single digit *)
let integer = ['0'-'9']['0'-'9']*  (* one or more digits *)

(* Lexing rules: match patterns left-to-right, produce tokens *)
rule scan = parse
  | integer as s {  Parser.NUM(int_of_string s) }  (* number literal *)
  | "+"  { Parser.ADD  }                            (* addition operator *)
  | "*"  { Parser.MUL }                             (* multiplication operator *)
  | eof  { Parser.EOF  }                            (* end of input *)
  | _    { scan lexbuf }                            (* skip anything else *)


{
(* No additional code needed — the parser drives the lexer *)
}
