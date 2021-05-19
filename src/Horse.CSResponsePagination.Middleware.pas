unit Horse.CSResponsePagination.Middleware;

interface

uses

  Horse,

  System.SysUtils,
  System.Classes,
  System.JSON,
  Web.HTTPApp;

procedure CSPaginationMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);

var
  global_paginateOnHeaders : Boolean;

implementation

procedure CSPaginationMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  _CSPInternalCount: Integer;
  _CSPWebResponse: TWebResponse;
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

    if ( ( Req.Headers['limit'] <> '' ) and ( Req.Headers['offset'] <> '' ) ) then
    begin

      try
        _CSPPageLimit :=  StrToInt(Req.Headers['limit']);
      except
        _CSPPageLimit :=  50;
      end;

      try
        _CSPOffset  :=  StrToInt(Req.Headers['offset']);
      except
        _CSPOffset :=  1;
      end;

      _CSPWebResponse := THorseHackResponse(Res).GetWebResponse;
      _CSPContent := THorseHackResponse(Res).GetContent;

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

          _CSPWebResponse.ContentType := 'application/json';

          if global_paginateOnHeaders then
          begin

            Res.RawWebResponse.SetCustomHeader('X-Pagination-count',_CSPOriginalJsonArray.Count.ToString);
            Res.RawWebResponse.SetCustomHeader('X-Pagination-pages',_CSPTotalPages.ToString);
            Res.RawWebResponse.SetCustomHeader('X-Pagination-limit',_CSPPageLimit.ToString);
            Res.RawWebResponse.SetCustomHeader('X-Pagination-offset',_CSPOffset.ToString);
            Res.RawWebResponse.SetCustomHeader('X-Pagination-size',_CSPNewJsonArray.Count.ToString);

            _CSPWebResponse.Content := _CSPNewJsonArray.ToJSON;

            Res.Send( _CSPNewJsonArray );

          end
          else
          begin

            _CSPResponse := TJsonObject.Create;

            _CSPResponse.AddPair('count', TJSONNumber.Create(_CSPOriginalJsonArray.Count));
            _CSPResponse.AddPair('pages', TJSONNumber.Create(_CSPTotalPages));
            _CSPResponse.AddPair('limit', TJSONNumber.Create(_CSPPageLimit));
            _CSPResponse.AddPair('offset', TJSONNumber.Create(_CSPOffset));
            _CSPResponse.AddPair('size', TJSONNumber.Create(_CSPNewJsonArray.Count));
            _CSPResponse.AddPair('data', _CSPNewJsonArray);

            _CSPWebResponse.Content := _CSPResponse.ToJSON;

            Res.Send( _CSPResponse );

          end;

        except
        end;

      end;

    end;

  end;

end;

end.
