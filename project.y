%{
//#define YYDEBUG 1
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror (const char *s);
void print_header();
void Logging(const char *msg);
void addString(char *s);
void printType();
void checkID(char *s);

extern int yylineno;
//int yydebug = 1;

// Can have 15 strings
char str[15][10];

// Will keep track of total # of variables
int numStrings = 0;


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

line : PROGRAM{ Logging("Found PROGRAM Keyword"); } pname';'{ print_header(); } VAR declist';' { fprintf(c.output_file, ";\n"); } beginning { Logging("Found BEGIN Keyword"); }statlist END { Logging("Found END. Keyword Terminate program"); }

pname 	: ID						{ $$ = $1; Logging("Found program name"); }
		;
declist : dec ':' type					{ printType(); }
		| dec type				{ yyerror("Missing : "); }
		;

dec 	: ID',' dec 					{ addString($1); }
		| ID dec				{ yyerror("Missing , "); }
		| ID					{ $$ = $1; addString($1); }
		;

statlist	: stat';' statlist	    		{ $$ = $1; }
			| stat';'			{ $$ = $1; Logging("Found last stat;"); }
			| stat				{ yyerror("Missing ;"); }
			;

stat	: print					{ $$ = $1; fprintf(c.output_file, ";\n"); }
		| assign				{ $$ = $1; fprintf(c.output_file, ";\n"); }
		;

print	: PRINT'(' output ')'		{ $$ = $3; }
		| PRINT output ')'			{ yyerror("Missing ( "); }
		| PRINT '(' output			{ yyerror("Missing ) "); }
		;

output	: QUOTE',' ID              			{  Logging("Printing string = "); checkID($3); fprintf(c.output_file, "cout << %s << %s", $1, $3);}
        | ID                        			{  Logging("Printing just ID"); fprintf(c.output_file, "cout << %s", $1);  }
		;

assign	: ID '=' expr					{ Logging("Assignning"); fprintf(c.output_file, "%s = %s", $1, $3);  checkID($1); }
		| ID expr				{ yyerror("Missing = "); }
		;

expr	: term						{ $$ = $1; }
		| expr '+' term				{ $$ = $1;  Logging("Recognize +"); strcat($$, " + "); strcat($$, $3);}
		| expr '-' term				{  $$ = $1; Logging("Recognize -"); strcat($$, " - "); strcat($$, $3);}
		;

term 	: term '*' factor				{ $$ = $1;  Logging("Recognize *"); strcat($$, " * "); strcat($$, $3);}
		| term '/' factor			{ $$ = $1;  Logging("Recognize /"); strcat($$, " / "); strcat($$, $3);}
		| factor				{ $$ = $1;}
		;

factor	: ID						{ $$ = $1; checkID($1); }
		| number				{  $$ = $1; }
		| '(' expr ')'				{ $$ = $2; }
		| expr ')'				{ yyerror("Missing ( "); }
		| '(' expr 				{ yyerror("Missing ) "); }
		;

type	: INTEGER					{ $$ = $1; Logging("Found type"); }
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
	Logging("Printing header ... ");
	fprintf(c.output_file, "%s\n", "#include <iostream>");
	fprintf(c.output_file, "%s\n", "using namespace std;");
	fprintf(c.output_file, "%s\n", "int main() {");
}

void Logging(const char * msg)
{
    fprintf(c.log_file, "%s on line %d\n", msg, yylineno);
    
}

void addString(char *s)
{
	if (numStrings > 14)
	{
		printf("Have to many variables has to be less than 15\n");
		return;
	}
	strcpy(str[numStrings], s);
	numStrings += 1;

}

void checkID(char *s)
{
    int i;
    int stringflag = 1;
    for (i = 0; i < numStrings; i++)
    {
        if (strcmp(str[i], s) == 0)
        {
            stringflag = 0;
        }
    }
    
    if (stringflag == 1)
    {
        yyerror("UNKNOWN IDNETIFIER");
    }
}

void printType()
{
	int i;
	// Print the type
	fprintf(c.output_file, "int ");

	// Print all the declared variables
	for (i = 0; i < numStrings - 1; i++ )
	{
		fprintf(c.output_file, "%s, ", str[i]);
	}
	
	// Print the last in the array
	fprintf(c.output_file, "%s", str[numStrings - 1]);
}

void yyerror (const char *s)
{

	printf("%s on line %d\n", s, yylineno);

}
