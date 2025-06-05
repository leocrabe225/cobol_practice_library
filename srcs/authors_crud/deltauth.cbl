       IDENTIFICATION DIVISION.
       PROGRAM-ID. deltauth.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 

       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-AUTHOR-ID         PIC 9(10).
       
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.


       LINKAGE SECTION. 
       01  LK-AUTHOR-ID         PIC 9(10).


       PROCEDURE DIVISION USING LK-AUTHOR-ID.
      
       MOVE LK-AUTHOR-ID TO WS-AUTHOR-ID.

       EXEC SQL
          DELETE FROM authors 
          WHERE id = :WS-AUTHOR-ID  
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

       MOVE WS-AUTHOR-ID TO LK-AUTHOR-ID.

       EXIT PROGRAM.
