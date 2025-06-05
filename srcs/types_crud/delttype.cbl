       IDENTIFICATION DIVISION.
       PROGRAM-ID. delttype.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.


       DATA DIVISION. 
       
       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-TYPE-ID          PIC 9(10).
       
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.


       LINKAGE SECTION. 
       01  LK-TYPE-ID         PIC 9(10).
       

       PROCEDURE DIVISION USING LK-TYPE-ID.

       MOVE LK-TYPE-ID TO WS-TYPE-ID.

       EXEC SQL
          DELETE FROM types 
          WHERE id = :WS-TYPE-ID  
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

       MOVE WS-TYPE-ID TO LK-TYPE-ID.

       EXIT PROGRAM.
       
