       IDENTIFICATION DIVISION.
       PROGRAM-ID. initdb.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 03-06-2025 (fr).
       DATE-COMPILED. null.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  USERNAME               PIC X(30) VALUE "cobol".
       01  PASSWD                 PIC X(30) VALUE "mdp".
       01  DBNAME                 PIC X(10) VALUE "test_table".
       EXEC SQL END DECLARE SECTION END-EXEC.
       
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
          
           PERFORM 0100-CONNECT-SQL-BEGIN
              THRU 0100-CONNECT-SQL-END.

           PERFORM 0200-CREATE-AUTHORS-TABLE-BEGIN
              THRU 0200-CREATE-AUTHORS-TABLE-END.

           PERFORM 0300-CREATE-EDITORS-TABLE-BEGIN
              THRU 0300-CREATE-EDITORS-TABLE-END.

           PERFORM 0400-CREATE-TYPES-TABLE-BEGIN
              THRU 0400-CREATE-TYPES-TABLE-END.

           PERFORM 0500-CREATE-PEOPLE-TABLE-BEGIN
              THRU 0500-CREATE-PEOPLE-TABLE-END.

           PERFORM 0600-CREATE-BORROWINGS-TABLE-BEGIN
              THRU 0600-CREATE-BORROWINGS-TABLE-END.

           PERFORM 0700-CREATE-BOOKS-TABLE-BEGIN
              THRU 0700-CREATE-BOOKS-TABLE-END.

           EXIT PROGRAM.

       0100-CONNECT-SQL-BEGIN.
           DISPLAY "Connecting to PostgreSQL...".

           EXEC SQL
            CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME
           END-EXEC.

           IF SQLCODE NOT = 0
               DISPLAY "Connection error SQLCODE: " SQLCODE
               STOP RUN
           END-IF.

           DISPLAY "Successful connection!".

      *    EXEC SQL
      *        SET client_min_messages = warning;
      *    END-EXEC.
       0100-CONNECT-SQL-END.

       0200-CREATE-AUTHORS-TABLE-BEGIN.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS authors (
                   id SERIAL PRIMARY KEY,
                   last_name CHAR(25) NOT NULL,
                   first_name CHAR(25) NOT NULL
               )
           END-EXEC.

           PERFORM 0800-ERROR-CHECK-AND-COMMIT-BEGIN
              THRU 0800-ERROR-CHECK-AND-COMMIT-END.

           DISPLAY "Authors table is available.".
       0200-CREATE-AUTHORS-TABLE-END.

       0300-CREATE-EDITORS-TABLE-BEGIN.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS editors (
                   id SERIAL PRIMARY KEY,
                   name CHAR(25) NOT NULL
               )
           END-EXEC.

           PERFORM 0800-ERROR-CHECK-AND-COMMIT-BEGIN
              THRU 0800-ERROR-CHECK-AND-COMMIT-END.

           DISPLAY "Editors table is available.".
       0300-CREATE-EDITORS-TABLE-END.

       0400-CREATE-TYPES-TABLE-BEGIN.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS types (
                   id SERIAL PRIMARY KEY,
                   name CHAR(20) NOT NULL
               )
           END-EXEC.
           PERFORM 0800-ERROR-CHECK-AND-COMMIT-BEGIN
              THRU 0800-ERROR-CHECK-AND-COMMIT-END.
           
           DISPLAY "Types table is available.".
       0400-CREATE-TYPES-TABLE-END.

       0500-CREATE-PEOPLE-TABLE-BEGIN.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS people (
                   id SERIAL PRIMARY KEY,
                   last_name CHAR(25) NOT NULL,
                   first_name CHAR(25) NOT NULL
               )
           END-EXEC.

           PERFORM 0800-ERROR-CHECK-AND-COMMIT-BEGIN
              THRU 0800-ERROR-CHECK-AND-COMMIT-END.

           DISPLAY "People table is available.".
       0500-CREATE-PEOPLE-TABLE-END.

       0600-CREATE-BORROWINGS-TABLE-BEGIN.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS borrowings (
                   id SERIAL PRIMARY KEY,
                   people_id SERIAL REFERENCES people(id),
                   start_date CHAR(8) NOT NULL,
                   end_date CHAR(8) NOT NULL
               )
           END-EXEC.

           PERFORM 0800-ERROR-CHECK-AND-COMMIT-BEGIN
              THRU 0800-ERROR-CHECK-AND-COMMIT-END.

           DISPLAY "Borrowings table is available.".
       0600-CREATE-BORROWINGS-TABLE-END.

       0700-CREATE-BOOKS-TABLE-BEGIN.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS books (
                   id SERIAL PRIMARY KEY,
                   isbn CHAR(13) NOT NULL,
                   name CHAR(50) NOT NULL,
                   year CHAR(04) NOT NULL,
                   author_id SERIAL REFERENCES authors(id),
                   editor_id SERIAL REFERENCES editors(id),
                   type_id SERIAL REFERENCES types(id)
               )
           END-EXEC.

           PERFORM 0800-ERROR-CHECK-AND-COMMIT-BEGIN
              THRU 0800-ERROR-CHECK-AND-COMMIT-END.
           
           DISPLAY "Books table is available.".
       0700-CREATE-BOOKS-TABLE-END.

       0800-ERROR-CHECK-AND-COMMIT-BEGIN.
           IF SQLCODE NOT = 0
               DISPLAY "Connection error SQLCODE: " SQLCODE
               STOP RUN
           END-IF.
           EXEC SQL COMMIT WORK END-EXEC.
       0800-ERROR-CHECK-AND-COMMIT-END.
