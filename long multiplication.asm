;  Vladislav Kiselyov, M3139
;
;  multiplication
;
;  
;  first and second numbers < 10^5000
;
;  x86-64, Windows 7
;
;  compiler - flat assembler 1.71.51
;

 format PE console 4.0
 
include 'win32a.inc'
start:
     cinvoke scanf, rw_string, str1;
     cinvoke scanf, rw_string, str2;

     mov eax, -1;
     @@:
       inc eax;
       cmp [str1 + eax], 0;
       jne @b;
     mov [len_str1], eax;

     mov eax, -1;
     @@:
       inc eax;
       cmp [str2 + eax], 0;
       jne @b;
     mov [len_str2], eax;

     mov eax, [len_str1];
     add eax, [len_str2];
     mov [ans_len], eax;

     xor esi, esi;

     @@:		     ; zeroing str3
       mov [str3 + eax], 0;
       dec eax;
       inc esi;
       cmp eax, 0;
     jnl @b;

     mov esi, [len_str1];	  ; multiplication
     metka01:			  ; esi from len_str1 to 0
       dec esi; 		  ; edi from len_str2 to 0
       mov cl, [str1 + esi];
       sub cl, 48;

       mov edi, [len_str2];
       metka02:

	 dec edi;
	 mov dl, [str2 + edi];
	 sub dl, 48;

	 mov al, cl;
	 mul dl;
	 add al, [str3 + esi + edi + 1];

	 mov ah, 0;
	 @@:
	   cmp al, 10;	    ; instead of division
	   jb @f;
	   sub al, 10;
	   inc ah;
	   jmp @b;
	 @@:

	 mov [str3 + esi + edi + 1], al;
	 add [str3 + esi + edi], ah;

	 cmp edi, 0;
       jne metka02;

       cmp esi, 0;
     jne metka01;

     xor esi, esi;		 ; removal of the excess leading zero
     mov edi, [ans_len];
     @@:
       add [str3 + esi], 48;
       inc esi;
       cmp esi, edi;
     jb @b;

     mov esi, -1;

     @@:
       inc esi;
       cmp [str3 + esi], 48;
     je @b;

     mov edx, [ans_len];

     cmp esi, edx;
     jne @f;
       dec esi;
     @@:

     xor ebx, ebx;
     @@:
       mov al, [str3 + esi];
       mov [str3 + ebx], al;
       inc ebx;
       inc esi;
       cmp esi, edx;
     jng @b;

     mov [str3 + ebx], 0;

     invoke puts, str3;
    ; cinvoke scanf, rw_string, str1;

    ;invoke  sleep, 5000     ; 5 sec. delay
gtfo:	invoke	exit, 0

str1 db 5001 dup (?), 0
str2 db 5001 dup (?), 0
str3 db 10004 dup (?), 0

rw_int db '%d',0;

rw_string db '%s',0;

rw_char db '%hc',0;

len_str1 dd ?
len_str2 dd ?
ans_len dd ?

 data import
 
 library msvcrt,'MSVCRT.DLL',\
    kernel32,'KERNEL32.DLL'
 
 import kernel32,\
    sleep,'Sleep'
 
 import msvcrt,\
    puts,'puts',\
    scanf,'scanf',\
	printf,'printf',\ 
    exit,'exit'
end data