       IDENTIFICATION DIVISION.
       PROGRAM-ID. menutype.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       COPY crudstr.
       01  WS-TYPE-NAME         PIC X(20).
       01  WS-TYPE-ID           PIC 9(10).

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
                   DISPLAY "Enter the book type : "
                   ACCEPT WS-TYPE-NAME

                   CALL "creatype" USING 
                        WS-TYPE-NAME
                   END-CALL
      
               WHEN WS-READ-STRING
                   DISPLAY "Enter the book type id: "
                   ACCEPT WS-TYPE-ID

                   CALL "readtype" USING 
                        WS-TYPE-ID
                        WS-TYPE-NAME
                   END-CALL 

               WHEN WS-UPDATE-STRING
                   DISPLAY "Enter the book type id: "
                   ACCEPT WS-TYPE-ID
           
                   DISPLAY "Enter the book type : "
                   ACCEPT WS-TYPE-NAME

                   CALL "updttype" USING
                       WS-TYPE-ID
                       WS-TYPE-NAME
                   END-CALL 
                   
               WHEN WS-DELETE-STRING
                   DISPLAY "Enter the book type id: "
                   ACCEPT WS-TYPE-ID


                   CALL "delttype" USING 
                       WS-TYPE-ID
                   END-CALL
                   
               
               WHEN WS-QUIT-STRING
               SET WS-QUIT-Y TO TRUE 

           END-EVALUATE

       END-PERFORM.

       EXIT PROGRAM.
       