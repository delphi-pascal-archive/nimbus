unit Message1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, cxLookAndFeelPainters, cxTextEdit, cxButtons,
  cxControls, cxContainer, cxEdit, cxMemo, cxRichEdit;

type
  TFMessage = class(TForm)
    cxRichEdit1: TcxRichEdit;
    cxRichEdit2: TcxRichEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Text_User: TcxTextEdit;
    Text_Date: TcxTextEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxRichEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
  test1 :string;
  UserId :Integer;
  UserChatID :Integer;
  UserChat :string;
  MsgDate :TDateTime;
  MsgId :integer;   //номер сообщения. Переменная устанваливается из внешнего модуля


    { Public declarations }
  end;

var
  FMessage: TFMessage;

implementation

uses DataModule, main;

{$R *.dfm}




procedure TFMessage.cxButton1Click(Sender: TObject);
begin   // Кнопка ЗАКРЫТЬ
 if MsgId >0  then begin
    DM.Query_Custom.SQL.Clear;    // пометим, что сообщение прочитано
    DM.Query_Custom.SQL.Add('update AMESSAGE set READ1 = 2 where id = :param');
    DM.Query_Custom.ParamByName('param').asInteger:=MsgId;
    DM.Query_Custom.Prepare;
    DM.IBTran_Write.StartTransaction;
    DM.Query_Custom.ExecSQL;
    DM.IBTran_Write.Commit;
 end;
Close;
end;

//Кнопка -Ответить:
procedure TFMessage.cxButton2Click(Sender: TObject);
var  Tmp: string; TextStream: TStringStream; i:Integer;
begin
 if DM.DBConnect = 0 then exit;
 if cxRichEdit1.Text = '' then exit;
 TextStream := TStringStream.Create('');
 cxRichEdit1.Lines.SaveToStream(TextStream);
 Tmp :=  TextStream.DataString;
 if UserChatID = 6000 then begin // Send to everyone Online
  Form1.IBQuery1.First;  //Посылаем всем вообщение
  for I := 0 to Form1.IBQuery1.RecordCount-1 do begin
   if Form1.IBQuery1.FieldByName('OnLine').AsInteger = 1 then begin
    DM.User_msg.ParamByName('FROM_IN').AsInteger:= UserId;
    DM.User_msg.ParamByName('TO_IN').AsInteger:=Form1.IBQuery1.FieldByName('ID').AsInteger ;
    DM.User_msg.ParamByName('COMMAND_IN').AsString:= 'message';
    DM.User_msg.ParamByName('TXT_IN').AsString:= '';
    DM.User_msg.ParamByName('BLOB1_IN').AsString:= Tmp;
    DM.IBTran_Write.StartTransaction;
    DM.User_msg.ExecProc;
    DM.IBTran_Write.Commit;
    DM.IB_Post.ParamByName('IN_EVENT').AsString:= DM.GetUserName1(Form1.IBQuery1.FieldByName('ID').AsInteger);
    DM.IBTran_Write.StartTransaction;
    DM.IB_Post.ExecProc;
    DM.IBTran_Write.Commit;
   end;
   Form1.IBQuery1.Next;
  end;
  TextStream.Free;
  Close;
  Exit;
 end;

 DM.User_msg.ParamByName('FROM_IN').AsInteger:= UserId;
 DM.User_msg.ParamByName('TO_IN').AsInteger:= UserChatID;
 DM.User_msg.ParamByName('COMMAND_IN').AsString:= 'message';
 DM.User_msg.ParamByName('TXT_IN').AsString:= '';
 DM.User_msg.ParamByName('BLOB1_IN').AsString:= Tmp;
 DM.IBTran_Write.StartTransaction;
 DM.User_msg.ExecProc;
 DM.IBTran_Write.Commit;
 DM.IB_Post.ParamByName('IN_EVENT').AsString:= DM.GetUserName1(UserChatID);
 DM.IBTran_Write.StartTransaction;
 DM.IB_Post.ExecProc;
 DM.IBTran_Write.Commit;
 TextStream.Free;
 if MsgId >0  then begin   //Если отвечаем , то вх.сообщеие помечаем как прочитано
    DM.Query_Custom.SQL.Clear;
    DM.Query_Custom.SQL.Add('update AMESSAGE set READ1 = 2 where id = :param');
    DM.Query_Custom.ParamByName('param').asInteger:=MsgId;
    DM.Query_Custom.Prepare;
    DM.IBTran_Write.StartTransaction;
    DM.Query_Custom.ExecSQL;
    DM.IBTran_Write.Commit;
 end;
 Close;
end;

procedure TFMessage.cxRichEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

{if (ssCtrl in Shift) and (key=VK_RETURN) then  //отправка сообщения по Ctrl+Enter
 begin
   cxButton2Click(Self);
   Key:=0;
end;}
if (ssCtrl in Shift) and (key=VK_RETURN) then begin  //перевод строки по Ctrl+Enter (как в icq)
   Key:=13;
   exit;
end;

if  (key=VK_RETURN) then begin //отправка сообщения по Enter
   cxButton2Click(Self);
   Key:=0;
end;

end;


procedure TFMessage.FormCreate(Sender: TObject);
begin
 DeleteMenu(GetSystemMenu(Handle, false),SC_CLOSE, MF_BYCOMMAND);
 LoadKeyboardLayout('00000419', KLF_ACTIVATE);    //переключаем раскладку на русский
end;

procedure TFMessage.FormShow(Sender: TObject);
begin
//FMessage.Caption:=inttostr(FMessage.MsgId);
//showmessage(FMessage.Label1.Caption);
end;

end.
