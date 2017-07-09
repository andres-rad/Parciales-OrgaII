;
;struct pos {
; pos * cuad1;
; pos* cuad2;
; pos* cuad3;
; pos* cuad4;
; info* data;
;}
;(void rotate(pos* cuad)
;que realiza un movimiento de los punteros a los cuadrantes de la siguiente manera:
; cuad1 -> cuad2, cuad2 -> cuad3, cuad3 -> cuad4 y cuad4 -> cuad1.
; Esta rotacion debe realizarse para el cuadrante cuad pasado por parametro
;y para todos sus cuadrantes sucesivamente de forma recursiva.
extern malloc
extern free

%define CUAD1 0
%define CUAD2 8
%define CUAD3 16
%define CUAD4 24
%define DATA 32

global rotate
global trim

section .text

rotate:
  push rbp
  mov rbp, rsp
  push r12
  push r13
  push r14
  push r15

  cmp rdi, NULL
  je .fin

  push rdi ; resguardo pos* original
  push rax ; alineo

  mov r12, [rdi + CUAD1];cuad1
  mov r13, [rdi + CUAD2];cuad2
  mov r14, [rdi + CUAD3];cuad3
  mov r15, [rdi + CUAD4];cuad4

  mov rdi, r12
  call rotate

  mov rdi, r13
  call rotate

  mov rdi, r14
  call rotate

  mov rdi, r15
  call rotate

  pop rax
  pop rdi ; recupero pos original

  mov [rdi+CUAD1], r15 ;(4 a 1)
  mov [rdi+CUAD2], r12 ;(1 a 2)
  mov [rdi+CUAD3], r13 ;(2 a 3)
  mov [rdi+CUAD4], r14 ;(3 a 4)
.fin:
  pop r15
  pop r14
  pop r13
  pop r12
  pop rbp
  ret


;Implementar en ASM la funcion borrar hojas (void trim(pos* cuad, void* f_unir)), que se
;encarga de buscar todos los cuadrantes hoja (es decir aquellos en los cuales los punteros a cuadrantes
;son nulos) y unir sus datos con los de su padre por medio de la funcion f_unir pasada por parametro.
;La aridad de la funcion es la siguiente: info* f_unir(info* padre, info* hoja).
;Nota: se sugiere implementar la funcion auxiliar boolean esHoja(pos* cuad).
trim:
  push rbp
  mov rbp, rsp
  cmp rdi, NULL
  je .fin

  push r12
  push r13
  push r14
  push r15

  mov r12, rdi ; pointer to function
  mov r13, rsi ;func unir

    mov r14, [r12 + CUAD1]
    mov rdi, r14
    call trim
    mov rdi, r14
    call esHoja
    cmp rax, 0
    je .seguir2
  .unir1:
    mov rdi, [r12 + DATA]
    mov rsi, [r14 + DATA]
    call [r13]
    mov qword[r12 + DATA], rax
  .seguir2:
    mov r14, [r12 + CUAD2]
    mov rdi, r14
    call trim
    mov rdi, r14
    call esHoja
    cmp rax, 0
    je .seguir3
  .unir2:
    mov rdi, [r12 + DATA]
    mov rsi, [r14 + DATA]
    call [r13]
    mov qword[r12 + DATA], rax
  .seguir3:
    mov r14, [r12 + CUAD3]
    mov rdi, r14
    call trim
    mov rdi, r14
    call esHoja
    cmp rax, 0
    je .seguir4
  .unir3:
    mov rdi, [r12 + DATA]
    mov rsi, [r14 + DATA]
    call [r13]
    mov qword[r12 + DATA], rax

  .seguir4:
    mov r14, [r12 + CUAD4]
    mov rdi, r14
    call trim
    mov rdi, r14
    call esHoja
    cmp rax, 0
    je .seguir4
  .unir4:
    mov rdi, [r12 + DATA]
    mov rsi, [r14 + DATA]
    call [r13]
    mov qword[r12 + DATA], rax

  pop r15
  pop r14
  pop r13
  pop r12
.fin:
  pop rbp
  ret

esHoja:
  push rbp
  mov rbp, rsp
  push r12
  push r13
  push r14
  push r15
  mov r12, [rdi + CUAD1];cuad1
  mov r13, [rdi + CUAD2];cuad2
  mov r14, [rdi + CUAD3];cuad3
  mov r15, [rdi + CUAD4];cuad4

  or r12, r13
  or r12, r14
  or r12, r15
  cmp r12, NULL
  je .esHoja
  .noEsHoja:
    mov rax, 0
    jmp .fin
  .esHoja:
    mov rax, 1
.fin:
  pop r15
  pop r14
  pop r13
  pop r12
  pop rbp
  ret
