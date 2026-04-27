unit uDAO.Cliente;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uDAO.Conexao,
  uModel.Cliente;

type

  TDAOCliente = class
  private
    FConexao : TConexao;
  public
    constructor Create;
    function BuscarPorCodigo(const ACodigo: Integer;
                             out ACliente: TCliente): Boolean;
  end;

implementation

{ TDAOCliente }

constructor TDAOCliente.Create;
begin
  inherited Create;
  FConexao := TConexao.GetInstancia;
end;

function TDAOCliente.BuscarPorCodigo(const ACodigo: Integer;
                                     out ACliente: TCliente): Boolean;
const
  SQL_BUSCAR =
    'SELECT codigo, ' +
    '       nome,   ' +
    '       cidade, ' +
    '       uf      ' +
    '  FROM clientes' +
    ' WHERE codigo = :pCodigo';
var
  LQuery : TFDQuery;
begin
  Result   := False;
  ACliente := nil;

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection  := FConexao.GetConexao;
    LQuery.SQL.Text    := SQL_BUSCAR;
    LQuery.ParamByName('pCodigo').AsInteger := ACodigo;
    LQuery.Open;

    if not LQuery.IsEmpty then
    begin
      ACliente        := TCliente.Create;
      ACliente.Codigo := LQuery.FieldByName('codigo').AsInteger;
      ACliente.Nome   := LQuery.FieldByName('nome').AsString;
      ACliente.Cidade := LQuery.FieldByName('cidade').AsString;
      ACliente.UF     := LQuery.FieldByName('uf').AsString;
      Result          := True;
    end;
  finally
    LQuery.Free;
  end;
end;

end.
