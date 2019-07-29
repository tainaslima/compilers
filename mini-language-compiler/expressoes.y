%{
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

#define YYSTYPE Atributos

int linha = 1;
int coluna = 1;

struct Atributos {
  string v;
  string c;
  int linha;
};

int yylex();
int yyparse();
void yyerror(const char *);

string geraNomeVar();
string getLabel(int avanca);
string getNewVar();

int nVar = 0;
int nLab = 0;

string newVar = "";

%}

%start S
%token CINT CDOUBLE TK_ID TK_VAR TK_CONSOLE TK_SHIFTR TK_SHIFTL
%token TK_FOR TK_IN TK_2PT TK_IF TK_THEN TK_ELSE TK_BEGIN TK_END TK_STR TK_ENDL 
%token TK_ME TK_MA TK_MEIG TK_MAIG TK_IG TK_DIF TK_E TK_OU TK_NEG

%left TK_MA TK_ME
%left TK_MAIG TK_MEIG
%left TK_IG TK_DIF
%left TK_E TK_OU
%left TK_NEG
%left '+' '-'
%left '*' '/' '%'

%%

S : K
    { cout << "#include <stdio.h>\n"
					"#include <iostream>\n"
                    "using namespace std;\n\n"
					"int main()\n {\n" +$1.c +
					"\n return 0;\n}\n"<< endl; }
  ;

 K: DECLVAR CMDS{$$.c = newVar + ";\n\n" + $2.c;}
	| CMDS {$$.c = $1.c;}
	;
	
CMDS : CMDS CMD { $$.c = $1.c + $2.c; }
     | CMD 
     ;

CMD :  ENTRADA';' 
    | SAIDA';'
    | ATR';'
    | FOR
    | IF
    ;
	
	
DECLVAR : DECLVAR TK_VAR VARS';' {newVar = $1.c + ',' + $3.c ;}
		| TK_VAR VARS';' { newVar = "int " + $2.c + newVar; $$.c = newVar;}
        ;

VARS : VARS ',' VAR  { $$.c = $1.c + ", " + $3.c; }
     | VAR
     ;

VAR : TK_ID '[' CINT ']'
      { $$.c = $1.v + "[" + $3.v + "]"; }
    | TK_ID
      { $$.c = $1.v; }
    ;

ENTRADA : TK_CONSOLE SHIFTID   { $$.c = $2.c; }
        ;
SHIFTID: SHIFTID TK_SHIFTR TK_ID 			  { $$.c = $1.c + "cin >>" + $3.v + ";\n"; }
			     |  TK_SHIFTR TK_ID 						  { $$.c = "cin >> " + $2.v + ";\n";}
				 |  SHIFTID TK_SHIFTR TK_ID '[' E ']' {
																				$$.v = geraNomeVar(); 
																				$$.c = $1.c + $5.c + "cin >> " + $$.v + ";\n"
																				+ $3.v + "[" + $5.v + "] = " + $$.v + ";\n";
																			}
				|   TK_SHIFTR TK_ID '[' E ']' {
																$$.v = geraNomeVar(); 
																$$.c = $4.c + "cin >> " + $$.v + ";\n"
																+ $2.v + "[" + $4.v + "] = " + $$.v + ";\n";
															}
			;
		
SAIDA : TK_CONSOLE SHIFTE  TK_SHIFTL TK_ENDL{ $$.c = $2.c + "cout << endl;\n"; }
			| TK_CONSOLE SHIFTE { $$.c = $2.c; }
			;
						
SHIFTE: SHIFTE TK_SHIFTL E { $$.c = $1.c + $3.c + "cout << " + $3.v + ";\n";}
		   | SHIFTE TK_SHIFTL TK_STR { $$.c = $1.c + "cout << " + $3.v + ";\n";} 
           |  TK_SHIFTL E { $$.c = $2.c + "cout << " + $2.v + ";\n";}
		   |  TK_SHIFTL TK_STR{ $$.c = "cout << " + $2.v + ";\n";}
		   ;
		
FOR : TK_FOR TK_ID TK_IN '[' E TK_2PT E ']' CMD
																				{  string cond = geraNomeVar();
																					string lbl1 = getLabel(1);
																					string lbl2 = getLabel(1);
																					newVar += "," + cond;
																					
																				   $$.c = $5.c + $7.c
																						+ $2.v + " = " + $5.v + ";\n"
																						+  lbl1 + ":\n" + cond + " = " + $2.v + " > " + $7.v + ";\n"
																						+ "if( " + cond + ") goto " + lbl2 + ";\n"
																						+ $9.c
																						+ $2.v + " = " + $2.v + " + 1;\n"
																						+ "goto "+ lbl1 + ";\n"
																						+ lbl2 + ":\n";
																				}
		|   TK_FOR TK_ID TK_IN '[' E TK_2PT E ']' TK_BEGIN CMDS TK_END';'
																													{
																														string cond = geraNomeVar();
																														string lbl1 = getLabel(1);
																														string lbl2 = getLabel(1);
																														newVar += "," + cond;
																					
																														$$.c = $5.c + $7.c
																														+ $2.v + " = " + $5.v + ";\n"
																														+  lbl1 + ":\n" + cond + " = " + $2.v + " > " + $7.v + ";\n"
																														+ "if( " + cond + ") goto " + lbl2 + ";\n"
																														+ $10.c
																														+ $2.v + " = " + $2.v + " + 1;\n"
																														+ "goto "+ lbl1 + ";\n"
																														+ lbl2 + ":\n";
																													}
    ;

IF : CE {$$.c = $1.c;}
	| SE {$$.c = $1.c;}
	;

CE:  TK_IF E TK_THEN CMD TK_ELSE CMD {
																			$$.v = getLabel(1); 
																			$$.c = $2.c 
																			+ "if  (" + $2.v + " ) goto " + $$.v + ";\n" 
																			+ $6.c + "goto " + getLabel(1)  +  + ";\n"
																			+  $$.v + ":\n" + $4.c + "\n"
																			+ getLabel(0) + ":\n";
																		}
	|   TK_IF E TK_THEN TK_BEGIN CMDS TK_END TK_ELSE TK_BEGIN CMDS TK_END';' {
																																				$$.v = getLabel(1); 
																																				$$.c = $2.c 
																																				+ "if  (" + $2.v + " ) goto " + $$.v + ";\n" 
																																				+ $9.c + "goto " + getLabel(1)  + ";\n"
																																				+ $$.v + ":\n" + $5.c + "\n"
																																				+ getLabel(0) + ":\n";
																																			}
   |   TK_IF E TK_THEN TK_BEGIN CMDS TK_END TK_ELSE CMD{
																																				$$.v = getLabel(1); 
																																				$$.c = $2.c 
																																				+ "if  (" + $2.v + " ) goto " + $$.v + ";\n" 
																																				+ $8.c + "goto " + getLabel(1)  + ";\n"
																																				+ $$.v + ":\n" + $5.c + "\n"
																																				+ getLabel(0) + ":\n";
																																			}
   ;
   
SE : TK_IF E TK_THEN CMD {
												$$.v = getLabel(1); 
												$$.c = $2.c 
												+ "if  (" + $2.v + " ) goto " + $$.v + ";\n" 
												+ "goto " + getLabel(1)  + ";\n"
												+  $$.v + ":\n" + $4.c + "\n"
												+ getLabel(0) + ":\n";
												}
	
	 |   TK_IF E TK_THEN TK_BEGIN CMDS TK_END';'{
																					$$.v = getLabel(1); 
																					 $$.c = $2.c 
																					+ "if  (" + $2.v + " ) goto " + $$.v + ";\n" 
																					+ "goto " + getLabel(1)  + ";\n"
																					+  $$.v + ":\n" + $5.c + "\n"
																					+ getLabel(0) + ":\n";
																					}
	 ;

ATR : TK_ID '=' E
      { $$.v = $3.v;
        $$.c = $3.c + $1.v + " = " + $3.v + ";\n";
      }
    | TK_ID '[' E ']' '=' E
      { $$.c = $3.c + $6.c
             + $1.v + "[" + $3.v + "] = " + $6.v + ";\n";
        $$.v = $6.v;
      }
    ;

E : E '+' E
    { $$.v = geraNomeVar();
      $$.c = $1.c + $3.c + $$.v + " = " + $1.v + "+" + $3.v + ";\n";
	  newVar += "," + $$.v;
    }
 | E '-' E
    { $$.v = geraNomeVar();
      $$.c = $1.c + $3.c + $$.v + " = " + $1.v + "-" + $3.v + ";\n";
	  newVar += "," + $$.v;
    }
  | E '*' E
    { $$.v = geraNomeVar();
      $$.c = $1.c + $3.c + $$.v + " = " + $1.v + "*" + $3.v + ";\n";
	  newVar += "," + $$.v;
    }
  | E '/' E
    { $$.v = geraNomeVar();
      $$.c = $1.c + $3.c + $$.v + " = " + $1.v + "/" + $3.v + ";\n";
	  newVar += "," + $$.v;
    }
    |  E TK_ME E
   {  $$.v = geraNomeVar();
	   $$.c = $1.c + $3.c + $$.v +  " = " + $1.v + $2.v + $3.v + ";\n";
	   newVar += "," + $$.v;
   }
    |  E TK_MA E
   {  $$.v = geraNomeVar();
	   $$.c = $1.c + $3.c + $$.v +  " = " + $1.v + $2.v + $3.v + ";\n";
	   newVar += "," + $$.v;
   }
  |  E TK_DIF E
   {  $$.v = geraNomeVar();
	   $$.c = $1.c + $3.c + $$.v +  " = " + $1.v + $2.v + $3.v + ";\n";
	   newVar += "," + $$.v;
   }
   |  E TK_MEIG E
   {  $$.v = geraNomeVar();
	   $$.c = $1.c + $3.c + $$.v +  " = " + $1.v + $2.v + $3.v + ";\n";
	   newVar += "," + $$.v;
   }
   |  E TK_MAIG E
   {  $$.v = geraNomeVar();
	   $$.c = $1.c + $3.c + $$.v +  " = " + $1.v + $2.v + $3.v + ";\n";
	   newVar += "," + $$.v;
   }
   |  E TK_IG E
   {  $$.v = geraNomeVar();
	   $$.c = $1.c + $3.c + $$.v +  " = " + $1.v + $2.v + $3.v + ";\n";
	   newVar += "," + $$.v;
   }
   |  E TK_E  E
   {  $$.v = geraNomeVar();
	   $$.c = $1.c + $3.c + $$.v +  " = " + $1.v + $2.v + $3.v + ";\n";
	   newVar += "," + $$.v;
   }
   |  TK_NEG E
   {  $$.v = geraNomeVar();
	   $$.c = $2.c + $$.v +  " = " + $1.v +  $2.v + ";\n";
	   newVar += "," + $$.v;
   }
   |  E TK_OU E
   {  $$.v = geraNomeVar();
	   $$.c = $1.c + $3.c + $$.v +  " = " + $1.v + $2.v + $3.v + ";\n";
	   newVar += "," + $$.v;
   }
    |  E '%' E
   {  $$.v = geraNomeVar();
	   $$.c = $1.c + $3.c + $$.v +  " = " + $1.v + '%' + $3.v + ";\n";
	   newVar += "," + $$.v;
   }
  | V
  ;

V : TK_ID '[' E ']'
    { $$.v = geraNomeVar();
      $$.c = $3.c + $$.v + " = " + $1.v + "[" + $3.v + "];\n";
	  newVar += "," + $$.v;
    }
  | TK_ID     { $$.c = ""; $$.v = $1.v; }
  | CINT      { $$.c = ""; $$.v = $1.v; }
  | '(' E ')' { $$ = $2; }
  ;

%%

#include "lex.yy.c"

void yyerror( const char* st ) {
   puts( st );
   printf( "Linha %d, coluna %d, proximo a: %s\n", linha, coluna, yytext );
   exit( 0 );
}

string geraNomeVar() {
  char buf[20] = "";

  sprintf( buf, "t%d", nVar++ );

  return buf;
}

string getLabel(int avanca)
{
	if(avanca)
	{
		 char buf[20] = "";

		sprintf( buf, "lbl%d", nLab );
		
		nLab++;

		return buf;
	}
	else
	{
		 char buf[20] = "";

		sprintf( buf, "lbl%d", nLab );

		return buf;
	}
}

string getNewVar()
{
	string buf = "";
	if(newVar == "") 
	{
		return newVar;
	}
	else 
	{	
		buf = "," + newVar;
		return buf;
	}
}