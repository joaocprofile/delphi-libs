unit jc.DCrypt;

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TJcDCrypt = class(TComponent)
  private
    FKey: string;
    FText: string;
    FCriptoBin: string;
    FCriptoHex: string;
    procedure SetText(Value: string);
    procedure SetKey(Value: string);
    procedure SetCriptoBin(Value: string);
    procedure SetCriptoHex(Value: string);
    function Invert(SText: string): string;
    function DecToHex(Number: Byte): string;
    function HexToDec(Number: string): Byte;
  public
    constructor Create(AOwner: TComponent); override;
    function TextToCriptoBin(SText: string): string;
    function TextToCriptoHex(SText: string): string;
    function CriptoBinToText(SText: string): string;
    function CriptoHexToText(SText: string): string;
  published
    property CriptoBin: string read FCriptoBin write SetCriptoBin;
    property CriptoHex: string read FCriptoHex write SetCriptoHex;
    property Key: string read FKey write SetKey;
    property Text: string read FText write SetText;
  end;

implementation

{$J+}

// Create
constructor TJcDCrypt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FKey := '0@#$%&1';
end;


// SetKey
procedure TJcDCrypt.SetKey(Value: string);
begin
  if FKey <> Value then
    begin
      FKey := Value;
      FText := '';
      FCriptoBin := '';
      FCriptoHex := '';
    end;
end;


// SetText
procedure TJcDCrypt.SetText(Value: string);
begin
  if FText <> Value then
    begin
      FText := Value;
      FCriptoBin := TextToCriptoBin(FText);
      FCriptoHex := TextToCriptoHex(FText);
    end;
end;


// SetCriptoBin
procedure TJcDCrypt.SetCriptoBin(Value: string);
begin
  if FCriptoBin <> Value then
    begin
      FCriptoBin := Value;
      FText := CriptoBinToText(FCriptoBin);
      FCriptoHex := TextToCriptoHex(FText);
    end;
end;


// SetCriptoHex
procedure TJcDCrypt.SetCriptoHex(Value: string);
begin
  if FCriptoHex <> Value then
    begin
      FCriptoHex := Value;
      FText := CriptoHexToText(FCriptoHex);
      FCriptoBin := TextToCriptoBin(FText);
    end;
end;


// TextToCriptoBin
function TJcDCrypt.TextToCriptoBin(SText: string): string;
var
  SPos: Integer;
  BKey: Byte;
  S: string;
begin
  // inverte texto
  SText := Invert(SText);
  // criptografa
  Result := '';
  for SPos := 1 to Length(SText) do
    begin
      S := Copy(FKey, (SPos mod Length(FKey)) + 1, 1);
      BKey := Ord(S[1]) + SPos;
      Result := Result + Chr(Ord(SText[SPos]) xor BKey);
    end;
end;


// CriptoBinToText
function TJcDCrypt.CriptoBinToText(SText: string): string;
var
  SPos: Integer;
  BKey: Byte;
  S: string;
begin
  Result := '';
  // converte
  for SPos := 1 to Length(SText) do
    begin
      S := Copy(FKey, (SPos mod Length(FKey)) + 1, 1);
      BKey := Ord(S[1]) + SPos;
      Result := Result + Chr(Ord(SText[SPos]) xor BKey);
    end;
  // inverte Result
  Result := Invert(Result);
end;


// TextToCriptoHex
function TJcDCrypt.TextToCriptoHex(SText: string): string;
var
  SPos: Integer;
begin
  SText := TextToCriptoBin(SText);
  // converte para hex
  Result := '';
  for SPos := 1 to Length(SText) do
    Result := Result + DecToHex(Ord(SText[SPos]));
end;


// CriptoHexToText
function TJcDCrypt.CriptoHexToText(SText: string): string;
var
  SPos: Integer;
begin
  Result := '';
  for SPos := 1 to (Length(SText) div 2) do
    Result := Result + Chr(HexToDec(Copy(SText, ((SPos * 2) - 1), 2)));
  // converte para texto
  Result := CriptoBinToText(Result);
end;


// Invert
function TJcDCrypt.Invert(SText: string): string;
var
  Position: Integer;
begin
  Result := '';
  for Position := Length(SText) downto 1 do
    Result := Result + SText[Position];
end;


// DecToHex
function TJcDCrypt.DecToHex(Number: Byte): string;
begin
  Result := Copy('0123456789ABCDEF', (Number mod 16) + 1, 1);
  Number := Number div 16;
  Result := Copy('0123456789ABCDEF', (Number mod 16) + 1, 1) + Result
end;


// HexToDec
function TJcDCrypt.HexToDec(Number: string): Byte;
begin
  Number := UpperCase(Number);
  Result := (Pos(Number[1], '0123456789ABCDEF') - 1) * 16;
  Result := Result + (Pos(Number[2], '0123456789ABCDEF') - 1);
end;

end.
