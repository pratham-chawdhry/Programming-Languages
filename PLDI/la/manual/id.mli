(* Interface for the Id scanner module.
   Exposes one function: the FSA that recognises identifiers [a-zA-Z][a-zA-Z0-9]* *)
val id : char Mystream.mystream -> State.state
