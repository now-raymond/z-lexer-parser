/**
* A lexer for the Z language.
*/

%%

%class Lexer
%unicode
%line
%column
%cup
%cupdebug

// Main character classes
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

// Comments
Comment = {TraditionalComment} | {EndOfLineComment} | 
          {DocumentationComment}
		  
TraditionalComment = "/#" [^*] ~"#/" | "/#" "#"+ "/"
EndOfLineComment = "#" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/#" "#"+ [^/*] ~"#/"

// Identifiers
Identifier = [:jletter:][:jletterdigit:]*

/* integer literals */
DecIntegerLiteral = 0 | [1-9][0-9]*
DecLongLiteral    = {DecIntegerLiteral} [lL]

// TODO: RATIONAL NUMBERS
    
// Floating point literals      
FloatLiteral  = ({FLit1}|{FLit2}|{FLit3}) {Exponent}? [fF]
DoubleLiteral = ({FLit1}|{FLit2}|{FLit3}) {Exponent}?

FLit1    = [0-9]+ \. [0-9]* 
FLit2    = \. [0-9]+ 
FLit3    = [0-9]+ 
Exponent = [eE] [+-]? [0-9]+

// String and character literals
StringCharacter = [^\r\n\"\\]
SingleCharacter = [^\r\n\'\\]

%state STRING, CHARLITERAL

%%

<YYINITIAL> {

  /* Keywords */
  // Control Flow
  "if"                           { return symbol(IF); }
  "then"                         { return symbol(THEN); }
  "else"                         { return symbol(ELSE); }
  "fi"                        	 { return symbol(ENDIF); }
  "loop"                         { return symbol(LOOP); }
  "pool"                         { return symbol(ENDLOOP); }
  "break"                        { return symbol(BREAK); }
  "return"                       { return symbol(RETURN); }
  
  // Type definitions
  "tdef"                         { return symbol(DEFINE_TYPE); }
  "alias"                        { return symbol(ALIAS); }
  
  // Data types
  "fdef"                         { return symbol(DEFINE_FUNCTION); }
  "bool"                         { return symbol(BOOL); }
  "char"                         { return symbol(CHAR); }
  "float"                        { return symbol(FLOAT); }
  "int"                          { return symbol(INT); }
  "dict"                         { return symbol(DICT); }
  "seq"                          { return symbol(SEQ); }
  
  // Input-Output
  "read"                         { return symbol(READ); }
  "print"                        { return symbol(PRINT); }
  
  /* boolean literals */
  "T"                            { return symbol(BOOLEAN_LITERAL, true); }
  "F"                            { return symbol(BOOLEAN_LITERAL, false); }
  
  /* null literal */
  "null"                         { return symbol(NULL_LITERAL); }
  
  /* separators */
  "("                            { return symbol(LPAREN); }
  ")"                            { return symbol(RPAREN); }
  "{"                            { return symbol(LBRACE); }
  "}"                            { return symbol(RBRACE); }
  "["                            { return symbol(LBRACK); }
  "]"                            { return symbol(RBRACK); }
  "<"                            { return symbol(LANGLE); }
  ">"                            { return symbol(RANGLE); }
  ";"                            { return symbol(SEMICOLON); }
  ":"                            { return symbol(COLON); }
  ","                            { return symbol(COMMA); }
  "."                            { return symbol(DOT); }
  
  /* operators */
  "!"                            { return symbol(NOT); }
  "&&"                           { return symbol(AND); }
  "||"                           { return symbol(OR); }
  "=>"                           { return symbol(IMPLIES); }
  
  "+"                            { return symbol(PLUS); }
  "-"                            { return symbol(MINUS); }
  "*"                            { return symbol(MULT); }
  "/"                            { return symbol(DIV); }
  "^"                            { return symbol(XOR); }	// NOTE: Is this XOR?
  "::"                           { return symbol(CONCAT); }
  
  ":="                           { return symbol(EQ); }
  
  "in"                           { return symbol(IN); }
  
  /* string literal */
  \"                             { yybegin(STRING); string.setLength(0); }

  /* character literal */
  \'                             { yybegin(CHARLITERAL); }

  /* numeric literals */

  /* This is matched together with the minus, because the number is too big to 
     be represented by a positive integer. */
  "-2147483648"                  { return symbol(INTEGER_LITERAL, new Integer(Integer.MIN_VALUE)); }
  
  {DecIntegerLiteral}            { return symbol(INTEGER_LITERAL, new Integer(yytext())); }
  {DecLongLiteral}               { return symbol(INTEGER_LITERAL, new Long(yytext().substring(0,yylength()-1))); }
  
  {FloatLiteral}                 { return symbol(FLOATING_POINT_LITERAL, new Float(yytext().substring(0,yylength()-1))); }
  {DoubleLiteral}                { return symbol(FLOATING_POINT_LITERAL, new Double(yytext())); }
  {DoubleLiteral}[dD]            { return symbol(FLOATING_POINT_LITERAL, new Double(yytext().substring(0,yylength()-1))); }
  
  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  /* identifiers */ 
  {Identifier}                   { return symbol(IDENTIFIER, yytext()); }  
}

<STRING> {
  \"                             { yybegin(YYINITIAL); return symbol(STRING_LITERAL, string.toString()); }
  
  {StringCharacter}+             { string.append( yytext() ); }
  
  /* escape sequences */
  "\\b"                          { string.append( '\b' ); }
  "\\t"                          { string.append( '\t' ); }
  "\\n"                          { string.append( '\n' ); }
  "\\f"                          { string.append( '\f' ); }
  "\\r"                          { string.append( '\r' ); }
  "\\\""                         { string.append( '\"' ); }
  "\\'"                          { string.append( '\'' ); }
  "\\\\"                         { string.append( '\\' ); }
  
  /* error cases */
  \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
  {LineTerminator}               { throw new RuntimeException("Unterminated string at end of line"); }
}

<CHARLITERAL> {
  {SingleCharacter}\'            { yybegin(YYINITIAL); return symbol(CHARACTER_LITERAL, yytext().charAt(0)); }
  
  /* escape sequences */
  "\\b"\'                        { yybegin(YYINITIAL); return symbol(CHARACTER_LITERAL, '\b');}
  "\\t"\'                        { yybegin(YYINITIAL); return symbol(CHARACTER_LITERAL, '\t');}
  "\\n"\'                        { yybegin(YYINITIAL); return symbol(CHARACTER_LITERAL, '\n');}
  "\\f"\'                        { yybegin(YYINITIAL); return symbol(CHARACTER_LITERAL, '\f');}
  "\\r"\'                        { yybegin(YYINITIAL); return symbol(CHARACTER_LITERAL, '\r');}
  "\\\""\'                       { yybegin(YYINITIAL); return symbol(CHARACTER_LITERAL, '\"');}
  "\\'"\'                        { yybegin(YYINITIAL); return symbol(CHARACTER_LITERAL, '\'');}
  "\\\\"\'                       { yybegin(YYINITIAL); return symbol(CHARACTER_LITERAL, '\\'); }
  
  /* error cases */
  \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
  {LineTerminator}               { throw new RuntimeException("Unterminated character literal at end of line"); }
}

/* error fallback */
[^]                              { throw new RuntimeException("Illegal character \""+yytext()+
                                                              "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>                          { return symbol(EOF); }