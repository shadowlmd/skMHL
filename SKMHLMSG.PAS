{$B-}
unit skMHLmsg;

interface
uses
     skMHL,

     skCommon;

const
 MaxMapSize             = $F000;

type
 TFidoMap = array[0..MaxMapSize div 8 - 1] of Byte;

 PFidoMessageBase = ^TFidoMessageBase;
 TFidoMessageBase = object(TMessageBase)
  constructor Init;
  destructor Done; virtual;
  function Open(const Path: String): Boolean; virtual;
  function Create(const Path: String): Boolean; virtual;
  function Exist(const Path: String): Boolean; virtual;
  procedure Close; virtual;
  function Exists(Message: Longint): Boolean; virtual;
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
  function GetAttribute(Attribute: Longint): Boolean; virtual;
  procedure SetAttribute(Attribute: Longint; Enable: Boolean); virtual;
  function GetLocalAttribute(Attribute: Longint): Boolean; virtual;
  procedure SetLocalAttribute(Attribute: Longint; Enable: Boolean); virtual;
  procedure GetWrittenDateTime(var DateTime: TMessageBaseDateTime); virtual;
  procedure GetArrivedDateTime(var DateTime: TMessageBaseDateTime); virtual;
  procedure SetWrittenDateTime(var DateTime: TMessageBaseDateTime); virtual;
  procedure SetArrivedDateTime(var DateTime: TMessageBaseDateTime); virtual;
  function WriteMessage: Boolean; virtual;
  function WriteMessageHeader: Boolean; virtual;
  function CreateNewMessage: Boolean; virtual;
  function KillMessage: Boolean; virtual;
  function GetLastRead(const UserNumber: Longint): Longint; virtual;
  procedure SetLastRead(const UserNumber: Longint; const Value: Longint); virtual;
  function GetAFLAG(const Flag: String): Boolean;
  procedure SetAFLAG(const Flag: String; const Enable: Boolean);
  procedure SetReplyTo(const ReplyTo: Longint);
  function GetReplyTo: Longint;
  procedure SetReplyNext(const ReplyNext: Longint);
  function GetReplyNext: Longint;
  procedure GetHeader(var AHeader: TFidoHeader);
  function GetRead: Boolean; virtual;
  procedure SetRead(const Value: Boolean); virtual;
 private
  Map: TFidoMap;
  TotalMessages: Longint;
  HighMessage: Longint;
  Link: PMessageBaseStream;
  Header: TFidoHeader;
  procedure RebuildIndex;
  procedure SetMapDot(Num: Integer; Value: Boolean);
  function GetMapDot(Num: Integer): Boolean;
  function MapAttribute(var Attribute: Longint): Boolean;
 end;

implementation
uses
     skMHLvmb,

     Strings;

const
 MapPos: Array[0..7] Of Byte = (1, 2, 4, 8, 16, 32, 64, 128);

 faPrivate           = $0001;
 faCrash             = $0002;
 faReceived          = $0004;
 faSent              = $0008;
 faAttach            = $0010;
 faTransit           = $0020;
 faOrphan            = $0040;
 faKill              = $0080;
 faLocal             = $0100;
 faHold              = $0200;
 faFRq               = $0800;
 faRRq               = $1000;
 faRRc               = $2000;
 faARq               = $4000;
 faURq               = $8000;

{ TFidoMessageBase }

constructor TFidoMessageBase.Init;
 begin
  inherited Init;

  Link:=nil;
 end;

destructor TFidoMessageBase.Done;
 begin
  CloseMessage;

  Close;

  inherited Done;
 end;

function TFidoMessageBase.Open(const Path: String): Boolean;
 var
  S: String;
 begin
  Open:=False;

  SetOpened(False);

  S:=Path;

  if S[Length(S)] <> '\' then
   S:=Concat(S, '\');

  SetBasePath(S);

  if not DirectoryExists(Path) then
   begin
    SetStatus(fmbWrongPath);

    Exit;
   end;

  RebuildIndex;

  Open:=True;

  SetOpened(True);
 end;

function TFidoMessageBase.Create(const Path: String): Boolean;
 var
  S: String;
 begin
  Create:=False;

  SetOpened(False);

  S:=Path;

  if S[Length(S)] <> '\' then
   S:=Concat(S, '\');

  SetBasePath(S);

  if not CreateDirectory(GetBasePath) then
   Exit;

  RebuildIndex;

  Create:=True;

  SetOpened(True);
 end;

function TFidoMessageBase.Exist(const Path: String): Boolean;
 begin
  Exist:=DirectoryExists(Path);
 end;

procedure TFidoMessageBase.Close;
 begin
  SetBasePath('');

  SetOpened(False);
 end;

function TFidoMessageBase.Exists(Message: Longint): Boolean;
 begin
  Exists:=GetMapDot(Message);
 end;

function TFidoMessageBase.GetLocation: Longint;
 begin
  GetLocation:=Current;
 end;

procedure TFidoMessageBase.SetLocation(Location: Longint);
 begin
  SetCurrent(Location);
 end;

function TFidoMessageBase.OpenMessage: Boolean;
 begin
  OpenMessage:=False;

  if not Exists(Current) then
   begin
    SetStatus(fmbMessageNotFound);

    Exit;
   end;

  if Link <> nil then
   CloseMessage;

  Link:=CreateMessageBaseFileStream(GetBasePath + LongToStr(Current) + '.MSG', smOpen);

  if Link^.Status <> smOk then
   begin
    Dispose(Link, Done);

    Link:=nil;

    SetStatus(fmbCannotCreateStream);

    Exit;
   end;

  SetMessageTextStream(CreateMessageBaseMemoryStream(MaxMessageSize));

  if GetMessageTextStream^.Status <> smOk then
   begin
    Dispose(Link, Done);

    SetMessageTextStream(nil);

    Link:=nil;

    SetStatus(fmbCannotCreateStream);

    Exit;
   end;

  Link^.Seek(0);

  Link^.Read(Header, SizeOf(Header));

  GetMessageTextStream^.CopyFrom(Link^, Link^.GetSize - Link^.GetPos - 1);

  GetMessageTextStream^.Seek(0);

  OpenMessage:=True;
 end;

function TFidoMessageBase.OpenMessageHeader: Boolean;
 var
  vmb: PVirtualMessageBaseMHL;
  Line: PChar;
 begin
  OpenMessageHeader:=False;

  if not Exists(Current) then
   begin
    SetStatus(fmbMessageNotFound);

    Exit;
   end;

  if Link <> nil then
   CloseMessage;

  Link:=CreateMessageBaseFileStream(GetBasePath + LongToStr(Current) + '.MSG', smOpen);

  if Link^.Status <> smOk then
   begin
    Dispose(Link, Done);

    Link:=nil;

    SetStatus(fmbCannotCreateStream);

    Exit;
   end;

  SetMessageTextStream(CreateMessageBaseMemoryStream(MaxMessageSize));

  if GetMessageTextStream^.Status <> smOk then
   begin
    Dispose(Link, Done);

    SetMessageTextStream(nil);

    Link:=nil;

    SetStatus(fmbCannotCreateStream);

    Exit;
   end;

  Link^.Seek(0);

  Link^.Read(Header, SizeOf(Header));

  vmb:=New(PVirtualMessageBaseMHL, Init(Link));

  GetMem(Line, MaxLineSize);

  vmb^.GetStringPChar(Line, MaxLineSize);

  if Line[0] = #1 then
   PutStringPChar(Line);

  repeat
   vmb^.GetStringPChar(Line, MaxLineSize);

   if Line[0] <> #1 then
    Break;

   PutStringPChar(Line);
  until False;

  FreeMem(Line, MaxLineSize);

  Dispose(vmb, Done);

  OpenMessageHeader:=True;
 end;

function TFidoMessageBase.CloseMessage: Boolean;
 begin
  CloseMessage:=False;

  if Link = nil then
   begin
    SetStatus(fmbAlreadyClosed);

    Exit;
   end;

  Dispose(Link, Done);

  SetMessageTextStream(nil);

  Link:=nil;

  CloseMessage:=True;
 end;

function TFidoMessageBase.GetHighest: Longint;
 begin
  GetHighest:=HighMessage;
 end;

function TFidoMessageBase.GetCount: Longint;
 begin
  GetCount:=TotalMessages;
 end;

function TFidoMessageBase.GetFrom: String;
 begin
  GetFrom:=FromASCIIZ(@Header.FromUser);
 end;

function TFidoMessageBase.GetTo: String;
 begin
  GetTo:=FromASCIIZ(@Header.ToUser);
 end;

function TFidoMessageBase.GetSubject: String;
 begin
  GetSubject:=FromASCIIZ(@Header.Subject);
 end;

procedure TFidoMessageBase.GetFromAddress(var Address: TAddress);
 begin
  ClearAddress(Address);

  Address.Net:=Header.OrigNet;
  Address.Node:=Header.OrigNode;

  inherited GetFromAddress(Address);

  if Address.Zone = 0 then
   Address.Zone:=DefaultZone;
 end;

procedure TFidoMessageBase.GetToAddress(var Address: TAddress);
 begin
  ClearAddress(Address);

  Address.Net:=Header.DestNet;
  Address.Node:=Header.DestNode;

  inherited GetToAddress(Address);

  if Address.Zone = 0 then
   Address.Zone:=DefaultZone;
 end;

procedure TFidoMessageBase.GetFromAndToAddress(var FromAddress, ToAddress: TAddress);
 begin
  ClearAddress(FromAddress);
  ClearAddress(ToAddress);

  FromAddress.Net:=Header.OrigNet;
  FromAddress.Node:=Header.OrigNode;

  ToAddress.Net:=Header.DestNet;
  ToAddress.Node:=Header.DestNode;

  inherited GetFromAndToAddress(FromAddress, ToAddress);

  if FromAddress.Zone = 0 then
   FromAddress.Zone:=DefaultZone;

  if ToAddress.Zone = 0 then
   ToAddress.Zone:=DefaultZone;
 end;

procedure TFidoMessageBase.SetFrom(const S: String);
 begin
  ToASCIIZ(Copy(S, 1, 35), @Header.FromUser);
 end;

procedure TFidoMessageBase.SetTo(const S: String);
 begin
  ToASCIIZ(Copy(S, 1, 35), @Header.ToUser);
 end;

procedure TFidoMessageBase.SetSubject(const S: String);
 begin
  ToASCIIZ(Copy(S, 1, 71), @Header.Subject);
 end;

procedure TFidoMessageBase.SetFromAddress(var Address: TAddress; const FreshMSGID: Boolean);
 begin
  inherited SetFromAddress(Address, FreshMSGID);

  Header.OrigNet:=Address.Net;
  Header.OrigNode:=Address.Node;
 end;

procedure TFidoMessageBase.SetToAddress(var Address: TAddress);
 begin
  inherited SetToAddress(Address);

  Header.DestNet:=Address.Net;
  Header.DestNode:=Address.Node;
 end;

procedure TFidoMessageBase.SetFromAndToAddress(var FromAddress, ToAddress: TAddress; const FreshMSGID: Boolean);
 begin
  inherited SetFromAndToAddress(FromAddress, ToAddress, FreshMSGID);

  Header.OrigNet:=FromAddress.Net;
  Header.OrigNode:=FromAddress.Node;

  Header.DestNet:=ToAddress.Net;
  Header.DestNode:=ToAddress.Node;
 end;

function TFidoMessageBase.GetAttribute(Attribute: Longint): Boolean;
 begin
  if not MapAttribute(Attribute) then
   GetAttribute:=False
  else
   GetAttribute:=GetLocalAttribute(Attribute);
 end;

procedure TFidoMessageBase.SetAttribute(Attribute: Longint; Enable: Boolean);
 begin
  if MapAttribute(Attribute) then
   SetLocalAttribute(Attribute, Enable);
 end;

function TFidoMessageBase.GetLocalAttribute(Attribute: Longint): Boolean;
 begin
  GetLocalAttribute:=Header.Attr and Attribute = Attribute;
 end;

procedure TFidoMessageBase.SetLocalAttribute(Attribute: Longint; Enable: Boolean);
 begin
  if Enable then
   Header.Attr:=Header.Attr or Attribute
  else
   Header.Attr:=Header.Attr and not Attribute;
 end;

{ Warning!
  TFidoMessageBase.GetWrittenDateTime was tested only with format of
  keeping of date named 'Fido'. Work with other formats of keeping of
  date is not guaranteed.
}
procedure TFidoMessageBase.GetWrittenDateTime(var DateTime: TMessageBaseDateTime);
 var
  S: String;
  K: Byte;
 begin
  FillChar(DateTime, SizeOf(DateTime), 0);

  S:=FromASCIIZ(@Header.DateTime);

  if S[3] = ' ' then
   if S[11] = ' ' then {Fido - "DD MMM YY  HH:MM:SS"}
    begin
     MonthStringToMonthNumber(ExtractWord(2, S, [' ']), DateTime.Month);

     StrToWord(ExtractWord(1, S, [' ']), DateTime.Day);
     StrToWord(ExtractWord(3, S, [' ']), DateTime.Year);

     Delete(S, 1, 11);

     StrToWord(ExtractWord(1, S, [':']), DateTime.Hour);
     StrToWord(ExtractWord(2, S, [':']), DateTime.Min);
     StrToWord(ExtractWord(3, S, [':', ' ']), DateTime.Sec);
    end
   else {Opus - "DD MMM YY HH:MM:SS"}
    begin
     MonthStringToMonthNumber(ExtractWord(2, S, [' ']), DateTime.Month);

     StrToWord(ExtractWord(1, S, [' ']), DateTime.Day);
     StrToWord(ExtractWord(3, S, [' ']), DateTime.Year);

     Delete(S, 1, 10);

     StrToWord(ExtractWord(1, S, [':']), DateTime.Hour);
     StrToWord(ExtractWord(2, S, [':']), DateTime.Min);
     StrToWord(ExtractWord(3, S, [':', ' ']), DateTime.Sec);
    end
  else
   if S[4] = ' ' then {SeaDog - "DOW DD MMM YY HH:MM"}
    begin
     Delete(S, 1, 4);

     MonthStringToMonthNumber(ExtractWord(2, S, [' ']), DateTime.Month);

     StrToWord(ExtractWord(1, S, [' ']), DateTime.Day);
     StrToWord(ExtractWord(3, S, [' ']), DateTime.Year);

     Delete(S, 1, 10);

     StrToWord(ExtractWord(1, S, [':']), DateTime.Hour);
     StrToWord(ExtractWord(2, S, [':']), DateTime.Min);

     DateTime.Sec:=0;
    end
   else
    if S[3] = '-' then {Wierd - "DD-MM-YYYY HH:MM:SS"}
     begin
      for K:=1 to Length(S) do
       if S[K] in ['-', ':'] then S[K]:=' ';

      StrToWord(ExtractWord(1, S, [' ']), DateTime.Day);
      StrToWord(ExtractWord(2, S, [' ']), DateTime.Month);
      StrToWord(ExtractWord(3, S, [' ']), DateTime.Year);
      StrToWord(ExtractWord(4, S, [' ']), DateTime.Hour);
      StrToWord(ExtractWord(5, S, [' ']), DateTime.Min);
      StrToWord(ExtractWord(6, S, [' ']), DateTime.Sec);
     end;

  DateTime.Year:=DoubleToY2(DateTime.Year);
 end;

procedure TFidoMessageBase.GetArrivedDateTime(var DateTime: TMessageBaseDateTime);
 begin
  MSGDateTimeToMessageBaseDateTime(Header.DateArrived, DateTime);
 end;

procedure TFidoMessageBase.SetWrittenDateTime(var DateTime: TMessageBaseDateTime);
 function LeadingZero(Number: Word): String;
  var
   S: String[2];
  begin
   Str(Number, S);

   if S[0] = #1 then
    S:=Concat('0', S);

   LeadingZero:=S;
  end;
 begin
  StrPCopy(@Header.DateTime,
           LeadingZero(DateTime.Day) + ' ' +
           MonthNumberToMonthString(DateTime.Month) + ' ' +
           LeadingZero(Y2ToDouble(DateTime.Year)) + '  ' +
           LeadingZero(DateTime.Hour) + ':' +
           LeadingZero(DateTime.Min) + ':' +
           LeadingZero(DateTime.Sec));

  MessageBaseDateTimeToMSGDateTime(DateTime, Header.DateWritten);
 end;

procedure TFidoMessageBase.SetArrivedDateTime(var DateTime: TMessageBaseDateTime);
 begin
  MessageBaseDateTimeToMSGDateTime(DateTime, Header.DateArrived);
 end;

function TFidoMessageBase.WriteMessage: Boolean;
 var
  B: System.Byte;
 begin
  WriteMessage:=True;

  Link^.Reset;

  Link^.Seek(0);

  Link^.Write(Header, SizeOf(Header));

  GetMessageTextStream^.Seek(0);

  Link^.CopyFrom(GetMessageTextStream^, GetMessageTextStream^.GetSize);

  B:=0;

  Link^.Write(B, SizeOf(B));

  Link^.Truncate;

  Link^.Flush;
 end;

function TFidoMessageBase.WriteMessageHeader: Boolean;
 begin
  Link^.Seek(0);

  Link^.Write(Header, SizeOf(Header));

  WriteMessageHeader:=True;
 end;

function TFidoMessageBase.CreateNewMessage: Boolean;
 begin
  CreateNewMessage:=False;

  SetCurrent(GetHighest + 1);

  Inc(HighMessage);

  SetMapDot(Current, True);

  if Link <> nil then
   CloseMessage;

  Link:=CreateMessageBaseFileStream(GetBasePath + LongToStr(Current) + '.MSG', smCreate);

  if Link^.Status <> smOk then
   begin
    Dispose(Link, Done);

    Link:=nil;

    Exit;
   end;

  SetMessageTextStream(CreateMessageBaseMemoryStream(MaxMessageSize));

  if GetMessageTextStream^.Status <> smOk then
   begin
    Dispose(Link, Done);

    SetMessageTextStream(nil);

    Link:=nil;

    Exit;
   end;

  FillChar(Header, SizeOf(Header), 0);

  ResetDateTime;

  CreateNewMessage:=True;
 end;

function TFidoMessageBase.KillMessage: Boolean;
 begin
  KillMessage:=False;

  if not Exists(Current) then
   Exit;

  if not KillFile(GetBasePath + LongToStr(Current) + '.MSG') then
   Exit;

  SetMapDot(Current, False);

  KillMessage:=True;
 end;

function TFidoMessageBase.GetLastRead(const UserNumber: Longint): Longint;
 var
  Stream: PMessageBaseStream;
  LastRead: System.Word;
 begin
  Stream:=CreateMessageBaseFileStream(GetBasePath + 'lastread', smOpenRead);

  if Stream^.Status <> smOk then
   GetLastRead:=0
  else
   if (UserNumber + 1) * SizeOf(LastRead) > Stream^.GetSize then
    GetLastRead:=0
   else
    begin
     Stream^.Seek(UserNumber * SizeOf(LastRead));

     Stream^.Read(LastRead, SizeOf(LastRead));

     GetLastRead:=LastRead;
    end;

  Dispose(Stream, Done);
 end;

procedure TFidoMessageBase.SetLastRead(const UserNumber: Longint; const Value: Longint);
 var
  Stream: PMessageBaseStream;
  LastRead: System.Word;
 begin
  Stream:=CreateMessageBaseFileStream(GetBasePath + 'lastread', smOpenWrite);

  if Stream^.Status <> smOk then
   begin
    Dispose(Stream, Done);

    Stream:=CreateMessageBaseFileStream(GetBasePath + 'lastread', smCreate);
   end;

  if Stream^.Status = smOk then
    begin
     Stream^.Seek(UserNumber * SizeOf(LastRead));

     LastRead:=Value;

     Stream^.Write(LastRead, SizeOf(LastRead));
    end;

  Dispose(Stream, Done);
 end;

function TFidoMessageBase.GetAFLAG(const Flag: String): Boolean;
 var
  S: String;
 begin
  if (Flag <> '') and GetKludge(#1'FLAGS', S) then
   GetAFLAG:=Pos(Flag, S) > 0
  else
   GetAFLAG:=False;
 end;

procedure TFidoMessageBase.SetAFLAG(const Flag: String; const Enable: Boolean);
 var
  S: String;
 begin
  if (Flag <> '') and (GetAFLAG(Flag) <> Enable) then
   begin
    if GetKludge(#1'FLAGS', S) then
     if Enable then
      S:=Concat(S, ' ', Flag)
     else
      Delete(S, Pos(' ' + Flag, S), Length(Flag) + 1)
    else
     if Enable then
      S:=Concat(#1'FLAGS ', Flag)
     else
      S:='';

    if Length(S) < 8 then
     DeleteKludge(#1'FLAGS')
    else
     SetKludge(#1'FLAGS', S);
   end;
 end;

procedure TFidoMessageBase.SetReplyTo(const ReplyTo: Longint);
 begin
  Header.ReplyTo:=ReplyTo;
 end;

function TFidoMessageBase.GetReplyTo: Longint;
 begin
  GetReplyTo:=Header.ReplyTo;
 end;

procedure TFidoMessageBase.SetReplyNext(const ReplyNext: Longint);
 begin
  Header.ReplyNext:=ReplyNext;
 end;

function TFidoMessageBase.GetReplyNext: Longint;
 begin
  GetReplyNext:=Header.ReplyNext;
 end;

procedure TFidoMessageBase.GetHeader(var AHeader: TFidoHeader);
 begin
  AHeader:=Header;
 end;

function TFidoMessageBase.GetRead: Boolean;
 begin
  GetRead:=Header.TimesRead <> 0;
 end;

procedure TFidoMessageBase.SetRead(const Value: Boolean);
 begin
  if Value then
   Inc(Header.TimesRead)
  else
   Header.TimesRead:=0;
 end;

{ private methods }

procedure TFidoMessageBase.RebuildIndex;
 var
  Find: PMessageBaseFind;
{$IFDEF VIRTUALPASCAL}
  Num, Code: Longint;
{$ELSE}
  Num, Code: Integer;
{$ENDIF}
 begin
  FillChar(Map, SizeOf(Map), 0);

  TotalMessages:=0;
  HighMessage:=0;

  Find:=CreateMessageBaseFind;

  if Find^.StartSearch(GetBasePath + '*.MSG', faReadonly + faArchive) then
   repeat
    Val(Copy(Find^.iName, 1, Pos('.', Find^.iName) - 1), Num, Code);

    if (Code = 0) and (Num > 0) then
     begin
      SetMapDot(Num, True);

      if Num > HighMessage then
       HighMessage:=Num;
     end;
   until not Find^.NextSearch;

  Find^.StopSearch;

  Dispose(Find, Done);
 end;

procedure TFidoMessageBase.SetMapDot(Num: Integer; Value: Boolean);
 var
  N: Integer;
 begin
  if Num >= MaxMapSize then
   Exit;

  N:=Num shr $03;

  if Value then
   begin
    Map[N]:=Map[N] or MapPos[Num and $07];

    Inc(TotalMessages);
   end
  else
   begin
    Map[N]:=Map[N] and not MapPos[Num and $07];

    Dec(TotalMessages);
   end;
 end;

function TFidoMessageBase.GetMapDot(Num: Integer): Boolean;
 begin
  if Num >= MaxMapSize then
   begin
    GetMapDot:=False;

    Exit;
   end;

  GetMapDot:=Map[Num shr $03] and MapPos[Num and $07] <> 0;
 end;

function TFidoMessageBase.MapAttribute(var Attribute: Longint): Boolean;
 procedure DoMapping(const AAttribute: Longint);
  begin
   Attribute:=AAttribute;
  end;
 begin
  MapAttribute:=True;

  case Attribute of {DIR IMM KFS TFS LOK CFM}
   maPrivate: DoMapping(faPrivate);
   maCrash: DoMapping(faCrash);
   maReceived: DoMapping(faReceived);
   maSent: DoMapping(faSent);
   maAttach: DoMapping(faAttach);
   maTransit: DoMapping(faTransit);
   maOrphan: DoMapping(faOrphan);
   maKill: DoMapping(faKill);
   maLocal: DoMapping(faLocal);
   maHold: DoMapping(faHold);
   maFRq: DoMapping(faFRq);
   maRRq: DoMapping(faRRq);
   maRRc: DoMapping(faRRc);
   maARq: DoMapping(faARq);
   maURq: DoMapping(faURq);
  else
   MapAttribute:=False;
  end;
 end;

end.
