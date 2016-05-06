%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <stdio.h>
    #include <string.h>
	int white = 0;

    extern yylval;
    extern c;
%}

%option yylineno

%x C_COMMENT
%%
"(*"				{ BEGIN(C_COMMENT);}
<C_COMMENT>"*)"			{ BEGIN(INITIAL); Logging("Deleting Comment\n"); }
<C_COMMENT>. 			{}
"PROGRAM"			{ return PROGRAM; }
"VAR"				{ return VAR; }
"INTEGER"			{ return INTEGER; }
"BEGIN"				{ return beginning; }
"PRINT"				{ return PRINT; }
"END."				{ return END; }
'[^\n]*'             {   
                    int c = input();
                    unput(c);
                    if(c != '\'')
                        return QUOTE;
                    else
                        yymore();
                    }  
[a-f][a-f0-9]*		{ return ID; }
[0-9]+				{ 	
						yylval = atoi(yytext);
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

