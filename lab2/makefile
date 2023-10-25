all:
	gcc -m64 -g -ggdb -c -o ctest.o ctest.c
	nasm -g -f elf64 lab2.asm -l lab2.lst -F dwarf
	gcc -m64 -o ctest ctest.o lab2.o -fno-pie -no-pie
	rm *.o *.lst