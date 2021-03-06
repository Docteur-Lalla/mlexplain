(*open JsNumber*)  
open JsSyntax
open LibList

let int_of_native_error e =
  match e with
  | Coq_native_error_eval -> 1
  | Coq_native_error_range -> 2
  | Coq_native_error_ref -> 3
  | Coq_native_error_syntax -> 4
  | Coq_native_error_type -> 5
  | Coq_native_error_uri -> 6

let int_of_mathop o =
   match o with
   | Coq_mathop_abs -> 1

let int_of_prealloc p =
  match p with
  | Coq_prealloc_global -> 1
  | Coq_prealloc_global_eval -> 2
  | Coq_prealloc_global_parse_int -> 3
  | Coq_prealloc_global_parse_float -> 4
  | Coq_prealloc_global_is_finite -> 5
  | Coq_prealloc_global_is_nan -> 6
  | Coq_prealloc_global_decode_uri -> 7
  | Coq_prealloc_global_decode_uri_component -> 8
  | Coq_prealloc_global_encode_uri -> 9
  | Coq_prealloc_global_encode_uri_component -> 10
  | Coq_prealloc_object -> 11
  | Coq_prealloc_object_get_proto_of -> 12
  | Coq_prealloc_object_get_own_prop_descriptor -> 13
  | Coq_prealloc_object_get_own_prop_name -> 14
  | Coq_prealloc_object_create -> 15
  | Coq_prealloc_object_define_prop -> 16
  | Coq_prealloc_object_define_props -> 17
  | Coq_prealloc_object_seal -> 18
  | Coq_prealloc_object_freeze -> 19
  | Coq_prealloc_object_prevent_extensions -> 20
  | Coq_prealloc_object_is_sealed -> 21
  | Coq_prealloc_object_is_frozen -> 22
  | Coq_prealloc_object_is_extensible -> 23
  | Coq_prealloc_object_keys -> 24
  | Coq_prealloc_object_keys_call -> 25
  | Coq_prealloc_object_proto -> 26
  | Coq_prealloc_object_proto_to_string -> 27
  | Coq_prealloc_object_proto_value_of -> 28
  | Coq_prealloc_object_proto_has_own_prop -> 29
  | Coq_prealloc_object_proto_is_prototype_of -> 30
  | Coq_prealloc_object_proto_prop_is_enumerable -> 31
  | Coq_prealloc_function -> 32
  | Coq_prealloc_function_proto -> 33
  | Coq_prealloc_function_proto_to_string -> 34
  | Coq_prealloc_function_proto_apply -> 35
  | Coq_prealloc_function_proto_call -> 36
  | Coq_prealloc_function_proto_bind -> 37
  | Coq_prealloc_bool -> 38
  | Coq_prealloc_bool_proto -> 39
  | Coq_prealloc_bool_proto_to_string -> 40
  | Coq_prealloc_bool_proto_value_of -> 41
  | Coq_prealloc_number -> 42
  | Coq_prealloc_number_proto -> 43
  | Coq_prealloc_number_proto_to_string -> 44
  | Coq_prealloc_number_proto_value_of -> 45
  | Coq_prealloc_number_proto_to_fixed -> 46
  | Coq_prealloc_number_proto_to_exponential -> 47
  | Coq_prealloc_number_proto_to_precision -> 48
  | Coq_prealloc_array -> 49
  | Coq_prealloc_array_is_array -> 50
  | Coq_prealloc_array_proto -> 51
  | Coq_prealloc_array_proto_to_string -> 52
  | Coq_prealloc_array_proto_join -> 53
  | Coq_prealloc_array_proto_pop -> 54
  | Coq_prealloc_array_proto_push -> 55
  | Coq_prealloc_string -> 56
  | Coq_prealloc_string_proto -> 57
  | Coq_prealloc_string_proto_to_string -> 58
  | Coq_prealloc_string_proto_value_of -> 59
  | Coq_prealloc_string_proto_char_at -> 60
  | Coq_prealloc_string_proto_char_code_at -> 61
  | Coq_prealloc_math -> 62
  | Coq_prealloc_date -> 63
  | Coq_prealloc_regexp -> 64
  | Coq_prealloc_error -> 65
  | Coq_prealloc_error_proto -> 66
  | Coq_prealloc_error_proto_to_string -> 67
  | Coq_prealloc_throw_type_error -> 68
  | Coq_prealloc_json -> 69
  | Coq_prealloc_mathop o -> 100 + int_of_mathop o
  | Coq_prealloc_native_error e -> 200 + int_of_native_error e
  | Coq_prealloc_native_error_proto e -> 300 + int_of_native_error e

let prealloc_cmp p1 p2 =
  int_compare (int_of_prealloc p1) (int_of_prealloc p2)

let object_loc_cmp l1 l2 =
   match l1 with
   | Coq_object_loc_normal n1 ->
      begin match l2 with 
      | Coq_object_loc_normal n2 -> int_compare n1 n2
      | Coq_object_loc_prealloc p2 -> 1
      end
   | Coq_object_loc_prealloc p1 ->
      begin match l2 with 
      | Coq_object_loc_normal n2 -> -1
      | Coq_object_loc_prealloc p2 -> prealloc_cmp p1 p2
      end

(** val object_create :
    value -> class_name -> bool -> object_properties_type -> coq_object **)

let object_create vproto sclass bextens p =
  { object_proto_ = vproto; object_class_ = sclass; object_extensible_ =
    bextens; object_prim_value_ = None; object_properties_ = p; object_get_ =
    Coq_builtin_get_default; object_get_own_prop_ =
    Coq_builtin_get_own_prop_default; object_get_prop_ =
    Coq_builtin_get_prop_default; object_put_ = Coq_builtin_put_default;
    object_can_put_ = Coq_builtin_can_put_default; object_has_prop_ =
    Coq_builtin_has_prop_default; object_delete_ =
    Coq_builtin_delete_default; object_default_value_ =
    Coq_builtin_default_value_default; object_define_own_prop_ =
    Coq_builtin_define_own_prop_default; object_construct_ = None;
    object_call_ = None; object_has_instance_ = None; object_scope_ = None;
    object_formal_parameters_ = None; object_code_ = None;
    object_target_function_ = None; object_bound_this_ = None;
    object_bound_args_ = None; object_parameter_map_ = None }

(** val object_set_proto : coq_object -> value -> coq_object **)

let object_set_proto o v =
  { o with object_proto_ = v }

(** val object_set_class : coq_object -> class_name -> coq_object **)

let object_set_class o s =
  { o with object_class_ = s }

(** val object_set_extensible : coq_object -> bool -> coq_object **)

let object_set_extensible o b =
  { o with object_extensible_ = b }

(** val object_with_primitive_value : coq_object -> value -> coq_object **)

let object_with_primitive_value o v =
  { o with object_prim_value_ = (Some v) }

(** val object_with_extension : coq_object -> bool -> coq_object **)

let object_with_extension o b =
  { o with object_extensible_ = b }

(** val object_with_properties :
    coq_object -> object_properties_type -> coq_object **)

let object_with_properties o properties =
  { o with object_properties_ = properties }

(** val object_with_get : coq_object -> builtin_get -> coq_object **)

let object_with_get o g =
  { o with object_get_ = g }

(** val object_with_get_own_property :
    coq_object -> builtin_get_own_prop -> coq_object **)

let object_with_get_own_property o gop =
  { o with object_get_own_prop_ = gop }

(** val object_with_invokation :
    coq_object -> construct option -> call option -> builtin_has_instance
    option -> coq_object **)

let object_with_invokation o constr call0 has_instance =
  { o with object_construct_ = constr; object_call_ = call0;
    object_has_instance_ = has_instance }

(** val object_with_scope :
    coq_object -> lexical_env option -> coq_object **)

let object_with_scope o scope =
  { o with object_scope_ = scope }

(** val object_with_formal_params :
    coq_object -> string list option -> coq_object **)

let object_with_formal_params o params =
  { o with object_formal_parameters_ = params }

(** val object_with_details :
    coq_object -> lexical_env option -> string list option -> funcbody
    option -> object_loc option -> value option -> value list option ->
    object_loc option -> coq_object **)

let object_with_details o scope params code target boundthis boundargs paramsmap =
  { o with object_scope_ = scope; object_formal_parameters_ = params;
    object_code_ = code; object_target_function_ = target;
    object_bound_this_ = boundthis; object_bound_args_ = boundargs;
    object_parameter_map_ = paramsmap }

(** val object_for_array :
    coq_object -> builtin_define_own_prop -> coq_object **)

let object_for_array o defineownproperty =
  { o with object_define_own_prop_ = defineownproperty }

(** val object_for_args_object :
    coq_object -> object_loc -> builtin_get -> builtin_get_own_prop ->
    builtin_define_own_prop -> builtin_delete -> coq_object **)

let object_for_args_object o paramsmap get getownproperty defineownproperty delete_prop =
  { o with object_get_ = get; object_get_own_prop_ = getownproperty;
    object_delete_ = delete_prop; object_define_own_prop_ = defineownproperty;
    object_parameter_map_ = (Some paramsmap) }

(** val mathop_compare : mathop -> mathop -> bool **)

let mathop_compare m1 m2 = (m1:mathop) === m2

(* NEVER USED
    (** val native_error_compare : native_error -> native_error -> bool **)

  let native_error_compare ne1 ne2 = (ne1:native_error) === ne2

*)

(** val prealloc_compare : prealloc -> prealloc -> bool **)

let prealloc_compare bl1 bl2 = (bl1:prealloc) === bl2


(** val object_loc_compare : object_loc -> object_loc -> bool **)

let object_loc_compare l1 l2 =
  match l1 with
  | Coq_object_loc_normal ln1 ->
    (match l2 with
     | Coq_object_loc_normal ln2 -> nat_eq ln1 ln2
     | Coq_object_loc_prealloc p -> false)
  | Coq_object_loc_prealloc bl1 ->
    (match l2 with
     | Coq_object_loc_normal n -> false
     | Coq_object_loc_prealloc bl2 -> prealloc_compare bl1 bl2)

(** val prim_compare : prim -> prim -> bool **)

let prim_compare w1 w2 =
  match w1 with
  | Coq_prim_undef ->
    (match w2 with
     | Coq_prim_undef -> true
     | _ -> false)
  | Coq_prim_null ->
    (match w2 with
     | Coq_prim_null -> true
     | _ -> false)
  | Coq_prim_bool b1 ->
    (match w2 with
     | Coq_prim_bool b2 -> bool_eq b1 b2
     | _ -> false)
  | Coq_prim_number n1 ->
    (match w2 with
     | Coq_prim_number n2 -> n1 === n2
     | _ -> false)
  | Coq_prim_string s1 ->
    (match w2 with
     | Coq_prim_string s2 -> string_eq s1 s2
     | _ -> false)

(** val value_compare : value -> value -> bool **)

let value_compare v1 v2 =
  match v1 with
  | Coq_value_prim w1 ->
    (match v2 with
     | Coq_value_prim w2 -> prim_compare w1 w2
     | Coq_value_object o -> false)
  | Coq_value_object l1 ->
    (match v2 with
     | Coq_value_prim p -> false
     | Coq_value_object l2 -> object_loc_compare l1 l2)

(** val mutability_compare : mutability -> mutability -> bool **)

let mutability_compare m1 m2 = (m1:mutability) === m2

(** val ref_base_type_compare : ref_base_type -> ref_base_type -> bool **)

let ref_base_type_compare rb1 rb2 =
  match rb1 with
  | Coq_ref_base_type_value v1 ->
    (match rb2 with
     | Coq_ref_base_type_value v2 -> value_compare v1 v2
     | Coq_ref_base_type_env_loc e -> false)
  | Coq_ref_base_type_env_loc l1 ->
    (match rb2 with
     | Coq_ref_base_type_value v -> false
     | Coq_ref_base_type_env_loc l2 -> nat_eq l1 l2)

(** val ref_compare : ref -> ref -> bool **)

let ref_compare r1 r2 =
    (ref_base_type_compare r1.ref_base r2.ref_base)
 && (string_eq r1.ref_name r2.ref_name)
 && (bool_eq r1.ref_strict r2.ref_strict)

(** val type_compare : coq_type -> coq_type -> bool **)

let type_compare t1 t2 = (t1:coq_type) === t2

(** val res_with_value : res -> resvalue -> res **)

let res_with_value r rv =
  { r with res_value = rv }

(** val resvalue_compare : resvalue -> resvalue -> bool **)

let resvalue_compare rv1 rv2 =
  match rv1 with
  | Coq_resvalue_empty ->
    (match rv2 with
     | Coq_resvalue_empty -> true
     | Coq_resvalue_value v -> false
     | Coq_resvalue_ref r -> false)
  | Coq_resvalue_value v1 ->
    (match rv2 with
     | Coq_resvalue_empty -> false
     | Coq_resvalue_value v2 -> value_compare v1 v2
     | Coq_resvalue_ref r -> false)
  | Coq_resvalue_ref r1 ->
    (match rv2 with
     | Coq_resvalue_empty -> false
     | Coq_resvalue_value v -> false
     | Coq_resvalue_ref r2 -> ref_compare r1 r2)

(** val binary_op_compare : binary_op -> binary_op -> bool **)

let rec binary_op_compare op1 op2 = (op1:binary_op) === op2

(** val prog_intro_strictness : prog -> strictness_flag **)

let prog_intro_strictness p = match p with
| Coq_prog_intro (str, els) -> str

(** val prog_elements : prog -> element list **)

let prog_elements p = match p with
| Coq_prog_intro (str, els) -> els

(** val funcbody_prog : funcbody -> prog **)

let funcbody_prog fb = match fb with
| Coq_funcbody_intro (p, s) -> p

(** val funcbody_is_strict : funcbody -> strictness_flag **)

let funcbody_is_strict fb = match fb with
| Coq_funcbody_intro (p, s) ->
  match p with
  | Coq_prog_intro (b_strict, l) -> b_strict

(** val restype_compare : restype -> restype -> bool **)

let restype_compare rt1 rt2 = (rt1:restype) === rt2

(** val label_compare : label -> label -> bool **)

let label_compare lab1 lab2 =
  match lab1 with
  | Coq_label_empty ->
    (match lab2 with
     | Coq_label_empty -> true
     | Coq_label_string s -> false)
  | Coq_label_string s1 ->
    (match lab2 with
     | Coq_label_empty -> false
     | Coq_label_string s2 -> string_eq s1 s2)

(** val label_set_empty : label_set **)

let label_set_empty =
  []

(** val label_set_add : label -> label list -> label list **)

let label_set_add lab labs =
  lab :: labs

(** val label_set_add_empty : label list -> label list **)

let label_set_add_empty labs =
  label_set_add Coq_label_empty labs

(** val label_set_mem : label -> label list -> bool **)

let label_set_mem lab labs =
  mem_decide label_compare lab labs

(** val attributes_data_with_value :
    attributes_data -> value -> attributes_data **)

let attributes_data_with_value ad v' =
  { ad with attributes_data_value = v' }

(** val descriptor_with_value : descriptor -> value option -> descriptor **)

let descriptor_with_value desc v' =
  { desc with descriptor_value = v' }

(** val descriptor_with_writable :
    descriptor -> bool option -> descriptor **)

let descriptor_with_writable desc bw' =
  { desc with descriptor_writable = bw' }

(** val descriptor_with_get : descriptor -> value option -> descriptor **)

let descriptor_with_get desc vg' =
  { desc with descriptor_get = vg' }

(** val descriptor_with_set : descriptor -> value option -> descriptor **)

let descriptor_with_set desc vs' =
  { desc with descriptor_set = vs' }

(** val descriptor_with_enumerable :
    descriptor -> bool option -> descriptor **)

let descriptor_with_enumerable desc be' =
  { desc with descriptor_enumerable = be' }

(** val descriptor_with_configurable :
    descriptor -> bool option -> descriptor **)

let descriptor_with_configurable desc bc' =
  { desc with descriptor_configurable = bc' }

(** val codetype_compare : codetype -> codetype -> bool **)

let codetype_compare ct1 ct2 = (ct1:codetype) === ct2
