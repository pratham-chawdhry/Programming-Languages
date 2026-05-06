(* Unit tests for the Id (identifier) scanner.
   Converts each test string to a char stream, runs the Id.id FSA step by step,
   and prints whether the scanner accepted (true) or rejected (false). *)

(* Run one test: feed string s into the Id scanner and return (string, result) *)
let test_id s =
  let stream : (char Mystream.mystream) = Mystream.string_stream s in
  (* iter drives the FSA: if it returns State(next), advance the stream and call next.
     If it returns Terminate(b), b tells us whether the scanner accepted. *)
  let rec iter f str =
    let result = f str in
      match result with
        State.Terminate(b) -> s, b
      | State.State(st)    -> iter st ((Mystream.tl str) ())
  in
  iter Id.id stream

(* Run all test cases and print results.
   Expected: A->true, Aa->true, AaA->true, A1->true, Aa1->true, A1a->true,
             a1->true, 1a->false (starts with digit), aa_1->false (underscore) *)
let test_ids () =
  let n = [ "A"; "Aa"; "AaA"; "A1"; "Aa1"; "A1a"; "a1"; "1a"; "aa_1" ] in
  let result = List.map test_id n in
    List.iter (fun (x, y) -> (Printf.printf "%s -> %b;\n" x y)) result

let _ = test_ids ()
