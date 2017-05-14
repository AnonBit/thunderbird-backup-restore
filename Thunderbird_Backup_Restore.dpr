program Thunderbird_Backup_Restore;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form_Main},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Carbon');
  Application.CreateForm(TForm_Main, Form_Main);
  Application.Run;
end.
