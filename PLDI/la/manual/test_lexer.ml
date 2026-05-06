(* System tests for the full Lexer module.
   Feeds each test string into Lexer.lexer and prints the recognised token.
   If the lexer fails (no scanner matches), prints "false".
   This tests the full pipeline: Num + Id + In scanners working together. *)

(* Run one test case *)
let test_lexer s =
  try
    let (tok, _) = Lexer.lexer (Mystream.string_stream s) in
    Printf.printf "%s -> true;\n" (Lexer.string_of_token tok)
  with
    Failure(_) -> print_string (s ^ " -> false;\n")

(* Run all test cases.
   Includes identifiers, numbers, decimals, the keyword "in",
   and intentional error cases like "." and "1." *)
let test_lexers () =
  let inputs = [ "A"; "Bb"; "BbB"; "C1"; "Dd2"; "E3e"; "f4"; "5g"; "G_"; "6";
                 "7.7"; "88.8"; "99.99"; ".11"; "."; "1."; "in"; "integral" ] in
  List.iter test_lexer inputs;
  print_string (string_of_int (List.length inputs) ^ " test cases.\n")

let _ = test_lexers ()
