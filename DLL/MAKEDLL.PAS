uses Drivers,
     Objects,
     Wizard;

const
 skMHLapi = 'skMHLapi.pas';
 skMHLapiINC = 'skMHLapi.inc';
 skMHLapiAPI = '..\V\skMHLapi.pas';

var
 OCP: Char;
 F, API: Text;
 Line, K: Longint;
 GoinExport: TCollection;
 S, Token, CFName: String;

procedure Warning(const S: String);
 begin
  PrintStr(CFName + '(' + Long2Str(Line) + '): ' + S + #13#10);
 end;

begin
 InitVideo;
 DoneVideo;

 CFName:=skMHLapi;

 Assign(F, CFName);
 Reset(F);

 Assign(API, skMHLapiAPI);
 Rewrite(API);

 WriteLn(API, '{&CDecl-,OrgName+}');
 WriteLn(API, 'unit skMHLapi;');

 WriteLn(API);

 WriteLn(API, 'interface');

 WriteLn(API, 'uses');
 WriteLn(API, '     skCommon;');

 WriteLn(API);

 GoinExport.Init($10, $10);

 Line:=0;

 Warning('scanning');

 while not Eof(F) do
  begin
   ReadLn(F, S);

   Inc(Line);

   TrimEx(S);

   if S = '' then
    Continue;

   Token:=ExtractWord(1, S, [' ']);

   if Token = 'function' then
    OCP:='f'
   else
    OCP:='p';

   if (Token = 'function') or (Token = 'procedure') then
    begin
     Token:='';

     if ExtractWord(WordCount(S, [' ']), S, [' ']) <> 'export;' then
      begin
       ReadLn(F, Token);

       Inc(Line);

       TrimEx(Token);

       if Pos('export;', Token) = 0 then
        begin
         Warning('unexported ' + ExtractWord(2, S, [' ', '(', ':', ';']));

         Continue;
        end;
      end;

     Write(API, Trim(Replace(S, 'export;', '')));

     if Token = '' then
      begin
       if Length(Trim(Replace(S, 'export;', ''))) > 90 then
        WriteLn(API);

       WriteLn(API);
(*
       WriteLn(API, ' {$IFDEF DELPHI}pascal;{$ENDIF}');
*)
      end
     else
      WriteLn(API);

     Token:=Trim(Replace(Token, 'export;', ''));

     if Token <> '' then
      WriteLn(API, Token);
(*
     if Token <> '' then
      WriteLn(API, Token, ' {$IFDEF DELPHI}pascal;{$ENDIF}');
*)
     Token:=ExtractWord(2, S, [' ', '(', ':', ';']);

     if Token = '' then
      begin
       Warning('empty procedurename, stopped');

       Halt(255);
      end;

     GoinExport.Insert(NewStr(OCP + Token));
    end;
  end;

 Warning('finished: ' + Long2StrFmt(GoinExport.Count) + ' exportable procedures/functions');

 Close(F);

 CFName:=skMHLapiINC;

 Assign(F, CFName);
 Rewrite(F);

 Line:=0;

 Warning('creating export table');

 WriteLn(F, 'exports');

 WriteLn(API);

 WriteLn(API, 'implementation');

 WriteLn(API);

 WriteLn(API, '{$IFNDEF DPMI}');
 WriteLn(API, 'const');
 WriteLn(API, ' skMHLdll = {$IFDEF WIN32}''skMHLw32.dll'' {$ENDIF}');
 WriteLn(API, '            {$IFDEF OS2}  ''skMHLos2.dll''  {$ENDIF};');
 WriteLn(API, '{$ENDIF}');

 WriteLn(API);

 Inc(Line);

 for K:=0 to GoinExport.Count - 1 do
  begin
   GetPStringEx(GoinExport.At(K), S);

   OCP:=S[1];

   Delete(S, 1, 1);

   Write(F, ' ', S);

   if K = GoinExport.Count - 1 then
    WriteLn(F, ';')
   else
    WriteLn(F, ',');

   case OCP of
    'f': Write(API, 'function ');
    'p': Write(API, 'procedure ');
   end;

   WriteLn(API, S, '; external {$IFDEF DPMI} ''skMHLapi'' {$ELSE} skMHLdll {$ENDIF};');

   Inc(Line);
  end;

 WriteLn(API);

 WriteLn(API, 'end.');

 Close(F);
 Close(API);
end.
