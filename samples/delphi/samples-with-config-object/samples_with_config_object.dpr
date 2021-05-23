program samples_with_config_object;

{$APPTYPE CONSOLE}
{$R *.res}

uses

  Horse,
  Horse.compression,

  Horse.CSResponsePagination.Types,
  Horse.CSResponsePagination,

  Horse.Jhonson,

  System.JSON,
  System.SysUtils,

  DataSet.Serialize,
  DBClient;

var
  Config: TPaginationConfig;

begin

  Config := TPaginationConfig.Create;
  Config.paginateOnHeaders := True;
  Config.header.count := 'X-Total-Count';
  Config.header.page := 'X-Page-Count';
  Config.header.limit := 'X-Page-Limit';
  Config.header.offset := 'X-Page-Offset';
  Config.header.size := 'X-Page-Size';

  THorse
    .Use(Compression())
    .Use(CSResponsePagination(Config))
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

