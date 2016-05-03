%{
	#include <stdio.h>
%}

%%
("(*")(.|\n)*("*)") { printf("Deleting comment");}
[\t] {}

%%

main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	yylex();
	return 0;
}

int yywrap()
{
	return 1;
}

