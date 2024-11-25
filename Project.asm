INCLUDE Irvine32.inc

.data
    promptChoice BYTE "Choose an option (1-5):", 0
    option1 BYTE "1. Add Member", 0
    option2 BYTE "2. Add Books", 0
    option3 BYTE "3. Show Inventory", 0
    option4 BYTE "4. Borrow Book", 0
    option5 BYTE "5. Return Books", 0
    option6 BYTE "6. Exit Program", 0
    choice BYTE "Enter your choice: ", 0
    msgInvalid BYTE "Invalid option!", 0
    memberCount DWORD 0
    members DWORD 5 DUP(?)
    msgMemberAdded BYTE "Member added successfully!", 0
    fullMember BYTE "Members Full.", 0


.code
main PROC
    call Clrscr
    call DisplayMenu
    exit
main ENDP

DisplayMenu PROC
    Display:
        call crlf
        mov edx, OFFSET promptChoice
        call WriteString
        call crlf
        mov edx, OFFSET option1
        call WriteString
        call crlf
        mov edx, OFFSET option2
        call WriteString
        call crlf
        mov edx, OFFSET option3
        call WriteString
        call crlf
        mov edx, OFFSET option4
        call WriteString
        call crlf
        mov edx, OFFSET option5
        call WriteString
        call crlf
        mov edx, OFFSET option6
        call WriteString
        call crlf
        mov edx, OFFSET choice
        call WriteString
        call ReadInt
        call ProcessChoice
    cmp eax, 0
    jne Display
    ret
DisplayMenu ENDP

ProcessChoice PROC
    push eax
    cmp eax, 1
    je AddMember
    cmp eax, 6
    je endd
    mov edx, OFFSET msgInvalid
    call WriteString
    pop eax
    ret
ProcessChoice ENDP

AddMember PROC
    ; Code to add a member
    push eax
    cmp memberCount, 5
    jge MemberFull
    mov eax, memberCount
    inc memberCount
    mov members[eax*4], eax ; Store member ID
    mov edx, OFFSET msgMemberAdded
    call WriteString
    jmp EndAddMember

MemberFull:
    ; Handle case where the member array is full
    mov edx, OFFSET fullMember
    call WriteString

EndAddMember:
    pop eax
    call DisplayMenu
    ret
AddMember ENDP

AddBook PROC
    push eax
    ; Code to add a book
EndAddBook:
    pop eax
    call DisplayMenu
    ret
AddBook ENDP

ShowInventory PROC
    push eax
    ; Code to show inventory
EndShowInventory:
    pop eax
    call DisplayMenu
    ret
ShowInventory ENDP

BorrowBook PROC
    push eax
    ; Code to borrow a book
EndBorrowBook:
    pop eax
    call DisplayMenu
    ret
BorrowBook ENDP

ReturnBook PROC
    push eax
    ; Code to return a book
EndReturnBook:
    pop eax
    call DisplayMenu
    ret
ReturnBook ENDP

endd:
    exit
END main
