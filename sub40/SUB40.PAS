

{                               S U B  B A T T L E
                                       by
                                  The Hightailer
                             The Rapid Transit System
                                  (804) 784-4317

  Keep in mind that I debated whether or not to put my name on this stupid
  game.  This game was inspired by the program SUB.BAS - author unknown.
  Version 1.0 written 3/5/88 by The Hightailer.                            }

program sub;

{$V-}  {$C-}
{$I common.pas}

var
location : array[0..71] of char;
row      : array[0..71] of integer;
column   : array[0..71] of integer;
sub      : array[1..3] of integer;
tries,hits,low : integer;
gameover,wongame : boolean;
lofile : text;


(*

procedure return;
var
f : file;
begin
  cls;topscr;checkhangup;
  assign(f,'bbs.com');
  nl;ansic(3);print('Returning to BBS...');nl;
  remove_port;
  if hangup then term_ready(false);
  execute(f);
end;

*)

procedure locate(X,Y : integer);
type
  registers = record case boolean of
    true : (al,ah,bl,bh,cl,ch,dl,dh: byte);
    false: (ax,bx,cx,dx,bp,si,di,ds,es,flags: integer) end;
var
reg : registers;
i   : string[80];
ctr : integer;
begin
  i := #27+'['+cstr(x)+';'+cstr(y)+'H';checkhangup;
  for ctr := 1 to length(i) do
    begin
      reg.ah := $02;
      reg.dx := ord(i[ctr]);
      prompt(i[ctr]);
    end;
end;

procedure introduction;
var
loscore,loname : str;
begin
  cls;locate(5,35);
  ansic(6);print('S U B  B A T T L E');ansic(0);
  locate(6,42);ansic(4);
  prompt('by');
  locate(7,37);ansic(7);
  prompt('The Hightailer');
  assign(lofile,gfilespath+'sub.scr');
  {$I-} reset(lofile); {$I+}
  if ioresult <> 0 then
    begin
      print('Creating low score file...');
      rewrite(lofile);
      writeln(lofile,'NO ONE');
      writeln(lofile,'99');
      close(lofile);
    end;
  reset(lofile);
  readln(lofile,loname);
  readln(lofile,loscore);
  close(lofile);
  low := value(loscore);
  locate(9,15);ansic(3);
  prompt('The current low score belongs to '+loname+',');
  locate(11,10);ansic(7);
  prompt('who destroyed the enemy sub using only '+loscore+' depth charges.');
  locate(15,27);prt('Do you need instructions? ');
  if yn then
    begin
      cls;
      print('You''re the C.O. on a destroyer. You''ve played cat and mouse with an enemy sub');
      print('for 2 days and now it''s time to do battle. The sub is somewhere in the depths');
      print('below. You must try to destroy it with your depth charges. To fire a depth ');
      print('charge, enter the level (1,2, or 3) and the quadrant (A-X) that you want to ');
      print('hit with your depth charge. If you damage the sub, the quadrant letter will be');
      print('replaced with a flashing star. The sub is 3 quadrants in length and will be ');
      print('aligned diagonally, horizontally, or vertically, but will occupy only 1 level.');
      print('For every 3 depth charges you fire, the sub launches 1 torpedo, each of which');
      print('has a 50-50 chance of hitting your ship. The game is over when either your ship');
      print('or the sub is destroyed. It takes 3 hits to sink either the sub or your');
      print('ship. Your ability to find and destroy the sub will determine what your');
      print('next assignment will be:  an Aircraft Carrier or a Garbage Barge.');
      nl;pausescr;
    end;
end;

procedure initialize;
var ctr,temp,hidetype,hide1,hide2,hide3 : integer;
begin
  sysoplog('Played Sub Battle');
  randomize;
  window(1,1,80,25);
  gameover := false;
  wongame := false;
  tries := 0;
  hits := 0;
  for ctr := 0 to 23 do
    begin
      location[ctr] := char(ctr+65);
      location[ctr+24] := location[ctr];
      location[ctr+48] := location[ctr];
    end;
  temp := 18;
  for ctr := 0 to 5 do
    begin
      column[ctr] := temp + 10 * ctr;
      column[ctr+24] := column[ctr];
      column[ctr+48] := column[ctr];
    end;
  temp := 0;
  for ctr := 6 to 11 do
    begin
      column[ctr] := 16 + temp * 10;
      column[ctr+24] := column[ctr];
      column[ctr+48] := column[ctr];
      temp := temp + 1;
    end;
  temp := 0;
  for ctr := 12 to 17 do
    begin
      column[ctr] := 14 + temp * 10;
      column[ctr+24] := column[ctr];
      column[ctr+48] := column[ctr];
      temp := temp + 1;
    end;
  temp := 0;
  for ctr := 18 to 23 do
    begin
      column[ctr] := 12 + temp * 10;
      column[ctr+24] := column[ctr];
      column[ctr+48] := column[ctr];
      temp := temp + 1;
    end;
  temp := 9;
  for ctr := 0 to 5 do
    begin
      row[ctr] := temp;
      row[ctr+6] := temp + 1;
      row[ctr+12] := temp + 2;
      row[ctr+18] := temp + 3;
    end;
  temp := 14;
  for ctr := 24 to 29 do
    begin
      row[ctr] := temp;
      row[ctr+6] := temp + 1;
      row[ctr+12] := temp + 2;
      row[ctr+18] := temp + 3;
    end;
  temp := 19;
  for ctr := 48 to 53 do
    begin
      row[ctr] := temp;
      row[ctr+6] := temp + 1;
      row[ctr+12] := temp + 2;
      row[ctr+18] := temp + 3;
    end;
  repeat
    hide1 := trunc(random * 24);
  until ((hide1 > 6) and (hide1 < 11)) or ((hide1 > 12) and (hide1 < 17));
  hide1 := hide1 + (trunc(random * 3) * 24);
  hidetype := random(8) + 1;
  case hidetype of
    1:begin hide2 := hide1 + 1;hide3 := hide1 - 1 end;
    2:begin hide2 := hide1 + 7;hide3 := hide1 - 7 end;
    3:begin hide2 := hide1 + 6;hide3 := hide1 - 6 end;
    4:begin hide2 := hide1 + 5;hide3 := hide1 - 5 end;
    5:begin hide2 := hide1 - 1;hide3 := hide1 + 1 end;
    6:begin hide2 := hide1 - 7;hide3 := hide1 + 7 end;
    7:begin hide2 := hide1 - 6;hide3 := hide1 + 6 end;
    8:begin hide2 := hide1 - 5;hide3 := hide1 + 5 end;
  end;
  sub[1] := hide1;
  sub[2] := hide2;
  sub[3] := hide3;
end;

procedure gotobottom;
begin
  locate(24,1);
  prompt('                                                                              ');
  locate(24,1);
  ansic(0);
  checkhangup;
end;

procedure drawship;
begin
  ansic(6);
  print('                                       ×     ±±±                               ');
  ansic(6);
  print('                                       ×     ×   Û Û                           ');
  ansic(6);
  print('                                      ²²²²   ×   Û Û                           ');
  ansic(6);
  print('                           ÄÜÜ      ÛÛÛÛÛÛÛ  ×   Û Û      ÜÜÄ                  ');
  ansic(6);
  print('                  Õ      ®ÍÛÛÛÛ     Û±±Û±±Û±±Û±±±±±±Û    ÛÛÛÛÍ¯         Ò      ');
  ansic(6);
  print('                  ßÛÛ²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²ÛÛ      ');
  ansic(6);
  print('                    ßÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛß       ');
  ansic(0);
end;

procedure playershots;
var
ctr,temp,shots,drop : integer;
level,quadrant      : char;
begin
  cls;ansic(6);
  for ctr := 1 to 23 do
    begin
      locate(ctr,1);
      prompt('                                                                                ');
    end;
  locate(1,1);drawship;ansic(6);
  locate(7,14);prompt('_______');
  locate(7,73);prompt('______');
  locate(12,71);prompt('__________');
  locate(17,71);prompt('__________');
  temp := 13;
  for ctr := 8 to 13 do
    begin
      locate(ctr,temp);
      prompt('/                                                                /');
      temp := temp - 2;
    end;
  temp := 13;
  for ctr := 14 to 18 do
    begin
      locate(ctr,temp);
      prompt('/                                                                /');
      temp := temp - 2;
    end;
  temp := 13;
  for ctr := 19 to 23 do
    begin
      locate(ctr,temp);
      prompt('/                                                                /');
      temp := temp - 2;
    end;
  locate(13,70);prompt('          /');
  locate(18,71);prompt('         /');
  locate(13,4);
  prompt('________________________________________________________________');
  temp := 18;
  for ctr := 0 to 1 do
    begin
      locate(temp + ctr * 5,6);
      prompt('_______________________________________________________________');
    end;
  temp := 10;
  for ctr := 0 to 2 do
    begin
      locate(temp + ctr * 5,74);
      prompt('LEVEL '+cstr(ctr+1));
    end;
  for ctr := 0 to 71 do
    begin
      locate(row[ctr],column[ctr]);
      if location[ctr] = '*' then
        begin
          ansic(8);prompt(location[ctr]);ansic(6);
        end
      else
        prompt(location[ctr]);
    end;
  ansic(0);
  shots := 0;
  repeat
    gotobottom;
    prt('Choose a level [1-3,Q=Quit]: ');
    onek(level,'123Q');
    if level = 'Q' then
      begin
        sysoplog('Sub Battle aborted by user');
        return;
      end;
    locate(24,40);
    prt('Choose a quadrant [A-X,0=Quit]: ');
    onek(quadrant,'ABCDEFGHIJKLMNOPQRSTUVWX0');
    if quadrant = '0' then
      begin
        sysoplog('Sub Battle aborted by user');
        return;
      end;
    drop := (24 * (value(level) - 1)) + (ord(quadrant) - 65);
    if (drop = sub[1]) or (drop = sub[2]) or (drop = sub[3]) then
      location[drop] := '*'
    else
      location[drop] := ' ';
    locate(row[drop],column[drop]);
    if location[drop] = '*' then
      begin
        ansic(8);prompt(location[drop]);ansic(0);
      end
    else
      prompt(location[drop]);
    shots := shots + 1;tries := tries + 1;
    if (location[sub[1]] = '*') and (location[sub[2]] = '*') and (location[sub[3]] = '*') then
      begin
        gameover := true;wongame := true;
        gotobottom;ansic(7);
        prompt('You Won!  The Sub is scrap metal!');ansic(0);
        delay(3000);gotobottom;
      end;
  until (shots = 3) or gameover or hangup;
  if not(gameover) then
    begin
      gotobottom;ansic(3);
      prompt('Now it''s the sub''s turn to fire...');ansic(0);
      delay(3000);gotobottom;
    end;
  pausescr;
end;

procedure subshot;
var
hit : boolean;
ctr,temp : integer;
begin
  cls;
  ansic(6);
  print('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  ansic(6);
  print('³                      Ä              ³                                   ³');
  ansic(6);
  print('³                  40 ÄÄ              ³                                   ³');
  ansic(6);
  print('³                      Ä     Ë        ³                                   ³');
  ansic(6);
  print('³                  30 ÄÄ     ×       ±±±                                  ³');
  ansic(6);
  print('³                      Ä     ×       ×³                                   ³');
  ansic(6);
  print('³                  20 ÄÄ     ×       ×³  ÛÛ ÛÛ                            ³');
  ansic(6);
  print('³                      Ä    ²²²²²    ×³  ÛÛ ÛÛ                            ³');
  ansic(6);
  print('³              ÄÜÜ 10 ÄÄ   ÛÛÛÛÛÛÛ   ×³  ÛÛ ÛÛ           ÜÜÄ              ³');
  ansic(6);
  print('³    Õ       ®ÍÛÛÛÛ    Û±±±Û±±Û±±Û±±ÛÛ±±±±±±±±±Û        ÛÛÛÛÍ¯       Ò    ³');
  ansic(6);
  print('³    ßßÛÛ²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²ÛÛ    ³');
  ansic(6);
  print('ÃÄÄÄÄÄÄÄßÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛßßÄÄÄÄÄ´');
  ansic(6);
  print('³                 -10 ÄÄ              ³                                   ³');
  ansic(6);
  print('³                      Ä              ³                                   ³');
  ansic(6);
  print('³                 -20 ÄÄ              ³                                   ³');
  ansic(6);
  print('³                      Ä              ³                                   ³');
  ansic(6);
  print('³ Å ³ Å ³ Å ³ Å ³ Å ³ ÅÄÅ ³ Å ³ Å ³ Å ³ Å ³ Å ³ Å ³ Å ³ Å ³ Å ³ Å ³ Å ³ Å ³');
  ansic(6);
  print('³ 1   2   3   4   5   6Ä    7   8   9 ³-9  -8  -7  -6  -5  -4  -3  -2  -1 ³');
  ansic(6);
  print('³                 -30 ÄÄ              ³                                   ³');
  ansic(6);
  print('³                      Ä              ³                                   ³');
  ansic(6);
  print('³                 -40 ÄÄ              ³                                   ³');
  ansic(6);
  print('³                     ÄÄ              ³                                   ³');
  ansic(6);
  print('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
  ansic(0);
  hit := false;
  if random < 0.5 then hit := true;
  gotobottom;
  ansic(4);prompt('The Sub launches a torpedo at your ship...');ansic(0);
  for ctr := 1 to 3 do
    begin
      prompt(#7);
      delay(1000);
    end;
  temp := 22;
  repeat
    locate(temp,38);ansic(4);
    prompt('Þ');
    delay(300);
    locate(temp,38);ansic(6);
    prompt(' ');
    temp := temp - 1;
  until (temp = 12) or hangup;
  ansic(0);
  if hit then
    begin
      gotobottom;
      ansic(5);
      prompt('It''s a hit!!      ');
      ansic(8);
      locate(12,38);prompt('o');
      for ctr := 37 to 39 do
        begin
          locate(11,ctr);prompt('o');
        end;
      for ctr := 36 to 40 do
        begin
          locate(10,ctr);prompt('o');
        end;
      for ctr := 35 to 41 do
        begin
          locate(9,ctr);prompt('o');
        end;
      locate(8,32);prompt('o');
      locate(8,35);prompt('o');
      locate(8,40);prompt('o');
      ansic(0);
      hits := hits + 1;
    end
  else
    begin
      gotobottom;ansic(7);
      prompt('...the torpedo missed, Captain.');
    end;
  delay(4000);
  gotobottom;
  if hits = 3 then
    begin
      ansic(7);prompt('Your ship is history!!!');
      gameover := true;
      delay(3000);
      gotobottom;
    end;
  pausescr;
end;

procedure playerwon;
begin
  sysoplog('Won at Sub Battle');
  cls;
  locate(4,10);
  ansic(4);
  prompt('Congradulations, Captain '+thisuser.name+'!');
  locate(5,10);
  prompt('You have accomplished your mission and used');
  locate(6,10);
  prompt('only '+cstr(tries)+' depth charges. ');
  locate(7,10);
  prompt('Your promotion is on the way!');
  nl;nl;
  if tries < low then
    begin
      sysoplog('New low score in Sub Battle');
      locate(15,27);
      ansic(8);
      prompt('You have the new low score!');
      assign(lofile,gfilespath+'sub.scr');
      rewrite(lofile);
      writeln(lofile,thisuser.name);
      writeln(lofile,cstr(tries));
      close(lofile);
    end;
  gotobottom;pausescr;
end;

procedure playerlost;
begin
  sysoplog('Lost at Sub Battle');
  cls;ansic(7);
  locate(4,10);
  prompt('We are very sorry, Captain '+thisuser.name+'.');
  locate(5,10);
  prompt('Your ship was lost and your crew killed!');
  locate(6,10);
  prompt('You should be Court-Martialed for your poor');
  locate(7,10);
  prompt('judgement and performance!');
  gotobottom;pausescr;
end;

begin
  iport;
  if not(okansi) then
    begin
      nl;print('Sorry, but you must have ANSI graphics to play this game.');
      nl;pausescr;
      return;
    end;
  introduction;
  initialize;
  repeat
    playershots;
    if not(gameover) then
      subshot;
  until gameover or hangup;
  if not(hangup) then
    begin
      if wongame then
        playerwon
      else
        playerlost;
    end;
  return;
end.


