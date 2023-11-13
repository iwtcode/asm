all:
	nasm -g -f elf64 lab3.asm -l lab3.lst -F dwarf
	gcc -m64 -o lab3 lab3.o -fno-pie -no-pie
	rm *.o *.lst