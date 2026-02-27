module type PairComp = sig
  type t

  val (>) : t -> t -> bool
  val (<) : t -> t -> bool
  val (=) : t -> t -> bool
end

module IntComp : (PairComp with type t = int) = struct
  type t = int

  let (<) = (<)
  let (=) = (=)
  let (>) = (>)
end

type date = { day : int; month : int ; year : int }

module DateComp : (PairComp with type t = date) = struct
  type t = date

  let (<) d1 d2 = 
    if d1.year < d2.year then true
    else if d1.year > d2.year then false
    else 
      if d1.month < d2.month then true
      else if d1.month > d2.month then false
      else 
        if d1.day < d2.day then true
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

module type PAIR = sig
  type elt
  type t

  val newpair : elt -> elt -> t
  val first : elt * elt -> elt
  val second : elt * elt -> elt
  val ascending : elt * elt -> t
  val descending : elt * elt -> t
end

module Pair(C : PairComp) : PAIR
  with type elt = C.t and type t = C.t * C.t = struct
    type elt = C.t 
    type t = elt*elt
    
    let newpair x y = (x, y)

    let first (f, _) = f
    let second (_, s) = s

    let ascending (f, s) = 
      if C.(>) f s then (s, f)
      else (f, s)
    
    let descending (f, s) = 
      if C.(<) f s then (s, f)
      else (f, s)
end