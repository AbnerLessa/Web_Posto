unit PessoaFisicaForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fphttpclient, fpjson, jsonparser, Unit4;

type

  { TForm2 }

  TForm2 = class(TForm)
    Adicionar: TButton;
    ListBoxEmpresas: TListBox;
    Registrados: TButton;
    Cancelar: TButton;
    CEP: TEdit;
    EditTelefone: TEdit;
    Label6: TLabel;
    Nome: TEdit;
    Endereco: TEdit;
    CPF: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Telefone: TLabel;

    procedure AdicionarClick(Sender: TObject);
    procedure CancelarClick(Sender: TObject);
    procedure CEPChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxEmpresasClick(Sender: TObject);
    procedure RegistradosClick(Sender: TObject);

  private
    procedure BuscarEnderecoPeloCEP(const ACep: string);
    procedure AtualizarListaPessoasFisicas;
  public

  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
begin
  AtualizarListaPessoasFisicas;
end;

procedure TForm2.ListBoxEmpresasClick(Sender: TObject);
begin

end;

procedure TForm2.RegistradosClick(Sender: TObject);
begin
  AtualizarListaPessoasFisicas;
end;

procedure TForm2.CEPChange(Sender: TObject);
begin
  if Length(CEP.Text) = 8 then
    BuscarEnderecoPeloCEP(CEP.Text);
end;

procedure TForm2.BuscarEnderecoPeloCEP(const ACep: string);
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

procedure TForm2.AdicionarClick(Sender: TObject);
var
  Pessoa: TPessoaFisica;
begin
  Pessoa := TPessoaFisica.Create(Nome.Text, EditTelefone.Text, CEP.Text, Endereco.Text, CPF.Text);

  if Assigned(Form1) then
  begin
    Form1.AdicionarPessoaFisica(Pessoa);
    ShowMessage('Pessoa Física adicionada com sucesso!');
    AtualizarListaPessoasFisicas;
  end
  else
  begin
    ShowMessage('Erro: Formulário principal (Form1) não está disponível.');
    Pessoa.Free;
  end;
end;

procedure TForm2.CancelarClick(Sender: TObject);
begin
  Self.Hide;
end;

procedure TForm2.AtualizarListaPessoasFisicas;
var
  i: Integer;
  P: TPessoa;
  PF: TPessoaFisica;
begin
  ListBoxEmpresas.Clear;

  for i := 0 to Form1.ListaPessoas.Count - 1 do
  begin
    P := TPessoa(Form1.ListaPessoas[i]);
    if P is TPessoaFisica then
    begin
      PF := TPessoaFisica(P);
      ListBoxEmpresas.Items.Add(PF.Nome + ' (CPF: ' + PF.CPF + ')');
    end;
  end;
end;

end.

