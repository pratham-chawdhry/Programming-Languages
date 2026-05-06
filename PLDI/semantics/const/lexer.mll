(* ocamllex specification for the const language lexer.
   Converts input text into tokens for the parser.
   Handles: whitespace, parentheses, operators, integers, identifiers, etc.
   Note: some tokens here (COLON, ID, COMMA) are declared for potential future use. *)
{
exception Lexer_exception of string
}

(* Regular expression definitions *)
let digit = ['0'-'9']
let integer = ['0'-'9']['0'-'9']*            (* one or more digits *)
let id = ['a'-'z''A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9']*  (* identifier *)

rule scan = parse
  | [' ' '\t' '\n']+  { scan lexbuf                         }  (* skip whitespace *)
  | '('          { Parser.LPAREN                     }  (* left parenthesis *)
  | ')'          { Parser.RPAREN                     }  (* right parenthesis *)
  | ':'          { Parser.COLON                      }
  | '-'          { Parser.SUBTRACT                   }  (* subtraction operator *)
  | '+'          { Parser.ADD                        }  (* addition operator *)
  | integer as s { Parser.INTEGER((int_of_string s)) }  (* integer literal *)
  | id as s      { Parser.ID(s)                      }  (* identifier *)
  | ','          { Parser.COMMA                      }
  | eof          { Parser.EOF                        }  (* end of input *)

{
}
