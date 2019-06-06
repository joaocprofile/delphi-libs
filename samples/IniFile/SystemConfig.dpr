program SystemConfig;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Main_Form},
  jc.Libs.Interfaces in '..\..\jc.Libs.Interfaces.pas',
  jc.IniFile in '..\..\jc.IniFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain_Form, Main_Form);
  Application.Run;
end.
