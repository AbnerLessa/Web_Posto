unit Unit4;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TPessoa = class
  protected
    FNome: string;
    FTelefone: string;
    FCEP: string;
    FEndereco: string;
  public
    constructor Create(const ANome, ATelefone, ACEP, AEndereco: string); virtual;
    procedure ExibirResumo; virtual;
    property Nome: string read FNome write FNome;
    property Telefone: string read FTelefone write FTelefone;
    property CEP: string read FCEP write FCEP;
    property Endereco: string read FEndereco write FEndereco;
  end;

  TPessoaFisica = class(TPessoa)
  private
    FCPF: string;
  public
    constructor Create(const ANome, ATelefone, ACEP, AEndereco, ACPF: string); reintroduce;
    procedure ExibirResumo; override;
    property CPF: string read FCPF write FCPF;
  end;

  TPessoaJuridica = class(TPessoa)
  private
    FCNPJ: string;
  public
    constructor Create(const ANome, ATelefone, ACEP, AEndereco, ACNPJ: string); reintroduce;
    procedure ExibirResumo; override;
    property CNPJ: string read FCNPJ write FCNPJ;
  end;

implementation

{ TPessoa }

constructor TPessoa.Create(const ANome, ATelefone, ACEP, AEndereco: string);
begin
  FNome := ANome;
  FTelefone := ATelefone;
  FCEP := ACEP;
  FEndereco := AEndereco;
end;

procedure TPessoa.ExibirResumo;
begin
  WriteLn('Nome: ', FNome);
  WriteLn('Telefone: ', FTelefone);
  WriteLn('CEP: ', FCEP);
  WriteLn('Endereço: ', FEndereco);
end;

{ TPessoaFisica }

constructor TPessoaFisica.Create(const ANome, ATelefone, ACEP, AEndereco, ACPF: string);
begin
  inherited Create(ANome, ATelefone, ACEP, AEndereco);
  FCPF := ACPF;
end;

procedure TPessoaFisica.ExibirResumo;
begin
  inherited ExibirResumo;
  WriteLn('CPF: ', FCPF);
end;

{ TPessoaJuridica }

constructor TPessoaJuridica.Create(const ANome, ATelefone, ACEP, AEndereco, ACNPJ: string);
begin
  inherited Create(ANome, ATelefone, ACEP, AEndereco);
  FCNPJ := ACNPJ;
end;

procedure TPessoaJuridica.ExibirResumo;
begin
  inherited ExibirResumo;
  WriteLn('CNPJ: ', FCNPJ);
end;

end.
