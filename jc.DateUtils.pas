unit jc.DateUtils;

interface

uses
  Windows, Messages, SysUtils, Classes, DateUtils;

  function DateToText(ADate: TDateTime): string;
  Function DateTimeToText(ADateTime: TDateTime): string;
  function TextToDate(ADate: string): TDateTime;

implementation

function DateToText(ADate: TDateTime): string;
begin
  if ADate > 0 then
    Result := FormatDateTime('YYYY-MM-DD',ADate)
  else
    Result := '0000-00-00';
end;

Function DateTimeToText(ADateTime: TDateTime): string;
begin
  if ADateTime > 0 then
    Result := FormatDateTime('YYYY-MM-DDTHH:MM:SEG', ADateTime)
  else
    Result := '0000-00-00T00:00:00';
end;

Function DateToTextBr(ADate: TDateTime): string;
begin
  if ADate > 0 then
    Result := FormatDateTime('DD-MM-YYYY', ADate)
  else
    Result := '00-00-0000';
end;

Function DateToDateTime(ADate: TDateTime): TDateTime;
var
  Dia, Mes, Ano, Hor, Min, Seg, Mis: Word;
begin
  if (ADate > 0) then
  begin
    DecodeDateTime(Now, Ano, Mes, Dia, Hor, Min, Seg, Mis);
    DecodeDate(ADate, Ano, Mes, Dia);
    Result := EncodeDateTime(Ano, Mes, Dia, Hor, Min, Seg, 0);
  end
  else
    Result := 0;
end;

function TextToDate(ADate: string): TDateTime;
var
  Dia, Mes, Ano: Integer;
begin
  if (ADate <> '') AND (ADate <> '0000-00-00') then
  begin
    Dia := StrToInt(Copy(ADate,9,2));
    Mes := StrToInt(Copy(ADate,6,2));
    Ano := StrToInt(Copy(ADate,1,4));
    Result := EncodeDate(Ano,Mes,Dia);
  end
  else
    Result := 0;
end;

function TextToDateTime(ADateTime: string): TDateTime;
var
  Dia, Mes, Ano, Hor, Min, Seg: Integer;
begin
  if (ADateTime <> '') AND (ADateTime <> '0000-00-00T00:00:00') then
  begin
    Dia := StrToInt(Copy(ADateTime,9,2));
    Mes := StrToInt(Copy(ADateTime,6,2));
    Ano := StrToInt(Copy(ADateTime,1,4));
    Hor := StrToInt(Copy(ADateTime,12,2));
    Min := StrToInt(Copy(ADateTime,15,2));
    Seg := StrToInt(Copy(ADateTime,18,2));
    Result := EncodeDateTime(Ano,Mes,Dia, Hor, Min, Seg, 0);
  end
  else
    Result := 0;
end;

end.
