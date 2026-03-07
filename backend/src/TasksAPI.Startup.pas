unit TasksAPI.Startup;

interface

type
  TAppStartup = class
  public
    class procedure Execute;
  end;

implementation

uses
  System.SysUtils, Horse,
  TasksAPI.Conn.Interfaces, TasksAPI.Conn.Factory,
  TasksAPI.Repository.Interfaces, TasksAPI.Repository.Task,
  TasksAPI.Service.Interfaces, TasksAPI.Service.Task,
  TasksAPI.Controller.Tasks;

const
  PORT = 9000;

class procedure TAppStartup.Execute;
var
  LConn: IConnection;
  LRepository: ITaskRepository;
  LService: ITaskService;
  LController: TTaskController;
begin
  try
    WriteLn('Conectando ao banco de dados...');
    LConn := TConnectionFactory.ConnMSSQL;
    WriteLn('Conectado com sucesso');

    LRepository := TTaskRepository.Create(LConn);
    LService := TTaskService.Create(LRepository);

    LController := TTaskController.Create(LService);
    LController.RegisterRoutes;

    WriteLn('Iniciando API na porta ' + PORT.ToString + '...');
    THorse.Listen(PORT);
  except
    on E: Exception do
    begin
      WriteLn('Erro fatal: ' + E.Message);
      ReadLn;
    end;
  end;
end;

end.
