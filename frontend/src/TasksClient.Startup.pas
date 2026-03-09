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
  //Carrega do .ini
  LConfig := TClientConfigLoader.Load;

  { Client HTTP responsável por se comunicar com o backend através do RESTRequest4D,
    utiliza a biblioteca Neon para serializar/desserializar as requisições e respostas }
  LApiClient := TTaskApiClient.Create(LConfig);

  //Intermediário entre o client http e a view
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
