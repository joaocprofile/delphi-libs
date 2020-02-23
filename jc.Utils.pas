unit jc.Utils;

interface

uses
  Windows, Messages, SysUtils, Classes;

  function getPathApplication(ACustomDir: String = '';
                              ACustomFile: String = ''): String;
  Function getStringNameEXE(const ACustomFile: String = ''): String;
  Function ExtractName(const Filename: String): String;

  function getPcName: string;
  function GePcUserName: string;
  function getOSPlatform: String;

  function ReadString(SymbolSeparator: String; Value: String): String;
  function RemoveString(SymbolSeparator: String; Value: String): String;
  function getNumberSymbolSeparator(Asep, AValue: string): Integer;
  function getDomain(AEmail: String): String;
  function getHostName(AEmail: String): String;

  function LineCount(AFile: String; AFlag: String = ''): Integer;
  function SymbolCount(const subtext: string; Text: string): Integer;
  Function NoMask(Value: string): string; overload;
  function UpperFirstLetter(sNome: String): string;

implementation

uses
  System.RegularExpressions;

function getPathApplication(ACustomDir: String = ''; ACustomFile: String = ''): String;
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

  if trim(ACustomDir) <> '' then
  begin
    if not DirectoryExists(result + ACustomDir)  then
      CreateDir(result + ACustomDir);
    result := result + ACustomDir + PathDelim;
  end;
  if trim(ACustomFile) <> '' then
  begin
    result := result + ACustomFile;
  end;
end;

Function getStringNameEXE(const ACustomFile: String = ''): String;
var
  aExt : String;
  aPos : Integer;
  aExeName : String;
begin
  if trim(ACustomFile) = '' then
    aExeName := ParamStr(0)
  else
    aExeName := ACustomFile;

  aExt := ExtractFileExt(aExeName);
  Result := ExtractFileName(aExeName);
  if aExt <> '' then
  begin
    aPos := Pos(aExt, Result);
    if aPos > 0 then
    begin
      Delete(Result,aPos, Length(aExt));
    end;
  end;
end;

Function ExtractName(const Filename: String): String;
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
 for i := 1 to Length(Value) do
 begin
   if (Pos(Copy(Value, i, 1), '/-.)(,"{}[]') = 0) then
     xStr := xStr + Value[i];
 end;

 Result:= xStr;
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

function getNumberSymbolSeparator(Asep, AValue: string): Integer;
begin
  result := TRegEx.Matches(AValue, Asep).Count;
end;

function getDomain(AEmail: String): String;
begin
  result := Copy (AEmail, Pos ('@', AEmail) + 1, Length(AEmail));
end;

function getHostName(AEmail: String): String;
var
  lHost: string;
begin
  lHost := Copy (AEmail, Pos ('@', AEmail) + 1, Length(AEmail));
  result := trim( LowerCase( Copy(lHost, 1, pos('.', lHost)-1) ) );
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

function getPcName: string;
var
  buffer:array[0..MAX_COMPUTERNAME_LENGTH+1] of Char;
  length:Cardinal;
begin
   length := MAX_COMPUTERNAME_LENGTH+1;
   GetComputerName(@buffer, length);
   getPcName := buffer;
end;

function GePcUserName: string;
var
  Size: DWord;
begin
  Size := 1024;
  SetLength(result, Size);
  GetUserName(PChar(result), Size);
  SetLength(result, Size - 1);
end;

function getOSPlatform: String;
const
  PROCESSOR_ARCHITECTURE_INTEL = $0000;
  PROCESSOR_ARCHITECTURE_IA64 = $0006;
  PROCESSOR_ARCHITECTURE_AMD64 = $0009;
  PROCESSOR_ARCHITECTURE_UNKNOWN = $FFFF;
var
  xSysInfo: TSystemInfo;
begin
  GetNativeSystemInfo(xSysInfo);
  case xSysInfo.wProcessorArchitecture of
    PROCESSOR_ARCHITECTURE_AMD64, PROCESSOR_ARCHITECTURE_IA64:
      Result := 'x64';
  else
    Result := 'x86';
  end;
end;


end.
