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

Function UltimoDiaDoMes(AData: TDateTime): TDateTime;
var
  A, M, D: Word;
  sMes: string;
  sAno: string;
begin
  DecodeDate(AData, A, M, D);
  sMes := FormatFloat('00', M);
  sAno := FormatFloat('0000', A);

  if Pos( sMes, '01 03 05 07 08 10 12' ) > 0 then
    D := 31
  else
  begin
    if sMes <> '02' then
      D := 30
    else
    begin
      if ( StrToInt( sAno ) mod 4 ) = 0 then
        D := 29
      else
        D := 28;
    end;
  end;

  Result := EncodeDate(A, M, D);
end;

Function PrimeiroDiaDoMes(AData: TDateTime ) : TDateTime;
Var
  A, M, D : word;
begin
  DecodeDate(AData, A, M, D);
  Result := StrToDate(IntToStr(D-D+1) + '/' + IntToStr(M) + '/' + IntToStr(A));
end;

function IdadeExtenso(DataNasc: TDateTime): String;
Var
  CalcIdade       : Double;
  Ano, sA, sM, sD : String;
  A, M, D         : Word;
begin
   CalcIdade := ( Date - DataNasc);
   DecodeDate(CalcIdade, A, M, D);
   Dec(M);
   Ano := IntToStr(A);
   Delete(Ano,1,2);

   if A > 1 then
    sA := 'Anos'
  else
    sA := 'Ano';

  if M > 1 then
    sM := 'Meses'
  else
    sM := 'Mes';

  if D > 1 then
    sD := 'Dias'
  else
    sD := 'Dia';

  if Ano <> '00' then
    Result := Ano+' '+sA;
  if M > 0 then
    Result := Result + ' '+IntToStr(M)+' '+sM;
  if D > 0 then
    Result := Result + ' '+IntToStr(D)+' '+sD;
end;

function CalculaIdade(A, M, D: Word) : TDateTime;
Var
  Data: TDateTime;
begin
  Data := Date;
  Data := IncYear(IncMonth(Data - D, M * -1), A * -1);
  Result := Data;
end;

end.
