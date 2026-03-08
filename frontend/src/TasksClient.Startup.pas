unit TasksClient.Startup;

interface

type
  TAppStartup = class
  public
    class procedure Execute;
  end;

implementation

uses
  Vcl.Forms,
  System.SysUtils,
  TasksClient.Config,
  TasksClient.Client.Http,
  TasksClient.Client.Interfaces,
  TasksClient.Controller.Tasks,
  TasksClient.View.Main;

class procedure TAppStartup.Execute;
var
  LConfig: TClientConfig;
  LApiClient: ITaskApiClient;
  LController: TTaskController;
begin
  LConfig := TClientConfigLoader.Load;
  LApiClient := TTaskApiClient.Create(LConfig);

  LController := TTaskController.Create(LApiClient);
  try
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);

    frmMain.SetController(LController);

    Application.Run;
  finally
    LController.Free;
  end;
end;

end.
