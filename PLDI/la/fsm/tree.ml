(* A rose tree: each node holds an int value and a list (forest) of child trees.
   'Leaf' is an empty node with no value and no children.
   'Node(v, f)' is a node holding value v with children given by forest f. *)
type tree =
  | Leaf
  | Node of int * forest

(* A forest is a sequence of trees (like a linked list of trees).
   'Empty'       = no children
   'Cons(t, f)' = tree t followed by the rest of the forest f *)
and forest =
  | Empty
  | Cons of tree * forest

(* An example tree:
       10
      /  \
     5    3
          |
         Leaf
*)
let example_tree =
  Node (10,
    Cons (
      Node (5, Empty),
      Cons (
        Node (3,
          Cons (Leaf, Empty)
        ),
        Empty
      )
    )
  )

(* Sums all integer values in a tree.
   Leaf contributes 0.
   Node(v, f) contributes v + sum of all values in the forest f. *)
let rec sum_tree t =
  match t with
  | Leaf -> 0
  | Node (v, f) -> v + sum_forest f

(* Sums all integer values across a forest (list of trees). *)
and sum_forest f =
  match f with
  | Empty -> 0
  | Cons (t, rest) -> sum_tree t + sum_forest rest
