object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Instalador Sonda'
  ClientHeight = 250
  ClientWidth = 450
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
    Left = 260
    Top = 29
    Width = 70
    Height = 13
    Caption = 'Porta Remota:'
  end
  object Label2: TLabel
    Left = 233
    Top = 77
    Width = 97
    Height = 13
    Caption = 'Porta TSprint/Equip:'
  end
  object Label3: TLabel
    Left = 221
    Top = 125
    Width = 109
    Height = 13
    Caption = 'Porta Painel de Senha:'
  end
  object Label4: TLabel
    Left = 18
    Top = 29
    Width = 40
    Height = 13
    Caption = 'Usu'#225'rio:'
  end
  object Button1: TButton
    Left = 142
    Top = 173
    Width = 150
    Height = 50
    Caption = 'Instalar'
    TabOrder = 6
    OnClick = Button1Click
  end
  object chkTSprint: TCheckBox
    Left = 64
    Top = 71
    Width = 127
    Height = 17
    Caption = 'Instalar com TSprint'
    TabOrder = 4
  end
  object chkPainel: TCheckBox
    Left = 64
    Top = 103
    Width = 127
    Height = 17
    Caption = 'Atalho Painel de Senha'
    TabOrder = 5
  end
  object txtUser: TMaskEdit
    Left = 64
    Top = 21
    Width = 127
    Height = 21
    TabOrder = 0
    Text = ''
  end
  object txtRemota: TEdit
    Left = 336
    Top = 21
    Width = 53
    Height = 21
    MaxLength = 5
    NumbersOnly = True
    TabOrder = 1
  end
  object txtEquip: TEdit
    Left = 336
    Top = 69
    Width = 53
    Height = 21
    MaxLength = 4
    NumbersOnly = True
    TabOrder = 2
  end
  object txtPainel: TEdit
    Left = 336
    Top = 117
    Width = 53
    Height = 21
    MaxLength = 4
    NumbersOnly = True
    TabOrder = 3
  end
end
