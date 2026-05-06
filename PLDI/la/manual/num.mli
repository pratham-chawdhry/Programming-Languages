(* Interface for the Num scanner module.
   Exposes one function: the FSA that recognises decimal numbers like "1", "3.14", ".5". *)
val num : char Mystream.mystream -> State.state
