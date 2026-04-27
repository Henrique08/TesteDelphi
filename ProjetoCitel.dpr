program ProjetoCitel;

uses
  Vcl.Forms,
  uView.Pedido    in 'uView.Pedido.pas'    {frmPedido},
  uDAO.Conexao    in 'uDAO.Conexao.pas',
  uDAO.Cliente    in 'uDAO.Cliente.pas',
  uDAO.Produto    in 'uDAO.Produto.pas',
  uDAO.Pedido     in 'uDAO.Pedido.pas',
  uModel.Cliente  in 'uModel.Cliente.pas',
  uModel.Produto  in 'uModel.Produto.pas',
  uModel.Pedido   in 'uModel.Pedido.pas',
  uModel.ItemPedido in 'uModel.ItemPedido.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedido, frmPedido);
  Application.Run;
end.
