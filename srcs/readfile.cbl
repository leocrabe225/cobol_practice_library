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

       01 WS-ISBN          PIC X(13).
       01 WS-BOOK-NAME     PIC X(50).
       01 WS-AUTH-NAME     PIC X(25).
       01 WS-AUTH-FNAME    PIC X(25).
       01 WS-TYPE          PIC X(20).
       01 WS-YEAR          PIC 9(04).
       01 WS-EDIT-NAME     PIC X(25).

       01 WS-TYPE-ID       PIC 9(10).
       01 WS-AUTHOR-ID     PIC 9(10).
       01 WS-EDITOR-ID     PIC 9(10).

       COPY retstatu REPLACING ==:PREFIX:== BY ==WS==.

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
                       PERFORM 0200-PUT-LINE-IN-DB-BEGIN
                          THRU 0200-PUT-LINE-IN-DB-END
               END-READ
           END-PERFORM

           CLOSE F-INPUT.
           
           DISPLAY "File successfully inserted."

           EXIT PROGRAM.

       0200-PUT-LINE-IN-DB-BEGIN.

           PERFORM 0300-PUT-TYPE-BEGIN
              THRU 0300-PUT-TYPE-END.

           PERFORM 0400-PUT-AUTHOR-BEGIN
              THRU 0400-PUT-AUTHOR-END.

           PERFORM 0500-PUT-EDITOR-BEGIN
              THRU 0500-PUT-EDITOR-END.
      
       0200-PUT-LINE-IN-DB-END.

       0300-PUT-TYPE-BEGIN.
           MOVE F-IN-ISBN TO WS-ISBN.
           MOVE F-IN-BOOK-NAME TO WS-BOOK-NAME.
           MOVE F-IN-AUTH-NAME TO WS-AUTH-NAME.
           MOVE F-IN-AUTH-FNAME TO WS-AUTH-FNAME.
           MOVE F-IN-TYPE TO WS-TYPE.
           MOVE F-IN-YEAR TO WS-YEAR.
           MOVE F-IN-EDIT-NAME TO WS-EDIT-NAME.
           CALL "readtype" USING
               WS-TYPE
               WS-TYPE-ID
               WS-RETURN-VALUE
           END-CALL.

           EVALUATE TRUE
               WHEN WS-RETURN-NOT-FOUND
                   CALL "creatype" USING
                       WS-TYPE
                       WS-RETURN-VALUE
                   END-CALL
                   EVALUATE TRUE
                       WHEN WS-RETURN-ERROR
                           PERFORM 1000-ERROR-LEAVE-BEGIN
                              THRU 1000-ERROR-LEAVE-END
                       WHEN WS-RETURN-OK
                           CALL "readtype" USING
                               WS-TYPE
                               WS-TYPE-ID
                               WS-RETURN-VALUE
                           END-CALL
                           IF NOT WS-RETURN-OK THEN
                               PERFORM 1000-ERROR-LEAVE-BEGIN
                                  THRU 1000-ERROR-LEAVE-END
                           END-IF
                   END-EVALUATE
               WHEN WS-RETURN-ERROR
                   PERFORM 1000-ERROR-LEAVE-BEGIN
                      THRU 1000-ERROR-LEAVE-END
           END-EVALUATE.
       0300-PUT-TYPE-END.

       0400-PUT-AUTHOR-BEGIN.
           CALL "readauth" USING
               WS-AUTH-NAME
               WS-AUTH-FNAME
               WS-AUTHOR-ID
               WS-RETURN-VALUE
           END-CALL.

           EVALUATE TRUE
               WHEN WS-RETURN-NOT-FOUND
                   CALL "creaauth" USING
                       WS-AUTH-NAME
                       WS-AUTH-FNAME
                       WS-RETURN-VALUE
                   END-CALL
                   EVALUATE TRUE
                       WHEN WS-RETURN-ERROR
                           PERFORM 1000-ERROR-LEAVE-BEGIN
                              THRU 1000-ERROR-LEAVE-END
                       WHEN WS-RETURN-OK
                           CALL "readauth" USING
                               WS-AUTH-NAME
                               WS-AUTH-FNAME
                               WS-AUTHOR-ID
                               WS-RETURN-VALUE
                           END-CALL
                           IF NOT WS-RETURN-OK THEN
                               PERFORM 1000-ERROR-LEAVE-BEGIN
                                  THRU 1000-ERROR-LEAVE-END
                           END-IF
                   END-EVALUATE
               WHEN WS-RETURN-ERROR
                   PERFORM 1000-ERROR-LEAVE-BEGIN
                      THRU 1000-ERROR-LEAVE-END
           END-EVALUATE.
       0400-PUT-AUTHOR-END.

       0500-PUT-EDITOR-BEGIN.
           CALL "readedit" USING
               WS-EDIT-NAME
               WS-EDITOR-ID
               WS-RETURN-VALUE
           END-CALL.

           EVALUATE TRUE
               WHEN WS-RETURN-NOT-FOUND
                   CALL "creaedit" USING
                       WS-EDIT-NAME
                       WS-RETURN-VALUE
                   END-CALL
                   EVALUATE TRUE
                       WHEN WS-RETURN-ERROR
                           PERFORM 1000-ERROR-LEAVE-BEGIN
                              THRU 1000-ERROR-LEAVE-END
                       WHEN WS-RETURN-OK
                           CALL "readedit" USING
                               WS-EDIT-NAME
                               WS-EDITOR-ID
                               WS-RETURN-VALUE
                           END-CALL
                           IF NOT WS-RETURN-OK THEN
                               PERFORM 1000-ERROR-LEAVE-BEGIN
                                  THRU 1000-ERROR-LEAVE-END
                           END-IF
                   END-EVALUATE
               WHEN WS-RETURN-ERROR
                   PERFORM 1000-ERROR-LEAVE-BEGIN
                      THRU 1000-ERROR-LEAVE-END
           END-EVALUATE.
       0500-PUT-EDITOR-END.

       1000-ERROR-LEAVE-BEGIN.
           DISPLAY "Error while reading file".
           EXIT PROGRAM.
       1000-ERROR-LEAVE-END.
