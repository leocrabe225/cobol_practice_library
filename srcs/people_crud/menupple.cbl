       IDENTIFICATION DIVISION.
       PROGRAM-ID. menupple.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 05-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       COPY crudstr.
       01  WS-PERSON-LASTNAME   PIC X(25).
       01  WS-PERSON-FIRSTNAME  PIC X(25).
       01  WS-PERSON-ID         PIC 9(10).

       01 WS-QUIT      PIC X   VALUE "n".
           88 WS-QUIT-N        VALUE "n".
           88 WS-QUIT-Y        VALUE "Y".

       01 WS-CRUD   PIC X(10).

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
                   DISPLAY "Enter person's lastname : "
                   ACCEPT WS-PERSON-LASTNAME
                   DISPLAY "Enter person's firstname  : "
                   ACCEPT WS-PERSON-FIRSTNAME

                   CALL "creapple" USING 
                        WS-PERSON-LASTNAME
                        WS-PERSON-FIRSTNAME
                   END-CALL
      
               WHEN WS-READ-STRING
                   DISPLAY "Enter person's id: "
                   ACCEPT WS-PERSON-ID

                   CALL "readpple" USING 
                        WS-PERSON-ID
                        WS-PERSON-LASTNAME
                        WS-PERSON-FIRSTNAME
                   END-CALL 

               WHEN WS-UPDATE-STRING
                   DISPLAY "Enter person's id: "
                   ACCEPT WS-PERSON-ID
           
                   DISPLAY "Enter person's lastname : "
                   ACCEPT WS-PERSON-LASTNAME
                   DISPLAY "Enter person's firstname  : "
                   ACCEPT WS-PERSON-FIRSTNAME

                   CALL "updtpple" USING
                       WS-PERSON-ID
                       WS-PERSON-LASTNAME
                       WS-PERSON-FIRSTNAME
                   END-CALL 
                   
               WHEN WS-DELETE-STRING
                   DISPLAY "Enter person's id: "
                   ACCEPT WS-PERSON-ID

                   CALL "deltpple" USING 
                       WS-PERSON-ID
                   END-CALL
                   
               
               WHEN WS-QUIT-STRING
               SET WS-QUIT-Y TO TRUE 

           END-EVALUATE

       END-PERFORM.

       EXIT PROGRAM.
       