library MQTTEngineDLL;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  uConfigParser in 'uConfigParser.pas',
  uModel.Abstraction in 'Model\uModel.Abstraction.pas',
  uModel.FireDACEngineException in 'Model\uModel.FireDACEngineException.pas',
  uModel.FireDAC in 'Model\Repository\uModel.FireDAC.pas',
  uModel.Repository.DataManager in 'Model\Repository\uModel.Repository.DataManager.pas',
  uModel.DataManagerFactory in 'Model\Repository\uModel.DataManagerFactory.pas',
  uModel.Repository.Medidas in 'Model\Repository\uModel.Repository.Medidas.pas';

{$R *.res}

function Save(const Rede, Remota: Integer; const Medidas: TDecimais): Boolean; stdcall;
var
  Medida: TMedidaRepository;
begin
  DataManager := TDataManagerFactory.GetDataManager;
  try
    Medida := TMedidaRepository.Create;
    try
      Result := Medida.Save(DataManager, Rede, Remota, Medidas);

    finally
      FreeAndNil(Medida);
    end;

  finally
    DataManager.Connection.Close;
  end;
end;

exports
  Save;

begin
end.
