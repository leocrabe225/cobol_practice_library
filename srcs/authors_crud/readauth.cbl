       IDENTIFICATION DIVISION.
       PROGRAM-ID. readauth.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 
       
       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-AUTHOR-ID         PIC 9(10).
       01  WS-AUTHOR-LASTNAME   PIC X(25).
       01  WS-AUTHOR-FIRSTNAME  PIC X(25).
       
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.


       LINKAGE SECTION. 
       01  LK-AUTHOR-ID         PIC 9(10).
       01  LK-AUTHOR-LASTNAME   PIC X(25).
       01  LK-AUTHOR-FIRSTNAME  PIC X(25).
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.
       

       PROCEDURE DIVISION USING LK-AUTHOR-LASTNAME,
                                LK-AUTHOR-FIRSTNAME,
                                LK-AUTHOR-ID,
                                LK-RETURN-VALUE. 
       
       MOVE LK-AUTHOR-LASTNAME TO WS-AUTHOR-LASTNAME.
       MOVE LK-AUTHOR-FIRSTNAME TO WS-AUTHOR-FIRSTNAME.
       
       EXEC SQL 
          SELECT id
          INTO :WS-AUTHOR-ID
          FROM authors
          WHERE last_name = :WS-AUTHOR-LASTNAME AND
                first_name = :WS-AUTHOR-FIRSTNAME
       END-EXEC.

       EVALUATE SQLCODE
          WHEN 0
              SET LK-RETURN-OK TO TRUE
          WHEN +100
              SET LK-RETURN-NOT-FOUND TO TRUE
          WHEN OTHER
              SET LK-RETURN-ERROR TO TRUE
       END-EVALUATE.

       MOVE WS-AUTHOR-ID TO LK-AUTHOR-ID.

       EXIT PROGRAM.
