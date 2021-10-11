object About: TAbout
  Left = 51
  Top = 0
  BorderStyle = bsSingle
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 225
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxRichEdit1: TcxRichEdit
    Left = 6
    Top = 8
    Properties.HideScrollBars = False
    Properties.ReadOnly = True
    Properties.ScrollBars = ssVertical
    Properties.StreamModes = [resmPlainRtf]
    Lines.Strings = (
      'Load from file About.rtf')
    Style.Shadow = True
    TabOrder = 0
    Height = 178
    Width = 345
  end
  object cxButton1: TcxButton
    Left = 136
    Top = 192
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 1
    OnClick = cxButton1Click
  end
end
