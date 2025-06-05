       IDENTIFICATION DIVISION.
       PROGRAM-ID. menuauth.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 03-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       COPY crudstr.
       01  WS-AUTHOR-LASTNAME   PIC X(25).
       01  WS-AUTHOR-FIRSTNAME  PIC X(25).
       01  WS-AUTHOR-ID         PIC 9(10).

       01 WS-QUIT      PIC X   VALUE "n".
           88 WS-QUIT-N        VALUE "n".
           88 WS-QUIT-Y        VALUE "Y".

       01 WS-CRUD   PIC X(10).

       COPY retstatu REPLACING ==:PREFIX:== BY ==WS==.


       PROCEDURE DIVISION.
       


       SET WS-QUIT-N TO TRUE.

       PERFORM UNTIL WS-QUIT-Y
           DISPLAY "Choose an operation : "
           DISPLAY WS-CREATE-STRING " / " 
                   WS-READ-STRING " / " 
                   WS-UPDATE-STRING " / "
                   WS-DELETE-STRING " / "
                   WS-QUIT-STRING 
      
           ACCEPT WS-CRUD
           
           EVALUATE WS-CRUD
      
               WHEN WS-CREATE-STRING
                   DISPLAY "Enter author's lastname : "
                   ACCEPT WS-AUTHOR-LASTNAME
                   DISPLAY "Enter author's firstname  : "
                   ACCEPT WS-AUTHOR-FIRSTNAME

                   CALL "creaauth" USING 
                        WS-AUTHOR-LASTNAME
                        WS-AUTHOR-FIRSTNAME
                        WS-RETURN-VALUE
                   END-CALL

                   EVALUATE TRUE
                       WHEN WS-RETURN-OK
                           DISPLAY "Authors insert successful"
                       WHEN WS-RETURN-ALREADY-HERE
                           DISPLAY "Author already exists"
                       WHEN WS-RETURN-ERROR
                           DISPLAY "Author read/insert error"
                   END-EVALUATE
      
               WHEN WS-READ-STRING
                   DISPLAY "Enter author's last name: "
                   ACCEPT WS-AUTHOR-LASTNAME
                   DISPLAY "Enter author's first name: "
                   ACCEPT WS-AUTHOR-FIRSTNAME

                   CALL "readauth" USING 
                        WS-AUTHOR-LASTNAME
                        WS-AUTHOR-FIRSTNAME
                        WS-AUTHOR-ID
                        WS-RETURN-VALUE
                   END-CALL 

                   EVALUATE TRUE
                       WHEN WS-RETURN-OK
                           DISPLAY "id : " WS-AUTHOR-ID
                                   " | "
                                   "Last name : " WS-AUTHOR-LASTNAME
                                   " | "
                                   "First name : " WS-AUTHOR-FIRSTNAME
                           DISPLAY "Reading successful"
                       WHEN WS-RETURN-NOT-FOUND
                           DISPLAY "Record not found"
                       WHEN WS-RETURN-ERROR
                           DISPLAY "Authors read error"
                   END-EVALUATE
               WHEN WS-UPDATE-STRING
                   DISPLAY "Enter author's id: "
                   ACCEPT WS-AUTHOR-ID
           
                   DISPLAY "Enter author's lastname : "
                   ACCEPT WS-AUTHOR-LASTNAME
                   DISPLAY "Enter author's firstname  : "
                   ACCEPT WS-AUTHOR-FIRSTNAME

                   CALL "updtauth" USING
                       WS-AUTHOR-ID
                       WS-AUTHOR-LASTNAME
                       WS-AUTHOR-FIRSTNAME
                   END-CALL 
                   
               WHEN WS-DELETE-STRING
                   DISPLAY "Enter author's id: "
                   ACCEPT WS-AUTHOR-ID

                   CALL "deltauth" USING 
                       WS-AUTHOR-ID
                   END-CALL
                   
               
               WHEN WS-QUIT-STRING
               SET WS-QUIT-Y TO TRUE 

           END-EVALUATE

       END-PERFORM.

       EXIT PROGRAM.