unit uModel.Abstraction;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Generics.Collections, System.Classes, Datasnap.DBClient;

type
  TState = (dsBrowse, dsEdit, dsInsert, dsOpening);

  IDataManager = interface
  ['{EFF5B803-DF01-480E-9681-79E85A0FFF69}']

    function GetConnection: TCustomConnection;
    function GetStartTransaction: IDataManager;
    function GetCommit: IDataManager;
    function GetRollback: IDataManager;
    function GetEtity(EtitName: String): IDataManager;
    function GetFieldNames: TStrings;
    property Connection: TCustomConnection read GetConnection;

    property StartTransaction: IDataManager read GetStartTransaction;
    property Commit: IDataManager read GetCommit;
    property Rollback: IDataManager read GetRollback;
  end;


  IStatement = interface
  ['{A144C1E6-259E-4C9E-8043-9D642E39A6D2}']
    function GetQuery: TFDQuery;
    function SQL(Value: String): IStatement;
    function Open: IStatement;
    property Query: TFDQuery read GetQuery;
  end;

  IRootController<T: class> = interface
  ['{166FBDE6-2484-4AF7-914A-A6DE8AC453F5}']
    function Fields: TStrings;
    function FindAll(CommadSQL: String): TObjectList<T>; overload;
    function FindAll(CommadSQL: String; Entity: T): TObjectList<T>; overload;
  end;

  IController<T: class> = interface //(IRootController<T>)
  ['{7E854F73-17F8-4AE0-B6E6-82155679452E}']
    function Filtar(Entity: T): IStatement;

    {function GeneratedValue: Integer;
    function Fields: TStrings;
    function Save(Entity: T): Boolean;
    function Update(Entity: T): Boolean; overload;
    function Update(CommandSQL: String; Parameter: String; Entity: T): Boolean; overload;
    function DeleteById(Entity: T): Boolean;
    function FindById(Id: Integer): T;
    function FindExists: Boolean; overload;
    function FindExists(CommadSQL: String; Parameter: String; ParameterType: TFieldType; Value: Variant): IStatement; overload;
    function FindAll: TObjectList<T>; overload;
    function FindAll(CommadSQL: String; Entity: T): TObjectList<T>; overload;
    function Frist: T;
    function Previous(Id: Integer): T;
    function Next(Id: Integer): T;
    function Last: T;}
  end;

  IService<T: class> = interface
  ['{A6A0763F-5A15-4131-9858-5A96B9FFCCD6}']
    function Filtar(Entity: T): IStatement;

    {function Fields: TStrings;
    function GeneratedValue: Integer;
    function CurrentGeneratedValue: Integer;
    function IsValid(Entity: T; out MessageContext: String): Boolean;
    function Save(Entity: T): Boolean;
    function Update(Entity: T): Boolean; overload;
    function Update(CommandSQL: String; Parameter: String; Entity: T): Boolean; overload;
    function DeleteById(Entity: T): Boolean;
    function FindById(Id: Integer): T;
    function FindExists: Boolean; overload;
    function FindExists(CommadSQL: String; Parameter: String;
      ParameterType: TFieldType; Value: Variant): IStatement; overload;
    function FindAll: TObjectList<T>; overload;
    function FindAll(CommadSQL: String): TObjectList<T>; overload;
    function FindAll(CommadSQL: String; Entity: T): TObjectList<T>; overload;
    function Frist: T;
    function Previous(Id: Integer): T;
    function Next(Id: Integer): T;
    function Last: T;}
  end;

  IDataConverter<T: class> = interface
  ['{6C5C2E54-821C-412C-8828-E5F545C87B9D}']
    procedure Populate(Source: TObjectList<T>; Target: TClientDataSet);
  end;

  IRepository<T: class> = interface
  ['{557CB439-8E45-4FAF-AEF4-1ADBE83590C6}']
    function Filtar(Entity: T): IStatement;
    procedure SetStatement(Statement: IStatement; Entity: T);
    procedure SetProperty(Statement: IStatement; Entity: T);

    {function Fields: TStrings;
    procedure SetStatement(Statement: IStatement; Entity: T);
    procedure SetProperty(Statement: IStatement; Entity: T);
    function GeneratedValue: Integer;
    function CurrentGeneratedValue: Integer;
    function Save(Entity: T): Boolean;
    procedure AfterSave(Entity: T);
    function Update(Entity: T): Boolean; overload;
    function Update(CommandSQL: String; Parameter: String; Entity: T): Boolean; overload;
    function DeleteById(Entity: T): Boolean;
    function FindById(Id: Integer): T;
    function FindExists: Boolean; overload;
    function FindExists(CommadSQL: String; Parameter: String;
      ParameterType: TFieldType; Value: Variant): IStatement; overload;
    function FindAll: TObjectList<T>; overload;
    function FindAll(CommadSQL: String): TObjectList<T>; overload;
    function FindAll(CommadSQL: String; Entity: T): TObjectList<T>; overload;
    function Frist: T;
    function Previous(Id: Integer): T;
    function Next(Id: Integer): T;
    function Last: T;}
  end;

var
  State: TState;
  StateItens: TState;

implementation

end.

