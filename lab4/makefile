all:
	gcc -m64 -g -ggdb -c -o ctest.o ctest.c
	nasm -g -f elf64 lab4.asm -l lab4.lst -F dwarf
	gcc -m64 -o ctest ctest.o lab4.o -fno-pie -no-pie
	rm *.o *.lst