       IDENTIFICATION DIVISION.
       PROGRAM-ID. readbook.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 06-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION. 

       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01 WS-ID           PIC 9(10).
       01 WS-ISBN         PIC X(13).
       01 WS-NAME         PIC X(50).
       01 WS-YEAR         PIC X(04).
       01 WS-AUTHOR-NAME  PIC X(25).
       01 WS-AUTHOR-FNAME PIC X(25).
       01 WS-EDITOR-NAME  PIC X(25).
       01 WS-TYPE-NAME    PIC X(20).

       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       01 LK-ID           PIC 9(10).
       01 LK-ISBN         PIC X(13).
       01 LK-NAME         PIC X(50).
       01 LK-YEAR         PIC X(04).
       01 LK-AUTHOR-NAME  PIC X(25).
       01 LK-AUTHOR-FNAME PIC X(25).
       01 LK-EDITOR-NAME  PIC X(25).
       01 LK-TYPE-NAME    PIC X(20).
       COPY retstatu REPLACING ==:PREFIX:== BY ==LK==.
        

       PROCEDURE DIVISION USING LK-NAME,
                                LK-ID,
                                LK-ISBN,
                                LK-YEAR,
                                LK-AUTHOR-NAME,
                                LK-AUTHOR-FNAME,
                                LK-EDITOR-NAME,
                                LK-TYPE-NAME,
                                LK-RETURN-VALUE.
       
           MOVE LK-NAME TO WS-NAME.
       
       EXEC SQL 
           SELECT 
               books.id,
               books.isbn,
               books.year, 
               authors.first_name,
               authors.last_name,
               editors.name,
               types.name
           INTO 
               :WS-ID,
               :WS-ISBN,
               :WS-YEAR,
               :WS-AUTHOR-FNAME,
               :WS-AUTHOR-NAME,
               :WS-EDITOR-NAME,
               :WS-TYPE-NAME
           FROM books
           INNER JOIN authors on books.author_id = authors.id
           INNER JOIN editors on books.editor_id = editor.id
           INNER JOIN types on books.types_id = types.id
           WHERE 
               books.name = :WS-NAME
       END-EXEC.
       
           EVALUATE SQLCODE
               WHEN 0
                   SET LK-RETURN-OK TO TRUE
               WHEN +100
                   SET LK-RETURN-NOT-FOUND TO TRUE
               WHEN OTHER
                   DISPLAY "Error : " SQLCODE
                   SET LK-RETURN-ERROR TO TRUE
           END-EVALUATE.
      
           MOVE WS-ID        TO LK-ID.
           MOVE WS-ISBN      TO LK-ISBN.
           MOVE WS-YEAR      TO LK-YEAR.
           MOVE WS-AUTHOR-NAME TO LK-AUTHOR-NAME.
           MOVE WS-AUTHOR-FNAME TO LK-AUTHOR-FNAME.
           MOVE WS-EDITOR-NAME TO LK-EDITOR-NAME.
           MOVE WS-TYPE-NAME   TO LK-TYPE-NAME.
      
           EXIT PROGRAM.