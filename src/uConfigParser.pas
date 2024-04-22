unit uConfigParser;

interface

type
  TConfigParser = class
  public
    class function GetINI(Session, Key: String): String;
    class function GetNameAppToINI: String;
    class function Iif(const Condicao: Boolean; Se, SeNao: Variant): Variant;
  end;

implementation

{ TConfigParser }

uses
  System.SysUtils, System.IniFiles, Vcl.Forms;

class function TConfigParser.GetINI(Session, Key: String): String;
var
  Ini: TIniFile;
begin
  Ini:= TIniFile.Create(GetNameAppToINI);
  try
    Result:= Ini.ReadString(Session, Key, '');
  finally
    FreeAndNil(Ini);
  end;
end;

class function TConfigParser.GetNameAppToINI: String;
begin
  Result:= ChangeFileExt(Application.ExeName, '.ini');
end;

class function TConfigParser.Iif(const Condicao: Boolean; Se, SeNao: Variant): Variant;
begin
  if Condicao then
    Result:= Se
  else Result := SeNao;
end;

end.

