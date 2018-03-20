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
unit testDynLib;

interface
uses
  darkTest,
  darkDynLib;

type
  TTestDynlib = class( TTestCase )
  private
    fDynLib: IDynLib;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    // Test that dynlib will load a common library for the target OS.
    procedure LoadLibrary;
    // Test that dynlib will find a known entry point in a known libary.
    procedure GetProcAddress;
    // Test that dynlib will free a library for the target OS.
    procedure FreeLibrary;
    // Test that dynlib reports a failed LoadLibary when the specified module
    // cannot be found.
    procedure FailLoadLibrary;
  end;

implementation
uses
  sysutils;

const
{$ifdef MSWINDOWS}
  cEntryPoint = 'CopyFileA';
  cLibraryName = 'kernel32.dll';
{$endif}

procedure TTestDynlib.FailLoadLibrary;
var
  Status: boolean;
begin
  /// Arrange
  /// Act
  Status := fDynLib.LoadLibrary( 'unknownlibrary.dll' );
  /// Assert
  if Status then begin
    Fail('Library did not correctly report failure to load library.');
  end;
end;

procedure TTestDynlib.FreeLibrary;
var
  Status: boolean;
begin
  /// Arrange
  /// Act
  Status := fDynLib.FreeLibrary;
  /// Assert
  if not Status then begin
    Fail('Library did not un-load. Error ('+IntToStr(fDynLib.GetError)+')');
  end;
end;

procedure TTestDynlib.GetProcAddress;
var
  EntryPoint: pointer;
begin
  /// Arrange
  fDynLib.LoadLibrary( cLibraryName );
  /// Act
  EntryPoint := fDynLib.GetProcAddress(cEntryPoint);
  /// Assert
  if not assigned(EntryPoint) then begin
    Fail('Entry point not found.');
  end;
end;

procedure TTestDynlib.LoadLibrary;
var
  Status: boolean;
begin
  /// Arrange
  /// Act
  Status := fDynLib.LoadLibrary( cLibraryName );
  /// Assert
  if not Status then begin
    Fail('Library did not load. Error ('+IntToStr(fDynLib.GetError)+')');
  end;
end;

procedure TTestDynlib.Setup;
begin
  inherited Setup;
  fDynLib := TDynLib.Create;
end;

procedure TTestDynlib.TearDown;
begin
  fDynLib := nil;
  inherited TearDown;
end;


initialization
  RegisterTestCase(TTestDynlib);

end.
