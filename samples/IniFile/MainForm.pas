unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  jc.IniFile, jc.Libs.Interfaces;

type
  TMain_Form = class(TForm)
    Button1: TButton;
    Edt_Host: TEdit;
    Edt_UserName: TEdit;
    Edt_Password: TEdit;
    Edt_Port: TEdit;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    jcIniFIle: IJcIniFile;
    teste: TStrings;
  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.dfm}

function getApplicationPath: String;
var
   Path: array[0..MAX_PATH - 1] of Char;
   PathStr: string;
begin
   SetString(PathStr, Path, GetModuleFileName(HInstance, Path, SizeOf(Path)));
   result := ExtractFilePath(PathStr);
end;

procedure TMain_Form.Button1Click(Sender: TObject);
begin
  jcIniFIle := TJcIniFile.New(getApplicationPath + 'config.ini');

  jcIniFIle
    .AddString('database', 'host',     Edt_Host.Text)
    .AddString('database', 'user',     Edt_UserName.Text)
    .AddString('database', 'password', Edt_Password.Text)
    .AddString('database', 'port',     Edt_Port.Text)
end;

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  jcIniFIle := TJcIniFile.Get(getApplicationPath + 'config.ini');

  Edt_Host.Text     := jcIniFIle.GetString('database', 'host', '');
  Edt_UserName.Text := jcIniFIle.GetString('database', 'user', '');
  Edt_Password.Text := jcIniFIle.GetString('database', 'password', '');
  Edt_Port.Text     := jcIniFIle.GetString('database', 'port', '');
end;

procedure TMain_Form.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
