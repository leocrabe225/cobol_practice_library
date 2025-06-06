       IDENTIFICATION DIVISION.
       PROGRAM-ID. blibrary.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 03-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       COPY sepline.

       01 WS-BOOKS-STRING      PIC X(10) VALUE "BOOKS".
       01 WS-BORROWINGS-STRING PIC X(10) VALUE "BORROWINGS".
       01 WS-PEOPLE-STRING     PIC X(10) VALUE "PEOPLE".
       01 WS-TYPES-STRING      PIC X(10) VALUE "TYPES".
       01 WS-AUTHORS-STRING    PIC X(10) VALUE "AUTHORS".
       01 WS-EDITORS-STRING    PIC X(10) VALUE "EDITORS".
       01 WS-STATS-STRING      PIC X(10) VALUE "STATS".
       01 WS-FILE-STRING       PIC X(10) VALUE "FILE".
       01 WS-QUIT-STRING       PIC X(10) VALUE "QUIT".

       01 WS-USER-INPUT        PIC X(10).

       01 WS-IN-FILE-NAME      PIC X(20).

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
           
           CALL "initdb".

      *    ACCEPT WS-IN-FILE-NAME.
      *    CALL "readfile" USING WS-IN-FILE-NAME.

           PERFORM 0100-MAIN-MENU-BEGIN
              THRU 0100-MAIN-MENU-END.

           PERFORM 9900-DISCONNECT-SQL-BEGIN
              THRU 9900-DISCONNECT-SQL-END.

           STOP RUN.

       0100-MAIN-MENU-BEGIN.
           PERFORM UNTIL WS-USER-INPUT EQUAL WS-QUIT-STRING
               PERFORM 0200-DISPLAY-MAIN-MENU-BEGIN
                  THRU 0200-DISPLAY-MAIN-MENU-END
               ACCEPT WS-USER-INPUT
               EVALUATE WS-USER-INPUT
                   WHEN WS-BOOKS-STRING
                       CALL "menubook"
                   WHEN WS-BORROWINGS-STRING
                       PERFORM NO-OP
                   WHEN WS-PEOPLE-STRING
                       CALL "menupple"
                   WHEN WS-TYPES-STRING
                       CALL "menutype"
                   WHEN WS-AUTHORS-STRING
                       CALL "menuauth"
                   WHEN WS-EDITORS-STRING
                       CALL "menuedit"
                   WHEN WS-STATS-STRING
                       PERFORM NO-OP
                   WHEN WS-FILE-STRING
                       PERFORM 0300-READFILE-BEGIN
                          THRU 0300-READFILE-END
               END-EVALUATE
           END-PERFORM.
       0100-MAIN-MENU-END.

       0200-DISPLAY-MAIN-MENU-BEGIN.
           DISPLAY WS-SEPARATION-LINE.
           DISPLAY "Main menu"
           DISPLAY WS-SEPARATION-LINE.
           DISPLAY "What do you want to do ?".
           DISPLAY FUNCTION TRIM(WS-BOOKS-STRING)
                   " - Interact directly with books".
           DISPLAY FUNCTION TRIM(WS-BORROWINGS-STRING)
                   " - Interact directly with borrowings".
           DISPLAY FUNCTION TRIM(WS-PEOPLE-STRING)
                   " - Interact directly with borrowers".
           DISPLAY FUNCTION TRIM(WS-TYPES-STRING) 
                  " - Interact directly with book genres".
           DISPLAY FUNCTION TRIM(WS-AUTHORS-STRING) 
                  " - Interact directly with authors".
           DISPLAY FUNCTION TRIM(WS-EDITORS-STRING) 
                  " - Interact directly with editors".
           DISPLAY FUNCTION TRIM(WS-STATS-STRING) 
                  " - Get some stats".
           DISPLAY FUNCTION TRIM(WS-FILE-STRING) 
                  " - Input file into library".
           DISPLAY FUNCTION TRIM(WS-QUIT-STRING) 
                  " - Quit program".
       0200-DISPLAY-MAIN-MENU-END.

       0300-READFILE-BEGIN.
           DISPLAY "What file do you want to insert into the database?".
           ACCEPT WS-IN-FILE-NAME.
           CALL 'readfile' USING
               WS-IN-FILE-NAME
           END-CALL.
       0300-READFILE-END.

       9900-DISCONNECT-SQL-BEGIN.
       EXEC SQL
           DISCONNECT ALL
       END-EXEC.
       9900-DISCONNECT-SQL-END.

       NO-OP.
