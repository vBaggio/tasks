program TasksClient;

uses
  Vcl.Forms,
  TasksClient.Startup in 'src\TasksClient.Startup.pas',
  TasksClient.Config in 'src\config\TasksClient.Config.pas',
  TasksClient.Model.Dto.Task in 'src\model\dto\TasksClient.Model.Dto.Task.pas',
  TasksClient.Model.Dto.Stats in 'src\model\dto\TasksClient.Model.Dto.Stats.pas',
  TasksClient.Model.Exceptions in 'src\model\exceptions\TasksClient.Model.Exceptions.pas',
  TasksClient.Client.Interfaces in 'src\client\TasksClient.Client.Interfaces.pas',
  TasksClient.Client.Http in 'src\client\TasksClient.Client.Http.pas',
  TasksClient.Controller.Tasks in 'src\controller\TasksClient.Controller.Tasks.pas',
  TasksClient.View.Main in 'src\view\TasksClient.View.Main.pas' {frmMain},
  TasksClient.View.TaskCreate in 'src\view\TasksClient.View.TaskCreate.pas' {frmTaskCreate};

{$R *.res}

begin
  TAppStartup.Execute;
end.
