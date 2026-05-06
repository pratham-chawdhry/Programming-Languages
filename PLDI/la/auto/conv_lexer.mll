(* Word-frequency counter built with ocamllex.
   Reads text from stdin, counts how often each word appears,
   and prints a sorted frequency table.

   This demonstrates how to use ocamllex as a standalone tool
   (without a parser) — the "Part 3" code section does all the work. *)

(* ── Part 1: OCaml code included at the top of the generated lexer ── *)
{
exception Lexer_exception of string

(* Token type: either an identifier (word) or end-of-file *)
type token =
    Id of string    (* a word made of letters/digits *)
  | EOF             (* end of input *)
}

(* ── Part 2: Regular expressions and lexing rules ──────────────────── *)
let digit = ['0'-'9']
let integer = ['0'-'9']['0'-'9']*
let id = ['a'-'z''A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9']*  (* a word *)

(* The scanner: returns one token at a time *)
rule scan_words = parse
  | id as s {  Id(s) }           (* found a word *)
  | eof     { EOF  }             (* end of input *)
  | _       { scan_words lexbuf } (* skip non-word characters (spaces, punctuation, etc.) *)

(* ── Part 3: Application code ─────────────────────────────────────── *)
(* Normally this section is empty when the lexer is paired with a parser.
   Here we use it to build a complete word-frequency utility. *)
{

(* Print every entry in a hash table: word -> count *)
let print_table t =
  (Hashtbl.iter (fun key value -> (Printf.printf "%s %d\n" key !value)) t)

(* Generic list printer *)
let print_list l p = print_newline (); List.iter p l

(* Sort a hash table into an association list by count (ascending) *)
let sort_table t =
  let assoc_list = (Hashtbl.fold (fun k v acc -> (k, !v) :: acc) t []) in
    List.sort
      (
        fun (k1, v1) (k2, v2) -> if v1 > v2 then 1 else if v1 < v2 then -1 else 0
      ) assoc_list

(* Common English words to ignore (stop words) *)
let reject_words = [ "let"; "the"; "is"; "for"; "I"; "in"; "on"; "upon"; "between"; "under"; "above"; "over";
  "as"; "at"; "be"; "an"; "a"; "the"; "from"; "to"; "upto"; "am"; "was"; "would"; "could"; "should"; "shall" ]

(* Build a hash table of stop words for O(1) lookup *)
let reject_words_table =
  let table = Hashtbl.create 30 in
  let rec create_reject_words_table = function
      [] -> table
    | h :: t -> (Hashtbl.add table h ()); create_reject_words_table t
  in
  create_reject_words_table reject_words


(* Read all words from stdin, filtering out stop words.
   Returns a list of words in order. *)
let read_all_words () =
  let lexbuf = Lexing.from_channel stdin in
  let rec read_next_word word_list =
    let next_token = (scan_words lexbuf) in
      match next_token with
          Id(s)  ->
            if not (Hashtbl.mem reject_words_table s) then
              (read_next_word (s :: word_list))   (* keep this word *)
            else
              read_next_word word_list            (* skip stop word *)
        | EOF -> word_list
  in
  (List.rev (read_next_word []))

(* Build a frequency table: word -> ref(count).
   If a word is seen again, increment its count; otherwise add it. *)
let make_table word_list =
  let table = Hashtbl.create 30 in
  let rec enter_word = function
      h :: t ->
        if Hashtbl.mem table h then
          let count = Hashtbl.find table h in count := !count + 1
        else 
          Hashtbl.add table h (ref 1);
          enter_word t
    | [] -> ()
  in
  enter_word word_list;
  table

(* Main: read words -> build table -> print unsorted -> print sorted *)
let main () =
  let word_list = read_all_words () in
  let table = make_table word_list
  in
  print_table table;
  let sorted = (sort_table table) in
    (print_list sorted (fun (k, v) -> (Printf.printf "%s -> %d\n" k v)))
  ;;

main ()
}
