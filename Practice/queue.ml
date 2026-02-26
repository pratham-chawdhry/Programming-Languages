module type QUEUE = sig
  type 'a t =
  | Empty
  | Node of 'a * 'a t

  val push : 'a t -> 'a-> 'a t
  val pop : 'a t -> 'a t
  val front : 'a t -> 'a
  val empty : 'a t -> bool
end

module Queue : QUEUE = struct
  type 'a t =
  | Empty
  | Node of 'a * 'a t

  let rec push q x =
  match q with
  | Empty -> Node (x, Empty)
  | Node (h, t) -> Node (h, push t x)

  let pop q =
    match q with 
    | Empty -> failwith "Popping impossible"
    | Node(h, t) -> t
    
  let front q = 
    match q with
    | Empty -> failwith "No front"
    | Node(h, _) -> h
  
  let empty q =
    match q with
    | Empty -> true
    | _ -> false
end