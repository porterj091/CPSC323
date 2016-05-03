%{

void yyerror (char *s);
#include <stdio.h>
#include <stdlib.h>

%}

/* Yacc Definitions */
%start line
%token PRINT
%token VAR
%token BEGIN
%token INTEGER
%token PROGRAM
%token END
%token ID
%token number


%%

line : PROGRAM pname ';' VAR declist ';' BEGIN statlist END ;

pname 	: ID						{ $$ = $1; } 
		;
declist : dec ':' type							
		;
dec 	: ID',' dec 
		| ID
		;

statlist	: stat';'
			| stat';' statlist					
			;

stat	: print
		| assign
		;

print	: PRINT '('output')'					
		;
output	: ID									
		;
assign	: ID = expr					{ $$ = $1; }	
		;

expr	: term						{ $$ = $1; }
		| expr '+' term				{ $$ = $1 + $3; }	
		| expr '-' term				{ $$ = $1 - $3; }
		;

term 	: term '*' factor			{ $$ = $1 * $3; }
		| term '/' factor			{ $$ = $1 / $3; }
		| factor					{ $$ = $1; }
		;

factor	: ID						{ $$ = $1; }
		| number					{ $$ = $1; }
		| '(' expr ')'
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
	printf("%s\n", s);
}
