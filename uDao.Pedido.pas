unit uDAO.Pedido;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uDAO.Conexao,
  uDAO.Cliente,
  uDAO.Produto,
  uModel.Pedido,
  uModel.ItemPedido,
  uModel.Cliente;

type

  TDAOPedido = class
  private
    FConexao    : TConexao;
    FDAOCliente : TDAOCliente;
    FDAOProduto : TDAOProduto;

    function ProximoNumeroPedido(const AConexao: TFDConnection): Integer;
    procedure GravarCabecalho(const APedido: TPedido;
                              const AConexao: TFDConnection);
    procedure GravarItens(const APedido: TPedido;
                          const AConexao: TFDConnection);
    procedure ExcluirItens(const ANumeroPedido: Integer;
                           const AConexao: TFDConnection);
    procedure ExcluirCabecalho(const ANumeroPedido: Integer;
                               const AConexao: TFDConnection);
  public
    constructor Create;
    destructor  Destroy; override;
    function Gravar(const APedido: TPedido): Integer;

    function Carregar(const ANumeroPedido: Integer;
                      out APedido: TPedido): Boolean;

    procedure Excluir(const ANumeroPedido: Integer);
  end;

implementation

{ TDAOPedido }

constructor TDAOPedido.Create;
begin
  inherited Create;
  FConexao    := TConexao.GetInstancia;
  FDAOCliente := TDAOCliente.Create;
  FDAOProduto := TDAOProduto.Create;
end;

destructor TDAOPedido.Destroy;
begin
  FDAOProduto.Free;
  FDAOCliente.Free;
  inherited Destroy;
end;

function TDAOPedido.ProximoNumeroPedido(const AConexao: TFDConnection): Integer;
const
  SQL_PROXIMO =
    'SELECT COALESCE(MAX(numero_pedido), 0) + 1 AS proximo ' +
    '  FROM pedidos                                        ';
var
  LQuery : TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := AConexao;
    LQuery.SQL.Text   := SQL_PROXIMO;
    LQuery.Open;
    Result := LQuery.FieldByName('proximo').AsInteger;
  finally
    LQuery.Free;
  end;
end;

procedure TDAOPedido.GravarCabecalho(const APedido: TPedido;
                                     const AConexao: TFDConnection);
const
  SQL_CABECALHO =
    'INSERT INTO pedidos                                   ' +
    '       (numero_pedido, data_emissao,                  ' +
    '        codigo_cliente, valor_total)                  ' +
    'VALUES (:pNumeroPedido, :pDataEmissao,                ' +
    '        :pCodigoCliente, :pValorTotal)                ';
var
  LQuery : TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := AConexao;
    LQuery.SQL.Text   := SQL_CABECALHO;

    LQuery.ParamByName('pNumeroPedido').AsInteger  := APedido.NumeroPedido;
    LQuery.ParamByName('pDataEmissao').AsDate      := APedido.DataEmissao;
    LQuery.ParamByName('pCodigoCliente').AsInteger := APedido.Cliente.Codigo;
    LQuery.ParamByName('pValorTotal').AsCurrency   := APedido.ValorTotal;

    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

procedure TDAOPedido.GravarItens(const APedido: TPedido;
                                 const AConexao: TFDConnection);
const
  SQL_ITEM =
    'INSERT INTO pedido_itens                              ' +
    '       (numero_pedido, codigo_produto,                ' +
    '        quantidade, vr_unitario, vr_total)            ' +
    'VALUES (:pNumeroPedido, :pCodigoProduto,              ' +
    '        :pQuantidade, :pVrUnitario, :pVrTotal)        ';
var
  LItem  : TItemPedido;
  LQuery : TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := AConexao;
    LQuery.SQL.Text   := SQL_ITEM;

    for LItem in APedido.Itens do
    begin
      LQuery.ParamByName('pNumeroPedido').AsInteger  := APedido.NumeroPedido;
      LQuery.ParamByName('pCodigoProduto').AsInteger := LItem.CodigoProduto;
      LQuery.ParamByName('pQuantidade').AsFloat      := LItem.Quantidade;
      LQuery.ParamByName('pVrUnitario').AsCurrency   := LItem.VrUnitario;
      LQuery.ParamByName('pVrTotal').AsCurrency      := LItem.VrTotal;
      LQuery.ExecSQL;
    end;
  finally
    LQuery.Free;
  end;
end;

procedure TDAOPedido.ExcluirItens(const ANumeroPedido: Integer;
                                  const AConexao: TFDConnection);
const
  SQL_EXCLUIR_ITENS =
    'DELETE FROM pedido_itens     ' +
    ' WHERE numero_pedido = :pNum ';
var
  LQuery : TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := AConexao;
    LQuery.SQL.Text   := SQL_EXCLUIR_ITENS;
    LQuery.ParamByName('pNum').AsInteger := ANumeroPedido;
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

procedure TDAOPedido.ExcluirCabecalho(const ANumeroPedido: Integer;
                                      const AConexao: TFDConnection);
const
  SQL_EXCLUIR_CAB =
    'DELETE FROM pedidos          ' +
    ' WHERE numero_pedido = :pNum ';
var
  LQuery : TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := AConexao;
    LQuery.SQL.Text   := SQL_EXCLUIR_CAB;
    LQuery.ParamByName('pNum').AsInteger := ANumeroPedido;
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

function TDAOPedido.Gravar(const APedido: TPedido): Integer;
var
  LConexao : TFDConnection;
begin
  if APedido.Cliente.Codigo <= 0 then
    raise Exception.Create('Informe o cliente antes de gravar o pedido.');

  if APedido.Itens.Count = 0 then
    raise Exception.Create('O pedido nao possui itens.');

  LConexao := FConexao.GetConexao;
  LConexao.StartTransaction;
  try
    APedido.NumeroPedido := ProximoNumeroPedido(LConexao);
    GravarCabecalho(APedido, LConexao);
    GravarItens(APedido, LConexao);
    LConexao.Commit;
    Result := APedido.NumeroPedido;
  except
    LConexao.Rollback;
    raise;
  end;
end;

function TDAOPedido.Carregar(const ANumeroPedido: Integer;
                             out APedido: TPedido): Boolean;
const
  SQL_CABECALHO =
    'SELECT p.numero_pedido,     ' +
    '       p.data_emissao,      ' +
    '       p.codigo_cliente,    ' +
    '       p.valor_total        ' +
    '  FROM pedidos p            ' +
    ' WHERE p.numero_pedido = :pNum';

  SQL_ITENS =
    'SELECT pi.codigo_produto,   ' +
    '       pr.descricao,        ' +
    '       pi.quantidade,       ' +
    '       pi.vr_unitario,      ' +
    '       pi.vr_total          ' +
    '  FROM pedido_itens pi      ' +
    '  JOIN produtos     pr      ' +
    '    ON pr.codigo = pi.codigo_produto' +
    ' WHERE pi.numero_pedido = :pNum' +
    ' ORDER BY pi.id             ';
var
  LConexao : TFDConnection;
  LQuery   : TFDQuery;
  LItem    : TItemPedido;
  LCliente : TCliente;
begin
  Result   := False;
  APedido  := nil;
  LConexao := FConexao.GetConexao;

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConexao;
    LQuery.SQL.Text   := SQL_CABECALHO;
    LQuery.ParamByName('pNum').AsInteger := ANumeroPedido;
    LQuery.Open;

    if LQuery.IsEmpty then
      Exit;

    APedido              := TPedido.Create;
    APedido.NumeroPedido := LQuery.FieldByName('numero_pedido').AsInteger;
    APedido.DataEmissao  := LQuery.FieldByName('data_emissao').AsDateTime;

    if not FDAOCliente.BuscarPorCodigo(
             LQuery.FieldByName('codigo_cliente').AsInteger, LCliente) then
      raise Exception.CreateFmt(
              'Cliente de codigo %d nao encontrado.',
              [LQuery.FieldByName('codigo_cliente').AsInteger]);

    try
      APedido.Cliente.Codigo := LCliente.Codigo;
      APedido.Cliente.Nome   := LCliente.Nome;
      APedido.Cliente.Cidade := LCliente.Cidade;
      APedido.Cliente.UF     := LCliente.UF;
    finally
      LCliente.Free;
    end;
  finally
    LQuery.Free;
  end;

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConexao;
    LQuery.SQL.Text   := SQL_ITENS;
    LQuery.ParamByName('pNum').AsInteger := ANumeroPedido;
    LQuery.Open;

    while not LQuery.Eof do
    begin
      LItem               := TItemPedido.Create;
      LItem.CodigoProduto := LQuery.FieldByName('codigo_produto').AsInteger;
      LItem.Descricao     := LQuery.FieldByName('descricao').AsString;
      LItem.Quantidade    := LQuery.FieldByName('quantidade').AsFloat;
      LItem.VrUnitario    := LQuery.FieldByName('vr_unitario').AsFloat;
      APedido.Itens.Add(LItem);
      LQuery.Next;
    end;

    Result := True;
  finally
    LQuery.Free;
  end;
end;

procedure TDAOPedido.Excluir(const ANumeroPedido: Integer);
var
  LConexao : TFDConnection;
begin
  LConexao := FConexao.GetConexao;
  LConexao.StartTransaction;
  try
    ExcluirItens(ANumeroPedido, LConexao);
    ExcluirCabecalho(ANumeroPedido, LConexao);
    LConexao.Commit;
  except
    LConexao.Rollback;
    raise;
  end;
end;

end.
