unit TasksAPI.Service.Factory;

interface

uses
  TasksAPI.Repository.Interfaces,
  TasksAPI.Service.Interfaces;

type
  TServiceFactory = class(TInterfacedObject, IServiceFactory)
  private
    FRepFactory: IRepositoryFactory;
  public
    constructor Create(ARepFactory: IRepositoryFactory);
    function CreateTaskService: ITaskService;
    function CreateAuthService: IAuthService;
  end;

implementation

uses
  TasksAPI.Service.Task,
  TasksAPI.Service.Auth;

constructor TServiceFactory.Create(ARepFactory: IRepositoryFactory);
begin
  inherited Create;
  FRepFactory := ARepFactory;
end;

function TServiceFactory.CreateTaskService: ITaskService;
begin
  Result := TTaskService.Create(FRepFactory.CreateTaskRepository);
end;

function TServiceFactory.CreateAuthService: IAuthService;
begin
  Result := TAuthService.Create(FRepFactory.CreateUserRepository);
end;

end.
