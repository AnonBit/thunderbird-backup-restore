object Form_Main: TForm_Main
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Thunderbird Backup Restore'
  ClientHeight = 410
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBoxBackup: TGroupBox
    Left = 8
    Top = 8
    Width = 481
    Height = 185
    Caption = 'Backup'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object LabelProgressBarBackupPercentage: TLabel
      Left = 442
      Top = 107
      Width = 23
      Height = 16
      Caption = '0 %'
    end
    object LabelCopression: TLabel
      Left = 24
      Top = 147
      Width = 63
      Height = 16
      Caption = 'Copression'
    end
    object GroupBoxNewBackupFile: TGroupBox
      Left = 24
      Top = 24
      Width = 423
      Height = 65
      Caption = 'New Backup File'
      TabOrder = 0
      object EditNewBackupFilePath: TEdit
        Left = 16
        Top = 24
        Width = 273
        Height = 24
        ReadOnly = True
        TabOrder = 0
      end
      object ButtonSaveAs: TButton
        Left = 320
        Top = 24
        Width = 75
        Height = 25
        Caption = 'Save As'
        TabOrder = 1
        OnClick = ButtonSaveAsClick
      end
    end
    object ButtonBackup: TButton
      Left = 24
      Top = 104
      Width = 89
      Height = 25
      Caption = 'Backup'
      TabOrder = 1
      OnClick = ButtonBackupClick
    end
    object ProgressBarBackup: TProgressBar
      Left = 176
      Top = 104
      Width = 243
      Height = 25
      TabOrder = 2
    end
    object ComboBoxCompression: TComboBox
      Left = 176
      Top = 144
      Width = 47
      Height = 24
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 3
      Text = '1'
      Items.Strings = (
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9')
    end
  end
  object GroupBoxRestore: TGroupBox
    Left = 8
    Top = 199
    Width = 481
    Height = 201
    Caption = 'Restore'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object LabelProgressBarRestorePercentage: TLabel
      Left = 442
      Top = 152
      Width = 23
      Height = 16
      Caption = '0 %'
    end
    object GroupBoxExistingBackupFile: TGroupBox
      Left = 24
      Top = 32
      Width = 423
      Height = 97
      Caption = 'Existing Backup File'
      TabOrder = 0
      object ButtonBrowse: TButton
        Left = 320
        Top = 48
        Width = 75
        Height = 25
        Caption = 'Browse'
        TabOrder = 0
        OnClick = ButtonBrowseClick
      end
    end
    object EditRestoreFilePath: TEdit
      Left = 40
      Top = 80
      Width = 273
      Height = 24
      ReadOnly = True
      TabOrder = 1
    end
    object ButtonRestore: TButton
      Left = 24
      Top = 149
      Width = 89
      Height = 25
      Caption = 'Restore'
      TabOrder = 2
      OnClick = ButtonRestoreClick
    end
    object ProgressBarRestore: TProgressBar
      Left = 176
      Top = 149
      Width = 243
      Height = 25
      TabOrder = 3
    end
  end
  object ArchiverBackup: TZipForge
    ExtractCorruptedFiles = False
    CompressionLevel = clNone
    CompressionMode = 0
    CurrentVersion = '6.80 '
    SpanningMode = smNone
    SpanningOptions.AdvancedNaming = False
    SpanningOptions.FirstVolumeSize = 0
    SpanningOptions.VolumeSize = vsAutoDetect
    SpanningOptions.CustomVolumeSize = 65536
    Options.FlushBuffers = True
    Options.OEMFileNames = True
    InMemory = False
    OnOverallProgress = ArchiverBackupOverallProgress
    Zip64Mode = zmAuto
    UnicodeFilenames = True
    EncryptionMethod = caPkzipClassic
    Left = 168
  end
  object ArchiverRestore: TZipForge
    ExtractCorruptedFiles = False
    CompressionLevel = clFastest
    CompressionMode = 1
    CurrentVersion = '6.80 '
    SpanningMode = smNone
    SpanningOptions.AdvancedNaming = False
    SpanningOptions.FirstVolumeSize = 0
    SpanningOptions.VolumeSize = vsAutoDetect
    SpanningOptions.CustomVolumeSize = 65536
    Options.FlushBuffers = True
    Options.OEMFileNames = True
    InMemory = False
    OnOverallProgress = ArchiverRestoreOverallProgress
    Zip64Mode = zmAuto
    UnicodeFilenames = True
    EncryptionMethod = caPkzipClassic
    Left = 128
  end
end
