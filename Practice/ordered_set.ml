module type Comp = sig
  type t
  
  val (<) : t -> t -> bool
  val (>) : t -> t -> bool
  val (=) : t -> t -> bool
end

module IntComp : (Comp with type t = int) = struct
  type t = int

  let (<) = (<)
  let (>) = (>)
  let (=) = (=)
end

type date = {day : int; month : int; year: int}

module DateComp : (Comp with type t = date) = struct
  type t = date

  let (<) d1 d2 =
    if d1.year < d2.year then true
    else if d1.year > d2.year then false
    else if d1.month < d2.month then true
    else if d1.month > d2.month then false
    else if d1.day < d2.day then true
    else false
  
  let (>) d1 d2 =
    if (<) d1 d2 then false
    else if (=) d1 d2 then false
    else true
  
  let (=) d1 d2 =
    if d1.year = d2.year then 
      if d1.month = d2.month then
        if d1.day = d2.day then true
        else false
      else false
    else false
end

module StringComp : (Comp with type t = string) = struct
  type t = string

  let (<) = (<)
  let (>) = (>)
  let (=) = (=)
end


module type SET = sig
  type t
  type elt
  
  (*empty, insert, member, remove, elements*)
  val empty : t
  val insert : elt -> t -> t
  val member : elt -> t -> bool
  val remove : elt -> t -> t
  val elements : t -> elt list  
end

module Set(C : Comp) : SET with type elt = C.t 
and type t = C.t list = struct
  type elt = C.t
  type t = C.t list
  
  let empty = []

  let insert x s = 
    let rec aux s =
      match s with 
      | [] -> [x]
      | h :: t ->
        if C.(<) x h then x :: s
        else if C.(=) x h then s
        else h :: aux t
    in
    aux s
  
  let member x s =
    let rec aux s = 
      match s with 
      | [] -> false
      | h :: t -> 
        if C.(=) x h then true
        else aux t
    in
    aux s

  let remove x s = 
    let rec aux s =
      match s with
      | [] -> []
      | h :: t ->
        if C.(=) x h then t
        else h :: aux t
    in
    aux s

  let elements s = 
    let rec aux s acc = 
      match s with 
      | [] -> acc
      | h :: t ->
        let acc = acc @ [h] in 
        aux t acc
    in
    aux s []
end

module IntSet = Set(IntComp)
module DateSet = Set(DateComp)
module StringSet = Set(StringComp)

let d1 = {day = 1; month = 3; year = 2004}
let d2 = {day = 15; month = 7; year = 2002}
let d3 = {day = 10; month = 1; year = 2004}

let () =
  let s = IntSet.empty in
  let s = IntSet.insert 5 s in
  let s = IntSet.insert 3 s in
  let s = IntSet.insert 8 s in
  let s = IntSet.insert 5 s in  

  Printf.printf "IntSet elements:\n";
  List.iter (fun x -> Printf.printf "%d " x) (IntSet.elements s);
  Printf.printf "\n\n";

  let ds = [] in
  let ds = DateSet.insert d1 ds in
  let ds = DateSet.insert d2 ds in
  let ds = DateSet.insert d3 ds in
  let ds = DateSet.insert d1 ds in

  Printf.printf "DateSet elements:\n";
  List.iter
    (fun d ->
      Printf.printf "%d/%d/%d "
        d.day d.month d.year)
    (DateSet.elements ds);
  Printf.printf "\n\n";

  let ss = StringSet.empty in
  let ss = StringSet.insert "zebra" ss in
  let ss = StringSet.insert "apple" ss in
  let ss = StringSet.insert "mango" ss in
  let ss = StringSet.insert "apple" ss in

  Printf.printf "StringSet elements:\n";
  List.iter (fun s -> Printf.printf "%s " s) (StringSet.elements ss);
  Printf.printf "\n"