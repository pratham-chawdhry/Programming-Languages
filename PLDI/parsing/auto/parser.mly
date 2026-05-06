(* ocamlyacc grammar for arithmetic expressions with correct precedence.
   This file is processed by ocamlyacc to generate parser.ml and parser.mli.

   Grammar (in order of precedence, * binds tighter than +):
     expr   -> term EOF
     term   -> factor | factor + term      (addition, right-associative)
     factor -> NUM    | NUM * factor       (multiplication, right-associative)

   The grammar ensures * is evaluated before + by putting * in a lower
   (more tightly binding) rule than +. *)
%{
%}

(* Token declarations — these must match what the lexer produces *)
%token ADD SUB MUL EOF
%token <int> NUM

(* Entry point: parsing starts with the 'expr' rule *)
%start expr
%type <Expr_type.expr_type> expr     (* the result is an Expr_type.expr_type value *)

%% /* Grammar rules and actions follow */
;
  (* Top-level: a term followed by end-of-file *)
  expr  : term EOF        { $1          }

  (* A term is either a single factor, or factor + term (right-recursive for +) *)
  term  : factor          { $1          }
        | factor ADD term { Expr_type.Add($1, $3) }

  (* A factor is either a number, or number * factor (right-recursive for *) *)
  factor: NUM             { Expr_type.Num($1)     }
        | NUM MUL factor  { Expr_type.Mul(Expr_type.Num($1), $3) }
;

%%
