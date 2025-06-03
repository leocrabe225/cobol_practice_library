       IDENTIFICATION DIVISION.
       PROGRAM-ID. blibrary.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 03-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-IN-FILE-NAME      PIC X(20).

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
           
           CALL "initdb".

           ACCEPT WS-IN-FILE-NAME.
           CALL "readfile" USING WS-IN-FILE-NAME.

           PERFORM 9900-DISCONNECT-SQL-BEGIN
              THRU 9900-DISCONNECT-SQL-END.

           STOP RUN.

       9900-DISCONNECT-SQL-BEGIN.
       EXEC SQL
           DISCONNECT ALL
       END-EXEC.
       9900-DISCONNECT-SQL-END.
