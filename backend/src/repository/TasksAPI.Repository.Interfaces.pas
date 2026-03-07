unit TasksAPI.Repository.Interfaces;

interface

uses
  System.Generics.Collections,
  TasksAPI.Model.Entity.Task,
  TasksAPI.Model.Dto.Stats;

type
  ITaskRepository = interface
    ['{A3F1C2E4-B5D6-4789-9ABC-DEF012345678}']
    function FindAll: TObjectList<TTaskModel>;
    function FindById(AId: Integer): TTaskModel;
    function Insert(ATask: TTaskModel): Integer;
    procedure UpdateStatus(AId: Integer; AStatus: Integer);
    procedure Delete(AId: Integer);
    function GetStats: TTaskStatsDto;
    function TaskExists(AId: Integer): Boolean;
  end;

implementation

end.
