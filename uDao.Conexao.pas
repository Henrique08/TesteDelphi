unit uDAO.Conexao;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.DApt;

type

  TConexao = class
  private
    class var FInstancia : TConexao;

    FConexaoDB : TFDConnection;

    constructor CreateInterno;
    procedure   Configurar;
  public
    destructor Destroy; override;

    class function  GetInstancia: TConexao;
    class procedure LiberarInstancia;

    function GetConexao: TFDConnection;

    procedure Conectar;
    procedure Desconectar;
    function  EstaConectado: Boolean;

    procedure IniciarTransacao;
    procedure Confirmar;
    procedure Cancelar;
  end;

const
  C_HOST_BD    = 'localhost';
  C_PORTA_BD   = '3306';
  C_BANCO_BD   = 'pedidos_venda';
  C_USUARIO_BD = 'root';
  C_SENHA_BD   = '1234';

implementation

{ TConexao }

constructor TConexao.CreateInterno;
begin
  inherited Create;
  FConexaoDB := TFDConnection.Create(nil);
  Configurar;
end;

destructor TConexao.Destroy;
begin
  if Assigned(FConexaoDB) then
  begin
    if FConexaoDB.Connected then
      FConexaoDB.Close;
    FConexaoDB.Free;
  end;
  inherited Destroy;
end;

procedure TConexao.Configurar;
begin
  FConexaoDB.DriverName  := 'MySQL';
  FConexaoDB.LoginPrompt := False;

  FConexaoDB.Params.Clear;
  FConexaoDB.Params.Values['DriverID']        := 'MySQL';
  FConexaoDB.Params.Values['Server']          := C_HOST_BD;
  FConexaoDB.Params.Values['Port']            := C_PORTA_BD;
  FConexaoDB.Params.Values['Database']        := C_BANCO_BD;
  FConexaoDB.Params.Values['User_Name']       := C_USUARIO_BD;
  FConexaoDB.Params.Values['Password']        := C_SENHA_BD;
  FConexaoDB.Params.Values['CharacterSet']     := 'utf8';
  FConexaoDB.Params.Values['SSLMode']          := 'disabled';
  FConexaoDB.Params.Values['UseSSL']           := 'False';
  FConexaoDB.Params.Values['MYSQL_OPT_SSL_MODE'] := '1';
end;

class function TConexao.GetInstancia: TConexao;
begin
  if not Assigned(FInstancia) then
    FInstancia := TConexao.CreateInterno;
  Result := FInstancia;
end;

class procedure TConexao.LiberarInstancia;
begin
  if Assigned(FInstancia) then
    FreeAndNil(FInstancia);
end;

function TConexao.GetConexao: TFDConnection;
begin
  if not FConexaoDB.Connected then
    Conectar;
  Result := FConexaoDB;
end;

procedure TConexao.Conectar;
begin
  if not FConexaoDB.Connected then
    FConexaoDB.Open;
end;

procedure TConexao.Desconectar;
begin
  if FConexaoDB.Connected then
    FConexaoDB.Close;
end;

function TConexao.EstaConectado: Boolean;
begin
  Result := FConexaoDB.Connected;
end;

procedure TConexao.IniciarTransacao;
begin
  GetConexao.StartTransaction;
end;

procedure TConexao.Confirmar;
begin
  GetConexao.Commit;
end;

procedure TConexao.Cancelar;
begin
  GetConexao.Rollback;
end;

initialization
  TConexao.FInstancia := nil;

finalization
  TConexao.LiberarInstancia;

end.
