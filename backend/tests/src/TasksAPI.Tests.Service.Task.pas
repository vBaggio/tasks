unit TasksAPI.Tests.Service.Task;

interface

uses
  DUnitX.TestFramework,
  Delphi.Mocks,
  System.Rtti,
  System.Generics.Collections,
  TasksAPI.Service.Task,
  TasksAPI.Service.Interfaces,
  TasksAPI.Repository.Interfaces,
  TasksAPI.Model.Entity.Task,
  TasksAPI.Model.Dto.Stats,
  TasksAPI.Model.Exceptions;

type
  [TestFixture]
  TTaskServiceTest = class(TObject)
  private
    FMockRepo: TMock<ITaskRepository>;
    FService: ITaskService;
    function CreateTask(const ATitle: string; APriority: Integer): TTaskModel;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Add_EmptyTitle_RaisesValidationException;
    [Test]
    procedure Add_BlankTitle_RaisesValidationException;
    [Test]
    procedure Add_TitleTooLong_RaisesValidationException;
    [Test]
    procedure Add_DescriptionTooLong_RaisesValidationException;
    [Test]
    procedure Add_PriorityBelowMin_RaisesValidationException;
    [Test]
    procedure Add_PriorityAboveMax_RaisesValidationException;
    [Test]
    procedure Add_ValidTask_SetsPendingStatus;
    [Test]
    procedure Add_ValidTask_ReturnsInsertedTask;

    [Test]
    procedure GetById_ExistingId_ReturnsTask;
    [Test]
    procedure GetById_UnknownId_RaisesNotFoundException;

    [Test]
    procedure UpdateStatus_InvalidValue_RaisesValidationException;
    [Test]
    procedure UpdateStatus_UnknownTask_RaisesNotFoundException;
    [Test]
    procedure UpdateStatus_ValidData_Succeeds;

    [Test]
    procedure Delete_UnknownTask_RaisesNotFoundException;
    [Test]
    procedure Delete_ExistingTask_Succeeds;

    [Test]
    procedure ListAll_ReturnsRepositoryResult;
    [Test]
    procedure GetStats_ReturnsRepositoryResult;
  end;

implementation

{ TTaskServiceTest }

function TTaskServiceTest.CreateTask(const ATitle: string; APriority: Integer): TTaskModel;
begin
  Result := TTaskModel.Create;
  Result.Title := ATitle;
  Result.Priority := APriority;
end;

procedure TTaskServiceTest.Setup;
begin
  FMockRepo := TMock<ITaskRepository>.Create;
  FService := TTaskService.Create(FMockRepo);
end;

procedure TTaskServiceTest.TearDown;
begin
  FService := nil;
end;

procedure TTaskServiceTest.Add_EmptyTitle_RaisesValidationException;
var
  LNewTask: TTaskModel;
begin
  LNewTask := CreateTask('', 1);
  try
    Assert.WillRaise(
      procedure
      begin
        FService.Add(LNewTask);
      end,
      EValidationException
    );
  finally
    LNewTask.Free;
  end;
end;

procedure TTaskServiceTest.Add_BlankTitle_RaisesValidationException;
var
  LNewTask: TTaskModel;
begin
  LNewTask := CreateTask('   ', 1);
  try
    Assert.WillRaise(
      procedure
      begin
        FService.Add(LNewTask);
      end,
      EValidationException
    );
  finally
    LNewTask.Free;
  end;
end;

procedure TTaskServiceTest.Add_TitleTooLong_RaisesValidationException;
var
  LNewTask: TTaskModel;
begin
  LNewTask := CreateTask(StringOfChar('X', 101), 1);
  try
    Assert.WillRaise(
      procedure
      begin
        FService.Add(LNewTask);
      end,
      EValidationException
    );
  finally
    LNewTask.Free;
  end;
end;

procedure TTaskServiceTest.Add_DescriptionTooLong_RaisesValidationException;
var
  LNewTask: TTaskModel;
begin
  LNewTask := CreateTask('Valid title', 1);
  LNewTask.Description := StringOfChar('D', 501);
  try
    Assert.WillRaise(
      procedure
      begin
        FService.Add(LNewTask);
      end,
      EValidationException
    );
  finally
    LNewTask.Free;
  end;
end;

procedure TTaskServiceTest.Add_PriorityBelowMin_RaisesValidationException;
var
  LNewTask: TTaskModel;
begin
  LNewTask := CreateTask('Valid title', 0);
  try
    Assert.WillRaise(
      procedure
      begin
        FService.Add(LNewTask);
      end,
      EValidationException
    );
  finally
    LNewTask.Free;
  end;
end;

procedure TTaskServiceTest.Add_PriorityAboveMax_RaisesValidationException;
var
  LNewTask: TTaskModel;
begin
  LNewTask := CreateTask('Valid title', 4);
  try
    Assert.WillRaise(
      procedure
      begin
        FService.Add(LNewTask);
      end,
      EValidationException
    );
  finally
    LNewTask.Free;
  end;
end;

procedure TTaskServiceTest.Add_ValidTask_SetsPendingStatus;
var
  LNewTask, LPersistedTask, LReturned: TTaskModel;
begin
  LNewTask := CreateTask('Valid title', 2);
  LNewTask.Status := Ord(tsCompleted);

  LPersistedTask := TTaskModel.Create;
  LPersistedTask.Id := 1;

  LReturned := nil;
  try
    FMockRepo.Setup.WillReturn(TValue.From<Integer>(1)).When.Insert(It(0).IsAny<TTaskModel>());
    FMockRepo.Setup.WillReturn(TValue.From<TTaskModel>(LPersistedTask)).When.FindById(1);

    LReturned := FService.Add(LNewTask);

    Assert.AreEqual(Ord(tsPending), LNewTask.Status);
  finally
    LNewTask.Free;
    LReturned.Free;
  end;
end;

procedure TTaskServiceTest.Add_ValidTask_ReturnsInsertedTask;
var
  LNewTask, LPersistedTask, LReturned: TTaskModel;
begin
  LNewTask := CreateTask('Valid title', 2);

  LPersistedTask := TTaskModel.Create;
  LPersistedTask.Id := 5;
  LPersistedTask.Title := 'Valid title';

  LReturned := nil;
  try
    FMockRepo.Setup.WillReturn(TValue.From<Integer>(5)).When.Insert(It(0).IsAny<TTaskModel>());
    FMockRepo.Setup.WillReturn(TValue.From<TTaskModel>(LPersistedTask)).When.FindById(5);

    LReturned := FService.Add(LNewTask);

    Assert.AreEqual(5, LReturned.Id);
    Assert.AreEqual('Valid title', LReturned.Title);
  finally
    LNewTask.Free;
    LReturned.Free;
  end;
end;

procedure TTaskServiceTest.GetById_ExistingId_ReturnsTask;
var
  LPersistedTask, LReturned: TTaskModel;
begin
  LPersistedTask := TTaskModel.Create;
  LPersistedTask.Id := 3;

  LReturned := nil;
  try
    FMockRepo.Setup.WillReturn(TValue.From<TTaskModel>(LPersistedTask)).When.FindById(3);

    LReturned := FService.GetById(3);

    Assert.AreEqual(3, LReturned.Id);
  finally
    LReturned.Free;
  end;
end;

procedure TTaskServiceTest.GetById_UnknownId_RaisesNotFoundException;
begin
  FMockRepo.Setup.WillReturnNil.When.FindById(It(0).IsAny<Integer>());
  Assert.WillRaise(
    procedure
    begin
      FService.GetById(999);
    end,
    ENotFoundException
  );
end;

procedure TTaskServiceTest.UpdateStatus_InvalidValue_RaisesValidationException;
begin
  Assert.WillRaise(
    procedure
    begin
      FService.UpdateStatus(1, 99);
    end,
    EValidationException
  );
end;

procedure TTaskServiceTest.UpdateStatus_UnknownTask_RaisesNotFoundException;
begin
  FMockRepo.Setup.WillReturn(TValue.From<Boolean>(False)).When.TaskExists(It(0).IsAny<Integer>());

  Assert.WillRaise(
    procedure
    begin
      FService.UpdateStatus(999, Ord(tsCompleted));
    end,
    ENotFoundException
  );
end;

procedure TTaskServiceTest.UpdateStatus_ValidData_Succeeds;
begin
  FMockRepo.Setup.WillReturn(TValue.From<Boolean>(True)).When.TaskExists(It(0).IsAny<Integer>());

  FService.UpdateStatus(1, Ord(tsCompleted));

  Assert.Pass;
end;

procedure TTaskServiceTest.Delete_UnknownTask_RaisesNotFoundException;
begin
  FMockRepo.Setup.WillReturn(TValue.From<Boolean>(False)).When.TaskExists(It(0).IsAny<Integer>());
  Assert.WillRaise(
    procedure
    begin
      FService.Delete(999);
    end,
    ENotFoundException
  );
end;

procedure TTaskServiceTest.Delete_ExistingTask_Succeeds;
begin
  FMockRepo.Setup.WillReturn(TValue.From<Boolean>(True)).When.TaskExists(It(0).IsAny<Integer>());

  FService.Delete(1);

  Assert.Pass;
end;

procedure TTaskServiceTest.ListAll_ReturnsRepositoryResult;
var
  LResult: TObjectList<TTaskModel>;
begin
  FMockRepo.Setup.WillReturn(TValue.From<TObjectList<TTaskModel>>(TObjectList<TTaskModel>.Create(True))).When.FindAll;

  LResult := nil;
  try
    LResult := FService.ListAll;

    Assert.IsNotNull(LResult);
  finally
    LResult.Free;
  end;
end;

procedure TTaskServiceTest.GetStats_ReturnsRepositoryResult;
var
  LStub, LReturned: TTaskStatsDto;
begin
  LStub.TotalCount := 10;
  LStub.AveragePriorityPending := 2.5;
  LStub.CompletedLastSevenDays := 3;

  FMockRepo.Setup.WillReturn(TValue.From<TTaskStatsDto>(LStub)).When.GetStats;

  LReturned := FService.GetStats;

  Assert.AreEqual(10, LReturned.TotalCount);
  Assert.AreEqual(3, LReturned.CompletedLastSevenDays);
end;

initialization
  TDUnitX.RegisterTestFixture(TTaskServiceTest);
end.
