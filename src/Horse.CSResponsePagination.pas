unit Horse.CSResponsePagination;

interface

uses

  Horse,
  Horse.CSResponsePagination.Types,
  Horse.CSResponsePagination.Middleware,

  System.SysUtils,
  System.Classes,
  System.JSON;

function CSResponsePagination( paginateOnHeaders: Boolean = false ): THorseCallback; overload;
function CSResponsePagination( var config : TPaginationConfig ): THorseCallback; overload;

var
  global_config: TPaginationConfig;

implementation

{Geral}

function CSResponsePagination( paginateOnHeaders: Boolean = false ): THorseCallback;
begin

  global_config := TPaginationConfig.Create;
  global_config.paginateOnHeaders := paginateOnHeaders;

  Result := CSResponsePagination(global_config);

end;

function CSResponsePagination( var config : TPaginationConfig ): THorseCallback;
begin

  global_config := config;

  Result := Horse.CSResponsePagination.Middleware.CSPaginationMiddleware;

end;

end.
