unit TasksAPI.Model.Exceptions;

interface

uses
  System.SysUtils;

type
  EValidationException = class(Exception);
  ENotFoundException = class(Exception);
  EDatabaseException = class(Exception);

implementation

end.
