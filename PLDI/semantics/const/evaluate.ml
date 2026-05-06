(* Entry point for the const language interpreter.
   Reads an expression from a file (given as command-line argument)
   or from stdin if no file is provided.
   Parses it, evaluates it, and prints the integer result. *)
let evaluate () =
  try
    let cin =
      if Array.length Sys.argv > 1 then
        open_in Sys.argv.(1)       (* read from file if argument given *)
      else
        stdin                      (* otherwise read from keyboard *)
    in
    let e1 =
      let lexbuf = Lexing.from_channel cin in
        Parser.expr Lexer.scan lexbuf   (* lex + parse -> AST *)
    in
    Printf.printf "\n\t = %d\n" (Expression.eval e1)  (* evaluate and print *)
  with End_of_file -> exit 0

let _ = evaluate ()
