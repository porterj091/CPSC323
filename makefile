project.out : lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c -o project.out
lex.yy.c: y.tab.c project.l
	lex project.l
y.tab.c: project.y
	yacc -d project.y
clean:
	rm -f lex.yy.c y.tab.c y.tab.h project.out
