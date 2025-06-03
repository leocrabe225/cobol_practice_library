       IDENTIFICATION DIVISION.
       PROGRAM-ID. blibrary.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 03-06-2025 (fr).
       DATE-COMPILED. null.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  USERNAME               PIC X(30) VALUE "cobol".
       01  PASSWD                 PIC X(30) VALUE "mdp".
       01  DBNAME                 PIC X(10) VALUE "test_table".
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
           DISPLAY "Connecting to PostgreSQL...".

           EXEC SQL
            CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME
           END-EXEC.

           IF SQLCODE NOT = 0
               DISPLAY "Connection error SQLCODE: " SQLCODE
               STOP RUN
           END-IF.

           DISPLAY "Successful connection!".

      * 13 - 13 ISNB
      * 38 - 50 Book name
      * 22 - 25 Author Name
      * 22 - 25 Author fname
      * 16 - 20 Type
      * 04 - 04 Year
      * 23 - 25 Editor name
           EXEC SQL
               CREATE TABLE IF NOT EXISTS authors (
                   id SERIAL PRIMARY KEY,
                   last_name CHAR(25) NOT NULL,
                   first_name CHAR(25) NOT NULL
               )
           END-EXEC.
           IF SQLCODE NOT = 0
               DISPLAY "Connection error SQLCODE: " SQLCODE
               STOP RUN
           END-IF.
           EXEC SQL COMMIT WORK END-EXEC.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS editors (
                   id SERIAL PRIMARY KEY,
                   name CHAR(25) NOT NULL
               )
           END-EXEC.
           EXEC SQL COMMIT WORK END-EXEC.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS types (
                   id SERIAL PRIMARY KEY,
                   name CHAR(20) NOT NULL
               )
           END-EXEC.
           EXEC SQL COMMIT WORK END-EXEC.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS people (
                   id SERIAL PRIMARY KEY,
                   last_name CHAR(25) NOT NULL,
                   first_name CHAR(25) NOT NULL
               )
           END-EXEC.
           EXEC SQL COMMIT WORK END-EXEC.
           EXEC SQL
               CREATE TABLE IF NOT EXISTS borrowings (
                   id SERIAL PRIMARY KEY,
                   people_id SERIAL REFERENCES people(id),
                   start_date CHAR(8) NOT NULL,
                   end_date CHAR(8) NOT NULL
               )
           END-EXEC.
           IF SQLCODE NOT = 0
               DISPLAY "Connection error SQLCODE: " SQLCODE
               STOP RUN
           END-IF.
           EXEC SQL COMMIT WORK END-EXEC.
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
           IF SQLCODE NOT = 0
               DISPLAY "Connection error SQLCODE: " SQLCODE
               STOP RUN
           END-IF.
           EXEC SQL COMMIT WORK END-EXEC.

           EXEC SQL
               DISCONNECT ALL
           END-EXEC.

           STOP RUN.
