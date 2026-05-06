(* Unit test for the Mystream.string_stream function.
   Converts a string to a lazy character stream and prints each character
   one per line. Stops when the stream is exhausted (hd raises Failure). *)
let test_string_stream () =
  let s = Mystream.string_stream "Sujit" in
  let rec iter stream =
    try
      Printf.printf "%c\n" (Mystream.hd stream);   (* print current character *)
      iter ((Mystream.tl stream) ())                (* advance to next character *)
    with Failure(_) -> ()                           (* stream ended *)
  in
  iter s

let _ = test_string_stream ()
