(* ocamllex specification for the "if" language lexer.
   Extends the const lexer with: if, then, else, true, false keywords. *)
{
exception Lexer_exception of string
}

let digit = ['0'-'9']
let integer = ['0'-'9']['0'-'9']*
let id = ['a'-'z''A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9']*

rule scan = parse
  | [' ' '\t' '\n']+  { scan lexbuf                  }  (* skip whitespace *)
  | '('          { Parser.LPAREN                     }
  | ')'          { Parser.RPAREN                     }
  | ':'          { Parser.COLON                      }
  | '-'          { Parser.SUBTRACT                   }
  | '+'          { Parser.ADD                        }
  | integer as s { Parser.INTEGER((int_of_string s)) }
  | "if"         { Parser.IF                         }  (* keyword: if *)
  | "then"       { Parser.THEN                       }  (* keyword: then *)
  | "else"       { Parser.ELSE                       }  (* keyword: else *)
  | "true"       { Parser.BOOLEAN(true)              }  (* boolean literal *)
  | "false"      { Parser.BOOLEAN(false)             }  (* boolean literal *)
  | id as s      { Parser.ID(s)                      }
  | ','          { Parser.COMMA                      }
  | eof          { Parser.EOF                        }

{
}
