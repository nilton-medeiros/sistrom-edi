/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 10-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 CONEMB: Versão 3.1 - 27/04/2000 (REVISÃO DE 01/11/2012)
 OCOREN: Versão 3.0A - 03/03/1999
 DOCCOB: Versão 3.0A - 03/03/1999

 Arquivo: Main.prg
 Rotinas: Inicialização do Sistema e Form principal após o login
***********************************************************************************/

#include <hmg.ch>

#define TRES_MINUTOS 180000
#define MEIO_SEGUNDO 500

REQUEST HB_CODEPAGE_UTF8          /*  Este comando instrui o compilador a carregar as funções da CodePage UTF8EX com suporte a caracteres latinos.  */
//REQUEST HB_CODEPAGE_PT850
//REQUEST HB_CODEPAGE_UTF8EX        /*  Este comando instrui o compilador a carregar as funções da CodePage UTF8EX com suporte a caracteres latinos.  */
REQUEST HB_LANG_PT                  /*  Este comando instrui o compilador a carregar as funções de suporte de MENSAGENS INTERNAS DO HARBOUR para o idioma em português.  */

procedure Main

          // Definição de variáveis Públicas (Globais)

          // Objetos Públicos (Globais)
          public app := TAppData():New('1.1.0')  // Configurações iniciais

          // Arrays Públicos
          // Booleans Públicos
          // Números Públicos
          // Blocos de códigos Públicos (Usados nos Forms .fmg)
          // Strings Públicas

          // Início do sistema

          if HMG SUPPORT UNICODE RUN

          hb_langSelect('PT')           /*  Esta função define que o sistema ao exibir mensagens internas do Harbour, como as mensagens de erro por exemplo, que sejam apresentadas no idioma português.  */
          hb_cdpSelect('UTF8')        /*  Esta função instrui o sistema a usar a CodePage UTF8 ou UTF8EX a partir desse ponto em diante no sistema.  */

          SET CODEPAGE TO UNICODE
          SET MULTIPLE OFF WARNING      // Impedes Attempts To Run Multiple Instances Of The Application
          SET LANGUAGE TO PORTUGUESE
          SET TOOLTIPSTYLE BALLOON
          SET NAVIGATION EXTENDED
          SET DATE BRITISH
          SET CENTURY ON
          SET EPOCH TO YEAR(DATE()) - 20

          app:appRegistry()

          if is_true(RegistryRead(app:pathRegistry + "Monitoring\Don'tRun"))
             MessageBoxTimeout('O programa NÃO será executado. Ambiente de teste ou em atualização!', 'SistromEDI-PROCEDA (' + app:version + ')', MB_ICONEXCLAMATION, 10000)
             QUIT
          endif

          // Formulário principal Main.Fmg *********************************************************************************************

          DEFINE WINDOW Main;
              AT 142, 298;
              WIDTH 1320;
              HEIGHT 700;
              TITLE 'SistromEDI - Geração de EDI (Proceda-Versão.3.0A e 3.1)';
              ICON 'AppIcon';
              MAIN;
              ON INIT main_form_on_init();
              ON RELEASE main_form_on_release();
              ON SIZE main_form_on_size();
              ON MAXIMIZE main_form_on_maximize();
              BACKCOLOR {255,255,255};
              FONT 'Open Sans' SIZE 10

              DEFINE SPLITBOX

                  DEFINE TOOLBAR TooBar_1 BUTTONSIZE 45,40 IMAGESIZE 32,32 FONT 'Open Sans' SIZE 8 FLAT

                      // Botões do menu principal
                      BUTTON bttb_edi CAPTION 'EDI' PICTURE 'bttEDIGray' AUTOSIZE ACTION edi_generate_form()
                      BUTTON bttb_ftp CAPTION 'FTP' PICTURE 'bttFTPGray' AUTOSIZE ACTION ftp_send_form()
                      BUTTON bttb_cadastros CAPTION 'Cadastros' PICTURE 'bttRegistrationsGray'   AUTOSIZE WHOLEDROPDOWN
                      BUTTON bttb_sistema CAPTION 'Sistema' PICTURE 'bttSystemGray'  AUTOSIZE WHOLEDROPDOWN

                      // Menu Cadastros do Button ToolBar
                      DEFINE DROPDOWN MENU BUTTON bttb_cadastros
                          ITEM 'Clientes' action clients_form_list() NAME menu_clientes IMAGE 'mnuClients'
                          ITEM 'Usuários' ACTION form_users_list() NAME menu_usuarios IMAGE 'mnuUsers'
                      end MENU

                      // Menu Sistema
                      DEFINE DROPDOWN MENU BUTTON bttb_sistema
                          ITEM 'Empresas'        ACTION form_companies_list() NAME menu_empresas IMAGE 'mnuCompaniesBlue'
                          ITEM 'Configurações'   ACTION form_settings() NAME menu_configuracoes IMAGE 'mnuSettingsBlue'
                          ITEM 'Logs do Sistema' ACTION open_log_folder() NAME menu_logsys IMAGE 'mnuLogSysBlue'
                          ITEM 'Sobre'           ACTION show_about() NAME menu_sobre IMAGE 'mnuAboutBlue'
                      END MENU

                  END TOOLBAR

                  DEFINE TOOLBAR TooBar_2 BUTTONSIZE 200,40 IMAGESIZE 200,32 FONT 'Open Sans' SIZE 8 FLAT
                      BUTTON bttb_calendar CAPTION extended_date() PICTURE 'bttCalendarGray' TOOLTIP 'Clique aqui para ver o calendário' AUTOSIZE ACTION show_calendar()
                  END TOOLBAR

                  DEFINE TOOLBAR TooBar_3 BUTTONSIZE 120,40 IMAGESIZE 90,32 FONT 'Open Sans' SIZE 8 FLAT
                      BUTTON bttb_notificaoes CAPTION '0.000 Notificações' PICTURE 'bttNotificationsGray' TOOLTIP 'Clique aqui para ler e enviar recados' AUTOSIZE ACTION show_notifications()
                  END TOOLBAR

                  DEFINE TOOLBAR TooBar_4 BUTTONSIZE 200,40 IMAGESIZE 200,32 FONT 'Open Sans' SIZE 8 FLAT
                      BUTTON bttb_empresas CAPTION 'EMPRESAS...' PICTURE 'bttCompanies' TOOLTIP 'Clique aqui para trocar empresa' AUTOSIZE ACTION change_company()
                  END TOOLBAR

                  DEFINE TOOLBAR TooBar_5 BUTTONSIZE 60,40 IMAGESIZE 60,32 FONT 'Open Sans' SIZE 8 FLAT
                      BUTTON bttb_senha CAPTION 'Olá ...' PICTURE 'bttMan' TOOLTIP 'Clique aqui para alterar sua senha' AUTOSIZE ACTION change_password()
                  END TOOLBAR

                  DEFINE TOOLBAR TooBar_6 BUTTONSIZE 60,40 IMAGESIZE 60,32 FONT 'Open Sans' SIZE 8 FLAT
                      BUTTON bttb_desligar CAPTION 'Desligar' PICTURE 'bttTurnOffGray' AUTOSIZE ACTION fechar_sistema()
                  END TOOLBAR

              END SPLITBOX

              DEFINE IMAGE Image_1
                  ROW    75
                  COL    253
                  WIDTH  630
                  HEIGHT 550
                  PICTURE 'imgLogoPrincipal'
                  VISIBLE true
                  STRETCH false
                  BACKGROUNDCOLOR {255,255,255}
              END IMAGE

              DEFINE STATUSBAR FONT 'Open Sans' SIZE 9
                  STATUSITEM 'Status' WIDTH 800
                  STATUSITEM 'Aguardando login...' WIDTH 300
                  STATUSITEM 'Conectando...' WIDTH 220
              END STATUSBAR

              DEFINE TIMER Timer_1_main INTERVAL TRES_MINUTOS ACTION main_timer1()
              DEFINE TIMER Timer_2_main INTERVAL MEIO_SEGUNDO ACTION main_timer2()

          END WINDOW

          // Fim da definição do formulário principal Main.Fmg *************************************************************************

          on key escape of Main action fechar_sistema(true)

          if GetDesktopWidth() <= 1370    // Esse numero baseado em monitor de 15" resolução 1366 x 768
              Main.Maximize
          else
              Main.CENTER
          endif

          main_form_on_size()
          Main.ACTIVATE

return

procedure main_form_on_size()
          // local size

          if Main.HEIGHT < 700
              Main.HEIGHT := 700    // Preserva a altura mínima
          endif
          if Main.WIDTH < 1200      // Preserva a largura mínima
              Main.WIDTH := 1200
          endif

          // Calcula e reposiciona a imagem principal no cetro do form Main alterado
          Main.Image_1.COL := Main.WIDTH/2 - Main.Image_1.WIDTH/2
          Main.Image_1.ROW := Main.HEIGHT/2 - Main.Image_1.HEIGHT/2

          /* Registrado apenas por motivo didático, não há compomentes ou intenção no form principal para redimencionar
          // Tamanho da tela foi alterado pelo usuário, aumenta ou diminui componentes do form Main
          if Main.HEIGHT > app:HEIGHT
            // Tamanho do form Main aumentou
            size := int((Main.HEIGHT-app:HEIGHT)/2)
            Main.frame_Lotes.HEIGHT := Main.frame_Lotes.HEIGHT + size
          else
            // Tamanho do form Main diminuiu
            size := int((app:HEIGHT-Main.HEIGHT)/2)
            Main.frame_Lotes.HEIGHT := Main.frame_Lotes.HEIGHT - size
          endif
          */

          // Salva a última altura do form Main
          app:HEIGHT := Main.HEIGHT
          app:WIDTH := Main.WIDTH

return

procedure main_form_on_init()

          Main.Timer_1_Main.ENABLED := false
          Main.Timer_2_Main.ENABLED := false

          Main.TooBar_1.VISIBLE := false  // Menus
          Main.TooBar_3.VISIBLE := false  // Notificações
          Main.TooBar_4.VISIBLE := false  // Empresas
          Main.TooBar_5.VISIBLE := false  // Trocar Senha

          app:registryDB()

          load window login
          on key escape of login action login_form_key_escape()
          login.CENTER
          login.ACTIVATE

          if app:logged

             saveLog('Usuario logado: ' + app:getUser())
             app:setCompanies(RegistryRead(app:pathUser + 'lastCompany'))

             // Ocultar botões até que as permissões sejam restauradas
             Main.bttb_edi.HIDE
             Main.bttb_ftp.HIDE
             Main.bttb_cadastros.HIDE
                Main.menu_clientes.HIDE
                Main.menu_usuarios.HIDE
             Main.bttb_sistema.HIDE
                Main.menu_empresas.HIDE
                Main.menu_configuracoes.HIDE
                Main.menu_logsys.HIDE
                Main.menu_sobre.HIDE

             settings_icons_colors_form_Main()
             set_permissions()

             Main.bttb_edi.SHOW
             Main.bttb_ftp.SHOW
             // Cadastros
             Main.bttb_cadastros.SHOW
             Main.menu_clientes.SHOW
             Main.menu_usuarios.SHOW
             // Sistema
             Main.bttb_sistema.SHOW
             Main.menu_empresas.SHOW
             Main.menu_configuracoes.SHOW
             Main.menu_logsys.SHOW
             Main.menu_sobre.SHOW

             Main.TooBar_1.VISIBLE := true
             Main.TooBar_3.VISIBLE := true
             Main.TooBar_4.VISIBLE := true
             Main.TooBar_5.VISIBLE := true

             main_timer1()
             main_timer2()

          else
            turnOFF()
          endif

return

procedure main_form_on_maximize()
          main_form_on_size()
return

procedure main_form_on_release()
          status_message('Encerrando conexão com o servidor, aguarde...')
          RegistryWrite(app:pathRegistry + 'Monitoring\Running', 0)
          app:mysql:disconnect()
return

procedure fechar_sistema(confirm_exit)
    Local timer1_status := GetProperty("Main", "Timer_1_Main", "Enabled")
    Local timer2_status := GetProperty("Main", "Timer_2_Main", "Enabled")

    DEFAULT confirm_exit := false

    SetProperty("Main", "Timer_1_Main", "Enabled", false)
    SetProperty("Main", "Timer_2_Main", "Enabled", false)

    if ! (confirm_exit) .OR. MsgYesNo('Deseja sair do sistema?', 'Sistrom - EDI', false)
        turnOFF(true)
    END

    SetProperty("Main", "Timer_1_Main", "Enabled", timer1_status)
    SetProperty("Main", "Timer_2_Main", "Enabled", timer2_status)

return

procedure turnOFF(user)
          default user := false
          if user
             saveLog('Sistema encerrado pelo usuário')
          else
              saveLog('Sistema encerrou a execução')
          endif
          RegistryWrite(app:pathRegistry + 'Monitoring\Running', 0)
          //QUIT  // Não é permitido liberar uma janela em seu próprio procedimento 'on release' ou liberar a janela principal em qualquer procedimento 'on release'.
          RELEASE WINDOW ALL
return

procedure set_permissions()

          Main.bttb_edi.ENABLED := app:getUser('menu_edi', 'as logical')
          Main.bttb_ftp.ENABLED := app:getUser('menu_ftp', 'as logical')
          // Menu do botão Cadastro
          Main.menu_clientes.ENABLED := app:getUser('menu_clientes', 'as logical')
          Main.menu_usuarios.ENABLED := app:getUser('menu_usuarios', 'as logical')
          Main.bttb_cadastros.ENABLED := Main.menu_clientes.ENABLED .or. Main.menu_usuarios.ENABLED
          // Menu do botão Sistema
          Main.menu_empresas.ENABLED := app:getUser('menu_empresas', 'as logical')
          Main.menu_configuracoes.ENABLED := app:getUser('menu_configuracoes', 'as logical')
          Main.menu_logsys.ENABLED := app:getUser('menu_log_sistema', 'as logical')
          Main.bttb_sistema.ENABLED := Main.menu_empresas.ENABLED .or. Main.menu_configuracoes.ENABLED .or. Main.menu_logsys.ENABLED

          Main.bttb_notificaoes.ENABLED := app:getUser('menu_lembretes', 'as logical')

return

procedure main_timer1()

          Main.Timer_1_main.ENABLED := false
          Main.Timer_2_main.ENABLED := ! Main.Timer_2_main.ENABLED

          if Main.Timer_2_main.ENABLED
             app:flashing := 0
          endif

          app:messages := select_count('notificacoes WHERE id_destinatario=' + app:getUser('id') + ' AND lido=0')

          if app:messages == 0
             Main.bttb_notificaoes.PICTURE := 'bttNotifications' + app:menuColor
             Main.bttb_notificaoes.CAPTION := '0 Notificações'
          else
            Main.bttb_notificaoes.PICTURE := 'bttNotificationsRed'
            Main.bttb_notificaoes.CAPTION := app:getMessages()
          endif

          Main.Timer_1_main.ENABLED := true

return

procedure main_timer2()

          Main.Timer_1_main.ENABLED := false
          Main.Timer_2_main.ENABLED := false

          if ! (app:messages == 0) .and. (++app:flashing < 200)
             if Main.bttb_notificaoes.PICTURE == 'bttNotifications' + app:menuColor .or. app:flashing >= 199
                Main.bttb_notificaoes.PICTURE := 'bttNotificationsRed'
             else
                Main.bttb_notificaoes.PICTURE := 'bttNotifications' + app:menuColor
             endif
             Main.bttb_notificaoes.CAPTION := app:getMessages()
          endif

          Main.Timer_1_main.ENABLED := true
          Main.Timer_2_main.ENABLED := true

return

procedure show_about()
          ShellAbout('SistromEDI',;
                     'SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA ' +;
                     app:version + hb_eol() + Chr(169) +;
                     ' by SISTROM SISTEMAS WEB, 2021 | supporte@sistrom.com.br',;
                     LoadTrayIcon(GetInstance(), 'MAIN'))
return

declare window calendar
procedure show_calendar()

          if isWIndowActive(calendar)
          	 calendar.MINIMIZE
          	 calendar.RESTORE
          	 calendar.SETFOCUS
          else
          	 load window calendar
          	 on key escape of calendar action calendar.RELEASE
          	 calendar.CENTER
          	 calendar.ACTIVATE
          endif

return

procedure calendar_form_on_init()
          calendar.ROW := 88
          calendar.COL := (app:WIDTH/2 - calendar.WIDTH/2) + 60
return
