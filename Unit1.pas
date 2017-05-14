unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IOUtils,
  ShlObj, Vcl.ComCtrls, ZipForge, System.UITypes, Vcl.ExtCtrls;

type
  TForm_Main = class(TForm)
    GroupBoxBackup: TGroupBox;
    GroupBoxRestore: TGroupBox;
    GroupBoxNewBackupFile: TGroupBox;
    EditNewBackupFilePath: TEdit;
    ButtonSaveAs: TButton;
    ButtonBackup: TButton;
    ProgressBarBackup: TProgressBar;
    LabelProgressBarBackupPercentage: TLabel;
    ArchiverBackup: TZipForge;
    LabelCopression: TLabel;
    ComboBoxCompression: TComboBox;
    ButtonBrowse: TButton;
    GroupBoxExistingBackupFile: TGroupBox;
    EditRestoreFilePath: TEdit;
    ButtonRestore: TButton;
    ProgressBarRestore: TProgressBar;
    LabelProgressBarRestorePercentage: TLabel;
    ArchiverRestore: TZipForge;
    procedure FormCreate(Sender: TObject);
    procedure ButtonSaveAsClick(Sender: TObject);
    procedure ButtonBackupClick(Sender: TObject);
    procedure ArchiverBackupOverallProgress(Sender: TObject; Progress: Double; Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
    procedure ButtonBrowseClick(Sender: TObject);
    procedure ButtonRestoreClick(Sender: TObject);
    procedure ArchiverRestoreOverallProgress(Sender: TObject; Progress: Double; Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Main: TForm_Main;

implementation

{$R *.dfm}

function GetSpecialFolderPath(Folder: Integer; ForceDir: Boolean): string;
// Uses ShlObj
var
  Path: array[0..255] of char;
begin
  SHGetSpecialFolderPath(0, @Path[0], Folder, ForceDir);
  Result := Path;
end;

procedure TForm_Main.ArchiverBackupOverallProgress(Sender: TObject; Progress: Double; Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  ProgressBarBackup.Position := Trunc(Progress);
  LabelProgressBarBackupPercentage.Caption := IntToStr(ProgressBarBackup.Position * 100 div ProgressBarBackup.Max) + ' %';
  Application.ProcessMessages;
end;

procedure TForm_Main.ArchiverRestoreOverallProgress(Sender: TObject; Progress: Double; Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  ProgressBarRestore.Position := Trunc(Progress);
  LabelProgressBarRestorePercentage.Caption := IntToStr(ProgressBarRestore.Position * 100 div ProgressBarRestore.Max) + ' %';
  Application.ProcessMessages;
end;

procedure TForm_Main.ButtonBackupClick(Sender: TObject);
begin
  try
  // Set the Zip64Mode zmAuto for auto-detection of the archive format depending on sizes of the files being added (Thus you can create archive files > 4Gb and add files > 4 Gb to the archive)
    archiverBackup.Zip64Mode := zmAuto;
  //Enable Support Unicode Filenames
    archiverBackup.UnicodeFilenames := True;
  // Set archive temp dir
    archiverBackup.TempDir := TPath.GetTempPath;
    with archiverBackup do
    begin

    // Set the compression level
      archiverBackup.CompressionMode := ComboBoxCompression.ItemIndex;
    // Set the name of the archive file we want to create
      FileName := EditNewBackupFilePath.Text;
    // Because we create a new archive,
    // we set Mode to fmCreate
      OpenArchive(fmCreate);
    // Set base (default) directory for all archive operations
      BaseDir := TPath.GetHomePath + TPath.DirectorySeparatorChar + 'Thunderbird';
    // Add the c:\Test folder to the archive with all subfolders
      AddFiles(TPath.GetHomePath + TPath.DirectorySeparatorChar + 'Thunderbird' + TPath.DirectorySeparatorChar + '*.*');
      CloseArchive();
      MessageDlg('File Was Saved', mtInformation, [mbok], 0);

    end;
  except
    on E: Exception do
    begin
      Writeln('Exception: ', E.Message);
      // Wait for the key to be pressed
      Readln;
    end;
  end;
end;

procedure TForm_Main.ButtonBrowseClick(Sender: TObject);
var
  openDialog: TOpenDialog;    // Open dialog variable
begin
  // Create the open dialog object - assign to our open dialog variable
  openDialog := TOpenDialog.Create(self);

  openDialog.Title := 'Select backup file';

  // Set up the starting directory to be the current one
  openDialog.InitialDir := GetSpecialFolderPath(CSIDL_DESKTOP, False);

  //Default File Name
  openDialog.FileName := 'backup.bak';

  // Only allow existing files to be selected
  openDialog.Options := [ofFileMustExist];

  // Allow only .dpr and .pas files to be selected
  openDialog.Filter := 'Backup File|*.bak|';

  // Select pascal files as the starting filter type
  openDialog.FilterIndex := 1;

  // Display the open file dialog
  if openDialog.Execute then
    EditRestoreFilePath.Text := openDialog.FileName;

  // Free up the dialog
  openDialog.Free;
end;

procedure TForm_Main.ButtonRestoreClick(Sender: TObject);
begin
  try
  // Set the Zip64Mode zmAuto for auto-detection of the archive format depending on sizes of the files being added (Thus you can create archive files > 4Gb and add files > 4 Gb to the archive)
    ArchiverRestore.Zip64Mode := zmAuto;
  //Enable Support Unicode Filenames
    ArchiverRestore.UnicodeFilenames := True;
  // Set archive temp dir
    ArchiverRestore.TempDir := TPath.GetTempPath;
    with ArchiverRestore do
    begin
    // The name of the ZIP file to unzip
      FileName := EditRestoreFilePath.Text;
    // Open an existing archive
      OpenArchive(fmOpenRead);
    // Set base (default) directory for all archive operations
      BaseDir := TPath.GetHomePath + TPath.DirectorySeparatorChar + 'Thunderbird';
    // Extract all files from the archive to C:\Temp folder
      ExtractFiles('*.*');
      CloseArchive();
      MessageDlg('Backup Restored', mtInformation, [mbok], 0);
    end;
  except
    on E: Exception do
    begin
      Writeln('Exception: ', E.Message);
      // Wait for the key to be pressed
      Readln;
    end;
  end;
end;

procedure TForm_Main.ButtonSaveAsClick(Sender: TObject);
var
  saveDialog: tsavedialog;    // Save dialog variable
begin
  // Create the save dialog object - assign to our save dialog variable
  saveDialog := TSaveDialog.Create(self);

  // Give the dialog a title
  saveDialog.Title := 'Set backup file name';

  // Set up the starting directory to be the current one
  saveDialog.InitialDir := GetSpecialFolderPath(CSIDL_DESKTOP, False);

  //Default File Name
  saveDialog.FileName := 'backup.bak';

  // Allow only .bak file types to be saved
  saveDialog.Filter := 'Backup File|*.bak|';

  // Set the default extension
  saveDialog.DefaultExt := 'bak';

  // Select text files as the starting filter type
  saveDialog.FilterIndex := 1;

  // Display the open file dialog
  if saveDialog.Execute then
    EditNewBackupFilePath.Text := saveDialog.FileName;

  // Free up the dialog
  saveDialog.Free;
end;

procedure TForm_Main.FormCreate(Sender: TObject);
//Uses System.IOUtils , System.UITypes
begin
  if DirectoryExists(TPath.GetHomePath + TPath.DirectorySeparatorChar + 'Thunderbird') then
     GroupBoxBackup.Enabled:=True
  else
  begin
    GroupBoxBackup.Enabled:=False;
    MessageDlg(TPath.GetHomePath + TPath.DirectorySeparatorChar + 'Thunderbird' + sLineBreak + ' Does not exist', mtInformation, [mbok], 0)
  end
end;

end.

