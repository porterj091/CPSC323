%{

void yyerror (char *s);
#include <stdio.h>
#include <stdlib.h>

%}

/* Yacc Definitions */
%start line
%token PRINT
%token VAR
%token beginning
%token INTEGER
%token PROGRAM
%token END
%token ID
%token number


%%

line : PROGRAM pname';' VAR declist';' beginning statlist END ;

pname 	: ID						{ $$ = $1; } 
		;
declist : dec ':' type	
		;
dec 	: ID',' dec 
		| ID						{ $$ = $1; }
		;

statlist	: stat';'				{ $$ = $1; }
			| stat';' statlist					
			;

stat	: print
		| assign
		;

print	: PRINT'('output')'					
		;

output	: ID									
		;

assign	: ID '=' expr					{ $$ = $1; printf("Assignning\n");}	
		;

expr	: term						{ $$ = $1; }
		| expr '+' term				{ $$ = $1 + $3; printf("Recognize +\n"); }	
		| expr '-' term				{ $$ = $1 - $3; printf("Recognize -"); }
		;

term 	: term '*' factor				{ $$ = $1 * $3; printf("Recognize *\n"); }
		| term '/' factor			{ $$ = $1 / $3; printf("Recognize /\n"); }
		| factor				{ $$ = $1; }
		;

factor	: ID						{ $$ = $1; }
		| number				{ $$ = $1; }
		| '(' expr ')'				{ $$ = $2; }
		;

type	: INTEGER					{ $$ = $1; }
		;

%%

int main(int argc, char *argv[])
{
	yyparse();

	return 0;
}

void yyerror (char *s)
{
	printf("error at line: %s\n",s);
}
