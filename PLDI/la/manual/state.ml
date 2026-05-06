(* The return type used by every scanner (FSA) in the manual lexer.
   A scanner, after consuming one character, either:

   - Terminate(true)  : the scanner has matched a valid token successfully.
                        Stop — the current lexeme is accepted.
   - Terminate(false) : the scanner has failed to match.
                        Stop — discard this scanner.
   - State(f)         : the scanner is still running and needs more input.
                        f is the next state function to call with the next character. *)
type state =
    Terminate of bool
  | State of (char Mystream.mystream -> state)
