Program CIA;

{$V-}{$C-}
{$I COMMON.PAS}

Var
  N1S       : Array [1..50] of Str;         { Object FULL Names }
  NS        : Array [1..50] of Str;         { Object SHORT Names }
  N         : Array [1..50] of Integer;     { Object Locations }
  VS        : Array [1..18] of Str;         { Commands }
  LOS       : Array [1..30] of Str;         { Room Names }
  LON       : Array [1..30,1..4] of Integer;{ Rooms You Can Go To }
  Infile    : Text;                         { Files To Load Arrays }
  Outfile   : Text;                         { File To Keep Hi Scores }
  Datafile  : Text;                         { File Of Active Players }
  Scorefile : Text;                         { File Of Top Agent Scores }
  Tempfile  : Text;                         { Temporary Text File }
  Agent     : Str;                          { Player's Agent Number }
  Alias     : Str;                          { Player's Alias }
  Name      : Str;                          { Player's Name }
  Score     : Integer;                      { Player's Score }
  BA,BU,CA  : Integer;                      { Battery, Button, Card }
  CI,DA     : Integer;                      { Carried Items, Door }
  DG,DR,DW  : Integer;                      { Drug Guard, Drug Coffee, Drawer }
  EL,FL,GL  : Integer;                      { Electricity, Floor, Gloves }
  GU,LO     : Integer;                      { Gun, Location }
  OH,PA,RO  : Integer;                      { Object Here, Painting, Rope }
  SC,TA,TE  : Integer;                      { Sculpture, Tape, TV }
  TU        : Integer;                      { Turns }
  X,Y,Z     : Integer;                      { General Purpose Counters }
  CO        : Str;                          { Combination }
  RS,SS,US  : Str;                          { Response, Short, Upper }
  R,S,U,V   : Str;                          { General Purpose String }
  XR        : Real;                         { General Purpose Real }

Procedure AFD; Forward;
Procedure MNM; Forward;
Procedure PTG; Forward;

Procedure LAA;                                 { Load All Arrays }
Begin
  Assign(Infile,'CHAINS\CIA.OBJ');
  Reset(Infile);
  For X:=1 to 50 Do
  Begin
    ReadLn(Infile,S);
    N1S[X]:=S;
    ReadLn(Infile,S);
    NS[X]:=S;
    ReadLn(Infile,Y);
    N[X]:=Y;
  End;
  Close(Infile);
  Assign(Infile,'CHAINS\CIA.CMD');
  Reset(Infile);
  For X:=1 to 18 Do
  Begin
    ReadLn(Infile,S);
    VS[X]:=S;
  End;
  Close(Infile);
  Assign(Infile,'CHAINS\CIA.LOC');
  Reset(Infile);
  For X:=1 to 30 Do
  Begin
    ReadLn(Infile,S);
    LOS[X]:=S;
    ReadLn(Infile,Z);
    LON[X,1]:=Z;
    ReadLn(Infile,Z);
    LON[X,2]:=Z;
    ReadLn(Infile,Z);
    LON[X,3]:=Z;
    ReadLn(Infile,Z);
    LON[X,4]:=Z;
  End;
  Close(Infile);
End;

Procedure SLC;                                 { <---- Select Lock Combination }
Begin
  CO:='';
  Randomize;
  For X:=1 To 5 Do
  Begin
    Y:=Round(Random(9)+1);
    CO:=CO+(Cstr(Y));
    If X<5 Then CO:=(CO+' ');
  End;
End;

Procedure SIP;                                 { <---- System Init. Procedure }
Begin
  LAA;
  SLC;
  FL:=1;
  DR:=0;
  DG:=-1;
  DW:=0;
  TU:=0;
  EL:=0;
  BU:=0;
  DA:=0;
  CA:=0;
  BA:=0;
  GU:=0;
  TE:=0;
  GL:=0;
  PA:=0;
  RO:=0;
  SC:=0;
  LO:=1;
  Score:=0;
End;

Procedure SSF;                                 { <---- Show Score File }
Begin
  Cls;
  Reset(Scorefile);
  Nl;
  Nl;
  Nl;
  Ansic(3);
  Print('   Agent                Alias                        Score');
  Ansic(7);
  Print('============================================================');
  Nl;
  Ansic(8);
  For X:=1 To 10 Do
  Begin
    ReadLn(Scorefile,R);
    ReadLn(Scorefile,S);
    ReadLn(Scorefile,Y);
    For Z:=1 To (40-Length(S)) Do
    S:=S+' ';
    U:='';
    For Z:=1 To (7-Length(Cstr(Y))) Do
    U:=' '+U;
    Print('    '+R+'    '+S+U+Cstr(Y));
    Ansic(4);
  End;
  Close(Scorefile);
  Nl;
  Print('Top Ten Agents So Far...');
  Nl;
  Nl;
  Nl;
  Pausescr;
End;

Procedure RSF;                                 { <---- ReWrite Score File }
Var
  M : Boolean;
Begin
  Reset(Scorefile);
  Assign(Tempfile,'CHAINS\CIA.TMP');
  ReWrite(Tempfile);
  M:=False;
  For X:=1 To 10 Do
  Begin
    ReadLn(Scorefile,R);
    ReadLn(Scorefile,S);
    ReadLn(Scorefile,Y);
    If (Score>Y) And (Not M) Then
    Begin
      M:=True;
      WriteLn(Tempfile,Agent);
      WriteLn(Tempfile,Alias);
      WriteLn(Tempfile,Score);
      If Agent<>R Then
      Begin
        WriteLn(Tempfile,R);
        WriteLn(Tempfile,S);
        WriteLn(Tempfile,Y);
        X:=X+1;
      End;
    End
    Else
    Begin
      If Agent<>R Then
      Begin
        WriteLn(Tempfile,R);
        WriteLn(Tempfile,S);
        WriteLn(Tempfile,Y);
      End
      Else X:=X-1;
    End;
  End;
  Close(Scorefile);
  Close(Tempfile);
  Erase(Scorefile);
  Rename(Tempfile,'CHAINS\CIA.SCR');
  SSF;
End;

Procedure CSF;                                 { <---- Check Score File }
Var
  Matched : Boolean;
  TopTen  : Boolean;
Begin
  Assign(Scorefile,'CHAINS\CIA.SCR');
  {$I-} Reset(Scorefile); {$I+}
  If IOResult<>0 Then
  Begin
    ReWrite(Scorefile);
    For X:=1 To 10 Do
    Begin
      WriteLn(Scorefile,'000');
      WriteLn(Scorefile,'--------------------');
      WriteLn(Scorefile,0);
    End;
    Close(Scorefile);
    Reset(Scorefile);
  End;
  Matched:=False;
  TopTen:=False;
  Repeat
    ReadLn(Scorefile,R);
    ReadLn(Scorefile,S);
    ReadLn(Scorefile,Y);
    If Agent=R Then Matched:=True;
    If Score>Y Then TopTen:=True;
  Until (TopTen) Or (Matched) Or EOF(Scorefile);
  Close(Scorefile);
  If (Not TopTen) Then SSF
  Else RSF;
End;

Procedure RTB;                                 { <---- Return To BBS }
Begin
  CSF;
  Nl;
  Ansic(7);
  Print('Returning to The PHONE BOOTHE!');
  Delay(1500);
  Cls;
  Return;
End;

Procedure LTG;                                 { <---- Lost This Game }
Begin
  Ansic(8);
  Print('  You are DEAD... ');
  Nl;
  Ansic(4);
  Print(' Come Back Later! ');
  Delay(500);
  RTB;
End;

Procedure HAW;                                 { <---- Hello And Welcome }
Begin
  CLS;
  PrintFile('CHAINS\CIA.WEL');
  Pausescr;
  Cls;
  PTG;
End;

Procedure PCL;                                 { <---- Print Current Location }
Begin
  NL;
  Nl;
  Ansic(3);
  Print('We Are '+LOS[LO]);
End;

Procedure FGD;                                 { <---- Find Good Direction }
Begin
  If (LON[LO,1]>0) or (LON[LO,2]>0) or (LON[LO,3]>0) or (LON[LO,4]>0) Then
  Begin
    Ansic(2);
    Prompt('We Could Easily Go');
    Ansic(1);
    If LON[LO,1]>0 Then Prompt(' North');
    If LON[LO,2]>0 Then Prompt(' South');
    If LON[LO,3]>0 Then Prompt(' East');
    If LON[LO,4]>0 Then Prompt(' West');
    Print('.');
  End;
  Ansic(5);
  Print('+--------------------------------------+');
End;

Procedure CWH;                                 { <---- Check What's Here }
Begin
  Y:=0;
  Ansic(7);
  Print('I Can See...');
  For X:=1 To 46 Do
  Begin
    If N[X]=LO Then
    Begin
      Ansic(4);
      Prompt('  ');
      Print(N1S[X]);
      Y:=1;
    End;
  End;
  If Y=0 Then
  Begin
    Ansic(4);
    Print('  NOTHING!');
  End;
  Nl;
End;

Procedure RTC;                                 { <---- Raise Turn Counter }
Begin
  TU:=TU+1;
  If DG>0 Then DG:=DG-1;
  If TU=1 Then
  Begin
    Ansic(7);
    Print('      Hello '+ThisUser.RealName);
    Ansic(7);
    Print(' Welcome back to the CIA.');
    Nl;
  End;
  Nl;
  XR:=Random(100);
  If XR>=98 Then Score:=Score-100 Else
  If XR>=93 Then Score:=Score-50  Else
  If XR>=70 Then Score:=Score+50  Else
  If XR<=4  Then Score:=Score+100;
End;

{$I CIA.OVR}

Procedure PTC;                                 { <---- Point To Command }
Begin
  If SS='RUN' Then DC1 Else
  If SS='GET' Then DC2 Else
  If SS='DRO' Then DC3 Else
  If SS='PUS' Then DC4 Else
  If SS='PUL' Then DC5 Else
  If SS='LOO' Then DC6 Else
  If SS='INS' Then DC7 Else
  If SS='OPE' Then DC8 Else
  If SS='WEA' Then DC9 Else
  If SS='REA' Then DC0 Else
  If SS='STA' Then DCA Else
  If SS='BRE' Then DCB Else
  If SS='CUT' Then DCC Else
  If SS='THR' Then DCD Else
  If SS='CON' Then DCE Else
  If SS='QUI' Then DCF Else
  If SS='BON' Then DCG Else
  If SS='INV' Then DCH Else
  Begin
    Print('I Can''t Understand What You Are Saying.');
    Delay(1000);
  End;
End;

Procedure LCC;                                 { <---- Last Chance Commands }
Begin
  If SS='LOO' Then PTG Else
  If SS='BON' Then DCG Else
  If SS='INV' Then DCH Else
  Begin
    Print('Please Use 2-Word Commands So I Can Understand You.');
    AFD;
  End;
End;

Procedure CSP;                                 { <---- Check Second Part }
Begin
  For X:=1 To 49 Do
  Begin
    If US=NS[X] Then Exit;
  End;
  If (US='NOR') Or (US='SOU') Or (US='EAS') Or (US='WES') Then Exit;
  Print('I Don''t Know What It Is That You Are Talking About.');
  AFD;
End;

Procedure GSP;                                 { <---- Get Second Part }
Begin
  US:='';
  For X:=1 To Length(RS) Do
  Begin
    S:=Copy(RS,X,1);
    If S=' ' Then
    Begin
      US:=Copy(RS,X+1,3);
      Exit;
    End;
  End;
  LCC;
End;

Procedure CIL;                                 { <---- Change Input Length }
Begin
  If RS='N' Then RS:='RUN NORTH';
  If RS='S' Then RS:='RUN SOUTH';
  If RS='E' Then RS:='RUN EAST';
  If RS='W' Then RS:='RUN WEST';
  If RS='I' Then RS:='INV';
End;

Procedure CFC;                                 { <---- Change First Command }
Begin
  If (SS='WAL') Or (SS='GO ') Then SS:='RUN';
  If (SS='TAK') Or (SS='CAR') Then SS:='GET';
  If SS='LEA' Then SS:='DRO';
  If SS='PRE' Then SS:='PUS';
  If SS='EXA' Then SS:='LOO';
  If SS='PUT' Then SS:='INS';
  If SS='UNL' Then SS:='OPE';
  If SS='PLA' Then SS:='STA';
  If SS='SMA' Then SS:='BRE';
  If SS='ATT' Then SS:='CON';
  If SS='LIS' Then SS:='INV';
End;

Procedure FVC;                                 { <---- Find Valid Commands }
Begin
  For X:=1 to 18 Do
  Begin
    If SS=VS[X] Then Exit;
  End;
  If SS='ORD' Then HAW
  Else
  Begin
    Print('I Don''t Know How To Do That.');
    AFD;
  End;
End;

Procedure AFD;                                 { <---- Ask For Directions }
Begin
  CI:=0;
  For X:=1 To 46 Do
  Begin
    If N[X]=-1 Then CI:=CI+1;
  End;
  Prompt('What Do You Think We Should Do?  ');
  Input(RS,40);
  CheckHangUp;
  If HangUp Then RTB;
  CIL;
  SS:=Copy(RS,1,3);
  CFC;
  FVC;
  If SS='QUI' Then DCF Else GSP;
  CSP;
  PTC;
End;

Procedure CLR;                                 { <---- Check Location Results }
Begin
  If (LO=3) And (N[39]=-1) Then
  Begin
    Print('The Doorman Looks At My Badge And Throws Me Out.');
    Delay(1000);
    LO:=1;
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    PTG;
  End
  Else If (LO=10) And (N[42]<>-1) Then
  Begin
    Print('The Guard Looks At Me Suspiciously, Then Throws Me Back.');
    Delay(1000);
    LO:=9;
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    PTG;
  End
  Else If (LO=6) And (BU<>1) Then
  Begin
    Print('   Sirens Go Off All Around Me!');
    Print('Guards Run In And Shoot Me To Death!');
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    Delay(1000);
    LTG;
  End
  Else If (LO=11) And (EL<>1) Then
  Begin
    Print('The Floor Is Wired With Electricity!');
    Print('       I''m Being Electrocuted!');
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    Delay(1000);
    LTG;
  End
  Else If (LO=10) And (N[30]=-1) And (DR=1) Then
  Begin
    Print(' The Guard Takes My Coffee.');
    Print('And Falls To Sleep Right Away.');
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    DG:=(10+Round(Random(15)));
    N[11]:=0;
    N[12]:=10;
    N[30]:=0;
    DR:=0;
    AFD;
  End
  Else If (GU=-2) Then
  Begin
    Print('The Guard Draws His Gun And Shoots Me!');
    Ansic(4);
    Print('Your Final Score is '+Cstr(Score));
    Delay(1000);
    LTG;
  End
  Else If DG=0 Then
  Begin
    Print('I Hear Noises Like Someone Is Yawning.');
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    N[11]:=10;
    N[12]:=0;
    GU:=-2;
    DG:=-1;
    AFD;
  End
  Else If (LO=1) And (N[26]=-1) And (N[39]=-1) Then
  Begin
    Score:=25000;
    Ansic(8);
    Print('HURRAY!  You''ve Recovered The Ruby!');
    Print('            YOU WIN !!!');
    Nl;
    Print('E-Mail Dave with the secret word you');
    Print('used to get into the basement and he');
    Print('will see that you get a reward for a');
    Print('fine accomplishment!!!');
    Ansic(4);
    Print('Your Final Score is '+Cstr(Score));
    SysopLog(' RECOVERED THE RUBY');
    Pausescr;
    RTB;
  End
  Else If TU=250 Then
  Begin
    Print('OH NO!  They Caught Up To Me!  HELP!');
    Print(' They Are Pulling Out Their Guns...');
    Ansic(4);
    Print('Your Final Score is '+Cstr(Score));
    Delay(1000);
    LTG;
  End
  Else If TU=225 Then
  Begin
    Print('I Think They Are On To Me... I Hear Noises.');
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    Delay(1000);
    AFD;
  End
  Else If TU=1 Then
  Begin
    Print('  Writing On The Wall Says:  ');
    Print('For Help Type ''ORDERS PLEASE''');
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    AFD;
  End
  Else If (LO=6) And (LON[6,2]<>0) Then
  Begin
    Score:=10000;
    Print('A Secret Door Slams Behind Me!');
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    LON[6,2]:=0;
    AFD;
  End
  Else
  Begin
    Ansic(4);
    Print('Your Score is now '+Cstr(Score));
    AFD;
  End;
End;

Procedure MNM;                                 { <---- Play The Game }
Begin
  RTC;
  CLR;
End;

Procedure PTG;                                 { <---- Make Next Move }
Begin
 Cls;
  TLeft;
  PCL;
  CWH;
  FGD;
  MNM;
End;

Procedure LPO;                                 { <---- Log Player On }
Begin
  Nl;
  Nl;
  For X:=1 To 3 Do
  Begin
    Prompt('Enter Your Agent Number  ');
    Input(R,3);
    CheckHangUp;
    If HangUp Then RTB;
    Prompt('Enter Your Cover Name    ');
    Input(S,40);
    CheckHangUp;
    If HangUp Then RTB;
    If (R=Agent) And (S=Alias) Then
    Begin
      Print('Checking Records...');
      Delay(1500);
      Exit;
    End
    Else
    Begin
      Print('Checking Records...');
      Delay(1500);
      Print('Something Seems Wrong...');
      Nl;
      Nl;
    End;
  End;
  Print('Sorry... You have run out of luck.');
  LTG;
End;

Procedure GPI;                                 { <---- Give Player Info }
Begin
  Nl;
  Nl;
  Ansic(2);
  Print('  Your Number Is   '+Agent);
  Ansic(2);
  Print('  Your Alias Is    '+Alias);
  Nl;
  Ansic(3);
  Print(' Please write this data down as you');
  Ansic(3);
  Print(' will need it if you ever want to');
  Ansic(3);
  Print(' play the game again...');
  Nl;
  PauseScr;
End;

Procedure CNF;                                 { <---- Create New File }
Begin
  ReWrite(Datafile);
  WriteLn(Datafile,'001');
  Nl;
  PrintFile('CHAINS\CIA.WEL');
  Nl;
  Agent:='001';
  Prompt('Enter Your Alias For This Game  ');
  Input(Alias,40);
  WriteLn(Datafile,Alias);
  Name:=ThisUser.Name;
  WriteLn(Datafile,Name);
  Close(Datafile);
  Reset(Datafile);
  GPI;
End;

Procedure APR;                                 { <---- Add Player Record }
Begin
  Nl;
  PrintFile('CHAINS\CIA.WEL');
  Nl;
  Close(Datafile);
  Assign(Datafile,'CHAINS\CIA.DAT');
  Append(Datafile);
  Agent:=Cstr(Succ(Value(R)));
  If Length(Agent)=1 Then Agent:='00'+Agent;
  If Length(Agent)=2 Then Agent:='0'+Agent;
  WriteLn(Datafile,Agent);
  Prompt('Enter Your Alias For This Game  ');
  Input(Alias,40);
  WriteLn(Datafile,Alias);
  Name:=ThisUser.Name;
  WriteLn(Datafile,Name);
  Close(Datafile);
  GPI;
End;

Procedure CPL;                                 { <---- Check Player Log }
Begin
  Assign(Datafile,'CHAINS\CIA.DAT');
  {$I-} Reset(Datafile); {$I+}
  If IOResult<>0 Then
  Begin
    CNF;
    Exit;
  End;
  Repeat
    ReadLn(Datafile,R);
    ReadLn(Datafile,S);
    ReadLn(Datafile,U);
  Until (U=ThisUser.Name) Or (EOF(Datafile));
  If U<>ThisUser.Name Then APR
  Else
  Begin
    Close(Datafile);
    Agent:=R;
    Alias:=S;
    Name:=U;
    LPO;
  End;
End;

BEGIN
  CLS;
  IPORT;
  TOPSCR;
  SIP;
  SYSOPLOG(' Played CIA');
  CLS;
  CPL;
  WHILE (NOT HANGUP) DO PTG;
  RTB;
END.