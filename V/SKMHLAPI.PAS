{&CDecl-,OrgName+}
unit skMHLapi;

interface
uses
     skCommon;

procedure skmhlapiInit;
procedure skmhlapiSetRegisterFileHandlers(const ARegisterFileOpen: TMessageBaseRegisterFileOpen;
const ARegisterFileClose: TMessageBaseRegisterFileClose);
procedure skmhlapiClearRegisterFileHandlers;
function skmhlapiOpen(const Base: Pointer; const Path: String): Boolean;
function skmhlapiCreate(const Base: Pointer; const Path: String): Boolean;
function skmhlapiExist(const Base: Pointer; const Path: String): Boolean;
procedure skmhlapiClose(const Base: Pointer);
function skmhlapiExists(const Base: Pointer; Message: Longint): Boolean;
function skmhlapiCurrent(const Base: Pointer): Longint;
procedure skmhlapiSeek(const Base: Pointer; Message: Longint);
procedure skmhlapiSeekNext(const Base: Pointer);
procedure skmhlapiSeekPrev(const Base: Pointer);
function skmhlapiSeekFound(const Base: Pointer): Boolean;
function skmhlapiGetLocation(const Base: Pointer): Longint;
procedure skmhlapiSetLocation(const Base: Pointer; Location: Longint);
function skmhlapiOpenMessage(const Base: Pointer): Boolean;
function skmhlapiOpenMessageHeader(const Base: Pointer): Boolean;
function skmhlapiCloseMessage(const Base: Pointer): Boolean;
function skmhlapiGetHighest(const Base: Pointer): Longint;
function skmhlapiGetCount(const Base: Pointer): Longint;
function skmhlapiGetFrom(const Base: Pointer): String;
function skmhlapiGetTo(const Base: Pointer): String;
function skmhlapiGetSubject(const Base: Pointer): String;
procedure skmhlapiGetFromAddress(const Base: Pointer; var Address: TAddress);
procedure skmhlapiGetToAddress(const Base: Pointer; var Address: TAddress);
procedure skmhlapiGetFromAndToAddress(const Base: Pointer; var FromAddress, ToAddress: TAddress);

procedure skmhlapiSetFrom(const Base: Pointer; const S: String);
procedure skmhlapiSetTo(const Base: Pointer; const S: String);
procedure skmhlapiSetSubject(const Base: Pointer; const S: String);
procedure skmhlapiSetFromAddress(const Base: Pointer; var Address: TAddress; const FreshMSGID: Boolean);

procedure skmhlapiSetToAddress(const Base: Pointer; var Address: TAddress);
procedure skmhlapiSetFromAndToAddress(const Base: Pointer; var FromAddress, ToAddress: TAddress; const FreshMSGID: Boolean);
procedure skmhlapiGetStringPChar(const Base: Pointer; Line: PChar; MaxLen: Integer);
procedure skmhlapiGetString(const Base: Pointer; var Line: String);
procedure skmhlapiPutStringPChar(const Base: Pointer; Line: PChar);
procedure skmhlapiPutString(const Base: Pointer; const Line: String);
function skmhlapiEndOfMessage(const Base: Pointer): Boolean;
procedure skmhlapiSetTextPos(const Base: Pointer; Position: Longint);
function skmhlapiGetTextPos(const Base: Pointer): Longint;
function skmhlapiGetTextSize(const Base: Pointer): Longint;
procedure skmhlapiTruncateText(const Base: Pointer);
procedure skmhlapiReadText(const Base: Pointer; var Buf; Count: Word);
procedure skmhlapiWriteText(const Base: Pointer; var Buf; Count: Word);
function skmhlapiGetAttribute(const Base: Pointer; Attribute: Longint): Boolean;
procedure skmhlapiSetAttribute(const Base: Pointer; Attribute: Longint; Enable: Boolean);
procedure skmhlapiGetWrittenDateTime(const Base: Pointer; var DateTime: TMessageBaseDateTime);

procedure skmhlapiGetArrivedDateTime(const Base: Pointer; var DateTime: TMessageBaseDateTime);

procedure skmhlapiSetWrittenDateTime(const Base: Pointer; var DateTime: TMessageBaseDateTime);

procedure skmhlapiSetArrivedDateTime(const Base: Pointer; var DateTime: TMessageBaseDateTime);

function skmhlapiWriteMessage(const Base: Pointer): Boolean;
function skmhlapiWriteMessageHeader(const Base: Pointer): Boolean;
function skmhlapiGetKludgePChar(const Base: Pointer; const Name, Destination: PChar; const MaxLen: Integer): Boolean;

function skmhlapiGetKludge(const Base: Pointer; const Name: String; var Destination: String): Boolean;

procedure skmhlapiSetKludgePChar(const Base: Pointer; const Name, Value: PChar);
procedure skmhlapiSetKludge(const Base: Pointer; const Name, Value: String);
procedure skmhlapiDeleteKludgePChar(const Base: Pointer; const Name: PChar);
procedure skmhlapiDeleteKludge(const Base: Pointer; const Name: String);
procedure skmhlapiAddKludgePChar(const Base: Pointer; const Value: PChar);
procedure skmhlapiAddKludge(const Base: Pointer; const Value: String);
function skmhlapiGetMessageTextStream(const Base: Pointer): PMessageBaseStream;
procedure skmhlapiSetFlag(const Base: Pointer; const Flag: Longint; const Enable: Boolean);

function skmhlapiGetFlag(const Base: Pointer; const Flag: Longint): Boolean;
procedure skmhlapiCheckFromAddress(const Base: Pointer; const S: String; var Address: TAddress);

procedure skmhlapiCheckToAddress(const Base: Pointer; const S: String; var Address: TAddress);

function skmhlapiCreateNewMessage(const Base: Pointer): Boolean;
function skmhlapiKillMessage(const Base: Pointer): Boolean;
function skmhlapiGetLastRead(const Base: Pointer; const UserNumber: Longint): Longint;
procedure skmhlapiSetLastRead(const Base: Pointer; const UserNumber: Longint; const Value: Longint);

procedure skmhlapiResetDateTime(const Base: Pointer);
procedure skmhlapiSetBaseType(const Base: Pointer; const BaseType: TBaseType);
procedure skmhlapiPutOrigin(const Base: Pointer; Address: TAddress; const Text: String);
function skmhlapiAfterLastKludge(const Base: Pointer): Longint;
procedure skmhlapiSetMessageTextStream(const Base: Pointer; const AMessageText: PMessageBaseStream);

procedure skmhlapiSetStatus(const Base: Pointer; const AStatus: Longint);
function skmhlapiGetStatus(const Base: Pointer): Longint;
procedure skmhlapiSetOpened(const Base: Pointer; const AOpened: Boolean);
function skmhlapiGetOpened(const Base: Pointer): Boolean;
procedure skmhlapiSetCurrent(const Base: Pointer; const ACurrentMessage: Longint);
procedure skmhlapiSetBasePath(const Base: Pointer; const ABasePath: String);
function skmhlapiGetBasePath(const Base: Pointer): String;
function skmhlapiGetRead(const Base: Pointer): Boolean;
procedure skmhlapiSetRead(const Base: Pointer; const Value: Boolean);
function skmhlapiKludgeStart(const Base: Pointer): Longint;
function skmhlapiKludgeEnd(const Base: Pointer): Longint;
procedure skmhlapiGetAttributesLine(const Base: Pointer; var S: String);
procedure skmhlapiGetDateTimeLine(var DT: TMessageBaseDateTime; var S: String);
function skmhlapiVersion: String;
function skmhlapiTitle: String;
function skmhlapiFullTitle: String;
function skmhlapifidoGetAFLAG(const Base: Pointer; const Flag: String): Boolean;
procedure skmhlapifidoSetAFLAG(const Base: Pointer; const Flag: String; const Enable: Boolean);

procedure skmhlapifidoSetReplyTo(const Base: Pointer; const ReplyTo: Longint);
function skmhlapifidoGetReplyTo(const Base: Pointer): Longint;
procedure skmhlapifidoSetReplyNext(const Base: Pointer; const ReplyNext: Longint);
function skmhlapifidoGetReplyNext(const Base: Pointer): Longint;
procedure skmhlapifidoGetHeader(const Base: Pointer; var AHeader: TFidoHeader);
function skmhlapijamGetReplyTo(const Base: Pointer): LongInt;
function skmhlapijamGetReplyFirst(const Base: Pointer): LongInt;
function skmhlapijamGetReplyNext(const Base: Pointer): LongInt;
procedure skmhlapijamSetReplyTo(const Base: Pointer; const AReplyTo: LongInt);
procedure skmhlapijamSetReplyFirst(const Base: Pointer; const AReplyFirst: LongInt);
procedure skmhlapijamSetReplyNext(const Base: Pointer; const AReplyNext: LongInt);
procedure skmhlapijamGetMessageHeader(const Base: Pointer; var AHeader: TJamMessageHeaderFirst);

procedure skmhlapijamGetStreams(const Base: Pointer; var AHeaderLink, AIndexLink, ADataLink: PMessageBaseStream);

procedure skmhlapisquishGetReplies(const Base: Pointer; var Replies: TSquishMessageReplies);

procedure skmhlapisquishSetReplies(const Base: Pointer; var Replies: TSquishMessageReplies);

function skmhlapisquishGetReplyTo(const Base: Pointer): Longint;
procedure skmhlapisquishSetReplyTo(const Base: Pointer; const AReplyTo: Longint);
procedure skmhlapisquishGetMessageHeader(const Base: Pointer; var AHeader: TSquishMessageHeader);

procedure skmhlapisquishGetBaseHeader(const Base: Pointer; var AHeader: TSquishBaseHeader);

procedure skmhlapisquishGetStreams(const Base: Pointer; var ADataLink, AIndexLink: PMessageBaseStream);

function skmhlapisquishGetHighWater(const Base: Pointer): Longint;
procedure skmhlapisquishSetHighWater(const Base: Pointer; const AHighWater: Longint);
procedure skmhlapisquishSeekHighWater(const Base: Pointer);
function skmhlapiCreateFidoMessageBase: Pointer;
function skmhlapiCreateJamMessageBase: Pointer;
function skmhlapiCreateSquishMessageBase: Pointer;
function skmhlapiCreateMessageBase: Pointer;
procedure skmhlapiDestroyMessageBase(const Base: Pointer);
procedure skmhlapiSplitID(const ID: String; var Format: TMessageBaseFormat; var Path: String);

function skmhlapiOpenMessageBaseEx(var Base: Pointer; const ID: String; const Create: Boolean; Attempts: Longint): Boolean;
function skmhlapiOpenMessageBase(var Base: Pointer; const ID: String): Boolean;
function skmhlapiOpenOrCreateMessageBase(var Base: Pointer; const ID: String): Boolean;
function skmhlapiCloseMessageBase(var Base: Pointer): Boolean;
function skmhlapiExistMessageBase(const ID: String): Boolean;
function skmhlapiInitMessageBase(var Base: Pointer; const ID: String): Boolean;
function skmhlapiDoneMessageBase(var Base: Pointer): Boolean;
function skmhlapiGetOpenStatus: Longint;
procedure skmhlapiDistinguishBaseFormat(Base: Pointer; var Format: TMessageBaseFormat);
function skmhlapiGatewayTV(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;

function skmhlapiGatewayMHL(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;


implementation

{$IFNDEF DPMI}
const
 skMHLdll = {$IFDEF WIN32}'skMHLw32.dll' {$ENDIF}
            {$IFDEF OS2}  'skMHLos2.dll'  {$ENDIF};
{$ENDIF}

procedure skmhlapiInit; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetRegisterFileHandlers; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiClearRegisterFileHandlers; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiOpen; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiCreate; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiExist; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiClose; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiExists; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiCurrent; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSeek; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSeekNext; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSeekPrev; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiSeekFound; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetLocation; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetLocation; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiOpenMessage; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiOpenMessageHeader; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiCloseMessage; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetHighest; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetCount; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetFrom; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetTo; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetSubject; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiGetFromAddress; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiGetToAddress; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiGetFromAndToAddress; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetFrom; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetTo; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetSubject; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetFromAddress; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetToAddress; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetFromAndToAddress; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiGetStringPChar; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiGetString; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiPutStringPChar; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiPutString; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiEndOfMessage; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetTextPos; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetTextPos; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetTextSize; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiTruncateText; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiReadText; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiWriteText; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetAttribute; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetAttribute; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiGetWrittenDateTime; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiGetArrivedDateTime; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetWrittenDateTime; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetArrivedDateTime; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiWriteMessage; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiWriteMessageHeader; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetKludgePChar; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetKludge; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetKludgePChar; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetKludge; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiDeleteKludgePChar; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiDeleteKludge; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiAddKludgePChar; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiAddKludge; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetMessageTextStream; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetFlag; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetFlag; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiCheckFromAddress; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiCheckToAddress; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiCreateNewMessage; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiKillMessage; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetLastRead; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetLastRead; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiResetDateTime; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetBaseType; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiPutOrigin; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiAfterLastKludge; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetMessageTextStream; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetStatus; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetStatus; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetOpened; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetOpened; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetCurrent; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetBasePath; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetBasePath; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetRead; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSetRead; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiKludgeStart; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiKludgeEnd; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiGetAttributesLine; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiGetDateTimeLine; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiVersion; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiTitle; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiFullTitle; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapifidoGetAFLAG; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapifidoSetAFLAG; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapifidoSetReplyTo; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapifidoGetReplyTo; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapifidoSetReplyNext; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapifidoGetReplyNext; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapifidoGetHeader; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapijamGetReplyTo; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapijamGetReplyFirst; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapijamGetReplyNext; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapijamSetReplyTo; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapijamSetReplyFirst; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapijamSetReplyNext; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapijamGetMessageHeader; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapijamGetStreams; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapisquishGetReplies; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapisquishSetReplies; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapisquishGetReplyTo; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapisquishSetReplyTo; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapisquishGetMessageHeader; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapisquishGetBaseHeader; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapisquishGetStreams; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapisquishGetHighWater; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapisquishSetHighWater; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapisquishSeekHighWater; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiCreateFidoMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiCreateJamMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiCreateSquishMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiCreateMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiDestroyMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiSplitID; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiOpenMessageBaseEx; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiOpenMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiOpenOrCreateMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiCloseMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiExistMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiInitMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiDoneMessageBase; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGetOpenStatus; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
procedure skmhlapiDistinguishBaseFormat; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGatewayTV; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};
function skmhlapiGatewayMHL; external {$IFDEF DPMI} 'skMHLapi' {$ELSE} skMHLdll {$ENDIF};

end.
