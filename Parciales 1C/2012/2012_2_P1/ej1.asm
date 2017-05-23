global ordenarCadena

extern free
extern malloc

%define NULL 0
%define OFFSET_BASE 0
%define OFFSET_PAREJA 1
%define OFFSET_INFERIOR 9
%define ESLABON_SIZE 17

ordenarCadena:
;eslabon* ordenarCadena(eslabon* p, enum action_e (*cmp_base)(char* base1, char* base2))

push rbp
mov rbp, rsp
sub rsp, 40
push rbx
push r12
push r13
push r14
push r15

    cmp rdi, NULL
    je .fin

    ;Guardo el puntero a funcion
    mov r15, rsi

    mov [rbp -8], rdi
    lea rbx, [rbp - 8]
    
    mov r12, rdi
    mov r14, [r12 + OFFSET_PAREJA]
    mov [rbp - 16], r14
    lea r13, r14

.sig:

    cmp r12, NULL
    je .fin

    lea rdi, [r12 + OFFSET_BASE]
    lea rsi, [r14 + OFFSET_BASE]
    call r15

    cmp eax, 0
    jnz .duplicar

    mov rax, [r12 + OFFSET_INFERIOR]
    mov [rbx], rax

    mov rax, [r14 + OFFSET_INFERIOR]
    mov [r13], rax

    mov rdi, r12
    call free

    mov r12, [rbx]
    mov r14, [r13]

    jmp .sig

 .duplicar:
    
    mov rdi, ESLABON_SIZE
    call malloc

    ;Actualizo el inferior del lugar de donde vine
    ;Si en la primera iteracion del ciclo se duplica entonces el nodo duplicado es el nuevo primero
    mov [rbx], rax 
    
    ;Copio la base
    mov r8, [r12 + OFFSET_BASE]
    mov [rax + OFFSET_BASE], r8
    
    ;Lo copio arriba del nodo actual
    mov [rax + OFFSET_INFERIOR], r12

    ;Me quede sin registros para guardar :(
    mov [rbp - 24], rax

    ;Creo el eslabon pareja
    mov rdi, ESLABON_SIZE
    call malloc

    mov [r13], rax

    mov r8, [r14 + OFFSET_BASE]

    mov [rax + OFFSET_BASE], r8

    mov [rax + OFFSET_INFERIOR], r14

    ;Recupero al primer nodo creado
    mov r9, [rbp - 24]

    ;Conecto las parejas
    mov [r9 + OFFSET_PAREJA], rax
    mov [rax + OFFSET_PAREJA], r9

    ;Actualizo los doble punteros

    lea rbx, [r12 + OFFSET_INFERIOR]
    mov r12, [r12 + OFFSET_INFERIOR]

    lea r13, [r14 + OFFSET_INFERIOR]
    mov r14, [r14 + OFFSET_INFERIOR]

    jmp .sig  

.fin:
    ;Devuelvo el primer eslabon
    mov rax, [rbp - 8]
    
pop r15
pop r14
pop r13
pop r12
pop rbx
add rsp, 40
pop rbp

ret
