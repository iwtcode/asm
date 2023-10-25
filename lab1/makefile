all:
	gcc -m64 -g -ggdb -c -o ctest.o ctest.c
	nasm -g -f elf64 lab1.asm -l lab1.lst -F dwarf
	gcc -m64 -o ctest ctest.o lab1.o -fno-pie -no-pie
	rm *.o *.lst