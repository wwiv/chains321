
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




overlay procedure new;
begin
  solar.number:=usernum;
  solar.name:=thisuser.name;
  solar.rank:=rank1;
  solar.planetnum:=planet3;
  solar.hp:=30;
  solar.fuel:=50;
  if cs then solar.fuel:=100;
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


overlay procedure howmuch;
var a,b,c,d,e:integer;
begin
  nl;
  nl;
  print(' 1:Mercury   2:Venus    3:Earth');
  print(' 4:Mars      5:Jupiter  6:Saturn');
  print(' 7:Uranus    8:Neptune  9:Pluto');
  nl;
  begin
    prompt('FROM what planet: '); ini(a);
    nl;
    prompt('TO what planet: '); ini(b);
    if a=1 then c:=planet1; if a=2 then c:=planet2; if a=3 then c:=planet3;
    if a=4 then c:=planet4; if a=5 then c:=planet5; if a=6 then c:=planet6;
    if a=7 then c:=planet7; if a=8 then c:=planet8; if a=9 then c:=planet9;
    if b=1 then d:=planet1; if b=2 then d:=planet2; if b=3 then d:=planet3;
    if b=4 then d:=planet4; if b=5 then d:=planet5; if b=6 then d:=planet6;
    if b=7 then d:=planet7; if b=8 then d:=planet8; if b=9 then d:=planet9;
    if c>d then e:=c-d;
    if c<d then e:=d-c;
  end;
print('It takes '+cstr(e)+' Chrystlarium to get there...');
end;


overlay procedure gamedata;
var k,r:integer;
begin
  k:=random(8)+1;
  r:=random(8)+1;
  gm.number:=1;
  if k=1 then   gm.key1:=true  else gm.key1:=false;
  if k=2 then   gm.key2:=true  else gm.key2:=false;
  if k=3 then  begin k:=9; gm.key9:=true end   else gm.key9:=false;
  if k=4 then   gm.key4:=true   else gm.key4:=false;
  if k=5 then   gm.key5:=true   else gm.key5:=false;
  if k=6 then   gm.key6:=true   else gm.key6:=false;
  if k=7 then   gm.key7:=true   else gm.key7:=false;
  if k=8 then   gm.key8:=true   else gm.key8:=false;
  if k=9 then   gm.key9:=true   else gm.key9:=false;
  if r=1 then   gm.old1:=true   else gm.old1:=false;
  if r=2 then   gm.old2:=true   else gm.old2:=false;
  if r=3 then   begin r:=9; gm.old9:=true end  else gm.old9:=false;
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


overlay procedure makeit;
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

overlay procedure barfing;
begin
assign(allright,'promo.txt');
  {$I-} append(allright); {$I+}
  if (ioresult<>0) then begin rewrite(allright); writeln(allright); end;
  close(allright); append(allright);
assign(barf1,'bar1.log');
  {$I-} append(barf1); {$I+}
  if (ioresult<>0) then begin rewrite(barf1); writeln(barf1); end;
  close(barf1); append(barf1);

(***********assign(barf2,'bar2.log');
  {$I-} append(barf2); {$I+}
  if (ioresult<>0) then begin rewrite(barf2); writeln(barf2); end;
  close(barf2); append(barf2);
setc(8); print('                      8');
assign(barf3,'bar3.log');
  {$I-} append(barf3); {$I+}
  if (ioresult<>0) then begin rewrite(barf3); writeln(barf3); end;
  close(barf3); append(barf3);
setc(7); print('                      7');
assign(barf4,'bar4.log');
  {$I-} append(barf4); {$I+}
  if (ioresult<>0) then begin rewrite(barf4); writeln(barf4); end;
  close(barf4); append(barf4);
setc(6); print('                      6');
assign(barf5,'bar5.log');
  {$I-} append(barf5); {$I+}
  if (ioresult<>0) then begin rewrite(barf5); writeln(barf5); end;
  close(barf5); append(barf5);
setc(5); print('                      5');
assign(barf6,'bar6.log');
  {$I-} append(barf6); {$I+}
  if (ioresult<>0) then begin rewrite(barf6); writeln(barf6); end;
  close(barf6); append(barf6);
setc(4); print('                      4');
assign(barf7,'bar7.log');
  {$I-} append(barf7); {$I+}
  if (ioresult<>0) then begin rewrite(barf7); writeln(barf7); end;
  close(barf7); append(barf7);
setc(3); print('                      3');
assign(barf8,'bar8.log');
  {$I-} append(barf8); {$I+}
  if (ioresult<>0) then begin rewrite(barf8); writeln(barf8); end;
  close(barf8); append(barf8);
setc(2); print('                      2');
assign(barf9,'bar9.log');
  {$I-} append(barf9); {$I+}
  if (ioresult<>0) then begin rewrite(barf9); writeln(barf9); end;
  close(barf9); append(barf9);
setc(1); print('                      1');
************)




nl;
nl;
nl; nl;
end;

procedure fixit;
    begin
    Print('Searching for your records.....');
    new;
    assign(userfile,'solarwar.dat');
    {$I-} reset(userfile); {$I+}
    seek(userfile,usernum);
    write(userfile,solar);
    seek(userfile,usernum);
    read(userfile,solar);
    close(userfile);
    saveother;
    assign(otherfile,'other.dat');
    {$I-} reset(otherfile); {$I+}
    seek(otherfile,usernum);
    write(otherfile,other);
    seek(otherfile,usernum);
    read(otherfile,other);
    close(otherfile);
    saveother1;
 end;

