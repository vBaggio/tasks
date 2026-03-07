unit TasksAPI.Repository.User;

interface

uses
  TasksAPI.Model.Entity.User,
  TasksAPI.Repository.Interfaces;

type
  TUserRepository = class(TInterfacedObject, IUserRepository)
  private
    FUsers: array of TUserCredential;
    procedure LoadUsers;
  public
    constructor Create;
    function FindByUsername(const AUsername: string): TUserCredential;
    function Exists(const AUsername: string): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TUserRepository }

constructor TUserRepository.Create;
begin
  inherited Create;
  LoadUsers;
end;

procedure TUserRepository.LoadUsers;
begin
  SetLength(FUsers, 1);
  FUsers[0].Username := 'admin';
  FUsers[0].Password := '123456';
end;

function TUserRepository.FindByUsername(const AUsername: string): TUserCredential;
var
  I: Integer;
begin
  for I := Low(FUsers) to High(FUsers) do
  begin
    if SameText(FUsers[I].Username, AUsername) then
      Exit(FUsers[I]);
  end;

  Result := Default(TUserCredential);
end;

function TUserRepository.Exists(const AUsername: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Low(FUsers) to High(FUsers) do
  begin
    if SameText(FUsers[I].Username, AUsername) then
      Exit(True);
  end;
end;

end.
