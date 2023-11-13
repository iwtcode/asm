#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stdint.h>

float a, b;
double res_up, res_dn, result;
int32_t d;

extern void asm_func();

// вариант 19
// (-35/b+d-b)/(1+a*b/4)

int main(void) {
	printf("input a, b (float), d (int): ");
	scanf("%f %f %d", &a, &b, &d);
	res_up = (-35/b+d-b);
	res_dn = (1+a*b/4);
	result = res_up/res_dn;
	printf("c   | res_up: %.3f | res_dn: %.3f | result: %.3f\n", res_up, res_dn, result);
	res_up = 0; res_dn = 0; result = 0;
	asm_func();
	printf("asm | res_up: %.3f | res_dn: %.3f | result: %.3f\n", res_up, res_dn, result);
	
	return 0;
};
