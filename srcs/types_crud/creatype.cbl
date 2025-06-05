       IDENTIFICATION DIVISION.
       PROGRAM-ID. creatype.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 04-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 


       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-TYPE-NAME   PIC X(20).

       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION. 
       01  LK-TYPE-NAME   PIC X(20).
        

       PROCEDURE DIVISION USING LK-TYPE-NAME. 
       
       MOVE LK-TYPE-NAME TO WS-TYPE-NAME.

       
       EXEC SQL 
          SELECT name 
          INTO :WS-TYPE-NAME,  
          FROM types
          WHERE name = :WS-TYPE-NAME 
       END-EXEC.
       
       EVALUATE SQLCODE 
           
           WHEN +100
              EXEC SQL
              INSERT INTO types (name)
              VALUES (:WS-TYPE-NAME)
              END-EXEC
              EXEC SQL COMMIT END-EXEC
           
           WHEN 0
              DISPLAY "This book type is already in the database."

       END-EVALUATE.


       IF SQLCODE = 0
          DISPLAY "Insertion successful."

       ELSE
          DISPLAY "Insertion error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 

       END-IF.


       MOVE WS-TYPE-NAME TO LK-TYPE-NAME.

       EXIT PROGRAM.
       