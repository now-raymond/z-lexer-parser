/**
* A lexer for the Z language.
*/

import java_cup.runtime.*;

%%

%class Lexer
%unicode
%line
%column
%cup
%cupdebug

%{
	StringBuilder string = new StringBuilder();
	private Symbol symbol(int type) {
		//print_lexeme(type, null);
		return new Symbol(type, yyline, yycolumn);
	}
	private Symbol symbol(int type, Object value) {
		//print_lexeme(type, value);
		return new Symbol(type, yyline, yycolumn, value);
	}
%}

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

// Integer literals
IntegerLiteral = 0 | [1-9][0-9]*

// Rational literals
// TODO - verify that this is working.
RationalLiteral = ([0-9]+ "_")? [0-9]+ "/" [0-9]+
    
// Floating point literals      
FloatLiteral  = ({FLit1}|{FLit2}|{FLit3}) {Exponent}? [fF]

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
  "if"                           { return symbol(sym.IF); }
  "then"                         { return symbol(sym.THEN); }
  "else"                         { return symbol(sym.ELSE); }
  "fi"                        	 { return symbol(sym.ENDIF); }
  "loop"                         { return symbol(sym.LOOP); }
  "pool"                         { return symbol(sym.ENDLOOP); }
  "break"                        { return symbol(sym.BREAK); }
  "return"                       { return symbol(sym.RETURN); }
  
  // Type definitions
  "fdef"                         { return symbol(sym.DEFINE_FUNCTION); }
  "tdef"                         { return symbol(sym.DEFINE_TYPE); }
  "alias"                        { return symbol(sym.ALIAS); }
  
  // Data types
  "bool"                         { return symbol(sym.BOOLEAN); }
  "char"                         { return symbol(sym.CHAR); }
  "int"                          { return symbol(sym.INT); }
  "rat"                          { return symbol(sym.RAT); }
  "float"                        { return symbol(sym.FLOAT); }
  "seq"                          { return symbol(sym.SEQ); }
  "dict"                         { return symbol(sym.DICT); }
  
  // Input-Output
  "read"                         { return symbol(sym.READ); }
  "print"                        { return symbol(sym.PRINT); }
  
  /* boolean literals */
  "T"                            { return symbol(sym.BOOLEAN_LITERAL, true); }
  "F"                            { return symbol(sym.BOOLEAN_LITERAL, false); }
  
  /* null literal */
  "null"                         { return symbol(sym.NULL_LITERAL); }
  
  /* separators */
  "("                            { return symbol(sym.LPAREN); }
  ")"                            { return symbol(sym.RPAREN); }
  "{"                            { return symbol(sym.LBRACE); }
  "}"                            { return symbol(sym.RBRACE); }
  "["                            { return symbol(sym.LBRACK); }
  "]"                            { return symbol(sym.RBRACK); }
  "<"                            { return symbol(sym.LANGLE); }
  ">"                            { return symbol(sym.RANGLE); }
  ";"                            { return symbol(sym.SEMICOLON); }
  ":"                            { return symbol(sym.COLON); }
  ","                            { return symbol(sym.COMMA); }
  "."                            { return symbol(sym.DOT); }
  
  /* operators */
  // Boolean operators
  "!"                            { return symbol(sym.NOT); }
  "&&"                           { return symbol(sym.AND); }
  "||"                           { return symbol(sym.OR); }
  "=>"                           { return symbol(sym.IMPLIES); }
  
  // Numeric operators
  "="                            { return symbol(sym.EQEQ); }
  "<="                           { return symbol(sym.LTEQ); }
  
  "+"                            { return symbol(sym.PLUS); }
  "-"                            { return symbol(sym.MINUS); }
  "*"                            { return symbol(sym.MULT); }
  "/"                            { return symbol(sym.DIV); }
  "^"                            { return symbol(sym.POF); }	// Power-of
  
  ":="                           { return symbol(sym.EQ); }
  "in"                           { return symbol(sym.IN); }
  "::"                           { return symbol(sym.CONCAT); }
  "?"                            { return symbol(sym.QUESTION); }	// Function predicate
  
  /* string literal */
  \"                             { yybegin(STRING); string.setLength(0); }

  /* character literal */
  \'                             { yybegin(CHARLITERAL); }

  /* numeric literals */
  
  {IntegerLiteral}               { return symbol(sym.INTEGER_LITERAL, new Integer(yytext())); }
  
  // Rational literals
  // TODO: appropriately handle the type instead of casting to Integer
  {RationalLiteral}				 { return symbol(sym.RATIONAL_LITERAL, new Integer(yytext())); }
  
  {FloatLiteral}                 { return symbol(sym.FLOATING_POINT_LITERAL, new Float(yytext().substring(0,yylength()-1))); }
  
  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  /* identifiers */ 
  {Identifier}                   { return symbol(sym.IDENTIFIER, yytext()); }  
}

<STRING> {
  \"                             { yybegin(YYINITIAL); return symbol(sym.STRING_LITERAL, string.toString()); }
  
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
  {SingleCharacter}\'            { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, yytext().charAt(0)); }
  
  /* escape sequences */
  "\\b"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\b');}
  "\\t"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\t');}
  "\\n"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\n');}
  "\\f"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\f');}
  "\\r"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\r');}
  "\\\""\'                       { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\"');}
  "\\'"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\'');}
  "\\\\"\'                       { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\\'); }
  
  /* error cases */
  \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
  {LineTerminator}               { throw new RuntimeException("Unterminated character literal at end of line"); }
}

/* error fallback */
[^]                              { throw new RuntimeException("Illegal character \""+yytext()+
                                                              "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>                          { return symbol(sym.EOF); }