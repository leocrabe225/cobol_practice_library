       IDENTIFICATION DIVISION.
       PROGRAM-ID. deltedit.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 WS-ID               PIC 9(10).

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       01 LK-NAME             PIC X(25).
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.

       PROCEDURE DIVISION USING LK-NAME.

           PERFORM 0100-EXIT-IF-NOT-HERE-BEGIN
              THRU 0100-EXIT-IF-NOT-HERE-END.

           PERFORM 0200-DELETE-BEGIN
              THRU 0200-DELETE-END.
      
           EXIT PROGRAM.

       0100-EXIT-IF-NOT-HERE-BEGIN.
           CALL "readedit" USING
               LK-NAME
               WS-ID
               LK-RETURN-VALUE
           END-CALL.
           
           IF NOT LK-RETURN-OK THEN
                EXIT PROGRAM
           END-IF.
       0100-EXIT-IF-NOT-HERE-END.

       0200-DELETE-BEGIN.
       EXEC SQL
           DELETE FROM editors
           WHERE id=:WS-ID;
       END-EXEC.
           
           EVALUATE SQLCODE
               WHEN 0
                   SET LK-RETURN-OK TO TRUE
       EXEC SQL COMMIT END-EXEC
               WHEN OTHER
                   SET LK-RETURN-ERROR TO TRUE
       EXEC SQL ROLLBACK END-EXEC
           END-EVALUATE.
       0200-DELETE-END.
           