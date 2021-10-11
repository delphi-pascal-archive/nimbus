object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 204
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 288
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object nimbus: TIBDatabase
    Connected = True
    DatabaseName = 'localhost:C:\Firebird\NIMBUS.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    Left = 104
    Top = 72
  end
  object IBEvents1: TIBEvents
    AutoRegister = True
    Database = nimbus
    Events.Strings = (
      'post1')
    Registered = False
    OnEventAlert = IBEvents1EventAlert
    Left = 272
    Top = 72
  end
  object IBTransaction1: TIBTransaction
    Active = True
    DefaultDatabase = nimbus
    Left = 192
    Top = 112
  end
  object IBStoredProc1: TIBStoredProc
    Database = nimbus
    Transaction = IBTransaction1
    StoredProcName = 'POST1'
    Left = 328
    Top = 88
  end
end
