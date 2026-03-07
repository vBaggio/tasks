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

implementation

end.
