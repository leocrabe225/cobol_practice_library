       IDENTIFICATION DIVISION.
       PROGRAM-ID. readedit.
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
       01 LK-ID               PIC 9(10).
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.

       PROCEDURE DIVISION USING LK-NAME,
                                LK-ID,
                                LK-RETURN-VALUE.

           PERFORM 0100-READ-EDITOR-BEGIN
              THRU 0100-READ-EDITOR-END.
           EXIT PROGRAM.

       0100-READ-EDITOR-BEGIN.
           MOVE LK-NAME TO WS-NAME.
           EXEC SQL
               SELECT
                   id
               INTO
                   :WS-ID
               FROM
                   editors
               WHERE name=:WS-NAME;
           END-EXEC.

           EVALUATE SQLCODE
               WHEN 0
                   SET LK-RETURN-OK TO TRUE
                   MOVE WS-ID TO LK-ID
               WHEN +100
                   SET LK-RETURN-NOT-FOUND TO TRUE
               WHEN OTHER
                   SET LK-RETURN-ERROR TO TRUE
           END-EVALUATE.
       0100-READ-EDITOR-END.
           