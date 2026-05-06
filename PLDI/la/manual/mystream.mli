(* Interface for the Mystream module.
   Exposes a lazy character stream type and basic operations. *)

(* A lazy stream: either empty (End) or a head element + thunk for the rest *)
type 'a mystream =
    End
  | Cons of 'a * (unit -> 'a mystream)

(* Get the first element of the stream *)
val hd : 'a mystream -> 'a

(* Get a thunk that, when called with (), produces the rest of the stream *)
val tl : 'a mystream -> unit -> 'a mystream

(* Convert a string into a lazy stream of characters *)
val string_stream : string -> char mystream
