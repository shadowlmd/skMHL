unit skMHLmsg;

interface
uses
     skMHL,
     skCommon,

     skMHLapi;

type
 PFidoMessageBase = ^TFidoMessageBase;
 TFidoMessageBase = object(TMessageBase)
  function GetAFLAG(const Flag: String): Boolean; virtual;
  procedure SetAFLAG(const Flag: String; const Enable: Boolean); virtual;
  procedure SetReplyTo(const ReplyTo: Longint); virtual;
  function GetReplyTo: Longint; virtual;
  procedure SetReplyNext(const ReplyNext: Longint); virtual;
  function GetReplyNext: Longint; virtual;
  procedure GetHeader(var AHeader: TFidoHeader); virtual;
 end;

implementation

{ TFidoMessageBase }

function TFidoMessageBase.GetAFLAG(const Flag: String): Boolean;
 begin
  GetAFLAG:=skmhlapifidoGetAFLAG(Link, Flag);
 end;

procedure TFidoMessageBase.SetAFLAG(const Flag: String; const Enable: Boolean);
 begin
  skmhlapifidoSetAFLAG(Link, Flag, Enable);
 end;

procedure TFidoMessageBase.SetReplyTo(const ReplyTo: Longint);
 begin
  skmhlapifidoSetReplyTo(Link, ReplyTo);
 end;

function TFidoMessageBase.GetReplyTo: Longint;
 begin
  GetReplyTo:=skmhlapifidoGetReplyTo(Link);
 end;

procedure TFidoMessageBase.SetReplyNext(const ReplyNext: Longint);
 begin
  skmhlapifidoSetReplyNext(Link, ReplyNext);
 end;

function TFidoMessageBase.GetReplyNext: Longint;
 begin
  GetReplyNext:=skmhlapifidoGetReplyNext(Link);
 end;

procedure TFidoMessageBase.GetHeader(var AHeader: TFidoHeader);
 begin
  skmhlapifidoGetHeader(Link, AHeader);
 end;

end.