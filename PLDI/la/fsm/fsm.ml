(* Converts a string into a list of characters.
   e.g. "abc" -> ['a'; 'b'; 'c']
   Needed because OCaml strings are not lists, but pattern matching works on lists. *)
let list_of_string s =
  let rec iter i s =
    if i = (String.length s) then []
    else s.[i] :: (iter (i + 1)) s
  in
  iter 0 s

(* FSM 1: one_zero
   Accepts lists of ints where all 1s appear before all 0s.
   e.g. [1;1;0;0] -> true
        [0;1]     -> false
        []        -> true  (empty string is accepted)

   States:
     init   = starting state; expects 1s
     accept = seen at least one 1; now accepting 0s or more 1s *)
let one_zero lst =
  let rec init l =
    match l with
      [] -> true                                     (* empty input: accept *)
    | h :: t -> if h = 1 then (accept t) else false  (* must start with a 1 *)

  and accept l =
    match l with
      [] -> true                     (* end of input: accept *)
    | h :: t ->
      if h = 0 then (init t)         (* 0 seen: loop back to init state *)
      else if h = 1  then (accept t) (* another 1: stay in accept state *)
      else false                     (* anything else: reject *)
  in
  init lst                           (* start from the initial state *)


(* FSM 2: id
   Accepts strings that are valid identifiers:
     - Must start with a letter (a-z or A-Z)
     - Followed by zero or more letters or digits
   e.g. "x"      -> true
        "myVar"   -> true
        "foo42"   -> true
        "123abc"  -> false  (starts with a digit)
        "_x"      -> false  (underscore not allowed)

   States:
     one = start state; exactly one letter required
     two = rest of identifier; letters and digits allowed *)
let id s =
  let rec one l =
    match l with
      [] -> false                 (* empty string is not a valid identifier *)
    | h :: t ->
      if (h >= 'A' && h <= 'Z') || (h >= 'a' && h <= 'z') then
        (two t)                   (* first char is a letter: move to state two *)
      else
        false                     (* first char is not a letter: reject *)

  and two l =
    match l with
      [] -> true                  (* end of input after at least one letter: accept *)
    | h :: t ->
      if (h >= 'A' && h <= 'Z') || (h >= 'a' && h <= 'z') || (h >= '0' && h <= '9') then
        (two t)                   (* letter or digit: stay in state two *)
      else
        false                     (* anything else (e.g. '_', space): reject *)
  in
  one (list_of_string s)          (* convert string to char list, then run FSM *)
