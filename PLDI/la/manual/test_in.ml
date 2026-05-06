(* Unit tests for the In (keyword "in") scanner.
   Same driver pattern as test_id.ml — feeds each test string into In.keywd_in. *)

(* Run one test: feed string s into the keyword scanner *)
let test_in s =
  let stream : (char Mystream.mystream) = Mystream.string_stream s in
  let rec iter f str =
    let result = f str in
      match result with
        State.Terminate(b) -> s, b
      | State.State(st)    -> iter st ((Mystream.tl str) ())
  in
  iter In.keywd_in stream

(* Run all test cases.
   Expected: "in"->true, "int"->false (longer word), "in "->true (trailing space), "A1"->false *)
let test_ins () =
  let n = [ "in"; "int"; "in "; "A1" ] in
  let result = List.map test_in n in
    List.iter (fun (x, y) -> (Printf.printf "%s -> %b;\n" x y)) result

let _ = test_ins ()
