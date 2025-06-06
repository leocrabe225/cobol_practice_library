       IDENTIFICATION DIVISION.
       PROGRAM-ID. deltbook.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 06-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 WS-ID           PIC 9(10).
       01 WS-ISBN         PIC X(13).
       01 WS-NAME         PIC X(50).
       01 WS-YEAR         PIC X(04).
       01 WS-AUTHOR-NAME  PIC X(25).
       01 WS-AUTHOR-FNAME PIC X(25).
       01 WS-EDITOR-NAME  PIC X(25).
       01 WS-TYPE-NAME    PIC X(20).

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       01 LK-ID           PIC 9(10).
       01 LK-ISBN         PIC X(13).
       01 LK-NAME         PIC X(50).
       01 LK-YEAR         PIC X(04).
       01 LK-AUTHOR-NAME  PIC X(25).
       01 LK-AUTHOR-FNAME PIC X(25).
       01 LK-EDITOR-NAME  PIC X(25).
       01 LK-TYPE-NAME    PIC X(20).
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.

       PROCEDURE DIVISION USING LK-NAME,
                                LK-ID,
                                LK-ISBN,
                                LK-YEAR,
                                LK-AUTHOR-NAME,
                                LK-AUTHOR-FNAME,
                                LK-EDITOR-NAME,
                                LK-TYPE-NAME,
                                LK-RETURN-VALUE.

           PERFORM 0100-EXIT-IF-NOT-HERE-BEGIN
              THRU 0100-EXIT-IF-NOT-HERE-END.

           PERFORM 0200-DELETE-BEGIN
              THRU 0200-DELETE-END.
      
           EXIT PROGRAM.

       0100-EXIT-IF-NOT-HERE-BEGIN.
           MOVE LK-NAME TO WS-NAME.
           CALL "readbook" USING
               WS-NAME
               WS-ID
               WS-ISBN
               WS-YEAR
               WS-AUTHOR-NAME
               WS-AUTHOR-FNAME
               WS-EDITOR-NAME
               WS-TYPE-NAME
               LK-RETURN-VALUE
           END-CALL.
           
           IF NOT LK-RETURN-OK THEN
                EXIT PROGRAM
           END-IF.
       0100-EXIT-IF-NOT-HERE-END.

       0200-DELETE-BEGIN.
       EXEC SQL
           DELETE FROM books
           WHERE name=:WS-NAME;
       END-EXEC.
           
           EVALUATE SQLCODE
               WHEN 0
                   SET LK-RETURN-OK TO TRUE
                   MOVE WS-ID TO LK-ID
                   MOVE WS-ISBN      TO LK-ISBN
                   MOVE WS-YEAR      TO LK-YEAR
                   MOVE WS-AUTHOR-NAME TO LK-AUTHOR-NAME
                   MOVE WS-AUTHOR-FNAME TO LK-AUTHOR-FNAME
                   MOVE WS-EDITOR-NAME TO LK-EDITOR-NAME
                   MOVE WS-TYPE-NAME   TO LK-TYPE-NAME
       EXEC SQL COMMIT END-EXEC
               WHEN OTHER
                   SET LK-RETURN-ERROR TO TRUE
       EXEC SQL ROLLBACK END-EXEC
           END-EVALUATE.
       0200-DELETE-END.
           