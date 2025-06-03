       IDENTIFICATION DIVISION.
       PROGRAM-ID. creaauth.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 03-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 
       WORKING-STORAGE SECTION. 

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  AUTHOR-ID         PIC 9(10).
       01  AUTHOR-LASTNAME   PIC X(25).
       01  AUTHOR-FIRSTNAME  PIC X(25).
       
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.


       PROCEDURE DIVISION. 

       EXEC SQL
          INSERT INTO author (last_name, first_name)
          VALUES (:AUTHOR-LASTNAME, :AUTHOR-FIRSTNAME)
          
        
       END-EXEC.
              
       IF SQLCODE = 0
          DISPLAY "Insertion succeeded."
       ELSE
          DISPLAY "Insertion error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 
       END-IF.

       EXIT PROGRAM.
       