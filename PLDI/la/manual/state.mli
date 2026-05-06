(* Interface for the State module.
   Every scanner (FSA) returns this type after consuming one character.
   See state.ml for detailed explanation of each variant. *)
type state =
    Terminate of bool                              (* true = matched, false = failed *)
  | State of (char Mystream.mystream -> state)     (* still running: call with next input *)
