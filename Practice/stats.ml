module type OPPS = sig
  type number =
    | Int of int
    | Float of float

  val length : number list -> int
  val add : number list -> number
  val multiply : number list -> number
end

module Opps : OPPS = struct
  type number =
    | Int of int
    | Float of float

  let rec length lst = 
    match lst with 
    | [] -> 0
    | h :: t -> 1 + length(t)
    
  let add_two a b = 
    match (a, b) with
    | Int x, Int y -> Int(x + y)
    | Int x, Float y -> Float(float_of_int(x) +. y)
    | Float x, Int y -> Float(x +. float_of_int(y))
    | Float x, Float y -> Float(x +. y)

  let multiply_two a b = 
    match (a, b) with
    | Int x, Int y -> Int(x * y)
    | Int x, Float y -> Float(float_of_int(x) *. y)
    | Float x, Int y -> Float(x *. float_of_int(y))
    | Float x, Float y -> Float(x *. y)

  let add lst =
  List.fold_left add_two (Int 0) lst

  let multiply lst =
  List.fold_left multiply_two (Int 1) lst
end