       IDENTIFICATION DIVISION.
       PROGRAM-ID. updttype.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.


       DATA DIVISION. 
       
       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-TYPE-ID          PIC 9(10).
       01  WS-TYPE-NAME        PIC X(20).
       
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.


       LINKAGE SECTION. 
       01  LK-TYPE-ID         PIC 9(10).
       01  LK-TYPE-NAME       PIC X(20).
       

       PROCEDURE DIVISION USING LK-TYPE-ID,
                                LK-TYPE-NAME.


       MOVE LK-TYPE-ID TO WS-TYPE-ID.
       MOVE LK-TYPE-NAME TO WS-TYPE-NAME.


       EXEC SQL 
          SELECT id
          INTO :WS-TYPE-ID
          FROM types
          WHERE id = :WS-TYPE-ID
       END-EXEC.
       

       EVALUATE SQLCODE 
           
           WHEN +100
              DISPLAY "There is no book type to update in the database."
           
           WHEN 0
             
              EXEC SQL 
              UPDATE types
              SET name = :WS-TYPE-NAME 
              WHERE id = :WS-TYPE-ID
              END-EXEC
              EXEC SQL COMMIT END-EXEC
               
       END-EVALUATE.


       IF SQLCODE = 0
          DISPLAY "Update successful."
          DISPLAY "Book type : " WS-TYPE-NAME
         
       ELSE
          DISPLAY "Update error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 

       END-IF.

       MOVE WS-TYPE-ID TO LK-TYPE-ID.
       MOVE WS-TYPE-NAME TO LK-TYPE-NAME.

       EXIT PROGRAM.
       
