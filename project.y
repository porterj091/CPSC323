%{

void yyerror (const char *s);
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
%token QUOTE


%%

line : PROGRAM{ printf("Found PROGRAM Keyword\n"); } pname';' VAR declist';' beginning { printf("Found BEGIN Keyword\n"); }statlist END { printf("Found END. Keyword\n Terminate program\n"); } ;

pname 	: ID						{ $$ = $1; printf("Found program name\n"); }
		;
declist : dec ':' type	
		;
dec 	: ID',' dec 
		| ID						{ $$ = $1; }
		;

statlist	: stat';'				{ $$ = $1; printf("Found last stat;\n"); }
            | stat';' statlist       { printf("Looking for more stat;\n"); }
			;

stat	: print
		| assign
		;

print	: PRINT'(' output ')'			{}
		;

output	: QUOTE',' ID                  { $$ = $3; printf("Printing string = \n"); }
        | ID                            { $$ = $1; printf("Printing just ID\n"); }
		;

assign	: ID '=' expr					{ $$ = $1; printf("Assignning\n");}
		;

expr	: term						{ $$ = $1; }
		| expr '+' term				{ $$ = $1 + $3; printf("Recognize +\n"); }	
		| expr '-' term				{ $$ = $1 - $3; printf("Recognize -\n"); }
		;

term 	: term '*' factor				{ $$ = $1 * $3; printf("Recognize *\n"); }
		| term '/' factor			{ $$ = $1 / $3; printf("Recognize /\n"); }
		| factor				{ $$ = $1; }
		;

factor	: ID						{ $$ = $1; }
		| number				{ $$ = $1; }
		| '(' expr ')'				{ $$ = $2; }
		;

type	: INTEGER					{ $$ = $1; printf("Found type\n"); }
		;

%%

int main(int argc, char *argv[])
{
	yyparse();

	return 0;
}

void yyerror (const char *s)
{
	extern int yylineno;
	printf("%s on line %d\n", s, yylineno);

}
