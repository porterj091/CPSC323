%{
//#define YYDEBUG 1
void yyerror (const char *s);
void print_header();
void Logging(const char *msg);
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
//int yydebug = 1;


struct CaptainsLog
{
    FILE *log_file;
	FILE *output_file;
    
} c;

%}
%union {char *str; int num;}
%start line


/* Yacc Definitions */

%token PRINT
%token VAR
%token beginning
%token<str> INTEGER
%token PROGRAM
%token END
%token<str> ID
%token<str> number
%token<str> QUOTE
%type<str> pname declist statlist stat print output assign dec type 
%type<str> term expr factor
%left '-' '+'
%left '*' '/'

%%

line : PROGRAM{ Logging("Found PROGRAM Keyword\n"); } pname';'{ print_header(); } VAR declist';' beginning { Logging("Found BEGIN Keyword\n"); }statlist END { Logging("Found END. Keyword\n Terminate program\n"); } ;

pname 	: ID						{ $$ = $1; Logging("Found program name\n"); }
		;
declist : dec ':' type					{ printf("%s,\n ",$1); }//printf("%s %s\n", $1,$3);  }
		| dec type				{ yyerror("Missing : "); }
		;

dec 	: ID',' dec 					{ }
		| ID dec				{ yyerror("Missing , "); }
		| ID					{ $$ = $1;}
		;

statlist	: stat';' statlist	    		{ $$ = $1; }
			| stat';'			{ $$ = $1; Logging("Found last stat;\n"); }
			| stat				{ yyerror("Missing ;"); }
			;

stat	: print
		| assign				{  }
		;

<<<<<<< Updated upstream
print	: PRINT'(' output ')'				{ $$ = $3; }
=======
print	: PRINT'(' output ')'		{ $$ = $3; }
		| PRINT output ')'			{ yyerror("Missing ( "); }
		| PRINT '(' output			{ yyerror("Missing ) "); }
>>>>>>> Stashed changes
		;

output	: QUOTE',' ID              			{  Logging("Printing string = \n"); printf("cout << %s << %s;\n", $1, $3);}
        | ID                        			{  Logging("Printing just ID\n"); printf("cout << %s;\n", $1);  }
		;

assign	: ID '=' expr					{ Logging("Assignning\n"); printf("%s = %s\n", $1, $3);  }
		| ID expr				{ yyerror("Missing = "); }
		;

expr	: term						{ }
		| expr '+' term				{ $$ = $3;  Logging("Recognize +\n");}//printf("%s + %s", $1,$3); }	
		| expr '-' term				{  $$ = $3; Logging("Recognize -\n");}//printf("%s - %s", $1,$3);; }
		;

term 	: term '*' factor				{ $$ = $3;  Logging("Recognize *\n");}//printf("%s * %s", $1,$3); }
		| term '/' factor			{ $$ = $3;  Logging("Recognize /\n");}//printf("%s / %s", $1,$3); }
		| factor				{ $$ = $1;}
		;

factor	: ID						{ $$ = $1; }
		| number				{  $$ = $1; }
		| '(' expr ')'				{  }
		;

type	: INTEGER					{ $$ = $1; Logging("Found type\n"); printf("int "); }
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
    fprintf(c.output_file, "%s\n", "return 0;");
    fprintf(c.output_file, "%s\n", "}");
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
