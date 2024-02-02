/*
 * finalProject.c
 *
 * Created: 2/2/2024 7:18:03 AM
 * Author: 13
 */

#include <io.h>
int comp = 100 ; 
int count =0  ;
int number;
void main(void)
{
unsigned char segd[10] = {0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xd8,0x80,0x90};
DDRB = 0xFF;
DDRA=0xff;
DDRC = 0xFF;
DDRD = 0xFF;
PORTD = 0x0F;

    // Timer/Counter0 
    TCCR0 = (1 << WGM01) | (1 << CS01) | (1 << CS00); // CTC mode, prescaler = 64
    OCR0 = 125;

    // Enable Timer/Counter0 Compare Match A interrupt
    TIMSK = (1 << OCIE0);

    #asm("sei");
    while (1) {
        
        if (count == 0) {
            
            PORTC = ~segd[i];
            count = 0;
        }
    }
}

interrupt [TIM0_COMP] void timer0_comp_isr(void) {
    PORTD = 0x01;
    count ++;
    if (count == 100) {
        i++;
        count = 0;
    }
}