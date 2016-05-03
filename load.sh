#!/bin/bash
echo "Starting to run load.sh"
echo "Creating yacc files"
echo "======================================="
yacc -d project.y
echo "Creating lex files"
echo "======================================="
lex project.l
echo "Running gcc compiler to link all files"
echo "======================================="
gcc lex.yy.c y.tab.c -o project.out
