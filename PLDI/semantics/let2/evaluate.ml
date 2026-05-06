(* Entry point for the let2 language interpreter.
   Reads input, parses, prints the expression, evaluates, prints the result.
   Handles IntConst and BoolConst results. *)
let evaluate () =
  try
    let cin =
      if Array.length Sys.argv > 1 then
        open_in Sys.argv.(1)
      else
        stdin
    in
    let e1 =
      let lexbuf = Lexing.from_channel cin in
        Parser.expr Lexer.scan lexbuf
    in
    (* Print the parsed expression for debugging *)
    print_string (Interpreter.string_of_expr e1);
    (* Evaluate starting from an empty environment *)
    let result = (Interpreter.eval e1 Env.EmptyEnv) in
    match result with
      Expression.IntConst(n) -> Printf.printf "\n\t = %d\n" n
    | Expression.BoolConst(b) -> Printf.printf "\n\t = %b\n" b
    | _ -> failwith "Result can't be a non-normal form."
  with End_of_file -> exit 0

let _ = evaluate ()
