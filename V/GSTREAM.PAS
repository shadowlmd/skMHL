unit GStream;

interface
uses
{$IFNDEF DELPHI}
     Objects,
{$ENDIF}

     skCommon,

     Wizard;

const
 gfnDestroy     = $0000;
 gfnFlush       = $0001;
 gfnGetPos      = $0002; { OUT: l = CurPos }
 gfnGetSize     = $0003; { OUT: l = CurSize }
 gfnRead        = $0004; { IN: Data = @Buf, l = Count }
 gfnReset       = $0005;
 gfnSeek        = $0006; { IN: l = Count }
 gfnTruncate    = $0007;
 gfnWrite       = $0008; { IN: Data = @Buf, l = Count }
 gfnTVThunk     = $0009; { IN: Stream = Stream, Data = Gateway,
                           OUT: Longint(CreatedThunk) }
 gfnMHLThunk    = $000A; { same stuff }
 gfnTVkill      = $000B;
 gfnMHLkill     = $000C;
 gfnQueryStatus = $000D;

 { only MHL streams }
 gfnQueryMode   = $0100; { l = Mode }
 gfnQueryFName  = $0101; { Pointer(l) = @FName }

type
 TStreamGateway = function(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;

 PStreamThunk = ^TStreamThunk;
{$IFDEF DELPHI}
 TStreamThunk = object
{$ELSE}
 TStreamThunk = object(TStream)
{$ENDIF}
  Gateway: Pointer;
  Stream: Pointer;
  Destroy: Boolean;

  constructor Init(const AStream: Pointer; const AGateway: Pointer; const ADestroy: Boolean);
  procedure Flush; virtual;
  function GetPos: Longint; virtual;
  function GetSize: Longint; virtual;
  procedure Read(var Buf; Count: xWord); virtual;
  procedure Reset; virtual;
  procedure Seek(Pos: Longint); virtual;
  procedure Truncate; virtual;
  procedure Write(var Buf; Count: xWord); virtual;
  destructor Done; virtual;
 private
  Junk: Longint;
 end;

 PMessageBaseStreamThunk = ^TMessageBaseStreamThunk;
 TMessageBaseStreamThunk = object(TMessageBaseStream)
  Gateway: Pointer;
  Stream: Pointer;
  Destroy: Boolean;

  constructor Init(const AStream: Pointer; const AGateway: Pointer; const ADestroy: Boolean);
  procedure Flush; virtual;
  function GetPos: Longint; virtual;
  function GetSize: Longint; virtual;
  procedure Read(var Buf; Count: xWord); virtual;
  procedure Reset; virtual;
  procedure Seek(Pos: Longint); virtual;
  procedure Truncate; virtual;
  procedure Write(var Buf; Count: xWord); virtual;
  destructor Done; virtual;
 private
  Junk: Longint;
 end;

const
 TVStreamFName: String[15] = 'TV stream thunk';

function DefaultGateway(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
function DefaultGatewayTV(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
{$IFNDEF MSDOS}export;{$ENDIF}
function DefaultGatewayMHL(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
{$IFNDEF MSDOS}export;{$ENDIF}

function CreateRemoteStreamThunk(const Remote: Pointer; const Stream: Pointer;
 const Gateway: Pointer; const Destroy: Boolean): PStreamThunk;
function CreateRemoteMessageBaseStreamThunk(const Remote: Pointer; const Stream: Pointer;
 const Gateway: Pointer; const Destroy: Boolean): PMessageBaseStreamThunk;
procedure DestroyRemoteStreamThunk(const Remote: Pointer; const Stream: Pointer);
procedure DestroyRemoteMessageBaseStreamThunk(const Remote: Pointer; const Stream: Pointer);

implementation

{ CallGateway }

function CallGateway(const Gateway: Pointer;
                     const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
 var
  Gate: TStreamGateway absolute Gateway;
 begin
  CallGateway:=Gate(Stream, fn, Data, l);
 end;

{ TStreamThunk }

constructor TStreamThunk.Init(const AStream: Pointer; const AGateway: Pointer; const ADestroy: Boolean);
 begin
  inherited Init;

  Stream:=AStream;
  Gateway:=AGateway;
  Destroy:=ADestroy;

  Status:=CallGateway(Gateway, Stream, gfnQueryStatus, nil, Junk);
 end;

procedure TStreamThunk.Flush;
 begin
  Status:=CallGateway(Gateway, Stream, gfnFlush, nil, Junk);
 end;

function TStreamThunk.GetPos: Longint;
 begin
  Status:=CallGateway(Gateway, Stream, gfnGetPos, nil, Junk);

  GetPos:=Junk;
 end;

function TStreamThunk.GetSize: Longint;
 begin
  Status:=CallGateway(Gateway, Stream, gfnGetSize, nil, Junk);

  GetSize:=Junk;
 end;

procedure TStreamThunk.Read(var Buf; Count: xWord);
 begin
  Junk:=Count;

  Status:=CallGateway(Gateway, Stream, gfnRead, @Buf, Junk);
 end;

procedure TStreamThunk.Reset;
 begin
  Status:=CallGateway(Gateway, Stream, gfnReset, nil, Junk);
 end;

procedure TStreamThunk.Seek(Pos: Longint);
 begin
  Status:=CallGateway(Gateway, Stream, gfnSeek, nil, Pos);
 end;

procedure TStreamThunk.Truncate;
 begin
  Status:=CallGateway(Gateway, Stream, gfnTruncate, nil, Junk);
 end;

procedure TStreamThunk.Write(var Buf; Count: xWord);
 begin
  Junk:=Count;

  Status:=CallGateway(Gateway, Stream, gfnWrite, @Buf, Junk);
 end;

destructor TStreamThunk.Done;
 begin
  if Destroy then
   CallGateway(Gateway, Stream, gfnDestroy, nil, Junk);

  inherited Done;
 end;

{ TMessageBaseStreamThunk }

constructor TMessageBaseStreamThunk.Init(const AStream: Pointer; const AGateway: Pointer; const ADestroy: Boolean);
 var
  AFName: PString;
 begin
  CallGateway(AGateway, AStream, gfnQueryFName, nil, Longint(AFName));

  inherited Init('GSTREAM!MBST-THUNK!Self:' + HexL(Longint(@Self)) +
                                   '!Stream:' + HexL(Longint(@AStream)) +
                                   '!Gateway:' + HexL(Longint(@AGateway)) +
                                   '!Destroy:' + HexB(Byte(ADestroy)) +
                                   '!FName:' + GetPString(AFName), $FFFF);

  Stream:=AStream;
  Gateway:=AGateway;
  Destroy:=ADestroy;

  Status:=CallGateway(Gateway, Stream, gfnQueryStatus, nil, Junk);

  CallGateway(Gateway, Stream, gfnQueryMode, nil, Mode);
 end;

procedure TMessageBaseStreamThunk.Flush;
 begin
  Status:=CallGateway(Gateway, Stream, gfnFlush, nil, Junk);
 end;

function TMessageBaseStreamThunk.GetPos: Longint;
 begin
  Status:=CallGateway(Gateway, Stream, gfnGetPos, nil, Junk);

  GetPos:=Junk;
 end;

function TMessageBaseStreamThunk.GetSize: Longint;
 begin
  Status:=CallGateway(Gateway, Stream, gfnGetSize, nil, Junk);

  GetSize:=Junk;
 end;

procedure TMessageBaseStreamThunk.Read(var Buf; Count: xWord);
 begin
  Junk:=Count;

  Status:=CallGateway(Gateway, Stream, gfnRead, @Buf, Junk);
 end;

procedure TMessageBaseStreamThunk.Reset;
 begin
  Status:=CallGateway(Gateway, Stream, gfnReset, nil, Junk);
 end;

procedure TMessageBaseStreamThunk.Seek(Pos: Longint);
 begin
  Status:=CallGateway(Gateway, Stream, gfnSeek, nil, Pos);
 end;

procedure TMessageBaseStreamThunk.Truncate;
 begin
  Status:=CallGateway(Gateway, Stream, gfnTruncate, nil, Junk);
 end;

procedure TMessageBaseStreamThunk.Write(var Buf; Count: xWord);
 begin
  Junk:=Count;

  Status:=CallGateway(Gateway, Stream, gfnWrite, @Buf, Junk);
 end;

destructor TMessageBaseStreamThunk.Done;
 begin
  if Destroy then
   CallGateway(Gateway, Stream, gfnDestroy, nil, Junk);

  inherited Done;
 end;

{ DefaultGateway }

function DefaultGateway(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
 begin
  case fn of
   gfnTVThunk: DefaultGateway:=Longint(New(PStreamThunk, Init(Stream, Data, l = 1)));
   gfnMHLThunk: DefaultGateway:=Longint(New(PMessageBaseStreamThunk, Init(Stream, Data, l = 1)));
   gfnTVkill: Dispose(PStreamThunk(Stream), Done);
   gfnMHLkill: Dispose(PMessageBaseStreamThunk(Stream), Done);
  end;
 end;

{ Default gateways }

function DefaultGatewayTV(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
 var
  S: PStream absolute Stream;
 begin
  case fn of
   gfnDestroy:
    begin
     Dispose(S, Done);

     Exit;
    end;
   gfnFlush: S^.Flush;
   gfnGetPos: l:=S^.GetPos;
   gfnGetSize: l:=S^.GetSize;
   gfnRead: S^.Read(Data^, l);
   gfnReset: S^.Reset;
   gfnSeek: S^.Seek(l);
   gfnTruncate: S^.Truncate;
   gfnWrite: S^.Write(Data^, l);
   gfnQueryMode: l:=$FFFF;
   gfnQueryFName: Pointer(l):=@TVStreamFName;
   gfnQueryStatus:;
  else
   DefaultGatewayTV:=DefaultGateway(Stream, fn, Data, l);

   Exit;
  end;

  DefaultGatewayTV:=S^.Status;
 end;

function DefaultGatewayMHL(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
 var
  S: PMessageBaseStream absolute Stream;
 begin
  case fn of
   gfnDestroy:
    begin
     Dispose(S, Done);

     Exit;
    end;
   gfnFlush: S^.Flush;
   gfnGetPos: l:=S^.GetPos;
   gfnGetSize: l:=S^.GetSize;
   gfnRead: S^.Read(Data^, l);
   gfnReset: S^.Reset;
   gfnSeek: S^.Seek(l);
   gfnTruncate: S^.Truncate;
   gfnWrite: S^.Write(Data^, l);
   gfnQueryMode: l:=S^.Mode;
   gfnQueryFName: Pointer(l):=@S^.FileName;
   gfnQueryStatus:;
  else
   DefaultGatewayMHL:=DefaultGateway(Stream, fn, Data, l);

   Exit;
  end;

  DefaultGatewayMHL:=S^.Status;
 end;

{ Remote thunks operators }

function CreateRemoteStreamThunk(const Remote: Pointer; const Stream: Pointer;
 const Gateway: Pointer; const Destroy: Boolean): PStreamThunk;
 var
  Junk: Longint;
 begin
  if Destroy then
   Junk:=1
  else
   Junk:=0;

  CreateRemoteStreamThunk:=PStreamThunk(CallGateway(Remote, Stream, gfnTVThunk, Gateway, Junk));
 end;

function CreateRemoteMessageBaseStreamThunk(const Remote: Pointer; const Stream: Pointer;
 const Gateway: Pointer; const Destroy: Boolean): PMessageBaseStreamThunk;
 var
  Junk: Longint;
 begin
  if Destroy then
   Junk:=1
  else
   Junk:=0;

  CreateRemoteMessageBaseStreamThunk:=PMessageBaseStreamThunk(CallGateway(Remote, Stream, gfnMHLThunk, Gateway, Junk));
 end;

procedure DestroyRemoteStreamThunk(const Remote: Pointer; const Stream: Pointer);
 var
  Junk: Longint;
 begin
  CallGateway(Remote, Stream, gfnTVkill, nil, Junk);
 end;

procedure DestroyRemoteMessageBaseStreamThunk(const Remote: Pointer; const Stream: Pointer);
 var
  Junk: Longint;
 begin
  CallGateway(Remote, Stream, gfnMHLkill, nil, Junk);
 end;

end.