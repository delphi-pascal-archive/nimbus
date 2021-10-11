program nimbus;
//Програма начала готовиться в 2009 году, потом работы были возобновлены
// в феврале 2011

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
  Application.ShowMainForm:=false; // не видно окана при запуске
  if DM.DB_nimbus.Connected then Application.Run;
{ Changelog
 15.03.2011 - v1.0
 20.03.2011 -  v1.1
    RDPSession() - оперделаят  активность сессии
    Разделена транзакция на читающуу и пушущую
    Подтверждение выхода, нельзя отправить пустое сообщение
    Подтвержение прочтения сообщения в базу
    Добавлен поле COMP
 04.04.2011  -v 1.3
    Разделение транзакции на read и write.
    Если запускать из *.bat  не закрывается соединении при закрытии проги
    Переключение на русский при отправке сообщения
    Отправка по Ctrl+Enter
 04.05.2011  v1.4
  Убрал контроль запуска программы повторно одним и тем же пользователем



}
end.



