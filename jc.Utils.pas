unit jc.Utils;

interface

uses
  Windows, Messages, SysUtils, Classes, TypInfo,
  DBClient, DB, DateUtils, ShellAPI,
  Vcl.FileCtrl, IdHashMessageDigest, Winapi.WinInet;

  function getPathApplication: String;
  Function ExtractNameEXE(const Filename: String): String;
  function IsOnline: Boolean;
  function CreateSessionID: string;

  function LineCount(AFile: String; AFlag: String = ''): Integer;
  function SymbolCount(const subtext: string; Text: string): Integer;
  Function NoMask(Value: string): string; overload;
  function ReadString(SymbolSeparator: String; Value: String): String;
  function RemoveString(SymbolSeparator: String; Value: String): String;
  function UpperFirstLetter(sNome: String): string;
  Function MD5File(const AFileName: string): string;
  function MD5String(const texto: string): string;

implementation

function getPathApplication: String;
{$IFDEF MSWINDOWS}
var
   Path: array[0..MAX_PATH - 1] of Char;
   PathStr: string;
{$ENDIF MSWINDOWS}
begin
  {$IFDEF MSWINDOWS}
     SetString(PathStr, Path, GetModuleFileName(HInstance, Path, SizeOf(Path)));
     result := ExtractFilePath(PathStr);
  {$ENDIF MSWINDOWS}
  {$IFDEF POSIX}
     result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  {$ENDIF POSIX}
end;

function IsOnline: Boolean;
var
  Flags: DWORD;
begin
  if InternetGetConnectedState(@Flags, 0) then
    Result := True
  else
    Result := False;
end;

function CreateSessionID: string;
var
  lGuid: TGuid;
begin
  CreateGUID(lGuid);
  Result := GUIDToString(lGuid);
end;

function MD5File(const AFileName: string): string;
var
  idmd5 : TIdHashMessageDigest5;
  fs : TFileStream;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  fs := TFileStream.Create(AFileName, fmOpenRead OR fmShareDenyWrite) ;
  try
    result := idmd5.HashStreamAsHex(fs);
  finally
    fs.Free;
    idmd5.Free;
  end;
end;

function MD5String(const texto: string): string;
var
  idmd5: TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  try
    result := idmd5.HashStringAsHex(texto);
  finally
    idmd5.Free;
  end;
end;

Function ExtractNameEXE(const Filename: String): String;
var
  aExt : String;
  aPos : Integer;
begin
  aExt := ExtractFileExt(Filename);
  Result := ExtractFileName(Filename);
  if aExt <> '' then
  begin
    aPos := Pos(aExt,Result);
    if aPos > 0 then
    begin
      Delete(Result,aPos, Length(aExt));
    end;
  end;
end;

function LineCount(AFile: String; AFlag: String): Integer;
var
   f: TextFile;
   sLinha: String;
   sFlag: String;
   CountLine: Integer;
begin
   CountLine := 0;

   AssignFile(f, AFile);
   try
     Reset(f);
     While not Eof(f) do
     begin
       Readln(f, sLinha);

       if not AFlag.IsEmpty then
       begin
         sflag := copy(sLinha, 1, AFlag.Length);
         if sFlag = AFlag then
           Inc(CountLine);
       end
       else
         Inc(CountLine);
     end;
   finally
     CloseFile(f);
   end;

  result := CountLine;
End;

function SymbolCount(const subtext: string; Text: string): Integer;
begin
  if (Length(subtext) = 0) or (Length(Text) = 0) or (Pos(subtext, Text) = 0)
  then
    Result := 0
  else
    Result := (Length(Text) - Length(StringReplace(Text, subtext, '',
      [rfReplaceAll]))) div Length(subtext);
end;

function NoMask(Value: String): string;
var
  i: Integer;
  xStr : String;
begin
 xStr := '';
 for i:= 1 to Length(Trim(Value)) do
   if (Pos(Copy(Value,i,1), '/-.) (,"{}[]')=0) then xStr := xStr + Value[i];

 xStr := StringReplace(xStr,' ','',[rfReplaceAll]);

 Result:= Trim(xStr);
end;

function ReadString(SymbolSeparator: String; Value: String): String;
begin
  Result := Copy(Value, 1, pos(SymbolSeparator, Value)-1);
end;

function RemoveString(SymbolSeparator: String; Value: String): String;
begin
  Delete(Value, 1, pos(SymbolSeparator, Value));
  result := Value;
end;

function UpperFirstLetter(sNome: String): string;
const
  excecao: array[0..5] of string = ('da', 'de', 'do', 'das', 'dos', 'e');
var
  tamanho, j: integer;
  i: byte;
begin
  Result := AnsiLowerCase(sNome);
  tamanho := Length(Result);

  for j := 1 to tamanho do
    if (j = 1) or ((j>1) and (Result[j-1]=Chr(32))) then
      Result[j] := AnsiUpperCase(Result[j])[1];
  for i := 0 to Length(excecao)-1 do
    result:= StringReplace(result,excecao[i],excecao[i],[rfReplaceAll, rfIgnoreCase]);
end;


end.
