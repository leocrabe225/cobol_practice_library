       IDENTIFICATION DIVISION.
       PROGRAM-ID. creapple.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 05-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 


       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-PERSON-LASTNAME   PIC X(25).
       01  WS-PERSON-FIRSTNAME  PIC X(25).

       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION. 
       01  LK-PERSON-LASTNAME   PIC X(25).
       01  LK-PERSON-FIRSTNAME  PIC X(25).
        

       PROCEDURE DIVISION USING LK-PERSON-LASTNAME, LK-PERSON-FIRSTNAME. 
       
       MOVE LK-PERSON-LASTNAME TO WS-PERSON-LASTNAME.
       MOVE LK-PERSON-FIRSTNAME TO WS-PERSON-FIRSTNAME.

       
       EXEC SQL 
          SELECT last_name, first_name 
          INTO :WS-PERSON-LASTNAME, :WS-PERSON-FIRSTNAME 
          FROM people
          WHERE last_name = :WS-PERSON-LASTNAME 
          AND first_name = :WS-PERSON-FIRSTNAME
       END-EXEC.
       
       EVALUATE SQLCODE 
           
           WHEN +100
              EXEC SQL
              INSERT INTO people (last_name, first_name)
              VALUES (:WS-PERSON-LASTNAME, :WS-PERSON-FIRSTNAME)
              END-EXEC
              EXEC SQL COMMIT END-EXEC
           
           WHEN 0
              DISPLAY "This person is already in the database."

       END-EVALUATE.


       IF SQLCODE = 0
          DISPLAY "Insertion successful."

       ELSE
          DISPLAY "Insertion error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 

       END-IF.


       MOVE WS-PERSON-LASTNAME TO LK-PERSON-LASTNAME.
       MOVE WS-PERSON-FIRSTNAME TO LK-PERSON-FIRSTNAME.

       EXIT PROGRAM.