global check_trie

%define NULL 0

%define NODO_SIGUIENTE 0
%define NODO_HIJOS 8
%define NODO_LETRA 16
%define NODO_FIN 17
%define NODO_SIZE 18

;La implementación devuelve el primer nodo desordenado recorriendo estilo DFS

check_trie:
;nodo** check_trie(trie* t)

push rbp
mov rbp, rsp
sub rsp, 8
push rbx
push r12
push r13

    ;Me fijo si me pasaron NULL
    cmp rdi, NULL
    je .fin

    ;Trie vacío está ordenado
    mov r12, [rdi]; r8 = raiz*
    cmp r12, NULL
    je .ordenado

    ;Trie* es igual a **nodo
    mov rbx, rdi

;Itero por los nodos de cada nivel, y para cada uno hago un llamado recursivo para su hijo.
.ciclo:
    
    mov r8, [r12 + NODO_HIJOS]

    cmp r8, NULL
    je .avanzo_nivel; Si no tiene hijo avanzo en el nivel

    ;Si existe hago el llamado recursivo
    ;Creo un doble puntero que hace de trie*
    ;Mi nueva "raiz" es el hijo del nodo actual

    mov [rbp - 8], r8
    lea rdi, [rbp - 8]
    call check_trie
    
    ;Me fijo si me llego el resultado de mi llamado recursivo
    cmp rax, NULL
    jne .fin

.avanzo_nivel:
    mov r13, [r12 + NODO_SIGUIENTE]
    
    cmp r13, NULL

    ;Si llegue al final del nivel entonces todo lo anterior estaba ordenado
    je .ordenado

    ;No llegue al final, veo si el nodo actual es el desordenado
    xor rdi, rdi
    mov rdi, [r12 + NODO_LETRA]

    xor rsi, rsi
    mov rsi, [r13 + NODO_LETRA]

    cmp rdi, rsi
    jg .no_ordenado

    ;Avanzo en el nivel e itero de nuevo
    mov r12, r13
    jmp .ciclo

.no_ordenado:
    mov rax, rbx
    jmp .fin

.ordenado:
    mov rax, NULL

.fin:

pop r13
pop r12
pop rbx
add rsp, 8
pop rbp
ret