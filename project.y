%{

void yyerror (const char *s);
void print_header();
void Logging(const char *msg);
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;

char *str[15];

struct CaptainsLog
{
    FILE *log_file;
	FILE *output_file;
    
} c;

%}
%start line


/* Yacc Definitions */

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

line : PROGRAM{ Logging("Found PROGRAM Keyword\n"); } pname';'{ print_header(); } VAR declist';' beginning { Logging("Found BEGIN Keyword\n"); }statlist END { Logging("Found END. Keyword\n Terminate program\n"); } ;

pname 	: ID						{ $$ = $1; Logging("Found program name\n"); }
		;
declist : dec ':' type				{ $$ = $1 + $3;  }
		| dec type					{ yyerror("Missing : "); }
		;

dec 	: ID',' dec 				{ $$ = $1 + $3; }
		| ID dec					{ yyerror("Missing , "); }
		| ID						{ $$ = $1; }
		;

statlist	: stat';' statlist	    { $$ = $1; Logging("Looking for more stat;\n"); }
			| stat';'				{ $$ = $1; Logging("Found last stat;\n"); }
			| stat					{ yyerror("Missing ;"); }
			;

stat	: print
		| assign
		;

print	: PRINT'(' output ')'		{ $$ = $3; }
		;

output	: QUOTE',' ID               { $$ = $1; Logging("Printing string = \n"); }
        | ID                        { $$ = $1; Logging("Printing just ID\n"); }
		;

assign	: ID '=' expr				{ $$ = $1; Logging("Assignning\n");}
		| ID expr					{ yyerror("Missing = "); }
		;

expr	: term						{ $$ = $1; }
		| expr '+' term				{ $$ = $1 + $3; Logging("Recognize +\n"); }	
		| expr '-' term				{ $$ = $1 - $3; Logging("Recognize -\n"); }
		;

term 	: term '*' factor			{ $$ = $1 * $3; Logging("Recognize *\n"); }
		| term '/' factor			{ $$ = $1 / $3; Logging("Recognize /\n"); }
		| factor					{ $$ = $1; }
		;

factor	: ID						{ $$ = $1; }
		| number					{ $$ = $1; }
		| '(' expr ')'				{ $$ = $2; }
		;

type	: INTEGER					{ $$ = $1; Logging("Found type\n"); }
		;

%%

int main(int argc, char *argv[])
{
    c.log_file = fopen("log.txt", "w");
	c.output_file = fopen("aba13.cpp", "w");
    if (c.log_file == NULL || c.output_file == NULL)
    {
        printf("Error!\n");
        return 1;
    }

	// Start the compiler
	yyparse();
	fclose(c.log_file);
	fclose(c.output_file);
	return 0;
}

void print_header()
{
	Logging("Printing header ... \n");
	fprintf(c.output_file, "%s\n", "#include <iostream>");
	fprintf(c.output_file, "%s\n", "using namespace std;");
	fprintf(c.output_file, "%s\n", "int main() {");
}

void Logging(const char * msg)
{
    fprintf(c.log_file, "%s", msg);
    
}

void yyerror (const char *s)
{

	printf("%s on line %d\n", s, yylineno);

}
