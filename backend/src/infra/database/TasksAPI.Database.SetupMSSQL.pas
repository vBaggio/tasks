unit TasksAPI.Database.SetupMSSQL;

interface

uses
  TasksAPI.Conn.Interfaces;

type
  TDatabaseSetupMSSQL = class
  public
    class procedure Execute(const AConfig: TConnectionConfig); static;
  end;

implementation

uses
  System.SysUtils,
  TasksAPI.Conn.MSSQL;

class procedure TDatabaseSetupMSSQL.Execute(const AConfig: TConnectionConfig);
var
  LSetupConfig: TConnectionConfig;
  LAppConn, LSetupConn: IConnection;
  LDatabase: string;
begin
  LDatabase := AConfig.Database;

  LSetupConfig := AConfig;
  LSetupConfig.Database := '';
  try
    //Cria banco de dados (schema) caso não exista
    //Passando APooled=False para nao registrar no Pool
    LSetupConn := TConnectionMSSQL.Create(LSetupConfig, False);
    LSetupConn.GetConn.ExecSQL(
      'IF DB_ID(N''' + LDatabase + ''') IS NULL ' +
      'BEGIN EXEC(''CREATE DATABASE [' + LDatabase + ']'') END'
    );
  except
    on E: Exception do
      WriteLn('Aviso: n'+#227+'o foi possivel verificar/criar o banco "' + LDatabase + '": ' + E.Message);
  end;

  //Cria tabela caso não exista
  //Passando APooled=False para nao registrar no Pool
  LAppConn := TConnectionMSSQL.Create(AConfig, False);
  LAppConn.GetConn.ExecSQL(
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
