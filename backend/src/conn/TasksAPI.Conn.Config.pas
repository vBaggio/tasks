unit TasksAPI.Conn.Config;

interface

uses
  TasksAPI.Conn.Interfaces;

type
  TConnectionConfigLoader = class
  private
    class procedure CreateDefault(const AIniPath: string); static;
  public
    class function Load: TConnectionConfig; static;
  end;

implementation

uses
  System.SysUtils,
  System.IniFiles,
  System.IOUtils;

class procedure TConnectionConfigLoader.CreateDefault(const AIniPath: string);
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
  finally
    LIniFile.Free;
  end;
  WriteLn('Arquivo de configuracao criado com valores padrao: ' + AIniPath);
end;

class function TConnectionConfigLoader.Load: TConnectionConfig;
var
  LIniPath: string;
  LIniFile: TIniFile;
begin
  LIniPath := ChangeFileExt(ParamStr(0), '.ini');
  if not TFile.Exists(LIniPath) then
    CreateDefault(LIniPath);

  LIniFile := TIniFile.Create(LIniPath);
  try
    Result.Server   := LIniFile.ReadString('Database', 'Server',   'localhost');
    Result.Port     := LIniFile.ReadString('Database', 'Port',     '1433');
    Result.Database := LIniFile.ReadString('Database', 'Database', 'TaskDB');
    Result.UserName := LIniFile.ReadString('Database', 'UserName', 'sa');
    Result.Password := LIniFile.ReadString('Database', 'Password', 'MasterPassword@2026');
  finally
    LIniFile.Free;
  end;
end;

end.
