//------------------------------------------------------------------------------
// This file is part of the DarkGlass game engine project.
// More information can be found here: http://chapmanworld.com/darkglass
//
// DarkGlass is licensed under the MIT License:
//
// Copyright 2018 Craig Chapman
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the “Software”),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.
//------------------------------------------------------------------------------
/// <exclude />
unit darkdynlib.dynlib.windows;

interface
{$ifdef MSWINDOWS}
uses
  Windows,
  darkdynlib;

type
  TWindowsDynlib = class( TInterfacedObject, IDynLib )
  private
    fError: uint32;
    fHandle: HMODULE;
  private
    function GetError: uint32;
    function LoadLibrary( filepath: string ): boolean;
    function FreeLibrary: boolean;
    function GetProcAddress( funcName: string ): pointer;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

{$endif}
implementation
{$ifdef MSWINDOWS}

const
  null = 0;

constructor TWindowsDynlib.Create;
begin
  inherited Create;
  fHandle := null;
end;

destructor TWindowsDynlib.Destroy;
begin
  if fHandle<>null then begin
    FreeLibrary;
  end;
  inherited Destroy;
end;

function TWindowsDynlib.FreeLibrary: boolean;
begin
  Result := True;
  if fHandle=null then begin
    exit;
  end;
  if not Windows.FreeLibrary(fHandle) then begin
    fError := Windows.GetLastError;
  end;
  fHandle := null;
end;

function TWindowsDynlib.GetError: uint32;
begin
  Result := fError;
end;

function TWindowsDynlib.GetProcAddress( funcName: string ): pointer;
begin
  Result := Windows.GetProcAddress(fHandle,pAnsiChar(UTF8Encode(funcName)));
end;

function TWindowsDynlib.LoadLibrary(filepath: string): boolean;
begin
  //- If there is already a library loaded, free it.
  if fHandle<>null then begin
    FreeLibrary;
  end;
  //-
  fHandle := Windows.LoadLibraryA(pAnsiChar(UTF8Encode(filepath)));
  Result := not (fHandle=null);
  if not Result then begin
    fError := Windows.GetLastError;
  end;
end;

{$endif}
end.
