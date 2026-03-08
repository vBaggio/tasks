unit TasksAPI.Controller.ExceptionHandler;

interface

uses
  System.SysUtils,
  System.JSON,
  Horse,
  Horse.Commons,
  Horse.HandleException,
  TasksAPI.Model.Exceptions;

type
  TExceptionHandler = class
  private
    class procedure SendError(const Res: THorseResponse; const AMessage: string; AStatus: Integer);
    class procedure HandleNotFound(const E: ENotFoundException; const Res: THorseResponse);
    class procedure HandleValidation(const E: EValidationException; const Res: THorseResponse);
    class procedure HandleInternal(const Res: THorseResponse);
  public
    class procedure Handle(const E: Exception; const Req: THorseRequest; const Res: THorseResponse; var ASendException: Boolean);
  end;

  procedure ExceptionCallback(const E: Exception; const Req: THorseRequest; const Res: THorseResponse; var ASendException: Boolean);

implementation

{ TExceptionHandler }

class procedure TExceptionHandler.SendError(const Res: THorseResponse; const AMessage: string; AStatus: Integer);
begin
  Res.Status(AStatus).Send(AMessage);
end;

class procedure TExceptionHandler.HandleNotFound(const E: ENotFoundException; const Res: THorseResponse);
begin
  SendError(Res, E.Message, THTTPStatus.NotFound.ToInteger);
end;

class procedure TExceptionHandler.HandleValidation(const E: EValidationException; const Res: THorseResponse);
begin
  SendError(Res, E.Message, THTTPStatus.UnprocessableEntity.ToInteger);
end;

class procedure TExceptionHandler.HandleInternal(const Res: THorseResponse);
begin
  SendError(Res, 'Ocorreu um erro interno.', THTTPStatus.InternalServerError.ToInteger);
end;

class procedure TExceptionHandler.Handle(const E: Exception; const Req: THorseRequest; const Res: THorseResponse; var ASendException: Boolean);
begin
  ASendException := False;

  WriteLn(E.ClassName + ': ' + E.Message);

  if E is ENotFoundException then
    HandleNotFound(ENotFoundException(E), Res)

  else if E is EValidationException then
    HandleValidation(EValidationException(E), Res)

  else
    HandleInternal(Res);
end;

procedure ExceptionCallback(const E: Exception; const Req: THorseRequest;
  const Res: THorseResponse; var ASendException: Boolean);
begin
  TExceptionHandler.Handle(E, Req, Res, ASendException);
end;

end.

