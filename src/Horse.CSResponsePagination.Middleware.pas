unit Horse.CSResponsePagination.Middleware;

interface

uses

  Horse,

  System.SysUtils,
  System.Classes,
  System.JSON;

procedure CSPaginationMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  Horse.CSResponsePagination.Types,
  Horse.CSResponsePagination;

procedure CSPaginationMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  _CSPInternalCount: Integer;
  _CSPContent: TObject;
  _CSPOriginalJsonArray: TJSONArray;
  _CSPNewJsonArray: TJSONArray;
  _CSPResponse: TJSONObject;
  _CSPPageLimit: Integer;
  _CSPOffset: Integer;
  _CSPTotalPages: Integer;
begin

  try

    Next;

  finally

    if (Res.Content is TJSONArray ) then
    begin

      if ( ( Req.Headers['limit'] <> '' ) or ( Req.Headers['offset'] <> '' ) ) then
      begin

        try
          _CSPPageLimit :=  StrToInt(Req.Headers['limit']);
        except
          _CSPPageLimit :=  5;
        end;

        try
          _CSPOffset  :=  StrToInt(Req.Headers['offset']);
        except
          _CSPOffset :=  1;
        end;

//        _CSPWebResponse := THorseHackResponse(Res).GetWebResponse;
        _CSPContent := Res.Content;

        if Assigned(_CSPContent) and _CSPContent.InheritsFrom( TJSONValue ) then
        begin

          try

            _CSPOriginalJsonArray := TJSONValue(_CSPContent) as TJSONArray;

            TRY
              IF (_CSPOriginalJsonArray.Count MOD _CSPPageLimit) > 0 THEN
                _CSPTotalPages := (_CSPOriginalJsonArray.Count DIV _CSPPageLimit) + 1
              ELSE
                _CSPTotalPages := (_CSPOriginalJsonArray.Count DIV _CSPPageLimit);
            EXCEPT
              _CSPTotalPages := 1;
            END;

            _CSPNewJsonArray := TJsonArray.Create;

            for _CSPInternalCount := (_CSPPageLimit * (_CSPOffset - 1)) to ((_CSPPageLimit * _CSPOffset)) - 1 do
            begin
              if _CSPInternalCount < _CSPOriginalJsonArray.Count then
                _CSPNewJsonArray.AddElement(_CSPOriginalJsonArray.Items[_CSPInternalCount].Clone as TJSONValue);
            end;

            Res.RawWebResponse.ContentType := 'application/json';

            if global_config.paginateOnHeaders then
            begin

              Res.RawWebResponse.SetCustomHeader(global_config.header.count,_CSPOriginalJsonArray.Count.ToString);
              Res.RawWebResponse.SetCustomHeader(global_config.header.page,_CSPTotalPages.ToString);
              Res.RawWebResponse.SetCustomHeader(global_config.header.limit,_CSPPageLimit.ToString);
              Res.RawWebResponse.SetCustomHeader(global_config.header.offset,_CSPOffset.ToString);
              Res.RawWebResponse.SetCustomHeader(global_config.header.size,_CSPNewJsonArray.Count.ToString);

              Res.RawWebResponse.Content := _CSPNewJsonArray.ToJSON;

              Res.Send( _CSPNewJsonArray );

            end
            else
            begin

              _CSPResponse := TJsonObject.Create;

              _CSPResponse.AddPair(global_config.body.count, TJSONNumber.Create(_CSPOriginalJsonArray.Count));
              _CSPResponse.AddPair(global_config.body.page, TJSONNumber.Create(_CSPTotalPages));
              _CSPResponse.AddPair(global_config.body.limit, TJSONNumber.Create(_CSPPageLimit));
              _CSPResponse.AddPair(global_config.body.offset, TJSONNumber.Create(_CSPOffset));
              _CSPResponse.AddPair(global_config.body.size, TJSONNumber.Create(_CSPNewJsonArray.Count));
              _CSPResponse.AddPair(global_config.body.data, _CSPNewJsonArray);

              Res.RawWebResponse.Content := _CSPResponse.ToJSON;

              Res.Send( _CSPResponse );

            end;

          except
          end;

        end;

      end;

    end;

  end;

end;

end.
