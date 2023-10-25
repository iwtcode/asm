#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

int16_t a_i, b_i;
int res_i;

uint16_t a_ui, b_ui;
int res_ui;

extern void int16_asm(void);
extern void uint16_asm(void);

void test(char);

//вариант 19
//(a == b) : a/(b-4)
//(a > b) : 64
//(a < b) : a*b+8

int main(void) {
	printf("choose variation:\n1 - int16\n2 - uint16\n");
	char c;
	c = getchar();
	if(c == '1') {
		printf("input a, b (-32768 - 32767): ");
		scanf("%hd%hd", &a_i, &b_i);
		if(b_i-4 != 0) {
			if (a_i == b_i) res_i = a_i/(b_i-4);
			else if (a_i > b_i) res_i = 64;
			else if(a_i < b_i) res_i = a_i*b_i+8;

			printf("с: %d\n", res_i);
			res_i = 0;
			int16_asm();
			printf("asm: %d\n", res_i);
		}
		else printf("exeption: division by zero\n");
	}
	else if(c == '2') {
		printf("input a, b (0 - 65535): ");
		scanf("%hu%hu", &a_ui, &b_ui);
		if(b_ui-4 != 0) {
			if (a_ui == b_ui) res_ui = a_ui/(b_ui-4);
			else if (a_ui > b_ui) res_ui = 64;
			else if(a_ui < b_ui) res_ui = a_ui*b_ui+8;
			printf("с: %d\n", res_ui);
			res_ui = 0;
			uint16_asm();
			printf("asm: %d\n", res_ui);
		}
		else printf("exeption: division by zero\n");
	}
	test(c);
	return 0;
};

void test(char c) {
	signed int res_c;
	if (c == '1') {
		for(a_i = -2000; a_i < 2000; ++a_i) {
			for(b_i = -2000; b_i < 2000; ++b_i) {
				if(b_i-4 != 0) {
					if (a_i == b_i) res_c = a_i/(b_i-4);
					else if (a_i > b_i) res_c = 64;
					else if(a_i < b_i) res_c = a_i*b_i+8;
					res_i = 0;
					int16_asm();
					if(res_i != res_c) {
						printf("exeption: (%d, %d)\n", a_i, b_i);
						printf("с: %d\n", res_c);
						printf("asm: %d\n", res_i);
					}
				}
			}
		}
	}
	else if (c == '2') {
		for(a_ui = -2000; a_ui < 2000; ++a_ui) {
			for(b_ui = -2000; b_ui < 2000; ++b_ui) {
				if(b_ui-4 != 0) {
					if (a_ui == b_ui) res_c = a_ui/(b_ui-4);
					else if (a_ui > b_ui) res_c = 64;
					else if(a_ui < b_ui) res_c = a_ui*b_ui+8;
					res_ui = 0;
					uint16_asm();
					if(res_ui != res_c) {
						printf("exeption: (%d, %d)\n", a_ui, b_ui);
						printf("с: %d\n", res_c);
						printf("asm: %d\n", res_ui);
					}
				}
			}
		}
	}
	printf("test complete!\n");
}