(* Program By Zaphod.         *)
(* Maker of the Mythtical Barn*)
(* 301-273-6126               *)
(* Version 2.0                *)




program Solar_Warrior_Editor;

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
 Lazerdam   = 2;     rank3='Corpral';
 orghp      = 30;    rank4='Sergeant';
 Grenadedam   = 4;   rank5='Leutenant';
 cannondam      = 8;  rank6='Captain';
 ran         =11;    rank7='Major';
 man         =13;    rank8='Leutenant Colonel';
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
  k,reaperdam,fleshdam:integer;
  infile,outfile:text; kk:str;
  stopnow,quitnow,stop,done,found,getout,travel   : boolean;
  name : string[25];
  this,thing,now:str;
  other1,other: otheruser;
  solar1,solar :solaruser;
  gamefile:file of game;
  gm:game;
  userfile: file of solaruser;
  otherfile: file of otheruser;
  allright,newfile,barf1:text[1024];
  var unknown:integer; a:str; ka:integer;



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

procedure new;
begin
  solar.number:=unknown;
  solar.name:='Unknown';
  solar.rank:='Unknown';
  solar.planetnum:=0;
  solar.hp:=30;
  solar.fuel:=50;
  solar.magazine:=10;
  solar.grenades:=0;
  solar.Cannon:=0;
  solar.credits:=30;
  solar.aid:=0;
  solar.timeson:=0;
  solar.turns:=13;
  solar.thisdate:=date;
  solar.dead:=false;
  solar.experience:=0;
  solar.key:=false;
end;

overlay procedure othernew;
begin
  other.number:=unknown;
  other.name:='Unknown';
  other.rank:='Unknown';
  other.planetnum:=0;
  other.hp:=30;
  other.fuel:=50;
  other.magazine:=10;
  other.grenades:=0;
  other.Cannon:=0;
  other.credits:=30;
  other.aid:=0;
  other.timeson:=0;
  other.turns:=13;
  other.thisdate:=date;
  other.dead:=false;
  other.experience:=0;
  other.key:=false;
end;




procedure getunknowndata;
var fsz,inte:integer;
  begin
  inte:=0;
  unknown:=0;
    assign(userfile,'solarwar.dat');
    {$I-} reset(userfile); {$I+}
    if ioresult<>0 then begin print('Making Data file');
      rewrite(userfile);
      fsz:=500;
      begin
        while (not hangup) and (inte<fsz)  do begin
          inte:=inte+1;
          unknown:=inte;
          new;
          write(' '+cstr(inte));
          seek(userfile,inte);
          write(userfile,solar);
        end;
      end;
    end;
    seek(userfile,usernum);
    read(userfile,solar);
    close(userfile);
  end;

procedure getotherunknowndata;
var fsz,inte:integer;
  begin
    inte:=0;
    unknown:=0;
    assign(otherfile,'other.dat');
    {$I-} reset(otherfile); {$I+}
    if ioresult<>0 then begin print('Making Data file');
      rewrite(otherfile);
      fsz:=500;
      begin
        while (not hangup) and (inte<fsz)  do begin
          inte:=inte+1;
          unknown:=inte;
          write(' '+cstr(inte));
          othernew;
          seek(otherfile,inte);
          write(otherfile,other);
        end;
      end;
    end;
    seek(otherfile,usernum);
    read(otherfile,other);
    close(otherfile);
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

procedure getsolardata(var i:integer);
var fsz:integer;
    begin
    assign(userfile,'solarwar.dat');
    {$I-} reset(userfile); {$I+}
    if ioresult<>0 then begin print('Making Data file');
    rewrite(userfile); end;
    fsz:=filesize(userfile);
    if fsz<=i then begin
      seek(userfile,fsz);
      while filesize(userfile)<=i do
      write(userfile,solar);
    end;
    seek(userfile,i);
    read(userfile,solar);
    close(userfile);
  end;



procedure getgame(var i:integer);
var fsz:integer;
    begin
    assign(gamefile,'game.dat');
    {$I-} reset(gamefile); {$I+}
    if ioresult<>0 then begin print('Making Data file');
    rewrite(gamefile); end;
    fsz:=filesize(gamefile);
    if fsz<=i then begin
      seek(gamefile,fsz);
      while filesize(gamefile)<=i do
      write(gamefile,gm);
    end;
    seek(gamefile,i);
    read(gamefile,gm);
    close(gamefile);
  end;





overlay procedure saveother;
begin
  other.number:=solar.number;
  other.name:=solar.name;
  other.planetnum:=solar.planetnum;
  other.hp:=solar.hp;
  other.fuel:=solar.fuel;
  other.magazine:=solar.magazine;
  other.grenades:=solar.grenades;
  other.Cannon:=solar.Cannon;
  other.credits:=solar.credits;
  other.aid:=solar.aid;
  other.timeson:=solar.timeson;
  other.turns:=solar.turns;
  other.thisdate:=solar.thisdate;
  other.dead:=solar.dead;
  other.experience:=solar.experience;
  other.rank:=solar.rank;
  end;










procedure return;
  var
  f:file;
  begin
    assign(f,'bbs.com');
    nl;print('Returning you back to the Mythtical Barn');nl;
    sysoplog('<-> Played Solar Warrior Editor <->');
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


procedure savesolar;
begin
  reset(userfile);
  seek(userfile,solar.number);
  write(userfile,solar);
  close(userfile);
end;




procedure gamedata;
var k,r:integer;
begin
  k:=random(8)+1;
  r:=random(8)+1;
  gm.number:=1;
  if k=1 then   gm.key1:=true  else gm.key1:=false;
  if k=2 then   gm.key2:=true  else gm.key2:=false;
  if k=3 then   gm.key9:=true   else gm.key9:=false;
  if k=4 then   gm.key4:=true   else gm.key4:=false;
  if k=5 then   gm.key5:=true   else gm.key5:=false;
  if k=6 then   gm.key6:=true   else gm.key6:=false;
  if k=7 then   gm.key7:=true   else gm.key7:=false;
  if k=8 then   gm.key8:=true   else gm.key8:=false;
  if k=9 then   gm.key9:=true   else gm.key9:=false;
  if r=1 then   gm.old1:=true   else gm.old1:=false;
  if r=2 then   gm.old2:=true   else gm.old2:=false;
  if r=3 then   gm.old9:=true   else gm.old9:=false;
  if r=4 then   gm.old4:=true   else gm.old4:=false;
  if r=5 then   gm.old5:=true   else gm.old5:=false;
  if r=6 then   gm.old6:=true   else gm.old6:=false;
  if r=7 then   gm.old7:=true   else gm.old7:=false;
  if r=8 then   gm.old8:=true   else gm.old8:=false;
  if r=9 then   gm.old9:=true else  gm.old9:=false;
  gm.oldnumber:=r;
  gm.keynumber:=k;
  gm.code1:='KA';
  gm.code2:='I2';
  gm.code3:='N3';
end;


procedure makeit;
var fsz:integer;
begin
   begin
    assign(newfile,'winners.txt');
    {$I-} append(newfile); {$I+}
    if (ioresult<>0) then begin
      rewrite(newfile);
      writeln(newfile,'Winners at Solar Warrior :'); end;
     close(newfile);
   end;
   begin
    assign(gamefile,'game.dat');
    {$I-} reset(gamefile); {$I+}
    if ioresult<>0 then begin print('Making Data file');
    rewrite(gamefile); end;
    fsz:=1;
    if fsz<=1 then begin
      seek(gamefile,fsz);
      while filesize(gamefile)<=1 do
      write(gamefile,gm);
    end;
    seek(gamefile,gm.number);
    read(gamefile,gm);
    close(gamefile);
   end;
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


procedure cleanpromo;
begin
  assign(allright,'promo.txt');
  erase(allright);
  print('Done');
end;

procedure cleanbar;
begin
  assign(barf1,'bar1.log');
  erase(barf1);
  print('Done');
 end;


procedure cleangame;
begin
  assign(userfile,'solarwar.dat');
  erase(userfile);
  assign(otherfile,'other.dat');
  erase(otherfile);
  assign(gamefile,'game.dat');
  erase(gamefile);
  print('Done');
  getunknowndata;
  getotherunknowndata;
  gamedata;
  makeit;
end;


begin
  cls;
  unknown:=0;
  quitnow:=false;
  stop:=false;
  stopnow:=false;
  sysoplog('<-^-> Entered Solar Editor <-^->');
  iport;
  ansic(3);
  print('Welcome to Solar Warrior Editor');
  begin
    repeat checkhangup;
    print('Enter Solar Warrior Number [999 Edits Game Stats]: '); input(kk,3);
    if kk='Q' then stop:=true;
    k:=value(kk);
    if k=999 then
    begin
      k:=1;
      getgame(k);
      nl;
      begin
        repeat checkhangup;
        nl;
        kk:='0';


  if gm.keynumber=1 then   gm.key1:=true  else gm.key1:=false;
  if gm.keynumber=2 then   gm.key2:=true  else gm.key2:=false;
  if gm.keynumber=3 then   gm.key9:=true   else gm.key9:=false;
  if gm.keynumber=4 then   gm.key4:=true   else gm.key4:=false;
  if gm.keynumber=5 then   gm.key5:=true   else gm.key5:=false;
  if gm.keynumber=6 then   gm.key6:=true   else gm.key6:=false;
  if gm.keynumber=7 then   gm.key7:=true   else gm.key7:=false;
  if gm.keynumber=8 then   gm.key8:=true   else gm.key8:=false;
  if gm.keynumber=9 then   gm.key9:=true   else gm.key9:=false;
  if gm.oldnumber=1 then   gm.old1:=true   else gm.old1:=false;
  if gm.oldnumber=2 then   gm.old2:=true   else gm.old2:=false;
  if gm.oldnumber=3 then   gm.old9:=true   else gm.old9:=false;
  if gm.oldnumber=4 then   gm.old4:=true   else gm.old4:=false;
  if gm.oldnumber=5 then   gm.old5:=true   else gm.old5:=false;
  if gm.oldnumber=6 then   gm.old6:=true   else gm.old6:=false;
  if gm.oldnumber=7 then   gm.old7:=true   else gm.old7:=false;
  if gm.oldnumber=8 then   gm.old8:=true   else gm.old8:=false;
  if gm.oldnumber=9 then   gm.old9:=true else  gm.old9:=false;
        print('(1) Hologram is in :'+cstr(gm.oldnumber));
        print('(2) Radium is in   :'+cstr(gm.keynumber));
        print('(3) 1st Code #     :'+gm.code1);
        print('(4) 2nd Code #     :'+gm.code2);
        print('(5) 3rd Code #     :'+gm.code3);
        print('(6) Reset Game     ');
        print('(7) Reset Promotion List');
        print('(8) Reset Bar List');
        nl;
        prompt('What Do you wanna change? '); onek(op,'1234567Q8');
        case op of
        'Q':begin stopnow:=true; close(gamefile); end;
        '1':begin prompt('Hologram is in what Planet? (1-9): '); input(kk,1);
         k:=value(kk); gm.oldnumber:=k; end;
        '2':begin prompt('Radium is in what Planet? (1-9): '); input(kk,1);
         k:=value(kk); gm.keynumber:=k; end;
        '3':begin prompt('First Code is: '); input(kk,2);
        gm.code1:=kk; end;
        '4':begin prompt('Second Code is: '); input(kk,2);
        gm.code2:=kk; end;
        '5':begin prompt('Third Code is: '); input(kk,2);
        gm.code3:=kk; end;
        '6':begin print('Reseting Game.dat, Solarwar.dat, and Other.dat');
            cleangame;
            print('Reseting Promotions');
            cleanpromo;
            print('Reseting Bar Log ');
            cleanbar;
            end;
        '7':cleanpromo;
        '8':cleanbar;
        end;
        savegame;
        until stopnow;
        k:=0;
      end;
    end;
    if (k>=1) and (k<999) then begin
      getotherdata(k);
      nl;
      begin
        quitnow:=false;
        repeat checkhangup;
        kk:='0';
        if other.planetnum=0       then a:='Unknown';
        if other.planetnum=planet1 then a:='Mercury';
        if other.planetnum=planet2 then a:='Venus';
        if other.planetnum=planet3 then a:='Earth';
        if other.planetnum=planet4 then a:='Mars';
        if other.planetnum=planet5 then a:='Jupiter';
        if other.planetnum=planet6 then a:='Saturn';
        if other.planetnum=planet7 then a:='Uranus';
        if other.planetnum=planet8 then a:='Neptune';
        if other.planetnum=planet9 then a:='Pluto';
        nl;
        SETC(13);  PRINT('      #       : '+CSTR(OTHER.NUMBER));
        setc(13);  print('   Name       : '+other.name);
        setc(13);  print('   Rank       : '+other.rank);
        setc(13);  print('(A)Planet     : '+a);
        setc(13);  print('(B)Hit Points : '+cstr(other.hp)+'/'+cstr(orghp));
        setc(13);  print('   Times on   : '+cstr(other.timeson));
        setc(13);  print('(C)Fuel       : '+cstr(other.fuel));
        setc(13);  print('(D)Lazer Ammo : '+cstr(other.magazine));
        setc(13);  print('(E)Grenades   : '+cstr(other.grenades));
        setc(13);  print('(F)Cannon      : '+cstr(other.cannon));
        setc(13);  print('(G)Credits    : '+cstr(other.credits));
        setc(13);  print('(H)First Aid  : '+cstr(other.aid));
        setc(13);  print('(I)Experience : '+cstr(other.experience));
        setc(13);  print('(J)Turns      : '+cstr(other.Turns));
          if solar.key then begin
        setc(14);  print('(K)HAS FOUND RADIUM CHRYSTLES '); end;
        prompt('What would you like to edit?: '); onek(op,'ABCDEFGHIJKQ!');
        case op of
        'Q':begin quitnow:=true; close(otherfile); end;
        'A':begin prompt('What Planet? (1-9): '); input(kk,1);
         k:=value(kk);
        if k>0  then begin
        if k=1 then other.planetnum:=planet1
        else if k=2 then other.planetnum:=planet2
        else if k=3 then other.planetnum:=planet3
        else if k=4 then other.planetnum:=planet4
        else if k=5 then other.planetnum:=planet5
        else if k=6 then other.planetnum:=planet6
        else if k=7 then other.planetnum:=planet7
        else if k=8 then other.planetnum:=planet8
        else if k=9 then other.planetnum:=planet9;
        end; end;
        'B':begin prompt('How Many Hit Points?: '); input(kk,3);  k:=value(kk);
        other.hp:=k; end;
        'C':begin PROMpT('How much fuel?: '); input(kk,3);  k:=value(kk);
        other.fuel:=k; end;
        'D':begin PROMpT('How many lazers?: '); input(kk,3);  k:=value(kk);
        other.magazine:=k; end;
        'E':begin PROMpT('How many grenades?: '); input(kk,3);  k:=value(kk);
        other.grenades:=k; end;
        'F':begin PROMpT('How many Cannons?: '); input(kk,3);    k:=value(kk);
        other.cannon:=k; end;
        'G':begin PROMpT('How many Credits?: '); input(kk,3);  k:=value(kk);
        other.credits:=k; end;
        'H':begin PROMpT('How many First Aids?: '); input(kk,3);  k:=value(kk);
        other.aid:=k; end;
        'I':begin PROMpT('How much Experience?: '); input(kk,3);  k:=value(kk);
            other.experience:=k; end;
        'J':begin PROMpT('How many turns?: '); input(kk,3);       k:=value(kk);
        other.turns:=k; end;
        'K':solar.key:=false;
        end; saveother1; until quitnow;
      end;
    end
    else print('I dont believe that Solar Warrior is Here...');
    until stop;
    return;
  end;








end.


