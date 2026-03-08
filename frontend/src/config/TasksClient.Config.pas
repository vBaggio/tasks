unit TasksClient.Config;

interface

type
  TClientConfig = record
    BaseUrl: string;
    Username: string;
    Password: string;
  end;

  TClientConfigLoader = class
  private
    class procedure CreateDefault(const AIniPath: string); static;
  public
    class function Load: TClientConfig; static;
  end;

implementation

uses
  System.SysUtils,
  System.IniFiles,
  System.IOUtils;

class procedure TClientConfigLoader.CreateDefault(const AIniPath: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(AIniPath);
  try
    LIniFile.WriteString('API', 'BaseUrl',  'http://localhost:9000');
    LIniFile.WriteString('API', 'Username', 'admin');
    LIniFile.WriteString('API', 'Password', '123456');
  finally
    LIniFile.Free;
  end;
end;

class function TClientConfigLoader.Load: TClientConfig;
var
  LIniPath: string;
  LIniFile: TIniFile;
begin
  LIniPath := ChangeFileExt(ParamStr(0), '.ini');
  if not TFile.Exists(LIniPath) then
    CreateDefault(LIniPath);

  LIniFile := TIniFile.Create(LIniPath);
  try
    Result.BaseUrl  := LIniFile.ReadString('API', 'BaseUrl',  'http://localhost:9000');
    Result.Username := LIniFile.ReadString('API', 'Username', 'admin');
    Result.Password := LIniFile.ReadString('API', 'Password', '123456');
  finally
    LIniFile.Free;
  end;
end;

end.
