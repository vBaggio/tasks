unit TasksAPI.Conn.Factory;

interface

uses
  TasksAPI.Conn.Interfaces;

type
  TConnectionFactory = class(TInterfacedObject, IConnectionFactory)
  private
    FConfig: TConnectionConfig;
  public
    constructor Create(const AConfig: TConnectionConfig);

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

constructor TConnectionFactory.Create(const AConfig: TConnectionConfig);
begin
  FConfig := AConfig;
end;

function TConnectionFactory.CreateConnection: IConnection;
begin
  Result := TConnectionMSSQL.Create(FConfig);
end;

end.
