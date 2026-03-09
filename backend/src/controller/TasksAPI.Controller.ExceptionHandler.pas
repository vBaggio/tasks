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
    class procedure HandleNotFound(const E: ENotFoundException; const Res: THorseResponse);
    class procedure HandleValidation(const E: EValidationException; const Res: THorseResponse);
    class procedure HandleInternal(const Res: THorseResponse);
  public
    class procedure Handle(const E: Exception; const Req: THorseRequest; const Res: THorseResponse; var ASendException: Boolean);
  end;

implementation

{ TExceptionHandler }


class procedure TExceptionHandler.HandleNotFound(const E: ENotFoundException; const Res: THorseResponse);
begin
  Res.Status(THTTPStatus.NotFound.ToInteger).Send(E.Message);
end;

class procedure TExceptionHandler.HandleValidation(const E: EValidationException; const Res: THorseResponse);
begin
  Res.Status(THTTPStatus.UnprocessableEntity.ToInteger).Send(E.Message);
end;

class procedure TExceptionHandler.HandleInternal(const Res: THorseResponse);
begin
  //Não expõe mensagem de erro não tratado ou não previsto na resposta da api
  Res.Status(THTTPStatus.InternalServerError.ToInteger).Send('Ocorreu um erro interno. Verifique o console.');
end;

class procedure TExceptionHandler.Handle(const E: Exception; const Req: THorseRequest; const Res: THorseResponse; var ASendException: Boolean);
begin
  ASendException := False;

  //Loga erro no console
  WriteLn(E.ClassName + ': ' + E.Message);

  //Delega tratamento para o método apropriado de acordo com o tipo da exceção:

  if E is ENotFoundException then
    HandleNotFound(ENotFoundException(E), Res)

  else if E is EValidationException then
    HandleValidation(EValidationException(E), Res)

  else
    HandleInternal(Res);
end;

end.

