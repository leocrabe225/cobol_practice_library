       IDENTIFICATION DIVISION.
       PROGRAM-ID. creaauth.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 03-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 


       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-AUTHOR-LASTNAME   PIC X(25).
       01  WS-AUTHOR-FIRSTNAME  PIC X(25).

       EXEC SQL END DECLARE SECTION END-EXEC.

       01 WS-AUTHOR-ID          PIC 9(10).

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION. 
       01  LK-AUTHOR-LASTNAME   PIC X(25).
       01  LK-AUTHOR-FIRSTNAME  PIC X(25).
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.

        

       PROCEDURE DIVISION USING LK-AUTHOR-LASTNAME,
                                LK-AUTHOR-FIRSTNAME,
                                LK-RETURN-VALUE. 
       
       MOVE LK-AUTHOR-LASTNAME TO WS-AUTHOR-LASTNAME.
       MOVE LK-AUTHOR-FIRSTNAME TO WS-AUTHOR-FIRSTNAME.

       
       CALL "readauth" USING 
           WS-AUTHOR-LASTNAME
           WS-AUTHOR-FIRSTNAME
           WS-AUTHOR-ID
           LK-RETURN-VALUE
       END-CALL.

       EVALUATE TRUE
           WHEN LK-RETURN-OK
               SET LK-RETURN-ALREADY-HERE TO TRUE
               EXIT PROGRAM
           WHEN LK-RETURN-ERROR
               EXIT PROGRAM
       END-EVALUATE.
       
       EXEC SQL
           INSERT INTO authors (last_name, first_name)
           VALUES (:WS-AUTHOR-LASTNAME, :WS-AUTHOR-FIRSTNAME)
       END-EXEC

       EVALUATE SQLCODE 
           WHEN 0
              SET LK-RETURN-OK TO TRUE
              EXEC SQL COMMIT END-EXEC
           WHEN OTHER
              SET LK-RETURN-ERROR TO TRUE
              EXEC SQL ROLLBACK END-EXEC
       END-EVALUATE.
       EXIT PROGRAM.
