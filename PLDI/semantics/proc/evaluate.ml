(* Entry point for the proc language interpreter.
   Same as letrec/evaluate.ml — handles IntConst, BoolConst, and Closure results. *)
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
    (* Print the parsed expression *)
    print_string ("\n" ^ (Expression.string_of_expr e1) ^ "\n");
    (* Evaluate in an empty environment *)
    let result = (Interpreter.eval e1 Expression.EmptyEnv) in
    match result with
      Expression.IntConst(n) -> Printf.printf "\n\t = %d\n" n
    | Expression.BoolConst(b) -> Printf.printf "\n\t = %b\n" b
    | Expression.Closure(_, _, _) -> Printf.printf "\n\t = %s\n" (Expression.string_of_expr result)
    | _ -> failwith "Result can't be a non-normal form."
  with End_of_file -> exit 0

let _ = evaluate ()
