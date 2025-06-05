       IDENTIFICATION DIVISION.
       PROGRAM-ID. menubook.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 05-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY crudstr.
       COPY retstatu REPLACING ==:PREFIX:== BY ==WS==.
       
       01  WS-BOOK-NAME         PIC X(50).
       01  WS-BOOK-ID           PIC 9(10).

       01  WS-AUTHOR-LASTNAME   PIC X(25).
       01  WS-AUTHOR-FIRSTNAME  PIC X(25).
       01  WS-AUTHOR-ID         PIC 9(10).
       
       01  WS-TYPE-NAME         PIC X(20).
       01  WS-TYPE-ID           PIC 9(10).
       
       01 WS-NAME               PIC X(25).
       01 WS-ID                 PIC 9(10).


       01 WS-QUIT      PIC X   VALUE "n".
           88 WS-QUIT-N        VALUE "n".
           88 WS-QUIT-Y        VALUE "Y".

       01 WS-CRUD   PIC X(10).
       
       01 WS-USER-RESPONSE         PIC X.
           88 WS-USER-RESPONSE-N           VALUE "n".
           88 WS-USER-RESPONSE-Y           VALUE "Y".

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
                   DISPLAY "Enter book's name : "
                   ACCEPT WS-BOOK-NAME

                   CALL "creabook" USING 
                        WS-BOOK-NAME
                   END-CALL
                   
                   DISPLAY "Enter author's lastname : "
                   ACCEPT WS-AUTHOR-LASTNAME
                   DISPLAY "Enter author's firstname  : "
                   ACCEPT WS-AUTHOR-FIRSTNAME
                   
                   CALL "readauth" USING 
                        WS-AUTHOR-LASTNAME 
                        WS-AUTHOR-FIRSTNAME
                        WS-AUTHOR-ID
                        WS-RETURN-VALUE
                   END-CALL 
       
                   EVALUATE TRUE
                       WHEN WS-RETURN-NOT-FOUND
                           DISPLAY 
                           "Do you want to create an author ?"
                           ACCEPT WS-USER-RESPONSE
       
                           IF WS-USER-RESPONSE-Y
                               CALL "creaauth" USING
                                     WS-AUTHOR-LASTNAME 
                                     WS-AUTHOR-FIRSTNAME
                                     WS-RETURN-VALUE
                               END-CALL 

                               IF  WS-RETURN-OK
                               DISPLAY "Author added successfully"
                               END-IF 

                           ELSE 
                               EXIT PROGRAM
                           END-IF   
       
                       WHEN WS-RETURN-ALREADY-HERE
                           DISPLAY 
                            "This author is already in the database."
       
                       WHEN WS-RETURN-ERROR
                           DISPLAY "Author Read/Create error."
                   END-EVALUATE



                   DISPLAY "Enter book's type"
                   ACCEPT WS-TYPE-NAME

                   CALL "readtype" USING 
                        WS-TYPE-NAME
                        WS-TYPE-ID
                        WS-RETURN-VALUE
                   END-CALL 
                   
                   EVALUATE TRUE
                       WHEN WS-RETURN-NOT-FOUND
                           MOVE SPACE TO WS-USER-RESPONSE
                           DISPLAY 
                           "Do you want to create a type of book?"
                           ACCEPT WS-USER-RESPONSE

                           IF WS-USER-RESPONSE-Y
                               CALL "creatype" USING
                                     WS-TYPE-NAME
                                     WS-RETURN-VALUE
                               END-CALL 

                               IF  WS-RETURN-OK
                                DISPLAY "Book type added successfully"
                               END-IF 

                           ELSE 
                               EXIT PROGRAM
                           END-IF   

                       WHEN WS-RETURN-ALREADY-HERE
                           DISPLAY 
                            "This book type is already in the database."

                       WHEN WS-RETURN-ERROR
                           DISPLAY "Types Read/Create error."
                   END-EVALUATE

                   DISPLAY "Enter editor's name : "
                   ACCEPT WS-NAME 
                   CALL "readedit" USING 
                        WS-NAME 
                        WS-ID
                        WS-RETURN-VALUE
                   END-CALL 

                   EVALUATE TRUE
                       WHEN WS-RETURN-NOT-FOUND
                           DISPLAY 
                           "Do you want to create an editor ?"
                           ACCEPT WS-USER-RESPONSE
       
                           IF WS-USER-RESPONSE-Y
                               CALL "creaedit" USING
                                     WS-NAME
                                     WS-RETURN-VALUE
                               END-CALL 
                               
                               IF  WS-RETURN-OK
                               DISPLAY "Editor added successfully"
                               END-IF 

                           ELSE 
                               EXIT PROGRAM
                           END-IF   
       
                       WHEN WS-RETURN-ALREADY-HERE
                           DISPLAY 
                            "This editor is already in the database."
       
                       WHEN WS-RETURN-ERROR
                           DISPLAY "Editor Read/Create error."
                   END-EVALUATE

      *        WHEN WS-READ-STRING
      *            DISPLAY "Enter book's id: "
      *            ACCEPT WS-BOOK-ID
      *
      *            CALL "readbook" USING 
      *                 WS-BOOK-ID
      *                 WS-BOOK-NAME
      *            END-CALL 
      *
      *        WHEN WS-UPDATE-STRING
      *            DISPLAY "Enter book's id: "
      *            ACCEPT WS-BOOK-ID
      *    
      *            DISPLAY "Enter book's name : "
      *            ACCEPT WS-BOOK-NAME
      *
      *            CALL "updtbook" USING
      *                WS-BOOK-ID
      *                WS-BOOK-NAME
      *            END-CALL 
      *            
      *        WHEN WS-DELETE-STRING
      *            DISPLAY "Enter book's id: "
      *            ACCEPT WS-BOOK-ID
      *
      *            CALL "deltbook" USING 
      *                WS-BOOK-ID
      *            END-CALL
                   
               
               WHEN WS-QUIT-STRING
               SET WS-QUIT-Y TO TRUE 

           END-EVALUATE

       END-PERFORM.

       EXIT PROGRAM.
       