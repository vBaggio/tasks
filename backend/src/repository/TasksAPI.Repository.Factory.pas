unit TasksAPI.Repository.Factory;

interface

uses
  TasksAPI.Conn.Interfaces, TasksAPI.Conn.Factory,
  TasksAPI.Repository.Interfaces;

type
  TRepositoryFactory = class(TInterfacedObject, IRepositoryFactory)
  private
    FConnFactory: IConnectionFactory;
  public
    constructor Create(AConnFactory: IConnectionFactory);
    function CreateTaskRepository: ITaskRepository;
    function CreateUserRepository: IUserRepository;
  end;

implementation

uses
  TasksAPI.Repository.Task,
  TasksAPI.Repository.User;

constructor TRepositoryFactory.Create(AConnFactory: IConnectionFactory);
begin
  inherited Create;
  FConnFactory := AConnFactory;
end;

function TRepositoryFactory.CreateTaskRepository: ITaskRepository;
begin
  Result := TTaskRepository.Create(FConnFactory.CreateConnection);
end;

function TRepositoryFactory.CreateUserRepository: IUserRepository;
begin
  Result := TUserRepository.Create;
end;

end.
