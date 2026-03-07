unit TasksAPI.Conn.Interfaces;

interface

uses
  FireDAC.Comp.Client;

type
  TConnectionConfig = record
    Server: string;
    Port: string;
    Database: string;
    UserName: string;
    Password: string;
  end;

  IConnection = interface
    ['{69E96F76-0136-43F4-8CAD-EA4AA768A43A}']
    function GetConn: TFDConnection;
  end;

implementation

end.
