      $set Ans85 Mf DefaultByte"00"
       id division.
       program-id.   impressao.
       environment division.
       input-output section.
       file-control.
           select input-file assign to wid-relatorio
                             organization line sequential
                             file status is file-status.

       data division.
       file section.
       fd input-file
          record is varying in size from 1 to 80 characters
          depending on record-length-read.
       01 input-file-record               pic x(80).
       working-storage section.

       01 printer-handle                  pic x(4) comp-5 value zeroes.
       01 document-title.
          05 title-length                 pic x(2) comp-5 value zeroes.
          05 title-text                   pic x(20)       value spaces.
       01 printer-flags                   pic x(4) comp-5 value zeroes.
          88 printer-dialog-only                          value 1.
          88 font-dialog-only                             value 2.
          88 printer-and-font-dialog                      value 3.
          88 printer-portrait                             value 4.
          88 printer-landscape                            value 8.
          88 printer-progress                             value 16.
       01 window-handle                   pic x(4) comp-5 value 0.
       01 status-code             pic x(2) comp-5 value zeroes.
          88 printer-status-ok                            value 0.

       78 este-programa                              value "IMPRESSAO".
       78 delimitador                                    value x"0D0A".

       01 wid-relatorio              pic x(250) value spaces.


       01 record-length-read              pic 9(3)        value zeroes.
       01 ws-print-buffer                 pic x(82)       value spaces.
       01 ws-print-buffer-length          pic x(4) comp-5 value zeroes.
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
           03 ws-nome-arq          pic x(250).

       procedure division using ws-parametros-relatorio.
       000-begin.

           perform 100-open-input-file
           if file-status-ok
              perform 105-open-printer
              if printer-status-ok
                 perform 110-print-from-file
                 perform 115-close-printer
              end-if
              close input-file
           end-if
           stop run.

      *----------------------------------------------------------------*

       100-open-input-file.
           move ws-nome-arq  to wid-relatorio
           open input input-file.

      *----------------------------------------------------------------*

       105-open-printer.

           move length of title-text to title-length
           move "Print from File Test" to title-text

           set printer-portrait to true

           call "PC_PRINTER_OPEN"
              using by reference printer-handle
                    by reference document-title
                    by value     printer-flags
                    by value     window-handle
              returning          status-code
           end-call

           if printer-status-ok
              display este-programa ": Arquivo de impressao OK!"
           else
              display este-programa
                 ": Erro ao abrir arquivo de impressao - status = "
                 status-code
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
                 display este-programa ": Impressao Completa!"
              not at end
                 if file-status-ok
                    display este-programa ": Leitura OK!"
                 else
                    if rts-error-occurred
                       display este-programa
                          ": Erro ao ler arquivo = "
                          run-time-error
                    else
                       display este-programa
                          ": Erro na leitura do arquivo - status = "
                          file-status
                    end-if
                 end-if
           end-read.

      *----------------------------------------------------------------*

       205-write-to-printer.

      ***  append carraige return/line feed to end of record
      ***  and increment the record length by 2 characters accordingly.

           move delimitador
           to ws-print-buffer (record-length-read + 1:2)
           compute ws-print-buffer-length = record-length-read + 2

           call "PC_PRINTER_WRITE"
              using by reference printer-handle
                    by reference ws-print-buffer
                    by value     ws-print-buffer-length
              returning status-code
           end-call

           if not printer-status-ok
              display este-programa ": Erro ao imprimir = "
                 status-code
           end-if.

