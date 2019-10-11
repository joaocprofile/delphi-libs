unit jc.logFile;

interface

uses
  Classes, SysUtils, jc.Libs.Interfaces;

type
  TjcLog = class(TInterfacedObject, IJcLog)
  private
    class var FError: Exception;
    class var FSender: TObject;
    FCustomMsg: String;
    FDirPath: String;
  public
    constructor Create;
    destructor Destroy; override;
    class function New(Sender: TObject = nil; E: Exception = nil): IJcLog;

    function CatchException(Sender: TObject; E: Exception): IJcLog;
    function CustomMsg(Msg: String): IJcLog;
    function SaveLog(Alog: String = ''): IJcLog;
    function SaveError: IJcLog;
    function ShowLog(Alog: String = ''): IJcLog;
    function ShowError: IJcLog;
  end;

implementation

{ TjcLog }

uses jc.Utils, System.UITypes, Vcl.Dialogs;

class function TjcLog.New(Sender: TObject = nil; E: Exception = nil): IJcLog;
begin
  if E <> nil then
    FError := E;
  if Sender <> nil then
    FSender := Sender;

  Result := Self.Create;
end;

constructor TjcLog.Create;
begin
  FCustomMsg := EmptyStr;

  FDirPath := getPathApplication + 'logs' + PathDelim;
  if not DirectoryExists(FDirPath) then
    CreateDir(FDirPath);
end;

function TjcLog.CustomMsg(Msg: String): IJcLog;
begin
  FCustomMsg := Msg;
  Result := Self;
end;

destructor TjcLog.Destroy;
begin

  inherited;
end;

function TjcLog.CatchException(Sender: TObject; E: Exception): IJcLog;
begin
  if E <> nil then
    FError := E;
  if Sender <> nil then
    FSender := Sender;

  Result := Self;
end;

function TjcLog.SaveLog(Alog: String = ''): IJcLog;
var
  tFile: TextFile;
  FileName: string;
begin
  result := self;
  FileName := FormatDateTime('dd-mm-yyyy', now) + '_log' + '.txt';
  AssignFile(tFile, FDirPath + FileName);
  try
    if FileExists(FDirPath + FileName) then
      Append(tFile)
    else
      ReWrite(tFile);

    if FCustomMsg <> EmptyStr then
      WriteLn(tFile, FormatDateTime('hh:mm:ss', Now) +' '+ FCustomMsg)
    else
      WriteLn(tFile, FormatDateTime('hh:mm:ss', Now) +' '+ Alog);

  finally
    CloseFile(tFile);
  end;
end;

function TjcLog.SaveError: IJcLog;
var
  tFile: TextFile;
  FileName: string;
begin
  result := self;
  FileName := FormatDateTime('dd-mm-yyyy', now) + '_errors' + '.txt';
  AssignFile(tFile, FDirPath + FileName);
  try
    if FileExists(FDirPath + FileName) then
      Append(tFile)
    else
      ReWrite(tFile);

    WriteLn(tFile, 'Time.............: ' + FormatDateTime('hh:mm:ss', Now));
    WriteLn(tFile, 'Message..........: ' + FCustomMsg);
    WriteLn(tFile, 'Error............: ' + FError.Message);
    WriteLn(tFile, 'Class Exception..: ' + FError.ClassName);
    WriteLn(tFile, 'User.............: ' + '');
    WriteLn(tFile, 'Windows Version..: ' + '');
    WriteLn(tFile, '');
  finally
    CloseFile(tFile);
  end;

end;

function TjcLog.ShowLog(Alog: String = ''): IJcLog;
begin
  if FCustomMsg <> EmptyStr then
    MessageDlg(FCustomMsg, mtInformation, [mbOK], 0)
  else
    MessageDlg(Alog, mtInformation, [mbOK], 0);

  result := self;
end;

function TjcLog.ShowError: IJcLog;
var
  sBuilder: TStringBuilder;
begin
  result := self;
  sBuilder := TStringBuilder.Create;
  try
    sBuilder
      .AppendLine(FCustomMsg)
      .AppendLine(EmptyStr)
      .AppendLine('Error: ' + FError.Message);

    MessageDlg(sBuilder.ToString, mtError, [mbOK], 0);
  finally
    sBuilder.Free;
  end;
end;

end.
