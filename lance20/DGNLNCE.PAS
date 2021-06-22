program Dragonlance;

{$C-} {$V-}
{$I COMMON.PAS}

type
  playertype =
    record
      name,pseudo,password,ally,killer : string[30];
      gaspd:string[60];
      status,flights,alliance,plus : integer;
      r,experience,strength,intelligence,gold,luck,dexterity,constitution,
      charisma,weapon,vehicle,shield,damage,bank,attack,power,wins,loses : real;
    end;

  opponent =
    record
      name : string[30];
      gold,strength,dexterity,shield,luck,experience,weapon,weapon2,attack,power,vehicle : real;
    end;

var
  required          : array[1..28] of real;
  wname,sname       : array[1..25] of string[30];
  cross,strip,temp  : string[50];
  cost,w2,w3        : array[1..25] of real;
  vary,vary2,d,e,rd : real;
  roll,z,opt,x,buy,g: real;
  option            : string[1];
  mess              : array[1..20] of string[85];
  blt               : array[1..4] of string[60];
  infile,outfile    : text;
  messfile          : text;
  opp               : opponent;
  name,password,ugh : string[30];
  ugh2,ugh3         : string[60];
  enemy,a,b,m,j     : integer;
  number,dog,f,y,p  : integer;
  number_of_players : integer;
  number2,verify,okea,gam    : integer;
  trips,tint,spc,amount: integer;
  allied,finder     : boolean;
  play,doga         : boolean;
  uni,live,found,ftn: boolean;
  badchar,mg,fini,next   : boolean;
  partone           : boolean;
  bothover,healall  : boolean;
  player            : array[1..30] of playertype;
  result            : array[1..30] of string[80];
  opty              : char;
  abort,gonado,logit,yaya : boolean;


function playerattack : real;
  begin
    playerattack:=(vary*player[b].attack*player[b].strength*player[b].dexterity*(random*5+1))/
                  (opp.vehicle*opp.dexterity*opp.luck*vary2);
  end;

function playerattack2 : real;
  begin
    playerattack2:=round((vary*player[b].power*player[b].strength*(random*5+1)*(random*5+1))/
                   ((opp.vehicle)*opp.luck*vary2));
  end;

function roller : integer;
  begin
    roller:=round(random*3+1);
  end;


function opponentattack : real;
  begin
    opponentattack:=(vary2*opp.weapon*opp.strength*opp.dexterity*(random*5+1))/
                    ((player[b].vehicle)*player[b].dexterity*player[b].luck*vary);
  end;


function opponentattack2 : real;
  begin
    opponentattack2:=round((vary2*opp.weapon2*opp.strength*(random*5+1)*((random*5)+1))/
                     ((player[b].vehicle)*player[b].luck*vary));
  end;


function find1 : real;
  begin
    find1:=w2[round(player[b].weapon)];
  end;

function find2 : real;
  begin
    find2:=w3[round(player[b].weapon)];
  end;

function supplant : real;
  begin
    supplant:=(random(4)/10+(0.8));
  end;

function experience: real;
  begin
    experience:=((opp.vehicle-1+(opp.weapon+opp.weapon2-2)/2)*20+(opp.shield*7.5)+((opp.strength-10)*20)+
    (opp.luck+opp.dexterity-20)*17);
  end;

function spin : real;
  begin
    spin:=(random*6+1)+(random*6+1)+(random*6+1);
  end;

{overlay} procedure depobank;
var tempbank : real;
begin
  tempbank:=player[b].gold;
  if tempbank<0 then tempbank:=0;
  player[b].gold:=player[b].gold-tempbank;
  player[b].bank:=player[b].bank+tempbank;
  str(player[b].bank:1:0,temp);
  nl;
  ansic(3); print(temp+' Steel pieces are in the bank. ');
end;

{overlay} procedure withdrawbank;
  var
    tempbank : real;
  begin
    tempbank:=player[b].bank;
    if tempbank<0 then tempbank:=0;
    player[b].gold:=player[b].gold+tempbank;
    player[b].bank:=player[b].bank-tempbank;
    str(player[b].gold:1:0,temp);
    nl;
    ansic(5); print('You are now carring '+temp+' Steel pieces.');
  end;

procedure checkday;
  var
    oldy : str;
    h,a : integer;
  begin
    for a:=1 to number_of_players-1 do
     begin
      for h:=a+1 to number_of_players do
       begin
        if player[h].experience>player[a].experience then
         begin
          if h=b then b:=a
          else if a=b then b:=h;
          player[number_of_players+1]:=player[h];
          player[h]:=player[a];
          player[a]:=player[number_of_players+1];
         end;
       end;
     end;
    assign(infile,'DGNLNCE\date.lan');
    reset(infile);
    readln(infile,oldy);
    if oldy<>date then
      begin
        rewrite(infile);
        writeln(infile,date);
        for a:=1 to number_of_players do
          begin
            player[a].flights:=3;
            player[a].status:=0;
          end;
        assign(outfile,'DGNLNCE\record.lan');
        rewrite(outfile);
        writeln(outfile,'0');
        close(outfile);
      end;
    close(infile);
end;

procedure playerlist;
  var
    q,v,t,spc: integer;
    ts:str;
    tempaa,tempbb,tempcc,tempdd,tempee,tempff:string[10];
    tch:string[5];
  begin
   checkday;
   cls;
   nl;
   ansic(5);
   print('Hero Rankings:');
   print('!!!!!!!!!!!!!!');
   a:=1;
   repeat
     nl;
     str(a,temp);
     str(player[a].r:2:0,tempaa);
     str(player[a].wins:2:0,tempcc);
     str(player[a].loses:2:0,tempdd);
     if player[a].status=1 then tch:='SLAIN '
     else tch:='ALIVE';
     ansic(5);
     if a<10 then prompt(' '+temp+'.  ') else
     prompt(temp+'.  ');
     ansic(3);
     prompt(player[a].pseudo);
     for spc:=1 to 30-length(player[a].pseudo) do prompt('.');
     ansic(2);printa('Lev='+tempaa+'  W='+tempcc+'  L='+tempdd+'  S='+tch,abort,next);
     a:=a+1;
   until (a>number_of_players) or (abort);
  end;

procedure leave;
var a:integer;
  begin
  nl;
  assign(outfile,'DGNLNCE\characte.lan');
  rewrite(outfile);
  writeln(outfile,number_of_players);
  for a:= 1 to number_of_players do
    begin
      writeln(outfile,player[a].name);
      writeln(outfile,player[a].pseudo);
      writeln(outfile,player[a].gaspd);
      writeln(outfile,player[a].status);
      if player[a].status=1 then
        writeln(outfile,player[a].killer);
      writeln(outfile,round(player[a].strength),' ',round(player[a].intelligence),' ',
       round(player[a].luck),' ',round(player[a].dexterity),' ',round(player[a].constitution),
       ' ',round(player[a].charisma),' ',(player[a].experience):1:0,' ',
       round(player[a].r),' ',round(player[a].shield),' ',round(player[a].weapon),
       ' ',round(player[a].vehicle),' ',player[a].gold:1:0,' ',
       ' ',player[a].flights,' ',player[a].bank:1:0,' ',round(player[a].wins),' ',round(player[a].loses),
       ' ',player[a].plus);
    end;
  close(outfile);
  return;
end;

{overlay} procedure heal;
var
tempts : string[50];
  begin
    healall:=false;
    cls;
    str(round(8*player[b].r),temp);
    ansic(5); print('Clerics want '+temp+' Steel pieces per wound.');
    str(player[b].damage:1:0,tempts); nl;
    ansic(4); print('You have '+tempts+' points of damage to heal.');
    ansic(3); prompt('How many do points do you want healed? ');
    repeat
      {$I-}
      input(temp,3);
      if temp='' then healall:=true;
      opt:=value(temp);
      {$I+}
    until (ioresult=0) or hangup;
    if opt<0 then opt:=0;
    if hangup then leave;
    if healall then opt:=player[b].damage;
    if ((round(opt))*(player[b].r)*10)>player[b].gold then
      begin
    ansic(8);print('Sorry, you do not have enough Steel .');
        opt:=0;
      end
    else if opt>player[b].damage then opt:=player[b].damage;
    player[b].damage:=player[b].damage-opt;
    player[b].gold:=player[b].gold-8*opt*player[b].r;
    str(round(opt),temp);
    print(temp+' hit points healed.');
  end;

procedure findo;
begin
  nl;
  ansic(4);
  print('The Vile Enemy Dropped Something!');
  ynq('Do you want to get it? ');
  if yn then begin
   okea:=round(random(99)+1);
   if (okea < 10) and (player[b].weapon>=25) then begin
     player[b].weapon:=player[b].weapon+1;
     print('you have found a '+wname[round(player[b].weapon)]+'.');
   end;
   if (okea > 11) and (okea < 40) then begin
     player[b].gold:=player[b].gold+40;
     print('you have come across 40 Steel pieces');
   end else print('it''s gone!!!!');
  end else print('I wonder what it was?!?');
end;

procedure battle; forward;

{overlay} procedure recorda;
  var
    o:integer;
  begin
    assign(outfile,'DGNLNCE\record.lan');
    rewrite(outfile);
    writeln(outfile,number);
    for o:=1 to number do
    writeln(outfile,result[o]);
    close(outfile);
  end;

procedure readla;
  var
    o:integer;
  begin
    assign(infile,'DGNLNCE\record.lan');
    reset(infile);
    readln(infile,number);
    if number >30 then number:=30;
    for o:=1 to number do readln(infile,result[o]);
    close(infile);
  end;

{overlay} procedure mutantvictory;
var bt:integer;
  begin
    a:=m;
    if not doga then opp.gold:=opp.gold*supplant;
    str(opp.gold:0:0,temp);
    nl;
    print('You take his '+temp+' Steel pieces.');
    player[b].gold:=player[b].gold+opp.gold;
    if doga then
      begin
        nl;
        ansic(7); print('The Last Words He Utters Are...'); nl;
        print('"'+player[a].gaspd+'"'); nl;
        player[b].wins:=player[b].wins+1;
        player[a].loses:=player[a].loses+1;
        player[a].killer:=player[b].name;
        player[a].status:=1;
        player[a].gold:=0;
          if player[a].weapon>player[b].weapon then
            begin
              d:=player[b].weapon;
              player[b].weapon:=player[a].weapon;
              player[a].weapon:=d;
              bt:=player[b].plus;
              player[b].plus:=player[a].plus;
              player[a].plus:=bt;
              ansic(7);
              print('You Hath Taken His Weapon.');
            end;
          if player[a].vehicle>player[b].vehicle then
            begin
              d:=player[b].vehicle;
              player[b].vehicle:=player[a].vehicle;
              player[a].vehicle:=d;
              ansic(4);
              print('You Hath Taken His Armour.');
            end;
          player[b].attack:=find1;
          player[b].power:=find2;
          readla;
          number:=number+1;
          result[number]:=(player[b].pseudo+' conquered '+player[a].pseudo);
          recorda;
       end;
    z:=z*supplant;
    player[b].experience:=player[b].experience+z;
    str(z:0:0,temp);
    print('You obtain '+temp+' exp points.');
    doga:=false;
  end;

{overlay} procedure levelupdate;
var x,a:integer; tempaa:string[10];
  begin
    str(required[round(player[b].r+1)]:3:0,temp);
    ansic(7);
    str(player[b].experience:9:0,temp);
    if player[b].experience>required[round(player[b].r+1)] then
      begin
        player[b].r:=player[b].r+1;
        str(player[b].r:2:0,tempaa);
        ansic(4);
        print('Welcome to level '+tempaa+'!');
        x:=random(6)+1;
        case x of
            1:player[b].strength:=player[b].strength+1;
            2:player[b].intelligence:=player[b].intelligence+1;
            3:player[b].luck:=player[b].luck+1;
            4:player[b].dexterity:=player[b].dexterity+1;
            5:player[b].constitution:=player[b].constitution+1;
            6:player[b].charisma:=player[b].charisma+1;
          end;
        player[b].shield:=player[b].shield+(random*5+1)+(player[b].constitution/4);
         for a:= 1 to 10 do
           begin
             if hangup=true then begin play:=false; leave;end;
           end;
      end
     else for a:=1 to 2 do
      begin
       if hangup=true then leave;
      end;
    end;

procedure quickexit;
begin
  print('The Gods of Krynn Disapprove of your actions!');
  return;
end;

procedure amode;
begin
  roll:=playerattack;
  if roll<1.5 then
    begin
      tint:=round(random(3)+1);
      case tint of
        1:print('Swish you missed!');
        2:print('HA HA! He dodges your swing!');
        3:print('CLANG, The attack is blocked!');
        4: print('You Fight vigorously and miss!');
      end;
    end
  else
    begin
      roll:=playerattack2;
      if roll>5*player[b].power then roll:=5*player[b].power;
      opp.shield:=opp.shield-roll;
      str(round(roll),temp);
      tint:=round(random(2)+1);
         case tint of
           1:print('You Sliced him for '+temp+'.');
           2:print('You made contact to his body for '+temp+'.');
           3:print('You hacked him for '+temp+'.');
         end;
      if opp.shield<=0 then
        begin
          nl;
          tint:=round(random(3)+1);
             case tint of
               1:print('A Painless Death!');
               2:print('It Hath died!');
               3:print('A Smooth killing!');
               4:print('It has gone to the Abyss!');
             end;
          okea:=round(random(99)+1);
          if okea<30 then findo;
          mutantvictory;
          live:=false;
        end;
    end;
end;

procedure bmode;
var bt:integer;
begin
  if (opp.shield>0) and live then
    begin
      roll:=opponentattack;
        if roll<1.5 then
          begin
            ansic(7); print('His attack tears your armour.');
          end
        else
          begin
            roll:=opponentattack2;
            if roll>5*opp.weapon2 then roll:=5*opp.weapon2;
              str(round(roll),temp);
              tint:=round(random(2)+1);
                 case tint of
                   1:print('He hammered you for '+temp+'.');
                   2:print('He swung and hit for '+temp+'.');
                   3:print('You are suprised when he hits you for '+temp+'.');
                 end;
              player[b].damage:=player[b].damage+roll;
            if (player[b].damage>=player[b].shield) then begin
              nl;
              tint:=round(random(3)+1);
                 case tint of
                   1:print('Return This Knight To Huma''s Breast....');
                   2:print('You Hath Been Slain!!');
                   3:print('Return Soon Brave Warrior!');
                   4:print('May Palidine Be With You!!');
                 end;
              if doga then
                begin
                  player[a].wins:=player[a].wins+1;
                  player[b].loses:=player[b].loses+1;
                  player[a].gold:=player[a].gold+player[b].gold;
                  player[b].gold:=0;
                  readla;
                  number:=number+1;
                  result[number]:=(player[b].name+' killed '+player[a].name);
                  recorda;
                end;
                live:=false;
                leave;
                play:=false;
              end;
             end;
           end;
end;

{overlay} procedure statshow;
var
tempaa,tempbb,tempcc,tempdd,tempee,tempff,tempgg,temphh,tempii,tempjj,tempkk,templl,tempmm,tempnn,
tempoo,temppp,tempqq : string[50];
word : string[20];
 begin
  cls;
  str(round(player[b].r),tempaa);
  str(player[b].gold:1:0,tempbb);
  str(player[b].strength:2:0,tempcc);
  str(player[b].intelligence:2:0,tempdd);
  str(player[b].luck:2:0,tempee);
  str(player[b].dexterity:2:0,tempff);
  str(player[b].constitution:2:0,tempmm);
  str(player[b].charisma:2:0,tempnn);
  str(player[b].experience:1:0,tempgg);
  str((player[b].shield-player[b].damage):1:0,temphh);
  str(player[b].shield:1:0,tempii);
  str(player[b].bank:1:0,tempjj);
  str(player[b].flights,tempkk);
  str(round(3-dog),tempoo);
  str(round(player[b].wins),temppp);
  str(round(player[b].loses),tempqq);
  str(10-trips,templl);
  ansic(5); print('Name: '+player[b].pseudo+'   Level: '+tempaa);
  ansic(3); print('W/L: '+temppp+'/'+tempqq+'   Exp: '+tempgg);
  nl;
  ansic(4); print('Steel  (in hand): '+tempbb);
  ansic(4); print('Steel  (in bank): '+tempjj);
  nl;
  ansic(2); print('Battles: '+tempoo+'   Retreats: '+tempkk+'    Fights: '+templl+'   Hps: '+temphh+'('+tempii+')');
  nl;
  ansic(3); print('Weapon: '+wname[round(player[b].weapon)]+'     Armor: '+sname[round(player[b].vehicle)]);
 end;

{overlay} procedure chstats;
var temp1a,temp1b,temp1c,temp1d,temp1e,temp1f : real;
    tempaa,tempbb,tempcc,tempdd,tempee,tempff : string[50];

  procedure incre;
  begin
    prompt('Increase which stat? '); onek(opty,'123456Q');
    case opty of
      '1':player[b].strength:=player[b].strength+1;
      '2':player[b].intelligence:=player[b].intelligence+1;
      '3':player[b].dexterity:=player[b].dexterity+1;
      '4':player[b].luck:=player[b].luck+1;
      '5':player[b].constitution:=player[b].constitution+1;
      '6':player[b].charisma:=player[b].charisma+1;
      'Q':partone:=false;
    end;
  end;

  procedure decre;
  begin
    prompt('Decrease which stat? '); onek(opty,'123456');
    case opty of
      '1':player[b].strength:=player[b].strength-2;
      '2':player[b].intelligence:=player[b].intelligence-2;
      '3':player[b].dexterity:=player[b].dexterity-2;
      '4':player[b].luck:=player[b].luck-2;
      '5':player[b].constitution:=player[b].constitution-2;
      '6':player[b].charisma:=player[b].charisma-2;
    end;
  end;

  procedure ministat;
  begin
    yaya:=true;
    partone:=false;
    str(player[b].strength:1:0,tempaa);
    str(player[b].intelligence:1:0,tempbb);
    str(player[b].dexterity:1:0,tempdd);
    str(player[b].luck:1:0,tempcc);
    str(player[b].constitution:1:0,tempee);
    str(player[b].charisma:1:0,tempff);
    nl;
    print('Status Change:');
    print('^^^^^^^^^^^^^^');
    print('1> Str: '+tempaa);
    print('2> Int: '+tempbb);
    print('3> Dex: '+tempdd);
    print('4> Luk: '+tempcc);
    print('5> Con: '+tempee);
    print('6> Chr: '+tempff); nl;
    if player[b].strength < 6 then begin yaya:=false;nl; print('Strength cannot go below 6');end;
    if player[b].intelligence < 6 then begin yaya:=false;nl; print('Intelligence cannot go below 6');end;
    if player[b].dexterity < 6 then begin yaya:=false;nl; print('Dexterity cannot go below 6');end;
    if player[b].luck < 6 then begin yaya:=false;nl; print('Luck cannot go below 6');end;
    if player[b].constitution < 6 then begin yaya:=false;nl; print('Constitution cannot go below 6');end;
    if player[b].charisma < 6 then begin yaya:=false;nl; print('Charisma cannot go below 6');end;
    if yaya then begin
      ynq('Is this correct? ');
      if not yn then begin
        player[b].strength:=temp1a;
        player[b].intelligence:=temp1b;
        player[b].dexterity:=temp1d;
        player[b].luck:=temp1c;
        player[b].constitution:=temp1e;
        player[b].charisma:=temp1f;
        bothover:=false;
       end
      else bothover:=false;
    end
    else begin
      if not yaya then begin
        player[b].strength:=temp1a;
        player[b].intelligence:=temp1b;
        player[b].dexterity:=temp1d;
        player[b].luck:=temp1c;
        player[b].constitution:=temp1e;
        player[b].charisma:=temp1f;
        bothover:=false;
       end
      else bothover:=false;
    end;
  end;

begin
  cls;
  bothover:=false;
  temp1a:=player[b].strength;
  temp1b:=player[b].intelligence;
  temp1c:=player[b].luck;
  temp1d:=player[b].dexterity;
  temp1e:=player[b].constitution;
  temp1f:=player[b].charisma;
  str(player[b].strength:1:0,tempaa);
  str(player[b].intelligence:1:0,tempbb);
  str(player[b].luck:1:0,tempcc);
  str(player[b].dexterity:1:0,tempdd);
  str(player[b].constitution:1:0,tempee);
  str(player[b].charisma:1:0,tempff);
  repeat
    partone:=true;
    print('Status Change:');
    print('@@@@@@@@@@@@@');
    print('You may increase any stat by one,');
    print('yet you must decrease another by two.');
    nl;
    print('1> Str: '+tempaa);
    print('2> Int: '+tempbb);
    print('3> Dex: '+tempdd);
    print('4> Luk: '+tempcc);
    print('5> Con: '+tempee);
    print('6> Chr: '+tempff);nl;
    incre; if partone then decre else partone:=false;
    if partone then bothover:=true;
    if not partone then bothover:=false else ministat;
  until not bothover;
end;

procedure attackmodes;
begin
  if opp.dexterity>player[b].dexterity then
    begin
      if play then bmode;
      if play then amode;
    end else
  if opp.dexterity<player[b].dexterity then
    begin
      if play then amode;
      if play then bmode;
    end
  else begin
      if play then amode;
      if play then bmode;
    end
end;

procedure searcher;
var a:integer;
  begin
    trips:=trips+1;
    readln(infile,amount);
      rd:=random*(amount-1)+1;
      amount:=round(rd);
        for a:=1 to amount do
         begin
          readln(infile,opp.name);
          readln(infile,opp.shield,opp.weapon,opp.weapon2,opp.vehicle,opp.luck,
          opp.strength,opp.dexterity,opp.gold,z);

         end;
         close(infile);
         opp.weapon:=opp.weapon*supplant;
         opp.weapon2:=opp.weapon2*supplant;
         opp.vehicle:=opp.vehicle*supplant;
         opp.luck:=opp.luck*supplant;
         opp.strength:=opp.strength*supplant;
         opp.dexterity:=opp.dexterity*supplant;
         opp.shield:=opp.shield*supplant;
  end;

procedure fight(filename:str);
begin
  assign(infile,filename);
  reset(infile);
  searcher;
  battle;
end;

procedure doggie;
var
tempaa,tempbb,tempcc,tempdd,tmpgg : string[10];
tmphh : string[2];
tch:string[5];
spc,a:integer;
gono:boolean;
  begin
   if dog<=3 then
   begin
   nl;
   checkday;
   repeat
    repeat
     cls;
     ansic(4);
     print('Battle Another Hero:');
     print('********************');
      if number_of_players=1 then begin print('You are the only hero on Krynn!'); exit; end
      else begin
         begin
          a:=1;
          if hangup then leave;
          repeat
            if player[a].r>player[b].r-4 then begin
              nl;
              str(a,temp);
              str(player[a].r:2:0,tempaa);
              str(player[a].wins:2:0,tempcc);
              str(player[a].loses:2:0,tempdd);
              if player[a].status=1 then tch:='SLAIN '
              else tch:='ALIVE';
              ansic(5);
              if a<10 then prompt(' '+temp+'.  ') else
              prompt(temp+'.  ');
              ansic(3);
              prompt(player[a].pseudo);
              for spc:=1 to 30-length(player[a].pseudo) do prompt('.');
              ansic(2);printa('Lev='+tempaa+'  W='+tempcc+'  L='+tempdd+'  S='+tch,abort,next);
            end;
            a:=a+1;
          until (a>number_of_players) or (abort);
         end;
        nl;
        ansic(3);
        prompt('Enter the rank # of your opponent: ');
        {$I-}
        input(tmphh,2);
        enemy:=value(tmphh);
        {$I+}
        if (enemy=0) or (player[enemy].pseudo=player[b].pseudo) or (player[enemy].status=1) then exit;
      end;
    until (hangup) or (enemy<>0);
     if hangup then leave;
     for a:=1 to number_of_players do
       begin
         if enemy=a then
          begin
            if player[a].r>(player[b].r-4) then
             begin
               finder:=true;
               m:=a;
             end;
          end;
       end;
    until (hangup) or (finder=true);
    if hangup then leave;
      a:=m;
        begin
          opp.name:=player[a].pseudo;
          opp.shield:=player[a].shield;
          f:=b;
          vary2:=supplant;
          doga:=true;
          d:=player[b].attack;
          e:=player[b].power;
          g:=player[b].weapon;
          b:=a;
          dog:=dog+1;
          opp.weapon:=find1;
          opp.weapon2:=find2;
          b:=f;
          player[b].weapon:=g;
          player[b].attack:=d;
          player[b].power:=e;
          opp.vehicle:=player[a].vehicle;
          opp.luck:=player[a].luck;
          opp.strength:=player[a].strength;
          opp.dexterity:=player[a].dexterity;
          opp.gold:=player[a].gold;
          if opp.gold<0 then opp.gold:=0;
          z:=player[a].experience/10;
          finder:=false;
          player[b].alliance:=0;
          player[a].alliance:=0;
          battle;
        end;
    end;
  end;

procedure battle;
var loss,playerrem:real; option:char; tempxx:string[50];
  begin
    nl;
    live:=true;
    while live=true do
    begin
    playerrem:=player[b].shield-player[b].damage;
    str(playerrem:1:0,tempxx);
    nl;
    ansic(4); print('You are attacked by a '+opp.name+'.');
      repeat
        ansic(2);prompt('Combat ('+tempxx+' hps): (B,F,S): ');
        onek(option,'BFS?');
        if option='?' then begin
           nl;nl;
           print('(B)attle your opponent.');
           print('(F)lee from your opponent.');
           print('(S)tatus check.');
           nl;
        end;
      until (hangup) or (option='B') or (option='F') or (option='S');
        if hangup then leave;
        case option of
             'B':attackmodes;
             'S':statshow;
             'F':if (random*4+1)+player[b].dexterity>opp.dexterity then
                   begin
                     nl;
                     ansic(7); print('You Ride away on a Silver Dragon.');
                     doga:=false;
                     live:=false;
                     uni:=false
                   end;
        end;
    end;
  end;

{overlay} procedure credits;
  begin
    cls;
    ansic(7); print('Dragonlance 2.0 Credits');
    ansic(7); print('@@@@@@@@@@@@@@@@@@@@@@@');
    print('Original Dragonlance   :  Raistlin Majere & TML   ');
    print('Special Thanks To      : The Authors Of Dragonlance');
    print('Dragonlance''s Home     : The Tower Of High Sorcery');
    print('                               (717)696-2236       ');
    print('Originally modified from the Brazil Source Code.');nl;
    pausescr;
  end;


{overlay} procedure docs;
  begin
   cls;
   printfile('DGNLNCE\docs.lan');
   pausescr;
  end;

procedure vic;
var ahuh:boolean;

 procedure dit;
  begin
  nl;ansic(3);print('Enter your new Battle Cry.');
  prompt('>');inputl(ugh3,60);
  ynq('Is this correct? ');
  if yn then ahuh:=true else ahuh:=false;
  end;

begin
  repeat
    dit
  until ahuh;
  ahuh:=true;
end;

procedure create(new:boolean);
begin
  if new then
    begin
      nl;
      a:=number_of_players+1;
      player[a].name:=thisuser.name;
      player[a].pseudo:=thisuser.name;
      a:=number_of_players+1;
      vic;
    end
  else
    begin
      a:=b;
    end;
  with player[a] do
    begin
      strength:=12;
      status:=0;
      if new then number_of_players:=number_of_players+1;
      intelligence:=12;
      luck:=12;
      alliance:=0;
      damage:=0;
      gaspd:=ugh3;
      dexterity:=12;
      constitution:=12;
      charisma:=12;
      gold:=round(random(100)+175);
      weapon:=1;
      vehicle:=1;
      experience:=0;
      plus:=0;
      bank:=(random(199)+1);
      r:=1;
      shield:=(random*4+1)+player[a].constitution;
      flights:=3;
      wins:=0;
      loses:=0;
    end;
  nl;
  b:=a;
end;

procedure strait;
var p:integer;
begin
  for p:=1 to 25-length(strip) do
    strip:=strip+' ';
end;

procedure stripe;
var p:integer;
begin
  for p:=1 to 25-length(cross) do
    cross:=cross+' ';
end;

procedure weaponlist;
begin
  nl;
  nl;
  a:=1;
  print('  Num. Weapon                      Armour                          Price   ');
  print('(-------------------------------------------------------------------------)');
  repeat
    if hangup then leave;
    str(cost[a]:9:0,temp);
    str(a:2,opp.name);
    ansic(4);
    strip:=wname[a];
    strait;
    cross:=sname[a];
    stripe;
    printa('  '+opp.name+'>  '+(strip)+'   '+(cross)+'   '+temp,abort,next);nl;
    a:=a+1;
  until (a>25) or (abort);
end;


procedure readlist;
  begin
    assign(infile,'DGNLNCE\characte.lan');
    reset(infile);
    readln(infile,number_of_players);
    a:=1;
    b:=1;
    while (a<=number_of_players) do
      begin
        readln(infile,player[a].name,player[a].pseudo,player[a].gaspd,player[a].status);
        if player[a].status=1 then
          readln(player[a].killer);
        read(infile,player[a].strength,player[a].intelligence,player[a].luck,player[a].dexterity);
        read(infile,player[a].constitution,player[a].charisma,player[a].experience,player[a].r);
        read(infile,player[a].shield,player[a].weapon,player[a].vehicle,player[a].gold);
        read(infile,player[a].flights,player[a].bank,player[a].wins,player[a].loses);
        readln(infile,player[a].plus);
        a:=a+b;
      end;
    close(infile);
end;

procedure weaponquip;
begin
  input(temp,1);
  weaponlist;
end;

{overlay} procedure weaponshop;
var
tmpvv : string[2];
begin
  cls;
  ansic(4); print('Weapon & Armour Shop');
  ansic(7); print('$$$$$$$$$$$$$$$$$$$$');
  option:='B';
  while option<>'' do
    begin
      repeat
      nl;
      prompt('(B)rowse, (S)ell, (P)urchase, or (Q)uit? ');
      onek(opty,'BSQP');
      until (opty='P') or (opty='S') or (opty='') or (opty='Q') or (opty='B') or hangup;
      if hangup then leave;
        if opty='Q' then
        begin
         exit; end;
        if opty='B' then
          begin
            weaponlist;
          end;
        if opty='P' then
          begin
            nl;
           repeat
            {$I-}
            nl;
            prompt('Enter weapon/armour # you wish buy: ');
            input(temp,2);
            buy:=value(temp);
            {$I+}
            j:=ioresult;
           until (hangup) or(j=0);
           if hangup then leave;
           if buy=0 then exit;
           if cost[round(buy)]>player[b].gold then print('You don not have enough Steel .')
           else begin
               repeat
                 nl;
                 prompt('(W)eapon or (A)rmour: ');
                 onek(opty,'WA');
               until (hangup) or (option<>'D');
               if hangup then leave;
               if opty='W' then
                  begin
                    ynq('Are you sure you want buy it? ');
                       if yn then begin
                          player[b].gold:=player[b].gold-cost[round(buy)];
                          player[b].weapon:=buy;
                          nl;
                          ansic(5); print('You''ve bought a '+wname[round(buy)]);
                          player[b].attack:=find1;
                          player[b].power:=find2;
                       end;
                  end
               else if opty='A' then
                  begin
                    ynq('Are you sure you want buy it? ');
                       if yn then begin
                          player[b].gold:=player[b].gold-cost[round(buy)];
                          player[b].vehicle:=buy;
                          nl;
                         ansic(5); print('You''ve bought a '+sname[round(buy)]);
                       end;
                  end
               else nl;
             end;
           end
         else if opty='S' then
            begin
              repeat
                nl;
                prompt('(W)eapon,(A)rmour,(Q)uit : ');
                onek(opty,'AWQ');
              until (hangup) or (opty='W') or (opty='A') or (opty='') or (opty='Q');
              if hangup then leave;
                if opty='Q' then
                  begin
                    exit; end;
                if opty='W' then
                  begin
                    y:=(round(player[b].weapon));
                    x:=player[b].charisma;
                    x:=x*cost[y];
                    x:=((1/20)*x);
                    str(x:0:0,temp);
                    repeat
                    nl;
                    prompt('I will purchase it for '+temp+', okay? ');
                    onek(opty,'YN');
                    until (hangup) or (opty<>'D');
                    if hangup then leave;
                    if opty='Y' then
                      begin
                        ansic(7); print('Is it Dwarven Made?');
                        player[b].weapon:=1;
                        player[b].gold:=player[b].gold+x;
                      end;
                   end
                 else if opty='A' then
                   begin
                     x:=((1/20)*(player[b].charisma)*(cost[round(player[b].vehicle)]));
                     str(x:7:0,temp);
                     repeat
                     nl;
                     prompt('I will purchase it for '+temp+', okay? ');
                     onek(opty,'YN');
                     until (hangup) or (opty<>'D');
                     if opty='Y' then
                       begin
                         print('Fine Craftsmanship!');
                         player[b].vehicle:=1;
                         player[b].gold:=player[b].gold+x;
                       end;
                    end;
            end;
       end;
end;


procedure error;
  begin
    quickexit;
  end;

{overlay} procedure listplayers;
var a:integer;
  begin
    cls;
    ansic(4); print('Heroes That Have Been Defeated');
    ansic(5);print('+++++++++++++++++++++++++++++++');
    readla;
    a:=1;
    repeat
     if hangup then leave;
     ansic(3);
     printa(result[a],abort,next);
     a:=a+1;
    until (a>=number) or (abort);
  end;

{overlay} procedure spy;
var aa,bb,cc,dd,ee,ff,gg,hh:string[30]; a:integer;
  begin
    cls;
    print('Spying on another user eh.. well you may spy, but to keep');
    print('you from copying this person''s stats, they will not be   ');
    print('available to you.  Note that this is gonna cost you some ');
    print('cash too.  Cost: 20 Steel pieces                          ');
    nl;
    prompt('Who do you wish to spy on?'); input(aa,30);
    for a:=1 to number_of_players do
         if player[a].pseudo=aa then
           begin
             if player[b].gold<20 then
               begin
                 ansic(8);
                 print('You do not have enough Steel!');
               end
             else begin
               player[b].gold:=player[b].gold-20;
               str(player[a].r:1:0,bb);
               str(player[a].experience:1:0,cc);
               str(player[a].flights,dd);
               str((player[a].shield-player[a].damage):1:0,ee);
               str(player[a].bank:1:0,ff);
               str(player[a].gold:1:0,gg);
               str(player[a].shield:1:0,hh);
               nl;
               ansic(8);
               print(player[a].pseudo);nl;
               print('Level  :'+bb);
               print('Exp    :'+cc);
               print('Flights:'+dd);
               print('Hps    :'+ee+'('+hh+')');nl;
               ansic(5);
               print('Weapon :'+wname[round(player[a].weapon)]);
               ansic(5);
               print('Armour :'+sname[round(player[a].vehicle)]);nl;
               ansic(4);
               print('Steel  (in hand):'+gg);
               ansic(4);
               print('Steel  (in bank):'+ff);nl;pausescr;
             end
           end
  end;

{overlay} procedure gamble;

var
tempgd:string[5];
realgold:real;

  begin
   nl;
   if trips>10 then print('The Shooting Gallery is closed until tomorrow!')
   else begin
    cls;
    print('  Welcome to the Shooting Gallery');
    print(' Maximum wager is 25,000 Steel pieces');
    nl;
    prt('How many Steel pieces do you wish to wager? ');
    input(tempgd,5);
    {$I-}
    realgold:=value(tempgd);
    realgold:=round(realgold);
    {$I+}
    if realgold>player[b].gold then begin nl;
       print('You do not have enough Steel !'); end;
    if (realgold<>0) and ((player[b].gold>=realgold) and (realgold<=25000) and (realgold>=1)) then begin
      okea:=round(random(99)+1);
      if okea <= 3 then begin
        realgold:=realgold*100;
        player[b].gold:=player[b].gold+realgold;
        str(realgold,tempgd);
        print('You shot all the targets and win '+tempgd+' Steel pieces!');
      end;
      if (okea>3) and (okea<=15) then begin
        realgold:=realgold*10;
        player[b].gold:=player[b].gold+realgold;
        str(realgold,tempgd);
        print('You shot 50% of the targets and win '+tempgd+' Steel pieces!');
      end;
      if (okea>15) and (okea<=30) then begin
        realgold:=realgold*3;
        player[b].gold:=player[b].gold+realgold;
        str(realgold,tempgd);
        print('You shot %25 of the targets and win '+tempgd+' Steel pieces!');
      end;
      if okea>30 then begin
        player[b].gold:=player[b].gold-realgold;
        print('Sorry You Hath Lost!');
      end;
    end;
   end;
  end;


procedure afight;
  begin
    uni:=true;
    while uni do
      begin
        if trips>10 then
          begin
            nl;
            ansic(5); print('It''s Getting Dark Out!');
            ansic(5); print('Return to the Nearest Inn!');
            uni:=false;
          end
        else
          begin
            cls;
            fight('DGNLNCE\junkm1.lan');
            uni:=false;
          end;
      end;
  end;

procedure bfight;
  begin
    uni:=true;
    while uni do
      begin
        if trips>10 then
          begin
            nl;
            ansic(5); print('It''s Getting Dark Out!!.');
            ansic(5); print('Return to the Nearest Inn.');
            uni:=false;
          end
        else
          begin
            cls;
            fight('DGNLNCE\junkm2.lan');
            uni:=false;
          end;
      end;
  end;

procedure cfight;
  begin
    uni:=true;
    while uni do
      begin
        if trips>10 then
          begin
            nl;
            ansic(5); print('It''s Getting Dark Out!!.');
            ansic(5); print('Return to the Nearest Inn.');
            uni:=false;
          end
        else
          begin
            cls;
            fight('DGNLNCE\junkm3.lan');
            uni:=false;
          end;
      end;
  end;

procedure dfight;
  begin
    uni:=true;
    while uni do
      begin
        if trips>10 then
          begin
            nl;
            ansic(5); print('It''s Getting Dark Out!!.');
            ansic(5); print('Return to the Nearest Inn.');
            uni:=false;
          end
        else
          begin
            cls;
            fight('DGNLNCE\junkm4.lan');
            uni:=false;
          end;
      end;
  end;

procedure efight;
  begin
    uni:=true;
    while uni do
      begin
        if trips>10 then
          begin
            nl;
            ansic(5); print('It''s Getting Dark Out!!.');
            ansic(5); print('Return to the Nearest Inn.');
            uni:=false;
          end
        else
          begin
            cls;
            printfile('DGNLNCE\guards.lan');
            fight('DGNLNCE\junkm5.lan');
            uni:=false;
          end;
      end;
  end;

procedure Bulletin;

var
endfil:boolean;
countr:integer;
tempcoun:string[2];

begin
  cls;
  countr:=0;
  printfile('dgnlnce\bullet.lan');nl;
  ynq('Do you wish to enter a News Bulletin? ');
  if yn then begin
    nl;
    while (not endfil) do
     begin
      countr:=countr+1;
      str(countr,tempcoun);
      prt(tempcoun+'> ');
      inputl(blt[countr],60);
      if countr=4 then endfil:=true;
     end;
    nl;
    ynq('Is the bulletin correct? ');
    if yn then
     begin
      print('Saving Bulletin...');
      assign(messfile,'dgnlnce\bullet.lan');
      rewrite(messfile);
      writeln(messfile,blt[1]);
      writeln(messfile,blt[2]);
      writeln(messfile,blt[3]);
      writeln(messfile,blt[4]);
      close(messfile);
     end;
  end;
end;

{overlay} procedure training;

var
temptrain : string[1];
realtrain : real;
tttgld    : integer;

begin
 nl;
 if trips>10 then print('The Training Grounds are closed until tomorrow!')
 else begin
  cls;
  print('Training Grounds');
  print('%%%%%%%%%%%%%%%%');
  print('Each characteristic you wish to upgrade');
  print('will cost 1,000,000 Steel pieces per point.');
  nl;
  tttgld:=10000;
  ynq('Do you wish to upgrade a stat? ');
  if (yn) and (player[b].gold<(tttgld*100)) then
    print('Sorry, but you do not have enough Steel!')
  else if player[b].gold>=(tttgld*100) then begin
      nl;
      print('1> Strength       2> Intelligence');
      print('3> Dexterity      4> Luck        ');
      print('5> Constitution   6> Charisma    ');
      nl;
      prt('Which stat do you wish to increase? ');
      input(temptrain,1);
      {$I-}
      realtrain:=value(temptrain);
      {$I+}
      ynq('Are you sure? ');
      if yn then begin
        if realtrain=1 then begin
          player[b].strength:=player[b].strength+1;
          player[b].gold:=player[b].gold-(tttgld*100);
        end;
        if realtrain=2 then begin
          player[b].intelligence:=player[b].intelligence+1;
          player[b].gold:=player[b].gold-(tttgld*100);
        end;
        if realtrain=3 then begin
          player[b].dexterity:=player[b].dexterity+1;
          player[b].gold:=player[b].gold-(tttgld*100);
        end;
        if realtrain=4 then begin
          player[b].luck:=player[b].luck+1;
          player[b].gold:=player[b].gold-(tttgld*100);
        end;
        if realtrain=5 then begin
          player[b].constitution:=player[b].constitution+1;
          player[b].gold:=player[b].gold-(tttgld*100);
        end;
        if realtrain=6 then begin
          player[b].charisma:=player[b].charisma+1;
          player[b].gold:=player[b].gold-(tttgld*100);
        end;
      end;
  end;
 end;
end;

{overlay} procedure menuit;
begin
cls;
printfile('DGNLNCE\menu.lan');
if so then
print('           SysOp''s please press (@) if you wish to reroll the game!');
end;

begin
  iport;
  gonado:=true;
  hangup:=false;
  allied:=false;
  ftn:=false;
  vary:=supplant;
  dog:=0;
  doga:=false;
  for a:=1 to 30 do
    player[a].damage:=0;
  play:=true;
  trips:=0;
  found:=false;
  verify:=0;
  name:=thisuser.name; cls;
  nl;nl;
  credits;
  cls;
  prt('----------');ansic(8);prompt('   -=-=DRAGONLANCE=-=-      ');prt('    /\     ');nl;
  prt('\        /');ansic(1);prompt('       Version 2.0          ');prt('    ||     ');nl;
  prt(' \      / ');ansic(1);prompt('                            ');prt('    ||     ');nl;
  prt('  \    /  ');ansic(2);prompt('  Welcome To The World of   ');prt('    ||     ');nl;
  prt('   |  |   ');ansic(3);prompt('  Krynn, Where the gods     ');prt('    ||     ');nl;
  prt('  /    \  ');ansic(2);prompt('  of good and evil battle.  ');prt('  \ || /   ');nl;
  prt(' /      \ ');ansic(3);prompt('  Help the People Of Krynn. ');prt('   \==/    ');nl;
  prt('/        \');ansic(1);prompt('                            ');prt('    ##     ');nl;
  prt('----------');ansic(8);prompt('        ON WARD!!!          ');prt('    ##     ');nl;
  nl;
  print('News Bulletin:');nl;
  printfile('dgnlnce\bullet.lan');
  if hangup then leave;
      assign(infile,'DGNLNCE\characte.lan');
      reset(infile);
      readln(infile,number);
      number_of_players:=number;
      a:=1;
      b:=1;
      repeat
        with player[a] do
          begin
          readln(infile,name);
          readln(infile,pseudo);
          readln(infile,gaspd);
          readln(infile,status);
          if status=1 then readln(infile,killer);
          read(infile,strength,intelligence,luck,dexterity,constitution,charisma,experience,r,shield,weapon,vehicle,gold);
          read(infile,flights,bank,wins,loses,plus); readln(infile);
          a:=a+b;
          end;
       until (a>number_of_players);
       close(infile);
       for a:=1 to number_of_players do
         if player[a].name=name then
           begin
             found:=true;
             b:=a;
           end;
       if (not found) then begin
         if number_of_players >= 30 then quickexit else create(true);
       end;
       if player[b].status=1 then begin
         nl;
         ansic(3); print('A defeat was lead over you by '+player[b].killer+'.');
       end;
       checkday;
       if (player[b].flights<1) then
         begin
           trips:=12;
           dog:=4;
         end;
       player[b].flights:=player[b].flights-1;
       nl;
       pausescr; cls;
       assign(infile,'DGNLNCE\weapons.lan');
       ansic(2);
       reset(infile);
         for a:=1 to 25 do
          begin
           readln(infile,wname[a]);
           readln(infile,w2[a],w3[a]);
          end;
       close(infile); prompt(#13);
       assign(infile,'DGNLNCE\armor.lan');
       ansic(2);
       reset(infile);
         for a:=1 to 25 do
           readln(infile,sname[a]);
       close(infile);
         assign(infile,'DGNLNCE\prices.lan');
         reset(infile);
           for a:=1 to 25 do
             readln(infile,cost[a]);
         close(infile);
         player[b].attack:=find1;
         player[b].power:=find2;
         assign(infile,'DGNLNCE\experience.lan');
         reset(infile);
           for a:=1 to 28 do
             readln(infile,required[a]);
         close(infile);
        ansic(4);
        player[b].status:=0;
        vary2:=1;
        if hangup then leave;
        statshow;
        play:=true; mg:=false;
         repeat
           levelupdate;
           vary2:=1;
           if ((player[b].wins+1)*4)-(player[b].loses)<0 then begin
             nl;
             print('As you were Travelling along a Wilderness Path an   ');
             print('Evil Wizard Confronted You.  When you tried to fight');
             print('Him off, he cast a Spell of Instant Death Upon you.  ');
             print('Instantly you were slain by the Archmage, Leaving you');
             print('as nothing more than a pile of ashes.  Re-Rolled!   ');nl;
             pausescr;
             create(false); player[b].flights:=player[b].flights-1;
           end;
           nl;nl;
           prompt('Command (?): ');
           onek(opty,'QVP12345CHWLADGFRSTX+-?EZ@*#');
             case opty of
                  'Q':begin
                       ynq('LEAVE KRYNN? Are you sure?');
                       if yn then play:=false;
                      end;
                  '1':afight;
                  '2':bfight;
                  '3':cfight;
                  '4':dfight;
                  '5':efight;
                  'C':chstats;
                  'H':heal;
                  'W':weaponshop;
                  'L':levelupdate;
                  'A':doggie;
                  'D':Docs;
                  'G':gamble;
                  'F':listplayers;
                  'R':playerlist;
                  'S':statshow;
                  'T':training;
                  'X':begin
                        print('Please note that this will completely purge');
                        print('your current hero of all atributes!');nl;
                        ynq('Are you sure you want to REROLL your character? ');
                        if yn then begin
                          create(false);
                          player[b].flights:=player[b].flights-1;
                        end;
                      end;
                  '+':depobank;
                  'P':begin
                      printfile('DGNLNCE\Plug.lan');
                      end;
                  '-':withdrawbank;
                  '?':menuit;
                  'E':bulletin;
                  'Z':spy;
                  'V':begin
                      ansic(2); print('This Is Dragonlance version 2.0');
                      pausescr;
                      end;
                  '*':begin
                        nl;ansic(3);print('Your family crest has been stolen, they');
                        ansic(3);print('inscribe a new one with the name...');
                        prompt('>');input(ugh,30);nl;
                        ynq('Are you sure?');
                        if (ugh<>'') and (yn) then player[b].pseudo:=ugh;
                      end;
                  '#':begin vic; player[b].gaspd:=ugh3;end;
                  '@':if so then begin
                       nl;
                       ynq('Are you sure you want to re-roll the game? ');
                       if yn then begin
                         assign(infile,'DGNLNCE\characte.lan');
                         rewrite(infile);
                         writeln(infile,'0');
                         print('Character Sheets RE-ROLLED');
                         close(infile);
                         assign(infile,'DGNLNCE\record.lan');
                         rewrite(infile);
                         writeln(infile,'0');
                         print('Fight Records Re-initialized');
                         close(infile);
                         assign(infile,'DGNLNCE\bullet.lan');
                         print('Bulletin Re-initiazled');
                         rewrite(infile);
                         close(infile);
                         play:=false;
                         gonado:=false;
                       end;
                      end;
             end;
          until (play=false) or (gonado=false) or (hangup);
          sysoplog('#*#*# '+thisuser.name+' Played Dragonlance.');
          if gonado then leave;
end.
