program TasksAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  TasksAPI.Startup in 'src\TasksAPI.Startup.pas',
  TasksAPI.Controller.Tasks in 'src\controller\TasksAPI.Controller.Tasks.pas',
  TasksAPI.Conn.Interfaces in 'src\infra\conn\TasksAPI.Conn.Interfaces.pas',
  TasksAPI.Config in 'src\infra\config\TasksAPI.Config.pas',
  TasksAPI.Conn.MSSQL in 'src\infra\conn\TasksAPI.Conn.MSSQL.pas',
  TasksAPI.Conn.Factory in 'src\infra\conn\TasksAPI.Conn.Factory.pas',
  TasksAPI.Repository.Factory in 'src\repository\TasksAPI.Repository.Factory.pas',
  TasksAPI.Service.Factory in 'src\service\TasksAPI.Service.Factory.pas',
  TasksAPI.Database.SetupMSSQL in 'src\infra\database\TasksAPI.Database.SetupMSSQL.pas',
  TasksAPI.Model.Entity.Task in 'src\model\entity\TasksAPI.Model.Entity.Task.pas',
  TasksAPI.Model.Dto.Task in 'src\model\dto\TasksAPI.Model.Dto.Task.pas',
  TasksAPI.Model.Dto.Stats in 'src\model\dto\TasksAPI.Model.Dto.Stats.pas',
  TasksAPI.Repository.Interfaces in 'src\repository\TasksAPI.Repository.Interfaces.pas',
  TasksAPI.Repository.Task in 'src\infra\repository\TasksAPI.Repository.Task.pas',
  TasksAPI.Service.Interfaces in 'src\service\TasksAPI.Service.Interfaces.pas',
  TasksAPI.Service.Task in 'src\service\TasksAPI.Service.Task.pas',
  TasksAPI.Service.Auth in 'src\service\TasksAPI.Service.Auth.pas',
  TasksAPI.Model.Entity.User in 'src\model\entity\TasksAPI.Model.Entity.User.pas',
  TasksAPI.Model.Exceptions in 'src\model\TasksAPI.Model.Exceptions.pas',
  TasksAPI.Repository.User in 'src\infra\repository\TasksAPI.Repository.User.pas',
  TasksAPI.Controller.ExceptionHandler in 'src\controller\TasksAPI.Controller.ExceptionHandler.pas';

begin
  TAppStartup.Execute;
end.
