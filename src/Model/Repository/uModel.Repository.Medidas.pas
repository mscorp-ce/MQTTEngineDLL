unit uModel.Repository.Medidas;

interface

uses
  //[dcc32 Hint] uModel.Repository.Medidas.pas(45): H2443 Inline function 'TFDParams.GetItem' has not been expanded because unit '' is not specified in USES list

  System.Classes, uModel.Abstraction;

type
  TMedidaRepository = class
  public
    function Save(const DataManager: IDataManager; const Rede,
      Remota: Integer; const Values: TDecimais): Boolean;
  end;

implementation

{ TMedidaRepository }

uses
  System.SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

function TMedidaRepository.Save(const DataManager: IDataManager; const Rede,
  Remota: Integer; const Values: TDecimais): Boolean;
var
  SPOcorrenciaTelemedida: TFDStoredProc;
  i: Integer;
begin
  SPOcorrenciaTelemedida := TFDStoredProc.Create(nil);
  try
    SPOcorrenciaTelemedida.Connection := TFDCustomConnection(DataManager.Connection);
    SPOcorrenciaTelemedida.Params.Clear;
    SPOcorrenciaTelemedida.Params.CreateParam(ftFloat, 'p_mediador', ptInput);
    SPOcorrenciaTelemedida.Params.CreateParam(ftFloat, 'p_remota', ptInput);
    SPOcorrenciaTelemedida.Params.CreateParam(ftFloat, 'p_telemedida', ptInput);
    SPOcorrenciaTelemedida.Params.CreateParam(ftFloat, 'p_valor', ptInput);

    for i := Low(Values) to High(Values) do
      begin
        SPOcorrenciaTelemedida.Params[0].Value := Rede;
        SPOcorrenciaTelemedida.Params[1].Value := Remota;
        SPOcorrenciaTelemedida.Params[2].Value := i;
        SPOcorrenciaTelemedida.Params[3].Value := Values[i];
        SPOcorrenciaTelemedida.ExecProc;
      end;

    Result := SPOcorrenciaTelemedida.RowsAffected >= 1;

  finally
    FreeAndNil(SPOcorrenciaTelemedida);
  end;
end;

end.

