
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

