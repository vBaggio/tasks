unit TasksAPI.Config;

interface

uses
  TasksAPI.Conn.Interfaces;

type
  TServerConfig = record
    Port: Integer;
  end;

  TAppConfig = record
    Database: TConnectionConfig;
    Server: TServerConfig;
  end;

  TConfigLoader = class
  private
    class procedure CreateDefault(const AIniPath: string); static;
  public
    class function Load: TAppConfig; static;
  end;

implementation

uses
  System.SysUtils,
  System.IniFiles,
  System.IOUtils;

class procedure TConfigLoader.CreateDefault(const AIniPath: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(AIniPath);
  try
    LIniFile.WriteString('Database', 'Server',   'localhost');
    LIniFile.WriteString('Database', 'Port',     '1433');
    LIniFile.WriteString('Database', 'Database', 'TaskDB');
    LIniFile.WriteString('Database', 'UserName', 'sa');
    LIniFile.WriteString('Database', 'Password', 'MasterPassword@2026');

    LIniFile.WriteInteger('Server', 'Port', 9000);
  finally
    LIniFile.Free;
  end;
  WriteLn('Arquivo de configuracao criado com valores padrao: ' + AIniPath);
end;

class function TConfigLoader.Load: TAppConfig;
var
  LIniPath: string;
  LIniFile: TIniFile;
begin
  LIniPath := ChangeFileExt(ParamStr(0), '.ini');
  if not TFile.Exists(LIniPath) then
    CreateDefault(LIniPath);

  LIniFile := TIniFile.Create(LIniPath);
  try
    Result.Database.Server   := LIniFile.ReadString('Database', 'Server',   'localhost');
    Result.Database.Port     := LIniFile.ReadString('Database', 'Port',     '1433');
    Result.Database.Database := LIniFile.ReadString('Database', 'Database', 'TaskDB');
    Result.Database.UserName := LIniFile.ReadString('Database', 'UserName', 'sa');
    Result.Database.Password := LIniFile.ReadString('Database', 'Password', 'MasterPassword@2026');

    Result.Server.Port := LIniFile.ReadInteger('Server', 'Port', 9000);
  finally
    LIniFile.Free;
  end;
end;

end.
