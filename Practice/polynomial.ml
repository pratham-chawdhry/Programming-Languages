module type POLYNOMIAL = sig
  type t = (int * int) list

  val eval : t -> int -> int
  val add : t -> t -> t -> t
  (* val derivative : t -> t *)
end

module Polynomial : POLYNOMIAL = struct
  type t = (int * int) list

  let rec eval t num = 
    let rec power num exp = 
      if exp = 0 then 1
      else num * power num (exp - 1)
    in
    match t with 
    | [] -> 0
    | h :: t -> 
      match h with 
      | a, b -> a * power num b 
  
  let rec add lst1 lst2 result =
    match lst1, lst2 with
    | [], [] ->
        result

    | [], (c,d)::t2 ->
        let result = add [] t2 result in
        (c,d) :: result

    | (a,b)::t1, [] ->
        let result = add t1 [] result in
        (a,b) :: result

    | (a,b)::t1, (c,d)::t2 ->
        if b = d then
          let result = add t1 t2 result in
          (a + c, b) :: result

        else if b < d then
          let result = add lst1 t2 result in
          (c,d) :: result

        else
          let result = add t1 lst2 result in
          (a,b) :: result
    
end