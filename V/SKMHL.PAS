{
 The Virtual skMHL

 intended to work with Real skMHL via skMHLapi.dll

 (q) by sergey korowkin, 2000.
 (q) by tatyana medvedeva, 2000.
}
unit skMHL;

interface
uses
     skCommon;

type
 PMessageBase = ^TMessageBase;
 TMessageBase = object
  Link: Pointer;

  constructor Init(const ALink: Pointer);
  destructor DoneNoDestroy; virtual;
  destructor Done; virtual;

  function Open(const Path: String): Boolean; virtual;
  function Create(const Path: String): Boolean; virtual;
  function Exist(const Path: String): Boolean; virtual;
  procedure Close; virtual;
  function Exists(Message: Longint): Boolean; virtual;
  function Current: Longint; virtual;
  procedure Seek(Message: Longint); virtual;
  procedure SeekNext; virtual;
  procedure SeekPrev; virtual;
  function SeekFound: Boolean; virtual;
  function GetLocation: Longint; virtual;
  procedure SetLocation(Location: Longint); virtual;
  function OpenMessage: Boolean; virtual;
  function OpenMessageHeader: Boolean; virtual;
  function CloseMessage: Boolean; virtual;
  function GetHighest: Longint; virtual;
  function GetCount: Longint; virtual;
  function GetFrom: String; virtual;
  function GetTo: String; virtual;
  function GetSubject: String; virtual;
  procedure GetFromAddress(var Address: TAddress); virtual;
  procedure GetToAddress(var Address: TAddress); virtual;
  procedure GetFromAndToAddress(var FromAddress, ToAddress: TAddress); virtual;
  procedure SetFrom(const S: String); virtual;
  procedure SetTo(const S: String); virtual;
  procedure SetSubject(const S: String); virtual;
  procedure SetFromAddress(var Address: TAddress; const FreshMSGID: Boolean); virtual;
  procedure SetToAddress(var Address: TAddress); virtual;
  procedure SetFromAndToAddress(var FromAddress, ToAddress: TAddress; const FreshMSGID: Boolean); virtual;
  procedure GetStringPChar(Line: PChar; MaxLen: Integer); virtual;
  procedure GetString(var Line: String); virtual;
  procedure PutStringPChar(Line: PChar); virtual;
  procedure PutString(const Line: String); virtual;
  function EndOfMessage: Boolean; virtual;
  procedure SetTextPos(Position: Longint); virtual;
  function GetTextPos: Longint; virtual;
  function GetTextSize: Longint; virtual;
  procedure TruncateText; virtual;
  procedure ReadText(var Buf; Count: Word); virtual;
  procedure WriteText(var Buf; Count: Word); virtual;
  function GetAttribute(Attribute: Longint): Boolean; virtual;
  procedure SetAttribute(Attribute: Longint; Enable: Boolean); virtual;
  procedure GetWrittenDateTime(var DateTime: TMessageBaseDateTime); virtual;
  procedure GetArrivedDateTime(var DateTime: TMessageBaseDateTime); virtual;
  procedure SetWrittenDateTime(var DateTime: TMessageBaseDateTime); virtual;
  procedure SetArrivedDateTime(var DateTime: TMessageBaseDateTime); virtual;
  function WriteMessage: Boolean; virtual;
  function WriteMessageHeader: Boolean; virtual;
  function GetKludgePChar(const Name, Destination: PChar; const MaxLen: Integer): Boolean; virtual;
  function GetKludge(const Name: String; var Destination: String): Boolean; virtual;
  procedure SetKludgePChar(const Name, Value: PChar); virtual;
  procedure SetKludge(const Name, Value: String); virtual;
  procedure DeleteKludgePChar(const Name: PChar); virtual;
  procedure DeleteKludge(const Name: String); virtual;
  procedure AddKludgePChar(const Value: PChar); virtual;
  procedure AddKludge(const Value: String); virtual;
  function GetMessageTextStream: PMessageBaseStream; virtual;
  procedure SetFlag(const Flag: Longint; const Enable: Boolean); virtual;
  function GetFlag(const Flag: Longint): Boolean; virtual;
  procedure CheckFromAddress(const S: String; var Address: TAddress); virtual;
  procedure CheckToAddress(const S: String; var Address: TAddress); virtual;
  function CreateNewMessage: Boolean; virtual;
  function KillMessage: Boolean; virtual;
  function GetLastRead(const UserNumber: Longint): Longint; virtual;
  procedure SetLastRead(const UserNumber: Longint; const Value: Longint); virtual;
  procedure ResetDateTime;
  procedure SetBaseType(const BaseType: TBaseType); virtual;
  procedure PutOrigin(Address: TAddress; const Text: String); virtual;
  function AfterLastKludge: Longint; virtual;
  procedure SetMessageTextStream(const AMessageText: PMessageBaseStream); virtual;
  procedure SetStatus(const AStatus: Longint); virtual;
  function GetStatus: Longint; virtual;
  procedure SetOpened(const AOpened: Boolean); virtual;
  function GetOpened: Boolean; virtual;
  procedure SetCurrent(const ACurrentMessage: Longint); virtual;
  procedure SetBasePath(const ABasePath: String); virtual;
  function GetBasePath: String; virtual;
  function GetRead: Boolean; virtual;
  procedure SetRead(const Value: Boolean); virtual;
 end;

procedure GetAttributesLine(B: PMessageBase; var S: String);
procedure GetDateTimeLine(var DT: TMessageBaseDateTime; var S: String);

function skMHLversion: String;
function skMHLtitle: String;
function skMHLfulltitle: String;

implementation
uses
     skMHLapi;

constructor TMessageBase.Init(const ALink: Pointer);
 begin
  Link:=ALink;
 end;

destructor TMessageBase.DoneNoDestroy;
 begin
 end;

destructor TMessageBase.Done;
 begin
  skmhlapiDestroyMessageBase(Link);
 end;

function TMessageBase.Open(const Path: String): Boolean;
 begin
  Open:=skmhlapiOpen(Link, Path);
 end;

function TMessageBase.Create(const Path: String): Boolean;
 begin
  Create:=skmhlapiCreate(Link, Path);
 end;

function TMessageBase.Exist(const Path: String): Boolean;
 begin
  Exist:=skmhlapiExist(Link, Path);
 end;

procedure TMessageBase.Close;
 begin
  skmhlapiClose(Link);
 end;

function TMessageBase.Exists(Message: Longint): Boolean;
 begin
  Exists:=skmhlapiExists(Link, Message);
 end;

function TMessageBase.Current: Longint;
 begin
  Current:=skmhlapiCurrent(Link);
 end;

procedure TMessageBase.Seek(Message: Longint);
 begin
  skmhlapiSeek(Link, Message);
 end;

procedure TMessageBase.SeekNext;
 begin
  skmhlapiSeekNext(Link);
 end;

procedure TMessageBase.SeekPrev;
 begin
  skmhlapiSeekPrev(Link);
 end;

function TMessageBase.SeekFound: Boolean;
 begin
  SeekFound:=skmhlapiSeekFound(Link);
 end;

function TMessageBase.GetLocation: Longint;
 begin
  GetLocation:=skmhlapiGetLocation(Link);
 end;

procedure TMessageBase.SetLocation(Location: Longint);
 begin
  skmhlapiSetLocation(Link, Location);
 end;

function TMessageBase.OpenMessage: Boolean;
 begin
  OpenMessage:=skmhlapiOpenMessage(Link);
 end;

function TMessageBase.OpenMessageHeader: Boolean;
 begin
  OpenMessageHeader:=skmhlapiOpenMessageHeader(Link);
 end;

function TMessageBase.CloseMessage: Boolean;
 begin
  CloseMessage:=skmhlapiCloseMessage(Link);
 end;

function TMessageBase.GetHighest: Longint;
 begin
  GetHighest:=skmhlapiGetHighest(Link);
 end;

function TMessageBase.GetCount: Longint;
 begin
  GetCount:=skmhlapiGetCount(Link);
 end;

function TMessageBase.GetFrom: String;
 begin
  GetFrom:=skmhlapiGetFrom(Link);
 end;

function TMessageBase.GetTo: String;
 begin
  GetTo:=skmhlapiGetTo(Link);
 end;

function TMessageBase.GetSubject: String;
 begin
  GetSubject:=skmhlapiGetSubject(Link);
 end;

procedure TMessageBase.GetFromAddress(var Address: TAddress);
 begin
  skmhlapiGetFromAddress(Link, Address);
 end;

procedure TMessageBase.GetToAddress(var Address: TAddress);
 begin
  skmhlapiGetToAddress(Link, Address);
 end;

procedure TMessageBase.GetFromAndToAddress(var FromAddress, ToAddress: TAddress);
 begin
  skmhlapiGetFromAndToAddress(Link, FromAddress, ToAddress);
 end;

procedure TMessageBase.SetFrom(const S: String);
 begin
  skmhlapiSetFrom(Link, S);
 end;

procedure TMessageBase.SetTo(const S: String);
 begin
  skmhlapiSetTo(Link, S);
 end;

procedure TMessageBase.SetSubject(const S: String);
 begin
  skmhlapiSetSubject(Link, S);
 end;

procedure TMessageBase.SetFromAddress(var Address: TAddress; const FreshMSGID: Boolean);
 begin
  skmhlapiSetFromAddress(Link, Address, FreshMSGID);
 end;

procedure TMessageBase.SetToAddress(var Address: TAddress);
 begin
  skmhlapiSetToAddress(Link, Address);
 end;

procedure TMessageBase.SetFromAndToAddress(var FromAddress, ToAddress: TAddress; const FreshMSGID: Boolean);
 begin
  skmhlapiSetFromAndToAddress(Link, FromAddress, ToAddress, FreshMSGID);
 end;

procedure TMessageBase.GetStringPChar(Line: PChar; MaxLen: Integer);
 begin
  skmhlapiGetStringPChar(Link, Line, MaxLen);
 end;

procedure TMessageBase.GetString(var Line: String);
 begin
  skmhlapiGetString(Link, Line);
 end;

procedure TMessageBase.PutStringPChar(Line: PChar);
 begin
  skmhlapiPutStringPChar(Link, Line);
 end;

procedure TMessageBase.PutString(const Line: String);
 begin
  skmhlapiPutString(Link, Line);
 end;

function TMessageBase.EndOfMessage: Boolean;
 begin
  EndOfMessage:=skmhlapiEndOfMessage(Link);
 end;

procedure TMessageBase.SetTextPos(Position: Longint);
 begin
  skmhlapiSetTextPos(Link, Position);
 end;

function TMessageBase.GetTextPos: Longint;
 begin
  GetTextPos:=skmhlapiGetTextPos(Link);
 end;

function TMessageBase.GetTextSize: Longint;
 begin
  GetTextSize:=skmhlapiGetTextSize(Link);
 end;

procedure TMessageBase.TruncateText;
 begin
  skmhlapiTruncateText(Link);
 end;

procedure TMessageBase.ReadText(var Buf; Count: Word);
 begin
  skmhlapiReadText(Link, Buf, Count);
 end;

procedure TMessageBase.WriteText(var Buf; Count: Word);
 begin
  skmhlapiWriteText(Link, Buf, Count);
 end;

function TMessageBase.GetAttribute(Attribute: Longint): Boolean;
 begin
  GetAttribute:=skmhlapiGetAttribute(Link, Attribute);
 end;

procedure TMessageBase.SetAttribute(Attribute: Longint; Enable: Boolean);
 begin
  skmhlapiSetAttribute(Link, Attribute, Enable);
 end;

procedure TMessageBase.GetWrittenDateTime(var DateTime: TMessageBaseDateTime);
 begin
  skmhlapiGetWrittenDateTime(Link, DateTime);
 end;

procedure TMessageBase.GetArrivedDateTime(var DateTime: TMessageBaseDateTime);
 begin
  skmhlapiGetArrivedDateTime(Link, DateTime);
 end;

procedure TMessageBase.SetWrittenDateTime(var DateTime: TMessageBaseDateTime);
 begin
  skmhlapiSetWrittenDateTime(Link, DateTime);
 end;

procedure TMessageBase.SetArrivedDateTime(var DateTime: TMessageBaseDateTime);
 begin
  skmhlapiSetArrivedDateTime(Link, DateTime);
 end;

function TMessageBase.WriteMessage: Boolean;
 begin
  WriteMessage:=skmhlapiWriteMessage(Link);
 end;

function TMessageBase.WriteMessageHeader: Boolean;
 begin
  WriteMessageHeader:=skmhlapiWriteMessageHeader(Link);
 end;

function TMessageBase.GetKludgePChar(const Name, Destination: PChar; const MaxLen: Integer): Boolean;
 begin
  GetKludgePChar:=skmhlapiGetKludgePChar(Link, Name, Destination, MaxLen);
 end;

function TMessageBase.GetKludge(const Name: String; var Destination: String): Boolean;
 begin
  GetKludge:=skmhlapiGetKludge(Link, Name, Destination);
 end;

procedure TMessageBase.SetKludgePChar(const Name, Value: PChar);
 begin
  skmhlapiSetKludgePChar(Link, Name, Value);
 end;

procedure TMessageBase.SetKludge(const Name, Value: String);
 begin
  skmhlapiSetKludge(Link, Name, Value);
 end;

procedure TMessageBase.DeleteKludgePChar(const Name: PChar);
 begin
  skmhlapiDeleteKludgePChar(Link, Name);
 end;

procedure TMessageBase.DeleteKludge(const Name: String);
 begin
  skmhlapiDeleteKludge(Link, Name);
 end;

procedure TMessageBase.AddKludgePChar(const Value: PChar);
 begin
  skmhlapiAddKludgePChar(Link, Value);
 end;

procedure TMessageBase.AddKludge(const Value: String);
 begin
  skmhlapiAddKludge(Link, Value);
 end;

function TMessageBase.GetMessageTextStream: PMessageBaseStream;
 begin
  GetMessageTextStream:=skmhlapiGetMessageTextStream(Link);
 end;

procedure TMessageBase.SetFlag(const Flag: Longint; const Enable: Boolean);
 begin
  skmhlapiSetFlag(Link, Flag, Enable);
 end;

function TMessageBase.GetFlag(const Flag: Longint): Boolean;
 begin
  GetFlag:=skmhlapiGetFlag(Link, Flag);
 end;

procedure TMessageBase.CheckFromAddress(const S: String; var Address: TAddress);
 begin
  skmhlapiCheckFromAddress(Link, S, Address);
 end;

procedure TMessageBase.CheckToAddress(const S: String; var Address: TAddress);
 begin
  skmhlapiCheckToAddress(Link, S, Address);
 end;

function TMessageBase.CreateNewMessage: Boolean;
 begin
  CreateNewMessage:=skmhlapiCreateNewMessage(Link);
 end;

function TMessageBase.KillMessage: Boolean;
 begin
  KillMessage:=skmhlapiKillMessage(Link);
 end;

function TMessageBase.GetLastRead(const UserNumber: Longint): Longint;
 begin
  GetLastRead:=skmhlapiGetLastRead(Link, UserNumber);
 end;

procedure TMessageBase.SetLastRead(const UserNumber: Longint; const Value: Longint);
 begin
  skmhlapiSetLastRead(Link, UserNumber, Value);
 end;

procedure TMessageBase.ResetDateTime;
 begin
  skmhlapiResetDateTime(Link);
 end;

procedure TMessageBase.SetBaseType(const BaseType: TBaseType);
 begin
  skmhlapiSetBaseType(Link, BaseType);
 end;

procedure TMessageBase.PutOrigin(Address: TAddress; const Text: String);
 begin
  skmhlapiPutOrigin(Link, Address, Text);
 end;

function TMessageBase.AfterLastKludge: Longint;
 begin
  AfterLastKludge:=skmhlapiAfterLastKludge(Link);
 end;

procedure TMessageBase.SetMessageTextStream(const AMessageText: PMessageBaseStream);
 begin
  skmhlapiSetMessageTextStream(Link, AMessageText);
 end;

procedure TMessageBase.SetStatus(const AStatus: Longint);
 begin
  skmhlapiSetStatus(Link, AStatus);
 end;

function TMessageBase.GetStatus: Longint;
 begin
  GetStatus:=skmhlapiGetStatus(Link);
 end;

procedure TMessageBase.SetOpened(const AOpened: Boolean);
 begin
  skmhlapiSetOpened(Link, AOpened);
 end;

function TMessageBase.GetOpened: Boolean;
 begin
  GetOpened:=skmhlapiGetOpened(Link);
 end;

procedure TMessageBase.SetCurrent(const ACurrentMessage: Longint);
 begin
  skmhlapiSetCurrent(Link, ACurrentMessage);
 end;

procedure TMessageBase.SetBasePath(const ABasePath: String);
 begin
  skmhlapiSetBasePath(Link, ABasePath);
 end;

function TMessageBase.GetBasePath: String;
 begin
  GetBasePath:=skmhlapiGetBasePath(Link);
 end;

function TMessageBase.GetRead: Boolean;
 begin
  GetRead:=skmhlapiGetRead(Link);
 end;

procedure TMessageBase.SetRead(const Value: Boolean);
 begin
  skmhlapiSetRead(Link, Value);
 end;

{* Stuff *}

procedure GetAttributesLine(B: PMessageBase; var S: String);
 begin
  skmhlapiGetAttributesLine(B^.Link, S);
 end;

procedure GetDateTimeLine(var DT: TMessageBaseDateTime; var S: String);
 begin
  skmhlapiGetDateTimeLine(DT, S);
 end;

{ Versions }

function skMHLversion: String;
 begin
  skMHLversion:=skmhlapiVersion;
 end;

function skMHLtitle: String;
 begin
  skMHLtitle:=skmhlapiTitle;
 end;

function skMHLfulltitle: String;
 begin
  skMHLfulltitle:=skmhlapiFullTitle;
 end;

end.
