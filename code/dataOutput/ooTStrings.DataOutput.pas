{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooTStrings.DataOutput;

interface

uses
  Classes, SysUtils,
  ooKey.Intf,
  ooDataOutput.Intf;

type
  TTStringsDataOutput = class sealed(TInterfacedObject, IDataOutput)
  strict private
    _Destination: TStrings;
    _Section: String;
  public
    procedure WriteNull(const Key: IKey);
    procedure WriteInteger(const Key: IKey; const Value: Integer);
    procedure WriteBoolean(const Key: IKey; const Value: Boolean);
    procedure WriteFloat(const Key: IKey; const Value: Extended);
    procedure WriteString(const Key: IKey; const Value: String);
    procedure WriteDateTime(const Key: IKey; const Value: TDateTime);
    procedure WriteChar(const Key: IKey; const Value: Char);
    procedure EnterSection(const Key: IKey);
    procedure ExitSection(const Key: IKey);
    constructor Create(const Destination: TStrings);
    class function New(const Destination: TStrings): IDataOutput;
  end;

implementation

procedure TTStringsDataOutput.WriteBoolean(const Key: IKey; const Value: Boolean);
const
  BOOL_VALUE: array [Boolean] of Char = ('0', '1');
begin
  WriteString(Key, BOOL_VALUE[Value]);
end;

procedure TTStringsDataOutput.WriteChar(const Key: IKey; const Value: Char);
begin
  WriteString(Key, Value);
end;

procedure TTStringsDataOutput.WriteDateTime(const Key: IKey; const Value: TDateTime);
begin
  WriteString(Key, DateTimeToStr(Value));
end;

procedure TTStringsDataOutput.WriteFloat(const Key: IKey; const Value: Extended);
begin
  WriteString(Key, FloatToStr(Value));
end;

procedure TTStringsDataOutput.WriteInteger(const Key: IKey; const Value: Integer);
begin
  WriteString(Key, IntToStr(Value));
end;

procedure TTStringsDataOutput.WriteString(const Key: IKey; const Value: String);
var
  ExistIndex: Integer;
begin
  ExistIndex := _Destination.IndexOfName(_Section + Key.AsString);
  if ExistIndex = - 1 then
    _Destination.Append(_Section + Key.AsString + '=' + Value)
  else
    _Destination.ValueFromIndex[ExistIndex] := Value;
end;

procedure TTStringsDataOutput.WriteNull(const Key: IKey);
begin
  WriteString(Key, #0);
end;

procedure TTStringsDataOutput.EnterSection(const Key: IKey);
begin
  _Section := _Section + Key.AsString + '.';
end;

procedure TTStringsDataOutput.ExitSection(const Key: IKey);
begin
  _Section := Copy(_Section, 1, Pred(Length(_Section) - Length(Key.AsString)));
end;

constructor TTStringsDataOutput.Create(const Destination: TStrings);
begin
  _Destination := Destination;
  _Section := EmptyStr;
end;

class function TTStringsDataOutput.New(const Destination: TStrings): IDataOutput;
begin
  Result := TTStringsDataOutput.Create(Destination);
end;

end.
