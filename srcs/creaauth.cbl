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

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION. 
       01  LK-AUTHOR-LASTNAME   PIC X(25).
       01  LK-AUTHOR-FIRSTNAME  PIC X(25).
        

       PROCEDURE DIVISION. 

       DISPLAY "Enter author's lastname : ".
       ACCEPT WS-AUTHOR-LASTNAME.
       DISPLAY "Enter author's firstname  : ".
       ACCEPT WS-AUTHOR-FIRSTNAME.


       EXEC SQL
          INSERT INTO authors (last_name, first_name)
          VALUES (:WS-AUTHOR-LASTNAME, :WS-AUTHOR-FIRSTNAME)
          
        
       END-EXEC.
              
       IF SQLCODE = 0
          DISPLAY "Insertion successful."
       ELSE
          DISPLAY "Insertion error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 
       END-IF.


       MOVE WS-AUTHOR-LASTNAME TO LK-AUTHOR-LASTNAME.
       MOVE WS-AUTHOR-FIRSTNAME TO LK-AUTHOR-FIRSTNAME.

       EXIT PROGRAM.

