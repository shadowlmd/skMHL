{&Cdecl-,OrgName+}
library
 {$IFDEF DELPHI}
  skMHLd
 {$ELSE}
  {$IFDEF DPMI}  skMHLapi {$ENDIF}
  {$IFDEF WIN32} skMHLw32 {$ENDIF}
  {$IFDEF OS2}   skMHLos2 {$ENDIF}
 {$ENDIF};

uses Wizard,

     skMHL,
     skCommon,

     skMHLmsg,
     skMHLjam,
     skMHLsq,
     skMHLvmb,
     skOpen,

     GStream;

{ stuff }

procedure skmhlapiInit; export;
 begin
 end;

procedure skmhlapiSetRegisterFileHandlers(const ARegisterFileOpen: TMessageBaseRegisterFileOpen;
                                          const ARegisterFileClose: TMessageBaseRegisterFileClose); export;
 begin
  RegisterFileOpen:=ARegisterFileOpen;
  RegisterFileClose:=ARegisterFileClose;
 end;

procedure skmhlapiClearRegisterFileHandlers; export;
 begin
  RegisterFileOpen:=DefaultRegisterFileOpen;
  RegisterFileClose:=DefaultRegisterFileClose;
 end;

{ TMessageBase }

function skmhlapiOpen(const Base: Pointer; const Path: String): Boolean; export;
 begin
  skmhlapiOpen:=PMessageBase(Base)^.Open(Path);
 end;

function skmhlapiCreate(const Base: Pointer; const Path: String): Boolean; export;
 begin
  skmhlapiCreate:=PMessageBase(Base)^.Create(Path);
 end;

function skmhlapiExist(const Base: Pointer; const Path: String): Boolean; export;
 begin
  skmhlapiExist:=PMessageBase(Base)^.Exist(Path);
 end;

procedure skmhlapiClose(const Base: Pointer); export;
 begin
  PMessageBase(Base)^.Close;
 end;

function skmhlapiExists(const Base: Pointer; Message: Longint): Boolean; export;
 begin
  skmhlapiExists:=PMessageBase(Base)^.Exists(Message);
 end;

function skmhlapiCurrent(const Base: Pointer): Longint; export;
 begin
  skmhlapiCurrent:=PMessageBase(Base)^.Current;
 end;

procedure skmhlapiSeek(const Base: Pointer; Message: Longint); export;
 begin
  PMessageBase(Base)^.Seek(Message);
 end;

procedure skmhlapiSeekNext(const Base: Pointer); export;
 begin
  PMessageBase(Base)^.SeekNext;
 end;

procedure skmhlapiSeekPrev(const Base: Pointer); export;
 begin
  PMessageBase(Base)^.SeekPrev;
 end;

function skmhlapiSeekFound(const Base: Pointer): Boolean; export;
 begin
  skmhlapiSeekFound:=PMessageBase(Base)^.SeekFound;
 end;

function skmhlapiGetLocation(const Base: Pointer): Longint; export;
 begin
  skmhlapiGetLocation:=PMessageBase(Base)^.GetLocation;
 end;

procedure skmhlapiSetLocation(const Base: Pointer; Location: Longint); export;
 begin
  PMessageBase(Base)^.SetLocation(Location);
 end;

function skmhlapiOpenMessage(const Base: Pointer): Boolean; export;
 begin
  skmhlapiOpenMessage:=PMessageBase(Base)^.OpenMessage;
 end;

function skmhlapiOpenMessageHeader(const Base: Pointer): Boolean; export;
 begin
  skmhlapiOpenMessageHeader:=PMessageBase(Base)^.OpenMessageHeader;
 end;

function skmhlapiCloseMessage(const Base: Pointer): Boolean; export;
 begin
  skmhlapiCloseMessage:=PMessageBase(Base)^.CloseMessage;
 end;

function skmhlapiGetHighest(const Base: Pointer): Longint; export;
 begin
  skmhlapiGetHighest:=PMessageBase(Base)^.GetHighest;
 end;

function skmhlapiGetCount(const Base: Pointer): Longint; export;
 begin
  skmhlapiGetCount:=PMessageBase(Base)^.GetCount;
 end;

function skmhlapiGetFrom(const Base: Pointer): String; export;
 begin
  skmhlapiGetFrom:=PMessageBase(Base)^.GetFrom;
 end;

function skmhlapiGetTo(const Base: Pointer): String; export;
 begin
  skmhlapiGetTo:=PMessageBase(Base)^.GetTo;
 end;

function skmhlapiGetSubject(const Base: Pointer): String; export;
 begin
  skmhlapiGetSubject:=PMessageBase(Base)^.GetSubject;
 end;

procedure skmhlapiGetFromAddress(const Base: Pointer; var Address: TAddress); export;
 begin
  PMessageBase(Base)^.GetFromAddress(Address);
 end;

procedure skmhlapiGetToAddress(const Base: Pointer; var Address: TAddress); export;
 begin
  PMessageBase(Base)^.GetToAddress(Address);
 end;

procedure skmhlapiGetFromAndToAddress(const Base: Pointer; var FromAddress, ToAddress: TAddress); export;
 begin
  PMessageBase(Base)^.GetFromAndToAddress(FromAddress, ToAddress);
 end;

procedure skmhlapiSetFrom(const Base: Pointer; const S: String); export;
 begin
  PMessageBase(Base)^.SetFrom(S);
 end;

procedure skmhlapiSetTo(const Base: Pointer; const S: String); export;
 begin
  PMessageBase(Base)^.SetTo(S);
 end;

procedure skmhlapiSetSubject(const Base: Pointer; const S: String); export;
 begin
  PMessageBase(Base)^.SetSubject(S);
 end;

procedure skmhlapiSetFromAddress(const Base: Pointer; var Address: TAddress; const FreshMSGID: Boolean); export;
 begin
  PMessageBase(Base)^.SetFromAddress(Address, FreshMSGID);
 end;

procedure skmhlapiSetToAddress(const Base: Pointer; var Address: TAddress); export;
 begin
  PMessageBase(Base)^.SetToAddress(Address);
 end;

procedure skmhlapiSetFromAndToAddress(const Base: Pointer; var FromAddress, ToAddress: TAddress; const FreshMSGID: Boolean);
export;
 begin
  PMessageBase(Base)^.SetFromAndToAddress(FromAddress, ToAddress, FreshMSGID);
 end;

procedure skmhlapiGetStringPChar(const Base: Pointer; Line: PChar; MaxLen: Integer); export;
 begin
  PMessageBase(Base)^.GetStringPChar(Line, MaxLen);
 end;

procedure skmhlapiGetString(const Base: Pointer; var Line: String); export;
 begin
  PMessageBase(Base)^.GetString(Line);
 end;

procedure skmhlapiPutStringPChar(const Base: Pointer; Line: PChar); export;
 begin
  PMessageBase(Base)^.PutStringPChar(Line);
 end;

procedure skmhlapiPutString(const Base: Pointer; const Line: String); export;
 begin
  PMessageBase(Base)^.PutString(Line);
 end;

function skmhlapiEndOfMessage(const Base: Pointer): Boolean; export;
 begin
  skmhlapiEndOfMessage:=PMessageBase(Base)^.EndOfMessage;
 end;

procedure skmhlapiSetTextPos(const Base: Pointer; Position: Longint); export;
 begin
  PMessageBase(Base)^.SetTextPos(Position);
 end;

function skmhlapiGetTextPos(const Base: Pointer): Longint; export;
 begin
  skmhlapiGetTextPos:=PMessageBase(Base)^.GetTextPos;
 end;

function skmhlapiGetTextSize(const Base: Pointer): Longint; export;
 begin
  skmhlapiGetTextSize:=PMessageBase(Base)^.GetTextSize;
 end;

procedure skmhlapiTruncateText(const Base: Pointer); export;
 begin
  PMessageBase(Base)^.TruncateText;
 end;

procedure skmhlapiReadText(const Base: Pointer; var Buf; Count: Word); export;
 begin
  PMessageBase(Base)^.ReadText(Buf, Count);
 end;

procedure skmhlapiWriteText(const Base: Pointer; var Buf; Count: Word); export;
 begin
  PMessageBase(Base)^.WriteText(Buf, Count);
 end;

function skmhlapiGetAttribute(const Base: Pointer; Attribute: Longint): Boolean; export;
 begin
  skmhlapiGetAttribute:=PMessageBase(Base)^.GetAttribute(Attribute);
 end;

procedure skmhlapiSetAttribute(const Base: Pointer; Attribute: Longint; Enable: Boolean); export;
 begin
  PMessageBase(Base)^.SetAttribute(Attribute, Enable);
 end;

procedure skmhlapiGetWrittenDateTime(const Base: Pointer; var DateTime: TMessageBaseDateTime); export;
 begin
  PMessageBase(Base)^.GetWrittenDateTime(DateTime);
 end;

procedure skmhlapiGetArrivedDateTime(const Base: Pointer; var DateTime: TMessageBaseDateTime); export;
 begin
  PMessageBase(Base)^.GetArrivedDateTime(DateTime);
 end;

procedure skmhlapiSetWrittenDateTime(const Base: Pointer; var DateTime: TMessageBaseDateTime); export;
 begin
  PMessageBase(Base)^.SetWrittenDateTime(DateTime);
 end;

procedure skmhlapiSetArrivedDateTime(const Base: Pointer; var DateTime: TMessageBaseDateTime); export;
 begin
  PMessageBase(Base)^.SetArrivedDateTime(DateTime);
 end;

function skmhlapiWriteMessage(const Base: Pointer): Boolean; export;
 begin
  skmhlapiWriteMessage:=PMessageBase(Base)^.WriteMessage;
 end;

function skmhlapiWriteMessageHeader(const Base: Pointer): Boolean; export;
 begin
  skmhlapiWriteMessageHeader:=PMessageBase(Base)^.WriteMessageHeader;
 end;

function skmhlapiGetKludgePChar(const Base: Pointer; const Name, Destination: PChar; const MaxLen: Integer): Boolean; export;
 begin
  skmhlapiGetKludgePChar:=PMessageBase(Base)^.GetKludgePChar(Name, Destination, MaxLen);
 end;

function skmhlapiGetKludge(const Base: Pointer; const Name: String; var Destination: String): Boolean; export;
 begin
  skmhlapiGetKludge:=PMessageBase(Base)^.GetKludge(Name, Destination);
 end;

procedure skmhlapiSetKludgePChar(const Base: Pointer; const Name, Value: PChar); export;
 begin
  PMessageBase(Base)^.SetKludgePChar(Name, Value);
 end;

procedure skmhlapiSetKludge(const Base: Pointer; const Name, Value: String); export;
 begin
  PMessageBase(Base)^.SetKludge(Name, Value);
 end;

procedure skmhlapiDeleteKludgePChar(const Base: Pointer; const Name: PChar); export;
 begin
  PMessageBase(Base)^.DeleteKludgePChar(Name);
 end;

procedure skmhlapiDeleteKludge(const Base: Pointer; const Name: String); export;
 begin
  PMessageBase(Base)^.DeleteKludge(Name);
 end;

procedure skmhlapiAddKludgePChar(const Base: Pointer; const Value: PChar); export;
 begin
  PMessageBase(Base)^.AddKludgePChar(Value);
 end;

procedure skmhlapiAddKludge(const Base: Pointer; const Value: String); export;
 begin
  PMessageBase(Base)^.AddKludge(Value);
 end;

function skmhlapiGetMessageTextStream(const Base: Pointer): PMessageBaseStream; export;
 begin
  skmhlapiGetMessageTextStream:=PMessageBase(Base)^.GetMessageTextStream;
 end;

procedure skmhlapiSetFlag(const Base: Pointer; const Flag: Longint; const Enable: Boolean); export;
 begin
  PMessageBase(Base)^.SetFlag(Flag, Enable);
 end;

function skmhlapiGetFlag(const Base: Pointer; const Flag: Longint): Boolean; export;
 begin
  skmhlapiGetFlag:=PMessageBase(Base)^.GetFlag(Flag);
 end;

procedure skmhlapiCheckFromAddress(const Base: Pointer; const S: String; var Address: TAddress); export;
 begin
  PMessageBase(Base)^.CheckFromAddress(S, Address);
 end;

procedure skmhlapiCheckToAddress(const Base: Pointer; const S: String; var Address: TAddress); export;
 begin
  PMessageBase(Base)^.CheckToAddress(S, Address);
 end;

function skmhlapiCreateNewMessage(const Base: Pointer): Boolean; export;
 begin
  skmhlapiCreateNewMessage:=PMessageBase(Base)^.CreateNewMessage;
 end;

function skmhlapiKillMessage(const Base: Pointer): Boolean; export;
 begin
  skmhlapiKillMessage:=PMessageBase(Base)^.KillMessage;
 end;

function skmhlapiGetLastRead(const Base: Pointer; const UserNumber: Longint): Longint; export;
 begin
  skmhlapiGetLastRead:=PMessageBase(Base)^.GetLastRead(UserNumber);
 end;

procedure skmhlapiSetLastRead(const Base: Pointer; const UserNumber: Longint; const Value: Longint); export;
 begin
  PMessageBase(Base)^.SetLastRead(UserNumber, Value);
 end;

procedure skmhlapiResetDateTime(const Base: Pointer); export;
 begin
  PMessageBase(Base)^.ResetDateTime;
 end;

procedure skmhlapiSetBaseType(const Base: Pointer; const BaseType: TBaseType); export;
 begin
  PMessageBase(Base)^.SetBaseType(BaseType);
 end;

procedure skmhlapiPutOrigin(const Base: Pointer; Address: TAddress; const Text: String); export;
 begin
  PMessageBase(Base)^.PutOrigin(Address, Text);
 end;

function skmhlapiAfterLastKludge(const Base: Pointer): Longint; export;
 begin
  skmhlapiAfterLastKludge:=PMessageBase(Base)^.AfterLastKludge;
 end;

procedure skmhlapiSetMessageTextStream(const Base: Pointer; const AMessageText: PMessageBaseStream); export;
 begin
  PMessageBase(Base)^.SetMessageTextStream(AMessageText);
 end;

procedure skmhlapiSetStatus(const Base: Pointer; const AStatus: Longint); export;
 begin
  PMessageBase(Base)^.SetStatus(AStatus);
 end;

function skmhlapiGetStatus(const Base: Pointer): Longint; export;
 begin
  skmhlapiGetStatus:=PMessageBase(Base)^.GetStatus;
 end;

procedure skmhlapiSetOpened(const Base: Pointer; const AOpened: Boolean); export;
 begin
  PMessageBase(Base)^.SetOpened(AOpened);
 end;

function skmhlapiGetOpened(const Base: Pointer): Boolean; export;
 begin
  skmhlapiGetOpened:=PMessageBase(Base)^.GetOpened;
 end;

procedure skmhlapiSetCurrent(const Base: Pointer; const ACurrentMessage: Longint); export;
 begin
  PMessageBase(Base)^.SetCurrent(ACurrentMessage);
 end;

procedure skmhlapiSetBasePath(const Base: Pointer; const ABasePath: String); export;
 begin
  PMessageBase(Base)^.SetBasePath(ABasePath);
 end;

function skmhlapiGetBasePath(const Base: Pointer): String; export;
 begin
  skmhlapiGetBasePath:=PMessageBase(Base)^.GetBasePath;
 end;

function skmhlapiGetRead(const Base: Pointer): Boolean; export;
 begin
  skmhlapiGetRead:=PMessageBase(Base)^.GetRead;
 end;

procedure skmhlapiSetRead(const Base: Pointer; const Value: Boolean); export;
 begin
  PMessageBase(Base)^.SetRead(Value);
 end;

{ TMessageBase publics }

function skmhlapiKludgeStart(const Base: Pointer): Longint; export;
 begin
  skmhlapiKludgeStart:=PMessageBase(Base)^.KludgeStart;
 end;

function skmhlapiKludgeEnd(const Base: Pointer): Longint; export;
 begin
  skmhlapiKludgeEnd:=PMessageBase(Base)^.KludgeEnd;
 end;

{ skMHL useful things }

procedure skmhlapiGetAttributesLine(const Base: Pointer; var S: String); export;
 begin
  GetAttributesLine(Base, S);
 end;

procedure skmhlapiGetDateTimeLine(var DT: TMessageBaseDateTime; var S: String); export;
 begin
  GetDateTimeLine(DT, S);
 end;

{ skMHL versions }

function skmhlapiVersion: String; export;
 begin
  skmhlapiVersion:=skMHLversion + skMHLdllsuffix;
 end;

function skmhlapiTitle: String; export;
 begin
  skmhlapiTitle:=skMHLtitle + skMHLdllsuffix;
 end;

function skmhlapiFullTitle: String; export;
 var
  S: String;
 begin
  S:=skMHLfulltitle;

  Insert(skMHLdllsuffix, S, Length(skMHLtitle) + 1);

  skmhlapiFullTitle:=S;
 end;

{ TFidoMessageBase additional methods }

function skmhlapifidoGetAFLAG(const Base: Pointer; const Flag: String): Boolean; export;
 begin
  skmhlapifidoGetAFLAG:=PFidoMessageBase(Base)^.GetAFLAG(Flag);
 end;

procedure skmhlapifidoSetAFLAG(const Base: Pointer; const Flag: String; const Enable: Boolean); export;
 begin
  PFidoMessageBase(Base)^.SetAFLAG(Flag, Enable);
 end;

procedure skmhlapifidoSetReplyTo(const Base: Pointer; const ReplyTo: Longint); export;
 begin
  PFidoMessageBase(Base)^.SetReplyTo(ReplyTo);
 end;

function skmhlapifidoGetReplyTo(const Base: Pointer): Longint; export;
 begin
  skmhlapifidoGetReplyTo:=PFidoMessageBase(Base)^.GetReplyTo;
 end;

procedure skmhlapifidoSetReplyNext(const Base: Pointer; const ReplyNext: Longint); export;
 begin
  PFidoMessageBase(Base)^.SetReplyNext(ReplyNext);
 end;

function skmhlapifidoGetReplyNext(const Base: Pointer): Longint; export;
 begin
  skmhlapifidoGetReplyNext:=PFidoMessageBase(Base)^.GetReplyNext;
 end;

procedure skmhlapifidoGetHeader(const Base: Pointer; var AHeader: TFidoHeader); export;
 begin
  PFidoMessageBase(Base)^.GetHeader(AHeader);
 end;

{ TJamMessageBase }

function skmhlapijamGetReplyTo(const Base: Pointer): LongInt; export;
 begin
  skmhlapijamGetReplyTo:=PJamMessageBase(Base)^.GetReplyTo;
 end;

function skmhlapijamGetReplyFirst(const Base: Pointer): LongInt; export;
 begin
  skmhlapijamGetReplyFirst:=PJamMessageBase(Base)^.GetReplyFirst;
 end;

function skmhlapijamGetReplyNext(const Base: Pointer): LongInt; export;
 begin
  skmhlapijamGetReplyNext:=PJamMessageBase(Base)^.GetReplyNext;
 end;

procedure skmhlapijamSetReplyTo(const Base: Pointer; const AReplyTo: LongInt); export;
 begin
  PJamMessageBase(Base)^.SetReplyTo(AReplyTo);
 end;

procedure skmhlapijamSetReplyFirst(const Base: Pointer; const AReplyFirst: LongInt); export;
 begin
  PJamMessageBase(Base)^.SetReplyFirst(AReplyFirst);
 end;

procedure skmhlapijamSetReplyNext(const Base: Pointer; const AReplyNext: LongInt); export;
 begin
  PJamMessageBase(Base)^.SetReplyNext(AReplyNext);
 end;

procedure skmhlapijamGetMessageHeader(const Base: Pointer; var AHeader: TJamMessageHeaderFirst); export;
 begin
  PJamMessageBase(Base)^.GetMessageHeader(AHeader);
 end;

procedure skmhlapijamGetStreams(const Base: Pointer; var AHeaderLink, AIndexLink, ADataLink: PMessageBaseStream); export;
 begin
  PJamMessageBase(Base)^.GetStreams(AHeaderLink, AIndexLink, ADataLink);
 end;

{ TSquishMessageBase }

procedure skmhlapisquishGetReplies(const Base: Pointer; var Replies: TSquishMessageReplies); export;
 begin
  PSquishMessageBase(Base)^.GetReplies(Replies);
 end;

procedure skmhlapisquishSetReplies(const Base: Pointer; var Replies: TSquishMessageReplies); export;
 begin
  PSquishMessageBase(Base)^.SetReplies(Replies);
 end;

function skmhlapisquishGetReplyTo(const Base: Pointer): Longint; export;
 begin
  skmhlapisquishGetReplyTo:=PSquishMessageBase(Base)^.GetReplyTo;
 end;

procedure skmhlapisquishSetReplyTo(const Base: Pointer; const AReplyTo: Longint); export;
 begin
  PSquishMessageBase(Base)^.SetReplyTo(AReplyTo);
 end;

procedure skmhlapisquishGetMessageHeader(const Base: Pointer; var AHeader: TSquishMessageHeader); export;
 begin
  PSquishMessageBase(Base)^.GetMessageHeader(AHeader);
 end;

procedure skmhlapisquishGetBaseHeader(const Base: Pointer; var AHeader: TSquishBaseHeader); export;
 begin
  PSquishMessageBase(Base)^.GetBaseHeader(AHeader);
 end;

procedure skmhlapisquishGetStreams(const Base: Pointer; var ADataLink, AIndexLink: PMessageBaseStream); export;
 begin
  PSquishMessageBase(Base)^.GetStreams(ADataLink, AIndexLink);
 end;

function skmhlapisquishGetHighWater(const Base: Pointer): Longint; export;
 begin
  skmhlapisquishGetHighWater:=PSquishMessageBase(Base)^.GetHighWater;
 end;

procedure skmhlapisquishSetHighWater(const Base: Pointer; const AHighWater: Longint); export;
 begin
  PSquishMessageBase(Base)^.SetHighWater(AHighWater);
 end;

procedure skmhlapisquishSeekHighWater(const Base: Pointer); export;
 begin
  PSquishMessageBase(Base)^.SeekHighWater;
 end;

{ general stuff }

function skmhlapiCreateFidoMessageBase: Pointer; export;
 begin
  skmhlapiCreateFidoMessageBase:=New(PFidoMessageBase, Init);
 end;

function skmhlapiCreateJamMessageBase: Pointer; export;
 begin
  skmhlapiCreateJamMessageBase:=New(PJamMessageBase, Init);
 end;

function skmhlapiCreateSquishMessageBase: Pointer; export;
 begin
  skmhlapiCreateSquishMessageBase:=New(PSquishMessageBase, Init);
 end;

function skmhlapiCreateMessageBase: Pointer; export;
 begin
  skmhlapiCreateMessageBase:=New(PMessageBase, Init);
 end;

procedure skmhlapiDestroyMessageBase(const Base: Pointer); export;
 begin
  Dispose(PMessageBase(Base), Done);
 end;

{ skOpen }

procedure skmhlapiSplitID(const ID: String; var Format: TMessageBaseFormat; var Path: String); export;
 begin
  SplitID(ID, Format, Path);
 end;

function skmhlapiOpenMessageBaseEx(var Base: Pointer; const ID: String; const Create: Boolean; Attempts: Longint): Boolean;
export;
 begin
  if Create then
   skmhlapiOpenMessageBaseEx:=OpenMessageBaseEx(PMessageBase(Base), ID, OpenOrCreateMessageBase, Attempts)
  else
   skmhlapiOpenMessageBaseEx:=OpenMessageBaseEx(PMessageBase(Base), ID, OpenMessageBase, Attempts);
 end;

function skmhlapiOpenMessageBase(var Base: Pointer; const ID: String): Boolean; export;
 begin
  skmhlapiOpenMessageBase:=OpenMessageBase(PMessageBase(Base), ID);
 end;

function skmhlapiOpenOrCreateMessageBase(var Base: Pointer; const ID: String): Boolean; export;
 begin
  skmhlapiOpenOrCreateMessageBase:=OpenOrCreateMessageBase(PMessageBase(Base), ID);
 end;

function skmhlapiCloseMessageBase(var Base: Pointer): Boolean; export;
 begin
  skmhlapiCloseMessageBase:=CloseMessageBase(PMessageBase(Base));
 end;

function skmhlapiExistMessageBase(const ID: String): Boolean; export;
 begin
  skmhlapiExistMessageBase:=ExistMessageBase(ID);
 end;

function skmhlapiInitMessageBase(var Base: Pointer; const ID: String): Boolean; export;
 begin
  skmhlapiInitMessageBase:=InitMessageBase(PMessageBase(Base), ID);
 end;

function skmhlapiDoneMessageBase(var Base: Pointer): Boolean; export;
 begin
  skmhlapiDoneMessageBase:=DoneMessageBase(PMessageBase(Base));
 end;

function skmhlapiGetOpenStatus: Longint; export;
 begin
  skmhlapiGetOpenStatus:=OpenStatus;
 end;

{ other stuff }

procedure skmhlapiDistinguishBaseFormat(Base: Pointer; var Format: TMessageBaseFormat); export;
 var
  ObjectBase: PMessageBase absolute Base;
 begin
  if TypeOf(ObjectBase^) = TypeOf(TSquishMessageBase) then Format:=mbfSquish else
  if TypeOf(ObjectBase^) = TypeOf(TJamMessageBase) then Format:=mbfJam else
  if TypeOf(ObjectBase^) = TypeOf(TFidoMessageBase) then Format:=mbfMSG else
   Format:=mbfUnknown;
 end;

{ gateways }

function skmhlapiGatewayTV(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint; export;
 begin
  skmhlapiGatewayTV:=DefaultGatewayTV(Stream, fn, Data, l);
 end;

function skmhlapiGatewayMHL(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint; export;
 begin
  skmhlapiGatewayMHL:=DefaultGatewayMHL(Stream, fn, Data, l);
 end;

{$I skMHLapi.INC}

begin
end.