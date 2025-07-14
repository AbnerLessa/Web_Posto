unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  PessoaFisicaForm, PessoaJuridicaForm, Unit4;

type

  { TForm1 }

  TForm1 = class(TForm)
    Cadastro: TButton;
    CadastroPJ: TButton;
    Label1: TLabel;
    procedure CadastroClick(Sender: TObject);
    procedure CadastroPJClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    ListaPessoas: TList;
    procedure AdicionarPessoaFisica(P: TPessoaFisica);
    procedure AdicionarPessoaJuridica(P: TPessoaJuridica);
    procedure SalvarDados;
    procedure CarregarDados;
  end;

var
  Form1: TForm1;

implementation

uses
  StrUtils;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListaPessoas := TList.Create;
  CarregarDados;
end;

procedure TForm1.CadastroClick(Sender: TObject);
begin
  Form2 := TForm2.Create(nil);
  Form2.Show;
end;

procedure TForm1.CadastroPJClick(Sender: TObject);
begin
  Form3 := TForm3.Create(nil);
  Form3.Show;
end;

procedure TForm1.AdicionarPessoaFisica(P: TPessoaFisica);
begin
  ListaPessoas.Add(P);
  SalvarDados;
end;

procedure TForm1.AdicionarPessoaJuridica(P: TPessoaJuridica);
begin
  ListaPessoas.Add(P);
  SalvarDados;
end;

procedure TForm1.SalvarDados;
var
  Linhas: TStringList;
  i: Integer;
  pessoa: TPessoa;
  pf: TPessoaFisica;
  pj: TPessoaJuridica;
  linhaCSV: string;
begin
  Linhas := TStringList.Create;
  try
    for i := 0 to ListaPessoas.Count - 1 do
    begin
      pessoa := TPessoa(ListaPessoas[i]);
      if pessoa is TPessoaFisica then
      begin
        pf := TPessoaFisica(pessoa);
        linhaCSV := Format('FISICA;%s;%s;%s;%s;%s', [pf.Nome, pf.Telefone, pf.CEP, pf.Endereco, pf.CPF]);
        Linhas.Add(linhaCSV);
      end
      else if pessoa is TPessoaJuridica then
      begin
        pj := TPessoaJuridica(pessoa);
        linhaCSV := Format('JURIDICA;%s;%s;%s;%s;%s', [pj.Nome, pj.Telefone, pj.CEP, pj.Endereco, pj.CNPJ]);
        Linhas.Add(linhaCSV);
      end;
    end;
    Linhas.SaveToFile('pessoas.csv');
  finally
    Linhas.Free;
  end;
end;

procedure TForm1.CarregarDados;
var
  Linhas: TStringList;
  i: Integer;
  partes: array of string;
  tipo: string;
  pessoa: TPessoa;
begin
  if not FileExists('pessoas.csv') then Exit;

  Linhas := TStringList.Create;
  try
    Linhas.LoadFromFile('pessoas.csv');

    for i := 0 to Linhas.Count - 1 do
    begin
      partes := Linhas[i].Split(';');
      if Length(partes) < 6 then Continue;

      tipo := partes[0];

      if tipo = 'FISICA' then
      begin
        pessoa := TPessoaFisica.Create(partes[1], partes[2], partes[3], partes[4], partes[5]);
        ListaPessoas.Add(pessoa);
      end
      else if tipo = 'JURIDICA' then
      begin
        pessoa := TPessoaJuridica.Create(partes[1], partes[2], partes[3], partes[4], partes[5]);
        ListaPessoas.Add(pessoa);
      end;
    end;
  finally
    Linhas.Free;
  end;
end;

end.

