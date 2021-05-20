unit Horse.CSResponsePagination;

interface

uses

  Horse,
  Horse.CSResponsePagination.Middleware,

  System.SysUtils,
  System.Classes,
  System.JSON,
  Web.HTTPApp;

type

  TBodyParameters = class
  private
    fcount: string;
    flimit: string;
    fsize: string;
    foffset: string;
    fpage: string;
    fdata: string;
  protected
  published
    property count: string read fcount write fcount;
    property page: string read fpage write fpage;
    property limit: string read flimit write flimit;
    property offset: string read foffset write foffset;
    property size: string read fsize write fsize;
    property data: string read fdata write fdata;
  end;

  THeaderParameters = class
  private
    fcount: string;
    flimit: string;
    fsize: string;
    foffset: string;
    fpage: string;
  protected
  published
    property count: string read fcount write fcount;
    property page: string read fpage write fpage;
    property limit: string read flimit write flimit;
    property offset: string read foffset write foffset;
    property size: string read fsize write fsize;
  end;

  TPaginationConfig = class
  private
    fpaginateOnHeaders: Boolean;
    fBodyParameters: TBodyParameters;
    fHeadersParameters: THeaderParameters;
  public
    constructor Create;
  published
    property paginateOnHeaders: Boolean read fpaginateOnHeaders write fpaginateOnHeaders;
    property body: TBodyParameters read fBodyParameters write fBodyParameters;
    property header: THeaderParameters read fHeadersParameters write fHeadersParameters;
  end;

function CSResponsePagination(  ): THorseCallback; overload;
function CSResponsePagination( paginateOnHeaders: Boolean ): THorseCallback; overload;
function CSResponsePagination( config : TPaginationConfig ): THorseCallback; overload;

var
  global_config: TPaginationConfig;

implementation

{ TCSConfig }

constructor TPaginationConfig.Create();
begin

  inherited;

  Self.paginateOnHeaders := False;
  Self.fBodyParameters := TBodyParameters.Create;
  Self.fHeadersParameters := THeaderParameters.Create;

  self.fBodyParameters.count := 'count';
  self.fBodyParameters.page := 'page';
  self.fBodyParameters.limit := 'limit';
  self.fBodyParameters.offset := 'offset';
  self.fBodyParameters.size := 'size';
  self.fBodyParameters.data := 'data';

  self.fHeadersParameters.count := 'x-pagination-count';
  self.fHeadersParameters.page := 'x-pagination-page';
  self.fHeadersParameters.limit := 'x-pagination-limit';
  self.fHeadersParameters.offset := 'x-pagination-offset';
  self.fHeadersParameters.size := 'x-pagination-size';

end;

{Geral}

function CSResponsePagination(): THorseCallback;
begin

  Result := CSResponsePagination(false);

end;

function CSResponsePagination( paginateOnHeaders: Boolean ): THorseCallback;
begin

  global_config := TPaginationConfig.Create;
  global_config.paginateOnHeaders := paginateOnHeaders;

  Result := CSResponsePagination(global_config);

end;

function CSResponsePagination( config : TPaginationConfig ): THorseCallback;
begin

  Result := Horse.CSResponsePagination.Middleware.CSPaginationMiddleware;

end;

end.
