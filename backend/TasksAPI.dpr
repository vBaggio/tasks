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
  TasksAPI.Model.Dto.Stats in 'src\model\dto\TasksAPI.Model.Dto.Stats.pas',
  TasksAPI.Repository.Interfaces in 'src\repository\TasksAPI.Repository.Interfaces.pas',
  TasksAPI.Service.Interfaces in 'src\service\TasksAPI.Service.Interfaces.pas';

const
  PORT = 9000;

var
  LConn, LConnMaster: IConnection;
begin

  try
    WriteLn('Conectando ao banco de dados...');
    TDatabaseSetupMSSQL.Execute(TConnectionFactory.MasterConn, TConnectionFactory.Conn);
    WriteLn('Conectado com sucesso');

    WriteLn('Iniciando API na porta ' + PORT.ToString + '...');

    THorse.Get('/ping',
      procedure(Req: THorseRequest; Res: THorseResponse)
      begin
        Res.Send('pong');
      end);

    THorse.Listen(PORT);
  except
    on E: Exception do
    begin
      WriteLn('Erro fatal na inicialização: ' + E.Message);
      Readln; //Para o console não fechar quando ocorrer erro, permitindo ler a mensagem
    end;
  end;
end.
