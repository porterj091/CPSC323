%{
	#include "y.tab.h"
%}

%%
("(*")(.|\n)*("*)") { printf("Deleting comment");}
"PROGRAM"			{ return PROGRAM; }
"VAR"				{ return VAR; }
"INTEGER"			{ return INTEGER; }
"BEGIN"				{ return BEGIN; }
"PRINT"				{ return PRINT; }
"END."				{ return END; }
[a-f][a-f0-9]		{ return ID; }
[0-9]+				{ return number; }
[ \t\n] 			{}
[-+=:"();]			{ return yytext[0]; }

. 					{ECHO; yyerror ("Unexpected character");}

%%

int yywrap()
{
	return 1;
}

