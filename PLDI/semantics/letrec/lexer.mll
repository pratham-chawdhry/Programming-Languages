(* ocamllex specification for the letrec language lexer.
   Extends let2 lexer with: *, ->, fun, rec keywords for functions and recursion. *)
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
  | '*'          { Parser.MUL                        }  (* NEW: multiplication *)
  | '='          { Parser.EQ                         }
  | "->"         { Parser.RTARROW                    }  (* NEW: arrow for fun x -> body *)
  | integer as s { Parser.INTEGER((int_of_string s)) }
  | "if"         { Parser.IF                         }
  | "then"       { Parser.THEN                       }
  | "else"       { Parser.ELSE                       }
  | "true"       { Parser.BOOLEAN(true)              }
  | "false"      { Parser.BOOLEAN(false)             }
  | "and"        { Parser.AND                        }
  | "or"         { Parser.OR                         }
  | "not"        { Parser.NOT                        }
  | "let"        { Parser.LET                        }
  | "in"         { Parser.IN                         }
  | "fun"        { Parser.FUN                        }  (* NEW: function keyword *)
  | "rec"        { Parser.REC                        }  (* NEW: recursive keyword *)
  | id as s      { Parser.ID(s)                      }
  | ','          { Parser.COMMA                      }
  | eof          { Parser.EOF                        }

{
}
