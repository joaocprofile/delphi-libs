object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 232
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 27
    Width = 28
    Height = 13
    Caption = 'String'
  end
  object Label2: TLabel
    Left = 24
    Top = 75
    Width = 70
    Height = 13
    Caption = 'String Crypted'
  end
  object Label3: TLabel
    Left = 16
    Top = 139
    Width = 86
    Height = 13
    Caption = 'String Descrypted'
  end
  object Button1: TButton
    Left = 108
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 108
    Top = 24
    Width = 401
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 108
    Top = 72
    Width = 401
    Height = 21
    TabOrder = 2
  end
  object Edit3: TEdit
    Left = 108
    Top = 136
    Width = 401
    Height = 21
    TabOrder = 3
  end
end
