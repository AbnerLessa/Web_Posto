unit PessoaFisicaForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  fphttpclient, fpjson, jsonparser, Pessoas;

type

  { TForm2 }

  TForm2 = class(TForm)
    Adicionar: TButton;
    DBGrid1: TDBGrid;
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
    procedure RegistradosClick(Sender: TObject);

  private
    procedure BuscarEnderecoPeloCEP(const ACep: string);
  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
begin
end;

procedure TForm2.RegistradosClick(Sender: TObject);
begin
  ShowMessage('Consulta de pessoas físicas local simulada.');
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
  Pessoa.ExibirResumo;
  Pessoa.Free;
  Self.Hide;
end;

procedure TForm2.CancelarClick(Sender: TObject);
begin
  Self.Hide;
end;

end.

