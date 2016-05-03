#!/bin/bash
echo "Starting to run load.sh"
echo "Creating yacc files"
yacc -d project.y
echo "Creating lex files"
lex project.l
echo "Running gcc compiler to link all files"
gcc lex.yy.c y.tab.c -o project.out
