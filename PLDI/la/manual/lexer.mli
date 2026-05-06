(* Interface for the Lexer module — the top-level lexical analyser.
   It combines all the individual scanners (Num, Id, In) and returns
   the best-matching token for the next chunk of input. *)

(* The token types the lexer can produce *)
type token =
    NUM of float    (* a decimal number, e.g. NUM(3.14) *)
  | ID  of string   (* an identifier, e.g. ID("foo") *)
  | IN              (* the keyword "in" *)

(* Pretty-print a token for debugging *)
val string_of_token : token -> string

(* Main entry point: takes a character stream, returns (token, remaining_stream).
   Raises Failure "Lexical error" if no scanner matches the input. *)
val lexer : char Mystream.mystream -> token * (char Mystream.mystream)
