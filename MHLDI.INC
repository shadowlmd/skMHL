{ Delphi objects interface }

type
 PMessageBaseFileStream = ^TMessageBaseFileStream;
 TMessageBaseFileStream = object(TMessageBaseStream)
  Handle: Integer;

  constructor Init(const AFileName: String; const AMode: Longint);
  destructor Done; virtual;

  procedure Read(var Buf; Count: Word); virtual;
  procedure Write(var Buf; Count: Word); virtual;
  procedure Seek(Position: Longint); virtual;
  function GetPos: Longint; virtual;
  function GetSize: Longint; virtual;
  procedure Flush; virtual;
  procedure Truncate; virtual;
  procedure Reset; virtual;
 end;

 PMessageBaseFileFind = ^TMessageBaseFileFind;
 TMessageBaseFileFind = object(TMessageBaseFind)
  function StartSearch(const Mask: String; Attributes: Longint): Boolean; virtual;
  function NextSearch: Boolean; virtual;
  procedure StopSearch; virtual;
 private
  SR: TSearchRec;
  procedure Fresh;
 end;

 PMessageBaseRamStream = ^TMessageBaseRamStream;
 TMessageBaseRamStream = object(TMessageBaseStream)
  constructor Init;
  destructor Done; virtual;
  function GetPos: Longint; virtual;
  function GetSize: Longint; virtual;
  procedure Read(var Buf; Count: Word); virtual;
  procedure Seek(Pos: Longint); virtual;
  procedure Truncate; virtual;
  procedure Write(var Buf; Count: Word); virtual;
  procedure CopyFrom(var S: TMessageBaseStream; Count: Longint); virtual;
  procedure Flush; virtual;
 public
  Buffer: PChar;
  BufferSize: Longint;
  StreamSize: Longint;
  StreamPos: Longint;
 end;
