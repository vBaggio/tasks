unit TasksAPI.Conn.MSSQL;

interface

uses
  FireDAC.Comp.Client,
  TasksAPI.Conn.Interfaces;

type
  TConnectionMSSQL = class(TInterfacedObject, IConnection)
  private
    FConnection: TFDConnection;
    FDatabaseName: string;
  public
    constructor Create(const AConfig: TConnectionConfig);
    destructor Destroy; override;
    function GetConn: TFDConnection;
    function DatabaseName: string;

    class function New(const AConfig: TConnectionConfig): IConnection;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Phys.MSSQL;

constructor TConnectionMSSQL.Create(const AConfig: TConnectionConfig);
begin
  inherited Create;
  FDatabaseName := AConfig.Database;
  FConnection := TFDConnection.Create(nil);
  FConnection.LoginPrompt := False;
  FConnection.Params.Clear;
  FConnection.Params.AddPair('DriverID', 'MSSQL');
  FConnection.Params.AddPair('Server', AConfig.Server);
  FConnection.Params.AddPair('Port', AConfig.Port);
  FConnection.Params.AddPair('Database', AConfig.Database);
  FConnection.Params.AddPair('User_Name', AConfig.UserName);
  FConnection.Params.AddPair('Password', AConfig.Password);
  FConnection.Params.AddPair('ConnectionTimeout', '5');
end;

destructor TConnectionMSSQL.Destroy;
begin
  FConnection.Free;
  inherited Destroy;
end;

function TConnectionMSSQL.GetConn: TFDConnection;
begin
  if not FConnection.Connected then
  begin
    FConnection.Connected := True;
    if not FConnection.Connected then
      raise Exception.CreateFmt(
        'Falha ao conectar ao banco de dados "%s". Verifique o servidor e as credenciais no arquivo .ini.',
        [FDatabaseName]
      );
  end;
  Result := FConnection;
end;

function TConnectionMSSQL.DatabaseName: string;
begin
  Result := FDatabaseName;
end;

class function TConnectionMSSQL.New(
  const AConfig: TConnectionConfig): IConnection;
begin
  Result := Self.Create(AConfig);
end;

end.
