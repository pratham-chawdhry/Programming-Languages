(* ocamllex specification for the if_bool language lexer.
   Extends the "if" lexer with: and, or, not keywords for boolean operators. *)
{
exception Lexer_exception of string
}

let digit   = ['0'-'9']
let integer = ['0'-'9']['0'-'9']*
let id      = ['a'-'z''A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9']*

rule scan = parse
  | [' ' '\t' '\n']+  { scan lexbuf                  }  (* skip whitespace *)
  | '('          { Parser.LPAREN                     }
  | ')'          { Parser.RPAREN                     }
  | ':'          { Parser.COLON                      }
  | '-'          { Parser.SUBTRACT                   }
  | '+'          { Parser.ADD                        }
  | integer as s { Parser.INTEGER((int_of_string s)) }
  | "if"         { Parser.IF                         }
  | "then"       { Parser.THEN                       }
  | "else"       { Parser.ELSE                       }
  | "true"       { Parser.BOOLEAN(true)              }
  | "false"      { Parser.BOOLEAN(false)             }
  | "and"        { Parser.AND                        }  (* NEW: boolean and *)
  | "or"         { Parser.OR                         }  (* NEW: boolean or *)
  | "not"        { Parser.NOT                        }  (* NEW: boolean not *)
  | id as s      { Parser.ID(s)                      }
  | ','          { Parser.COMMA                      }
  | eof          { Parser.EOF                        }

{
}
