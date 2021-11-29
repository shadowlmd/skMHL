{ Delphi objects code }

{ TMessageBaseFileStream }

constructor TMessageBaseFileStream.Init(const AFileName: String; const AMode: Longint);
 var
  BMode, L: Longint;
  S: String;
 begin
  inherited Init(AFileName, AMode);

  if AMode and $FF = smCreate then
   Handle:=FileCreate(AFileName)
  else
   begin
    case AMode and $FF of
     smOpen: BMode:=fmOpenReadWrite;
     smOpenRead: BMode:=fmOpenRead;
     smOpenWrite: BMode:=fmOpenWrite;
    end;

    case Mode and $FF00 of
     smDenyAll: BMode:=BMode or fmShareExclusive;
     smDenyWrite: BMode:=BMode or fmShareDenyWrite;
     smDenyRead: BMode:=BMode or fmShareDenyRead;
     smDenyNone: BMode:=BMode or fmShareDenyNone;
    end;

    Handle:=FileOpen(AFileName, BMode);
   end;

  L:=GetLastError;
  S:=SysErrorMessage(L);

  if Handle < 0 then
   Status:=Handle
  else
   Status:=smOk;
 end;

destructor TMessageBaseFileStream.Done;
 begin
  FileClose(Handle);

  inherited Done;
 end;

procedure TMessageBaseFileStream.Read(var Buf; Count: Longint);
 begin
  if FileRead(Handle, Buf, Count) = -1 then
   Status:=GetLastError
  else
   Status:=smOk;
 end;

procedure TMessageBaseFileStream.Write(var Buf; Count: Longint);
 begin
  if FileWrite(Handle, Buf, Count) = -1 then
   Status:=GetLastError
  else
   Status:=smOk;
 end;

procedure TMessageBaseFileStream.Seek(Position: Longint);
 begin
  if FileSeek(Handle, Position, 0) = -1 then
   Status:=GetLastError
  else
   Status:=smOk;
 end;

function TMessageBaseFileStream.GetPos: Longint;
 begin
  GetPos:=FileSeek(Handle, 0, 1);
 end;

function TMessageBaseFileStream.GetSize: Longint;
 var
  OldPos: Longint;
 begin
  OldPos:=GetPos;

  GetSize:=FileSeek(Handle, 0, 2);

  Seek(OldPos);
 end;

procedure TMessageBaseFileStream.Flush;
 begin
 end;

procedure TMessageBaseFileStream.Truncate;
 begin
  SetEndOfFile(Handle);
 end;

procedure TMessageBaseFileStream.Reset;
 begin
  Status:=smOk;
 end;

{ TMessageBaseFileFind }

function TMessageBaseFileFind.StartSearch(const Mask: String; Attributes: Longint): Boolean;
 begin
  StartSearch:=SysUtils.FindFirst(Mask, Attributes, SR) = 0;

  Fresh;
 end;

function TMessageBaseFileFind.NextSearch: Boolean;
 begin
  NextSearch:=FindNext(SR) = 0;

  Fresh;
 end;

procedure TMessageBaseFileFind.StopSearch;
 begin
  FindClose(SR);
 end;

procedure TMessageBaseFileFind.Fresh;
 begin
  iName:=SR.Name;
  iAttributes:=SR.Attr;
  iTime:=SR.Time;
  iSize:=SR.Size;
 end;

{ TMessageBaseRamStream }

constructor TMessageBaseRamStream.Init;
 begin
  inherited Init('', 0);

  Buffer:=nil;
  BufferSize:=0;

  StreamSize:=0;
  StreamPos:=0;
 end;

destructor TMessageBaseRamStream.Done;
 begin
  if BufferSize <> 0 then
   FreeMem(Buffer, BufferSize);

  inherited Done;
 end;

function TMessageBaseRamStream.GetPos: Longint;
 begin
  GetPos:=StreamPos;
 end;

function TMessageBaseRamStream.GetSize: Longint;
 begin
  GetSize:=StreamSize;
 end;

procedure TMessageBaseRamStream.Read(var Buf; Count: Longint);
 begin
  if StreamPos + Count > StreamSize then
   begin
    FillChar(Buf, Count, 0);

    Count:=StreamSize - StreamPos;
   end;

  Move(Buffer[StreamPos], Buf, Count);

  Inc(StreamPos, Count);
 end;

procedure TMessageBaseRamStream.Seek(Pos: Longint);
 begin
  StreamPos:=Pos;
 end;

procedure TMessageBaseRamStream.Truncate;
 begin
  StreamSize:=StreamPos;
 end;

procedure TMessageBaseRamStream.Write(var Buf; Count: Longint);
 begin
  if StreamPos + Count > BufferSize then
   begin
    BufferSize:=StreamPos + Count;

    ReallocMem(Buffer, BufferSize);
   end;

  Move(Buf, Buffer[StreamPos], Count);

  Inc(StreamPos, Count);

  if StreamPos > StreamSize then
   StreamSize:=StreamPos;
 end;

procedure TMessageBaseRamStream.CopyFrom(var S: TMessageBaseStream; Count: Longint);
 begin
  if StreamPos + Count > BufferSize then
   begin
    BufferSize:=StreamPos + Count;

    ReallocMem(Buffer, BufferSize);
   end;

  inherited CopyFrom(S, Count);
 end;

procedure TMessageBaseRamStream.Flush;
 begin
 end;

{ wrappers }

function CreateMessageBaseFileStream(const FileName: String; Mode: Longint): PMessageBaseStream;
 begin
  CreateMessageBaseFileStream:=New(PMessageBaseFileStream, Init(FileName, Mode));
 end;

function CreateMessageBaseMemoryStream(Maximum: Longint): PMessageBaseStream;
 begin
  CreateMessageBaseMemoryStream:=New(PMessageBaseRamStream, Init);
 end;

function CreateMessageBaseFind: PMessageBaseFind;
 begin
  CreateMessageBaseFind:=New(PMessageBaseFileFind, Init);
 end;
