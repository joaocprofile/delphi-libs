unit jc.IniFile;

interface

uses
  IniFiles, Classes, jc.Libs.Interfaces;

type
  TJcIniFile = class(TInterfacedObject, IJcIniFile)
  private
    FIniFile: TIniFile;
    FFileName: string;
  public
    constructor Create(AFileName: String);
    destructor Destroy; override;
    class function New(AFileName: String = '') : IJcIniFile;
    class function Get(AFileName: String = '') : IJcIniFile;

    function FileName(const Value: string): IJcIniFile;
    function AddSection(const Section, Values: string): IJcIniFile;
    function AddString(const Section, Ident, Value: string): IJcIniFile;
    function AddInteger(const Section, Ident: string; Value: integer): IJcIniFile;
    function AddBoolean(const Section, Ident: string; Value: Boolean): IJcIniFile;
    function DeleteKey(const Section, Ident: String): IJcIniFile;
    function DeleteSection(const Section: String): IJcIniFile;
    function GetSections(var Sections: TStrings): IJcIniFile;
    function GetSectionValues(const Section: String; Strings: TStrings): IJcIniFile;
    function GetString(const Section, Ident, Default: string): string;
    function GetInteger(const Section, Ident: string; Default: integer): integer;
    function GetBoolean(const Section, Ident: string; Default: Boolean): Boolean;
  end;

implementation

uses
  Forms, SysUtils;

{ TJcIniFile }

class function TJcIniFile.New(AFileName: String = ''): IJcIniFile;
begin
  Result := Self.Create(AFileName);
end;

class function TJcIniFile.Get(AFileName: String): IJcIniFile;
begin
  Result := Self.Create(AFileName);
end;

constructor TJcIniFile.Create(AFileName: String);
begin
  if AFileName <> '' then
    FileName(AFileName);
end;

destructor TJcIniFile.Destroy;
begin
  if Assigned(FIniFile) then
    FreeAndNil(FIniFile);

  inherited;
end;

function TJcIniFile.FileName(const Value: string): IJcIniFile;
begin
  result := self;
  FFileName := Value;

  if Assigned(FIniFile) then
    FreeAndNil(FIniFile);
  FIniFile := TIniFile.Create(FFileName);
end;

function TJcIniFile.AddSection(const Section, Values: string): IJcIniFile;
var
  vValues: TStrings;
  vI: Integer;
begin
  result := self;
  DeleteSection(Section);
  vValues := TStringList.Create;
  vValues.Text := Values;
  try
    for vI := 0 to vValues.Count-1 do
      self.AddString(Section, vValues.Names[vI], vValues.ValueFromIndex[vI]);
  finally
    vValues.Free;
  end;
end;

function TJcIniFile.AddString(const Section, Ident, Value: string): IJcIniFile;
begin
  result := self;
  FIniFile.WriteString(Section, Ident, Value);
end;

function TJcIniFile.AddInteger(const Section, Ident: string;
  Value: integer): IJcIniFile;
begin
  result := self;
  FIniFile.WriteInteger(Section, Ident, Value);
end;

function TJcIniFile.AddBoolean(const Section, Ident: string; Value: Boolean): IJcIniFile;
begin
   FIniFile.WriteBool(Section, Ident, Value);
   result := self;
end;

function TJcIniFile.DeleteKey(const Section, Ident: String): IJcIniFile;
begin
  FIniFile.DeleteKey(Section, Ident);
  result := self;
end;

function TJcIniFile.DeleteSection(const Section: String): IJcIniFile;
begin
  FIniFile.EraseSection(Section);
  result := self;
end;

function TJcIniFile.GetSections(var Sections: TStrings): IJcIniFile;
begin
  result := self;
  FIniFile.ReadSections(Sections);
end;

function TJcIniFile.GetSectionValues(const Section: String;
  Strings: TStrings): IJcIniFile;
begin
  result := self;
  FIniFile.ReadSectionValues(Section, Strings);
end;

function TJcIniFile.GetString(const Section, Ident, Default: string): string;
begin
  try
    Result := FIniFile.ReadString(Section, Ident, Default);
  except
    Result := Default;
  end;
end;

function TJcIniFile.GetInteger(const Section, Ident: string; Default: integer): integer;
begin
  Result := FIniFile.ReadInteger(Section, Ident, Default);
end;

function TJcIniFile.GetBoolean(const Section, Ident: string; Default: Boolean): Boolean;
begin
  try
    Result := FIniFile.ReadBool(Section, Ident, Default);
  except
    Result := Default;
  end;
end;

end.
