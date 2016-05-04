%{

void yyerror (const char *s);
#include <stdio.h>
#include <stdlib.h>

struct CaptainsLog
{
    FILE *flptr;
    
} c;

void Logging(char * msg)
{
    fprintf(c.flptr, "%s", msg);
    
}



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

line : PROGRAM{ Logging("Found PROGRAM Keyword\n"); } pname';' VAR declist';' beginning { Logging("Found BEGIN Keyword\n"); }statlist END { Logging("Found END. Keyword\n Terminate program\n"); } ;

pname 	: ID						{ $$ = $1; Logging("Found program name\n"); }
		;
declist : dec ':' type	
		;
dec 	: ID',' dec 
		| ID						{ $$ = $1; }
		;

statlist	: stat';'				{ $$ = $1; Logging("Found last stat;\n"); }
            | stat';' statlist       { Logging("Looking for more stat;\n"); }
			;

stat	: print
		| assign
		;

print	: PRINT'(' output ')'			{}
		;

output	: QUOTE',' ID                  { $$ = $3; Logging("Printing string = \n"); }
        | ID                            { $$ = $1; Logging("Printing just ID\n"); }
		;

assign	: ID '=' expr					{ $$ = $1; Logging("Assignning\n");}
		;

expr	: term						{ $$ = $1; }
		| expr '+' term				{ $$ = $1 + $3; Logging("Recognize +\n"); }	
		| expr '-' term				{ $$ = $1 - $3; Logging("Recognize -\n"); }
		;

term 	: term '*' factor				{ $$ = $1 * $3; Logging("Recognize *\n"); }
		| term '/' factor			{ $$ = $1 / $3; Logging("Recognize /\n"); }
		| factor				{ $$ = $1; }
		;

factor	: ID						{ $$ = $1; }
		| number				{ $$ = $1; }
		| '(' expr ')'				{ $$ = $2; }
		;

type	: INTEGER					{ $$ = $1; Logging("Found type\n"); }
		;

%%

int main(int argc, char *argv[])
{
    c.flptr = fopen("log.txt", "w");
    if (c.flptr == NULL)
    {
        printf("Error!\n");
        return 1;
    }
	yyparse();

	return 0;
}

void yyerror (const char *s)
{
	extern int yylineno;
	printf("%s on line %d\n", s, yylineno);

}
