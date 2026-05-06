(*
  Scanner for identifiers.
  An identifier starts with a letter, followed by zero or more letters or digits.
  Valid:   "A", "Aa", "AaA", "A1", "Aa1", "A1a", "a1"
  Invalid: "1a" (starts with digit), "a_b" (underscore not allowed)

  Design notes: see num.ml for a full explanation of how the State/lazy-evaluation
  design works. This scanner follows exactly the same pattern.
*)

let id (s : char Mystream.mystream) : State.state =
  let is_alpha c = (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')
  and is_digit c = (c >= '0' && c <= '9') in
  let is_alphanum c = (is_alpha c) || (is_digit c) in

  (* State ONE: waiting for the mandatory first letter.
     If the current char is a letter, peek at the lookahead:
       - if the next char is also alphanumeric -> transition to state TWO (more chars expected)
       - if the next char is something else or end -> Terminate(true) (single-letter identifier)
     If the current char is not a letter -> Terminate(false) (not an identifier) *)
  let rec one (stream : char Mystream.mystream) : State.state =
    match stream with
      Mystream.End -> State.Terminate(false)        (* empty input: not an identifier *)
    | Mystream.Cons(c, _) ->
        let lookahead = (Mystream.tl stream) () in  (* peek one character ahead *)
        if is_alpha c then
          match lookahead with
            Mystream.Cons(c', _) ->
              if (is_alphanum c') then
                State.State(two)                    (* more alphanumeric chars follow *)
              else
                State.Terminate(true)               (* single-letter identifier: done *)
          | Mystream.End ->
              State.Terminate(true)                 (* single-letter identifier at end: done *)
        else
          State.Terminate(false)                    (* first char is not a letter: reject *)

  (* State TWO: consuming the rest of the identifier (letters + digits allowed).
     Same lookahead logic: keep going while alphanumeric, stop when something else appears. *)
  and two  (stream : char Mystream.mystream) : State.state =
    match stream with
      Mystream.End -> State.Terminate(true)         (* end of input: identifier complete *)
    | Mystream.Cons(c, _) ->
        let lookahead = (Mystream.tl stream) () in
        if (is_alphanum c) then
           match lookahead with
            Mystream.Cons(c', _) ->
              if (is_alphanum c') then
                State.State(two)                    (* another alphanumeric: stay in state two *)
              else
                State.Terminate(true)               (* next char ends it: done *)
          | Mystream.End -> State.Terminate(true)   (* end of input: identifier complete *)
      else
        State.Terminate(true)                       (* non-alphanumeric char: identifier ended *)
  in
  (* Entry point: if stream is empty reject immediately, otherwise start at state ONE *)
  match s with
    Mystream.End -> State.Terminate(false)
  | _ -> one s
