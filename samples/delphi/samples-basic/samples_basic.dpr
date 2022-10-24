program samples_basic;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.compression,
  Horse.Jhonson,
  System.JSON,
  System.SysUtils,
  DataSet.Serialize,
  DBClient,
  Horse.CSResponsePagination.Types in '..\..\..\src\Horse.CSResponsePagination.Types.pas',
  Horse.CSResponsePagination.Middleware in '..\..\..\src\Horse.CSResponsePagination.Middleware.pas',
  Horse.CSResponsePagination in '..\..\..\src\Horse.CSResponsePagination.pas';

begin

  THorse
    .Use(Compression())
    .Use(CSResponsePagination(false))
    .Use(Jhonson);

  THorse.Get('/teste',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LDataSet: TClientDataSet;
      ErroMSG: string;
    begin

      try

        LDataSet := TClientDataSet.Create(nil);

        try

          LDataSet.LoadFromFile('dataSetExample.xml');
          Res.Send(LDataSet.ToJsonArray);

        finally
          LDataSet.Free;
        end;

      except
        on e:exception do
        begin
          ErroMSG := e.Message;
        end;
      end;

    end);

  THorse.Listen(9000);

end.

