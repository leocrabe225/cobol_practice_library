       IDENTIFICATION DIVISION.
       PROGRAM-ID. readfile.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 03-06-2025 (fr).
       DATE-COMPILED. null.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OPTIONAL IN-FILE
               ASSIGN TO DISK
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-F-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD IN-FILE
           VALUE OF FILE-ID IS WS-FILE-NAME.
       01 IN-LINE PIC X(20).
           

       WORKING-STORAGE SECTION.
       01 WS-F-STATUS         PIC X(2).
           88 WS-F-STATUS-OK           VALUE '00'.
           88 WS-F-STATUS-EOF          VALUE '10'.
           
       01 WS-FOLDER-NAME      PIC X(20) VALUE "input/".
       01 WS-FILE-NAME        PIC X(40).

       LINKAGE SECTION.
       01 LK-FILE-NAME        PIC X(20).

       PROCEDURE DIVISION USING LK-FILE-NAME.
           STRING WS-FOLDER-NAME LK-FILE-NAME DELIMITED BY SPACE
           INTO WS-FILE-NAME.
           DISPLAY WS-FILE-NAME.
           
           OPEN INPUT IN-FILE.
           READ IN-FILE.
           DISPLAY IN-LINE.
           CLOSE IN-FILE.
           

           EXIT PROGRAM.