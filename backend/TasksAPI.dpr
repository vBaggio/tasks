program TasksAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  TasksAPI.Controller.Tasks in 'src\controller\TasksAPI.Controller.Tasks.pas',
  TasksAPI.Conn.Interfaces in 'src\conn\TasksAPI.Conn.Interfaces.pas',
  TasksAPI.Conn.Config in 'src\conn\TasksAPI.Conn.Config.pas',
  TasksAPI.Conn.MSSQL in 'src\conn\TasksAPI.Conn.MSSQL.pas',
  TasksAPI.Conn.Factory in 'src\conn\TasksAPI.Conn.Factory.pas',
  TasksAPI.Database.Setup in 'src\database\TasksAPI.Database.Setup.pas',
  TasksAPI.Model.Entity.Task in 'src\model\entity\TasksAPI.Model.Entity.Task.pas',
  TasksAPI.Model.Dto.Task in 'src\model\dto\TasksAPI.Model.Dto.Task.pas',
  TasksAPI.Repository.Interfaces in 'src\repository\TasksAPI.Repository.Interfaces.pas',
  TasksAPI.Service.Interfaces in 'src\service\TasksAPI.Service.Interfaces.pas';

const
  PORT = 9000;

begin
  WriteLn('Iniciando API na porta ' + PORT.ToString + '...');
  try
    try
      // Poderia ter sido implementado usando um script SQL, optei por criar
      // o schema e tabela via código para facilitar a execução do projeto
      TDatabaseSetupMSSQL.Execute(TConnectionFactory.MasterConn, TConnectionFactory.Conn);

      THorse.Get('/ping',
        procedure(Req: THorseRequest; Res: THorseResponse)
        begin
          Res.Send('pong');
        end);

      THorse.Listen(PORT);
    except
      on E: Exception do
      begin
        WriteLn('Erro inesperado: ' + E.ClassName + ' | ' + E.Message);
        Sleep(5000);
      end;

    end;
  finally
    WriteLn('Finalizando API...');
  end;

end.
