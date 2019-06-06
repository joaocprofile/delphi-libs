unit jc.Libs.Interfaces;

interface

uses
  Classes, System.SysUtils;

type

  IJcIniFile = interface
    ['{D9DBD781-CA6C-401A-B58B-6620CBBBF5EC}']
    function FileName(const Value: string): IJcIniFile;
    function AddSection(const Section, Values: string): IJcIniFile;
    function AddString(const Section, Ident, Value: string): IJcIniFile;
    function AddInteger(const Section, Ident: string; Value: integer): IJcIniFile;
    function AddBoolean(const Section, Ident: string; Value: Boolean): IJcIniFile;
    function DeleteKey(const Section, Ident: String): IJcIniFile;
    function DeleteSection(const Section: String): IJcIniFile;
    function GetSections(var Sections: TStrings): IJcIniFile;
    function GetSectionValues(const Section: String; Strings: TStrings): IJcIniFile;
    function GetString(const Section, Ident, Default: string): string;
    function GetInteger(const Section, Ident: string; Default: integer): integer;
    function GetBoolean(const Section, Ident: string; Default: Boolean): Boolean;
  end;

  IJcLog = interface
    ['{32FB4942-419A-4E91-8405-FF6E3DE45393}']
    function CatchException(Sender: TObject; E: Exception): IJcLog;
    function CustomMsg(Msg: String): IJcLog;
    function SaveLog(Alog: String = ''): IJcLog;
    function SaveError: IJcLog;
    function ShowLog(Alog: String = ''): IJcLog;
    function showError: IJcLog;
  end;

implementation


end.
