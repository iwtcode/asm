all:
	gcc -m64 -g -ggdb -c -o ctest.o ctest.c
	nasm -g -f elf64 lab5.asm -l lab5.lst -F dwarf
	gcc -m64 -o ctest ctest.o lab5.o -fno-pie -no-pie
	rm *.o *.lst