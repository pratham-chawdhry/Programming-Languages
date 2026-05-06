(* ocamlyacc grammar for the const language.
   Simplest grammar: just integer arithmetic with + and -.
   %left ADD SUBTRACT gives both operators equal, left-to-right precedence. *)
%{
%}

%token NEWLINE WS COMMA EOF LPAREN RPAREN COLON
%token ADD SUBTRACT
%token <int> INTEGER
%token <string> ID

%start expr
%type <Expression.expr> expr

%left ADD SUBTRACT    (* + and - have equal precedence, left-associative *)

%% /* Grammar rules and actions follow */

expr :
    expr ADD expr { Expression.Add($1, $3) }         (* e1 + e2 *)
  | expr SUBTRACT expr { Expression.Subtract($1, $3) } (* e1 - e2 *)
  | INTEGER { Expression.Const $1 }                  (* integer literal *)
;

%%
