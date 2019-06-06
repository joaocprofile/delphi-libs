object Main_Form: TMain_Form
  Left = 0
  Top = 0
  Caption = 'Project'
  ClientHeight = 155
  ClientWidth = 361
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
    Left = 16
    Top = 16
    Width = 137
    Height = 25
    Caption = 'Save log'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 56
    Width = 137
    Height = 25
    Caption = 'show log'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 208
    Top = 16
    Width = 129
    Height = 25
    Caption = 'Show error'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 208
    Top = 56
    Width = 129
    Height = 25
    Caption = 'Save Error'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 208
    Top = 104
    Width = 129
    Height = 25
    Caption = 'Save and Show Error'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 16
    Top = 104
    Width = 137
    Height = 25
    Caption = 'Save and Show Log'
    TabOrder = 5
    OnClick = Button6Click
  end
end
