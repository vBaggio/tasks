unit TasksClient.Client.Interfaces;

interface

uses
  TasksClient.Model.Dto.Task,
  TasksClient.Model.Dto.Stats;

type
  ITaskApiClient = interface
    ['{A3F8C2D1-4B7E-4A9F-8C3D-1E5F2A6B7C8D}']
    function ListAll: TArray<TTaskResponseDto>;
    function CreateTask(const ARequest: TCreateTaskRequestDto): TTaskResponseDto;
    procedure UpdateStatus(AId: Integer; AStatus: Integer);
    procedure Delete(AId: Integer);
    function GetStats: TTaskStatsDto;
  end;

implementation

end.
