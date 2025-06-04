       IDENTIFICATION DIVISION.
       PROGRAM-ID. readtype.
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
       
       EXEC SQL 
          SELECT name 
          INTO :WS-TYPE-NAME 
          FROM types
          WHERE id = :WS-TYPE-ID
       END-EXEC.
              

       IF SQLCODE = 0
          DISPLAY "Reading successful."
          DISPLAY "Book type : " WS-TYPE-NAME
          
       
       ELSE
          DISPLAY "Reading error SQLCODE: " SQLCODE
          EXEC SQL 
           ROLLBACK 
          END-EXEC 

       END-IF.

       MOVE WS-TYPE-NAME TO LK-TYPE-NAME.


       EXIT PROGRAM.
       