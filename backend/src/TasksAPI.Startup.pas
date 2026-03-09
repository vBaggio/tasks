unit TasksAPI.Startup;

interface

type
  TAppStartup = class
  public
    class procedure Execute;
  end;

implementation

uses
  System.SysUtils, Horse, Horse.HandleException, Horse.BasicAuthentication,
  TasksAPI.Config, 
  TasksAPI.Conn.Interfaces, TasksAPI.Conn.Factory,
  TasksAPI.Repository.Interfaces, TasksAPI.Repository.Task,
  TasksAPI.Repository.User,
  TasksAPI.Service.Interfaces, TasksAPI.Service.Task,
  TasksAPI.Service.Auth,
  TasksAPI.Repository.Factory,
  TasksAPI.Service.Factory,
  TasksAPI.Controller.Tasks,
  TasksAPI.Controller.ExceptionHandler;

class procedure TAppStartup.Execute;
var
  LController: TTaskController;
  LConnFactory: IConnectionFactory;
  LRepFactory: IRepositoryFactory;
  LServiceFactory: IServiceFactory;
  LAppConfig: TAppConfig;
begin
  try
    LAppConfig := TConfigLoader.Load;
    LConnFactory := TConnectionFactory.Create(LAppConfig.Database);
    
    WriteLn('Testando conexão inicial e preparando tabelas do banco...');
    LConnFactory.SetupDatabase;
    WriteLn('Conectado com sucesso. Pool habilitado e tabelas prontas.');

    LRepFactory := TRepositoryFactory.Create(LConnFactory);
    LServiceFactory := TServiceFactory.Create(LRepFactory);

    //Middlewares
    THorse.Use(HandleException(ExceptionCallback));
    THorse.Use(HorseBasicAuthentication(
      function(const AUsername, APassword: string): Boolean
      var
        LAuthService: IAuthService;
      begin
        LAuthService := LServiceFactory.CreateAuthService;
        Result := LAuthService.Validate(AUsername, APassword);
      end
    ));

    LController := TTaskController.Create(LServiceFactory);
    try
      LController.RegisterRoutes;

      WriteLn('Inicializando API na porta ' + LAppConfig.Server.Port.ToString + '...');
      THorse.Listen(LAppConfig.Server.Port);
      WriteLn('Encerrando aplicação...');
    finally
      LController.Free;
    end;

  except
    on E: Exception do
    begin
      WriteLn('Erro fatal: ' + E.Message);
      ReadLn;
    end;
  end;
end;

end.
