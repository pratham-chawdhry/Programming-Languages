(* Interface for the In scanner module.
   Exposes one function: the FSA that recognises the keyword "in". *)
val keywd_in : char Mystream.mystream -> State.state
