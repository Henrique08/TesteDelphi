unit uDAO.Produto;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uDAO.Conexao,
  uModel.Produto;

type

  TDAOProduto = class
  private
    FConexao : TConexao;
  public
    constructor Create;

    function BuscarPorCodigo(const ACodigo: Integer;
                             out AProduto: TProduto): Boolean;
  end;

implementation

{ TDAOProduto }

constructor TDAOProduto.Create;
begin
  inherited Create;
  FConexao := TConexao.GetInstancia;
end;

function TDAOProduto.BuscarPorCodigo(const ACodigo: Integer;
                                     out AProduto: TProduto): Boolean;
const
  SQL_BUSCAR =
    'SELECT codigo,     ' +
    '       descricao,  ' +
    '       preco_venda ' +
    '  FROM produtos    ' +
    ' WHERE codigo = :pCodigo';
var
  LQuery : TFDQuery;
begin
  Result   := False;
  AProduto := nil;

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection  := FConexao.GetConexao;
    LQuery.SQL.Text    := SQL_BUSCAR;
    LQuery.ParamByName('pCodigo').AsInteger := ACodigo;
    LQuery.Open;

    if not LQuery.IsEmpty then
    begin
      AProduto            := TProduto.Create;
      AProduto.Codigo     := LQuery.FieldByName('codigo').AsInteger;
      AProduto.Descricao  := LQuery.FieldByName('descricao').AsString;
      AProduto.PrecoVenda := LQuery.FieldByName('preco_venda').AsFloat;
      Result              := True;
    end;
  finally
    LQuery.Free;
  end;
end;

end.
