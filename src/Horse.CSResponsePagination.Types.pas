unit Horse.CSResponsePagination.Types;

interface

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
    fBody: TBodyParameters;
    fHeaders: THeaderParameters;
  public
    constructor Create;
    procedure init;
  published
    property paginateOnHeaders: Boolean read fpaginateOnHeaders write fpaginateOnHeaders;
    property body: TBodyParameters read fBody write fBody;
    property header: THeaderParameters read fHeaders write fHeaders;
  end;

implementation

{ TCSConfig }

constructor TPaginationConfig.Create();
begin

  inherited;

  Self.paginateOnHeaders := False;
  Self.init;

end;

procedure TPaginationConfig.init;
begin

  Self.fBody := TBodyParameters.Create;
  Self.fHeaders := THeaderParameters.Create;

  self.fBody.count := 'count';
  self.fBody.page := 'page';
  self.fBody.limit := 'limit';
  self.fBody.offset := 'offset';
  self.fBody.size := 'size';
  self.fBody.data := 'data';

  self.fHeaders.count := 'x-pagination-count';
  self.fHeaders.page := 'x-pagination-page';
  self.fHeaders.limit := 'x-pagination-limit';
  self.fHeaders.offset := 'x-pagination-offset';
  self.fHeaders.size := 'x-pagination-size';

end;

end.
