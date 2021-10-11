object FMessage: TFMessage
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
  ClientHeight = 263
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 28
    Width = 56
    Height = 13
    Caption = #1042#1093#1086#1076#1103#1097#1077#1077':'
  end
  object Label2: TLabel
    Left = 8
    Top = 127
    Width = 62
    Height = 13
    Caption = #1048#1089#1093#1086#1076#1103#1097#1077#1077':'
  end
  object cxRichEdit1: TcxRichEdit
    Left = 8
    Top = 144
    Properties.ScrollBars = ssVertical
    StyleDisabled.Color = clWindow
    StyleDisabled.TextColor = clWindowText
    TabOrder = 0
    OnKeyDown = cxRichEdit1KeyDown
    Height = 80
    Width = 302
  end
  object cxRichEdit2: TcxRichEdit
    Left = 8
    Top = 43
    ParentShowHint = False
    Properties.ReadOnly = True
    Properties.ScrollBars = ssVertical
    Lines.Strings = (
      '')
    ShowHint = True
    TabOrder = 1
    Height = 80
    Width = 302
  end
  object cxButton1: TcxButton
    Left = 168
    Top = 230
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = cxButton1Click
  end
  object cxButton2: TcxButton
    Left = 56
    Top = 230
    Width = 75
    Height = 25
    Hint = 'Ctrl+Enter'
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = cxButton2Click
  end
  object Text_User: TcxTextEdit
    Left = 8
    Top = 5
    Enabled = False
    Properties.AutoSelect = False
    Properties.ReadOnly = True
    Style.Color = clYellow
    Style.TextStyle = []
    StyleDisabled.Color = clYellow
    StyleDisabled.TextColor = clWindowText
    StyleFocused.TextStyle = []
    StyleHot.TextStyle = []
    TabOrder = 4
    Text = 'User'
    Width = 185
  end
  object Text_Date: TcxTextEdit
    Left = 208
    Top = 5
    Enabled = False
    Properties.Alignment.Horz = taCenter
    Properties.AutoSelect = False
    Properties.ReadOnly = True
    Style.Color = clYellow
    Style.TextStyle = []
    StyleDisabled.Color = clYellow
    StyleDisabled.TextColor = clWindowText
    StyleFocused.TextStyle = []
    StyleHot.TextStyle = []
    TabOrder = 5
    Text = 'dd.mm.yy hh:mm'
    Width = 102
  end
end
