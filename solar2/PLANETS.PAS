
overlay procedure checkrank;
var exp:integer; thisrank:str;
begin
   exp:=solar.experience;
   if exp<=25 then thisrank:=rank1;
   if (exp>=26) and (exp<50) then thisrank:=rank2;
   if (exp>=50) and (exp<75) then thisrank:=rank3;
   if (exp>=75) and (exp<150) then thisrank:=rank4;
   if (exp>=150) and (exp<200) then thisrank:=rank5;
   if (exp>=200) and (exp<300) then thisrank:=rank6;
   if (exp>=300) and (exp<400) then thisrank:=rank7;
   if (exp>=400) and (exp<550) then thisrank:=rank8;
   if (exp>=550) and (exp<650) then thisrank:=rank9;
   if exp>=650 then thisrank:=rank10;
   if thisrank=solar.rank then nl else
     begin
     solar.rank:=thisrank;
     Print('Because of your battle skills, you recieve a promotion.');
     print('You are now a '+solar.rank);
     writepromo('!  '+solar.name+' was promoted to '+thisrank+' / '+date);
   end;
end;



(*
overlay procedure left;
     begin
        if thisplanet=planet1 then writebarf1('- '+cstr(solar.number)+' '+solar.name+' left on /  '+date)
        else if thisplanet=planet2 then writebarf2('- '+cstr(solar.number)+' '+solar.name+' left on /  '+date)
        else if thisplanet=planet3 then writebarf3('- '+cstr(solar.number)+' '+solar.name+' left on /  '+date)
        else if thisplanet=planet4 then writebarf4('- '+cstr(solar.number)+' '+solar.name+' left on /  '+date)
        else if thisplanet=planet5 then writebarf5('- '+cstr(solar.number)+' '+solar.name+' left on /  '+date)
        else if thisplanet=planet6 then writebarf6('- '+cstr(solar.number)+' '+solar.name+' left on /  '+date)
        else if thisplanet=planet7 then writebarf7('- '+cstr(solar.number)+' '+solar.name+' left on /  '+date)
        else if thisplanet=planet8 then writebarf8('- '+cstr(solar.number)+' '+solar.name+' left on /  '+date)
        else if thisplanet=planet9 then writebarf9('- '+cstr(solar.number)+' '+solar.name+' left on /  '+date);
      end;

overlay procedure arrived;
  begin
  if thisplanet=planet1 then writebarf1('+ '+cstr(solar.number)+' '+solar.name+' arrived on /  '+date)
  else if thisplanet=planet2 then writebarf2('+ '+cstr(solar.number)+' '+solar.name+' arrived on /  '+date)
  else if thisplanet=planet3 then writebarf3('+ '+cstr(solar.number)+' '+solar.name+' arrived on /  '+date)
  else if thisplanet=planet4 then writebarf4('+ '+cstr(solar.number)+' '+solar.name+' arrived on /  '+date)
  else if thisplanet=planet5 then writebarf5('+ '+cstr(solar.number)+' '+solar.name+' arrived on /  '+date)
  else if thisplanet=planet6 then writebarf6('+ '+cstr(solar.number)+' '+solar.name+' arrived on /  '+date)
  else if thisplanet=planet7 then writebarf7('+ '+cstr(solar.number)+' '+solar.name+' arrived on /  '+date)
  else if thisplanet=planet8 then writebarf8('+ '+cstr(solar.number)+' '+solar.name+' arrived on /  '+date)
  else if thisplanet=planet9 then writebarf9('+ '+cstr(solar.number)+' '+solar.name+' arrived on /  '+date);
  end;*)



procedure finduser;
var stopit:boolean; temphp,damage,exp,k:integer; nn:str;
  begin
    stopit:=false;
    print('Enter Solar Warrior Number: '); input(nn,3);
    k:=value(nn); if k>1 then begin
    getotherdata(k);
    nl;
    if other.planetnum=solar.planetnum then begin
    if other.name=solar.name then print('I dont believe that Solar Warrior is in this bar..')
    else begin
    if (other.name<>solar.name) and (not other.dead) then
      begin
      print('You look across the bar and you see '+Other.name+' drinking a Coors');
      print('You put your hand on his shoulder and pull him out of his seat');
      print('Hey.. But silly you you left your Equipment at the door of the bar.');
      print('It looks like you are going to have to fight it hand to hand...');
      damage:=fistdam;
      print('Uh oh, '+other.name+' looks alot bigger when he stands up..'); end;
    if (other.name<>solar.name) and ( other.dead) then
    print(other.name+' is dead, but he might have some things on him...');
      temphp:=other.hp;
        nl;
        repeat checkhangup;
        ynq('Do you attack?');
        if yn then begin
          spaceflip;
          if other.dead then solarw2:=1;
          nl;
          if solarw>=solarw2 then begin
            ansic(3);
            Print('You hit him.. Doing a Damage of '+cstr(damage));
            temphp:=temphp-1;
            ansic(3);
            print('This solar warrior has now '+cstr(temphp)+' hitpoints');
            if temphp<1 then stopit:=true; end
          else begin
            Print('You missed. Now its his turn...');
            spaceflip;
            if solarw2>=solarw then begin
            ansic(4);
              print('He hits you with a damage of '+cstr(damage));
              solar.hp:=solar.hp-1;
            ansic(4); print('Your hit points are now '+cstr(solar.hp));
              if solar.hp<1 then begin
                solar.dead:=true;
                print('You are Killed Solar Warrior...');
                dead;
                savedata;
              end;
            end;
            if solarw2<solarw then begin
              print('He missed ya...');
            end;
          end;
        end
        else begin print('You run away and hide.. Coward.'); stopit:=true; end;
      until stopit;
      if temphp<1 then begin
        print('You knocked out '+other.name+', Quick take one of his items before he wakes up.');
        nl;
        print('Name         : '+other.name);
        print('1: Fuel      : '+cstr(other.fuel));
        print('2: Lazer Ammo: '+cstr(other.magazine));
        print('3: Grenades  : '+cstr(other.grenades));
        print('4: Cannon     : '+cstr(other.Cannon));
        print('5: Credits   : '+cstr(other.credits));
        print('6: First Aid : '+cstr(other.aid));
        if other.key then
        print('7: Radium Chrystles');
        nl;
        prompt('Which on do ya want?');
        onek(op,'1234567');
        case op of
          '1':begin other.planetnum:=solar.planetnum; solar.fuel:=solar.fuel+other.fuel; other.fuel:=0; end;
          '2':begin other.planetnum:=solar.planetnum; solar.magazine:=solar.magazine+other.magazine;
              other.magazine:=0; end;
          '3':begin other.planetnum:=solar.planetnum; solar.grenades:=solar.grenades+other.grenades;
              other.grenades:=0; end;
          '4':begin other.planetnum:=solar.planetnum; solar.Cannon:=solar.Cannon+other.Cannon; other.Cannon:=0; end;
          '5':begin other.planetnum:=solar.planetnum; solar.credits:=solar.credits+other.credits; other.credits:=0; end;
          '6':begin other.planetnum:=solar.planetnum; solar.aid:=solar.aid+other.aid; other.aid:=0; end;
          '7':begin
              if other.key then begin
                other.key:=false; solar.key:=true; end
              else print('He doesn''t have the Radium Chrystles. '+other.name+' wakes up...');
              end;

        end;
        if not other.dead then begin
        exp:=random(10)+1;
        print('For that battle you recieve '+cstr(exp)+' experience points...');
        solar.experience:=solar.experience+exp; end;
        begin
        writebarf1('* '+solar.name+' beat up '+other.name+' / '+date);

        (*else if thisplanet=planet2 then writebarf2('* '+solar.name+' beat up '+other.name+' / '+date)
        else if thisplanet=planet3 then writebarf3('* '+solar.name+' beat up '+other.name+' / '+date)
        else if thisplanet=planet4 then writebarf4('* '+solar.name+' beat up '+other.name+' / '+date)
        else if thisplanet=planet5 then writebarf5('* '+solar.name+' beat up '+other.name+' / '+date)
        else if thisplanet=planet6 then writebarf6('* '+solar.name+' beat up '+other.name+' / '+date)
        else if thisplanet=planet7 then writebarf7('* '+solar.name+' beat up '+other.name+' / '+date)
        else if thisplanet=planet8 then writebarf8('* '+solar.name+' beat up '+other.name+' / '+date)
        else if thisplanet=planet9 then writebarf9('* '+solar.name+' beat up '+other.name+' / '+date);****)

        end;
        saveother1;
        saveother;
        getotherdata(solar.number);
        saveother1;
      end;
      end;
    end
    else print('I dont believe that Solar Warrior is in this bar...');
    saveother;
  end
  else print('Who are you talking about?????');
end;




procedure spaceflip;
begin
  fa:=random(8)+1;
  fb:=random(8)+1;
  fc:=random(8);
  death2:=random(6)+1;
  death1:=random(7)+1;
  death:=random(6)+2;
  worm:=random(6)+1;
  warrior5:=random(7)+1;
  warrior4:=random(6)+1;
  warrior3:=random(7)+2;
  warrior2:=random(7)+1;
  warrior1:=random(6)+1;
  warrior:=random(7)+1;
  flesh:=fa+fb+fc;
  reaper:=death+death1+death2;
  space:=worm+worm+worm;
  solarw2:=warrior3+warrior4+warrior5;
  solarw:=warrior1+warrior2+warrior;
end;




procedure wormattack;
var exp,randomfuel,damage,swhp,i:integer; wormdead,continue:boolean;
begin
wormdead:=false;
  continue:=false;
  print('Because of the fumes from your Jet Pack, a Space Worm Attacks;');
  swhp:=random(8)+5;
  nl;
  print('There is no place to run, so you have to fight.');
  nl;
repeat checkhangup;
  repeat checkhangup;
    nl;
    print('1: Hands  2:Lazer Gun  3:Grenade  4:Cannon  5:Heal  6:Status');
    prompt('Which Weapon do you use? '); onek(op,'123456');
    nl;
    case op of
    '1':begin damage:=fistdam; continue:=true; end;
    '2':
    begin
      if solar.magazine>0 then begin
        damage:=lazerdam;
        solar.magazine:=solar.magazine-1;
        solarw:=1;
        continue:=true;
      end
      else begin print('You dont have any Lazers....'); continue:=false; end;
    end;
    '3':
    begin
      if solar.grenades>0 then begin
        damage:=grenadedam;
        solar.grenades:=solar.grenades-1;
        solarw:=2;
        continue:=true;
      end
      else begin print('You dont have any grenades...'); continue:=false; end;
    end;
    '4':begin
      if solar.Cannon>0 then begin
        damage:=Cannondam;
        solar.Cannon:=solar.Cannon-1;
        solarw:=5;
        continue:=true;
      end
      else begin print('You dont have a Cannon...'); continue:=false; end; end;
    '5':heal;
    '6':status;
    end;
  until continue;
  spaceflip;
  if solarw>=space then
    begin
    nl;
      swhp:=swhp-damage;
      ansic(4);
      print('You did a damage of '+cstr(damage)+', the Space Worm has '+cstr(swhp)+' hit pionts now.');
    end else
    begin
    nl;
      print('You missed, Now The Worm Attacks....');
      spaceflip;
      if space>solarw then begin
      nl;
        ansic(7);
        print('He hits you.. doing a damage of '+cstr(wormdam));
        solar.hp:=solar.hp-wormdam;
        nl;
        print('You now have '+cstr(solar.hp)+' hit points');
      end else begin
      nl;
      print('He missed ya.. hahahha!'); end;
    end;
  if swhp<1 then wormdead:=true;
  if solar.hp<1 then begin solar.dead:=true;
dead; savedata; end;
until wormdead;
print('You defeated the space worm.');
randomfuel:=random(3)+1;
exp:=random(10)+5;
print('For that Battle, you recieve '+cstr(exp)+' experience points...');
nl;
solar.experience:=solar.experience+exp;
print('Floating around the dead worm you find '+cstr(randomfuel)+' Chrystlarium...');
solar.fuel:=solar.fuel+randomfuel;
nl;
print('Continue with your voyage.');
end;


procedure flip;
var i:integer;
begin
setc(4);
i:=random(8)+1;
if i=1 then wormattack
else prompt('.');
end;

procedure journey;
begin
if (thisthing=1) then begin delay(700); flip; end;
if (thisthing>=2) and (thisthing<5) then begin delay(700); flip; delay(700); flip; end;
if (thisthing>=5) and (thisthing<8) then begin delay(700); flip; delay(700); flip;
                          delay(700); flip; end;
if (thisthing>=8) and (thisthing<12) then begin delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip; end;
if (thisthing>=12) and (thisthing<15) then begin delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip;
                          delay(700); flip; end;
if (thisthing>=15) and (thisthing<18) then begin delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip; end;
if (thisthing>=18) and (thisthing<20) then begin delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip;
                          delay(700); flip; end;
if (thisthing>=20) and (thisthing<24) then begin delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip; end;
if thisthing>=24 then begin delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip;
                          delay(700); flip; delay(700); flip;
                          delay(700); flip; end;
end;


procedure heal;
var j,a,moneynow,price:integer; ok:boolean;
begin
cls;
ok:=false; ansic(3);
  print('You have '+cstr(solar.aid)+' First Aid Kits. One Kit heals one hit point.');
  ansic(4);
  print('You have '+cstr(solar.hp)+' Hit Points, the most you can have is '+cstr(orghp));
         if solar.aid>0 then begin
           prompt('How many do you want?'); ino(a);
           price:=a;  moneynow:=solar.aid-price;
           j:=solar.hp+a;
           if j>orghp then begin  print('You aren''t that badly hurt.'); ok:=true; end
           else begin
             if (moneynow<0) and (not ok) then
             print('You dont have enough.');
             if moneynow>=0 then begin
               solar.aid:=moneynow;
               nl;
               print('That cost you '+cstr(price)+' First Aids.');
               solar.hp:=solar.hp+a;
             end;
           end;
         end;
       end;


procedure status;
var a:str; ka:integer;
begin
if solar.planetnum=planet1 then a:='Mercury';
if solar.planetnum=planet2 then a:='Venus';
if solar.planetnum=planet3 then a:='Earth';
if solar.planetnum=planet4 then a:='Mars';
if solar.planetnum=planet5 then a:='Jupiter';
if solar.planetnum=planet6 then a:='Saturn';
if solar.planetnum=planet7 then a:='Uranus';
if solar.planetnum=planet8 then a:='Neptune';
if solar.planetnum=planet9 then a:='Pluto';
nl;
setc(13);  print('Name       : '+solar.name);
setc(13);  print('Rank       : '+solar.rank);
setc(13);  print('Planet     : '+a);
setc(13);  print('Hit Points : '+cstr(solar.hp)+'/'+cstr(orghp));
setc(13);  print('Times on   : '+cstr(solar.timeson));
setc(13);  print('Fuel       : '+cstr(solar.fuel));
setc(13);  print('Lazer Ammo : '+cstr(solar.magazine));
setc(13);  print('Grenades   : '+cstr(solar.grenades));
setc(13);  print('Cannon     : '+cstr(solar.Cannon));
setc(13);  print('Credits    : '+cstr(solar.credits));
setc(13);  print('First Aid  : '+cstr(solar.aid));
setc(13);  print('Experience : '+cstr(solar.experience));
setc(13);  print('Turns      : '+cstr(solar.Turns));
  if solar.key then begin
setc(14);  print(' HAS FOUND RADIUM CHRYSTLES '); end;
end;

overlay procedure blackmenu;
begin
nl;
print('You enter a small room in the bar and all around you, you see:');
print('Chrystlarium, Lazer Magazines, Grenades, Cannons, And First Aid Kits.');
print('You can also Sell fuel, See your sTatus, or Quit...');
print('S:ell Fuel    T:status ');
print('C:hrystlarium L:azers  ');
print('G:renades     N:Cannons');
print('F:irst Aid    Q:uit    ');

end;

procedure blackmarket;
var a,price,moneynow:integer; noblack:boolean;
begin
nl;
noblack:=false;
blackmenu;
repeat checkhangup;
nl;
nl;
ansic(4);
 print('(C,L,G,N,F,S,T,Q,?)');
 ansic(3);
prompt('( What would you like?  " ? " gives you menu:');
onek(op,'CLGFQST?N');
  case op of
  '?': blackmenu;
  'C': begin
         Print(' Chrystarium costs 10 credits a chrystle ');
         if solar.credits>=10 then begin
           prompt('How many do you want?'); ino(a);
           price:=a*10;  moneynow:=solar.credits-price;
           if moneynow<0 then
           print('Yo Homes! Wassup wi''tch you.. You dont have enough.')
           else begin
             solar.credits:=moneynow;
             nl;
             print('You now have '+cstr(solar.credits)+' credits.');
             print('Thanks YO! It be nice doin'' buisness wi''tch you .');
             solar.fuel:=solar.fuel+a;
           end;
         end;
       end;
  'T':status;
  'G': begin
         Print(' Grenades costs 8 credits a piece');
         if solar.credits>=8 then begin
           prompt('How many do you want?'); ino(a);
           price:=a*8;  moneynow:=solar.credits-price;
           if moneynow<0 then
           print('Yo man! you Diss''n me... You dont have enough.')
           else begin
             solar.credits:=moneynow;
             nl;
             print('You now have '+cstr(solar.credits)+' credits.');
             print('Thanks YO! It be nice doin'' buisness wi''tch you .');
             solar.grenades:=solar.grenades+a;
           end;
         end;
       end;
   'L': begin
        Print(' Lazer Ammunition costs 5 credits a piece');
         if solar.credits>=5 then begin
           prompt('How many do you want?'); ino(a);
           price:=a*5;  moneynow:=solar.credits-price;
           if moneynow<0 then
           print('Yo man! you Diss''n me... You dont have enough.')
           else begin
             solar.credits:=moneynow;
             nl;
             print('You now have '+cstr(solar.credits)+' credits.');
             print('Thanks YO! It be nice doin'' buisness wi''tch you .');
             solar.magazine:=solar.magazine+a;
           end;
         end;
       end;
    'F': begin
        Print(' First Aid Kits costs 2 credits a piece');
         if solar.credits>=2 then begin
           prompt('How many do you want?'); ino(a);
           price:=a*2;  moneynow:=solar.credits-price;
           if moneynow<0 then
           print('Yo man! you Diss''n me... You dont have enough.')
           else begin
             solar.credits:=moneynow;
             nl;
             print('You now have '+cstr(solar.credits)+' credits.');
             print('Thanks YO! It be nice doin'' buisness wi''tch you .');
             solar.aid:=solar.aid+a;
           end;
         end;
       end;
     'N': begin
        Print(' Photon Cannons costs 20 credits a piece');
         if solar.credits>=20 then begin
           prompt('How many do you want?'); ino(a);
           price:=a*20;  moneynow:=solar.credits-price;
           if moneynow<0 then
           print('Yo man! you Diss''n me... You dont have enough.')
           else begin
             solar.credits:=moneynow;
             nl;
             print('You now have '+cstr(solar.credits)+' credits.');
             print('Thanks YO! It be nice doin'' buisness wi''tch you .');
             solar.Cannon:=solar.Cannon+a;
           end;
         end;
       end;
     'S': begin
          Print('Yo! We''ll buy yo Chrystlarium fo'' 5 credits a chrystle');
          prompt('How many you wa'' Sell? [ You have '+cstr(solar.fuel)+' chrystles ]:');
          ino(a); moneynow:=solar.fuel-a;
          if moneynow<0 then
          print('Yo! Trayvon. Can you believe this Dude wants to sell me stuff he aint got.')
          else begin
            price:=a*5;
            solar.fuel:=solar.fuel-a;
            solar.credits:=solar.credits+price;
            nl;
            print('You now have '+cstr(solar.fuel)+' fuel, and '+cstr(solar.credits)+' credits.');
          end;
        end;
    'Q': noblack:=true;
end;
until noblack;
end;



procedure barmenu;
begin
nl;
ansic(6);  print('R: ( Get a room for the night, Quit game.  )');
ansic(6);  print('B: ( Go to the Black Market.               )');
ansic(6);  print('H: ( Heal lost hit points.                 )');
ansic(6);  print('L: ( Listen to Rumors                      )');
Ansic(6);  print('T: ( Take a look, to see who is in the bar )');
ansic(6);  print('Q: ( Leave Bar.                            )');
ansic(6);  print('?: ( This Menu.                            )');
ansic(6);  print('F: ( Fight a user at the Bar               )');
  nl;
end;


overlay procedure ulist;
var ct,inte:integer; abort,next:boolean;
begin
  nl;
  print('Users in this Bar:');
  nl;
  reset(otherfile); ct:=0;
  inte:=0; abort:=false;
  while (not abort) and (inte<500) do begin
    inte:=inte+1;
    seek(otherfile,inte); read(otherfile,other);
    if other.planetnum=thisplanet then begin
      printacr(other.name+' #'+cstr(other.number),abort,next);
      ct:=ct+1;
    end;
  end;
  close(otherfile);
end;

procedure bar;
var barname:string[25]; now:boolean;
begin
  if thisplanet=planet1 then begin barname:='The Sizzler'; end;
  if thisplanet=planet2 then begin barname:='Wind Chimes'; end;
  if thisplanet=planet3 then begin barname:='Hammerjacks'; end;
  if thisplanet=planet4 then begin barname:='The Red Hills'; end;
  if thisplanet=planet5 then begin barname:='Swirlers'; end;
  if thisplanet=planet6 then begin barname:='The Golden Rings'; end;
  if thisplanet=planet7 then begin barname:='Ice Castles'; end;
  if thisplanet=planet8 then begin barname:='Tide Waters'; end;
  if thisplanet=planet9 then begin barname:='Frostie''s'; end;
  cls;
  now:=false;
  repeat checkhangup;
  if thisplanet=planet1 then setc(220);
  if thisplanet=planet2 then setc(203);
  if thisplanet=planet3 then setc(156);
  if thisplanet=planet4 then setc(140);
  if thisplanet=planet5 then setc(222);
  if thisplanet=planet6 then setc(155);
  if thisplanet=planet7 then setc(202);
  if thisplanet=planet8 then setc(250);
  if thisplanet=planet9 then setc(141);
    prompt('<'+barname+'>');
    onek(op,'T!LSBRQH?F');
    case op of
      'R':savedata;
      'H':heal;
      'B':blackmarket;
      'Q':begin
        now:=true; end;
      '?':barmenu;
      'S':status;
      'F':finduser;
      'T':ulist;
      'L':begin
          printfile('bar1.log')

       (******else if thisplanet=planet2 then printfile('bar2.log')
        else if thisplanet=planet3 then printfile('bar3.log')
        else if thisplanet=planet4 then printfile('bar4.log')
        else if thisplanet=planet5 then printfile('bar5.log')
        else if thisplanet=planet6 then printfile('bar6.log')
        else if thisplanet=planet7 then printfile('bar7.log')
        else if thisplanet=planet8 then printfile('bar8.log')
        else if thisplanet=planet9 then printfile('bar9.log');*****)

         end;
    end;
  until now;
end;



overlay procedure planetmenu;
  begin
  nl;
    print('I:structions on how to play');
    print('C:aves ( There are no caves on Earth )');
    print('B:ar');
    print('L:eave Planet');
    print('S:tatus');
    print('H:eal wounds');
    print('*:How much fuel needed to fly form one planet to the other.');
    print('G: if on Earth Deposit Radium Chrystles...');
setc(11);
    print(' Note: To Quit Solar Warrior you must be in a BAR');
  end;

overlay procedure go;
       begin
          if not solar.key then print(solar.name+' you dont have the Radium Chrystles..')
          else begin
            prompt('Quick Solar Warrior, what are the first 2 letters of the code? :'); input(this,2);
            prompt('Quick Solar Warrior, what are the Second 2 letters of the code? :'); input(thing,2);
            prompt('Quick Solar Warrior, what are the Last 2 letters of the code? :'); input(now,2);
            if (this=gm.code1) and (thing=gm.code2) and (now=gm.code3)
            then begin
            nl;
            nl;
             ansic(8);
              print('You have won the game Solar Warrior..');
              ansic(8);
              print('For that you recieve 15 Cow Chips..');
              thisuser.forusr:=thisuser.forusr+15;
              nl;
              begin
                assign(newfile,'winners.txt');
                {$I-} append(newfile); {$I+}
                if (ioresult<>0) then begin
                  rewrite(newfile);
                  writeln(newfile,'Winners at Solar Warrior :');
                end else
                writeln(' ');
                writeln(newfile,solar.rank+' '+thisuser.name+' '+date);
                close(newfile);
                wongame:=true;
                solar.key:=false;
                savedata;
              end;
            end
            else print('That is the incorrect code. You must find the correct one');
          end;
          end;






procedure earth;
var i:integer;
begin
if solar.dead then begin print('You were killed bucko .. try next time');
dead; savedata;
end;
  if travel then begin
  i:=thisplanet-planet3;
  if i=0 then print('You are Already there Solar Warrior...');
  if i>0 then solar.fuel:=solar.fuel-i;
  if i<0 then solar.fuel:=solar.fuel+i;
  solar.planetnum:=thisplanet;
    print('You have '+cstr(solar.fuel)+' fuel left from the voyage..');
  end;
  nl; nl;
  getout:=false;
  repeat checkhangup;
  checkrank;
  travel:=false;
  thisplanet:=3;
  solar.planetnum:=thisplanet;
    nl;
    Ansic(4);
    nl;
    setc(26);
    prompt('[Earth> "?" gets menu: ');
    onek(op,'21G?*HLBSI');
    case op of
      'B':Bar;
      '2':ulist;
      'L':begin  Leave; end;
      'S':status;
      'H':heal;
      '*':howmuch;
      '?':planetmenu;
      'I':printfile('instruct.txt');
      'G':go;
      '1':if cs then begin
          print(' Radium Chrystles : '+cstr(gm.keynumber));
          print(' Hologram         : '+cstr(gm.oldnumber));
          end;
      end;
    until getout or hangup;
    if getout then savedata;
  end;



procedure Pluto;
var temphp,i:integer; stopit,quitit:boolean; planetname:str; damage,k:integer;
begin
if solar.dead then begin print('You were killed bucko .. try next time');
dead;
savedata; end;
if travel then
  begin
  if thisplanet=24 then begin
    i:=solar.planetnum-planet9; end
   else if thisplanet=1 then begin
    i:=solar.planetnum-planet1; end
   else if thisplanet=2 then begin
    i:=solar.planetnum-planet2; end
   else if thisplanet=4 then begin
    i:=solar.planetnum-planet4; end
   else if thisplanet=6 then begin
    i:=solar.planetnum-planet5; end
   else if thisplanet=8 then begin
    i:=solar.planetnum-planet6; end
   else if thisplanet=12 then begin
    i:=solar.planetnum-planet7; end
   else if thisplanet=17 then begin
    i:=solar.planetnum-planet8; end;
    if i=0 then print('You are already there, Solar Warrior...');
    if i>0 then solar.fuel:=solar.fuel-i;
    if i<0 then solar.fuel:=solar.fuel+i;
    solar.planetnum:=thisplanet;
    print('You have '+cstr(solar.fuel)+' fuel left from the voyage..');
  nl; nl;
  end;
  thisplanet:=solar.planetnum;
  quitit:=false;
  repeat checkhangup;
  checkrank;
  travel:=false;
    begin
    thisplanet:=solar.planetnum;
    if solar.planetnum=1 then begin setc(76); planetname:='Mercury'; end;
    if solar.planetnum=2 then begin setc(19); planetname:='Venus'; end;
    if solar.planetnum=4 then begin setc(4);  planetname:='Mars'; end;
    if solar.planetnum=6 then begin setc(6);  planetname:='Jupiter';  end;
    if solar.planetnum=8 then begin setc(91);  planetname:='Saturn'; end;
    if solar.planetnum=12 then begin setc(58);  planetname:='Uranus'; end;
    if solar.planetnum=17 then begin setc(59);  planetname:='Neptune'; end;
    if solar.planetnum=24 then begin setc(3);  planetname:='Pluto'; end;
    prompt('['+planetname+'> "?" gets menu: ');
    onek(op,'UC*HLBSI?');
    case op of
      'C':caveattack;
      'B':Bar;
      'L':begin quitit:=true; Leave; end;
      'S':status;
      'H':heal;
      '*':howmuch;
      '?':planetmenu;
      'I':printfile('instruct.txt');
        end;
      end;
  until quitit or hangup;
  end;


