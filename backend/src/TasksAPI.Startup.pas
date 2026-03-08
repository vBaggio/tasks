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
  TasksAPI.Conn.Interfaces, TasksAPI.Conn.Factory,
  TasksAPI.Repository.Interfaces, TasksAPI.Repository.Task,
  TasksAPI.Repository.User,
  TasksAPI.Service.Interfaces, TasksAPI.Service.Task,
  TasksAPI.Service.Auth,
  TasksAPI.Controller.Tasks,
  TasksAPI.Controller.ExceptionHandler;

const
  PORT = 9000;

class procedure TAppStartup.Execute;
var
  LController: TTaskController;
begin
  try
    WriteLn('Testando conexão inicial com o banco de dados...');
    TConnectionFactory.ConnMSSQL; // Initial test, will close naturally
    WriteLn('Conectado com sucesso. Pool habilitado.');

    //Middlewares
    THorse.Use(HandleException(ExceptionCallback));
    THorse.Use(HorseBasicAuthentication(
      function(const AUsername, APassword: string): Boolean
      var
        LAuthService: IAuthService;
      begin
        LAuthService := TAuthService.Create(TUserRepository.Create);
        Result := LAuthService.Validate(AUsername, APassword);
      end
    ));

    //Controller rest
    LController := TTaskController.Create;
    try
      LController.RegisterRoutes;

      WriteLn('Inicializando API na porta ' + PORT.ToString + '...');
      THorse.Listen(PORT);
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
