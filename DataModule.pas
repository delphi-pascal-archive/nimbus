unit DataModule;

interface

uses
  Dialogs, Windows,Messages,SysUtils,Forms, Classes, DB, IBCustomDataSet,
  IBStoredProc, IBDatabase, IBEvents,  ExtCtrls, IniFiles, IBDatabaseINI,
  IBQuery, JwaWinType,  JwaWtsApi32;
// JwaWinType,  JwaWtsApi32 - для чтения RDP, файлы из каталога Jedi , каталог подключается в свойствах проекта
type
  TDM = class(TDataModule)
    DB_nimbus: TIBDatabase;
    IBEvents1: TIBEvents;
    IBTran: TIBTransaction;
    OnlineTimer: TTimer;
    IB_Post: TIBStoredProc;
    User_Reg: TIBStoredProc;
    Query_UserID: TIBQuery;
    Query_UserIDID: TIntegerField;
    Query_ReadMSG: TIBQuery;
    IntegerField1: TIntegerField;
    Query_ReadMSGCOMMAND: TIBStringField;
    Query_ReadMSGDNOW: TDateTimeField;
    Query_ReadMSGFROM1: TIntegerField;
    Query_ReadMSGTO1: TIntegerField;
    Query_ReadMSGTXT: TIBStringField;
    Query_ReadMSGBLOB1: TMemoField;
    Query_UserName: TIBQuery;
    Query_UserNameUSERNAME: TIBStringField;
    User_msg: TIBStoredProc;
    Query_Custom: TIBQuery;
    IntegerField2: TIntegerField;
    IBStringField1: TIBStringField;
    DateTimeField1: TDateTimeField;
    IntegerField3: TIntegerField;
    IntegerField4: TIntegerField;
    IBStringField2: TIBStringField;
    MemoField1: TMemoField;
    Query_ReadMSGREAD1: TSmallintField;
    DBConnectTimer: TTimer;
    IBTran_Write: TIBTransaction;
    User_ping: TIBStoredProc;

    procedure IBEvents1EventAlert(Sender: TObject; EventName: string;
      EventCount: Integer; var CancelAlerts: Boolean);
    procedure DataModuleCreate(Sender: TObject);
     procedure OnlineTimerTimer(Sender: TObject);
    procedure DBConnectTimerTimer(Sender: TObject);

  private

    { Private declarations }
  public
  var ini: TIniFile;
  var UserName :string;
  var UserId :Integer;
  var DBConnect: Integer ;   //Флаг коннекта к базе
  Var FAdmin: Integer; // Флаг админа
  Var FAway: Integer; //Флаг показывать поле away
  

  Function GetUserFromWindows :string;
  Function GetUserID(Username:string) :Integer;
  Function GetUserName1(UserId:integer) :String;
  Function CheckMsg(Read1:Integer) :Integer;
    { Public declarations }

  end;

var
  DM: TDM;

implementation

uses main, Message1;

{$R *.dfm}

procedure msg( a: Variant ) ;
Begin
 ShowMessage(a);
end;
// Взять значение из коммандной стоки
function getCmdParam(aparam: String; aprefix: array of String): String;
var
  i,j: Integer;
  f  : Boolean;
  s  : String;
begin
 Result:=''; f:=false;
 for i:=1 to ParamCount do begin
  for j:=low(aprefix) to high(aprefix) do begin
   s:=LowerCase(aprefix[j]+aparam);
   if LowerCase(Copy(ParamStr(i),1,length(s)))=s then  begin
    Result:=Copy(ParamStr(i),length(s)+1, length(ParamStr(i)));
   end;
   if f then Break;
  end;
  if f then Break;
 end;
end;

function SecondsIdle: DWord;   //Простой в секундах
var
   liInfo: TLastInputInfo;
begin
   Result := 0;
   liInfo.cbSize := SizeOf(TLastInputInfo) ;
   if GetLastInputInfo(liInfo) =True then
   Result := (GetTickCount - liInfo.dwTime) DIV 1000;
end;

function SecToTime(Sec: Integer): Double;        // Перевод секунд в часы
var
   ZH, ZM, ZS: Integer;
begin
   Result := EncodeTime(23, 59, 59, 0);
   if (Sec div 86400) = 0  then begin    //  дни не учитываем
    ZH := Sec div 3600;
    ZM := Sec div 60 - ZH * 60;
    ZS := Sec - (ZH * 3600 + ZM * 60) ;
    Result := EncodeTime(ZH, ZM, ZS, 0);
   end;
end;
function RDPSession(): Integer; //запрашивает активность  RDP сессии
var RetBytes         : Cardinal;
    pData :LPTSTR  ;
begin
    Result := 0;
    if WTSQuerySessionInformation(WTS_CURRENT_SERVER_HANDLE , WTS_CURRENT_SESSION, WTSConnectState,Pointer( pData), RetBytes) = True then
     if Integer(pData^) =0  then Result := 1;  // 0 - Активна , 4 - disconect
end;
function CompName: string; //получаем имя компьютера
var
 i:dword;
 p:pchar;
begin
 i:=255;
 getmem(p, i);
 getcomputername(p, i);
 result:=string(p);
 freemem(p);
end;



procedure TDM.DataModuleCreate(Sender: TObject);
begin

 DBConnect:=0;
 FAdmin:=0;
  FAway:=0;
 if FindCmdLineSwitch('away', ['/', '\', '-'], True) then FAway:=1;
 if FindCmdLineSwitch('admin', ['/', '\', '-'], True) then FAdmin:=1;

 DM.Username := DM.GetUserFromWindows() ;
 // Добавим постоянных админов
 if (DM.UserName='admin')or(DM.UserName='ldir')or(DM.UserName='ksa')or(DM.UserName='dav')
  then FAdmin:=1;
 DM.User_Reg.ParamByName('AWAY1').AsTime:=  SecToTime(SecondsIdle());
 DM.User_Reg.ParamByName('USER1').AsString:=  DM.Username;
 DM.User_Reg.ParamByName('COMP1').AsString:=  CompName();
 Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
 DM.DB_nimbus.close;
 DM.DB_nimbus.DatabaseName :=Ini.ReadString( 'Main', 'Database','nimbus');
 try
  DM.DB_nimbus.open;
  DM.IBEvents1.Events.Clear;
  DM.IBEvents1.Events.Add(DM.Username);
  DM.IBEvents1.RegisterEvents;
  DM.IBTran_Write.StartTransaction;
  DM.User_Reg.ExecProc;  //Регистриуем или обновляем пользователя
  DM.IBTran_Write.Commit;

  DM.UserId:=DM.GetUserID(DM.UserName);
  DM.User_Ping.ParamByName('USER1').AsInteger:=DM.UserId;
  OnlineTimer.Enabled:=True;   // запускаем обновляет статуса online
  DBConnectTimer.Enabled:=True; //запускаем проверки всязи

 finally
  Ini.Free;
  if DM.DB_nimbus.Connected = false then
  begin
   msg ('Не удалось подключиться к базе данных') ;
   Application.Terminate;
  end;
  DBConnect:=1;
 end;

end;



procedure TDM.DBConnectTimerTimer(Sender: TObject);
begin
 if DBConnect = 0 then begin
  try
   DM.DB_nimbus.open;
  except
  // обрабатываем ошибку соединения.. хотя и так всё ясно
  end;
   if DM.DB_nimbus.Connected = True then begin
    DM.IBEvents1.Events.Clear;
    DM.IBEvents1.Events.Add(DM.Username);
    DM.IBEvents1.RegisterEvents;
    DBConnect := 1;
    MessageBox(0, 'Связь восстановлена', 'Nimbus', MB_OK+MB_SYSTEMMODAL);
   end;
  end;
end;


function TDM.GetUserFromWindows: string;     // Получаем имя пользователя
Var
  UserName    : string;
  UserNameLen : Dword;
Begin
 UserNameLen := 10;
 UserName :=getCmdParam('user=', ['-','\','/']);
 if (UserName <> '') then  begin   // user задан в командной строке
  if (length(UserName)>10) then SetLength(UserName, UserNameLen);
  Result:=UserName;
  end
 else begin
  //Возмем имя пользователя из Windows
  SetLength(userName, UserNameLen);
  If GetUserName(PChar(UserName), UserNameLen) Then
    Result := Copy(UserName,1,UserNameLen - 1)
  Else   Result := 'Unknown';
 end;
 Result:=AnsiLowerCase(Result);
 
end;

function TDM.GetUserID(Username:string): integer;
Begin
  Result:=0;
  Query_UserID.close;
  Query_UserId.ParamByName('username_in').asString:=UserName;
  Query_UserID.open;
  if Query_UserId.RecordCount >0 Then Result := Query_UserID.Fields[0].AsInteger;
  Query_UserID.close;
end;
function TDM.GetUserName1(UserID:Integer): String;
Begin
  Result:='';
  Query_UserName.close;
  Query_UserName.ParamByName('id_in').asInteger:=UserID;
  Query_UserName.open;
  if Query_UserName.RecordCount >0 Then Result := Query_UserName.Fields[0].AsString;
  Query_UserName.close;
end;

procedure TDM.IBEvents1EventAlert(Sender: TObject; EventName: string;
  EventCount: Integer; var CancelAlerts: Boolean);
begin  // Обрабатываем Alert
 DM.CheckMSG(1);
end;

function TDM.CheckMsg(Read1:integer): Integer;
var i:Integer;
Begin
  DM.Query_ReadMSG.close;
  DM.Query_ReadMSG.ParamByName('to1_in').asInteger:=DM.UserID;
  DM.Query_ReadMSG.ParamByName('read1_in').asInteger:=Read1;
  DM.Query_ReadMSG.open;
  DM.Query_ReadMSG.FetchAll;
  for I := 0 to DM.Query_ReadMSG.RecordCount-1  do
  begin                                    ;
   if DM.Query_ReadMSG.FieldByName('COMMAND').AsString = 'message' then
   begin // Принимаем сообщение
    FMessage:=TFMessage.Create(Application);
    FMessage.UserId:=DM.UserId;
    FMessage.UserChatID:=DM.Query_ReadMSG.FieldByName('FROM1').AsInteger;
    FMessage.Text_Date.Text:=FormatDateTime('DD/MM/YYYY HH:NN',DM.Query_ReadMSG.FieldByName('DNOW').AsDateTime);
    FMessage.Text_User.Text:= DM.GetUserName1(DM.Query_ReadMSG.FieldByName('FROM1').AsInteger);
    FMessage.cxRichEdit2.Lines.Text:= DM.Query_ReadMSG.FieldByName('BLOB1').AsString;
    FMessage.MsgId:=DM.Query_ReadMSG.FieldByName('ID').AsInteger;
    FMessage.Show;
    DM.Query_Custom.SQL.Clear;    // пометим, что сообщение получено
    DM.Query_Custom.SQL.Add('update AMESSAGE set READ1 = 1 where id = :param');
    DM.Query_Custom.ParamByName('param').asInteger:=DM.Query_ReadMSG.FieldByName('ID').AsInteger;
    DM.Query_Custom.Prepare;
    DM.IBTran_Write.StartTransaction;
    DM.Query_Custom.ExecSQL;
    DM.IBTran_Write.Commit;
   end;
   DM.Query_ReadMSG.Next;
  end;
  DM.Query_ReadMSG.close;
  result:=0;
end;


procedure TDM.OnlineTimerTimer(Sender: TObject);
var a:integer;
begin
if RDPSession() = 0 then exit; //сессия не активна
if DBConnect =1 then begin
 if DM.DB_nimbus.TestConnected()= False Then begin
  DBConnect:=0;
  DM.DB_nimbus.close;    MessageBox(0, 'Связь прервана', 'Nimbus', MB_OK+MB_SYSTEMMODAL); exit;
 end;
 DM.User_Ping.ParamByName('AWAY1').AsTime:=  SecToTime(SecondsIdle());
 DM.IBTran_Write.StartTransaction;
 DM.User_Ping.ExecProc;
 DM.IBTran_Write.Commit;
  //Обновляем записи  без потери курсора
 a:=Form1.gUserTable.DataController.FocusedRecordIndex;
 Form1.ibquery1.Active:=False;
 Form1.ibquery1.Active:=True;
 Form1.gUserTable.DataController.FocusedRecordIndex :=a;
 DM.CheckMSG(1);  // проверим новые сообщения
end;
end;


end.
