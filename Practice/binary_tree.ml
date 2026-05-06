type 'a bintree =
  | Empty 
  | Node of 'a * 'a bintree * 'a bintree

let tree = 
  Node(
    1,
    Node(
      2,
      Node(
        4,
        Empty,
        Empty
      ),
      Node(
        5, 
        Empty,
        Empty
      )
    ),
    Node(
      3,
      Node(
        6,
        Empty,
        Empty
      ),
      Empty
    )
  )

let rec inordertraversal t lst = 
  match t with
  | Empty -> lst
  | Node(n, l, r) -> 
    let lst = inordertraversal l lst in
    let lst = lst @ [n] in
    inordertraversal r lst 
