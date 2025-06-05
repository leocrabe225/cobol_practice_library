       IDENTIFICATION DIVISION.
       PROGRAM-ID. readpple.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 05-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 
       
       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-PERSON-ID         PIC 9(10).
       01  WS-PERSON-LASTNAME   PIC X(25).
       01  WS-PERSON-FIRSTNAME  PIC X(25).
       
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.


       LINKAGE SECTION. 
       01  LK-PERSON-ID         PIC 9(10).
       01  LK-PERSON-LASTNAME   PIC X(25).
       01  LK-PERSON-FIRSTNAME  PIC X(25).
       

       PROCEDURE DIVISION USING LK-PERSON-ID,
                                LK-PERSON-LASTNAME,
                                LK-PERSON-FIRSTNAME. 
       
       MOVE LK-PERSON-ID TO WS-PERSON-ID.
       
       EXEC SQL 
          SELECT last_name, first_name 
          INTO :WS-PERSON-LASTNAME, :WS-PERSON-FIRSTNAME 
          FROM people
          WHERE id = :WS-PERSON-ID
       END-EXEC.
              

       IF SQLCODE = 0
          DISPLAY "Reading successful."
          DISPLAY "Lastname : " WS-PERSON-LASTNAME
          SPACES WITH NO ADVANCING 
                  "Firstname : " WS-PERSON-FIRSTNAME
          
       
       ELSE
          DISPLAY "Reading error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 

       END-IF.

       MOVE WS-PERSON-LASTNAME TO LK-PERSON-LASTNAME.
       MOVE WS-PERSON-FIRSTNAME TO LK-PERSON-FIRSTNAME.


       EXIT PROGRAM.
       