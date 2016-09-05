    %include "sdl.asm"
    %include "gl.asm"

    extern window

    global loop

section .text

loop:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 0x40

    ;   is running
    mov     BYTE [rbp - 0x39], 1
    
    loop_event:
        lea     rdi, [rbp - 0x38]
        call    SDL_PollEvent
        cmp     rax, 0
        je     loop_main

        cmp     DWORD [rbp - 0x38], SDL_QUIT
        je      case_quit
        jmp     loop_event

        case_quit:
            mov     BYTE [rbp - 0x39], 0
            jmp     loop_event

    loop_main:

        pxor    xmm0, xmm0
        pxor    xmm1, xmm1
        pxor    xmm2, xmm2
        pxor    xmm3, xmm3
        call    [glClearColor]

        mov     rdi, GL_COLOR_BUFFER_BIT
        call    [glClear]

        mov     rdi, QWORD [window]
        call    SDL_GL_SwapWindow

        cmp     BYTE [rbp - 0x39], 1
        je      loop_event

    add     rsp, 0x40
    pop     rbp
    xor     rax, rax
    ret
