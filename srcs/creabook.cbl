       IDENTIFICATION DIVISION.
       PROGRAM-ID. creabook.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 05-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 


       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  WS-BOOK-NAME   PIC X(50).

       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION. 
       01  LK-TYPE-NAME   PIC X(50).
        

       PROCEDURE DIVISION USING LK-TYPE-NAME. 
       
       MOVE LK-TYPE-NAME TO WS-BOOK-NAME.

       
       EXEC SQL 
          SELECT name 
          INTO :WS-BOOK-NAME,  
          FROM books
          WHERE name = :WS-BOOK-NAME 
       END-EXEC.
       
       EVALUATE SQLCODE 
           
           WHEN +100
              EXEC SQL
              INSERT INTO books (name)
              VALUES (:WS-BOOK-NAME)
              END-EXEC
              EXEC SQL COMMIT END-EXEC
           
           WHEN 0
              DISPLAY "This book is already in the database."

       END-EVALUATE.


       IF SQLCODE = 0
          DISPLAY "Insertion successful."

       ELSE
          DISPLAY "Insertion error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 

       END-IF.


       MOVE WS-BOOK-NAME TO LK-TYPE-NAME.

       EXIT PROGRAM.
       