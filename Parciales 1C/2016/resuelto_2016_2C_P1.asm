;typedef struct node_t {
;int value;
;node *derecha;
;node *izquierda;
;} node;

;(25p) Construir una funcion en ASM que determine si el arbol esta ordenado. La misma debe respetar
;la aridad void ordenado(node* arbol, node** desordenado), tomando como paramentro
;el puntero al primer nodo del arbol y un doble puntero a nodo donde sera almacenado el puntero
;al subarbol mas peque~no que resulte estar desordenado. En el caso que el arbol este ordenado, se
;escribira en desordenado un cero.
extern malloc
extern free
global ordenado

; como no es packed entonces  alinea al mas grande, en este caso es 8 bytes el puntero.
%define IZQ 16
%define DER 8
%define VAL 0
%define NULL 0

section .text

ordenado:
  push rbp
  mov rbp, rsp

  cmp rdi, NULL
  je .fin




.fin:
  pop rbp
  ret
