unit skMHLvmb;

interface
uses
{$IFNDEF DELPHI}
     Objects,
{$ENDIF}

     skMHL,
     skCommon;

{
 this unit is intented to work with text which may contain
 lines larger than 255 characters. it supports TV & MHL streams
 and full string-features of skMHL.

 dedicated to Tatyana Medvedeva, 2:6033/28@fidonet, "ice-lock npd2000".
}

const
 CopyFromBufferSize     = 4096;

type
 {$IFNDEF DELPHI}
 PVirtualMessageBase = ^TVirtualMessageBase;
 TVirtualMessageBase = object(TMessageBase)
  constructor Init(const AStream: PStream);
  destructor Done; virtual;
 end;
 {$ENDIF}

 PVirtualMessageBaseMHL = ^TVirtualMessageBaseMHL;
 TVirtualMessageBaseMHL = object(TMessageBase)
  constructor Init(const AStream: PMessageBaseStream);
  destructor Done; virtual;
 end;

 {$IFNDEF DELPHI}
 PVirtualStreamLinker = ^TVirtualStreamLinker;
 TVirtualStreamLinker = object(TMessageBaseStream)
  Stream: PStream;

  constructor Init(const AStream: PStream);

  procedure Read(var Buf; Count: Word); virtual;
  procedure Write(var Buf; Count: Word); virtual;
  procedure Seek(Position: Longint); virtual;
  function GetPos: Longint; virtual;
  function GetSize: Longint; virtual;
  procedure Flush; virtual;
  procedure Truncate; virtual;
  procedure Reset; virtual;
 end;
 {$ENDIF}

{$IFNDEF DELPHI}
procedure CopyFromMHLStream(var Source: TMessageBaseStream; var Destination: TStream; Count: Longint);
procedure CopyFromTVStream(var Source: TStream; var Destination: TMessageBaseStream; Count: Longint);
{$ENDIF}

implementation

{ TVirtualMessageBase }

{$IFNDEF DELPHI}
constructor TVirtualMessageBase.Init(const AStream: PStream);
 begin
  inherited Init;

  SetMessageTextStream(New(PVirtualStreamLinker, Init(AStream)));
 end;

destructor TVirtualMessageBase.Done;
 begin
  SetMessageTextStream(nil);

  inherited Done;
 end;
{$ENDIF}

{ TVirtualMessageBaseMHL }

constructor TVirtualMessageBaseMHL.Init(const AStream: PMessageBaseStream);
 begin
  inherited Init;

  SetMessageTextStream(AStream);
 end;

destructor TVirtualMessageBaseMHL.Done;
 begin
  UnsetMessageTextStream;

  inherited Done;
 end;

{ TVirtualStreamLinker }

{$IFNDEF DELPHI}
constructor TVirtualStreamLinker.Init(const AStream: PStream);
 begin
  inherited Init('$LOCKNPD2000', smCreate);

  Stream:=AStream;
 end;

procedure TVirtualStreamLinker.Read(var Buf; Count: Word);
 begin
  Stream^.Read(Buf, Count);

  Status:=Stream^.Status;
 end;

procedure TVirtualStreamLinker.Write(var Buf; Count: Word);
 begin
  Stream^.Write(Buf, Count);

  Status:=Stream^.Status;
 end;

procedure TVirtualStreamLinker.Seek(Position: Longint);
 begin
  Stream^.Seek(Position);

  Status:=Stream^.Status;
 end;

function TVirtualStreamLinker.GetPos: Longint;
 begin
  GetPos:=Stream^.GetPos
 end;

function TVirtualStreamLinker.GetSize: Longint;
 begin
  GetSize:=Stream^.GetSize;
 end;

procedure TVirtualStreamLinker.Flush;
 begin
  Stream^.Flush;

  Status:=Stream^.Status;
 end;

procedure TVirtualStreamLinker.Truncate;
 begin
  Stream^.Truncate;

  Status:=Stream^.Status;
 end;

procedure TVirtualStreamLinker.Reset;
 begin
  Stream^.Reset;

  Status:=Stream^.Status;
 end;
{$ENDIF}

{ misc stuff }

{$IFNDEF DELPHI}
procedure CopyFromMHLStream(var Source: TMessageBaseStream; var Destination: TStream; Count: Longint);
 var
  N: Word;
  Buffer: array[0..CopyFromBufferSize] of Byte;
 begin
  while Count > 0 do
   begin
    if Count > SizeOf(Buffer) then
     N:=SizeOf(Buffer)
    else
     N:=Count;

    Source.Read(Buffer, N);
    Destination.Write(Buffer, N);

    Dec(Count, N);
   end;
 end;

procedure CopyFromTVStream(var Source: TStream; var Destination: TMessageBaseStream; Count: Longint);
 var
  N: Word;
  Buffer: array[0..CopyFromBufferSize] of Byte;
 begin
  while Count > 0 do
   begin
    if Count > SizeOf(Buffer) then
     N:=SizeOf(Buffer)
    else
     N:=Count;

    Source.Read(Buffer, N);
    Destination.Write(Buffer, N);

    Dec(Count, N);
   end;
 end;
{$ENDIF}

end.
