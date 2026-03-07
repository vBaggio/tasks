unit TasksAPI.Database.Setup;

interface

uses
  TasksAPI.Conn.Interfaces;

type
  TDatabaseSetupMSSQL = class
  public
    class procedure Execute(
      const AMasterConnection: IConnection;
      const AAppConnection: IConnection); static;
  end;

implementation

uses
  System.SysUtils;

class procedure TDatabaseSetupMSSQL.Execute(const AMasterConnection: IConnection; const AAppConnection: IConnection);
var
  LDatabaseName: string;
  LSafeName: string;
begin
  LDatabaseName := AAppConnection.DatabaseName;
  LSafeName := StringReplace(LDatabaseName, ']', ']]', [rfReplaceAll]);

  AMasterConnection.GetConn.ExecSQL(
    'IF DB_ID(N''' + LDatabaseName + ''') IS NULL ' +
    'BEGIN EXEC(''CREATE DATABASE [' + LSafeName + ']'') END'
  );

  AAppConnection.GetConn.ExecSQL(
    'IF OBJECT_ID(N''dbo.tasks'', N''U'') IS NULL ' +
    'BEGIN ' +
    'CREATE TABLE dbo.tasks (' +
    'id INT IDENTITY(1,1) PRIMARY KEY, ' +
    'title VARCHAR(100) NOT NULL, ' +
    'description VARCHAR(500) NULL, ' +
    'status INT DEFAULT 0, ' +
    'priority INT NOT NULL, ' +
    'created_at DATETIME DEFAULT GETDATE(), ' +
    'completed_at DATETIME NULL' +
    ') ' +
    'END'
  );
end;

end.
