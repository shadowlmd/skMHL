unit skMHLjam;

interface
uses
     skMHL,
     skCommon,

     skMHLapi;

type
 PJamMessageBase = ^TJamMessageBase;
 TJamMessageBase = object(TMessageBase)
  function GetReplyTo: LongInt; virtual;
  function GetReplyFirst: LongInt; virtual;
  function GetReplyNext: LongInt; virtual;
  procedure SetReplyTo(const AReplyTo: LongInt); virtual;
  procedure SetReplyFirst(const AReplyFirst: LongInt); virtual;
  procedure SetReplyNext(const AReplyNext: LongInt); virtual;
  procedure GetMessageHeader(var AHeader: TJamMessageHeaderFirst); virtual;
  procedure GetStreams(var AHeaderLink, AIndexLink, ADataLink: PMessageBaseStream); virtual;
 end;

implementation

{ TJamMessageBase }

function TJamMessageBase.GetReplyTo: LongInt;
 begin
  GetReplyTo:=skmhlapijamGetReplyTo(Link);
 end;

function TJamMessageBase.GetReplyFirst: LongInt;
 begin
  GetReplyFirst:=skmhlapijamGetReplyFirst(Link);
 end;

function TJamMessageBase.GetReplyNext: LongInt;
 begin
  GetReplyNext:=skmhlapijamGetReplyNext(Link);
 end;

procedure TJamMessageBase.SetReplyTo(const AReplyTo: LongInt);
 begin
  skmhlapijamSetReplyTo(Link, AReplyTo);
 end;

procedure TJamMessageBase.SetReplyFirst(const AReplyFirst: LongInt);
 begin
  skmhlapijamSetReplyFirst(Link, AReplyFirst);
 end;

procedure TJamMessageBase.SetReplyNext(const AReplyNext: LongInt);
 begin
  skmhlapijamSetReplyNext(Link, AReplyNext);
 end;

procedure TJamMessageBase.GetMessageHeader(var AHeader: TJamMessageHeaderFirst);
 begin
  skmhlapijamGetMessageHeader(Link, AHeader);
 end;

procedure TJamMessageBase.GetStreams(var AHeaderLink, AIndexLink, ADataLink: PMessageBaseStream);
 begin
  skmhlapijamGetStreams(Link, AHeaderLink, AIndexLink, ADataLink);
 end;

end.