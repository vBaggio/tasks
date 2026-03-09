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
    //Carrega as configurações .ini
    LAppConfig := TConfigLoader.Load;
    
    LConnFactory := TConnectionFactory.Create(LAppConfig.Database);
    
    WriteLn('Testando conexão inicial e preparando tabelas do banco...');
    LConnFactory.SetupDatabase;
    WriteLn('Conectado com sucesso. Pool habilitado e tabelas prontas.');

    LRepFactory := TRepositoryFactory.Create(LConnFactory);
    LServiceFactory := TServiceFactory.Create(LRepFactory);

    //Middleware Exception Handler para definir o padrão de resposta de erros
    THorse.Use(HandleException(
      procedure (const E: Exception; const Req: THorseRequest; const Res: THorseResponse; var ASendException: Boolean)
      begin
        TExceptionHandler.Handle(E, Req, Res, ASendException);
      end
    ));
    
    //Middleware de Autenticação Básica
    THorse.Use(HorseBasicAuthentication(
      function(const AUsername, APassword: string): Boolean
      var
        LAuthService: IAuthService;
      begin
        LAuthService := LServiceFactory.CreateAuthService;
        Result := LAuthService.Validate(AUsername, APassword);
      end
    ));

    //Controller para gerenciar as rotas da api, recebe a factory de serviços como injeção de dependência
    LController := TTaskController.Create(LServiceFactory);
    try
      //Registra as rotas da api no horse
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
