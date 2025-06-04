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

       PROCEDURE DIVISION USING LK-NAME.

           PERFORM 0100-CHECK-IF-ALREADY-HERE-BEGIN
              THRU 0100-CHECK-IF-ALREADY-HERE-END.

           PERFORM 0200-INSERT-BEGIN
              THRU 0200-INSERT-END.

           EXIT PROGRAM.

       0100-CHECK-IF-ALREADY-HERE-BEGIN.
           MOVE LK-NAME TO WS-NAME.
       EXEC SQL
           SELECT
               id
           INTO
               :WS-ID
           FROM
               editors
           WHERE
               name = :WS-NAME;
       END-EXEC.
       0100-CHECK-IF-ALREADY-HERE-END.

       0200-INSERT-BEGIN.
       EXEC SQL
           INSERT INTO editors 
               (name)
           VALUES
               (:WS-NAME);
       END-EXEC.
       0200-INSERT-END.
