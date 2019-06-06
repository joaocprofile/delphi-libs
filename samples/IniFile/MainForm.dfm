object Main_Form: TMain_Form
  Left = 0
  Top = 0
  Caption = 'System Config'
  ClientHeight = 240
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 72
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edt_Host: TEdit
    Left = 72
    Top = 24
    Width = 233
    Height = 21
    TabOrder = 1
  end
  object Edt_UserName: TEdit
    Left = 72
    Top = 56
    Width = 233
    Height = 21
    TabOrder = 2
  end
  object Edt_Password: TEdit
    Left = 72
    Top = 91
    Width = 233
    Height = 21
    TabOrder = 3
  end
  object Edt_Port: TEdit
    Left = 72
    Top = 131
    Width = 233
    Height = 21
    TabOrder = 4
  end
  object Button2: TButton
    Left = 153
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 5
    OnClick = Button2Click
  end
end
