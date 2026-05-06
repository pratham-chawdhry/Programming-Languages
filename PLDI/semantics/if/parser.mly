(* ocamlyacc grammar for the "if" language.
   Extends the const grammar with: if BOOLEAN then expr else expr. *)
%{
%}

%token NEWLINE WS COMMA EOF LPAREN RPAREN COLON
%token IF THEN ELSE
%token ADD SUBTRACT
%token <int> INTEGER
%token <string> ID
%token <bool> BOOLEAN
%start expr
%type <Expression.expr> expr

%left ADD SUBTRACT

%% /* Grammar rules and actions follow */

expr :
    expr ADD expr { Expression.Add($1, $3) }
  | expr SUBTRACT expr { Expression.Subtract($1, $3) }
  | INTEGER { Expression.Const $1 }
  | if_expr { $1 }
;

(* if-then-else: the condition is a boolean literal (true/false) *)
if_expr : IF BOOLEAN THEN expr ELSE expr { Expression.IfExpr($2, $4, $6) }
%%
