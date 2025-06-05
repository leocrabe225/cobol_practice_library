       IDENTIFICATION DIVISION.
       PROGRAM-ID. updtedit.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 WS-OLD-NAME         PIC X(25).
       01 WS-NEW-NAME         PIC X(25).
       EXEC SQL END DECLARE SECTION END-EXEC.


       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       01 LK-OLD-NAME            PIC X(25).
       01 LK-NEW-NAME            PIC X(25).
       01 LK-ID                  PIC 9(25).
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.

       PROCEDURE DIVISION USING LK-OLD-NAME,
                                LK-NEW-NAME,
                                LK-ID,
                                LK-RETURN-VALUE.

           PERFORM 0100-EXIT-IF-NOT-HERE-BEGIN
              THRU 0100-EXIT-IF-NOT-HERE-END.

           PERFORM 0200-UPDATE-BEGIN
              THRU 0200-UPDATE-END.

           EXIT PROGRAM.
           
       0100-EXIT-IF-NOT-HERE-BEGIN.
           CALL "readedit" USING
               LK-OLD-NAME
               LK-ID
               LK-RETURN-VALUE
           END-CALL.
           
           IF NOT LK-RETURN-OK THEN
                EXIT PROGRAM
           END-IF.
       0100-EXIT-IF-NOT-HERE-END.

       0200-UPDATE-BEGIN.
           MOVE LK-OLD-NAME TO WS-OLD-NAME.
           MOVE LK-NEW-NAME TO WS-NEW-NAME.
       EXEC SQL
           UPDATE editors
           SET name = :WS-NEW-NAME
           WHERE name = :WS-OLD-NAME;
       END-EXEC.

           EVALUATE SQLCODE
               WHEN 0
                   SET LK-RETURN-OK TO TRUE
       EXEC SQL COMMIT END-EXEC
               WHEN OTHER
                   SET LK-RETURN-ERROR TO TRUE
       EXEC SQL ROLLBACK END-EXEC
           END-EVALUATE.
       0200-UPDATE-END.
       