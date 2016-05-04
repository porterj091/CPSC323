%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <stdio.h>
	int white = 0;

	extern yylval;
%}

%option yylineno

%x C_COMMENT
%%
"(*"				{ BEGIN(C_COMMENT);}
<C_COMMENT>"*)"			{ BEGIN(INITIAL); printf("Deleting Comment\n"); }
<C_COMMENT>. 			{}
"PROGRAM"			{ return PROGRAM; }
"VAR"				{ return VAR; }
"INTEGER"			{ return INTEGER; }
"BEGIN"				{ return beginning; }
"PRINT"				{ return PRINT; }
"END."				{ return END; }
\'(\\.|[^"])*\'     { return QUOTE; }
[a-f][a-f0-9]*		{ return ID; }
[0-9]+				{ 	
						yylval = atof(yytext);
						return number; 
					}
[ \t\n] 			{}
[-+=:,();\*]			{ return yytext[0]; }

. 				{ECHO; yyerror ("Unexpected character");}

%%

int yywrap()
{
	return 1;
}

