unit TasksAPI.Service.Auth;

interface

uses
  TasksAPI.Repository.Interfaces,
  TasksAPI.Service.Interfaces;

type
  TAuthService = class(TInterfacedObject, IAuthService)
  private
    FUserRepository: IUserRepository;
  public
    constructor Create(AUserRepository: IUserRepository);
    function Validate(const AUsername, APassword: string): Boolean;
  end;

implementation

uses
  System.SysUtils,
  TasksAPI.Model.Entity.User;

{ TAuthService }

constructor TAuthService.Create(AUserRepository: IUserRepository);
begin
  inherited Create;
  FUserRepository := AUserRepository;
end;

function TAuthService.Validate(const AUsername, APassword: string): Boolean;
var
  LUser: TUserModel;
begin
  Result := False;

  if not FUserRepository.Exists(AUsername) then
    Exit;

  LUser := FUserRepository.FindByUsername(AUsername);
  if Assigned(LUser) then
    Result := SameStr(LUser.Password, APassword);
end;

end.
