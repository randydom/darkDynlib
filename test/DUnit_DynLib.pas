unit DUnit_DynLib;

interface
uses
  DUnitX.TestFramework,
  darkDynLib;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  private
    fDynLib: IDynLib;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    // Test that dynlib will load a common library for the target OS.
    [Test]
    procedure LoadLibrary;

    // Test that dynlib will find a known entry point in a known libary.
    [Test]
    procedure GetProcAddress;

    // Test that dynlib will free a library for the target OS.
    [Test]
    procedure FreeLibrary;

    // Test that dynlib reports a failed LoadLibary when the specified module
    // cannot be found.
    [Test]
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

procedure TMyTestObject.FailLoadLibrary;
var
  Status: boolean;
begin
  /// Arrange
  /// Act
  Status := fDynLib.LoadLibrary( 'unknownlibrary.dll' );
  /// Assert
  Assert.IsFalse( Status, 'Library did not correctly report failure to load library.');
end;

procedure TMyTestObject.FreeLibrary;
var
  Status: boolean;
begin
  /// Arrange
  /// Act
  Status := fDynLib.FreeLibrary;
  /// Assert
  Assert.IsTrue( Status, 'Library did not un-load. Error ('+IntToStr(fDynLib.GetError)+')' );
end;

procedure TMyTestObject.GetProcAddress;
var
  EntryPoint: pointer;
begin
  /// Arrange
  fDynLib.LoadLibrary( cLibraryName );
  /// Act
  EntryPoint := fDynLib.GetProcAddress(cEntryPoint);
  /// Assert
  Assert.IsNotNull(EntryPoint, 'Entry point not found.');
end;

procedure TMyTestObject.LoadLibrary;
var
  Status: boolean;
begin
  /// Arrange
  /// Act
  Status := fDynLib.LoadLibrary( cLibraryName );
  /// Assert
  Assert.IsTrue(Status, 'Library did not load. Error ('+IntToStr(fDynLib.GetError)+')');
end;

procedure TMyTestObject.Setup;
begin
  fDynLib := TDynLib.Create;
end;

procedure TMyTestObject.TearDown;
begin
  fDynLib := nil;
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
