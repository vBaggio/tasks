unit TasksAPI.Conn.Factory;

interface

uses
  TasksAPI.Conn.Interfaces;

type
  TConnectionFactory = class
  public
    class function Conn: IConnection;
    class function MasterConn: IConnection;
  end;

implementation

uses
  TasksAPI.Conn.Config,
  TasksAPI.Conn.MSSQL;

class function TConnectionFactory.Conn: IConnection;
begin
  Result := TConnectionMSSQL.Create(TConnectionConfigLoader.Load);
end;

class function TConnectionFactory.MasterConn: IConnection;
var
  LConfig: TConnectionConfig;
begin
  LConfig := TConnectionConfigLoader.Load;
  LConfig.Database := 'master';
  Result := TConnectionMSSQL.Create(LConfig);
end;

end.
