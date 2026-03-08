unit TasksAPI.Conn.Factory;

interface

uses
  TasksAPI.Conn.Config,
  TasksAPI.Conn.Interfaces;

type
  TConnectionFactory = class(TInterfacedObject, IConnectionFactory)
  private
    FConfig: TConnectionConfig;
  public
    constructor Create;

    procedure SetupDatabase;
    function CreateConnection: IConnection;
  end;

implementation

uses
  TasksAPI.Conn.MSSQL,
  TasksAPI.Database.SetupMSSQL;

procedure TConnectionFactory.SetupDatabase;
begin
  TDatabaseSetupMSSQL.Execute(FConfig);
  Self.CreateConnection; //inicializa o pool firedac
end;

constructor TConnectionFactory.Create;
begin
  FConfig := TConnectionConfigLoader.Load;
end;

function TConnectionFactory.CreateConnection: IConnection;
begin
  Result := TConnectionMSSQL.Create(FConfig);
end;

end.
