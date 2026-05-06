(* A lazy stream of values of type 'a.
   Instead of loading the whole input into memory at once, each element is
   produced on demand using a thunk (a function of type unit -> 'a mystream).

   'End'         = the stream is empty / exhausted
   'Cons(h, tf)' = the next element is h; calling tf() gives the rest of the stream *)
type 'a mystream =
    End
  | Cons of 'a * (unit -> 'a mystream)

(* Returns the first element of the stream.
   Raises Failure "empty" if the stream is empty. *)
let hd = function
    End -> failwith "empty"
  | Cons(h, _) -> h

(* Returns the rest of the stream (everything after the first element).
   Raises Failure "empty" if the stream is empty.
   Note: this returns a thunk — call it with () to get the next stream. *)
let tl = function
    End -> failwith "empty"
  | Cons(_, t) -> t

(* Converts a string into a lazy character stream.
   e.g. string_stream "hi" produces:
     Cons('h', fun () -> Cons('i', fun () -> End)) *)
let string_stream s =
  let rec iter n =
    if n >= String.length s then End
    else Cons (s.[n], fun () -> iter (n + 1))
  in
  iter 0
