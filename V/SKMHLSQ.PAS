unit skMHLsq;

interface
uses
     skMHL,
     skCommon,

     skMHLapi;

type
 PSquishMessageBase = ^TSquishMessageBase;
 TSquishMessageBase = object(TMessageBase)
  procedure GetReplies(var Replies: TSquishMessageReplies); virtual;
  procedure SetReplies(var Replies: TSquishMessageReplies); virtual;
  function GetReplyTo: Longint; virtual;
  procedure SetReplyTo(const AReplyTo: Longint); virtual;
  procedure GetMessageHeader(var AHeader: TSquishMessageHeader); virtual;
  procedure GetBaseHeader(var AHeader: TSquishBaseHeader); virtual;
  procedure GetStreams(var ADataLink, AIndexLink: PMessageBaseStream); virtual;
  function GetHighWater: Longint; virtual;
  procedure SetHighWater(const AHighWater: Longint); virtual;
  procedure SeekHighWater; virtual;
 end;

implementation

{ TSquishMessageBase }

procedure TSquishMessageBase.GetReplies(var Replies: TSquishMessageReplies);
 begin
  skmhlapisquishGetReplies(Link, Replies);
 end;

procedure TSquishMessageBase.SetReplies(var Replies: TSquishMessageReplies);
 begin
  skmhlapisquishSetReplies(Link, Replies);
 end;

function TSquishMessageBase.GetReplyTo: Longint;
 begin
  GetReplyTo:=skmhlapisquishGetReplyTo(Link);
 end;

procedure TSquishMessageBase.SetReplyTo(const AReplyTo: Longint);
 begin
  skmhlapisquishSetReplyTo(Link, AReplyTo);
 end;

procedure TSquishMessageBase.GetMessageHeader(var AHeader: TSquishMessageHeader);
 begin
  skmhlapisquishGetMessageHeader(Link, AHeader);
 end;

procedure TSquishMessageBase.GetBaseHeader(var AHeader: TSquishBaseHeader);
 begin
  skmhlapisquishGetBaseHeader(Link, AHeader);
 end;

procedure TSquishMessageBase.GetStreams(var ADataLink, AIndexLink: PMessageBaseStream);
 begin
  skmhlapisquishGetStreams(Link, ADataLink, AIndexLink);
 end;

function TSquishMessageBase.GetHighWater: Longint;
 begin
  GetHighWater:=skmhlapisquishGetHighWater(Link);
 end;

procedure TSquishMessageBase.SetHighWater(const AHighWater: Longint);
 begin
  skmhlapisquishSetHighWater(Link, AHighWater);
 end;

procedure TSquishMessageBase.SeekHighWater;
 begin
  skmhlapisquishSeekHighWater(Link);
 end;

end.