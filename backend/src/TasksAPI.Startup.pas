unit TasksAPI.Startup;

interface

type
  TAppStartup = class
  public
    class procedure Execute;
  end;

implementation

uses
  System.SysUtils, Horse, Horse.BasicAuthentication,
  TasksAPI.Conn.Interfaces, TasksAPI.Conn.Factory,
  TasksAPI.Repository.Interfaces, TasksAPI.Repository.Task,
  TasksAPI.Repository.User,
  TasksAPI.Service.Interfaces, TasksAPI.Service.Task,
  TasksAPI.Service.Auth,
  TasksAPI.Controller.Tasks;

const
  PORT = 9000;

class procedure TAppStartup.Execute;
var
  LConn: IConnection;
  LTaskRepository: ITaskRepository;
  LUserRepository: IUserRepository;
  LTaskService: ITaskService;
  LAuthService: IAuthService;
  LController: TTaskController;
begin
  try
    WriteLn('Conectando ao banco de dados...');
    LConn := TConnectionFactory.ConnMSSQL;
    WriteLn('Conectado com sucesso');

    LUserRepository := TUserRepository.Create;
    LAuthService := TAuthService.Create(LUserRepository);

    //middleware de autentica��o
    THorse.Use(HorseBasicAuthentication(
      function(const AUsername, APassword: string): Boolean
      begin
        Result := LAuthService.Validate(AUsername, APassword);
      end
    ));


    LTaskRepository := TTaskRepository.Create(LConn);
    LTaskService := TTaskService.Create(LTaskRepository);

    LTaskRepository := TTaskRepository.Create(LConn);
    LTaskService := TTaskService.Create(LTaskRepository);

    LController := TTaskController.Create(LTaskService);
    try
      LController.RegisterRoutes;

      WriteLn('Iniciando API na porta ' + PORT.ToString + '...');
      THorse.Listen(PORT);
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
