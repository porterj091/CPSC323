%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <stdio.h>
	int white = 0;

	extern yylval;
%}

%option yylineno

%%
("(*")(.|\n)*("*)") { printf("Deleting comment\n"); }
[\t\n' '] 			{ printf("Delete whitespace: %d\n", white); white++;}
"PROGRAM"			{ return PROGRAM; }
"VAR"				{ return VAR; }
"INTEGER"			{ return INTEGER; }
"BEGIN"				{ return beginning; }
"PRINT"				{ return PRINT; }
"END."				{ return END; }
[a-f][a-f0-9]		{ return ID; }
[0-9]+				{ 	
						yylval = atof(yytext);
						return number; 
					}

[-+=:"();]			{ return yytext[0]; }

. 					{ECHO; yyerror ("Unexpected character");}

%%

int yywrap()
{
	return 1;
}

