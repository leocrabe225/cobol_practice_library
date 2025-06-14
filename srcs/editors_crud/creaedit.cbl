       IDENTIFICATION DIVISION.
       PROGRAM-ID. creaedit.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 WS-NAME             PIC X(25).
       01 WS-ID               PIC 9(10).
       EXEC SQL END DECLARE SECTION END-EXEC.


       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       01 LK-NAME             PIC X(25).
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.

       PROCEDURE DIVISION USING LK-NAME
                                LK-RETURN-VALUE.

           PERFORM 0100-EXIT-IF-ALREADY-HERE-BEGIN
              THRU 0100-EXIT-IF-ALREADY-HERE-END.

           PERFORM 0200-CREATE-BEGIN
              THRU 0200-CREATE-END.

           EXIT PROGRAM.

       0100-EXIT-IF-ALREADY-HERE-BEGIN.
           CALL "readedit" USING
               LK-NAME
               WS-ID
               LK-RETURN-VALUE
           END-CALL.
           
           IF NOT LK-RETURN-NOT-FOUND THEN
               SET LK-RETURN-ALREADY-HERE TO TRUE
               EXIT PROGRAM
           END-IF.
       0100-EXIT-IF-ALREADY-HERE-END.

       0200-CREATE-BEGIN.
           MOVE LK-NAME TO WS-NAME.
       EXEC SQL
           INSERT INTO editors 
               (name)
           VALUES
               (:WS-NAME);
       END-EXEC.

           EVALUATE SQLCODE
               WHEN 0
                   SET LK-RETURN-OK TO TRUE
       EXEC SQL COMMIT END-EXEC
               WHEN OTHER
                   SET LK-RETURN-ERROR TO TRUE
       EXEC SQL ROLLBACK END-EXEC
           END-EVALUATE.
       0200-CREATE-END.
