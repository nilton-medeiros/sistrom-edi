/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 06-Dez-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: class_ged_ftp.prg
 Classe : TGedFTP - Classe Gerenciador Eletronico de Documenttos via FTP
***********************************************************************************/


#include <hmg.ch>
#include "hbclass.ch"

// GED - Gerenciador Eletrônico de Documentos - via FTP


class TGedFTP
   data hostFile PROTECTED
   data remotePath PROTECTED
   data remoteFile PROTECTED
   data ftp_url PROTECTED
   data ftp_server PROTECTED
   data ftp_userId PROTECTED
   data ftp_password PROTECTED
   data isUpload READONLY

   method new(host_file, remote_path, ftp_credential) constructor
   method upload()

end class

method new(host_file, remote_path, ftp_credential) class TGedFTP
   ::hostFile := host_file
   ::remotePath := remote_path
   ::remoteFile := token(host_file, '\') // Igual a SubStr(host_file, Rat('\', host_file)+1)
   ::ftp_server := ftp_credential['server']
   ::ftp_userId := ftp_credential['userId']
   ::ftp_password := ftp_credential['password']
   ::ftp_url := 'ftp://' + ::ftp_userId + ':' + ::ftp_password + '@' + ::ftp_server
   ::isUpload := false
return self

method upload() class TGedFTP
   local url, ftp, error := 'UPLOAD - Erro de FTP: '

   saveLog('Iniciando upload de arquivo: ' + ::hostFile)

   ::isUpload := false

   if hb_FileExists(::hostFile)
      url := TUrl():new(::ftp_url)
      ftp := TIPClientFTP():new(url)
      ftp:nConnTimeout := 20000
      ftp:bUsePasv := true
      ftp:oURL:cServer := ::ftp_server
      ftp:oURL:cUserID := ::ftp_userId
      ftp:oURL:cPassword := ::ftp_password
      if ftp:open()
         url:cPath := ::remotePath
         if ftp:cwd(url:cPath)
            if ftp:UploadFile(::hostFile)
               ::isUpload := true
               saveLog('Upload de arquivo concluído com sucesso')
            else
               saveLog('Falha no upload de arquivo: ' + hb_eol() + 'host file: ' + ::hostFile + hb_eol() + 'remote file: ' + ::remoteFile)
            endif
         else
            saveLog('Não foi possível mudar o diretório no servidor: ' + url:cPath)
         endif
         ftp:close()
      else
         if (ftp:socketCon == Nil)
            error += 'Conexão não iniciada'
         elseif (hb_inetErrorCode(ftp:socketCon) == 0)
            error += 'Resposta do servidor: ' + ftp:cReply
         else
            error += hb_inetErrorDesc(ftp:socketCon)
         endif
         saveLog(error + hb_eol() + 'ftp_url: ' + ::ftp_url + hb_eol() + 'host file: ' + ::hostFile + hb_eol() + 'remote file: ' + ::remoteFile)
      endif
   else
      saveLog('Upload falhou! Arquivo não encontrado: ' + ::hostFile)
   endif

return ::isUpload
