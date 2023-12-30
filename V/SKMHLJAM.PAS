unit skMHLjam;

interface
uses
     skMHL,
     skCommon,

     skMHLapi;

type
 PJamMessageBase = ^TJamMessageBase;
 TJamMessageBase = object(TMessageBase)
  function GetReplyTo: Longint; virtual;
  function GetReplyFirst: Longint; virtual;
  function GetReplyNext: Longint; virtual;
  procedure SetReplyTo(const AReplyTo: Longint); virtual;
  procedure SetReplyFirst(const AReplyFirst: Longint); virtual;
  procedure SetReplyNext(const AReplyNext: Longint); virtual;
  procedure GetMessageHeader(var AHeader: TJamMessageHeaderFirst); virtual;
  procedure GetStreams(var AHeaderLink, AIndexLink, ADataLink: PMessageBaseStream); virtual;
 end;

implementation

{ TJamMessageBase }

function TJamMessageBase.GetReplyTo: Longint;
 begin
  GetReplyTo:=skmhlapijamGetReplyTo(Link);
 end;

function TJamMessageBase.GetReplyFirst: Longint;
 begin
  GetReplyFirst:=skmhlapijamGetReplyFirst(Link);
 end;

function TJamMessageBase.GetReplyNext: Longint;
 begin
  GetReplyNext:=skmhlapijamGetReplyNext(Link);
 end;

procedure TJamMessageBase.SetReplyTo(const AReplyTo: Longint);
 begin
  skmhlapijamSetReplyTo(Link, AReplyTo);
 end;

procedure TJamMessageBase.SetReplyFirst(const AReplyFirst: Longint);
 begin
  skmhlapijamSetReplyFirst(Link, AReplyFirst);
 end;

procedure TJamMessageBase.SetReplyNext(const AReplyNext: Longint);
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