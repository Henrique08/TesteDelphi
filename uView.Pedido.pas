unit uView.Pedido;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Grids,
  uModel.Pedido,
  uModel.ItemPedido,
  uModel.Produto,
  uModel.Cliente,
  uDAO.Cliente,
  uDAO.Produto,
  uDAO.Pedido;

type

  TEstadoGrid = (egInserindo, egEditando);

  TfrmPedido = class(TForm)

    pnlCabecalho     : TPanel;
    lblNumeroPedido  : TLabel;
    edtNumeroPedido  : TEdit;
    lblDataEmissao   : TLabel;
    edtDataEmissao   : TEdit;
    lblCodigoCliente : TLabel;
    edtCodigoCliente : TEdit;
    lblNomeCliente   : TLabel;
    edtNomeCliente   : TEdit;
    lblCidadeUF      : TLabel;
    edtCidadeUF      : TEdit;

    pnlProduto      : TPanel;
    lblCodProduto   : TLabel;
    edtCodProduto   : TEdit;
    lblDescProduto  : TLabel;
    edtDescProduto  : TEdit;
    lblQuantidade   : TLabel;
    edtQuantidade   : TEdit;
    lblVrUnitario   : TLabel;
    edtVrUnitario   : TEdit;
    lblVrTotalItem  : TLabel;
    edtVrTotalItem  : TEdit;
    btnInserirItem  : TButton;

    pnlGrid  : TPanel;
    grdItens : TStringGrid;

    pnlRodape         : TPanel;
    lblTotalPedido    : TLabel;
    edtTotalPedido    : TEdit;
    btnNovoPedido     : TButton;
    btnGravarPedido   : TButton;
    btnCarregarPedido : TButton;
    btnExcluirPedido  : TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure edtCodigoClienteExit(Sender: TObject);
    procedure edtCodigoClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoClienteKeyDown(Sender: TObject; var Key: Word;
                                      Shift: TShiftState);

    procedure edtCodProdutoKeyUp(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure edtCodProdutoKeyPress(Sender: TObject; var Key: Char);

    procedure edtQuantidadeChange(Sender: TObject);
    procedure edtQuantidadeKeyDown(Sender: TObject; var Key: Word;
                                   Shift: TShiftState);

    procedure edtVrUnitarioChange(Sender: TObject);
    procedure edtVrUnitarioKeyDown(Sender: TObject; var Key: Word;
                                   Shift: TShiftState);

    procedure btnInserirItemClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure btnExcluirPedidoClick(Sender: TObject);
    procedure btnNovoPedidoClick(Sender: TObject);

    procedure grdItensKeyDown(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
    procedure grdItensSelectCell(Sender: TObject; ACol, ARow: Integer;
                                 var CanSelect: Boolean);

  private
    FPedido      : TPedido;
    FDAOCliente  : TDAOCliente;
    FDAOProduto  : TDAOProduto;
    FDAOPedido   : TDAOPedido;
    FEstadoGrid  : TEstadoGrid;
    FLinhaEdicao : Integer;

    procedure InicializarGrid;
    procedure ConfigurarFormulario;

    procedure LimparEntradaProduto;
    procedure LimparGrid;
    procedure AtualizarGrid;
    procedure AtualizarTotalRodape;
    procedure AtualizarVisibilidadeBotoes;

    procedure BuscarEExibirCliente;
    procedure BuscarProduto;
    procedure CarregarPedidoNaTela(const APedido: TPedido);
    procedure CarregarItemParaEdicao(ARow: Integer);
    procedure AdicionarItemNoGrid(const AItem: TItemPedido; ARow: Integer);

    function LinhaParaIndice(ARow: Integer): Integer;

    function ValidarEntradaItem: Boolean;
    function ValidarClienteInformado: Boolean;

  end;

var
  frmPedido: TfrmPedido;

implementation

{$R *.dfm}

const
  COL_CODIGO     = 0;
  COL_DESCRICAO  = 1;
  COL_QUANTIDADE = 2;
  COL_UNITARIO   = 3;
  COL_TOTAL      = 4;
  LINHA_HEADER   = 0;

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  FPedido      := TPedido.Create;
  FDAOCliente  := TDAOCliente.Create;
  FDAOProduto  := TDAOProduto.Create;
  FDAOPedido   := TDAOPedido.Create;
  FEstadoGrid  := egInserindo;
  FLinhaEdicao := -1;

  InicializarGrid;
  ConfigurarFormulario;
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  FDAOPedido.Free;
  FDAOProduto.Free;
  FDAOCliente.Free;
  FPedido.Free;
end;

procedure TfrmPedido.InicializarGrid;
begin
  grdItens.RowCount  := 2;
  grdItens.FixedRows := 1;
  grdItens.FixedCols := 0;

  grdItens.ColWidths[COL_CODIGO]     := 65;
  grdItens.ColWidths[COL_DESCRICAO]  := 360;
  grdItens.ColWidths[COL_QUANTIDADE] := 80;
  grdItens.ColWidths[COL_UNITARIO]   := 100;
  grdItens.ColWidths[COL_TOTAL]      := 100;

  grdItens.Cells[COL_CODIGO,     LINHA_HEADER] := 'Codigo';
  grdItens.Cells[COL_DESCRICAO,  LINHA_HEADER] := 'Descricao';
  grdItens.Cells[COL_QUANTIDADE, LINHA_HEADER] := 'Qtd';
  grdItens.Cells[COL_UNITARIO,   LINHA_HEADER] := 'Vr. Unit.';
  grdItens.Cells[COL_TOTAL,      LINHA_HEADER] := 'Vr. Total';
end;

procedure TfrmPedido.ConfigurarFormulario;
begin
  KeyPreview             := True;
  edtDataEmissao.Text    := FormatDateTime('dd/mm/yyyy', Now);
  edtNumeroPedido.Text   := '(novo)';
  edtDescProduto.Enabled := False;
  edtVrTotalItem.Enabled := False;
  edtNomeCliente.Enabled := False;
  edtCidadeUF.Enabled    := False;
  edtTotalPedido.Text    := 'R$ 0,00';
  AtualizarVisibilidadeBotoes;
end;

procedure TfrmPedido.FormKeyDown(Sender: TObject; var Key: Word;
                                 Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and (FEstadoGrid = egEditando) then
  begin
    LimparEntradaProduto;
    Key := 0;
  end;
end;

procedure TfrmPedido.edtCodigoClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmPedido.edtCodigoClienteKeyDown(Sender: TObject; var Key: Word;
                                              Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if Trim(edtCodigoCliente.Text) <> '' then
    begin
      BuscarEExibirCliente;
      AtualizarVisibilidadeBotoes;
    end;
    edtCodProduto.SetFocus;
    Key := 0;
  end;
end;

procedure TfrmPedido.edtCodigoClienteExit(Sender: TObject);
begin
  if Trim(edtCodigoCliente.Text) = '' then
  begin
    FPedido.Cliente.Limpar;
    edtNomeCliente.Text := '';
    edtCidadeUF.Text    := '';
    AtualizarVisibilidadeBotoes;
    Exit;
  end;

  BuscarEExibirCliente;
  AtualizarVisibilidadeBotoes;
end;

procedure TfrmPedido.BuscarEExibirCliente;
var
  LCliente : TCliente;
  LCodigo  : Integer;
begin
  LCodigo := StrToIntDef(edtCodigoCliente.Text, 0);
  if LCodigo <= 0 then
    Exit;

  if FDAOCliente.BuscarPorCodigo(LCodigo, LCliente) then
  begin
    try
      FPedido.Cliente.Codigo := LCliente.Codigo;
      FPedido.Cliente.Nome   := LCliente.Nome;
      FPedido.Cliente.Cidade := LCliente.Cidade;
      FPedido.Cliente.UF     := LCliente.UF;

      edtNomeCliente.Text := LCliente.Nome;
      edtCidadeUF.Text    := LCliente.Cidade + ' / ' + LCliente.UF;
    finally
      LCliente.Free;
    end;
  end
  else
  begin
    ShowMessage('Cliente nao encontrado.');
    edtCodigoCliente.Clear;
    edtCodigoCliente.SetFocus;
    FPedido.Cliente.Limpar;
    edtNomeCliente.Text := '';
    edtCidadeUF.Text    := '';
  end;
end;

procedure TfrmPedido.edtCodProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmPedido.edtCodProdutoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;

    if Trim(edtCodProduto.Text) = '' then
      Exit;

    BuscarProduto;

    if Trim(edtDescProduto.Text) <> '' then
    begin
      if Trim(edtQuantidade.Text) = '' then
        edtQuantidade.Text := '1';

      edtQuantidade.SetFocus;
      edtQuantidade.SelectAll;
    end;
  end;
end;

procedure TfrmPedido.edtCodProdutoExit(Sender: TObject);
begin
  if Trim(edtCodProduto.Text) = '' then
  begin
    edtDescProduto.Text := '';
    Exit;
  end;

  BuscarProduto;
end;

procedure TfrmPedido.BuscarProduto;
var
  LProduto : TProduto;
  LCodigo  : Integer;
begin
  edtDescProduto.Text := '';
  LCodigo := StrToIntDef(edtCodProduto.Text, 0);
  if LCodigo <= 0 then
    Exit;

  if FDAOProduto.BuscarPorCodigo(LCodigo, LProduto) then
  begin
    try
      edtDescProduto.Text := LProduto.Descricao;

      if Trim(edtVrUnitario.Text) = '' then
        edtVrUnitario.Text := FormatFloat('0.00', LProduto.PrecoVenda);
    finally
      LProduto.Free;
    end;
  end
  else
  begin
    ShowMessage('Produto nao encontrado.');
    edtCodProduto.Clear;
    edtCodProduto.SetFocus;
  end;
end;

procedure TfrmPedido.edtQuantidadeChange(Sender: TObject);
var
  LQtd  : Double;
  LUnit : Double;
begin
  LQtd  := StrToFloatDef(edtQuantidade.Text, 0);
  LUnit := StrToFloatDef(edtVrUnitario.Text, 0);
  edtVrTotalItem.Text := FormatFloat('0.00', LQtd * LUnit);
end;

procedure TfrmPedido.edtQuantidadeKeyDown(Sender: TObject; var Key: Word;
                                          Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    edtVrUnitario.SetFocus;
    edtVrUnitario.SelectAll;
    Key := 0;
  end;
end;

procedure TfrmPedido.edtVrUnitarioChange(Sender: TObject);
begin
  edtQuantidadeChange(Sender);
end;

procedure TfrmPedido.edtVrUnitarioKeyDown(Sender: TObject; var Key: Word;
                                          Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    btnInserirItemClick(Sender);
    Key := 0;
  end;
end;

procedure TfrmPedido.btnInserirItemClick(Sender: TObject);
var
  LItem   : TItemPedido;
  LIndice : Integer;
begin
  if not ValidarEntradaItem then
    Exit;

  case FEstadoGrid of

    egInserindo:
    begin
      LItem               := TItemPedido.Create;
      LItem.CodigoProduto := StrToInt(edtCodProduto.Text);
      LItem.Descricao     := edtDescProduto.Text;
      LItem.Quantidade    := StrToFloat(edtQuantidade.Text);
      LItem.VrUnitario    := StrToFloat(edtVrUnitario.Text);
      FPedido.Itens.Add(LItem);
    end;

    egEditando:
    begin
      LIndice          := LinhaParaIndice(FLinhaEdicao);
      LItem            := FPedido.Itens[LIndice];
      LItem.Quantidade := StrToFloat(edtQuantidade.Text);
      LItem.VrUnitario := StrToFloat(edtVrUnitario.Text);
    end;

  end;

  AtualizarGrid;
  AtualizarTotalRodape;
  LimparEntradaProduto;
  edtCodProduto.SetFocus;
end;

procedure TfrmPedido.btnGravarPedidoClick(Sender: TObject);
var
  LNumero : Integer;
begin
  if not ValidarClienteInformado then
    Exit;

  if FPedido.Itens.Count = 0 then
  begin
    ShowMessage('Informe ao menos um item antes de gravar o pedido.');
    Exit;
  end;

  try
    LNumero := FDAOPedido.Gravar(FPedido);
    edtNumeroPedido.Text := IntToStr(LNumero);
    ShowMessage(Format('Pedido %d gravado com sucesso!', [LNumero]));

    FPedido.Itens.Clear;
    LimparGrid;
    AtualizarTotalRodape;
    LimparEntradaProduto;

    edtNumeroPedido.Text  := '(novo)';
    edtDataEmissao.Text   := FormatDateTime('dd/mm/yyyy', Now);
    edtCodigoCliente.Text := '';
    edtNomeCliente.Text   := '';
    edtCidadeUF.Text      := '';

    edtCodProduto.SetFocus;
  except
    on E: Exception do
      ShowMessage('Erro ao gravar o pedido: ' + E.Message);
  end;
end;

procedure TfrmPedido.btnCarregarPedidoClick(Sender: TObject);
var
  LNumeroStr : string;
  LNumero    : Integer;
  LPedido    : TPedido;
begin
  LNumeroStr := InputBox('Carregar Pedido', 'Informe o numero do pedido:', '');
  if Trim(LNumeroStr) = '' then
    Exit;

  LNumero := StrToIntDef(LNumeroStr, 0);
  if LNumero <= 0 then
  begin
    ShowMessage('Numero de pedido invalido.');
    Exit;
  end;

  try
    if FDAOPedido.Carregar(LNumero, LPedido) then
    begin
      FreeAndNil(FPedido);
      FPedido := LPedido;
      CarregarPedidoNaTela(FPedido);
    end
    else
      ShowMessage(Format('Pedido numero %d nao encontrado.', [LNumero]));
  except
    on E: Exception do
      ShowMessage('Erro ao carregar o pedido: ' + E.Message);
  end;
end;

procedure TfrmPedido.CarregarPedidoNaTela(const APedido: TPedido);
begin
  edtNumeroPedido.Text  := IntToStr(APedido.NumeroPedido);
  edtDataEmissao.Text   := FormatDateTime('dd/mm/yyyy', APedido.DataEmissao);
  edtCodigoCliente.Text := IntToStr(APedido.Cliente.Codigo);
  edtNomeCliente.Text   := APedido.Cliente.Nome;
  edtCidadeUF.Text      := APedido.Cliente.Cidade + ' / ' + APedido.Cliente.UF;

  AtualizarGrid;
  AtualizarTotalRodape;
  AtualizarVisibilidadeBotoes;
end;

procedure TfrmPedido.btnExcluirPedidoClick(Sender: TObject);
var
  LNumeroStr : string;
  LNumero    : Integer;
begin
  LNumeroStr := InputBox('Excluir Pedido',
                         'Informe o numero do pedido a excluir:', '');
  if Trim(LNumeroStr) = '' then
    Exit;

  LNumero := StrToIntDef(LNumeroStr, 0);
  if LNumero <= 0 then
  begin
    ShowMessage('Numero de pedido invalido.');
    Exit;
  end;

  if MessageDlg(
       Format('Confirma a exclusao do pedido %d e todos os seus itens?',
              [LNumero]),
       mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    FDAOPedido.Excluir(LNumero);
    ShowMessage(Format('Pedido %d excluido com sucesso!', [LNumero]));
  except
    on E: Exception do
      ShowMessage('Erro ao excluir o pedido: ' + E.Message);
  end;
end;

procedure TfrmPedido.btnNovoPedidoClick(Sender: TObject);
begin
  FPedido.Limpar;
  edtNumeroPedido.Text  := '(novo)';
  edtDataEmissao.Text   := FormatDateTime('dd/mm/yyyy', Now);
  edtCodigoCliente.Text := '';
  edtNomeCliente.Text   := '';
  edtCidadeUF.Text      := '';

  LimparEntradaProduto;
  LimparGrid;
  AtualizarTotalRodape;
  AtualizarVisibilidadeBotoes;

  edtCodigoCliente.SetFocus;
end;

procedure TfrmPedido.grdItensKeyDown(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);
var
  LIndice : Integer;
begin
  case Key of

    VK_RETURN:
    begin
      if grdItens.Row <= LINHA_HEADER then
        Exit;

      LIndice := LinhaParaIndice(grdItens.Row);
      if (LIndice < 0) or (LIndice >= FPedido.Itens.Count) then
        Exit;

      CarregarItemParaEdicao(grdItens.Row);
      edtQuantidade.SetFocus;
      edtQuantidade.SelectAll;
      Key := 0;
    end;

    VK_DELETE:
    begin
      if grdItens.Row <= LINHA_HEADER then
        Exit;

      LIndice := LinhaParaIndice(grdItens.Row);
      if (LIndice < 0) or (LIndice >= FPedido.Itens.Count) then
        Exit;

      if MessageDlg('Deseja realmente excluir este item?',
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        FPedido.Itens.Delete(LIndice);
        LimparGrid;
        AtualizarGrid;
        AtualizarTotalRodape;
      end;

      Key := 0;
    end;

  end;
end;

procedure TfrmPedido.grdItensSelectCell(Sender: TObject; ACol, ARow: Integer;
                                        var CanSelect: Boolean);
begin
  CanSelect := True;
end;

procedure TfrmPedido.LimparEntradaProduto;
begin
  edtCodProduto.Text     := '';
  edtDescProduto.Text    := '';
  edtQuantidade.Text     := '';
  edtVrUnitario.Text     := '';
  edtVrTotalItem.Text    := '';
  btnInserirItem.Caption := 'Inserir Item';
  FEstadoGrid            := egInserindo;
  FLinhaEdicao           := -1;
end;

procedure TfrmPedido.LimparGrid;
var
  I : Integer;
begin
  for I := 1 to grdItens.RowCount - 1 do
  begin
    grdItens.Cells[COL_CODIGO,     I] := '';
    grdItens.Cells[COL_DESCRICAO,  I] := '';
    grdItens.Cells[COL_QUANTIDADE, I] := '';
    grdItens.Cells[COL_UNITARIO,   I] := '';
    grdItens.Cells[COL_TOTAL,      I] := '';
  end;

  grdItens.RowCount := 2;
end;

procedure TfrmPedido.AtualizarGrid;
var
  I    : Integer;
  LQtd : Integer;
begin
  LQtd := FPedido.Itens.Count;
  grdItens.RowCount := Max(LQtd + 1, 2);

  for I := 0 to LQtd - 1 do
    AdicionarItemNoGrid(FPedido.Itens[I], I + 1);
end;

procedure TfrmPedido.AdicionarItemNoGrid(const AItem: TItemPedido; ARow: Integer);
begin
  grdItens.Cells[COL_CODIGO,     ARow] := IntToStr(AItem.CodigoProduto);
  grdItens.Cells[COL_DESCRICAO,  ARow] := AItem.Descricao;
  grdItens.Cells[COL_QUANTIDADE, ARow] := FormatFloat('0.000', AItem.Quantidade);
  grdItens.Cells[COL_UNITARIO,   ARow] := FormatFloat('0.00',  AItem.VrUnitario);
  grdItens.Cells[COL_TOTAL,      ARow] := FormatFloat('0.00',  AItem.VrTotal);
end;

procedure TfrmPedido.AtualizarTotalRodape;
begin
  edtTotalPedido.Text := FormatFloat('R$ #,##0.00', FPedido.ValorTotal);
end;

procedure TfrmPedido.AtualizarVisibilidadeBotoes;
var
  LClienteVazio : Boolean;
begin
  LClienteVazio := Trim(edtCodigoCliente.Text) = '';

  btnCarregarPedido.Visible := LClienteVazio;
  btnExcluirPedido.Visible  := LClienteVazio;
  btnGravarPedido.Enabled   := not LClienteVazio;
end;

procedure TfrmPedido.CarregarItemParaEdicao(ARow: Integer);
var
  LItem : TItemPedido;
begin
  LItem := FPedido.Itens[LinhaParaIndice(ARow)];

  edtCodProduto.Text     := IntToStr(LItem.CodigoProduto);
  edtDescProduto.Text    := LItem.Descricao;
  edtQuantidade.Text     := FormatFloat('0.000', LItem.Quantidade);
  edtVrUnitario.Text     := FormatFloat('0.00',  LItem.VrUnitario);
  edtVrTotalItem.Text    := FormatFloat('0.00',  LItem.VrTotal);
  FEstadoGrid            := egEditando;
  FLinhaEdicao           := ARow;
  btnInserirItem.Caption := 'Atualizar Item';
end;

function TfrmPedido.LinhaParaIndice(ARow: Integer): Integer;
begin
  Result := ARow - 1;
end;

function TfrmPedido.ValidarEntradaItem: Boolean;
begin
  Result := False;

  if Trim(edtCodProduto.Text) = '' then
  begin
    edtCodProduto.SetFocus;
    Exit;
  end;

  if Trim(edtDescProduto.Text) = '' then
  begin
    if Trim(edtCodProduto.Text) <> '' then
    begin
      edtQuantidade.SetFocus;
      Exit;
    end;
  end;

  if StrToFloatDef(edtQuantidade.Text, 0) <= 0 then
  begin
    ShowMessage('Informe uma quantidade valida (maior que zero).');
    edtQuantidade.SetFocus;
    Exit;
  end;

  if StrToFloatDef(edtVrUnitario.Text, 0) <= 0 then
  begin
    ShowMessage('Informe um valor unitario valido (maior que zero).');
    edtVrUnitario.SetFocus;
    Exit;
  end;

  Result := True;
end;

function TfrmPedido.ValidarClienteInformado: Boolean;
begin
  Result := FPedido.Cliente.Codigo > 0;
  if not Result then
    ShowMessage('Informe o cliente antes de gravar o pedido.');
end;

end.
