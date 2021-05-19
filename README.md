# Horse-CSPagination

Horse Server Middleware for Paging JSON Data in APIS's RESTFULL

### For install in your project using [boss](https://github.com/HashLoad/boss):

``` sh
$ boss install https://github.com/claudneysessa/Horse-CSResponsePagination
```

## Usage

If you are using the Jhonson middleware, your declaration must come before the Jhonson declaration, and if you also use the Compression middleware, your declaration must come after the Compression declaration.

```delphi

  THorse
    .Use(Compression())
    .Use(CSPagination()) // <<-- Here!
    .Use(Jhonson);

```

#### First steps

To enable the paging of the data, just inform the HEADER of the Requisition the following parameters:

Parameter  | type     | description
:--------- | :------- | :--------------
limit      | integer  | number of records per page ( minimum value 5 )
offset     | integer  | page to be displayed

<br>

Sample Horse server using CSPagination:

```delphi
uses

  Horse,
  Horse.Compression,
  Horse.Jhonson,
  Horse.CSPagination,

  System.SysUtils,
  System.JSON,

  DBClient,
  DataSet.Serialize;

begin
  THorse
    .Use(Compression())
    .Use(CSPagination())
    .Use(Jhonson);

  THorse.Get('/testeCSPagination',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      DataSet: TClientDataSet;
    begin
      DataSet := TClientDataSet.Create(nil);
      try
        DataSet.LoadFromFile('dataSetExample.xml');
        Res.Send<TJsonArray>(DataSet.ToJsonArray);
      finally
        DataSet.Free;
      end;
    end);

  THorse.Listen(8888);

end.
```
# Result on JsonBody

When choosing to use pagination in the result body, CSPagination will generate a customized return presenting the pagination data in the result body.

Field    | description
:------- | :--------------
count    | Total number of records
pages    | Total existing pages
limit    | Total number of records per page
offset   | Selected page
size     | Number of records for the selected page
data     | Result Array

<br>

Json Result:

```json
{
    "count": 564,
    "pages": 113,
    "limit": 5,
    "offset": 2,
    "size": 5,
    "data": []
}
```

Sample Code:

```delphi
begin
  THorse
    .Use(Compression())
    .Use(CSPagination(false)) // <<-- paginateOnHeaders = false
    .Use(Jhonson);

  THorse.Get('/testeCSPagination',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      DataSet: TClientDataSet;
    begin
      DataSet := TClientDataSet.Create(nil);
      try
        DataSet.LoadFromFile('dataSetExample.xml');
        Res.Send<TJsonArray>(DataSet.ToJsonArray);
      finally
        DataSet.Free;
      end;
    end);

  THorse.Listen(8888);

end.
```

# Result on Response Headers

When choosing to use pagination in the response header, CSPagination will generate some personalized information presenting the data in the response header.

Field                | description
:------------------- | :--------------
X-Pagination-count   | Total number of records
X-Pagination-pages   | Total existing pages
X-Pagination-limit   | Total number of records per page
X-Pagination-offset  | Selected page
X-Pagination-size    | Number of records for the selected page

<br>

Sample Code:

```delphi
begin
  THorse
    .Use(Compression())
    .Use(CSPagination(true)) // <<-- paginateOnHeaders = true
    .Use(Jhonson);

  THorse.Get('/testeCSPagination',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      DataSet: TClientDataSet;
    begin
      DataSet := TClientDataSet.Create(nil);
      try
        DataSet.LoadFromFile('dataSetExample.xml');
        Res.Send<TJsonArray>(DataSet.ToJsonArray);
      finally
        DataSet.Free;
      end;
    end);

  THorse.Listen(8888);

end.
```