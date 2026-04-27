unit uModel.Cliente;

interface

type

  TCliente = class
  private
    FCodigo : Integer;
    FNome   : string;
    FCidade : string;
    FUF     : string;
  public
    property Codigo : Integer read FCodigo write FCodigo;
    property Nome   : string  read FNome   write FNome;
    property Cidade : string  read FCidade write FCidade;
    property UF     : string  read FUF     write FUF;

    procedure Limpar;
  end;

implementation

{ TCliente }

procedure TCliente.Limpar;
begin
  FCodigo := 0;
  FNome   := '';
  FCidade := '';
  FUF     := '';
end;

end.
