unit TasksAPI.Conn.MSSQL;

interface

uses
  FireDAC.Comp.Client,
  TasksAPI.Conn.Interfaces;

type
  TConnectionMSSQL = class(TInterfacedObject, IConnection)
  private
    FConnection: TFDConnection;
    FConfig: TConnectionConfig;
  public
    constructor Create(const AConfig: TConnectionConfig; APooled: Boolean = True);
    destructor Destroy; override;

    function GetConn: TFDConnection;

    class function New(const AConfig: TConnectionConfig; APooled: Boolean = True): IConnection;
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

const
  CONNECTION_DEF_NAME = 'TasksAPI_MSSQL_Pool';

constructor TConnectionMSSQL.Create(const AConfig: TConnectionConfig; APooled: Boolean);
var
  LDef: IFDStanConnectionDef;
begin
  FConfig := AConfig;
  FConnection := TFDConnection.Create(nil);

  //Usa pool de conexões do firedac para performance e suportar alto volume de requisições mantendo a api stateless
  if APooled then
  begin
    if not FDManager.IsConnectionDef(CONNECTION_DEF_NAME) then
    begin
      LDef := FDManager.ConnectionDefs.AddConnectionDef;
      LDef.Name := CONNECTION_DEF_NAME;
      LDef.Params.AddPair('DriverID', 'MSSQL');
      LDef.Params.AddPair('Pooled', 'True');
      LDef.Params.AddPair('POOL_MaximumItems', '100');
      LDef.Params.AddPair('Server', AConfig.Server);
      LDef.Params.AddPair('Port', AConfig.Port);
      if AConfig.Database <> '' then
        LDef.Params.AddPair('Database', AConfig.Database);
      LDef.Params.AddPair('User_Name', AConfig.UserName);
      LDef.Params.AddPair('Password', AConfig.Password);
      LDef.Params.AddPair('ConnectionTimeout', '5');
      LDef.Apply;
    end;

    FConnection.ConnectionDefName := CONNECTION_DEF_NAME;
  end
  else
  begin
    FConnection.Params.Clear;
    FConnection.Params.AddPair('DriverID', 'MSSQL');
    FConnection.Params.AddPair('Server', AConfig.Server);
    FConnection.Params.AddPair('Port', AConfig.Port);
    if AConfig.Database <> '' then
      FConnection.Params.AddPair('Database', AConfig.Database);
    FConnection.Params.AddPair('User_Name', AConfig.UserName);
    FConnection.Params.AddPair('Password', AConfig.Password);
    FConnection.Params.AddPair('ConnectionTimeout', '5');
  end;

  FConnection.LoginPrompt := False;
end;

destructor TConnectionMSSQL.Destroy;
begin
  FConnection.Free;
  inherited;
end;

function TConnectionMSSQL.GetConn: TFDConnection;
begin
  if not FConnection.Connected then
  begin
    FConnection.Connected := True;
    if not FConnection.Connected then
      raise Exception.CreateFmt(
        'Falha ao conectar ao banco de dados "%s". Verifique o servidor e as credenciais no arquivo .ini.',
        [FConfig.Database]
      );
  end;
  Result := FConnection;
end;

class function TConnectionMSSQL.New(const AConfig: TConnectionConfig; APooled: Boolean): IConnection;
begin
  Result := Self.Create(AConfig, APooled);
end;

end.
