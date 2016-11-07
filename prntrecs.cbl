      $set Ans85 Mf DefaultByte"00"
       id division.
       program-id.   impressao.
       environment division.
       input-output section.
       file-control.
           select input-file assign to "relatorio.txt"
                             organization line sequential
                             file status is file-status.

       data division.
       file section.
       fd input-file
          record is varying in size from 1 to 80 characters
          depending on record-length-read.
       01 input-file-record               pic x(80).
       working-storage section.
       copy "prntopen.cpy".
       78 PROGRAM-NAME                                 value "PRNTRECS".
       78 CRLF                                            value x"0D0A".

       01 record-length-read              pic 9(3)        value zeroes.
       01 ws-print-buffer                 pic x(82)       value spaces.
       01 ws-print-buffer-length          pic x(4) comp-5 value zeroes.
      *----------------------------------------------------------------*
      *   The Net Express RTS can use the COBOL file status item to    *
      *   report an extended error. If the first byte = "9" then the   *
      *   second byte is a binary value indicating the extended run-   *
      *   time error code. These are documented in the Net Express     *
      *   Help file. Look in the Index under RTS/RTS Error Messages.   *
      *----------------------------------------------------------------*
       01 file-status                     pic x(2)        value spaces.
          88 file-status-ok                               value "00".
          88 read-complete                                value "10".
       01 redefines file-status.
          05 file-status1                 pic x.
             88 rts-error-occurred                        value "9".
          05 run-time-error               pic x comp-x.

      *>===================================================================================
       linkage section.
       01 ws-parametros-relatorio.
           03 ws-nome-arq          pic x(100).

       procedure division using ws-parametros-relatorio.
       000-begin.

           display PROGRAM-NAME ": Starting."

           perform 100-open-input-file
           if file-status-ok
              perform 105-open-printer
              if printer-status-ok
                 perform 110-print-from-file
                 perform 115-close-printer
              end-if
              close input-file
           end-if

           display PROGRAM-NAME ": Ending."
           stop run.

      *----------------------------------------------------------------*

       100-open-input-file.

           open input input-file
           if file-status-ok
              display PROGRAM-NAME ": Input file opened OK!"
           else
              if rts-error-occurred
                 display PROGRAM-NAME
                    ": Run-time error on open file = " run-time-error
              else
                 display PROGRAM-NAME
                    ": Error on open file - status = " file-status
              end-if
           end-if.

      *----------------------------------------------------------------*

       105-open-printer.

           move length of title-text to title-length
           move "Print from File Test" to title-text

      ***  Do not display a printer or font dialog box on open.
      ***  Use default settings but print in portrait mode.

           set printer-portrait to true

           call "PC_PRINTER_OPEN"
              using by reference printer-handle
                    by reference document-title
                    by value     printer-flags
                    by value     window-handle
              returning          status-code
           end-call

           if printer-status-ok
              display PROGRAM-NAME ": Printer opened OK!"
           else
              display PROGRAM-NAME
                 ": Error on open printer - status = " status-code
           end-if.

      *----------------------------------------------------------------*

       110-print-from-file.

           perform until exit
              perform 200-read-input-file
              if read-complete   *> at end condition
                 exit perform
              else
                 if file-status-ok
                    perform 205-write-to-printer
                    if not printer-status-ok
                       exit perform
                    end-if
                 else
                    exit perform
                 end-if
              end-if
           end-perform.

      *----------------------------------------------------------------*

       115-close-printer.

           call "PC_PRINTER_CLOSE"
              using by reference printer-handle
              returning status-code
           end-call.

      *----------------------------------------------------------------*

       200-read-input-file.

           read input-file into ws-print-buffer
              at end
                 display PROGRAM-NAME ": Print Complete!"
              not at end
                 if file-status-ok
                    display PROGRAM-NAME ": File read OK!"
                 else
                    if rts-error-occurred
                       display PROGRAM-NAME
                          ": Run-time error on read file = "
                          run-time-error
                    else
                       display PROGRAM-NAME
                          ": Error on read file - status = " file-status
                    end-if
                 end-if
           end-read.

      *----------------------------------------------------------------*

       205-write-to-printer.

      ***  append carraige return/line feed to end of record
      ***  and increment the record length by 2 characters accordingly.

           move CRLF to ws-print-buffer (record-length-read + 1:2)
           compute ws-print-buffer-length = record-length-read + 2

           call "PC_PRINTER_WRITE"
              using by reference printer-handle
                    by reference ws-print-buffer
                    by value     ws-print-buffer-length
              returning status-code
           end-call

           if printer-status-ok
              display PROGRAM-NAME ": Printer write OK!"
           else
              display PROGRAM-NAME ": Error on printer write = "
                 status-code
           end-if.

