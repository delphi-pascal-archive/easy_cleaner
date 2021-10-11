object Form2: TForm2
  Left = 491
  Top = 199
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 271
  ClientWidth = 192
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 135
    Height = 13
    Caption = #1042#1099#1073#1080#1088#1077#1090#1077' '#1092#1072#1081#1083' '#1080#1083#1080' '#1087#1072#1087#1082#1091':'
  end
  object SpeedButton1: TSpeedButton
    Left = 120
    Top = 240
    Width = 65
    Height = 25
    Caption = 'OK'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 48
    Top = 240
    Width = 65
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    OnClick = SpeedButton2Click
  end
  object ShellTreeView1: TShellTreeView
    Left = 8
    Top = 24
    Width = 177
    Height = 209
    ObjectTypes = [otFolders, otNonFolders, otHidden]
    Root = 'rfMyComputer'
    UseShellImages = True
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 0
  end
end
