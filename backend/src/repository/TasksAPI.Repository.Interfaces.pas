unit TasksAPI.Repository.Interfaces;

interface

uses
  System.Generics.Collections,
  TasksAPI.Model.Entity.Task,
  TasksAPI.Model.Entity.User,
  TasksAPI.Model.Dto.Stats;

{$M+}
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

  IUserRepository = interface
    ['{F1A2B3C4-D5E6-4789-ABCD-EF0123456789}']
    function FindByUsername(const AUsername: string): TUserModel;
    function Exists(const AUsername: string): Boolean;
  end;
{$M-}

implementation

end.
