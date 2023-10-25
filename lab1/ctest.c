#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
uint8_t a_uc, b_uc, d_uc;
uint16_t divider_uc;
int16_t dividend_uc, res_uc;

int8_t a_sc, b_sc, d_sc;
int16_t divider_sc, dividend_sc, res_sc;

uint16_t a_ui, b_ui, d_ui;
unsigned int divider_ui;
signed int dividend_ui, res_ui;

int16_t a_si, b_si, d_si;
signed int divider_si, dividend_si, res_si;

extern void uint8_asm(void);
extern void int8_asm(void);
extern void uint16_asm(void);
extern void int16_asm(void);

void test(char);

//var 19: (-35/b+d-b)/(1+a*b/4)
int main(void) {
	printf("choose variation:\n1 - uint8\n2 - int8\n3 - uint16\n4 - int16\n");
	char c;
	c = getchar();
	if(c == '1') {
		printf("input a, b, d (0 - 255): ");
		scanf("%hhu%hhu%hhu", &a_uc, &b_uc, &d_uc);
		if(1+a_uc*b_uc/4 != 0 && b_uc!=0) {
			uint8_asm();
			printf("с: %hd / %hu = %hd\n",
				(-35/b_uc+d_uc-b_uc), (1+a_uc*b_uc/4), (-35/b_uc+d_uc-b_uc)/(1+a_uc*b_uc/4));
			printf("asm: %hd / %hu = %hd\n",
				dividend_uc, divider_uc, res_uc);
		}
		else printf("exeption: division by zero\n");
	}
	if(c == '2') {
		printf("input a, b, d (-128 - 127): ");
		scanf("%hhd%hhd%hhd", &a_sc, &b_sc, &d_sc);
		if(1+a_sc*b_sc/4 != 0 && b_sc!=0) {
			int8_asm();
			printf("с: %hd / %hd = %hd\n",
				(-35/b_sc+d_sc-b_sc), (1+a_sc*b_sc/4), (-35/b_sc+d_sc-b_sc)/(1+a_sc*b_sc/4));
			printf("asm: %hd / %hd = %hd\n",
				dividend_sc, divider_sc, res_sc);
		}
		else printf("exeption: division by zero\n");
	}
	if(c == '3') {
		printf("input a, b, d (0 - 65535): ");
		scanf("%hu%hu%hu", &a_ui, &b_ui, &d_ui);
		if(1+a_ui*b_ui/4 != 0 && b_ui!=0) {
			printf("с: %d / %d = %d\n",
				(-35/b_ui+d_ui-b_ui), (1+a_ui/4*b_ui+1), (-35/b_ui+d_ui-b_ui)/(1+a_ui*b_ui/4));
			uint16_asm();
			printf("asm: %d / %d = %d\n",
				dividend_ui, divider_ui, res_ui);
		}
		else printf("exeption: division by zero\n");
	}
	if(c == '4') {
		printf("input a, b, d (-32768 - 32767): ");
		scanf("%hd%hd%hd", &a_si, &b_si, &d_si);
		if(1+a_si*b_si/4 != 0 && b_si!=0) {
			printf("с: %d / %d = %d\n",
				(-35/b_si+d_si-b_si), (1+a_si*b_si/4), (-35/b_si+d_si-b_si)/(1+a_si*b_si/4));
			int16_asm();
			printf("asm: %d / %d = %d\n",
				dividend_si, divider_si, res_si);
		}
		else printf("exeption: division by zero\n");
	}
	test(c);
	return 0;
};

void test(char c) {
	if (c == '1') {
		for(a_uc = 0; a_uc < 255; ++a_uc) {
			for(b_uc = 0; b_uc < 255; ++b_uc) {
				for(d_uc = 0; d_uc < 255; ++d_uc) {
					if(1+a_uc*b_uc/4 != 0 && b_uc!=0) {
						uint8_asm();
						if(res_uc != (-35/b_uc+d_uc-b_uc)/(1+a_uc*b_uc/4)) {
							printf("exeption: (%d, %d, %d)\n", a_uc, b_uc, d_uc);
							printf("с: %hd\n", (-35/b_uc+d_uc-b_uc)/(1+a_uc*b_uc/4));
							printf("asm: %hd\n", res_uc);
						}
					}
				}
			}
		}
	}
	else if (c == '2') {
		for(a_sc = -127; a_sc < 127; ++a_sc) {
			for(b_sc = -127; b_sc < 127; ++b_sc) {
				for(d_sc = -127; d_sc < 127; ++d_sc) {
					if(1+a_sc*b_sc/4 != 0 && b_sc!=0) {
						int8_asm();
						if(res_sc != (-35/b_sc+d_sc-b_sc)/(1+a_sc*b_sc/4)) {
							printf("exeption: (%d, %d, %d)\n", a_sc, b_sc, d_sc);
							printf("с: %hd\n", (-35/b_sc+d_sc-b_sc)/(1+a_sc*b_sc/4));
							printf("asm: %hd\n", res_sc);
						}
					}
				}
			}
		}
	}
	else if (c == '3') {
		for(a_ui = 65000; a_ui < 65535; ++a_ui) {
			for(b_ui = 65000; b_ui < 65535; ++b_ui) {
				for(d_ui = 65000; d_ui < 65535; ++d_ui) {
					if(1+a_ui*b_ui/4 != 0 && b_ui!=0) {
						uint16_asm();
						if(res_ui != (-35/b_ui+d_ui-b_ui)/(1+a_ui*b_ui/4)) {
							printf("exeption: (%d, %d, %d)\n", a_ui, b_ui, d_ui);
							printf("с: %d\n", (-35/b_ui+d_ui-b_ui)/(1+a_ui*b_ui/4));
							printf("asm: %d\n", res_ui);
						}
					}
				}
			}
		}
	}
	else if (c == '4') {
		for(a_si = -32768; a_si < -32200; ++a_si) {
			for(b_si = -32768; b_si < -32200; ++b_si) {
				for(d_si = -32768; d_si < -32200; ++d_si) {
					if(1+a_si*b_si/4 != 0 && b_si!=0) {
						int16_asm();
						if(res_si != (-35/b_si+d_si-b_si)/(1+a_si*b_si/4)) {
							printf("exeption: (%d, %d, %d)\n", a_si, b_si, d_si);
							printf("с: %d\n", (-35/b_si+d_si-b_si)/(1+a_si*b_si/4));
							printf("asm: %d\n", res_si);
						}
					}
				}
			}
		}
	}
	printf("test complete!\n");
}