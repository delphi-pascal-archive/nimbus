unit About1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMemo, cxRichEdit ;

type
  TAbout = class(TForm)
    cxRichEdit1: TcxRichEdit;
    cxButton1: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  About: TAbout;

implementation

{$R *.dfm}





procedure TAbout.cxButton1Click(Sender: TObject);
begin

Close;
end;

//Загрузка текста - О программе из файла
procedure TAbout.FormCreate(Sender: TObject);
var i,b:integer;
var a:String;
begin
b:=0;
for i := 0 to Length(Application.ExeName) - 1 do
if Application.ExeName[i] ='\' then
 b:=i;
a:=copy (Application.ExeName,0, Length(Application.ExeName)-(Length(Application.ExeName)-b));
cxrichEdit1.Lines.LoadFromFile(a+'about.rtf' );
end;

end.
