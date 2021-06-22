(* Program By Zaphod.         *)
(* Maker of the Mythtical Barn*)
(* 301-273-6126               *)
(* Verson 2.0                 *)




program Solar_Warrior;

{$I common.pas}

type
  game      = record
         number:integer;
         old1,old2,old4,
         old5,old6,old7,old8,
         old9:boolean;
         key1,key2,key4,
         key5,key6,key7,key8,
         key9:boolean;
         oldnumber,keynumber:integer;
         code1,code2,code3:str; end;
  otheruser = record
         number:integer;
         Name:string[25];
         rank:string[25];
         planetnum:integer;
         hp:integer;
         fuel:integer;
         magazine:integer;
         grenades:integer;
         cannon:integer;
         credits:integer;
         aid:integer;
         timeson:integer;
         turns:integer;
         thisdate:str;
         dead:boolean;
         experience:integer;
         key:boolean;
      end;
  Solaruser = record
         number:integer;
         Name:string[25];
         rank:string[25];
         planetnum:integer;
         hp:integer;
         fuel:integer;
         magazine:integer;
         grenades:integer;
         cannon:integer;
         credits:integer;
         aid:integer;
         timeson:integer;
         turns:integer;
         thisdate:str;
         dead:boolean;
         experience:integer;
         key:boolean;
       end;

Const
 Wormdam    = 2;     rank1='Private';
 fistdam    = 1;     rank2='Private First Class';
 Lazerdam   = 2;     rank3='Coropral';
 orghp      = 30;    rank4='Sergeant';
 Grenadedam   = 4;   rank5='Lieutenant';
 cannondam      = 8;  rank6='Captain';
 ran         =11;    rank7='Major';
 man         =13;    rank8='Lieutenant Colonel';
 planet1 =1;         rank9='Colonel';
 planet2 =2;         rank10='General';
 planet3 =3;
 planet4 =4;
 planet5 =6;
 planet6 =8;
 planet7 =12;
 planet8 =17;
 planet9 =24;


Var
  op,nn: char;
  worm,warrior,solarw2,space,solarw,thisthing,something,THISPLANET:INTEGER;
  fa,fb,fc,death,death1,death2,reaper,flesh,l,warrior1,warrior2,warrior3,warrior4,warrior5:integer;
  reaperdam,fleshdam:integer;
  infile,outfile:text;
  wongame,done,found,getout,travel   : boolean;
  name : string[25];
  this,thing,now:str;
  other1,other: otheruser;
  solar1,solar :solaruser;
  gamefile:file of game;
  gm:game;
  userfile: file of solaruser;
  otherfile: file of otheruser;
  allright,newfile,barf1:text[1024];



procedure writebarf1(i:str);
begin
  writeln(barf1,i);
end;


procedure writepromo(i:str);
begin
  writeln(allright,i);
end;




procedure ini(var i:integer);
var s:str;
begin
  input(s,1); i:=value(s);
end;


procedure ino(var i:integer);
var s:str;
begin
  input(s,2); i:=value(s);
end;




procedure switch;
begin
  solar.number:=other.number;
  solar.name:= other.name;
  solar.planetnum:=other.planetnum;
  solar.hp:=other.hp;
  solar.fuel:=other.fuel;
  solar.magazine:=other.magazine;
  solar.grenades:=other.grenades;
  solar.cannon:=other.cannon;
  solar.credits:=other.credits;
  solar.aid:=other.aid;
  solar.timeson:=  other.timeson;
  solar.turns:=  other.turns;
  solar.thisdate:=  other.thisdate;
  solar.dead:=  other.dead;
  solar.experience:=other.experience;
  solar.rank:=other.rank;
end;



procedure getusrdata;
var fsz:integer;
  begin
    assign(userfile,'solarwar.dat');
    {$I-} reset(userfile); {$I+}
    if ioresult<>0 then begin print('Making Data file');
    rewrite(userfile); end;
    fsz:=filesize(userfile);
    if fsz<=usernum then begin
      seek(userfile,fsz);
      while filesize(userfile)<=usernum do
      write(userfile,solar);
    end;
    seek(userfile,usernum);
    read(userfile,solar);
    close(userfile);
  end;


procedure getotherdata(var i:integer);
var fsz:integer;
    begin
    assign(otherfile,'other.dat');
    {$I-} reset(otherfile); {$I+}
    if ioresult<>0 then begin print('Making Data file');
    rewrite(otherfile); end;
    fsz:=filesize(otherfile);
    if fsz<=i then begin
      seek(otherfile,fsz);
      while filesize(otherfile)<=i do
      write(otherfile,other);
    end;
    seek(otherfile,i);
    read(otherfile,other);
    close(otherfile);
  end;






procedure return;
  var
  f:file;
  begin
    close(allright);
    close(barf1);
    assign(f,'bbs.com');
    nl;print('Returning you back to the Mythtical Barn');nl;
    thisuser.forusr:=thisuser.forusr-1;
    sysoplog('<-> Played Solar Warrior <->');
    prtc(2,'The "KID" took a Cow Chip for the fields..');
    delay(500);
    remove_port;
    if hangup then term_ready(false);
    execute(f);
  end;


procedure savegame;
begin
  reset(gamefile);
  seek(gamefile,gm.number);
  write(gamefile,gm);
  close(gamefile);
end;


procedure saveother1;
begin
  reset(otherfile);
  seek(otherfile,other.number);
  write(otherfile,other);
  close(otherfile);
end;



{$I overlay.pas}

procedure savedata;
begin
  solar.thisdate:=date;
  solar.timeson:=solar.timeson+1;
  solar.turns:=solar.turns-1;
  saveother;
  saveother1;
  savegame;
  reset(userfile);
  seek(userfile,solar.number);
  write(userfile,solar);
  close(userfile);
  print('You are leaving the game Solar Warrior...');
  print('See ya later...');
  if (wongame) or (solar.hp<1) then begin
  assign(gamefile,'game.dat');
  erase(gamefile);
  gamedata;
  makeit; end;
  return;
end;


procedure pluto; forward;
procedure earth; forward;

procedure goplanet;
begin
  if solar.planetnum=1 then pluto;
  if solar.planetnum=2 then pluto;
  if solar.planetnum=3 then earth;
  if solar.planetnum=4 then pluto;
  if solar.planetnum=6 then pluto;
  if solar.planetnum=8 then pluto;
  if solar.planetnum=12 then pluto;
  if solar.planetnum=17 then pluto;
  if solar.planetnum=24 then pluto;
end;



{$I cave.pas}
procedure journey; forward;

overlay procedure leave;
var a:str; stop:boolean; j:integer; planetname:str;

begin
  if thisplanet=1 then planetname:='MERCURY';
  if thisplanet=2 then planetname:='VENUS';
  if thisplanet=3 then planetname:='EARTH';
  if thisplanet=4 then planetname:='MARS';
  if thisplanet=6 then planetname:='JUPITER';
  if thisplanet=8 then planetname:='SATURN';
  if thisplanet=12 then planetname:='URANUS';
  if thisplanet=17 then planetname:='NEPTUNE';
  if thisplanet=24 then planetname:='PLUTO';
  nl;
  stop:=false;
  repeat
  checkhangup;
  something:=solar.fuel;
  travel:=true;
  nl;
  prompt('('+planetname+')(Type the name of the planet you would like to go to: ');  setc(29); input(a,7);
       if (a='Q') or (a='QUIT')
       then a:=planetname;
       if a='EARTH' THEN
        begin
          j:=thisplanet-planet3;
          if j>0 then something:=something-j;
          if j<0 then something:=something+j;
          if something<0 then print('You dont have enough fuel.')
          else begin
            stop:=true; thisthing:=solar.fuel-something; journey; earth;
          end;
        end
  else IF A='MERCURY' THEN
        begin
          j:=thisplanet-planet1;
          if j>0 then something:=something-j;
          if j<0 then something:=something+j;
          if something<0 then print('You dont have enough fuel.')
          else begin
            stop:=true; thisplanet:=planet1; thisthing:=solar.fuel-something; journey; pluto;
          end;
        end
  else IF A='VENUS' THEN
        begin
          j:=thisplanet-planet2;
          if j>0 then something:=something-j;
          if j<0 then something:=something+j;
          if something<0 then print('You dont have enough fuel.')
          else begin
            stop:=true; thisplanet:=planet2; thisthing:=solar.fuel-something; journey;   pluto;
          end;
        end
  else IF A='MARS' THEN
        begin
          j:=thisplanet-planet4;
          if j>0 then something:=something-j;
          if j<0 then something:=something+j;
          if something<0 then print('You dont have enough fuel.')
          else begin
            stop:=true; thisplanet:=planet4; thisthing:=solar.fuel-something; journey; pluto;
          end;
        end
  else IF A='JUPITER' THEN
        begin
          j:=thisplanet-planet5;
          if j>0 then something:=something-j;
          if j<0 then something:=something+j;
          if something<0 then print('You dont have enough fuel.')
          else begin
            stop:=true; thisplanet:=planet5; thisthing:=solar.fuel-something; journey; pluto;
          end;
        end
  else IF A='SATURN' THEN
        begin
          j:=thisplanet-planet6;
          if j>0 then something:=something-j;
          if j<0 then something:=something+j;
          if something<0 then print('You dont have enough fuel.')
          else begin
            stop:=true; thisplanet:=planet6; thisthing:=solar.fuel-something; journey; pluto;
          end;
        end
  else IF A='URANUS' THEN
         begin
          j:=thisplanet-planet7;
          if j>0 then something:=something-j;
          if j<0 then something:=something+j;
          if something<0 then  print('You dont have enough fuel.')
          else begin
            stop:=true; thisplanet:=planet7; thisthing:=solar.fuel-something; journey; pluto;
          end;
        end
  else IF A='NEPTUNE' THEN
        begin
          j:=thisplanet-planet8;
          if j>0 then something:=something-j;
          if j<0 then something:=something+j;
          if something<0 then  print('You dont have enough fuel.')
          else begin
            stop:=true; thisplanet:=planet8; thisthing:=solar.fuel-something; journey; pluto;
          end;
        end
  else IF A='PLUTO' THEN
        begin
          j:=thisplanet-planet9;
          if j>0 then something:=something-j;
          if j<0 then something:=something+j;
          if something<0 then
          print('You dont have enough fuel.')

          else begin
            stop:=true; thisplanet:=planet9; thisthing:=solar.fuel-something; journey; pluto;
          end;
        end
  else print('There is no such planet...');
  until stop;
 end;


{$I planets.pas}










begin
  cls;
  wongame:=false;
  sysoplog('<-> Entered Solar Warrior.......');
  iport;
  gamedata;
  barfing;
  ansic(3);
  print('Welcome to Solar Warrior');
  makeit;
  new;
  printfile('Solar.txt');
  saveother;
  nl;
  getusrdata;
  getotherdata(usernum);
  switch;
  nl;
  ynq('Would you like to know how to play Solar Warrior?');
  if yn then printfile('instruct.txt');
  setc(7);
  printfile('winners.txt');
  nl;
  if solar.dead then begin
    print('Your Dead Solar Warrior, But with the Miricles of Modern Science');
    print('you can start over...');
    if solar.thisdate=date then fa:=0 else fa:=3;
    new;
    solar.turns:=fa; solar.timeson:=1; solar.planetnum:=3; saveother;
  end;
  if (solar.turns<1) and (solar.thisdate<>date) then solar.turns:=3;
  if (solar.turns<1) and (solar.thisdate=date) then begin
    print('You are to tired.. Wait till tomorrow then you''ll feel better..');
    savedata; end;
  travel:=false;
  printfile('Promo.txt');
  nl;
  print('Starting Adventure...');
  nl;
    if usernum=solar.number then nl
    else fixit;
  if solar.name<>thisuser.name then fixit else nl;
  nl;
  goplanet;
end.


