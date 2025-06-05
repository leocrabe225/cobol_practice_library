       IDENTIFICATION DIVISION.
       PROGRAM-ID. updtpple.
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
       MOVE LK-PERSON-LASTNAME TO WS-PERSON-LASTNAME.
       MOVE LK-PERSON-FIRSTNAME TO WS-PERSON-FIRSTNAME.


       EXEC SQL 
          SELECT id
          INTO :WS-PERSON-ID
          FROM people
          WHERE id = :WS-PERSON-ID
       END-EXEC.
       

       EVALUATE SQLCODE 
           
           WHEN +100
               DISPLAY "There is no one to update in the database."
           
           WHEN 0
             
               EXEC SQL 
               UPDATE people
               SET last_name = :WS-PERSON-LASTNAME, 
               first_name = :WS-PERSON-FIRSTNAME
               
               WHERE id = :WS-PERSON-ID
               END-EXEC
               EXEC SQL COMMIT END-EXEC
               
       END-EVALUATE.


       IF SQLCODE = 0
          DISPLAY "Update successful."
          DISPLAY "Lastname : " WS-PERSON-LASTNAME
          SPACES WITH NO ADVANCING 
                  "Firstname : " WS-PERSON-FIRSTNAME
         
       ELSE
          DISPLAY "Update error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 

       END-IF.

       MOVE WS-PERSON-ID TO LK-PERSON-ID.
       MOVE WS-PERSON-LASTNAME TO LK-PERSON-LASTNAME.
       MOVE WS-PERSON-FIRSTNAME TO LK-PERSON-FIRSTNAME.

       EXIT PROGRAM.
       