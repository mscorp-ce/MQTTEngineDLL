unit uModel.FireDAC;

interface

uses
  uModel.Abstraction, System.Classes, System.SysUtils, FireDAC.Stan.Option,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Moni.RemoteClient, FireDAC.Moni.FlatFile,
  FireDAC.Moni.Base, FireDAC.Moni.Custom;

type
  TModelFireDAC = class(TInterfacedObject, IDataManager)
    procedure onRecover(ASender, AInitiator: TObject;
      AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
    procedure onOutput(ASender: TFDMoniClientLinkBase;
      const AClassName, AObjName, AMessage: string);
  private
    FConexao : TFDConnection;

    FMSSQLDriver: TFDPhysMSSQLDriverLink;

    Monitor: TFDMoniCustomClientLink;

    MonitorRemote: TFDMoniRemoteClientLink;

    Messages: TStrings;
    fEtitieName: String;
  public
    constructor Create;
    destructor Destroy; override;

    function GetStartTransaction: IDataManager;
    function GetCommit: IDataManager;
    function GetRollback: IDataManager;
    function GetEtity(EtitieName: String): IDataManager;
    function GetFieldNames: TStrings;

    function GetConnection: TCustomConnection;
    property Connection: TCustomConnection read GetConnection;
    property StartTransaction: IDataManager read GetStartTransaction;
    property Commit: IDataManager read GetCommit;
    property Rollback: IDataManager read GetRollback;
  end;

implementation

uses
  Vcl.Dialogs, Vcl.Controls, System.UITypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Error, uLibary, uModel.FireDACEngineException;

{ TModelFireDAC }

constructor TModelFireDAC.Create;
begin
  inherited Create;
  try

    FConexao := TFDConnection.Create(nil);
    FConexao.DriverName                := TLibary.GetINI('DATA_MSSMQL', 'DriverName');
    FConexao.Params.Values['Server']   := TLibary.GetINI('DATA_MSSMQL', 'Server');
    FConexao.Params.Values['Database'] := TLibary.GetINI('DATA_MSSMQL', 'Database');
    FConexao.Params.Values['User_Name']:= TLibary.GetINI('DATA_MSSMQL', 'User_Name');
    FConexao.Params.Values['Password'] := TLibary.GetINI('DATA_MSSMQL', 'Password');

    FMSSQLDriver:= TFDPhysMSSQLDriverLink.Create(nil);

    Monitor:= TFDMoniCustomClientLink.Create(nil);
    Monitor.Tracing:= false;

    MonitorRemote:= TFDMoniRemoteClientLink.Create(nil);
    MonitorRemote.Host:= '127.0.0.1';
    MonitorRemote.Port:= 8050;
    MonitorRemote.Timeout:= 3000;
    MonitorRemote.Tracing:= False;

    // MonitorRemote.EventKinds

    FConexao.Params.MonitorBy:= mbRemote;

    Messages:= TStringList.Create;

    FConexao.OnRecover:= onRecover;
    FConexao.Open;

  except
    on E: EFDDBEngineException do
      ShowMessage( TFireDACEngineException.GetMessage(E) );
  end;
end;

destructor TModelFireDAC.Destroy;
begin
  FConexao.Close;
  FreeAndNil( FConexao );
  FreeAndNil( FMSSQLDriver );
  FreeAndNil( Monitor );
  Messages.Clear;
  FreeAndNil( Messages );
  FreeAndNil( MonitorRemote );
  inherited Destroy;
end;

function TModelFireDAC.GetEtity(EtitieName: String): IDataManager;
begin
  fEtitieName:= EtitieName;
  Result:= Self;
end;

function TModelFireDAC.GetCommit: IDataManager;
begin
  FConexao.Commit;
  Result:= Self;
end;

function TModelFireDAC.GetConnection: TCustomConnection;
begin
  Result:= FConexao;
end;

function TModelFireDAC.GetFieldNames: TStrings;
var
  Items: TStrings;
begin
  Items:= TStringList.Create;
  try
    FConexao.GetFieldNames('', '', fEtitieName, '', Items);

    Result:= Items;
 except
    on E: EFDDBEngineException do
      begin
        raise Exception.Create(TFireDACEngineException.GetMessage(E));
      end;
  end;
end;

function TModelFireDAC.GetRollback: IDataManager;
begin
  FConexao.Rollback;
  Result:= Self;
end;

function TModelFireDAC.GetStartTransaction: IDataManager;
begin
  FConexao.StartTransaction;
  Result:= Self;
end;

procedure TModelFireDAC.onOutput(ASender: TFDMoniClientLinkBase;
  const AClassName, AObjName, AMessage: string);
begin
  Messages.Add(AMessage);
end;

procedure TModelFireDAC.onRecover(ASender, AInitiator: TObject;
  AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
var
  Res: Integer;
begin
  Res:= MessageDlg('Conexão perdida, escolha o que você deseja fazer: YES - OffLine, Reconectar - OK, Falha - Cancel',
                   mtConfirmation, [mbYes, mbOK, mbCancel], 0
                   );

  case Res of
    mrYes: AAction:= faOfflineAbort;
    mrOK: AAction:= faRetry;
    mrCancel: AAction:= faFail;
  end;
end;

end.

