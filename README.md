# CPSC323
Our git repository for our CPSC323 Compiler Project

##To create all the files run the load.sh script
I am using linux don't know how to use this in other operating systems
It should create these files
* lex.yy.c
* y.tab.h
* y.tab.c
* project.out _This is executable_

##How to use it on linux

	./project.out < final.txt

###How to Compile this 
1. yacc -d project.y
2. lex project.l
3. gcc lex.yy.c y.tab.c -o project.out
