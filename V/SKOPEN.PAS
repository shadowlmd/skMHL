unit skOpen;

interface
uses
     skCommon,

     skMHL,
     skMHLmsg,
     skMHLjam,
     skMHLsq,

     skMHLapi;

var
 OpenStatus: Longint;

type
 TMessageBaseOpenProcess = function(var Base: PMessageBase; const ID: String): Boolean;

procedure CreateBaseThunk(var Base: PMessageBase; const ID: String);

procedure SplitID(const ID: String; var Format: TMessageBaseFormat; var Path: String);

function OpenMessageBaseEx(var Base: PMessageBase; const ID: String; const Process: TMessageBaseOpenProcess;
 Attempts: Longint): Boolean;

function OpenMessageBase(var Base: PMessageBase; const ID: String): Boolean;
function OpenOrCreateMessageBase(var Base: PMessageBase; const ID: String): Boolean;
function CloseMessageBase(var Base: PMessageBase): Boolean;
function ExistMessageBase(const ID: String): Boolean;

function InitMessageBase(var Base: PMessageBase; const ID: String): Boolean;
function DoneMessageBase(var Base: PMessageBase): Boolean;

implementation

{ base thunk creator }

procedure CreateBaseThunk(var Base: PMessageBase; const ID: String);
 var
  Format: TMessageBaseFormat;
  Path: String;
 begin
  SplitID(ID, Format, Path);

  case Format of
   mbfMSG: Base:=New(PFidoMessageBase, Init(Base));
   mbfJam: Base:=New(PJamMessageBase, Init(Base));
   mbfSquish: Base:=New(PSquishMessageBase, Init(Base));
  else
   OpenStatus:=ombUnknownIDorUnsupported;

   skmhlapiDestroyMessageBase(Base);

   Base:=nil;
  end;
 end;

{ main stuff }

procedure SplitID(const ID: String; var Format: TMessageBaseFormat; var Path: String);
 begin
  skmhlapiSplitID(ID, Format, Path);
 end;

function OpenMessageBaseEx(var Base: PMessageBase; const ID: String; const Process: TMessageBaseOpenProcess;
 Attempts: Longint): Boolean;
 begin
  if skmhlapiOpenMessageBaseEx(Pointer(Base), ID, @Process = @OpenOrCreateMessageBase, Attempts) then
   begin
    OpenMessageBaseEx:=True;

    CreateBaseThunk(Base, ID);
   end
  else
   OpenMessageBaseEx:=False;

  OpenStatus:=skmhlapiGetOpenStatus;
 end;

function OpenMessageBase(var Base: PMessageBase; const ID: String): Boolean;
 begin
  if skmhlapiOpenMessageBase(Pointer(Base), ID) then
   begin
    OpenMessageBase:=True;

    CreateBaseThunk(Base, ID);
   end
  else
   OpenMessageBase:=False;

  OpenStatus:=skmhlapiGetOpenStatus;
 end;

function OpenOrCreateMessageBase(var Base: PMessageBase; const ID: String): Boolean;
 begin
  if skmhlapiOpenOrCreateMessageBase(Pointer(Base), ID) then
   begin
    OpenOrCreateMessageBase:=True;

    CreateBaseThunk(Base, ID);
   end
  else
   OpenOrCreateMessageBase:=False;

  OpenStatus:=skmhlapiGetOpenStatus;
 end;

function CloseMessageBase(var Base: PMessageBase): Boolean;
 begin
  if Base <> nil then
   begin
    Base^.Close;

    CloseMessageBase:=DoneMessageBase(Base);
   end
  else
   CloseMessageBase:=False;
 end;

function ExistMessageBase(const ID: String): Boolean;
 begin
  ExistMessageBase:=skmhlapiExistMessageBase(ID);

  OpenStatus:=skmhlapiGetOpenStatus;
 end;

function InitMessageBase(var Base: PMessageBase; const ID: String): Boolean;
 begin
  if skmhlapiInitMessageBase(Pointer(Base), ID) then
   begin
    InitMessageBase:=True;

    CreateBaseThunk(Base, ID);
   end
  else
   InitMessageBase:=False;

  OpenStatus:=skmhlapiGetOpenStatus;
 end;

function DoneMessageBase(var Base: PMessageBase): Boolean;
 begin
  Dispose(Base, Done);

  Base:=nil;

  DoneMessageBase:=True;
 end;

end.
