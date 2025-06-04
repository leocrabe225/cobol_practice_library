       IDENTIFICATION DIVISION.
       PROGRAM-ID. updtauth.
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


       PROCEDURE DIVISION.

       DISPLAY "Enter author's id: ".
       ACCEPT WS-AUTHOR-ID.

       DISPLAY "Enter author's lastname : ".
       ACCEPT WS-AUTHOR-LASTNAME.
       DISPLAY "Enter author's firstname  : ".
       ACCEPT WS-AUTHOR-FIRSTNAME.


       EXEC SQL 
          UPDATE authors
          SET last_name = :WS-AUTHOR-LASTNAME, 
          first_name = :WS-AUTHOR-FIRSTNAME
          
          WHERE id = :WS-AUTHOR-ID
       END-EXEC.

       IF SQLCODE = 0
          DISPLAY "Update successful."
          DISPLAY "Lastname : " WS-AUTHOR-LASTNAME
          SPACES WITH NO ADVANCING 
                  "Firstname : " WS-AUTHOR-FIRSTNAME
         
       ELSE
          DISPLAY "Update error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 
       END-IF.

       MOVE WS-AUTHOR-ID TO LK-AUTHOR-ID.
       MOVE WS-AUTHOR-LASTNAME TO LK-AUTHOR-LASTNAME.
       MOVE WS-AUTHOR-FIRSTNAME TO LK-AUTHOR-FIRSTNAME.

       EXIT PROGRAM.
       