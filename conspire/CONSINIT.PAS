Program Conspiricy_InIt;

Type field1= Array[1..200,1..18] of integer;

Var filc:file of field1;
    d   :array[1..18]of integer;
    l1,l2:integer;
    l:field1; {Location attributes}
    gp,dp:String[60];
    fila:text;
    vl:char;
    n       :array[1..200] of string[40]; {Name of location}
    gl      :string[4];
    file1,file2,file3,file4,file5,
    file6,file7,file8,file9             :string[80];
    Stf           :array[1..12] of String[20];
    LcStf         :Array[10..18] of String[20];
    Wages,Kv      :Array[1..9] of integer;
    zeta          :integer;

Begin
    Writeln('Warning:running this program will delete the old game.');
    Write('Proceed? Y to continue   ');
    Readln(vl);
    if (vl<>'y') and (vl<>'Y') then halt;
    Writeln;
    Writeln('Enter your G-files path for text (ie c:\bbs\gfiles)');
    Readln(gp);
    Writeln('Enter you data path (ie c:\bbs\data)');
    Readln(dp);
      file2:=dp+'\Consplay.dat';
      file1:=dp+'\ConsLocs.dat';
      file3:=dp+'\ConsDate.dat';
      file5:=gp+'\ConsNews.txt';
      file8:=dp+'\ConsMsgs.dat';
      file4:=gp+'\ConsLcNm.txt';
      file6:=gp+'\ConsOlds.txt';
      file7:=gp+'\ConsMenu.txt';
      file9:=dp+'\Consvars.dat';

    {menu}
      Assign(fila,file7);
      Rewrite(fila);
      Writeln(fila,'Main menu:');
      Writeln(fila,'A)ttacks');
      Writeln(fila,'B)ulletins');
      Writeln(fila,'D)efense $$$');
      Writeln(fila,'F)inances');
      Writeln(fila,'I)ntelligence');
      Writeln(fila,'H)elp');
      Writeln(fila,'M)ove men');
      Writeln(fila,'P)ublicity');
      Writeln(fila,'Q)uit');
      Writeln(fila,'S)tatus');
      Writeln(fila,'X)pert mode toggle');
      Writeln(fila,'W)rite mail');
      Close(fila);

    { players }
    Assign(fila,file2);
    Rewrite(fila);
    writeln(fila,'The Computer');
    writeln(fila,'The FBI');
    Writeln(fila,0);
    d[1]:=30;
    d[2]:=10;
    d[3]:=8;
    d[4]:=3;
    d[5]:=6;
    d[6]:=4;
    d[7]:=0;
    d[8]:=0;
    d[9]:=2;
    d[10]:=5000;
    d[11]:=100;
    d[12]:=2000;
    for l1:=13 to 18 do d[l1]:=0;
    for l1:=1 to 18 do Writeln(fila,d[l1]);
    Close(fila);

    {Players inited. Next comes date.}
    Assign(fila,file3);
    rewrite(fila);
    writeln(fila,0);
    Close(fila);

    Assign(fila,file5);
    Rewrite(fila);
    Writeln(fila,'Conspiracy Inited');
    Close(fila);

    Assign(fila,file6);
    Rewrite(fila);
    Writeln(fila,'Bleah!');
    Close(fila);

    Assign(fila,file8);
    Rewrite(fila);
    Writeln(fila,'Mail room initiated.');
    Writeln(fila,1);
    Writeln(fila,1);
    Close(fila);

    {Location initiation.
    Attributes are:
    N is name
    [1-18] are attributes
    1-9 Armed forces there
    10 D demand
    11 S demand
    12 Police Activity
    13 Media Activity
    14 Value for Takeover
    15 Owner
    16 Resistance-Max
    17 Current Resistance
    18 Defense $$$}



for l1:=1 to 50 do begin
str(l1,gl);
if l1 mod 10 = 1 then n[l1]:=gl+'st Street ';
if l1 mod 10 = 2 then n[l1]:=gl+'nd Street ';
if l1 mod 10 = 3 then n[l1]:=gl+'rd Street ';
if (l1 mod 10 >3) or (l1 mod 10 =0) then n[l1]:=gl+'th Street';
l[l1,1]:=random(5);
l[l1,2]:=random(3);
if random>0.5 then l[l1,3]:=1 else l[l1,3]:=0;
for l2:=4 to 9 do l[l1,l2]:=0;
l[l1,10]:=random(10);
l[l1,11]:=random(10);
l[l1,12]:=random(11)+random(11);
l[l1,13]:=random(11)+random(31);
l[l1,14]:=trunc(random*random(8)*random(8)+trunc(10*random+1)*random(6));
l[l1,15]:=0;
zeta:=trunc((random(10)*(random)+1)*(random(3)+1));
l[l1,16]:=zeta;
l[l1,17]:=zeta;
l[l1,18]:=trunc(random(31)*random+11*random);
end;



n[50]:='Krogers';
l[50,12]:=20;
l[50,13]:=80;
l[50,14]:=5000;
l[50,16]:=10;
l[50,17]:=10;

n[49]:='Boardwalk';
l[49,10]:=20;  {Drug demand}
l[49,11]:=30;  {Sex demand}
l[49,12]:=20;  {Police activity}
l[49,13]:=50;  {Media activity}
l[49,14]:=400; {Takeover income}
l[49,15]:=0;   {Owner}
l[49,16]:=100; {Maximum resistance}
l[49,17]:=100; {current resistance}
l[49,18]:=300; {defense $$$$}

n[45]:='GTE main office, Terre Haute';
l[45,1]:=20;
l[45,10]:=10;
l[45,11]:=3;
l[45,12]:=0;
l[45,13]:=0;
l[45,14]:=60;
l[45,18]:=200;

n[46]:='WalkenBooks';
l[46,10]:=0;
l[46,11]:=1;
l[46,12]:=20;
l[46,13]:=40;
l[46,14]:=30;
l[46,16]:=2;
l[48,18]:=20;

n[47]:='ARA dining hall';
l[47,10]:=0;
l[47,11]:=25;
l[47,12]:=5;
l[47,13]:=10;
l[47,14]:=50;
l[47,16]:=10;
l[47,18]:=50;

n[48]:='Clyde''s auto repair';
l[48,10]:=2;
l[48,11]:=5;
l[48,12]:=10;
l[48,13]:=10;
l[48,14]:=50;
l[48,16]:=10;
l[48,18]:=100;

for l1:=1 to 50 do l[l1,17]:=l[l1,16];

    Assign(filc,file1);
    Rewrite(filc);
    Write(filc,l);
    Close(filc);

Assign(fila,file4);
Rewrite(fila);
for l1:=1 to 50 do Writeln(fila,n[l1]);
Close(fila);



    Stf[1]:='Goon(s)';
    Stf[2]:='Elite grunt(s)';
    Stf[3]:='Leader(s)';
    Stf[4]:='Boss(s)';
    Stf[5]:='Spy(s)';
    Stf[6]:='Agent(s)';
    Stf[7]:='Pimp(s)';
    Stf[8]:='Dealer(s)';
    Stf[9]:='Recruiters';
    Stf[10]:='Money';
    Stf[11]:='Public Opinion';
    Stf[12]:='Defense $$$';

    LcStf[10]:='Drug Demand';
    Lcstf[11]:='Sex Demand';
    Lcstf[12]:='Police activity';
    Lcstf[13]:='Media activity';
    Lcstf[14]:='Value $/day';
    Lcstf[15]:='Owner';
    LcStf[16]:='Maximum Resistance'; {unnocupied defense}
    LcStf[17]:='Current Resistance';
    LcStf[18]:='Defense $$$$';

    Wages[1]:=1;
    Wages[2]:=2;
    Wages[3]:=3;
    Wages[4]:=10;
    Wages[5]:=10;
    Wages[6]:=20;
    Wages[7]:=5;
    Wages[8]:=7;
    Wages[9]:=20;

    Kv[1]:=4;
    Kv[2]:=6;
    Kv[3]:=6;
    Kv[4]:=10;
    Kv[5]:=15;
    Kv[6]:=30;
    Kv[7]:=2;
    Kv[8]:=2;
    Kv[9]:=2;

    Assign(fila,file9);
    rewrite(fila);
    for l1:=1 to 12 do Writeln(fila,Stf[l1]);
    for l1:=10 to 18 do Writeln(fila,Lcstf[l1]);
    for l1:=1 to 9 do Writeln(fila,Wages[l1]);
    for l1:=1 to 9 do Writeln(fila,Kv[l1]);
    Close(fila);

End.