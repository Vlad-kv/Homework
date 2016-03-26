;  Vladislav Kiselyov, M3139
;
;  subtraction
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
     cmp eax, [len_str2];
     jnbe @f;
       mov eax, [len_str2];
     @@:
     mov [max_len], eax;

     mov ecx, [max_len];	   ; Addition of the first number
     mov [str1 + ecx + 1], 0;	   ; with the leading zero to max_len
     mov edx, [len_str1];
     @@:
       dec edx;
       mov ah, [str1 + edx];
       mov [str1 + ecx], ah;
       dec ecx;
       cmp edx, 0;
     jnz @b;

     @@:
       mov [str1 + ecx], 48;
       dec ecx;
       cmp ecx, 0;
     jnl @b;

     mov ecx, [max_len];	   ; Addition of the second number
     mov [str2 + ecx + 1], 0;	   ; with the leading zero to max_len
     mov edx, [len_str2];
     @@:
       dec edx;
       mov ah, [str2 + edx];
       mov [str2 + ecx], ah;
       dec ecx;
       cmp edx, 0;
     jnz @b;

     @@:
       mov [str2 + ecx], 48;
       dec ecx;
       cmp ecx, 0;
     jnl @b;


     mov [inv], 0;
     xor ebx, ebx;
     mov edx, [max_len];
     inc edx;
     @@:			    ; comparing numbers
       cmp ebx, edx;
       je metka04;
       mov al, [str1 + ebx];
       cmp al, [str2 + ebx];
       jb metka03;
       ja metka04;

       inc ebx;
       jmp @b;

       metka03:

       mov [inv], 1;
       mov ebx, -1;		     ;  if the first number less than second swap their,
       @@:                           ;  inv = 1
	 inc ebx;
	 cmp ebx, edx;
	 je @f;
	 mov al, [str1 + ebx];
	 mov ah, [str2 + ebx];
	 mov [str1 + ebx], ah;
	 mov [str2 + ebx], al;
	 jmp @b;
       @@:
     @@:

     metka04:

     mov ecx, [max_len];	   // subtraction
     mov [str3 + ecx + 1], 0;
     xor bh, bh;
     @@:
       mov ah, [str1 + ecx];
       sub ah, [str2 + ecx];
       sub ah, bh;
       add ah, 48;
       xor bh, bh;
       cmp ah, 48;
       jge metka01;
	 mov bh, 1;		  
	 add ah, 10;
       metka01:
       mov [str3 + ecx], ah;
       dec ecx;
       cmp ecx, 0
     ja @b;

     mov [str3], 48;
     sub [str3], bh;


     mov esi, -1;

     @@:			 ; removal of the excess leading zero
       inc esi;
       cmp [str3 + esi], 48;
     je @b;

     mov edx, [max_len];
     inc edx;

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

     cmp [inv], 0;
     je @f;
       cinvoke printf, mn;
     @@:

     invoke puts, str3;

    ;cinvoke scanf, rw_string, str1;

    ;invoke  sleep, 5000     ; 5 sec. delay
gtfo:	invoke	exit, 0

str1 db 5001 dup (?), 0
str2 db 5001 dup (?), 0
str3 db 5002 dup (?), 0

rw_int db '%d', 0;

mn db "-", 0;

rw_string db '%s', 0;

rw_char db '%hc', 0;

len_str1 dd ?
len_str2 dd ?
max_len dd ?
inv dd ?

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