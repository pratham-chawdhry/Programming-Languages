(*
  Scanner for the keyword 'in' (as used in "let x = e1 in e2").

  It must NOT match 'inn', 'in1', 'into', etc. — those are identifiers.
  So after matching 'i' then 'n', it peeks at the next character:
    - if the next char is alphanumeric, this is an identifier, not the keyword -> reject
    - if the next char is something else (space, end of input, operator) -> accept as IN

  Design: same State / lazy-lookahead pattern as num.ml. Two states: one, two.
*)

let keywd_in (s : char Mystream.mystream) : State.state =
  let is_alpha c = (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')
  and is_digit c = (c >= '0' && c <= '9') in
  let is_alphanum c = (is_alpha c) || (is_digit c) in

  (* State ONE: expecting the letter 'i'.
     Any other character immediately rejects. *)
  let rec one (stream : char Mystream.mystream) : State.state =
    match stream with
      Mystream.End -> State.Terminate(false)         (* empty: can't be 'in' *)
    | Mystream.Cons(c, _) ->
        let lookahead = (Mystream.tl stream) () in
        if c = 'i' then
          match lookahead with
            Mystream.Cons(c', _) ->
              if (c' = 'n') then
                State.State(two)                     (* 'i' seen, next is 'n': go to state two *)
              else
                State.Terminate(false)               (* 'i' seen but next is not 'n': reject *)
          | Mystream.End ->
              State.Terminate(false)                 (* only 'i', nothing after: reject *)
        else
          State.Terminate(false)                     (* not 'i': reject *)

  (* State TWO: we've seen 'i', now expecting 'n'.
     After matching 'n', peek ahead: if more alphanumeric chars follow,
     this is actually an identifier (e.g. "into"), so reject. *)
  and two  (stream : char Mystream.mystream) : State.state =
    match stream with
      Mystream.End -> State.Terminate(true)          (* stream ended right after 'i': only "i", reject? handled above. *)
    | Mystream.Cons(c, _) ->
        let lookahead = (Mystream.tl stream) () in
        if (c = 'n') then
           match lookahead with
            Mystream.Cons(c', _) ->
              if (is_alphanum c') then
                State.Terminate(false)               (* "in" followed by alphanumeric: it's an identifier, not keyword *)
              else
                State.Terminate(true)                (* "in" followed by non-alphanum (e.g. space): it's the keyword *)
          | Mystream.End -> State.Terminate(true)    (* "in" at end of input: accept *)
        else
          State.Terminate(false)                     (* expected 'n' but got something else: reject *)
  in
  match s with
    Mystream.End -> State.Terminate(false)
  | _ -> one s
