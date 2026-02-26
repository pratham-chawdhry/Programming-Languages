type myList = 
    | Empty 
    | Node of int*myList

let reverse lst = 
    let rec trreverse lst acc = 
        match lst with
        | Empty -> acc
        | Node(h, t) -> 
            let acc = h :: acc in 
            trreverse t acc
    in
    let acc = [] in 
    trreverse lst acc

let main () =
  let lst = Node(1, Node(2, Node(3, Node(4, Empty)))) in
  let result = reverse lst in
  
  let str =
    String.concat " "
      (List.map string_of_int result)
  in
  
  print_endline str

let _ = main();;