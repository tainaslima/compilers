/* Coloque aqui definições regulares */

DIG		    [0-9]
LET		    [A-Za-z_]		

WS			[ \t\n]
INT			{DIG}+
FLOAT		{INT}("."{INT})?([Ee]("+"|"-")?{INT})?
ID			{LET}({LET}|{DIG})*
COMMENT	    \/\*((({WS}|(\/\*)|[^\/\*]|((\/)+([^\/\*])([^\/\*])*(\*)+)|((\*)+([^\/\*])([^\/\*])*(\/)+))*)|((\*)+)|((\/)+))\*\/
STRING		\"([^\/\"\n])*((\\\")|(\"\"))*([^\/\"\n])*((\\\")|(\"\"))*([^\/\"\n])*\"


%%
    /* Padrões e ações. Nesta seção, comentários devem ter um tab antes */

{WS}				{ /* ignora espaços, tabs e '\n' */ }

"if"				{return _IF;}
"for"				{return _FOR;} 
">="				{return _MAIG;}
"<="				{return _MEIG;}
"=="				{return _IG;}
"!="				{return _DIF;}

{ID}				{return _ID;}
{INT}				{return _INT;}
{FLOAT}				{return _FLOAT;}
{COMMENT}   		{return _COMENTARIO;}
{STRING}			{return _STRING;}
.                   {return *yytext; 
          /* Essa deve ser a última regra. Dessa forma qualquer caractere isolado será retornado pelo seu código ascii. */ }

%%

/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */