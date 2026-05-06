module type QUEUE = sig
  type 'a t

  val empty : 'a t
  val push : 'a t -> 'a-> 'a t
  val pop : 'a t -> 'a t
  val front : 'a t -> 'a
  val is_empty : 'a t -> bool
end

module Queue : QUEUE = struct
  type 'a t = 'a list

  let empty = []

  let rec push q x =
    match q with
    | [] -> [x]
    | h :: t -> h :: push t x

  let pop q =
    match q with 
    | [] -> failwith "Cannot pop from an empty queue"
    | _ :: t -> t
    
  let front q = 
    match q with
    | [] -> failwith "No front"
    | h :: _ -> h
  
  let is_empty q =
    match q with
    | [] -> true
    | _ -> false
end

let main () =
  let open Queue in
  let q0 = Queue.empty in
  let q1 = push q0 10 in
  let q2 = push q1 20 in
  let q3 = push q2 30 in

  Printf.printf "Front element: %d\n" (front q3);

  let q4 = pop q3 in
  Printf.printf "Front after pop: %d\n" (front q4)
;;

main ()