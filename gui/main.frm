object formMain: TformMain
  Left = 1373
  Height = 369
  Top = 485
  Width = 558
  Caption = 'KnifeGui - Control your Blade'
  ClientHeight = 369
  ClientWidth = 558
  OnCreate = FormCreate
  OnWindowStateChange = FormWindowStateChange
  LCLVersion = '6.8'
  object grpbxColor: TGroupBox
    Left = 128
    Height = 319
    Top = 0
    Width = 430
    Align = alClient
    Caption = 'Effect color'
    ClientHeight = 299
    ClientWidth = 426
    TabOrder = 0
    object selectedColorPanel: TplColorPanel
      Left = 8
      Height = 25
      Top = 268
      Width = 185
      FrameColorHighLight = 8623776
      FrameColorShadow = 8623776
      FrameWidth = 1
      Color = clBtnFace
      Caption = 'Click to show more options'
      ParentColor = False
      TabOrder = 0
      UseDockManager = True
      Anchors = [akLeft, akBottom]
      OnClick = selectedColorPanelClick
    end
    object panelColorselector: TPanel
      Left = 8
      Height = 262
      Top = 0
      Width = 414
      Anchors = [akTop, akLeft, akRight, akBottom]
      BevelOuter = bvNone
      ClientHeight = 262
      ClientWidth = 414
      TabOrder = 1
      OnClick = panelColorselectorClick
      object colorPicker: THSColorPicker
        Left = 0
        Height = 262
        Top = 0
        Width = 414
        SelectedColor = 460777
        HintFormat = 'H: %h S: %hslS'#13'Hex: %hex'
        Align = alClient
        TabOrder = 0
        Color = clBlack
        ParentColor = False
        OnMouseUp = colorPickerMouseUp
        OnChange = colorPickerChange
      end
    end
    object colPanelGreen: TplColorPanel
      Left = 367
      Height = 25
      Top = 268
      Width = 25
      FrameColorHighLight = 8623776
      FrameColorShadow = 8623776
      FrameWidth = 1
      Color = clLime
      ParentColor = False
      TabOrder = 2
      UseDockManager = True
      Anchors = [akRight, akBottom]
      OnClick = colPanelGreenClick
    end
    object colPanelRed: TplColorPanel
      Left = 337
      Height = 25
      Top = 268
      Width = 25
      FrameColorHighLight = 8623776
      FrameColorShadow = 8623776
      FrameWidth = 1
      Color = clRed
      ParentColor = False
      TabOrder = 3
      UseDockManager = True
      Anchors = [akRight, akBottom]
      OnClick = colPanelRedClick
    end
    object colPanelBlue: TplColorPanel
      Left = 397
      Height = 25
      Top = 268
      Width = 25
      FrameColorHighLight = 8623776
      FrameColorShadow = 8623776
      FrameWidth = 1
      Color = clBlue
      ParentColor = False
      TabOrder = 4
      UseDockManager = True
      Anchors = [akRight, akBottom]
      OnClick = colPanelBlueClick
    end
  end
  object controlPanelLeft: TPanel
    Left = 0
    Height = 319
    Top = 0
    Width = 128
    Align = alLeft
    BevelOuter = bvNone
    ClientHeight = 319
    ClientWidth = 128
    TabOrder = 1
    object rdgrpEffect: TRadioGroup
      Left = 0
      Height = 219
      Top = 0
      Width = 128
      Align = alClient
      AutoFill = True
      Caption = 'Lightning mode'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 1
      ClientHeight = 199
      ClientWidth = 124
      ItemIndex = 5
      Items.Strings = (
        'None (off)'
        'Wave'
        'Reactive'
        'Breath'
        'Spectrum'
        'Static'
      )
      OnClick = rdgrpEffectClick
      TabOrder = 0
    end
    object grpbxSpeed: TGroupBox
      Left = 0
      Height = 50
      Top = 269
      Width = 128
      Align = alBottom
      Caption = 'Effect speed'
      ClientHeight = 30
      ClientWidth = 124
      TabOrder = 1
      object sliderSpeed: TplSlider
        Left = 0
        Height = 30
        Top = 0
        Width = 124
        EdgeSize = 0
        NumThumbStates = 0
        Options = [soShowPoints]
        Increment = 1
        MinValue = 1
        MaxValue = 4
        Value = 1
        Align = alClient
        TabOrder = 0
      end
    end
    object grpbxBrightness: TGroupBox
      Left = 0
      Height = 50
      Top = 219
      Width = 128
      Align = alBottom
      Caption = 'Brightness'
      ClientHeight = 30
      ClientWidth = 124
      TabOrder = 2
      object sliderBrightness: TplSlider
        Left = 0
        Height = 30
        Top = 0
        Width = 124
        EdgeSize = 0
        NumThumbStates = 0
        Options = [soShowPoints]
        Increment = 25
        MinValue = 0
        MaxValue = 255
        Value = 1
        Align = alClient
        TabOrder = 0
        OnChange = sliderBrightnessChange
      end
    end
  end
  object panelSettings: TPanel
    Left = 0
    Height = 50
    Top = 319
    Width = 558
    Align = alBottom
    BevelOuter = bvNone
    ClientHeight = 50
    ClientWidth = 558
    TabOrder = 2
    object chkgrpSettings: TCheckGroup
      Left = 0
      Height = 50
      Top = 0
      Width = 456
      Align = alLeft
      AutoFill = True
      Caption = 'Settings'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.TopBottomSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 3
      ClientHeight = 30
      ClientWidth = 452
      Columns = 3
      Items.Strings = (
        'Start Knife minimized'
        'Minimize to Systray'
        'Autostart with Windows'
      )
      OnItemClick = chkgrpSettingsItemClick
      TabOrder = 0
      Data = {
        03000000020202
      }
    end
    object KLinkLabel1: TKLinkLabel
      Cursor = crHandPoint
      Left = 459
      Height = 15
      Top = 33
      Width = 91
      Caption = 'Visit project page'
      Font.Color = clBlue
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      ShowURLAsHint = True
      URL = 'https://github.com/lpcvoid/knife'
    end
  end
  object ColorDialog: TColorDialog
    Color = clBlack
    CustomColors.Strings = (
      'ColorA=000000'
      'ColorB=000080'
      'ColorC=008000'
      'ColorD=008080'
      'ColorE=800000'
      'ColorF=800080'
      'ColorG=808000'
      'ColorH=808080'
      'ColorI=C0C0C0'
      'ColorJ=0000FF'
      'ColorK=00FF00'
      'ColorL=00FFFF'
      'ColorM=FF0000'
      'ColorN=FF00FF'
      'ColorO=FFFF00'
      'ColorP=FFFFFF'
      'ColorQ=C0DCC0'
      'ColorR=F0CAA6'
      'ColorS=F0FBFF'
      'ColorT=A4A0A0'
    )
    Left = 432
    Top = 32
  end
  object TrayIcon: TTrayIcon
    PopUpMenu = PopupMenuTrayIcon
    Icon.Data = {
      BE1000000000010001002020000001002000A810000016000000280000002000
      0000400000000100200000000000000000000000000000000000000000000000
      0000000000000000000085D7A65285D7A6DA85D7A6EE85D7A6D885D7A69285D7
      A62C000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000085D7A65C85D7A6FC85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7
      A6FC85D7A69C85D7A61000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000085D7A63085D7A6F885D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6DC85D7A626000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000085D7A66285D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6E485D7A6200000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000085D7A60A85D7A6CA85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6CE85D7A60800000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000085D7A61485D7A6D285D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A68885D7A60285D7A68A85D7
      A6E885D7A64E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000085D7A61685D7A6D485D7A6FF85D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6F685D7A6AA85D7A6FF85D7
      A6FF85D7A68A0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000085D7A61685D7A6D485D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7
      A6C885D7A60E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000085D7A61685D7A6D485D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6CA85D7
      A6100000000085D7A66685D7A648000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000085D7A61685D7A6D485D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6CA85D7A6120000
      000085D7A67085D7A6FC85D7A6F885D7A64E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000085D7A61685D7
      A6D285D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6CA85D7A6120000000085D7
      A67285D7A6FA85D7A65885D7A69685D7A6F885D7A64E00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000085D7
      A61A85D7A6F285D7A6FF85D7A6FF85D7A6CA85D7A6100000000085D7A67485D7
      A6FF85D7A6780000000085D7A60285D7A6A285D7A6F885D7A64C000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000085D7A60285D7
      A6A885D7A6FF85D7A6FF85D7A6C885D7A6100000000085D7A67485D7A6FF85D7
      A6FF85D7A6EA85D7A62E0000000085D7A60485D7A6B485D7A6F685D7A6420000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000085D7A63C85D7
      A6FF85D7A6FF85D7A6C285D7A60E0000000085D7A67485D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6EA85D7A6300000000085D7A60C85D7A6CA85D7A6F085D7
      A62E000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000085D7A60E85D7
      A6B685D7A6A685D7A60C0000000085D7A67485D7A6FF85D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6EC85D7A6320000000085D7A61A85D7A6E285D7
      A6E085D7A6160000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000085D7A62685D7A6F885D7A6FF85D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6EC85D7A6300000000085D7A63485D7
      A6F685D7A6C085D7A60400000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000085D7A65285D7A6F885D7A6FF85D7A6F685D7
      A6FC85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6EA85D7A62C0000000085D7
      A66085D7A6FF85D7A68600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000085D7A65285D7A6D685D7A62285D7
      A69885D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6E685D7A6240000
      000085D7A69C85D7A6FC85D7A640000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000085D7A60485D7A64685D7
      A6F685D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6DE85D7
      A61C85D7A60C85D7A6D885D7A6DC85D7A60A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000085D7A65485D7
      A6FA85D7A6E085D7A68285D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7
      A6D285D7A61085D7A63685D7A6FA85D7A6860000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000085D7
      A64C85D7A61E85D7A64C85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7
      A6FF85D7A6BC85D7A60685D7A68C85D7A6F885D7A62200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000085D7A61285D7A6F085D7A6FF85D7A6F285D7A6FA85D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A69685D7A60C85D7A6E285D7A6A600000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000085D7A65285D7A6D885D7A62085D7A69C85D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A65E85D7A65E85D7A6FC85D7A628000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000085D7A60485D7A64685D7A6F685D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6F285D7A62885D7A6D285D7A698000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000085D7A65085D7A6F885D7A6FF85D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6C485D7A65A85D7A6F285D7A60C0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000085D7A65285D7A6F885D7A6FF85D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A66A85D7A6E285D7A65E0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000085D7A65085D7A6F885D7
      A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6E885D7A69285D7A6AE0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000085D7A65085D7
      A6F885D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6FF85D7A6A685D7A6F085D7
      A604000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000085D7
      A65085D7A6C885D7A6EA85D7A6FF85D7A6FF85D7A6FF85D7A6E085D7A6F285D7
      A630000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000085D7A60085D7A62885D7A68085D7A6E885D7A6FF85D7A6FF85D7
      A65C000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000085D7A60C85D7A68485D7A6F885D7
      A66E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000085D7A63485D7
      A652E1FFFFFFC07FFFFF803FFFFF801FFFFF800FFFFFC004FFFFE0007FFFF000
      FFFFF801FFFFFC039FFFFE074FFFFF0EE7FFFE1C73FFFE3839FFFE701CFFFFE0
      0E7FFFF0073FFFFA033FFFFE019FFFFE00CFFFFFC04FFFFF8027FFFFD037FFFF
      F013FFFFF00BFFFFF80BFFFFFC01FFFFFE01FFFFFF01FFFFFFE1FFFFFFF9FFFF
      FFFF
    }
    OnClick = TrayIconClick
    Left = 360
    Top = 32
  end
  object PopupMenuTrayIcon: TPopupMenu
    Left = 256
    Top = 32
    object MenuItemShow: TMenuItem
      Caption = 'Show'
      OnClick = MenuItemShowClick
    end
    object MenuItemQuit: TMenuItem
      Caption = 'Quit'
      OnClick = MenuItemQuitClick
    end
  end
end
