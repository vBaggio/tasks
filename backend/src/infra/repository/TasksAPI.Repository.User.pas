unit TasksAPI.Repository.User;

interface

uses
  System.Generics.Collections,
  TasksAPI.Model.Entity.User,
  TasksAPI.Repository.Interfaces;

type
  TUserRepository = class(TInterfacedObject, IUserRepository)
  private
    FUsers: TObjectList<TUserModel>;
    procedure LoadUsers;
  public
    constructor Create;
    destructor Destroy; override;
    function FindByUsername(const AUsername: string): TUserModel;
    function Exists(const AUsername: string): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TUserRepository }

constructor TUserRepository.Create;
begin
  inherited Create;
  FUsers := TObjectList<TUserModel>.Create(True);
  LoadUsers;
end;

destructor TUserRepository.Destroy;
begin
  FUsers.Free;
  inherited;
end;

procedure TUserRepository.LoadUsers;
var
  LUser: TUserModel;
begin
  LUser := TUserModel.Create;
  LUser.Username := 'admin';
  LUser.Password := '123456';
  FUsers.Add(LUser);
end;

function TUserRepository.FindByUsername(const AUsername: string): TUserModel;
var
  LUser: TUserModel;
begin
  for LUser in FUsers do
  begin
    if SameText(LUser.Username, AUsername) then
      Exit(LUser);
  end;

  Result := nil;
end;

function TUserRepository.Exists(const AUsername: string): Boolean;
var
  LUser: TUserModel;
begin
  for LUser in FUsers do
  begin
    if SameText(LUser.Username, AUsername) then
      Exit(True);
  end;
  Result := False;
end;

end.
