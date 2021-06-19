unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TMain_Form = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.dfm}

uses jc.LogFile;

procedure TMain_Form.Button1Click(Sender: TObject);
begin
  TjcLog.New
    .SaveLog('to say hello !')
end;

procedure TMain_Form.Button2Click(Sender: TObject);
begin
  TjcLog.New
     .ShowLog('Hello world !');
end;

procedure TMain_Form.Button3Click(Sender: TObject);
begin

  try
    StrToInt('jc');
  except
    On E: Exception do
      TjcLog.New(Sender, E)
        .CustomMsg('Erro ao converter variavel')
          .showError;
  end;

end;

procedure TMain_Form.Button4Click(Sender: TObject);
begin

  try
    StrToInt('jc');
  except
    On E: Exception do
      TjcLog.New(Sender, E)
        .CustomMsg('Erro ao converter variavel')
          .SaveError;
  end;

end;

procedure TMain_Form.Button5Click(Sender: TObject);
begin
  try
    StrToInt('jc');
  except
    On E: Exception do
      TjcLog.New(Sender, E)
        .CustomMsg('Erro ao converter variavel')
          .showError
          .SaveError;
  end;
end;

procedure TMain_Form.Button6Click(Sender: TObject);
begin
  TjcLog.New
    .CustomMsg('Hello world')
      .ShowLog
      .SaveLog;
end;

end.
