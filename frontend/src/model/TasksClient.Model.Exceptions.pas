unit TasksClient.Model.Exceptions;

interface

uses
  System.SysUtils;

type
  EApiException = class(Exception)
  private
    FStatusCode: Integer;
  public
    constructor Create(AStatusCode: Integer; const AMessage: string);
    property StatusCode: Integer read FStatusCode;
  end;

  EApiValidationException = class(EApiException)
  public
    constructor Create(const AMessage: string);
  end;

  EApiNotFoundException = class(EApiException)
  public
    constructor Create(const AMessage: string);
  end;

  EApiUnauthorizedException = class(EApiException)
  public
    constructor Create(const AMessage: string);
  end;

implementation

{ EApiException }

constructor EApiException.Create(AStatusCode: Integer; const AMessage: string);
begin
  inherited Create(AMessage);
  FStatusCode := AStatusCode;
end;

{ EApiValidationException }

constructor EApiValidationException.Create(const AMessage: string);
begin
  inherited Create(422, AMessage);
end;

{ EApiNotFoundException }

constructor EApiNotFoundException.Create(const AMessage: string);
begin
  inherited Create(404, AMessage);
end;

{ EApiUnauthorizedException }

constructor EApiUnauthorizedException.Create(const AMessage: string);
begin
  inherited Create(401, AMessage);
end;

end.
