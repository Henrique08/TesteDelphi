object frmPedido: TfrmPedido
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 640
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 17
  object pnlCabecalho: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 115
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 894
    object lblNumeroPedido: TLabel
      Left = 12
      Top = 10
      Width = 113
      Height = 17
      Caption = 'N'#250'mero do Pedido'
    end
    object lblDataEmissao: TLabel
      Left = 124
      Top = 10
      Width = 79
      Height = 17
      Caption = 'Data Emiss'#227'o'
    end
    object lblCodigoCliente: TLabel
      Left = 12
      Top = 66
      Width = 70
      Height = 17
      Caption = 'C'#243'd. Cliente'
    end
    object lblNomeCliente: TLabel
      Left = 104
      Top = 66
      Width = 36
      Height = 17
      Caption = 'Nome'
    end
    object lblCidadeUF: TLabel
      Left = 476
      Top = 66
      Width = 69
      Height = 17
      Caption = 'Cidade / UF'
    end
    object edtNumeroPedido: TEdit
      Left = 12
      Top = 30
      Width = 100
      Height = 25
      Enabled = False
      TabOrder = 0
      Text = '(novo)'
    end
    object edtDataEmissao: TEdit
      Left = 124
      Top = 30
      Width = 100
      Height = 25
      Enabled = False
      TabOrder = 1
    end
    object edtCodigoCliente: TEdit
      Left = 12
      Top = 86
      Width = 80
      Height = 25
      MaxLength = 9
      TabOrder = 2
      OnExit = edtCodigoClienteExit
      OnKeyDown = edtCodigoClienteKeyDown
      OnKeyPress = edtCodigoClienteKeyPress
    end
    object edtNomeCliente: TEdit
      Left = 104
      Top = 86
      Width = 360
      Height = 25
      Enabled = False
      TabOrder = 3
    end
    object edtCidadeUF: TEdit
      Left = 476
      Top = 86
      Width = 220
      Height = 25
      Enabled = False
      TabOrder = 4
    end
  end
  object pnlProduto: TPanel
    Left = 0
    Top = 115
    Width = 900
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 894
    object lblCodProduto: TLabel
      Left = 12
      Top = 6
      Width = 78
      Height = 17
      Caption = 'C'#243'd. Produto'
    end
    object lblDescProduto: TLabel
      Left = 104
      Top = 6
      Width = 128
      Height = 17
      Caption = 'Descri'#231#227'o do Produto'
    end
    object lblQuantidade: TLabel
      Left = 386
      Top = 6
      Width = 68
      Height = 17
      Caption = 'Quantidade'
    end
    object lblVrUnitario: TLabel
      Left = 478
      Top = 6
      Width = 66
      Height = 17
      Caption = 'Vr. Unit'#225'rio'
    end
    object lblVrTotalItem: TLabel
      Left = 580
      Top = 6
      Width = 48
      Height = 17
      Caption = 'Vr. Total'
    end
    object edtCodProduto: TEdit
      Left = 12
      Top = 26
      Width = 80
      Height = 25
      MaxLength = 9
      TabOrder = 0
      OnExit = edtCodProdutoExit
      OnKeyPress = edtCodProdutoKeyPress
      OnKeyUp = edtCodProdutoKeyUp
    end
    object edtDescProduto: TEdit
      Left = 104
      Top = 26
      Width = 270
      Height = 25
      Enabled = False
      TabOrder = 1
    end
    object edtQuantidade: TEdit
      Left = 386
      Top = 26
      Width = 80
      Height = 25
      TabOrder = 2
      OnChange = edtQuantidadeChange
      OnKeyDown = edtQuantidadeKeyDown
    end
    object edtVrUnitario: TEdit
      Left = 478
      Top = 26
      Width = 90
      Height = 25
      TabOrder = 3
      OnChange = edtVrUnitarioChange
      OnKeyDown = edtVrUnitarioKeyDown
    end
    object edtVrTotalItem: TEdit
      Left = 580
      Top = 26
      Width = 90
      Height = 25
      Enabled = False
      TabOrder = 4
    end
    object btnInserirItem: TButton
      Left = 686
      Top = 24
      Width = 130
      Height = 29
      Caption = 'Inserir Item'
      TabOrder = 5
      OnClick = btnInserirItemClick
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 185
    Width = 900
    Height = 365
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 894
    ExplicitHeight = 348
    object grdItens: TStringGrid
      Left = 0
      Top = 0
      Width = 900
      Height = 365
      Align = alClient
      DefaultColWidth = 100
      DefaultRowHeight = 22
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      ScrollBars = ssVertical
      TabOrder = 0
      OnKeyDown = grdItensKeyDown
      OnSelectCell = grdItensSelectCell
      ExplicitWidth = 894
      ExplicitHeight = 348
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 550
    Width = 900
    Height = 90
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 533
    ExplicitWidth = 894
    object lblTotalPedido: TLabel
      Left = 12
      Top = 10
      Width = 134
      Height = 17
      Caption = 'Valor Total do Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtTotalPedido: TEdit
      Left = 12
      Top = 30
      Width = 160
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'R$ 0,00'
    end
    object btnNovoPedido: TButton
      Left = 390
      Top = 26
      Width = 110
      Height = 33
      Caption = 'Novo Pedido'
      TabOrder = 1
      OnClick = btnNovoPedidoClick
    end
    object btnGravarPedido: TButton
      Left = 512
      Top = 26
      Width = 130
      Height = 33
      Caption = 'Gravar Pedido'
      TabOrder = 2
      OnClick = btnGravarPedidoClick
    end
    object btnCarregarPedido: TButton
      Left = 654
      Top = 26
      Width = 110
      Height = 33
      Caption = 'Carregar Pedido'
      TabOrder = 3
      OnClick = btnCarregarPedidoClick
    end
    object btnExcluirPedido: TButton
      Left = 776
      Top = 26
      Width = 110
      Height = 33
      Caption = 'Excluir Pedido'
      TabOrder = 4
      OnClick = btnExcluirPedidoClick
    end
  end
end
