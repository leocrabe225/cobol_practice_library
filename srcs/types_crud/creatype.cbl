       IDENTIFICATION DIVISION.
       PROGRAM-ID. creatype.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 


       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-TYPE-NAME   PIC X(20).

       EXEC SQL END DECLARE SECTION END-EXEC.

       01  WS-TYPE-ID     PIC 9(10).

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION. 
       01  LK-TYPE-NAME   PIC X(20).
       
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.

       PROCEDURE DIVISION USING LK-TYPE-NAME,
                                LK-RETURN-VALUE. 
       
       MOVE LK-TYPE-NAME TO WS-TYPE-NAME.

       
       CALL 'readtype' USING
           WS-TYPE-NAME
           WS-TYPE-ID
           LK-RETURN-VALUE
       END-CALL

       EVALUATE TRUE
           WHEN LK-RETURN-OK
               SET LK-RETURN-ALREADY-HERE TO TRUE
               EXIT PROGRAM
           WHEN LK-RETURN-ERROR
               EXIT PROGRAM
       END-EVALUATE.

       EXEC SQL
           INSERT INTO types (name)
           VALUES (:WS-TYPE-NAME)
       END-EXEC

       EVALUATE SQLCODE
           WHEN 0
               SET LK-RETURN-OK TO TRUE
               EXEC SQL COMMIT END-EXEC
           WHEN OTHER
               SET LK-RETURN-ERROR TO TRUE
               EXEC SQL ROLLBACK END-EXEC
       END-EVALUATE.

       MOVE WS-TYPE-NAME TO LK-TYPE-NAME.

       EXIT PROGRAM.
       