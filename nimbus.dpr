program nimbus;
//�������� ������ ���������� � 2009 ����, ����� ������ ���� ������������
// � ������� 2011

uses
  Forms,
  main in 'main.pas' {Form1},
  DataModule in 'DataModule.pas' {DM: TDataModule},
  Message1 in 'Message1.pas' {FMessage},
  About1 in 'About1.pas' {About};

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := TRUE;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm1, Form1);
  Application.ShowMainForm:=false; // �� ����� ����� ��� �������
  if DM.DB_nimbus.Connected then Application.Run;
{ Changelog
 15.03.2011 - v1.0
 20.03.2011 -  v1.1
    RDPSession() - ����������  ���������� ������
    ��������� ���������� �� �������� � �������
    ������������� ������, ������ ��������� ������ ���������
    ������������ ��������� ��������� � ����
    �������� ���� COMP
 04.04.2011  -v 1.3
    ���������� ���������� �� read � write.
    ���� ��������� �� *.bat  �� ����������� ���������� ��� �������� �����
    ������������ �� ������� ��� �������� ���������
    �������� �� Ctrl+Enter
 04.05.2011  v1.4
  ����� �������� ������� ��������� �������� ����� � ��� �� �������������



}
end.



