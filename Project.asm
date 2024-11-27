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
    dot BYTE " . ", 0
    memberCount DWORD 0
    members DWORD 5 DUP(?)
    books BYTE 5 DUP(30 DUP(?))
    author BYTE 5 DUP(30 DUP(?))
    genre BYTE 5 DUP(30 DUP(?))
    publicationYear DWORD 5 DUP(0)
    bookCount DWORD 0
    takeBookName BYTE "Enter name of the book: ", 0
    authorName BYTE "Enter author of the book: ", 0
    takeYear BYTE "Enter publication year: ", 0
    takeGenre BYTE "Enter genre of the book: ", 0
    temp DWORD 0
    nameBook BYTE "Book Name: ", 0
    auth BYTE "Author: ", 0
    gnr BYTE "Genre: ", 0
    pby BYTE "Publication Year: ", 0
    borrowedBooks DWORD 5 DUP(0)
    borrowInput BYTE "Enter ISBN(Index) of book you want to borrow: ", 0
    noBookMatch BYTE "No book of this ISBN!", 0
    msgMemberAdded BYTE "Member added successfully!", 0
    msgBookAdded BYTE "Book added successfully!", 0
    msgBorrowed BYTE "Book borrowed successfully!", 0
    msgReturned BYTE "Book returned successfully!", 0
    msgNoNeed BYTE "No books were borrowed!", 0
    noSpace BYTE "Library Full.", 0
    msgNoBooks BYTE "No books.", 0
    fullMember BYTE "Members Full.", 0
    msgNoMember BYTE "No member in the library.", 0
    set DWORD 0

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
    cmp eax, 2
    je AddBook
    cmp eax, 3
    je ShowInventory
    cmp eax, 4
    je BorrowBook
    cmp eax, 5
    je ReturnBook
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
    ; Code to add a book
    push eax
    cmp bookCount, 5
    jge BookFull
    mov ecx, 5
    mov esi, OFFSET books
    mov edi, OFFSET author
    mov ebx, OFFSET genre
    TakingInput:
        push ecx
        TakingName:
            mov edx, OFFSET takeBookName
            call WriteString
            mov edx,esi
            mov ecx,30
            call ReadString
            add esi,30
        TakingAuthor:  
            mov edx, OFFSET authorName
            call WriteString
            mov edx, edi
            mov ecx,30
            call ReadString
            add edi, 30
        TakingGenre:  
            mov edx, OFFSET takeGenre
            call WriteString
            mov edx, ebx
            mov ecx,30
            call ReadString
            add ebx, 30
        TakingYear:  
            mov edx, OFFSET takeYear
            call WriteString
            call ReadDec
        mov edx, OFFSET msgBookAdded
        call WriteString
        call crlf
        mov edx, bookCount
        inc bookCount
        mov borrowedBooks[edx * 4], 1
        mov publicationYear[edx * 4], eax
        pop ecx
        dec ecx
        cmp ecx, 0
        je EndAddBook
        jmp TakingInput
BookFull:
    ; Handle case where the book array is full
    mov edx, OFFSET noSpace
    call WriteString

EndAddBook:
    pop eax
    call DisplayMenu
    ret
AddBook ENDP

ShowInventory PROC
    push eax
    cmp memberCount, 0
    je NoMembers
    cmp bookCount, 0
    je NoBooks

    mov ecx, 5
    mov esi, OFFSET books
    mov edi, OFFSET author
    mov ebx, OFFSET genre
    PrintLoop:
        mov edx, OFFSET nameBook
        call WriteString
        mov edx, esi
        call WriteString
        call crlf

        mov edx, OFFSET auth
        call WriteString
        mov edx, edi
        call WriteString
        call crlf

        mov edx, OFFSET gnr
        call WriteString
        mov edx, ebx
        call WriteString
        call crlf
        mov edx, temp
        inc temp
        mov eax, publicationYear[edx * 4]
        mov edx, OFFSET pby
        call WriteString
        call WriteDec
        call crlf
        call crlf

        add esi, 30
        add edi, 30
        add ebx, 30
        loop PrintLoop
jmp EndShowInventory

NoMembers:
    mov edx, OFFSET msgNoMember
    call WriteString
    jmp EndShowInventory

NoBooks:
    mov edx, OFFSET msgNoBooks
    call WriteString
       
EndShowInventory:
    pop eax
    call DisplayMenu
    ret
ShowInventory ENDP

BorrowBook PROC
    ; Code to borrow a book
    push eax
    cmp memberCount, 0
    je NoMembers
    cmp bookCount, 0
    je NoBooks

    mov ecx, 5
    mov eax, 0
    mov esi, OFFSET books
PrintLoop:
    call WriteDec
    inc eax
    mov edx, OFFSET dot
    call WriteString
    mov edx, esi
    call WriteString
    call crlf
    add esi, 30
    loop PrintLoop


Borrowing:
    mov edx, OFFSET borrowInput
    call WriteString
    call ReadDec
    mov ecx, eax

    ; Check if the index is valid
    cmp ecx, 0
    jl NoBook
    cmp ecx, bookCount
    jge NoBook

    mov eax, borrowedBooks[ecx * 4]
    cmp eax, 0
    je NoBook

    cmp eax, 2
    je AlreadyBorrowed

    ; Mark the book as borrowed
    mov borrowedBooks[ecx * 4], 2 ; Mark as borrowed
    mov edx, OFFSET msgBorrowed
    call WriteString
    jmp EndBorrowBook
   

AlreadyBorrowed:
    mov edx, OFFSET msgNoBooks
    call WriteString
    jmp EndBorrowBook

NoBook:
    mov edx, OFFSET noBookMatch
    call WriteString
    jmp EndBorrowBook

NoMembers:
    mov edx, OFFSET msgNoMember
    call WriteString
    jmp EndBorrowBook

NoBooks:
    mov edx, OFFSET msgNoBooks
    call WriteString

EndBorrowBook:
    pop eax
    call DisplayMenu
    ret
BorrowBook ENDP

ReturnBook PROC
    ; Code to return a book
    push eax
    cmp memberCount, 0
    je NoMembersReturn

    mov ebx, 0
    mov ecx, 5
    Checking:
    mov eax, borrowedBooks[ebx * 4]
    cmp eax, 0
    je continue
    cmp eax, 1
    je continue
    cmp eax, 2
    jne continue
    mov borrowedBooks[ebx * 4], 0
    mov edx, OFFSET msgReturned
    call WriteString
    call crlf
    mov set, 1
    continue:
        inc ebx
        loop Checking

cmp set, 0
jne EndReturnBook
NoBooksBorrowed:
    mov edx, OFFSET msgNoNeed
    call WriteString
    jmp EndReturnBook

NoMembersReturn:
    mov edx, OFFSET msgNoMember
    call WriteString

EndReturnBook:
    pop eax
    call DisplayMenu
    ret
ReturnBook ENDP

endd:
    exit
END main
