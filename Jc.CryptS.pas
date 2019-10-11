unit Jc.CryptS;

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TCryptS = class
  private
    class var FInstance: TCryptS;
  private
    FKey: string;
    FText: string;
    FCriptoBin: string;
    FCriptoHex: string;
    function Invert(SText: string): string;
    function DecToHex(Number: Byte): string;
    function HexToDec(Number: string): Byte;

    function TextToCriptoBin(SText: string): string;
    function TextToCriptoHex(SText: string): string;
    function CriptoBinToText(SText: string): string;
    function CriptoHexToText(SText: string): string;

    procedure PrivateCreate;
  public
    class function Instance(): TCryptS;

    function Crypt(AValue: String): String;
    function Decrypt(AValue: String): String;
  end;

implementation

class function TCryptS.Instance: TCryptS;
begin
  if FInstance = nil then
  begin
    FInstance := TCryptS.Create;

    FInstance.PrivateCreate;
  end;

  result := FInstance;
end;

procedure TCryptS.PrivateCreate;
begin
  FKey := 'YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4VZYW9KHJUI2347EJHJKDF3424SKL';
end;

function TCryptS.Crypt(AValue: String): String;
begin
  self.Instance;
  Result := FInstance.TextToCriptoHex(AValue)
end;

function TCryptS.Decrypt(AValue: String): String;
begin
  self.Instance;
  Result := FInstance.CriptoHexToText(AValue)
end;

function TCryptS.TextToCriptoBin(SText: string): string;
var
  SPos: Integer;
  BKey: Byte;
  S: string;
begin
  SText := Invert(SText);
  Result := '';
  for SPos := 1 to Length(SText) do
    begin
      S := Copy(FKey, (SPos mod Length(FKey)) + 1, 1);
      BKey := Ord(S[1]) + SPos;
      Result := Result + Chr(Ord(SText[SPos]) xor BKey);
    end;
end;

function TCryptS.CriptoBinToText(SText: string): string;
var
  SPos: Integer;
  BKey: Byte;
  S: string;
begin
  Result := '';
  for SPos := 1 to Length(SText) do
    begin
      S := Copy(FKey, (SPos mod Length(FKey)) + 1, 1);
      BKey := Ord(S[1]) + SPos;
      Result := Result + Chr(Ord(SText[SPos]) xor BKey);
    end;
  Result := Invert(Result);
end;

function TCryptS.TextToCriptoHex(SText: string): string;
var
  SPos: Integer;
begin
  SText := TextToCriptoBin(SText);
  Result := '';
  for SPos := 1 to Length(SText) do
    Result := Result + DecToHex(Ord(SText[SPos]));
end;

function TCryptS.CriptoHexToText(SText: string): string;
var
  SPos: Integer;
begin
  Result := '';
  for SPos := 1 to (Length(SText) div 2) do
    Result := Result + Chr(HexToDec(Copy(SText, ((SPos * 2) - 1), 2)));
  Result := CriptoBinToText(Result);
end;

function TCryptS.Invert(SText: string): string;
var
  Position: Integer;
begin
  Result := '';
  for Position := Length(SText) downto 1 do
    Result := Result + SText[Position];
end;

function TCryptS.DecToHex(Number: Byte): string;
begin
  Result := Copy('0123456789ABCDEF', (Number mod 16) + 1, 1);
  Number := Number div 16;
  Result := Copy('0123456789ABCDEF', (Number mod 16) + 1, 1) + Result
end;


function TCryptS.HexToDec(Number: string): Byte;
begin
  Number := UpperCase(Number);
  Result := (Pos(Number[1], '0123456789ABCDEF') - 1) * 16;
  Result := Result + (Pos(Number[2], '0123456789ABCDEF') - 1);
end;

initialization

finalization
  if TCryptS.FInstance <> nil then
  begin
    TCryptS.FInstance.Free;
    TCryptS.FInstance := nil;
  end;

end.
