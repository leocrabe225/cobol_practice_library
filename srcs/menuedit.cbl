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
       01 WS-USER-NAME-INPUT-2 PIC X(25).
       01 WS-ID               PIC 9(10).

       01 WS-OUT-HDR.
           05 WS-OUT-HDR-ID   PIC X(10) VALUE "id".
           05 FILLER          PIC X(03) VALUE " | ".
           05 WS-OUT-HDR-NAME PIC X(25) VALUE "name".

       01 WS-OUT-SEPARATION-LINE.
           05 FILLER          PIC X(10) VALUE ALL "-".
           05 FILLER          PIC X(03) VALUE "-*-".
           05 FILLER          PIC X(25) VALUE ALL "-".

       01 WS-OUT-LINE.
           05 WS-OUT-ID       PIC X(10).
           05 FILLER          PIC X(03) VALUE " | ".
           05 WS-OUT-NAME     PIC X(25).

       PROCEDURE DIVISION.

           PERFORM 0100-MENU-EDIT-BEGIN
              THRU 0100-MENU-EDIT-END.

           EXIT PROGRAM.
           
       0100-MENU-EDIT-BEGIN.
           DISPLAY WS-SEPARATION-LINE.
           DISPLAY "Editors interface".
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
                       PERFORM 0500-UPDATE-EDITOR-BEGIN
                          THRU 0500-UPDATE-EDITOR-END
                   WHEN WS-DELETE-STRING
                       PERFORM 0600-DELETE-EDITOR-BEGIN
                          THRU 0600-DELETE-EDITOR-END
               END-EVALUATE
           END-PERFORM.
       0100-MENU-EDIT-END.

       0200-DISPLAY-MENU-EDIT-BEGIN.
           DISPLAY WS-SEPARATION-LINE.
           DISPLAY WS-CREATE-STRING " / "
                   WS-READ-STRING   " / "
                   WS-UPDATE-STRING " / "
                   WS-DELETE-STRING " / "
                   WS-QUIT-STRING ".".
           DISPLAY WS-SEPARATION-LINE.
       0200-DISPLAY-MENU-EDIT-END.

       0300-CREATE-EDITOR-BEGIN.
           DISPLAY "What is the name of the new editor? "
                   NO ADVANCING.
           ACCEPT WS-USER-NAME-INPUT.
           CALL "creaedit" USING
               WS-USER-NAME-INPUT
               WS-RETURN-VALUE
           END-CALL.
           EVALUATE TRUE
               WHEN WS-RETURN-OK
                   DISPLAY "Editor insert successful."
               WHEN WS-RETURN-ALREADY-HERE
                   DISPLAY "Editor already exists."
               WHEN WS-RETURN-ERROR
                   DISPLAY "Editor insert error."
           END-EVALUATE.
       0300-CREATE-EDITOR-END.

       0400-READ-EDITOR-BEGIN.
           DISPLAY "What name do you want to check? " 
                   NO ADVANCING.
           ACCEPT WS-USER-NAME-INPUT.
           CALL "readedit" USING
                WS-USER-NAME-INPUT
                WS-ID
                WS-RETURN-VALUE
           END-CALL.
           EVALUATE TRUE
               WHEN WS-RETURN-OK
                   DISPLAY WS-OUT-SEPARATION-LINE
                   DISPLAY WS-OUT-HDR
                   DISPLAY WS-OUT-SEPARATION-LINE
                   MOVE WS-ID TO WS-OUT-ID
                   MOVE WS-USER-NAME-INPUT TO WS-OUT-NAME
                   DISPLAY WS-OUT-LINE
                   DISPLAY WS-OUT-SEPARATION-LINE
               WHEN WS-RETURN-NOT-FOUND
                   DISPLAY "Record not found."
               WHEN WS-RETURN-ERROR
                   DISPLAY "Read error."
           END-EVALUATE.
       0400-READ-EDITOR-END.
       
       0500-UPDATE-EDITOR-BEGIN.
           DISPLAY "What name do you want to update? "
                   NO ADVANCING.
           ACCEPT WS-USER-NAME-INPUT.
           DISPLAY "What is the new name ? "
                   NO ADVANCING.
           ACCEPT WS-USER-NAME-INPUT-2.
           CALL "updtedit" USING
               WS-USER-NAME-INPUT
               WS-USER-NAME-INPUT-2
               WS-ID
               WS-RETURN-VALUE
           END-CALL.
           EVALUATE TRUE
               WHEN WS-RETURN-OK
                   DISPLAY "Old record :"
                   DISPLAY WS-OUT-SEPARATION-LINE
                   DISPLAY WS-OUT-HDR
                   DISPLAY WS-OUT-SEPARATION-LINE
                   MOVE WS-ID TO WS-OUT-ID
                   MOVE WS-USER-NAME-INPUT TO WS-OUT-NAME
                   DISPLAY WS-OUT-LINE
                   DISPLAY WS-OUT-SEPARATION-LINE
                   DISPLAY "New record :"
                   DISPLAY WS-OUT-SEPARATION-LINE
                   DISPLAY WS-OUT-HDR
                   DISPLAY WS-OUT-SEPARATION-LINE
                   MOVE WS-ID TO WS-OUT-ID
                   MOVE WS-USER-NAME-INPUT-2 TO WS-OUT-NAME
                   DISPLAY WS-OUT-LINE
                   DISPLAY WS-OUT-SEPARATION-LINE
                   DISPLAY "Was successfully updated."
               WHEN WS-RETURN-NOT-FOUND
                   DISPLAY "Record not found."
               WHEN WS-RETURN-ERROR
                   DISPLAY "Read/Update error."
           END-EVALUATE.
       0500-UPDATE-EDITOR-END.

       0600-DELETE-EDITOR-BEGIN.
           DISPLAY "What name do you want to delete? "
                   NO ADVANCING.
           ACCEPT WS-USER-NAME-INPUT.
           CALL "deltedit" USING
               WS-USER-NAME-INPUT
               WS-ID
               WS-RETURN-VALUE
           END-CALL.
           EVALUATE TRUE
               WHEN WS-RETURN-OK
                   DISPLAY WS-OUT-SEPARATION-LINE
                   DISPLAY WS-OUT-HDR
                   DISPLAY WS-OUT-SEPARATION-LINE
                   MOVE WS-ID TO WS-OUT-ID
                   MOVE WS-USER-NAME-INPUT TO WS-OUT-NAME
                   DISPLAY WS-OUT-LINE
                   DISPLAY WS-OUT-SEPARATION-LINE
                   DISPLAY "Was successfully deleted."
               WHEN WS-RETURN-NOT-FOUND
                   DISPLAY "Record not found."
               WHEN WS-RETURN-ERROR
                   DISPLAY "Read/Delete error."
           END-EVALUATE.
       0600-DELETE-EDITOR-END.