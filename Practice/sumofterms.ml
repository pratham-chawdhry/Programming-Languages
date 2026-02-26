module type SUMMATION = sig
  val sum : 
    zero : 'r ->
    term : ('a -> 'r) ->
    next : ('a -> 'a) ->
    plus : ('r -> 'r -> 'r) -> 
    'a ->
    'a ->
    'r
end

module Summation : SUMMATION = struct
  let sum ~zero ~term ~next ~plus a b =
    let rec eval acc curr = 
      if curr > b then acc
      else 
        eval (plus acc (term curr)) (next curr)
  
  in
  eval zero a
end