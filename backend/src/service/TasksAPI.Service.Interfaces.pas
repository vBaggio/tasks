unit TasksAPI.Service.Interfaces;

interface

uses
  System.Generics.Collections,
  TasksAPI.Model.Entity.Task,
  TasksAPI.Model.Dto.Stats;

type
  ITaskService = interface
    ['{C4E2D3F5-A6B7-4890-ABCD-EF1234567890}']
    function ListAll: TObjectList<TTaskModel>;
    function GetById(AId: Integer): TTaskModel;
    function Add(ATask: TTaskModel): TTaskModel;
    procedure UpdateStatus(AId: Integer; AStatus: Integer);
    procedure Delete(AId: Integer);
    function GetStats: TTaskStatsDto;
  end;

  IAuthService = interface
    ['{A1B2C3D4-E5F6-4789-ABCD-123456789ABC}']
    function Validate(const AUsername, APassword: string): Boolean;
  end;

  IServiceFactory = interface
    ['{C0142A9B-20EE-4130-9ECA-2936220E15ED}']
    function CreateTaskService: ITaskService;
    function CreateAuthService: IAuthService;
  end;

implementation

end.
