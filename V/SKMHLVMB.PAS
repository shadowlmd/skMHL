unit skMHLvmb;

interface
uses
     Objects,

     skMHL,
     skCommon,

     skMHLapi,

     GStream;

const
 CopyFromBufferSize     = 4096;

type
 PVirtualMessageBase = ^TVirtualMessageBase;
 TVirtualMessageBase = object(TMessageBase)
  constructor Init(const AStream: PStream);
  constructor InitMHL(const AStream: PMessageBaseStream);
  constructor InitDirect(const AStream: PMessageBaseStream);
  destructor Done; virtual;
 end;

implementation

{ TVirtualMessageBase }

constructor TVirtualMessageBase.Init(const AStream: PStream);
 begin
  inherited Init(skmhlapiCreateMessageBase);

  SetMessageTextStream(
    CreateRemoteMessageBaseStreamThunk(
      @skmhlapiGatewayMHL,
      AStream,
      @DefaultGatewayTV,
      False));
 end;

constructor TVirtualMessageBase.InitMHL(const AStream: PMessageBaseStream);
 begin
  inherited Init(skmhlapiCreateMessageBase);

  SetMessageTextStream(
    CreateRemoteMessageBaseStreamThunk(
      @skmhlapiGatewayMHL,
      AStream,
      @DefaultGatewayMHL,
      False));
 end;

constructor TVirtualMessageBase.InitDirect(const AStream: PMessageBaseStream);
 begin
  inherited Init(skmhlapiCreateMessageBase);

  SetMessageTextStream(AStream);
 end;

destructor TVirtualMessageBase.Done;
 begin
  SetMessageTextStream(nil);

  inherited Done;
 end;

end.
