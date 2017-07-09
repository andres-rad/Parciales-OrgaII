%define NODO_IZQ 0
%define NODO_VALUE 8 ; por padding.
%define NODO_DER 16
%define NULL 0
%define TAM_NODO 24

section .text

extern malloc
extern free
global expandir
global comprimir

expandir:
  push rbp ; align
  mov rbp, rsp
  push r12
  push r13 ; align

  mov r12, rdi
  mov r13, rsi

  cmp r12, NULL
  je .fin

  mov rdi, [r12+NODO_DER]
  mov rsi, r13
  call expandir
  mov rdi, r12
  mov rsi, r13
  call expandirIzq
.fin:
  pop r13
  pop r12
  pop rbp
  ret

expandirIzq:
  push rbp
  mov rbp, rsp
  push r12
  push r13
  push r14
  push r15

  mov r12, rdi ; Padre
  mov r13, [r12+NODO_IZQ] ; Hijo izquierdo
  mov rdi, r13
  mov r14, rsi
  call expandir ; expande su hijo, sigue la recursion hasta nodos hojas
  mov rdi, r12 ; padre
  mov rsi, r13 ; Hijo
  call [r14] ; llamo a funcion.
  mov r15, rax ; val a agregar
  mov rdi, TAM_NODO
  call malloc
  mov qword [rax+NODO_VALUE], r15
  mov qword [rax+NODO_IZQ], r13 ; a la izquierda tiene al hijo original de la izquierda
  mov qword [rax+NODO_DER], NULL
  mov qword [r12+NODO_IZQ], rax ; el padre ahora apunta a lo que me dio malloc (nuevo nodo)
  pop r15
  pop r14
  pop r13
  pop r12
  pop rbp
  ret

comprimir:
  ; TODO
