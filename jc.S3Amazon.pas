unit jc.S3Amazon;

interface

uses
  Classes, SysUtils, Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI, IPPeerClient;

type
  TAws = class
  private
    class var FInstance: TAws;

    FConnection: TAmazonConnectionInfo;
    FS3: TAmazonStorageService;
    FS3Region:  TAmazonRegion;
    FAccessKey: String;
    FSecretKey: String;

    FRegion: string;
    FEndPoint: string;
  public
    constructor create(const AccessKey, SecretKey: String);
    destructor destroy; override;
    class function New(): TAws; overload;
    class function New(const AccessKey, SecretKey: String): TAws; overload;

    function getEndPoint: String;
    function getRegion: String;
    function GetAmazonStorage: TAmazonStorageService;
    function getBuckets: TStrings;
    function getBucket(AName: String): TAmazonBucketResult;
    function DownloadObject(const ABucket, AFile, AOutPath: string): boolean;
    function UploadObject(const ABucket, AFile, AFileName: string): boolean;
    function DeleteObject(const ABucket, AFile: string): boolean;
  end;

implementation

Uses
  Jc.Utils;

{ TAws }

constructor TAws.create(const AccessKey, SecretKey: String);
begin
  FAccessKey := AccessKey;
  FSecretKey := SecretKey;

  FConnection := TAmazonConnectionInfo.Create(nil);
  FConnection.AccountName := FAccessKey;
  FConnection.AccountKey := FSecretKey;

  FS3 := TAmazonStorageService.Create(FConnection);
  FRegion        := TAmazonStorageService.GetRegionString(FS3Region);
  FEndPoint      := FConnection.StorageEndpoint;
end;

destructor TAws.destroy;
begin
  if Assigned(FConnection) then
    FreeAndNil(FConnection);

  if Assigned(FS3) then
    FreeAndNil(FS3);

  inherited;
end;

class function TAws.New(): TAws;
begin
  if not Assigned(FInstance) then
    raise Exception.Create('Primeiro, use o construtor new com parâmetros AccessKey e SecretKey');
  
  result := FInstance;
end;

class function TAws.New(const AccessKey, SecretKey: String): TAws;
begin
  if FInstance = nil then
    FInstance := TAws.Create(AccessKey, SecretKey);

  result := FInstance;
end;

function TAws.getEndPoint: String;
begin
  result := FendPoint;
end;

function TAws.getRegion: String;
begin
  Result := Fregion;
end;

function TAws.getBucket(AName: String): TAmazonBucketResult;
begin
  result := GetAmazonStorage.GetBucket(AName, nil);
end;

function TAws.getBuckets: TStrings;
var
  ResponseInfo : TCloudResponseInfo;
begin
  ResponseInfo := TCloudResponseInfo.Create;
  try
    result := GetAmazonStorage.ListBuckets(ResponseInfo);
  finally
    ResponseInfo.Free;
  end;
end;

function TAws.GetAmazonStorage: TAmazonStorageService;
begin
  result := FS3;
end;

function TAws.UploadObject(const ABucket, AFile, AFileName: string): boolean;
var
  FileContent   : TBytes;
  fReader       : TBinaryReader;
  Meta, Headers : TStringList;
begin
    //Cria o stream do arquivo para upload
    fReader := TBinaryReader.Create(AFile);
    try
      FileContent := fReader.ReadBytes(fReader.BaseStream.Size);
    finally
      fReader.Free;
    end;

    try
      //Prepara o upload
      try
        Meta    := TStringList.Create;
        Headers := TStringList.Create;

        if ExtractFileExt(AFileName) = '.pdf' then
          Headers.Add('Content-type=application/pdf')
        else if ExtractFileExt(AFileName) = '.jpg' then
          Headers.Add('Content-Type=image/jpeg')
        else if ExtractFileExt(AFileName) = '.png' then
          Headers.Add('Content-Type=image/png')
        else if ExtractFileExt(AFileName) = '.zip' then
          Headers.Add('Content-type=application/zip')
        else
          Meta.Add('Content-type=text/xml');

        //Faz o upload
        try
          GetAmazonStorage.UploadObject(ABucket, AFileName, FileContent, False, Meta, Headers, amzbaPublicRead);
          result := true;
        except
          on E:Exception do
          begin
            result := false;
            raise Exception.Create(e.Message);
          end;
        end;

      finally
        Meta.Free;
        Headers.Free;
      end;
    except
      on E:Exception do
      begin
        result := false;
        raise Exception.Create(e.Message);
      end;
    end;
end;



function TAws.DeleteObject(const ABucket, AFile: string): boolean;
begin
    try
      GetAmazonStorage.DeleteObject(ABucket, AFile);
      result := true;
    except
      on E:Exception do
      begin
        result := false;
        raise Exception.Create(e.Message);
      end;
    end;
end;

function TAws.DownloadObject(const ABucket, AFile, AOutPath: string): boolean;
var
  FStream : TStream;
  sFile   : String;
begin
  FStream := TMemoryStream.Create;
  try
    sFile := AFile;

    try
      //Download do arquivo para a vari�vei FStream
      GetAmazonStorage.GetObject(ABucket, sFile, FStream);
      FStream.Position := 0;

      //Permite selecionar a pasta
      TMemoryStream(FStream).SaveToFile(AOutPath + sFile);
      result := true;
    except
      result := false;
    end;
  finally
    FStream.Free;
  end;
end;

initialization

finalization
  if TAws.FInstance <> nil then
  begin
    TAws.FInstance.Free;
    TAws.FInstance := nil
  end;

end.
