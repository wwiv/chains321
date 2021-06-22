procedure spaceflip; forward;
procedure heal; forward;
procedure status; forward;

procedure reaperflip;
begin
  fleshdam:=random(6)+1;
  reaperdam:=random(3)+2;
end;



procedure holo;
begin
    Print('A hologram of an old man appears before you...');
    print('The message is full of static but you can make out.');
    print('The .... is '+gm.code1+' '+gm.code2+' '+gm.code3+'....');
    print('And the message ends.. What could that message mean?');
     end;



overlay procedure dead;
     begin
        writebarf1('- '+cstr(solar.number)+' '+solar.name+' Was killed on /  '+date);

        (*else if thisplanet=planet2 then writebarf2('- '+cstr(solar.number)+' '+solar.name+' was killed on /  '+date)
        else if thisplanet=planet3 then writebarf3('- '+cstr(solar.number)+' '+solar.name+' was killed on /  '+date)
        else if thisplanet=planet4 then writebarf4('- '+cstr(solar.number)+' '+solar.name+' was killed on /  '+date)
        else if thisplanet=planet5 then writebarf5('- '+cstr(solar.number)+' '+solar.name+' was killed on /  '+date)
        else if thisplanet=planet6 then writebarf6('- '+cstr(solar.number)+' '+solar.name+' was killed on /  '+date)
        else if thisplanet=planet7 then writebarf7('- '+cstr(solar.number)+' '+solar.name+' was killed on /  '+date)
        else if thisplanet=planet8 then writebarf8('- '+cstr(solar.number)+' '+solar.name+' was killed on /  '+date)
        else if thisplanet=planet9 then writebarf9('- '+cstr(solar.number)+' '+solar.name+' was killed on /  '+date);**)
      end;



overlay procedure worldattack;
var exp,k,randomfuel,damage,swhp,i:integer; runaway,fleshdead,continue,won:boolean;
begin
fleshdead:=false;
won:=false;
  continue:=false;
  runaway:=false;
  swhp:=random(15)+10;
  k:=random(2)+1;
  if k=1 then begin
  prompt('Walking...'); delay(700); prompt('.'); delay(700);
  prompt('.'); delay(700); end;
  if k=2 then begin
  prompt('Walking...'); prompt('.'); delay(700);
  prompt('.'); delay(700); prompt('.'); delay(700); end;
  if k=3 then begin
  prompt('Walking...'); delay(700); prompt('.'); delay(700);
  prompt('.'); delay(700); prompt('.'); delay(700);
  prompt('.'); delay(700);end;
  nl;
  print('Your heart beats as you get closer to the Flesh Eater''s');
  print('Lair. The smell of the dead Solar Warriors that came before');
  print('you, Makes you want to throw up. Then you hear the gurgle');
  print('sound of the Flesh Eaters breathing...');
  nl;
  nl;
  repeat checkhangup;
    repeat checkhangup;
    reaperflip;
    nl;
    print('1: Hands  2:Lazer Gun  3:Grenade  4:Cannon  5:Heal  6:Run Away  7:Status');
    prompt('Which Weapon do you use? '); onek(op,'1234567');
    case op of
    '1':begin damage:=fistdam; continue:=true; end;
    '2':
    begin
      if solar.magazine>0 then begin
        damage:=lazerdam;
        solar.magazine:=solar.magazine-1;
        solarw:=2;
        continue:=true;
      end
      else begin print('You dont have any Lazers....'); continue:=false; end;
    end ;
    '3':
    begin
      if solar.grenades>0 then begin
        damage:=grenadedam;
        solar.grenades:=solar.grenades-1;
        solarw:=3;
        continue:=true;
      end
      else begin print('You dont have any grenades...'); continue:=false; end;
    end;
    '4':
       begin
      if solar.Cannon>0 then begin
        damage:=Cannondam;
        solar.Cannon:=solar.Cannon-1;
        solarw:=7;
        continue:=true;
      end
      else begin print('You dont have a Cannon...'); continue:=false; end;
    end;
    '6':begin runaway:=true; continue:=false; end;
    '5': begin heal; continue:=false; end;
    '7': begin status; continue:=false; end;
  end;
  until (continue) or (runaway);
  if continue then
  begin
    spaceflip;
    if solarw>=flesh then
      begin
      nl;
        swhp:=swhp-damage;
        ansic(4);
        print('You did a damage of '+cstr(damage)+', the Flesh Eater has '+cstr(swhp)+' hit points now.');
      end else
      begin
      nl;
        print('You missed, Now The Flesh Eater Attacks....');
        spaceflip;
        nl;
          if flesh>solarw then begin
          ansic(7);
          print('It hits you.. doing a damage of '+cstr(fleshdam));
          solar.hp:=solar.hp-fleshdam;
          nl;
          print('You now have '+cstr(solar.hp)+' hit points');
        end else begin
        nl;
        print('He missed ya.. hahahha!'); end;
      end;
    if solar.hp<=5 then begin
    ansic(8); print('Warning Solar Warrior... You are low on hit points'); end;
    if swhp<1 then fleshdead:=true; won:=true;
    if solar.hp<1 then begin solar.dead:=true;
    dead;
    print('You were killed by a Flesh Eater....'); savedata;
    end;
  end;
  until (fleshdead) or (runaway);
  if won then begin
    print('You defeated the Flesh Eater.');
    exp:=random(25)+15;
    nl;
    print('For your battle, you recieve '+cstr(exp)+' experience points');
    solar.experience:=solar.experience+exp;
    pausescr;
    ansic(8);
    if (thisplanet=planet1) and (gm.key1) then begin
    gm.keynumber:=0;
    solar.key:=true; gm.key1:=false;
    Print('You found the Radium Chrystles...'); end;

     if (thisplanet=planet2) and (gm.key2) then begin
    solar.key:=true; gm.key2:=false;gm.keynumber:=0;
    Print('You found the Radium Chrystles...'); end;

     if (thisplanet=planet4) and (gm.key4) then begin
    solar.key:=true; gm.key4:=false; gm.keynumber:=0;
    Print('You found the Radium Chrystles...'); end;

    if (thisplanet=planet5) and (gm.key5) then begin
    solar.key:=true; gm.key5:=false; gm.keynumber:=0;
    Print('You found the Radium Chrystles...'); end;

     if (thisplanet=planet6) and (gm.key6) then begin
    solar.key:=true; gm.key6:=false; gm.keynumber:=0;
    Print('You found the Radium Chrystles...'); end;

     if (thisplanet=planet7) and (gm.key7) then begin
    solar.key:=true; gm.key7:=false; gm.keynumber:=0;
    Print('You found the Radium Chrystles...'); end;

    if (thisplanet=planet8) and (gm.key8) then begin
    solar.key:=true; gm.key8:=false; gm.keynumber:=0;
    Print('You found the Radium Chrystles...'); end;

    if (thisplanet=planet9) and (gm.key9) then begin
    solar.key:=true; gm.key9:=false; gm.keynumber:=0;
    Print('You found the Radium Chrystles...'); end;
    nl;
    (*************************)
    if (thisplanet=planet1) and (gm.old1) then begin
    holo; gm.old1:=false;
     end;
    if (thisplanet=planet2) and (gm.old2) then begin
    holo; gm.old2:=false;
     end;
     if (thisplanet=planet4) and (gm.old4) then begin
     holo;
    gm.old4:=false; end;
    if (thisplanet=planet5) and (gm.old5) then begin
    holo;
    gm.old5:=false; end;
    if (thisplanet=planet6) and (gm.old6) then begin
    holo;
    gm.old6:=false; end;
    if (thisplanet=planet7) and (gm.old7) then begin
    holo;
    gm.old7:=false; end;
    if (thisplanet=planet8) and (gm.old8) then begin
    holo;
    gm.old8:=false; end;
    if (thisplanet=planet9) and (gm.old9) then begin
    holo;
    gm.old9:=false; end;
    nl;
    print('Going Back to the Bar.');nl;
  end;
  if not won then print('With a fruitless journey you return back to this world');
  goplanet;
end;


overlay procedure caveattack;
var exp,k,randomfuel,damage,swhp,i:integer; runaway,wormdead,continue:boolean;
begin
wormdead:=false;
  continue:=false;
  runaway:=false;
  swhp:=random(15)+10;
  k:=random(2)+1;
  if k=1 then begin
  prompt('Walking...'); delay(700); prompt('.'); delay(700);
  prompt('.'); delay(700); end;
  if k=2 then begin
  prompt('Walking...'); prompt('.'); delay(700);
  prompt('.'); delay(700); prompt('.'); delay(700); end;
  if k=3 then begin
  prompt('Walking...'); delay(700); prompt('.'); delay(700);
  prompt('.'); delay(700); prompt('.'); delay(700);
  prompt('.'); delay(700);end;
  nl;
  print('You Travel through this worlds Chrystlarium minds..');
  print('Suddenly you hear it, its a soft sound, but at each');
  print('passing second the noise gets louder. Then you see it');
  print('Its a Death Reaper...');
  nl;
  nl;
repeat checkhangup;
  repeat checkhangup;
  reaperflip;
    nl;
    print('1: Hands  2:Lazer Gun  3:Grenade  4:Cannon  5:Heal  6:Run Away  7:Status');
    prompt('Which Weapon do you use? '); onek(op,'1234567');
    case op of
    '1':begin damage:=fistdam; continue:=true; end;
    '2':
    begin
      if solar.magazine>0 then begin
        damage:=lazerdam;
        solar.magazine:=solar.magazine-1;
        solarw:=2;
        continue:=true;
      end
      else begin print('You dont have any Lazers....'); continue:=false; end;
    end ;
    '3':
    begin
      if solar.grenades>0 then begin
        damage:=grenadedam;
        solar.grenades:=solar.grenades-1;
        solarw:=3;
        continue:=true;
      end
      else begin print('You dont have any grenades...'); continue:=false; end;
    end;
    '4':
       begin
      if solar.Cannon>0 then begin
        damage:=Cannondam;
        solar.Cannon:=solar.Cannon-1;
        solarw:=7;
        continue:=true;
      end
      else begin print('You dont have a Cannon...'); continue:=false; end;
    end;
    '6':begin runaway:=true; continue:=false; end;
    '5':begin heal; continue:=false; end;
    '7':begin status; continue:=false; end;
  end;
  until (continue) or (runaway);
  if continue then
  begin
    spaceflip;
    if solarw>=reaper then
      begin
      nl;
        swhp:=swhp-damage;
        ansic(4);
        print('You did a damage of '+cstr(damage)+', the Death Reaper has '+cstr(swhp)+' hit points now.');
      end else
      begin
      nl;
        print('You missed, Now The Reaper Attacks....');
        spaceflip;
        if reaper>solarw then begin
        nl;
        ansic(7);
          print('It hits you.. doing a damage of '+cstr(reaperdam));
          solar.hp:=solar.hp-reaperdam;
          nl;
          print('You now have '+cstr(solar.hp)+' hit points');
        end else begin
        nl;
        print('He missed ya.. hahahha!'); end;
      end;
    if solar.hp<=5 then begin
    ansic(8); print('Warning Solar Warrior... You are low on hit points'); end;
    if swhp<1 then wormdead:=true;
    if solar.hp<1 then begin solar.dead:=true;
    dead;
    print('You were killed by a Death Reaper....'); savedata;
    end;
  end;
  until (wormdead) or (runaway);
  if wormdead then begin
    print('You defeated the Death Reaper.');
    exp:=random(15)+10;
    print('For your battle, you recieve '+cstr(exp)+' experience points');
    nl;
    solar.experience:=solar.experience+exp;
    randomfuel:=random(25)+8;
    print('Because of the fight, you knocked '+cstr(randomfuel)+' Chrystlarium loose');
    solar.fuel:=solar.fuel+randomfuel;
    nl;
    ynq('Do ya wanna look for the Flesh Eater, Solar Warrior?');
    if yn then worldattack;
  end
  else print('Your going back to the bar.....');
end;

