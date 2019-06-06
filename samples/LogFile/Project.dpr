program Project;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Main_Form},
  jc.Libs.Interfaces in '..\..\jc.Libs.Interfaces.pas',
  jc.Utils in '..\..\jc.Utils.pas',
  jc.LogFile in '..\..\jc.LogFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain_Form, Main_Form);
  Application.Run;
end.
