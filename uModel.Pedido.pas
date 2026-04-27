unit uModel.Pedido;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  uModel.Cliente,
  uModel.ItemPedido;

type

  TPedido = class
  private
    FNumeroPedido : Integer;
    FDataEmissao  : TDate;
    FCliente      : TCliente;
    FItens        : TObjectList<TItemPedido>;

    function GetValorTotal: Double;
  public
    constructor Create;
    destructor  Destroy; override;

    property NumeroPedido : Integer                  read FNumeroPedido write FNumeroPedido;
    property DataEmissao  : TDate                    read FDataEmissao  write FDataEmissao;
    property Cliente      : TCliente                 read FCliente;
    property Itens        : TObjectList<TItemPedido> read FItens;

    property ValorTotal   : Double                   read GetValorTotal;

    procedure Limpar;
  end;

implementation

{ TPedido }

constructor TPedido.Create;
begin
  inherited Create;
  FCliente     := TCliente.Create;
  FItens       := TObjectList<TItemPedido>.Create(True);
  FDataEmissao := Now;
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  FCliente.Free;
  inherited Destroy;
end;

function TPedido.GetValorTotal: Double;
var
  LItem : TItemPedido;
begin
  Result := 0;
  for LItem in FItens do
    Result := Result + LItem.VrTotal;
end;

procedure TPedido.Limpar;
begin
  FNumeroPedido := 0;
  FDataEmissao  := Now;
  FCliente.Limpar;
  FItens.Clear;
end;

end.
