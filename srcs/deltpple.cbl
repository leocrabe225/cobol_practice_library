       IDENTIFICATION DIVISION.
       PROGRAM-ID. deltpple.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 05-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 

       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-PERSON-ID         PIC 9(10).
       
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.


       LINKAGE SECTION. 
       01  LK-PERSON-ID         PIC 9(10).


       PROCEDURE DIVISION USING LK-PERSON-ID.
      
       MOVE LK-PERSON-ID TO WS-PERSON-ID.

       EXEC SQL
          DELETE FROM people 
          WHERE id = :WS-PERSON-ID  
       END-EXEC.
       EXEC SQL COMMIT END-EXEC.
       
       IF SQLCODE = 0
          DISPLAY "Delete successful."
       
       ELSE
          DISPLAY "Delete error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 

       END-IF.

       MOVE WS-PERSON-ID TO LK-PERSON-ID.

       EXIT PROGRAM.
       