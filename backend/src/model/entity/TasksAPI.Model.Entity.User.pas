unit TasksAPI.Model.Entity.User;

interface

type
  TUserModel = class
  private
    FUsername: string;
    FPassword: string;
  public
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
  end;

implementation

end.
