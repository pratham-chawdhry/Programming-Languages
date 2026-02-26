type tree =
  | Empty
  | Node of int * tree * tree

let f x = 2 * x

let rec map f t = 
    match t with
    | Empty -> Empty
    | Node(num, l, r) -> Node(f num, map f l, map f r)

let rec print_tree t =
  match t with
  | Empty -> ()
  | Node(v, l, r) ->
      print_tree l;
      print_int v;
      print_string " ";
      print_tree r

let main () =
  let t =
    Node(2,
      Node(3,
        Node(4, Empty, Empty),
        Empty),
      Node(5,
        Node(6,
          Node(7, Empty, Empty),
          Node(8, Empty, Empty)),
        Empty))
  in
  let result = map f t in
  print_tree result;
  print_newline ()

let _ = main ();;