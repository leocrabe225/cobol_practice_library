       IDENTIFICATION DIVISION.
       PROGRAM-ID. readfile.
       AUTHOR. ThomasD & Leocrabe225.
       DATE-WRITTEN. 03-06-2025 (fr).
       DATE-COMPILED. null.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OPTIONAL F-INPUT
               ASSIGN TO DISK
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-F-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD F-INPUT
           VALUE OF FILE-ID IS WS-FILE-NAME.
       01 F-IN-RCD.
           05 F-IN-ISBN          PIC X(13).
           05 F-IN-BOOK-NAME     PIC X(38).
           05 F-IN-AUTH-NAME     PIC X(22).
           05 F-IN-AUTH-FNAME    PIC X(22).
           05 F-IN-TYPE          PIC X(16).
           05 F-IN-YEAR          PIC 9(04).
           05 F-IN-EDIT-NAME     PIC X(25).

       WORKING-STORAGE SECTION.
       01 WS-F-STATUS         PIC X(2).
           88 WS-F-STATUS-OK           VALUE '00'.
           88 WS-F-STATUS-OPEN-ERROR   VALUE '05'.
           88 WS-F-STATUS-EOF          VALUE '10'.
           
       01 WS-FOLDER-NAME      PIC X(20) VALUE "input/".
       01 WS-FILE-NAME        PIC X(40).

       LINKAGE SECTION.
       01 LK-FILE-NAME        PIC X(20).

       PROCEDURE DIVISION USING LK-FILE-NAME.

           STRING WS-FOLDER-NAME LK-FILE-NAME DELIMITED BY SPACE
           INTO WS-FILE-NAME.
           
           OPEN INPUT F-INPUT.

           IF WS-F-STATUS-OPEN-ERROR THEN
               DISPLAY "Error, file " QUOTES FUNCTION TRIM(WS-FILE-NAME)
                       QUOTES " does not exist"
               EXIT PROGRAM
           END-IF.

           PERFORM UNTIL WS-F-STATUS-EOF
               READ F-INPUT
                   NOT AT END
                       PERFORM NO-OP
               END-READ
           END-PERFORM

           CLOSE F-INPUT.
           

           EXIT PROGRAM.

       NO-OP.
           .