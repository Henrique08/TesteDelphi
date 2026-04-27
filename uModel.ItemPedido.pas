unit uModel.ItemPedido;

interface

type

  TItemPedido = class
  private
    FCodigoProduto : Integer;
    FDescricao     : string;
    FQuantidade    : Double;
    FVrUnitario    : Double;

    function GetVrTotal: Double;
  public
    property CodigoProduto : Integer read FCodigoProduto write FCodigoProduto;
    property Descricao     : string  read FDescricao     write FDescricao;
    property Quantidade    : Double  read FQuantidade    write FQuantidade;
    property VrUnitario    : Double  read FVrUnitario    write FVrUnitario;
    property VrTotal       : Double  read GetVrTotal;

    procedure Limpar;
  end;

implementation

{ TItemPedido }

function TItemPedido.GetVrTotal: Double;
begin
  Result := FQuantidade * FVrUnitario;
end;

procedure TItemPedido.Limpar;
begin
  FCodigoProduto := 0;
  FDescricao     := '';
  FQuantidade    := 0;
  FVrUnitario    := 0;
end;

end.
