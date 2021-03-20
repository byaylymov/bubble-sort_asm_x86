%include "io.inc"
section .data
list: DD 5,1,4,9,2,3,7,6,0   ;List must end with 0!
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov eax, list
    xor ebx, ebx
    call list_length
    PRINT_STRING "List length:"
    NEWLINE
    PRINT_DEC 4, ebx
    NEWLINE
 
    mov esi, list   ; [esi] = start address of list
    mov ecx, ebx    ; [ecx] = Number of elements
    PRINT_STRING "Unsorted list:"
    NEWLINE   
    call print_list
    NEWLINE
    call bubble_sort
    PRINT_STRING "Sorted list:"
    NEWLINE
    call print_list
    NEWLINE
    ret   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
list_length:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cmp byte [eax + ebx * 4], 0
    je length_found
    inc ebx
    jmp list_length
length_found:
    ret    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
bubble_sort:   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; [esi] = start address of list
    ; [ecx] = Number of elements
    pushad
reset:   
    xor ebx, ebx    ; first number
    xor edx, edx    ; second number
    xor eax, eax
    xor edi, edi    ; 1st counter
    xor ecx, ecx    ; 2nd counter
    mov ecx, 4
    mov eax, 4
sort_loop:
    mov ebx, [esi + edi]    ; [ebx] = first number
    cmp ebx, 0              ; check for last 0
    je test_sorted
    mov edx, [esi + ecx]    ; [edx] = second number
    cmp edx, 0              ; check for last 0
    je test_sorted
    cmp ebx, edx            ; compare the two numbers
    jg swap
    add edi, eax
    add ecx, eax
    jmp sort_loop
swap:
    xchg ebx, [esi + ecx]
    mov [esi + edi], ebx
    add edi, eax
    add ecx, eax
    jmp sort_loop    
test_sorted:
    push ebx
    push edx
    push eax
    push edi
    push ecx
    
    xor ebx, ebx    ; first number
    xor edx, edx    ; second number
    xor eax, eax
    xor edi, edi    ; 1st counter
    xor ecx, ecx    ; 2nd counter
    mov ecx, 4
    mov eax, 4
test_sorted_loop:    
    mov ebx, [esi + edi]
    mov edx, [esi + ecx]
    cmp ebx, 0
    je end
    cmp edx, 0
    je end
    cmp ebx, edx
    jg nope
    add edi, eax
    add ecx, eax  
    jmp test_sorted_loop  
nope:
    pop ecx
    pop edi
    pop eax
    pop edx
    pop ebx
    jmp reset
end:
    pop ecx
    pop edi
    pop eax
    pop edx
    pop ebx
    popad
    ret       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_list:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Output array
    ; [eax] Start address of an array
    ; [ecx] Number of elements in an array
    pushad    
    xor ebx, ebx    ; Column in ebx
    xor edx, edx    ; Row in eax
print_next_column:
    cmp ebx, ecx    ; Last column edited?
    je print_last_column
    ; [ebx] Column number S
    ; [edx] Row number Z
    ; [ecx] Number of elements in an array
    mov eax, edx    ; Z
    mov ebp, edx
    mul ecx         ; Z*N
    mov edx, ebp
    add eax, ebx    ; Z*N+S
    mov edi, eax    ; Save the address
    PRINT_DEC 4, [esi+edi*4]
    PRINT_STRING " "
    inc ebx         ; Next column    
    jmp print_next_column
print_last_column:
    inc edx         ; Next row
    xor ebx, ebx    ; Column index at 0
end_print:
    popad  
    ret