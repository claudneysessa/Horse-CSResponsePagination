unit Horse.CSResponsePagination;

interface

uses

  Horse,
  Horse.CSResponsePagination.Middleware,

  System.SysUtils,
  System.Classes,
  System.JSON,
  Web.HTTPApp;

function CSResponsePagination( paginateOnHeaders : boolean = false ): THorseCallback;

implementation

function CSResponsePagination( paginateOnHeaders : boolean = false ): THorseCallback;
begin
  Horse.CSResponsePagination.Middleware.global_paginateOnHeaders := paginateOnHeaders;
  Result := Horse.CSResponsePagination.Middleware.CSPaginationMiddleware;
end;

end.
