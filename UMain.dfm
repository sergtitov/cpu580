object FEditor: TFEditor
  Left = 332
  Top = 187
  Align = alClient
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'FEditor'
  ClientHeight = 488
  ClientWidth = 644
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 25
    Height = 488
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel2: TBevel
      Left = 0
      Top = 487
      Width = 25
      Height = 1
      Align = alBottom
    end
    object Bevel3: TBevel
      Left = 0
      Top = 0
      Width = 1
      Height = 487
      Align = alLeft
      Style = bsRaised
    end
    object Bevel1: TBevel
      Left = 22
      Top = 0
      Width = 3
      Height = 487
      Align = alRight
      Shape = bsRightLine
      Style = bsRaised
    end
  end
  object Panel0: TPanel
    Left = 25
    Top = 0
    Width = 619
    Height = 488
    Align = alClient
    BevelOuter = bvNone
    Locked = True
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 381
      Top = 4
      Width = 5
      Height = 484
      Cursor = crHSplit
      Color = clBtnFace
      ParentColor = False
    end
    object Panel7: TPanel
      Left = 0
      Top = 0
      Width = 619
      Height = 4
      Align = alTop
      TabOrder = 2
    end
    object Panel1: TPanel
      Left = 0
      Top = 4
      Width = 381
      Height = 484
      Align = alLeft
      BevelOuter = bvNone
      Locked = True
      TabOrder = 0
      object RText: TRichEdit
        Left = 0
        Top = 0
        Width = 376
        Height = 484
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = []
        ParentFont = False
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object Panel8: TPanel
        Left = 376
        Top = 0
        Width = 5
        Height = 484
        Align = alRight
        TabOrder = 1
      end
    end
    object Panel2: TPanel
      Left = 386
      Top = 4
      Width = 233
      Height = 484
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Splitter2: TSplitter
        Left = 0
        Top = 355
        Width = 233
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        Beveled = True
        ResizeStyle = rsUpdate
      end
      object Splitter3: TSplitter
        Left = 0
        Top = 225
        Width = 233
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        Beveled = True
        ResizeStyle = rsUpdate
      end
      object Panel4: TPanel
        Left = 0
        Top = 358
        Width = 233
        Height = 126
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
      end
      object Panel5: TPanel
        Left = 0
        Top = 228
        Width = 233
        Height = 127
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 233
        Height = 225
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
      end
    end
  end
end
