unit TasksAPI.Conn.Factory;

interface

uses
  TasksAPI.Conn.Interfaces;

type
  TConnectionFactory = class
  public
    class function ConnMSSQL: IConnection;
  end;

implementation

uses
  TasksAPI.Conn.Config,
  TasksAPI.Conn.MSSQL,
  TasksAPI.Database.SetupMSSQL;

class function TConnectionFactory.ConnMSSQL: IConnection;
var
  LConfig: TConnectionConfig;
begin
  LConfig := TConnectionConfigLoader.Load;
  TDatabaseSetupMSSQL.Execute(LConfig);
  Result := TConnectionMSSQL.Create(LConfig);
end;

end.
