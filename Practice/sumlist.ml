type mylist = 
    | Empty 
    | Node of int * mylist

let rec sum lst = 
    match lst with 
    | Empty -> 0
    | Node (h, t) -> h + sum t

let tailrecursion lst = 
    let rec sumrec lst acc =
        match lst with 
        | Empty -> acc
        | Node(h, t) -> sumrec t (acc + h)
    in sumrec lst 0

let main () =
  let l = Node (1, Node (2, Node (3, Empty))) in
  
  let result1 = sum l in
  print_endline (string_of_int result1);

  let result2 = tailrecursion l in
  print_endline (string_of_int result2)

let _ = main()