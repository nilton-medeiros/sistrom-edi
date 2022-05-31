/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: settings.prg
 Rotinas: Form de Configurações e Preferências do usuário
***********************************************************************************/

#include <hmg.ch>

declare window settings

procedure form_settings()

        if IsWIndowActive(settings)
            settings.MINIMIZE
            settings.RESTORE
            settings.SETFOCUS
        else
            load window settings
            on key escape of settings action settings.RELEASE
            settings.CENTER
            settings.ACTIVATE
        endif

return

procedure settings_Form_on_init()
          settings.radio_avatar.VALUE := app:avatar
          settings_radio_avatar_on_change()
          switch app:menucolor
              case 'Gray'
                settings.radio_icon_colors.VALUE := 1
                  exit
              case 'Pink'
                settings.radio_icon_colors.VALUE := 2
                  exit
              case 'Blue'
                settings.radio_icon_colors.VALUE := 3
                  exit
          endswitch
          settings_radio_icon_colors_on_change()
return

procedure settings_radio_avatar_on_change()
        if settings.radio_avatar.VALUE == 1
            settings.image_avatar.PICTURE := 'bttMan'
        else
            settings.image_avatar.PICTURE := 'bttWoman'
        endif
return

procedure settings_radio_icon_colors_on_change()
        local colors := {'Gray', 'Pink', 'Blue'}
        settings.image_icon1.PICTURE := 'bttRegistrations' + colors[settings.radio_icon_colors.VALUE]
        settings.image_icon2.PICTURE := 'bttSystem' + colors[settings.radio_icon_colors.VALUE]
        settings.image_icon3.PICTURE := 'mnuCompanies' + colors[settings.radio_icon_colors.VALUE]
return

procedure settings_button_aplicar_action()
        local color := {'Gray', 'Pink', 'Blue'}
        app:avatar := settings.radio_avatar.VALUE
        app:menuColor :=  color[settings.radio_icon_colors.VALUE]
        RegistryWrite(app:pathUser + 'avatar', app:avatar)
        RegistryWrite(app:pathUser + 'menuColor', app:menuColor)
        settings_icons_colors_form_Main()
        status_message('Configurações Aplicadas!')
        playOk()
        MessageBoxTimeout('As configurações terão efeito na próxima entrada', 'Configurações Aplicadas', MB_ICONINFORMATION, 10000)
return

declare window Main
procedure settings_icons_colors_form_Main()
        // Definir a cor dos ícones do menu do usuário
        SetProperty('Main', 'bttb_edi', 'PICTURE', 'bttEDI' + app:menuColor)
        SetProperty('Main', 'bttb_ftp', 'PICTURE', 'bttFTP' + app:menuColor)
        SetProperty('Main', 'bttb_cadastros', 'PICTURE', 'bttRegistrations' + app:menuColor)
        SetProperty('Main', 'bttb_sistema', 'PICTURE', 'bttSystem' + app:menuColor)
        SetProperty('Main', 'bttb_calendar', 'PICTURE', 'bttCalendar' + app:menuColor)
        SetProperty('Main', 'bttb_notificaoes', 'PICTURE', 'bttNotifications' + app:menuColor)
        SetProperty('Main', 'bttb_senha', 'PICTURE', iif(app:avatar == 1, 'bttMan', 'bttWoman'))
return
