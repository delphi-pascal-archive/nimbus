unit main;

interface

uses
  Windows, Messages,  Variants,Dialogs, Classes, Graphics, Controls,Forms,SysUtils, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, Menus, cxLookAndFeelPainters, ExtCtrls, IBCustomDataSet,
  IBQuery, StdCtrls, cxButtons, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView,
   cxGrid;

type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    IBQuery1: TIBQuery;
    gUserTable: TcxGridDBTableView;
    gUserLevel1: TcxGridLevel;
    gUserTableID: TcxGridDBColumn;
    gUserTableUSERNAME: TcxGridDBColumn;
    gUserTablePINGTIME: TcxGridDBColumn;
    gUser: TcxGrid;   
    cxStyleRepository1: TcxStyleRepository;
    cxStyleOnline: TcxStyle;
    gUserTableOnLine: TcxGridDBColumn;
    TrayIcon1: TTrayIcon;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    About1: TMenuItem;
    cxButtonSend: TcxButton;
    gUserTableAWAY: TcxGridDBColumn;
    SysMenu1: TMenuItem;
    SendEveryOne1: TMenuItem;
    procedure gUserTableUSERNAMEStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure TrayIcon1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure cxButtonSendClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SendEveryOne1Click(Sender: TObject);
  private
    { Private declarations }
    procedure WMSysCommand(var Msg: TWMSysCommand);
    message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses About1, Message1, DataModule;

{$R *.dfm}
procedure msg( a: Variant ) ;  //Упрощённый вывод тестового сообщения
Begin
 ShowMessage(a);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
Application.CreateForm(TAbout, About);
try
 About.ShowModal;
finally
 About.Free;
end;
end;







procedure TForm1.cxButtonSendClick(Sender: TObject);
begin

 //   showmessage( DM.GetUserFromWindows());
//   showmessage(Application.ExeName);
//DM.IB_Post.ParamByName('IN_EVENT').AsString:='ldir';
 //DM.IB_Post.ExecProc;
 //DM.IBTran.CommitRetaining;
//Application.MessageBox('1','Ты ввёл:', MB_OKCANCEL) ;

 FMessage:=TFMessage.Create(Application);
 FMessage.UserId:=DM.UserId;
 FMessage.UserChatID:=gUserTable.DataController.Values[gUserTable.DataController.FocusedRecordIndex, 0];
 FMessage.Text_User.Text:= DM.GetUserName1(FMessage.UserChatID);
 FMessage.Text_Date.Text:='';
 FMessage.MsgId:=0;
 FMessage.Show;

//FMessage.Label1.Caption :='input';
//FMessage.ShowModal;
//showmessage(gUserTable.DataController.Values[gUserTable.DataController.FocusedRecordIndex, 0] );
//Showmessage(FMessage.Caption);
end;

procedure TForm1.WMSysCommand;
begin //убираем в трей
if (Msg.CmdType = SC_MINIMIZE) or (Msg.CmdType = SC_CLOSE) then begin
  form1.Visible:=false ;
 end
else
  inherited;
end;





procedure TForm1.FormCreate(Sender: TObject);
begin
 Form1.IBQuery1.Active:=True;
 Form1.Caption:='Nimbus.'+DM.UserName+':'+inttostr(DM.UserId);
 Form1.TrayIcon1.Hint:=caption;
 SysMenu1.Enabled:=False;  //Системное меню
 if (DM.FAdmin=1) or (DM.FAway=1) then begin  // Покажем поле Away
   Form1.Width:=Form1.Width+60;
   gUser.Width:=gUser.Width+60;
   gUserTableAWAY.Visible:=True;
  end;
 if (DM.FAdmin=1) then
  SysMenu1.Enabled:=True;  //Системное меню
 DM.CheckMsg(2);// откроем новые и непрочитанные
end;


procedure TForm1.gUserTableUSERNAMEStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin  //Выделяем цевтом Online пользователей по невидимому полю Online
 if ARecord.Values[1] Then
   AStyle := cxStyleOnline;

end;

procedure TForm1.N1Click(Sender: TObject);  //Меню Выход
begin
 if Application.MessageBox('Завершить работу?','Nimbus', MB_YESNO) = IDYES then  begin
 DM.DB_nimbus.Close;
 Form1.Close;
 end;
end;

procedure TForm1.SendEveryOne1Click(Sender: TObject);
begin
 FMessage:=TFMessage.Create(Application);
 FMessage.UserId:=DM.UserId;
 FMessage.UserChatID:=6000; //code for everyone online
 FMessage.Text_User.Text:= 'EveryOne Online';
 FMessage.Text_Date.Text:='';
 FMessage.MsgId:=0;
 FMessage.Show;

end;




procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
 form1.Visible:=true;
 SetForeGroundWindow(Application.MainForm.Handle); //Показываем принудительно
 SetActiveWindow(Application.MainForm.Handle); //Показываем принудительно
end;


end.


