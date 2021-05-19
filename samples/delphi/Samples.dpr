program Samples;

{$APPTYPE CONSOLE}
{$R *.res}

uses

  Horse,
  Horse.compression,
  Horse.CSResponsePagination,
  Horse.Jhonson,

  System.JSON,
  System.SysUtils,

  DataSet.Serialize,
  DBClient;

begin

  THorse
    .Use(Compression())
    .Use(CSResponsePagination(false))
    .Use(Jhonson);

  THorse.Get('/testeCSPagination',
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

  THorse.Listen(8888);

end.

