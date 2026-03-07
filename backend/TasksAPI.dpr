program TasksAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, Horse,
  TasksAPI.Controller.Tasks in 'src\TasksAPI.Controller.Tasks.pas';

begin
  WriteLn('Iniciando Api...');
  try
    try
      THorse.Get('/ping',
        procedure(Req: THorseRequest; Res: THorseResponse)
        begin
          Res.Send('pong');
        end);

      THorse.Listen(9000);
    except
      on E: Exception do
        WriteLn('ERRO INESPERADO: ' + E.ClassName + ' | ' + E.Message);

    end;
  finally
    WriteLn('Finalizando Api...');
  end;

end.
