       IDENTIFICATION DIVISION.
       PROGRAM-ID. menubook.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 05-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY crudstr.
       COPY retstatu REPLACING ==:PREFIX:== BY ==WS==.

       01  WS-BOOK-ID           PIC 9(10).
       01  WS-BOOK-NAME         PIC X(50).
      
       01  WS-BOOK-ISBN         PIC X(13).
       01  WS-BOOK-YEAR         PIC 9(04).

       01  WS-AUTHOR-LASTNAME   PIC X(25).
       01  WS-AUTHOR-FIRSTNAME  PIC X(25).
       01  WS-AUTHOR-ID         PIC 9(10).
       
       01  WS-TYPE-NAME         PIC X(20).
       01  WS-TYPE-ID           PIC 9(10).
       
       01  WS-EDITOR-NAME               PIC X(25).
       01  WS-EDITOR-ID                 PIC 9(10).

       01 WS-QUIT      PIC X   VALUE "n".
           88 WS-QUIT-N        VALUE "n".
           88 WS-QUIT-Y        VALUE "Y".

       01 WS-CRUD   PIC X(10).
       
       01 WS-USER-RESPONSE         PIC X.
           88 WS-USER-RESPONSE-N           VALUE "n".
           88 WS-USER-RESPONSE-Y           VALUE "Y".

       01 WS-OUT-HDR.
           05 FILLER          PIC X(10) VALUE "id".
           05 FILLER          PIC X(03) VALUE " | ".
           05 FILLER          PIC X(13) VALUE "isbn".
           05 FILLER          PIC X(03) VALUE " | ".
           05 FILLER          PIC X(25) VALUE "book name".
           05 FILLER          PIC X(03) VALUE " | ".
           05 FILLER          PIC X(04) VALUE "year".
           05 FILLER          PIC X(03) VALUE " | ".
           05 FILLER          PIC X(25) VALUE "author first_name".
           05 FILLER          PIC X(03) VALUE " | ".
           05 FILLER          PIC X(25) VALUE "author last_name".
           05 FILLER          PIC X(03) VALUE " | ".
           05 FILLER          PIC X(25) VALUE "editor name".
           05 FILLER          PIC X(03) VALUE " | ".
           05 FILLER          PIC X(25) VALUE "type name".

       01 WS-OUT-SEPARATION-LINE.
           05 FILLER          PIC X(10) VALUE ALL "-".
           05 FILLER          PIC X(03) VALUE "-*-".
           05 FILLER          PIC X(13) VALUE ALL "-".
           05 FILLER          PIC X(03) VALUE "-*-".
           05 FILLER          PIC X(25) VALUE ALL "-".
           05 FILLER          PIC X(03) VALUE "-*-".
           05 FILLER          PIC X(04) VALUE ALL "-".
           05 FILLER          PIC X(03) VALUE "-*-".
           05 FILLER          PIC X(25) VALUE ALL "-".
           05 FILLER          PIC X(03) VALUE "-*-".
           05 FILLER          PIC X(25) VALUE ALL "-".
           05 FILLER          PIC X(03) VALUE "-*-".
           05 FILLER          PIC X(25) VALUE ALL "-".
           05 FILLER          PIC X(03) VALUE "-*-".
           05 FILLER          PIC X(25) VALUE ALL "-".

       01 WS-OUT-LINE.
           05 WS-OUT-BOOK-ID       PIC X(10).
           05 FILLER               PIC X(03) VALUE " | ".
           05 WS-OUT-BOOK-ISBN     PIC X(13).
           05 FILLER               PIC X(03) VALUE " | ".
           05 WS-OUT-BOOK-NAME     PIC X(25).
           05 FILLER               PIC X(03) VALUE " | ".
           05 WS-OUT-YEAR          PIC 9(04).
           05 FILLER               PIC X(03) VALUE " | ".
           05 WS-OUT-AUTHOR-FNAME  PIC X(25).
           05 FILLER               PIC X(03) VALUE " | ".
           05 WS-OUT-AUTHOR-NAME   PIC X(25).
           05 FILLER               PIC X(03) VALUE " | ".
           05 WS-OUT-EDITOR-NAME   PIC X(25).
           05 FILLER               PIC X(03) VALUE " | ".
           05 WS-OUT-TYPE-NAME     PIC X(25).

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
                   DISPLAY "Enter book's isbn : "
                   ACCEPT WS-BOOK-ISBN
                   DISPLAY "Enter book's release year : "
                   ACCEPT WS-BOOK-YEAR
                   
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
                                   CALL "readauth" USING 
                                        WS-AUTHOR-LASTNAME 
                                        WS-AUTHOR-FIRSTNAME
                                        WS-AUTHOR-ID
                                        WS-RETURN-VALUE
                                   END-CALL 
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
                                   CALL "readtype" USING 
                                       WS-TYPE-NAME
                                       WS-TYPE-ID
                                       WS-RETURN-VALUE
                                   END-CALL 
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
                   ACCEPT WS-EDITOR-NAME 
                   CALL "readedit" USING 
                        WS-EDITOR-NAME 
                        WS-EDITOR-ID
                        WS-RETURN-VALUE
                   END-CALL 

                   EVALUATE TRUE
                       WHEN WS-RETURN-NOT-FOUND
                           DISPLAY 
                           "Do you want to create an editor ?"
                           ACCEPT WS-USER-RESPONSE
       
                           IF WS-USER-RESPONSE-Y
                               CALL "creaedit" USING
                                     WS-EDITOR-NAME
                                     WS-RETURN-VALUE
                               END-CALL 
                               
                               IF  WS-RETURN-OK
                               DISPLAY "Editor added successfully"
                                   CALL "readedit" USING 
                                       WS-EDITOR-NAME 
                                       WS-EDITOR-ID
                                       WS-RETURN-VALUE
                                   END-CALL 
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

                   CALL "creabook" USING
                       WS-BOOK-ISBN
                       WS-BOOK-NAME
                       WS-BOOK-YEAR
                       WS-AUTHOR-ID
                       WS-EDITOR-ID
                       WS-TYPE-ID
                       WS-RETURN-VALUE
                   END-CALL

               WHEN WS-READ-STRING
                   DISPLAY "Enter book's name: "
                   ACCEPT WS-BOOK-NAME
       
                   CALL "readbook" USING 
                        WS-BOOK-NAME
                        WS-BOOK-ID
                        WS-BOOK-ISBN,
                        WS-BOOK-YEAR,
                        WS-AUTHOR-LASTNAME,
                        WS-AUTHOR-FIRSTNAME,
                        WS-EDITOR-NAME,
                        WS-TYPE-NAME,
                        WS-RETURN-VALUE
                   END-CALL 

                   EVALUATE TRUE
                       WHEN WS-RETURN-OK
                           PERFORM 0500-MOVE-BOOK-TO-OUT-LINE-BEGIN
                              THRU 0500-MOVE-BOOK-TO-OUT-LINE-END
                           PERFORM 0600-DISPLAY-OUT-LINE-BEGIN
                              THRU 0600-DISPLAY-OUT-LINE-END
                       WHEN WS-RETURN-NOT-FOUND
                           DISPLAY "Record not found"
                       WHEN WS-RETURN-ERROR
                           DISPLAY "Book read error"
                   END-EVALUATE
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
               WHEN WS-DELETE-STRING
                   DISPLAY "Enter book's name: "
                   ACCEPT WS-BOOK-NAME
       
                   CALL "deltbook" USING 
                       WS-BOOK-NAME
                       WS-BOOK-ID,
                       WS-BOOK-ISBN,
                       WS-BOOK-YEAR,
                       WS-AUTHOR-LASTNAME,
                       WS-AUTHOR-FIRSTNAME,
                       WS-EDITOR-NAME,
                       WS-TYPE-NAME,
                       WS-RETURN-VALUE
                   END-CALL
                   
                   EVALUATE TRUE
                       WHEN WS-RETURN-OK
                           PERFORM 0500-MOVE-BOOK-TO-OUT-LINE-BEGIN
                              THRU 0500-MOVE-BOOK-TO-OUT-LINE-END
                           DISPLAY WS-OUT-SEPARATION-LINE
                           DISPLAY WS-OUT-HDR
                           DISPLAY WS-OUT-SEPARATION-LINE
                           DISPLAY WS-OUT-LINE
                           DISPLAY WS-OUT-SEPARATION-LINE
                           DISPLAY "Was successfully deleted."
                       WHEN WS-RETURN-NOT-FOUND
                           DISPLAY "Record not found."
                       WHEN WS-RETURN-ERROR
                           DISPLAY "Read/Delete error."
                   END-EVALUATE
               
               WHEN WS-QUIT-STRING
               SET WS-QUIT-Y TO TRUE 

           END-EVALUATE

       END-PERFORM.

       EXIT PROGRAM.

       0500-MOVE-BOOK-TO-OUT-LINE-BEGIN.
           MOVE WS-BOOK-ID          TO WS-OUT-BOOK-ID.
           MOVE WS-BOOK-ISBN        TO WS-OUT-BOOK-ISBN.
           MOVE WS-BOOK-NAME        TO WS-OUT-BOOK-NAME.
           MOVE WS-BOOK-YEAR        TO WS-OUT-YEAR.
           MOVE WS-AUTHOR-FIRSTNAME TO WS-OUT-AUTHOR-FNAME.
           MOVE WS-AUTHOR-LASTNAME  TO WS-OUT-AUTHOR-NAME.
           MOVE WS-EDITOR-NAME      TO WS-OUT-EDITOR-NAME.
           MOVE WS-TYPE-NAME        TO WS-OUT-TYPE-NAME.
       0500-MOVE-BOOK-TO-OUT-LINE-END.
       
       0600-DISPLAY-OUT-LINE-BEGIN.
           DISPLAY WS-OUT-SEPARATION-LINE.
           DISPLAY WS-OUT-HDR.
           DISPLAY WS-OUT-SEPARATION-LINE.
           DISPLAY WS-OUT-LINE.
           DISPLAY WS-OUT-SEPARATION-LINE.
       0600-DISPLAY-OUT-LINE-END.
