/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/2/2024
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <string.h>
#include <alcd.h>
#include <io.h>
#include <stdlib.h>
#include <stdbool.h>

//function's
void delay(int time);
int slowWrite(char mesg[16], int x , int y);
void baseInput ();
int getInput();
int getAns();
void clear();
void segShow(int num);
int counter(int num , bool upCount , bool owerCount , int delayNum);
void end();

//global variable 
int cmp = 100 ; 
int count =-1  ;
int number;
int flag = 0;
int answer;
bool upCounter , owerCounter;
unsigned char segd[10] = {0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xd8,0x80,0x90};
int delayNum = 0;

void main(void)
{
char mesg[16]; 
DDRB = 0b11111000;
DDRC = 0xFF;
DDRD = 0x7F;

//LCD PORT
DDRA=0x00;
PORTA=0x00;

lcd_init(16);

// Timer/Counter0 
TCCR0 = (1 << WGM01) | (1 << CS01) | (1 << CS00); // CTC mode, prescaler = 64
OCR0 = 125;

// Enable Timer/Counter0 Compare Match A interrupt

TIMSK = (1 << OCIE0);       
    #asm("sei");
    while (1) {
            baseInput();
                 
            strcpy(mesg,"ok let's start");;
            slowWrite(mesg ,0,0);
            delay(100);
            strcpy(mesg,"base:");;
            slowWrite(mesg ,0,0);
            itoa(number , mesg);
            slowWrite(mesg ,7,0);
            strcpy(mesg,(upCounter)?"enUP":"enDOWN");;
            slowWrite(mesg ,10,0);
            strcpy(mesg,"counter :");
            slowWrite(mesg ,0,1); 
            
            counter(number , upCounter , owerCounter , delayNum);
            end();
            break;
            
    }
}

interrupt [TIM0_COMP] void timer0_comp_isr(void) {
    count ++;   
    if (count == cmp) {
        count = 0;
        flag = 1;
    }
}

void delay(int time){
    cmp = time;
    count = 0 ;
    while(flag == 0);
    flag=0;  
}

void baseInput () {
    char mesg[16]; 
    int ans;
    int i ;
    
     
    lcd_gotoxy(0,0);
    lcd_putsf("Hello !");
    //lcd_gotoxy(0,1);
    strcpy(mesg,"it's counter!");
    slowWrite(mesg ,0,1);
    delay(100);
    clear();
    strcpy(mesg,"use * as # to answer");
    slowWrite(mesg ,0,0);
    //clear();
    
    //lcd_gotoxy(0,0);
    strcpy(mesg,"* is yes # is no");
    slowWrite(mesg ,0,1);
    delay(150);
    //lcd_puts(mesg);
    clear();
    strcpy(mesg,"                ");
    strcpy(mesg,"Get start?");
    slowWrite(mesg ,0,1);
    
    answer = 0;
    while (answer != 1 ){answer = getAns();}
    answer = 0;     
    
    //Get the initial value--------------------------------------------------
    do {
        clear();
        strcpy(mesg,"Enter the base:");
        slowWrite(mesg ,0,0);
        PORTC=~segd[0];
        PORTD=~segd[0];
        ans = getInput();
        while (ans<0){ans = getInput();delay(50);}
        delay(50);
        PORTC=~segd[ans];
        itoa(ans,mesg);
        lcd_gotoxy(7 , 1);
        lcd_puts(mesg);
        ans = ans*10;
        i = getInput();
        delay(20);
        ans = (i<0)?ans/10:ans+i;
        PORTD=~segd[(ans%10)];
        itoa(ans,mesg);
        lcd_gotoxy(7 , 1);
        lcd_puts(mesg);
        delay(20);
         
        clear();
        strcpy(mesg,"your base is:");
        slowWrite(mesg ,0,0);
        itoa(ans,mesg);
        lcd_gotoxy(13 , 0);
        lcd_puts(mesg);
        strcpy(mesg,"you confirm?");
        slowWrite(mesg ,0,1);
        
        answer = getAns();  
    }while(answer == 0);
    
    number = ans;
    clear();
    
    strcpy(mesg,"you can see base");
    slowWrite(mesg ,0,0);
    strcpy(mesg,"on 7SEGMENT--->");
    slowWrite(mesg ,0,1);
    segShow(number);
    delay(100);
    //strcpy(mesg,"on 7seg --> ");
    //lcd_gotoxy(0,0);
    //lcd_puts(mesg);
    //strcpy(mesg,"Count up or down ?");
    //slowWrite(mesg ,0,1);
    
    //Get the counter status --------------------------------------------------
    strcpy(mesg,"Count up or down ?");
    lcd_gotoxy(0,0);
    lcd_puts(mesg);
    strcpy(mesg,"# down    * up ");
    slowWrite(mesg ,0,1);
    ans = getAns();
    upCounter = (ans)? true:false;
    
    (!upCounter)?strcpy(mesg,"set count down"):strcpy(mesg,"set count up");
    clear();
   // strcpy(mesg,(upCounter)?"set count up":"set count down");
    slowWrite(mesg ,0,0);
    delay(100);
    
    //Get the delay value--------------------------------------------------
    strcpy(mesg,"How long is");
    slowWrite(mesg ,0,0);
    strcpy(mesg,"delay?  X  * 1ms");
    slowWrite(mesg ,0,1);
    i = 0 ;
    ans = 0 ;
    do {
         
        ans = getInput();
        delay(40);
        
        if (ans >= 0){
            delayNum *=10 ; 
            delayNum += ans;
            i++;
            itoa(ans,mesg);
            lcd_gotoxy(6+i,1);
            lcd_puts(mesg);
        }
        
        if (i == 1){
            strcpy(mesg," ");
            lcd_gotoxy(8,1);
            lcd_puts(mesg);
        }
        
          
    }while(0<=ans && i<6 );
    
    
    //initialise state of the overflow--------------------------------------------------
    clear();
    strcpy(mesg,"Should I stop");
    slowWrite(mesg ,0,0);
    strcpy(mesg,"after owerflow?");
    slowWrite(mesg ,0,1);
    delay(150);
    strcpy(mesg,"stop *        ");;
    lcd_gotoxy(0,0);
    lcd_puts(mesg);
    strcpy(mesg,"continue #    ");
    lcd_gotoxy(0,1);
    lcd_puts(mesg);
    ans = getAns();
    owerCounter = (ans == 1) ? false:true;
    clear();

}

int getInput(){
    while(1){
        PORTB=0x08;
            if (PINB.0==1){delay(50);PORTB=0x00;return 3;}
            if (PINB.1==1){delay(50);PORTB=0x00;return 2;}
            if (PINB.2==1){delay(50);PORTB=0x00;return 1;}
        PORTB=0x10;
            if (PINB.0==1){delay(50);PORTB=0x00;return 6;}
            if (PINB.1==1){delay(50);PORTB=0x00;return 5;}
            if (PINB.2==1){delay(50);PORTB=0x00;return 4;}
        PORTB=0x20;
            if (PINB.0==1){delay(50);PORTB=0x00;return 9;}
            if (PINB.1==1){delay(50);PORTB=0x00;return 8;}
            if (PINB.2==1){delay(50);PORTB=0x00;return 7;}                
        PORTB=0x40;
            if (PINB.0==1){delay(50);PORTB=0x00;return -2;}// # = -2 => 0
            if (PINB.1==1){delay(50);PORTB=0x00;return 0;}
            if (PINB.2==1){delay(50);PORTB=0x00;return -1;}// * = -1 => 1
     } 
}
int getAns(){
    int tmp =0;
    while (1){
        tmp = getInput();
        if (tmp < 0)
            break;
    }
    return (tmp == -1) ? 1:0 ; 
}
int slowWrite(char mesg[16], int x , int y){
    int i;
    char chr='';
    lcd_gotoxy(x,y);
    for (i=0;i<=15;i++){
        delay(4);
        lcd_gotoxy((x+i),y);
        
        chr = mesg[i];
        lcd_putchar(chr);
    }
    strcpy(mesg,"                   ");
    return 0;
}
void clear (){
    char mesg[16];
    strcpy(mesg,"                ");
    lcd_gotoxy(0,0);
    lcd_puts(mesg);
    lcd_gotoxy(0,1);
    lcd_puts(mesg);
}
void segShow(int num){
    PORTC =~segd[(num-(num%10))/10];
    PORTD =~segd[num%10];
}

int counter(int num , bool upCount , bool owerCount, int delayNum){
    char mesg[16];
    
    while(1){
       while (PIND.7==0);
       if (PINB.7==1 && PORTD.7==0)
            return 0 ;          
       num += (upCount)? 1:-1;                         
       
       if ( num==100 || num == -1 ){
            if (!owerCount)
                return 0;
            num = (upCount)? 0:99;
            strcpy(mesg,"   ");
            lcd_gotoxy(10,1);
            lcd_puts(mesg);

       }
       segShow(num);
       itoa(num,mesg);
       lcd_gotoxy(10,1);
       lcd_puts(mesg);
       delay(delayNum);
    }
}
void end(){
    char mesg[16];
    int ans;
    clear();
    strcpy(mesg,"continue ?");
    slowWrite(mesg ,0,1);
    
    ans = getAns();
    if (ans==1)
        main();
    
    clear();
    strcpy(mesg,"goodbye ");
    slowWrite(mesg ,0,1);
}