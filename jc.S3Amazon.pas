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

    FendPoint: string;
    Fregion: string;

    procedure PrivateDestroy;
    procedure PrivateCreate;
  public
    class function Instance: TAws;

    function getEndPoint: String;
    function getS3: TAmazonStorageService;
    function key(const AccessKey, SecretKey: String): TAws;

    function getBuckets: TStrings;
    function getBucket(AName: String): TAmazonBucketResult;

    function DownloadObject(const ABucket, AFile, AOutPath: string): boolean;
    function UploadObject(const ABucket, AFile, AFileName: string): boolean;
    function DeleteObject(const ABucket, AFile: string): boolean;
  end;

const
  AccessKeyDefault = 'AKIAI2CQTPN44I3LQSSQ';
  SecretKeyDefault = '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';

implementation

Uses
  SIGData.Utils;

{ TAws }

class function TAws.Instance: TAws;
begin
  if FInstance = nil then
  begin
    FInstance := TAws.Create;
    FInstance.PrivateCreate;
  end;

  result := FInstance;
end;

procedure TAws.PrivateCreate;
begin
  FConnection := TAmazonConnectionInfo.Create(nil);
  FConnection.AccountName := AccessKeyDefault;
  FConnection.AccountKey := SecretKeyDefault;

  FS3 := TAmazonStorageService.Create(FConnection);
  FRegion := TAmazonStorageService.GetRegionString(FS3Region);
  FendPoint := FConnection.StorageEndpoint;
end;

procedure TAws.PrivateDestroy;
begin
  if Assigned(FConnection) then
    FreeAndNil(FConnection);

  if Assigned(FS3) then
    FreeAndNil(FS3);
end;

function TAws.key(const AccessKey, SecretKey: String): TAws;
begin
  FConnection.AccountName := AccessKey;
  FConnection.AccountKey := SecretKey;
  result := FInstance;
end;

function TAws.getBucket(AName: String): TAmazonBucketResult;
begin
  result := getS3.GetBucket(AName, nil);
end;

function TAws.getBuckets: TStrings;
var
  ResponseInfo : TCloudResponseInfo;
begin
  ResponseInfo := TCloudResponseInfo.Create;
  try
    result := getS3.ListBuckets(ResponseInfo);
  finally
    ResponseInfo.Free;
  end;
end;

function TAws.getEndPoint: String;
begin
  result := FendPoint;
end;

function TAws.getS3: TAmazonStorageService;
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
        else
          Meta.Add('Content-type=text/xml');

        //Faz o upload
        try
          getS3.UploadObject(ABucket, AFileName, FileContent, False, Meta, Headers, amzbaPublicRead);
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
      getS3.DeleteObject(ABucket, AFile);
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
      //Download do arquivo para a variávei FStream
      getS3.GetObject(ABucket, sFile, FStream);
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
    TAws.FInstance.PrivateDestroy;
    TAws.FInstance.Free;
    TAws.FInstance := nil
  end;

end.
