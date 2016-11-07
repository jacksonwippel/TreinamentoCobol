       identification division.
       program-id. cadcli.
       author. HBSIS Informática Solucoes em TI by Jackson R Wippel.
       date-written. 01/04/2012 (Treinamento Cobol) utilizando Git
       environment division.
         configuration section.

         copy slrelatorio.cpy.
         copy slcadcli.cpy.

       data division.
         copy fdcadcli.cpy.
         copy fdrelatorio.cpy.

       working-storage section.
       78 relatorio-impressao                     value "impressao".

       01 ws-param-relatorio.
          03 ws-nome-arq-rel                    pic x(250) value spaces.

       01 wid-relatorio              pic x(250) value spaces.

       01 fs-clientes.
          02 fs-clientes-1            pic 9.
          02 fs-clientes-2            pic 9.
          02 fs-cliente-r redefines fs-clientes-2 pic 99 comp-x.
          77 opcao                       pic x value spaces.
          77 ws-opcao                    pic 9(1) value 0.

       01  ws-campos-trabalho.
           03 ws-teclas                          pic x(02).
              88 tecla-enter                                 value "00".
              88 esc                                         value "01".
              88 funcao-1                                    value "02".
              88 funcao-4                                    value "05".
              88 funcao-5                                    value "06".
              88 funcao-6                                    value "07".
              88 funcao-7                                    value "08".
              88 funcao-8                                    value "09".
              88 funcao-9                                    value "10".
              88 funcao-10                                   value "11".
              88 pgup                                        value "54".
              88 pgdn                                        value "55".
           03 ws-col                      pic 9(02)       value 1.
           03 ws-mensagem                 pic x(100)      value spaces.
           03 ws-dt-edit                  pic x(10)       value spaces.
           03 ws-horas                          pic 9(8)        value 0.
           03 ws-hora-1 redefines ws-horas.
              05 ws-hora                        pic 9(2).
              05 ws-minu                        pic 9(2).
              05 ws-segu                        pic 9(2).
              05 ws-mile                        pic 9(2).

       01 ws-reg-cliente.
          02 wcodigo              pic 9(4) value zeros.
          02 wnome                pic x(50).
          02 wdata-nas.
             03 wdia-nas             pic 9(02) value zeros.
             03 wmes-nas             pic 9(02) value zeros.
             03 wano-nas             pic 9(4) value zeros.
          02 wtelefone               pic x(30).
          02 wendereco               pic x(50).
          02 wnumero                 pic 9(6) value zeros.
          02 wcomplemento            pic x(30).
          02 wbairro                 pic x(30).
          02 wcidade                 pic x(30).
          02 wcep                    pic x(8).
          02 westado                 pic AA.
          02 wemail                  pic x(50).

       01 Linha-cabecalho.
          10 filler                    pic x(031) value spaces.
          10 filler    pic x(017) value "Lista de Pessoa".
       01 Linha-cabecalho-labels.
          10 filler                    pic x(006) value "Codigo".
          10 filler                    pic x(001).
          10 filler                    pic x(050) value "Nome".
          10 filler                    pic x(001).
          10 filler                    pic x(010) value "Nasc.".
          10 filler                    pic x(001).
          10 filler                    pic x(030) value "Tipo".
       01 Linha-cabecalho-linha.
          10 filler                    pic x(006) value all "=".
          10 filler                    pic x(001).
          10 filler                    pic x(050) value all "=".
          10 filler                    pic x(001).
          10 filler                    pic x(010) value all "=".
          10 filler                    pic x(001).
          10 filler                    pic x(030) value all "=".
       01 Linha-detalhe.
          10 detalhe-codigo            pic z(006).
          10 filler                    pic x(001).
          10 detalhe-nome              pic x(050).
          10 filler                    pic x(001).
          10 detalhe-nasc.
             20 detalhe-dia            pic 9(002).
             20 filler                 pic x(001) value "/".
             20 detalhe-mes            pic 9(002).
             20 filler                 pic x(001) value "/".
             20 detalhe-ano            pic 9(004).
          10 filler                    pic x(001).
          10 detalhe-tipo              pic x(030). *>Fisica/Juridica

       screen section.
       01  scr-menu.
           03 blank screen.
           03 line 01 column 01 "Menu Principal      ".
           03 line 02 column 01 "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ".
           03 line 03 column 01 "(1) Cadastro Cliente".
           03 line 04 column 01 "(2) Exclusao Cliente".
           03 line 05 column 01 "(3) Impressao       ".
           03 line 05 column 01 "(4) Cadastro Cidades".
           03 line 06 column 01 "(5) Cadastro Bairros".
           03 line 07 column 01 "( ) Opcao".
           03 line 08 column 01 "F1-Ajuda".


       procedure division.
           perform 1000-inicio
           perform 2000-processo
           perform 3000-finaliza.

       0000-saida.
            exit program
            stop run.

       1000-inicio section.
       1000.
           perform 1001-abre-arquivos.
       1000-saida.
       1000.
           exit.

       1001-abre-arquivos section.
       1001.
           open i-o clientes with lock
           if   fs-clientes = "9A"
               display "Arquivo locado"
               accept ws-teclas
           end-if
           .
       1001-saida.
       1001.
           exit.

       2000-processo section.
       2000.
          display erase
          perform 2001-menu-principal until ws-opcao equal 9.
       2000-exit section.
       2000.
          exit.

       2001-menu-principal section.
       2001.
          display scr-menu
          move 0                  to ws-opcao
          accept  ws-opcao        at 0602
          with update auto-skip
          accept ws-teclas from escape key
          if   esc
               perform 3000-finaliza
          end-if
          evaluate ws-opcao
              when 1
                  perform 2002-incluir
              when 2
                  perform 2002-excluir
              when 3
                  perform 2003-imprimir
              when 4
                  perform 2004-cadastro-cidades
              when 5
                  perform 2005-cadastro-bairros
              when 9
                  perform 3000-finaliza
          end-evaluate.

       2001-exit section.
       2001.
          exit.

       2005-cadastro-cidades section.
       2005.

       2005.
          exit.

       2004-cadastro-cidades section.
       2004.

       2004.
          exit.


       2003-imprimir section.
       2003.
          display erase
          display "Relatorio de clientes" at 0430
          move spaces                   to ws-reg-cliente
          display "Codigo             : " at 0605
          accept wcodigo                  at 0625

          perform 2007-monta-label-rel
          open output relatorio

          move linha-cabecalho to relatorio-registro
          write relatorio-registro

          move linha-cabecalho-labels to relatorio-registro
          write relatorio-registro

          open input clientes
          initialize registro-clientes
          if   wcodigo <> zeros
               move wcodigo    to codigo
          end-if
          start clientes key is not less codigo
          read clientes next
          perform until fs-clientes equal "10"
            if  wcodigo <> zeros
                if wcodigo <> codigo
                   exit perform
                end-if
            end-if
            move codigo to detalhe-codigo
            move nome to detalhe-nome
            move dia-nas to detalhe-dia
            move mes-nas to detalhe-mes
            move ano-nas to detalhe-ano
            move linha-detalhe to relatorio-registro
            write relatorio-registro
            read clientes next
          end-perform
          close relatorio

          move wid-relatorio       to ws-nome-arq-rel
          call relatorio-impressao using ws-param-relatorio
          cancel relatorio-impressao.

       2003-exit section.
       2003.
          exit.

       2002-incluir section.
       2002.
          display erase
          display "Cadastro de clientes" at 0430
          move spaces                   to ws-reg-cliente
          display "Codigo             : " at 0605
          accept wcodigo                  at 0625
          move wcodigo                    to codigo
          display "Nome               : " at 0705
          display "Data Nascimento    :   /  /" at 0805
          read clientes with lock
          if   fs-clientes = "9D"
               display "O registro está locado"
               accept ws-teclas
          end-if


          if  fs-clientes = "00"
              string dia-nas"/"mes-nas"/"ano-nas into ws-dt-edit
              display ws-dt-edit              at 0825
              display nome                    at 0725
              display "Cliente ja existe. Deseja alterar [S/N]: "
              accept opcao
          else
              move "S"                        to opcao
          end-if
          if   function upper-case(opcao) =  "S"
               display "                                       "
               accept wnome                    at 0725
               accept wdia-nas                 at 0825
               accept wmes-nas                 at 0828
               accept wano-nas                 at 0831
               move wnome                      to nome
               move wdata-nas                  to data-nas
               perform 2006-gravar-arquivo
          end-if.

       2002-exit.
       2002.
          exit.

       2002-excluir section.

          display erase
          display "Excluir Cliente"       at 0430
          display "Codigo             : " at 0605
          accept wcodigo                  at 0625
          move wcodigo                    to codigo
          read clientes
          if  fs-clientes = "23"
              display "Cliente não cadastrado" at 1905
          else
              delete clientes
          end-if.

       2002-exit.
       2002.
          exit.

       2005-move-tela-arq section.
       2005.
          move ws-reg-cliente to registro-clientes.
       2005-exit section.
       2005.
          exit.
       2006-gravar-arquivo section.
       2006.
          write registro-clientes
          if   fs-clientes = "22"
               rewrite registro-clientes
          end-if.

       2006-exit section.
       2006.
          exit.

      *>===================================================================================
       2007-monta-label-rel section.
       2007.
            move spaces to wid-relatorio
            accept ws-horas from time
            string "Relatorio" delimited by " ",
                   "_",
                   ws-horas,
                   ".rel"
                   into wid-relatorio.
       2007-exit.
            exit.

       3000-finaliza section.
       3000.
       display erase
       stop run.

