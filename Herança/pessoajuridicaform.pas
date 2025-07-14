unit PessoaJuridicaForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Unit4,
  fpjson, jsonparser, fphttpclient;

type
  { TForm4 }
  TForm4 = class(TForm)
    Apagar: TButton;
    CEP: TEdit;
    Endereco: TEdit;
    CNPJ: TEdit;
    Telefone: TEdit;
    Nome: TEdit;

    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;

    Adicionar: TButton;
    Cancelar: TButton;

    ListBoxPessoasJuridicas: TListBox;

    procedure AdicionarClick(Sender: TObject);
    procedure ApagarClick(Sender: TObject);
    procedure CancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CEPChange(Sender: TObject);
  private
    procedure AtualizarListaPessoasJuridicas;
    procedure BuscarEnderecoPeloCEP(const ACep: String);
  public

  end;

var
  Form4: TForm4;

implementation

uses Unit1;

{$R *.lfm}

procedure TForm4.FormCreate(Sender: TObject);
begin
  AtualizarListaPessoasJuridicas;
end;

procedure TForm4.AtualizarListaPessoasJuridicas;
var
  i: Integer;
  P: TPessoa;
  PJ: TPessoaJuridica;
begin
  ListBoxPessoasJuridicas.Clear;

  for i := 0 to Form1.ListaPessoas.Count - 1 do
  begin
    P := TPessoa(Form1.ListaPessoas[i]);
    if Assigned(P) and (P is TPessoaJuridica) then
    begin
      PJ := TPessoaJuridica(P);
      ListBoxPessoasJuridicas.Items.Add(PJ.Nome + ' - ' + PJ.CNPJ);
    end;
  end;
end;

procedure TForm4.AdicionarClick(Sender: TObject);
var
  PJ: TPessoaJuridica;
begin
  PJ := TPessoaJuridica.Create(
    Nome.Text,
    Telefone.Text,
    CEP.Text,
    Endereco.Text,
    CNPJ.Text
  );

  Form1.AdicionarPessoaJuridica(PJ);
  ShowMessage('Pessoa Jurídica cadastrada com sucesso!');
  AtualizarListaPessoasJuridicas;
end;

procedure TForm4.ApagarClick(Sender: TObject);
var
  i: Integer;
  P: TPessoa;
begin
  for i := Form1.ListaPessoas.Count - 1 downto 0 do
  begin
    P := TPessoa(Form1.ListaPessoas[i]);
    if P is TPessoaJuridica then
    begin
      Form1.ListaPessoas.Delete(i);
      P.Free;
      Break;
    end;
  end;

  AtualizarListaPessoasJuridicas;
end;


procedure TForm4.CancelarClick(Sender: TObject);
begin
  Close;
end;


procedure TForm4.CEPChange(Sender: TObject);
begin
  if Length(CEP.Text) = 8 then
    BuscarEnderecoPeloCEP(CEP.Text);
end;

//
procedure TForm4.BuscarEnderecoPeloCEP(const ACep: string);
var
  Json: TJSONData;
  Cliente: TFPHTTPClient;
  JsonParser: TJSONParser;
  Resposta: TStringStream;
begin
  Cliente := TFPHTTPClient.Create(nil);
  Resposta := TStringStream.Create('');
  try
    Cliente.Get('http://viacep.com.br/ws/' + ACep + '/json/', Resposta);
    Resposta.Position := 0;
    JsonParser := TJSONParser.Create(Resposta);
    Json := JsonParser.Parse;

    if Assigned(Json.FindPath('erro')) then
      raise Exception.Create('CEP não encontrado.');

    Endereco.Text := Json.FindPath('logradouro').AsString + ', ' +
                     Json.FindPath('bairro').AsString + ' - ' +
                     Json.FindPath('localidade').AsString + ' / ' +
                     Json.FindPath('uf').AsString;

    Json.Free;
    JsonParser.Free;
  except
    on E: Exception do
      ShowMessage('Erro ao buscar o CEP: ' + E.Message);
  end;
  Cliente.Free;
  Resposta.Free;
end;

end.

