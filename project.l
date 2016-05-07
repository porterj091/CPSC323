%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <stdio.h>
    #include <string.h>



    extern c;
%}

%option yylineno

%x C_COMMENT
%%
"(*"				{ BEGIN(C_COMMENT);}
<C_COMMENT>"*)"			{ BEGIN(INITIAL); Logging("Deleting Comment"); }
<C_COMMENT>. 			{}
"PROGRAM"			{ return PROGRAM; }
"VAR"				{ return VAR; }
"INTEGER"			{ return INTEGER; }
"BEGIN"				{ return beginning; }
"PRINT"				{ return PRINT; }
"END."				{ return END; }
'(\\.|[^\\'])*'             	{  yylval.str = strdup(yytext); return QUOTE;}  
[a-f][a-f0-9]*			{ yylval.str = strdup(yytext); return ID; }
[0-9]+				{ yylval.str = strdup(yytext); return number;}
[ \t\n] 			{}
[-+=:,();\*]			{ return yytext[0]; }

. 				{ECHO; yyerror ("Unexpected character");}

%%

int yywrap()
{
	return 1;
}

