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
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.
       

       PROCEDURE DIVISION USING LK-TYPE-NAME,
                                LK-TYPE-ID,
                                LK-RETURN-VALUE.
       
       MOVE LK-TYPE-NAME TO WS-TYPE-NAME.
       
       EXEC SQL 
          SELECT id 
          INTO :WS-TYPE-ID 
          FROM types
          WHERE name = :WS-TYPE-NAME
       END-EXEC.
              

       EVALUATE SQLCODE
          WHEN 0
              SET LK-RETURN-OK TO TRUE
          WHEN +100
              SET LK-RETURN-NOT-FOUND TO TRUE
          WHEN OTHER
              SET LK-RETURN-ERROR TO TRUE
       EXEC SQL 
          ROLLBACK 
       END-EXEC 

       END-EVALUATE.

       MOVE WS-TYPE-ID TO LK-TYPE-ID.


       EXIT PROGRAM.
       