# CPSC323
Our git repository for our CPSC323 Compiler Project

##To create all the files run the load.sh script
I am using linux don't know how to use this in other operating systems
It should create these files
* lex.yy.c
* y.tab.h
* y.tab.c
* project.out _This is executable_

###How to Compile this 
yacc -d project.y
lex project.l
gcc lex.yy.c y.tab.c -o project.out
