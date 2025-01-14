unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.FileCtrl, Vcl.ComCtrls, ShlObj, ActiveX , ComObj,
  Registry, IniFiles, System.Zip, WinInet, Vcl.Mask, Vcl.Printers;

type

  TForm1 = class(TForm)
    Button1: TButton;
    chkTSprint: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    chkPainel: TCheckBox;
    txtUser: TMaskEdit;
    txtRemota: TEdit;
    txtEquip: TEdit;
    txtPainel: TEdit;
    procedure Button1Click(Sender: TObject);

  private
    function criptografar(texto:string):string;

  public
  end;

var
  Form1: TForm1;
  directory, tsprintDirectory, projectName, shellStartup: string;
  cripto: array[0..9] of string;
  zipFile : TZipFile;
  F, arq: TextFile;

implementation

{$R *.dfm}

function GetDefaultPrinterName: string;
begin
  if (Printer.PrinterIndex >= 0) then
  begin
    Result := Printer.Printers[Printer.PrinterIndex];
  end
  else
  begin
    Result := 'Nenhuma impressora padr�o foi detectada.';
  end;
end;

function DesktopDir: string;
var
  DesktopPidl: PItemIDList;
  DesktopPath: array [0..MAX_PATH] of Char;

begin

  SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, DesktopPidl);
  SHGetPathFromIDList(DesktopPidl, DesktopPath);
  Result := IncludeTrailingPathDelimiter(DesktopPath);

end;

function DownloadArquivo(const Origem, Destino: String): Boolean;
const BufferSize = 1024;

var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: File;
  sAppName: string;

begin

 sAppName := ExtractFileName(Application.ExeName);
 hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

 try

  hURL := InternetOpenURL(hSession, PChar(Origem), nil,0,0,0);

  try

   AssignFile(f, Destino);
   Rewrite(f,1);

   repeat
    InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
    BlockWrite(f, Buffer, BufferLen)
   until BufferLen = 0;

   CloseFile(f);
   Result:=True;

  finally
   InternetCloseHandle(hURL)
  end

 finally
  InternetCloseHandle(hSession)
 end

end;

procedure CriarAtalhoDaNet(const NomeDoArquivo, URL : string);
begin

if NomeDoArquivo = 'Unilab' then
begin

  with TIniFile.Create(directory + NomeDoArquivo + '.url') do
  try
    //Escrevendo a URL do Atalho
    WriteString('InternetShortcut','URL',URL);

    //Extraindo �cone de um Execut�vel, neste caso do EXE do Internet Explorer
    WriteString('InternetShortcut','IconFile','C:\Delphi\instaladorSonda\Win32\Debug\unilab.ico');

    //Colocando o �ndice do �cone, porque o executavel possui mais de um �cone
    WriteString('InternetShortcut','IconIndex','9');

  finally
    Free;
  end;
end

else
begin

  with TIniFile.Create(DesktopDir + NomeDoArquivo + '.url') do
  try
    //Escrevendo a URL do Atalho
    WriteString('InternetShortcut','URL',URL);

    //Extraindo �cone de um Execut�vel, neste caso do EXE do Internet Explorer
    WriteString('InternetShortcut','IconFile','C:\Delphi\instaladorSonda\Win32\Debug\unilab.ico');

    //Colocando o �ndice do �cone, porque o executavel possui mais de um �cone
    WriteString('InternetShortcut','IconIndex','9');

  finally
  Free;
  end;
  end;
end;

procedure CreateShortcut (FileName, InitialDir, ShortcutName, ShortcutFolder : String; Parameters: PWideChar);

var
  MyObject : IUnknown;
  MySLink : IShellLink;
  MyPFile : IPersistFile;
  Directory : String;
  WFileName : WideString;
  MyReg : TRegIniFile;

  //Diret�rio ShellStartup
  shellStartup: string;
  nsize: Cardinal;
  UserName: string;

  begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;

  //Diret�rio ShellStartup
  nsize := 25;
  SetLength(UserName,nsize);
  GetUserName(PChar(UserName), nsize);
  SetLength(UserName,nsize-1);

  shellStartup := 'C:\Users\'+ UserName + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup';

    with MySLink do
    begin
    SetArguments(Parameters);
    SetPath(PChar(FileName));
    SetWorkingDirectory(PChar(InitialDir));
    end;

  if ShortcutName = 'Senha Unilab' then
  begin
    MyReg := TRegIniFile.Create('Software\\MicroSoft\\Windows\\CurrentVersion\\Explorer');
    Directory := MyReg.ReadString ('Shell Folders','Desktop','');
    WFileName := Directory + '\' + ShortcutName + '.lnk';
    MyPFile.Save (PWChar (WFileName), False);
    MyReg.Free;
  end

  else
  begin


  MyReg := TRegIniFile.Create('Software\\MicroSoft\\Windows\\CurrentVersion\\Explorer');
  Directory := MyReg.ReadString ('Shell Folders','Desktop','');
  WFileName := Directory + '\' + ShortcutName + '.lnk';
  MyPFile.Save (PWChar (WFileName), False);
  MyReg.Free;

  with MySLink do
    begin
    SetArguments(Parameters);
    SetPath(PChar(FileName));
    SetWorkingDirectory(PChar(InitialDir));
    end;

  MyReg := TRegIniFile.Create('Software\\MicroSoft\\Windows\\CurrentVersion\\Explorer');
  Directory := MyReg.ReadString ('Shell Folders','Desktop','');
  WFileName := shellStartup + '\' + ShortcutName + '.lnk';
  MyPFile.Save (PWChar (WFileName), False);
  MyReg.Free;
  end;
  end;

function Tform1.criptografar(texto:string):string;
var
retorno, letra: string;
I, x, y: Integer;
cripto2: array[0..9]of string;
begin
    cripto2[0]:='36';
    cripto2[1]:='6D';
    cripto2[2]:='6E';
    cripto2[3]:='6F';
    cripto2[4]:='70';
    cripto2[5]:='71';
    cripto2[6]:='72';
    cripto2[7]:='73';
    cripto2[8]:='74';
    cripto2[9]:='35';
   for I := 0 to 9 do
    begin
       cripto[I] := IntToStr(I);
    end;

    for x := 1 To 5 do
    begin
       letra:= Copy(texto,x,1);
       for y := 0 to 9 do
       begin
         if letra = cripto[y] then
         begin
            retorno := retorno + cripto2[y];
         end;
       end;
       result:= retorno+'494949';
    end;

end;

procedure TForm1.Button1Click(Sender: TObject);

var
user, userADM, userAdv, EqTsPort, PainelPort, RemotePort, versaoTSprint, versaoTXT, Destino, confTsprint,
URLacesso, criptografia, TSprint, destinoZIP, URLPainel, confImpressora :string;

begin

    projectName := ExtractFileName (Application.ExeName);
    directory := ExtractFilePath (Application.ExeName);
    user := txtUser.Text;
    criptografia:= criptografar(user);
    EqTsPort := txtEquip.Text;
    PainelPort := txtPainel.Text;
    RemotePort := txtRemota.Text;
    userADM := (Copy(txtUser.Text, 1, 5));
    userAdv := (Copy(txtUser.Text, 6, (Length(Trim(user))) - 5));
    URLacesso := 'http://' + userADM + '.unilab.app.br:' + RemotePort + '/';
    URLPainel := 'http://' + userADM + '-web.unilab.app.br:' + PainelPort + '/?' + userADM;

    if (user = '') or (RemotePort = '') then
    begin
      ShowMessage('� necess�rio preencher o usu�rio e a porta remota para a instala��o');
//      ShowMessage(GetDefaultPrinterName);
//      confImpressora := '[{"ID":1,"FOLDER":"root","PRINTERNAME":"' + GetDefaultPrinterName + '","DOWNLOAD":"Sim","PRINT":"Sim"},{"ID":2,"FOLDER":"pdf","PRINTERNAME":"' + GetDefaultPrinterName + '","DOWNLOAD":"Sim","PRINT":"N\u00E3o"}]';
//                  AssignFile(F, directory + 'print_doc_cnf.data');
//                  Rewrite(F);
//                  Writeln(F,confImpressora);
//                  CloseFile(F);


      Abort;
    end

    else
    begin

      if (chkTSprint.Checked = true) and (EqTsPort <> '') then
      begin

        zipFile := TZipFile.create;
        createDir(directory + 'TSprint');
        tsprintDirectory := directory + 'TSprint\';
        versaoTXT := 'https://uniware.com.br/updates/tsprint/versao.txt';
        Destino := tsprintDirectory + 'versao.txt';
        destinoZIP := tsprintDirectory + 'TSprint.zip';

        DownloadArquivo(versaoTXT, Destino);

        AssignFile(arq,tsprintDirectory + 'versao.txt');
        Reset(arq);
        Readln(arq, versaoTSprint);
        closeFile(arq);
        DeleteFile(tsprintDirectory + 'versao.txt');

        TSprint := 'https://uniware.com.br/updates/tsprint/tsprint_v' + versaoTSprint + '.zip';
        DownloadArquivo(TSprint, destinoZIP);

        zipFile.Open(tsprintDirectory + 'TSprint.zip', zmRead);
        zipFile.ExtractAll(tsprintDirectory);
        zipFile.Close;

        createDir(tsprintDirectory + 'conf');
                  confTsprint:='{"servidor":1,"maxthreads":20,"url":"http:\/\/'+ userADM +'-web.unilab.app.br\/tsprint","codigo_adm":"'+ userADM +'","rdp_user":"' + user + '","porta":'+ EqTsPort + ',"intervalo":2,"token":"'+ criptografia +'","MainApp":"TSPrint","FingerPrint":0}' ;
                  AssignFile(F,tsprintDirectory + 'conf\geral_cnf.data');
                  Rewrite(F);
                  Writeln(F,confTsprint);
                  CloseFile(F);


//                  confImpressora := '[{"ID":1,"FOLDER":"root","PRINTERNAME":"' + GetDefaultPrinterName + '","DOWNLOAD":"Sim","PRINT":"Sim"},{"ID":2,"FOLDER":"pdf","PRINTERNAME":"' + GetDefaultPrinterName + '","DOWNLOAD":"Sim","PRINT":"N\u00E3o"}]';
//                  AssignFile(F,tsprintDirectory + 'conf\print_doc_cnf.data');
//                  Rewrite(F);
//                  Writeln(F,confImpressora);
//                  CloseFile(F);

        createShortcut(tsprintDirectory + 'TSprint.Exe', tsprintDirectory, 'Servidor de Impress�o', tsprintDirectory + 'TSprint.Exe', 'a');
        DeleteFile(tsprintDirectory + 'TSprint.zip');

      end
      else if(chkTSprint.Checked = true) and (EqTsPort = '') then
      begin
        ShowMessage('Informe a porta do TSprint para a configura��o');
        Abort;
      end;

      if (chkPainel.Checked = true) and (PainelPort <> '') then
      begin
        AssignFile(arq,directory + '\' +'Link.txt');
        Rewrite(arq);
        Writeln(arq,'http://' + userADM + '.unilab.app.br:' + RemotePort + '/');
        Writeln(arq,'http://' + userADM + '-web.unilab.app.br/tsprint');
        Writeln(arq,'http://' + userADM + '-web.unilab.app.br:' + EqTsPort +'/'+ userADM +'-uniequip/');
        Writeln(arq,'http://' + userADM + '-web.unilab.app.br:' + PainelPort + '/?' + userADM);
        CriarAtalhoDaNet('Painel de senha', URLPainel);
      end
      else if(chkPainel.Checked = true) and (PainelPort = '') then
      begin
        ShowMessage('Informe a porta do painel para o acesso');
          Abort;
      end
       else if PainelPort <> '' then
      begin
        AssignFile(arq,directory + '\' +'Link.txt');
        Rewrite(arq);
        Writeln(arq,'http://' + userADM + '.unilab.app.br:' + RemotePort + '/');
        Writeln(arq,'http://' + userADM + '-web.unilab.app.br/tsprint');
        Writeln(arq,'http://' + userADM + '-web.unilab.app.br:' + EqTsPort +'/'+ userADM +'-uniequip/');
        Writeln(arq,'http://' + userADM + '-web.unilab.app.br:' + PainelPort + '/?' + userADM);
        CloseFile(arq);
      end
      else
      begin
        AssignFile(arq,directory + '\' +'Link.txt');
        Rewrite(arq);
        Writeln(arq,'http://' + userADM + '.unilab.app.br:' + RemotePort + '/');
        Writeln(arq,'http://' + userADM + '-web.unilab.app.br/tsprint');
        Writeln(arq,'http://' + userADM + '-web.unilab.app.br:' + EqTsPort +'/'+ userADM +'-uniequip/');
      end;

      AssignFile(arq,directory + '\' +'Senha Unilab.txt');
      Rewrite(arq);
      Writeln(arq,'@'+user);
      CloseFile(arq);

      CriarAtalhoDaNet('Unilab', URLacesso);
      CriarAtalhoDaNet('Unilab ' + userAdv, URLacesso);

      createShortcut(directory + 'Senha Unilab.txt', directory, 'Senha Unilab', directory + 'Senha Unilab.txt', '');
      SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);

      ShowMessage('Instalado com Sucesso');

      AssignFile(arq, directory + 'selfdelete.bat');
      ReWrite(arq);
      WriteLn(arq, '@echo off');
      Writeln(arq, '@ping localhost -n 1>NUL');
      Writeln(arq, 'taskkill /F /IM '+ ExtractFileName(application.exename));
      Writeln(arq, 'del /s /q "'+Application.Exename+'"');
      Writeln(arq, 'del /s /q "%~f0"');
      CloseFile(arq);
      WinExec(PAnsiChar(AnsiString(directory + 'selfdelete.bat')), 0);
      DeleteFile(directory + 'TSprint.zip');
//      DeleteFile(directory + 'Unilab.zip');



      Application.Terminate;
    end;
end;
end.
