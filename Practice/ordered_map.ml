module type ORDERED = sig
  type t
  val compare : t -> t -> int
end


module Map (K : ORDERED) : sig
  type key = K.t
  type 'a t
  val empty : 'a t
  val insert : key -> 'a -> 'a t -> 'a t
  val find : key -> 'a t -> 'a option
  val remove : key -> 'a t -> 'a t
end = struct

  type key = K.t

  (* sorted association list *)
  type 'a t = (key * 'a) list

  let empty = []

  let rec insert k v m =
    match m with
    | [] -> [(k, v)]
    | (k', v') :: t ->
        let c = K.compare k k' in
        if c = 0 then
          (k, v) :: t                 (* replace *)
        else if c < 0 then
          (k, v) :: m                 (* insert before *)
        else
          (k', v') :: insert k v t    (* continue *)

  let rec find k m =
    match m with
    | [] -> None
    | (k', v') :: t ->
        let c = K.compare k k' in
        if c = 0 then Some v'
        else if c < 0 then None
        else find k t

  let rec remove k m =
    match m with
    | [] -> []
    | (k', v') :: t ->
        let c = K.compare k k' in
        if c = 0 then t
        else if c < 0 then m
        else (k', v') :: remove k t

end