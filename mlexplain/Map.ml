(** Type representing a pair in a map *)
type ('k, 'v) binding = {
  key : 'k ;
  value : 'v
}

(** Alias for an equality-test function *)
type 'a equality_test = 'a -> 'a -> bool

(** The actual map datatype *)
type ('a, 'b) map = {
  eq : 'a equality_test ;
  show : 'a -> string ;
  bindings : ('a, 'b) binding list
}

(** Create a map with the given equality-test function *)
let empty_map eq show = { eq = eq ; show = show ; bindings = [] }

(** Accessors *)
let key_from_binding b = b.key
let value_from_binding b = b.value

(** Retrieve the value associated with the given key in the map *)
let rec find key m = match m.bindings with
| [] ->
  let err_msg = strappend "Could not find key '" (strappend (m.show key) "' in map") in
  Unsafe.error err_msg
| h :: t ->
  if m.eq h.key key then
    Unsafe.box h.value
  else
    find key { m with bindings = t }

(** Check if the given key exists in the map *)
let rec mem key m = match m.bindings with
| [] -> false
| h :: t -> m.eq key h.key || mem key { m with bindings = t }

(** Add the pair (key, value) in the map *)
let add key value m =
  (** Replace the value at the given key by the new one or do nothing if the key does not exist in the map *)
  let rec replace key value m = match m.bindings with
  | [] -> m
  | h :: t ->
    if m.eq h.key key then
      let pair = { key = key ; value = value } in
      { m with bindings = pair :: t }
    else
      let m' = replace key value { m with bindings = t } in
      { m' with bindings = h :: m'.bindings } in

  if mem key m then
    replace key value m
  else
    { m with bindings = { key = key ; value = value } :: m.bindings }

(** Left-biased union of the two maps *)
let rec union m1 m2 = match m1.bindings with
| [] -> m2
| h :: t ->
  let m1' = { m1 with bindings = t } in
  let m2' = add h.key h.value m2 in
  union m1' m2'

(** Apply the function on every element in the map *)
let rec map f m = match m.bindings with
| [] -> empty_map m.eq m.show
| h :: t ->
  let h' = { key = h.key ; value = f h.value } in
  let m' = map f { m with bindings = t } in
  { m' with bindings = h' :: m'.bindings }

(** Remove the pair identified with the given key from the map *)
let rec remove key m = match m.bindings with
| [] -> m
| h :: t ->
  let m' = { m with bindings = t } in
  if m.eq h.key key then
    m'
  else
    let mres = remove key m' in
    { mres with bindings = h :: mres.bindings }

(** Get a list of the values stored in the map *)
let rec elems m = match m.bindings with
| [] -> []
| h :: t -> h.value :: elems { m with bindings = t }
