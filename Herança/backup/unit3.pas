unit PessoaJuridicaForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  fphttpclient, fpjson, jsonparser, Pessoas;

type

  { TForm3 }

  TForm3 = class(TForm)
    Adicionar: TButton;
    DBGrid1: TDBGrid;
    Registrados: TButton;
    Cancelar: TButton;
    CEP: TEdit;
    Telefone: TEdit;
    Nome: TEdit;
    Endereco: TEdit;
    CNPJ: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;

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
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.FormCreate(Sender: TObject);
begin
end;

procedure TForm3.RegistradosClick(Sender: TObject);
begin
  ShowMessage('Consulta de empresas local simulada.');
end;

procedure TForm3.CEPChange(Sender: TObject);
begin
  if Length(CEP.Text) = 8 then
    BuscarEnderecoPeloCEP(CEP.Text);
end;

procedure TForm3.BuscarEnderecoPeloCEP(const ACep: string);
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

procedure TForm3.AdicionarClick(Sender: TObject);
var
  Empresa: TPessoaJuridica;
begin
  Empresa := TPessoaJuridica.Create(Nome.Text, Telefone.Text, CEP.Text, Endereco.Text, CNPJ.Text);
  Empresa.ExibirResumo;
  Empresa.Free;
  Self.Hide;
end;

procedure TForm3.CancelarClick(Sender: TObject);
begin
  Self.Hide;
end;

end.

