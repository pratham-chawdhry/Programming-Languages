(* Hand-written recursive-descent parser with backtracking.

   Grammar:
     S ::= c A d
     A ::= a b       (try this first)
     A ::= a         (fall back to this if A1 fails)

   This demonstrates how a parser tries one production rule, and if it
   fails, backtracks to try an alternative rule.

   Example inputs:
     "cabd" -> Success  (S = c, A = ab, d)
     "cad"  -> Success  (S = c, A = a, d)   — A1 fails, backtracks to A2
     "cab"  -> Failure  (no 'd' at the end)
     "cac"  -> Failure  (no 'd' at the end)
*)

(* Parse result: either Success with the final position, or Failure *)
type result =
    Success of int
  | Failure

let string_of_result = function
    Success(_) -> "Success"
  | Failure    -> "Failure"

(* The parser: takes a byte string and returns Success/Failure.
   Each parse_X function takes a position and returns the result. *)
let parse inp =

  (* parse_S: expects 'c', then A, then 'd' *)
  let rec parse_S pos =
    Printf.printf "parse_S %d\n" pos;
    if (Bytes.get inp pos) = 'c' then
    begin
      (* First try A ::= a b *)
      match (parse_A1 (pos + 1)) with
        Success(pos') ->
          if (Bytes.get inp (pos' + 1)) = 'd' then
            Success(pos' + 1)
          else
            Failure
      | Failure ->
        begin
          (* A1 failed — backtrack and try A ::= a *)
          match (parse_A2 (pos + 1)) with
            Success(pos') ->
              if (Bytes.get inp (pos' + 1)) = 'd' then
                Success (pos' + 1)
              else
                Failure
          | Failure -> Failure
        end
    end
    else
      Failure

  (* parse_A1: tries rule A ::= a b *)
  and parse_A1 pos =
    Printf.printf "parse_A1 %d\n" pos;
    if Bytes.get inp pos = 'a' then
      if Bytes.get inp (pos + 1) = 'b' then
        Success(pos + 1)
      else
        Failure
    else
      Failure

  (* parse_A2: tries rule A ::= a  (single character) *)
  and parse_A2 pos =
    Printf.printf "<backtracking> parse_A2 %d\n" pos;
    if Bytes.get inp pos = 'a' then
      Success(pos)
    else
      Failure
  in
  (* Catch out-of-bounds access (input too short) *)
  try
    parse_S 0
  with
    Invalid_argument(_) -> Failure

(* Test helper: pretty-print the parse result for a given input *)
let test inp =
   let result = (string_of_result (parse inp)) in
   begin
     print_endline ("********** Parsing " ^ inp ^ " ***********");
     print_endline (inp ^ " --> " ^ result);
     print_endline "*********************"
   end

(* Run all test cases *)
let main () =
  test "cabd";    (* Success: A = ab *)
  test "cad";     (* Success: A = a, with backtracking *)
  test "cab";     (* Failure: no 'd' *)
  test "cac"      (* Failure: no 'd' *)

let _ = main ()
