(*
  Scanner for decimal numbers.
  Valid:   "1", "1.1", "11.1", "11.11", ".11"
  Invalid: ".", "1.", "B"

  HOW IT WORKS (design notes):

  LAZY EVALUATION:
  Instead of consuming the entire token at once, each state function reads one
  character and then returns either:
    - State(f)         -> "I'm still going, call f with the next char"
    - Terminate(true)  -> "I found a valid token, stop here"
    - Terminate(false) -> "This is not my token, stop and discard me"
  This decouples the FSM from the lexer's job of choosing the longest/best token.

  LOOKAHEAD:
  Each state peeks one character ahead (the 'lookahead' variable) to decide
  whether to keep going or terminate. This is "k=1 lookahead", standard for lexers.

  STATES:
    one   = integer digits before the decimal point (or a leading '.')
    two   = the first digit immediately after the '.'
    three = further digits after the decimal point

  State transitions:
    one   --digit--> one      (more integer digits)
    one   --'.'--->  two      (decimal point seen, need at least one digit after)
    two   --digit--> three    (first digit after '.')
    three --digit--> three    (more digits after '.')
*)

let num (s : char Mystream.mystream) : State.state =
  let is_digit c = (c >= '0' && c <= '9') in

  (* State ONE: reading integer digits, or a leading '.' *)
  let rec one (stream : char Mystream.mystream) : State.state =
    match stream with
      Mystream.End -> State.Terminate(true)          (* end of input: just digits, accept *)
    | Mystream.Cons(c, _) ->
        let lookahead = (Mystream.tl stream) () in
        if (is_digit c) then
          match lookahead with
            Mystream.Cons(c', _) ->
              if (is_digit c') || (c' = '.') then
                State.State(one)                     (* digit or dot next: keep reading *)
              else
                State.Terminate(true)                (* end of number: accept *)
          | Mystream.End -> State.Terminate(true)    (* last char was a digit: accept *)
        else if c = '.' then
          match lookahead with
            Mystream.Cons(c', _) ->
              if (is_digit c') then
                State.State(two)                     (* '.' followed by digit: go to state two *)
              else
                State.Terminate(false)               (* '.' followed by non-digit: reject ("1." is invalid) *)
          | Mystream.End -> State.Terminate(false)   (* '.' at end of input: reject *)
        else
          State.Terminate(false)                     (* not a digit or '.': reject *)

  (* State TWO: we just saw '.', now we need at least one digit *)
  and two (stream : char Mystream.mystream) : State.state =
    match stream with
      Mystream.End -> State.Terminate(false)         (* '.' with no digit after it: reject *)
    | Mystream.Cons(c, _) ->
        let lookahead = (Mystream.tl stream) () in
        if (is_digit c) then
          match lookahead with
            Mystream.Cons(c', _) ->
              if (is_digit c') then
                State.State(three)                   (* more digits follow: go to state three *)
              else
                State.Terminate(true)                (* single digit after '.': accept (e.g. ".5") *)
          | Mystream.End -> State.Terminate(true)    (* only one digit after '.': accept *)
        else
          State.Terminate(false)                     (* non-digit immediately after '.': reject *)

  (* State THREE: reading further digits after the decimal point *)
  and three (stream : char Mystream.mystream) : State.state =
    match stream with
      Mystream.End -> State.Terminate(true)          (* end of input: accept *)
    | Mystream.Cons(c, _) ->
        let lookahead = (Mystream.tl stream) () in
        if (is_digit c) then
           match lookahead with
            Mystream.Cons(c', _) ->
              if (is_digit c') then
                State.State(three)                   (* another digit: stay in state three *)
              else
                State.Terminate(true)                (* end of decimal digits: accept *)
          | Mystream.End -> State.Terminate(true)    (* last digit: accept *)
        else
          State.Terminate(false)                     (* non-digit in middle of decimal part: reject *)
  in
  (* Entry point: empty stream cannot be a number *)
  match s with
    Mystream.End -> State.Terminate(false)
  | _            -> one s
