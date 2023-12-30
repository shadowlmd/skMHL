unit skMHLapi;

interface
uses
     GStream,

     skComnTV;

function skmhlapiGatewayTV(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
function skmhlapiGatewayMHL(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;

procedure skmhlapiInit;

implementation

{ streams gateways }

function skmhlapiGatewayTV(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
 begin
  skmhlapiGatewayTV:=DefaultGatewayTV(Stream, fn, Data, l);
 end;

function skmhlapiGatewayMHL(const Stream: Pointer; const fn: Integer; const Data: Pointer; var l: Longint): Longint;
 begin
  skmhlapiGatewayMHL:=DefaultGatewayMHL(Stream, fn, Data, l);
 end;

{ skmhlapiInit thunk }

procedure skmhlapiInit;
 begin
  InstallMHLcommon;
 end;

end.
