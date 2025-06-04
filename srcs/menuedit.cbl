       IDENTIFICATION DIVISION.
       PROGRAM-ID. menuedit.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       COPY utils.
       COPY retstatu REPLACING ==:PREFIX:== BY ==WS==.

       01 WS-USER-INPUT       PIC X(10).

       01 WS-USER-NAME-INPUT  PIC X(25).
       01 WS-ID               PIC 9(10).

       PROCEDURE DIVISION.

           PERFORM 0100-MENU-EDIT-BEGIN
              THRU 0100-MENU-EDIT-END.

           EXIT PROGRAM.
           
       0100-MENU-EDIT-BEGIN.
           DISPLAY WS-SEPARATION-LINE.
           DISPLAY "Editors interface".
           DISPLAY WS-SEPARATION-LINE.
           MOVE SPACE TO WS-USER-INPUT.
           PERFORM UNTIL WS-USER-INPUT EQUAL WS-QUIT-STRING
               PERFORM 0200-DISPLAY-MENU-EDIT-BEGIN
                  THRU 0200-DISPLAY-MENU-EDIT-END
               ACCEPT WS-USER-INPUT
               EVALUATE WS-USER-INPUT
                   WHEN WS-CREATE-STRING
                       PERFORM 0300-CREATE-EDITOR-BEGIN
                          THRU 0300-CREATE-EDITOR-END
                   WHEN WS-READ-STRING
                       PERFORM 0400-READ-EDITOR-BEGIN
                          THRU 0400-READ-EDITOR-END
                   WHEN WS-UPDATE-STRING
                       CALL "updtedit"
                   WHEN WS-DELETE-STRING
                       CALL "deltedit"
               END-EVALUATE
           END-PERFORM.
       0100-MENU-EDIT-END.

       0200-DISPLAY-MENU-EDIT-BEGIN.
           DISPLAY WS-CREATE-STRING " / "
                   WS-READ-STRING   " / "
                   WS-UPDATE-STRING " / "
                   WS-DELETE-STRING " / "
                   WS-QUIT-STRING ".".
       0200-DISPLAY-MENU-EDIT-END.

       0300-CREATE-EDITOR-BEGIN.
           DISPLAY "What is the name of the new editor?"
           ACCEPT WS-USER-NAME-INPUT.
           CALL "creaedit" USING
               WS-USER-NAME-INPUT
               WS-RETURN-VALUE
           END-CALL.
       0300-CREATE-EDITOR-END.

       0400-READ-EDITOR-BEGIN.
           DISPLAY "What name do you want to check?".
           ACCEPT WS-USER-NAME-INPUT.
           CALL "readedit" USING
                WS-USER-NAME-INPUT
                WS-ID
                WS-RETURN-VALUE
           END-CALL.
           EVALUATE TRUE
               WHEN WS-RETURN-OK
                   DISPLAY "The id is : " WS-ID
               WHEN WS-RETURN-NOT-FOUND
                   DISPLAY "Record not found."
               WHEN WS-RETURN-ERROR
                   DISPLAY "Read error."
           END-EVALUATE.
       0400-READ-EDITOR-END.
       