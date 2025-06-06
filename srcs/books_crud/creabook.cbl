       IDENTIFICATION DIVISION.
       PROGRAM-ID. creabook.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 05-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 

       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01 WS-ISBN         PIC X(13).
       01 WS-NAME         PIC X(50).
       01 WS-YEAR         PIC X(04).
       01 WS-AUTHOR-ID    PIC 9(10).
       01 WS-AUTHOR-NAME  PIC X(25).
       01 WS-AUTHOR-FNAME PIC X(25).
       01 WS-EDITOR-ID    PIC 9(10).
       01 WS-EDITOR-NAME  PIC X(25).
       01 WS-TYPE-ID      PIC 9(10).
       01 WS-TYPE-NAME    PIC X(20).

       EXEC SQL END DECLARE SECTION END-EXEC.

       01 WS-DULL         PIC X(50).

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       01 LK-ISBN        PIC X(13).
       01 LK-NAME        PIC X(50).
       01 LK-YEAR        PIC X(04).
       01 LK-AUTHOR-ID   PIC 9(10).
       01 LK-EDITOR-ID   PIC 9(10).
       01 LK-TYPE-ID     PIC 9(10).
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.
        

       PROCEDURE DIVISION USING LK-ISBN,
                                LK-NAME,
                                LK-YEAR,
                                LK-AUTHOR-ID,
                                LK-EDITOR-ID,
                                LK-TYPE-ID,
                                LK-RETURN-VALUE. 
       
           MOVE LK-ISBN      TO WS-ISBN.
           MOVE LK-NAME      TO WS-NAME.
           MOVE LK-YEAR      TO WS-YEAR.
           MOVE LK-AUTHOR-ID TO WS-AUTHOR-ID.
           MOVE LK-EDITOR-ID TO WS-EDITOR-ID.
           MOVE LK-TYPE-ID   TO WS-TYPE-ID.

       
           CALL "readbook" USING
               WS-NAME
               WS-DULL
               WS-DULL
               WS-DULL
               WS-DULL
               WS-DULL
               WS-DULL
               WS-DULL
               LK-RETURN-VALUE
           END-CALL.
       
           EVALUATE TRUE
               WHEN LK-RETURN-OK
                   SET LK-RETURN-ALREADY-HERE TO TRUE
                   EXIT PROGRAM
               WHEN LK-RETURN-ERROR
                   EXIT PROGRAM
           END-EVALUATE.

       EXEC SQL
           INSERT INTO books (isbn, name, year, author_id, editor_id,
               type_id)
           VALUES (:WS-ISBN, :WS-NAME, :WS-YEAR, WS-AUTHOR-ID,
               WS-EDITOR-ID, WS-TYPE-ID)
       END-EXEC
      
           EVALUATE SQLCODE
               WHEN 0
       EXEC SQL COMMIT END-EXEC
                   SET LK-RETURN-OK TO TRUE
               WHEN OTHER
                   SET LK-RETURN-ERROR TO TRUE
       EXEC SQL ROLLBACK END-EXEC
           END-EVALUATE.
      
           EXIT PROGRAM.
       