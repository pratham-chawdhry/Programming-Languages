(* Entry point for the "if" language interpreter.
   Same structure as const/evaluate.ml — reads input, parses, evaluates, prints. *)
let evaluate () =
  try
    let cin =
      if Array.length Sys.argv > 1 then
        open_in Sys.argv.(1)
      else
        stdin
    in
    let e1 =
      let lexbuf = Lexing.from_channel cin in  (*Lexbuf has buffer of characters from input stream *)
        Parser.expr Lexer.scan lexbuf   (*reads tokens from the lexer.scan(lexbuf). *) (*parser builds AST from tokens *) 
    in
    Printf.printf "\n\t = %d\n" (Expression.eval e1) (*prints the result of the evaluation of the expression e1. *)
  with End_of_file -> exit 0

let _ = evaluate ()
