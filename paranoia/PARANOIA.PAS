program paranoia;

{$V-} {$C-}
{$I COMMON.PAS}
{$I BRUCK.PAS}
{$I ERRHANDL.PAS}

type
  player =
    record
      name,killer,password,ally : string[30];
      status,flights,alliance: integer;
      lev,exp,str,int,credits,luk,dex,con,cha,weapon,ship,shield,damage,bank,
      attack,power : real;
    end;

  opponent =
    record
      name : string[30];
      credits,str,dex,shield,luk,exp,weapon,weapon2,attack,power,ship : real;
    end;

var
  required : array[1..28] of real;
  wname,sname : array[1..25] of string[30];
  strip,shit : string[50];
  cost,w2,w3 : array[1..25] of real;
  vary,vary2,d,e,rd,roll,z,opt,x,buy,g: real;
  option : string[1];
  mess : array[1..20] of string[85];
  infile,outfile,messfile : text;
  doc : string[80];
  opp : opponent;
  name,password : string[30];
  gamble,a,b,m,amount,j,skim,number,dog,f,y,keep,number2,verify,trips : integer;
  allied,finder,verbose,play,doga,uni,live,found : boolean;
  r : array[1..50] of player;
  enemy : string[30];
  result : array[1..51] of string[80];


function spin : real;
  begin
    spin:=(random*6+1)+(random*6+1)+(random*6+1);
  end;

function playerattack : real;
  begin
    playerattack:=(vary*r[b].attack*r[b].str*r[b].dex*(random*5+1))/
              (opp.ship*opp.dex*opp.luk*vary2);
  end;

function playerattack2 : real;
  begin
    playerattack2:=round((vary*r[b].power*r[b].str*(random*5+1)*(random*5+1))/
                  ((opp.ship)*opp.luk*vary2));
  end;

function roller : integer;
  begin
    roller:=round(random*2+1);
  end;


function opponentattack : real;
  begin
    opponentattack:=(vary2*opp.weapon*opp.str*opp.dex*(random*5+1))/
            ((r[b].ship)*r[b].dex*r[b].luk*vary);
  end;


function opponentattack2 : real;
  begin
    opponentattack2:=round((vary2*opp.weapon2*opp.str*(random*5+1)*((random*5)+1))/
                  ((r[b].ship)*r[b].luk*vary));
  end;


function find1 : real;
  begin
    find1:=w2[round(r[b].weapon)];
  end;

function find2 : real;
  begin
    find2:=w3[round(r[b].weapon)];
  end;

function supplant : real;
  begin
    supplant:=(random(4)/10+(0.8));
  end;

function experience: real;
  begin
    experience:=((opp.ship-1+(opp.weapon+opp.weapon2-2)/2)*20+(opp.shield*7.5)+((opp.str-10)*20)+
    (opp.luk+opp.dex-20)*15);
  end;

procedure playerlist;
  var
    p,q,v,t: integer;

  begin
    cls;
    print('');
    print('                        Player  Lev');
    for p:=1 to keep do
      begin
        shit:=r[p].name;
        q:=length(shit);
        t:=round(r[p].lev);
        str(t,option);
        shit:=(shit+'   '+option);
        print(shit);
      end;
     print('');
     prtm('TYPE ENTER TO CONTINUE');
     input(option,1);
  end;

procedure leave; forward;
procedure return;
  var ff:file;
  begin
    close(infile);
    close(outfile);
    assign(ff,'bbs.com');
    printm('And now back to the BBS!');
    remove_port;
    if hangup then term_ready(false);
    execute(ff);
  end;

procedure checkday;
  var
    oldy : str;
    h : integer;
  begin
    for a:=1 to keep-1 do
     begin
      for h:=a+1 to keep do
       begin
        if r[h].exp>r[a].exp then
         begin
          if h=b then b:=a
          else if a=b then b:=h;
          r[keep+1]:=r[h];
          r[h]:=r[a];
          r[a]:=r[keep+1];
         end;
       end;
     end;
    assign(infile,'gfiles\date.par');
    reset(infile);
    readln(infile,oldy);
    if oldy<>date then
      begin
        rewrite(infile);
        writeln(infile,date);
        for a:=1 to keep do
          begin
            r[a].flights:=6;
            r[a].status:=0;
          end;
        assign(outfile,'gfiles\record.pas');
        rewrite(outfile);
        writeln(outfile,'0');
        close(outfile);
      end;
    close(infile);
  end;

procedure heal;
  begin
    print('');
    str(r[b].credits:9:0,shit);
    printm('You have '+shit+' credits.');
    str(round(10*r[b].lev),shit);
    printm(' Each hit point costs '+shit+' to restore.');
    prtm('How many do you want?');
    repeat
      {$I-}
      input(shit,3);
      opt:=value(shit);
      if opt<0 then opt:=0;
      {$I+}
      j:=ioresult;
      checkhangup;
    until (j=0) or hangup;
    if hangup then leave;
    if ((round(opt))*(r[b].lev)*10)>r[b].credits then
      begin
        printm('You don''t have enough,commie!');
        opt:=0;
      end
    else if opt>r[b].damage then opt:=r[b].damage;
    r[b].damage:=r[b].damage-opt;
    r[b].credits:=r[b].credits-10*opt*r[b].lev;
    str(round(opt),shit);
    printm('You have been restored '+shit);

 end;


procedure battle;  forward;

procedure revenge;
  begin
    if r[a].alliance=1 then
      begin
       enemy:=r[a].ally;
       for a:=1 to keep do
       begin
         if enemy=r[a].name then
          begin
           if r[a].status=0 then finder:=true;
          end;
       end;
       if finder=false then exit;
       print('');
       printm('You are being attacked by the vengeful '+enemy+'!');
      for a:=1 to keep do
      if r[a].name=enemy then
        begin
          m:=a;
          opp.name:=r[a].name;
          opp.shield:=r[a].shield;
          f:=b;
          d:=r[b].attack;
          e:=r[b].power;
          g:=r[b].weapon;
          b:=a;
          r[b].weapon:=r[a].weapon;
          opp.weapon:=find1;
          opp.weapon2:=find2;
          b:=f;
          r[b].weapon:=g;
          r[b].attack:=d;
          r[b].power:=e;
          opp.ship:=r[a].ship;
          opp.luk:=r[a].luk;
          opp.str:=r[a].str;
          opp.dex:=r[a].dex;
          opp.credits:=r[a].credits;
          z:=r[a].exp/10;
          finder:=false;
          doga:=false;
          battle;
        end;
      end;
    end;

procedure recorda;
  var
    o:integer;
  begin
    assign(outfile,'gfiles\record.par');
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
    assign(infile,'gfiles\record.par');
    reset(infile);
    readln(infile,number);
    if number >50 then number:=50;
    for o:=1 to number do
    readln(infile,result[o]);
    close(infile);
  end;

procedure mutantvictory;
  begin
    a:=m;
    print('');
    if not doga then opp.credits:=opp.credits*supplant;
    str(opp.credits:8:0,shit);
    printm('You get his '+shit+' credits!');
    r[b].credits:=r[b].credits+opp.credits;
    print('');
    if doga then
      begin
        r[a].killer:=r[b].name;
        r[a].status:=1;
        r[a].credits:=0;
          if r[a].weapon>r[b].weapon then
            begin
              d:=r[b].weapon;
              r[b].weapon:=r[a].weapon;
              r[a].weapon:=d;
            end;
          if r[a].ship>r[b].ship then
            begin
              d:=r[b].ship;
              r[b].ship:=r[a].ship;
              r[a].ship:=d;
            end;
          r[b].attack:=find1;
          r[b].power:=find2;
          readla;
          number:=number+1;
          result[number]:=(r[b].name+' defeated '+r[a].name+'!');
          sysoplog('  '+result[number]);
          recorda;

       end;
    z:=z*supplant;
    r[b].exp:=r[b].exp+z;
    str(z:6:0,shit);
    printm('You also get '+shit+' experience!');
    doga:=false;
    print('');
    print('');
    prtm('TYPE ENTER TO CONTINUE');
    input(shit,1);
    cls;
  end;

procedure long;
  var
    a : integer;

  begin
    for a:=1 to 30-length(shit) do
      shit:=shit+' ';
  end;

procedure lengthword;
  var
    a : integer;

  begin
    for a:=1 to 20-length(shit) do
      shit:=shit+' ';
  end;

procedure statussheet;
  var
    word : string[20];
  begin
    cls;
    shit:=r[b].name;
    lengthword;
    prt(shit);
    str(round(r[b].lev),shit);
    shit:='Level: '+shit;
    lengthword;
    prt(shit);
    str(r[b].exp:9:0,shit);
    shit:='Exp: '+shit;
    prt(shit); nl;
    str(round(r[b].str),shit);
    shit:=('Str: '+shit);
    lengthword;
    prt(shit);
    str(round(r[b].int),shit);
    shit:=('Aglty: '+shit);
    lengthword;
    prt(shit);
    str(round(r[b].luk),shit);
    shit:='Luck: '+shit;
    prt(shit); nl;
    str(round(r[b].dex),shit);
    shit:='ManDex: '+shit;
    lengthword;
    prt(shit);
    str(round(r[b].con),shit);
    shit:='Indur: '+shit;
    lengthword;
    prt(shit);
    str(round(r[b].cha),shit);
    shit:='Chutz: '+shit;
    prt(shit); nl;
    shit:=('Weapon: '+wname[round(r[b].weapon)]);
    long;
    prt(shit);
    shit:=('Ship: '+sname[round(r[b].ship)]);
    prt(shit); nl;
    str(round(r[b].shield-r[b].damage),shit);
    word:=('Hit Points: '+shit+'(');
    str(round(r[b].shield),shit);
    shit:=word+shit;
    shit:=(shit+')');
    long;
    prt(shit);
    str(r[b].credits:9:0,shit);
    shit:=('Credits:'+shit);
    prt(shit); nl;
    str(r[b].flights,shit);
    shit:=('Clones: '+shit);
    long;
    prt(shit);
    str(trips,shit);
    shit:=('Attacks on Color Levels: '+shit);
    prt(shit); nl;
    str(r[b].bank:1:0,shit);
    shit:='You have '+shit+' credits in the bank';
    prt(shit); nl;

    if verbose then
     begin
      prt('HIT ENTER TO CONTINUE');
      input(option,1);
     end;
  end;

procedure levelupdate;
  begin
    print('');
    str(round(r[b].lev)+1,shit);
    printm('To reach level '+shit);
    str(required[round(r[b].lev+1)]:3:0,shit);
    printm(' you need '+shit+' experience.');
    str(r[b].exp:9:0,shit);
    if r[b].exp>required[round(r[b].lev+1)] then
      begin
        printm('Therefore you have been promoted a level!!!');
        r[b].lev:=r[b].lev+1;
        a:=roller;
        if (a=1) and (r[b].str<20) then r[b].str:=r[b].str+1;
        a:=roller;
        if (a=1) and (r[b].int<20) then r[b].int:=r[b].int+1;
        a:=roller;
        if (a=1) and (r[b].luk<20) then r[b].luk:=r[b].luk+1;
        a:=roller;
        if (a=1) and (r[b].dex<20) then r[b].dex:=r[b].dex+1;
        a:=roller;
        if (a=1) and (r[b].con<20) then r[b].con:=r[b].con+1;
        a:=roller;
        if (a=1) and (r[b].cha<20) then r[b].cha:=r[b].cha+1;
        r[b].shield:=r[b].shield+(random*5+1)+(r[b].con/4);
         for a:= 1 to 10 do
           begin
             print('');
             checkhangup;
             if hangup=true then leave;
           end;
      end
     else for a:=1 to 2 do
      begin
       print('');
       checkhangup;
       if hangup=true then leave;
      end;
    end;

procedure leave;
  begin
    print('');
    printm('That is the end of Paranoia!');
    printm('Later');
            assign(outfile,'gfiles\character.par');
            rewrite(outfile);
            writeln(outfile,keep);

            for a:= 1 to keep do
              begin
                writeln(outfile,r[a].name);
                writeln(outfile,r[a].status);
                if r[a].status=1 then
                  writeln(outfile,r[a].killer);
                writeln(outfile,round(r[a].str),' ',round(r[a].int),' ',
                round(r[a].luk),' ',round(r[a].dex),' ',round(r[a].con),
                ' ',round(r[a].cha),' ',(r[a].exp):1:0,' ',
                round(r[a].lev),' ',round(r[a].shield),' ',round(r[a].weapon),
                ' ',round(r[a].ship),' ',r[a].credits:1:0,' ',
                ' ',r[a].flights,' ',r[a].bank:1:0);
             end;
        close(outfile);
        close(infile);
     return;
  end;


procedure universeexplain;
  begin
    print('');
    printm('Currently available:');
    printm('++++++++++++++++++++');
    printm('(R)-Red Hallway ');
    printm('(O)-Orange Hallway');
    printm('(Y)-Yellow Hallway');
    printm('(G)-Green Hallway');
    printm('(B)-Blue Hallway');
    printm('(I)-Indigo Hallway');
    printm('(V)-Violet Hallway');
    printm('(U)-Ultraviolet Hallway');
    printm('(H)-Repair Body Armor');
    printm('(Q)-Quit universe commands');

  end;


procedure quickexit;
  begin
    return;
  end;

procedure amode;
  begin
            roll:=playerattack;
            if roll<1.5 then
              begin
                print('');
                printm('You missed him!');
              end
            else
              begin

                roll:=playerattack2;
                if roll>5*r[b].power then roll:=5*r[b].power;
                opp.shield:=opp.shield-roll;
                print('');
                str(round(roll),shit);
                printm('You hit him for '+shit);
                if opp.shield<=0 then
                  begin
                    print('');
                    printm('You killed him!');
                    mutantvictory;
                    live:=false;
                  end;

              end;

end;

procedure question;
  begin
    print('');
    printm('A - attack commie spy');
    printm('R - run');
    printm('S - see your status');
  end;

procedure battle;
  begin
    print('');
    live:=true;
    while live=true do
    begin
      printm('You are faced by a '+opp.name);
      repeat
        if verbose then question;
        prtm('Option?');
        input(option,1);
        if option='S' then statussheet
        else if (option='?')and (verbose=false) then
          question;
          checkhangup;
      until (hangup) or (option='A') or (option='R');
        if hangup then leave;
        if option='A' then amode
        else if option='R' then
              begin
                if (random*4+1)+r[b].dex>opp.dex then
                  begin
                    print('');
                    printm('You escaped!');
                    doga:=false;
                    live:=false;
                  end
               end;


          if (opp.shield>0) and live then
           begin
            roll:=opponentattack;
            if roll<1.5 then
               begin
                 print('');
                 printm('He Missed You!');
               end
             else
              begin
                roll:=opponentattack2;
                  if roll>5*opp.weapon2 then roll:=5*opp.weapon2;
                  str(round(roll),shit);
                  printm('He hit you for '+shit+' damage!');
                r[b].damage:=r[b].damage+roll;
                if (r[b].damage>=r[b].shield) then begin
                  print('');
                  printm('the commie spy destroyed you!');
                  printm('Farewell '+r[b].name);
                  if doga then
                   begin
                    r[a].credits:=r[a].credits+r[b].credits;
                    r[b].credits:=0;
                  if r[a].weapon<r[b].weapon then
                    begin
                      d:=r[a].weapon;
                      r[a].weapon:=r[b].weapon;
                      r[b].weapon:=d;
                    end;
                  if r[a].ship<r[b].ship then
                    begin
                      d:=r[a].ship;
                      r[a].ship:=r[b].ship;
                      r[b].ship:=d;
                    end;
                  readla;
                  number:=number+1;
                  result[number]:=(r[b].name+' was defeated by '+r[a].name+'!');
                  recorda;

                 end;

                live:=false;
                leave;
               end;
             end;
           end;
       end;
    end;

procedure searcher;
  begin
    trips:=trips+1;
    readln(infile,amount);
      rd:=random*(amount-1)+1;
      amount:=round(rd);
        for a:=1 to amount do
         begin
          readln(infile,opp.name);
          readln(infile,opp.shield,opp.weapon,opp.weapon2,opp.ship,opp.luk,
          opp.str,opp.dex,opp.credits,z);

         end;
         close(infile);
         opp.weapon:=opp.weapon*supplant;
         opp.weapon2:=opp.weapon2*supplant;
         opp.ship:=opp.ship*supplant;
         opp.luk:=opp.luk*supplant;
         opp.str:=opp.str*supplant;
         opp.dex:=opp.dex*supplant;
         opp.shield:=opp.shield*supplant;
  end;

procedure depobank;
  var
    wowzers : real;
  begin
    prtm('How much(enter for all)?');
    input(option,10);
    if option='' then wowzers:=r[b].credits
    else wowzers:=value(option);
    if wowzers>r[b].credits then wowzers:=r[b].credits;
    if wowzers>((r[b].lev*r[b].lev*r[b].lev)*1000)-r[b].bank then
      begin
        wowzers:=((r[b].lev*r[b].lev*r[b].lev)*1000)-r[b].bank;
        str(((r[b].lev*r[b].lev*r[b].lev)*1000):1:0,shit);
        printm('You can''t put in more than '+shit+' at your current level');
        printm('So I''ll just put in the max');
      end;
    if wowzers<0 then wowzers:=0;
    r[b].credits:=r[b].credits-wowzers;
    r[b].bank:=r[b].bank+wowzers;
    str(r[b].bank:1:0,shit);
    printm('You now have '+shit+' credits in the bank');
  end;

procedure removebank;
  var
    wowzers : real;
  begin
    prtm('How much(return for all)?');
    input(option,10);
    wowzers:=value(option);
    if option='' then wowzers:=r[b].bank;
    if wowzers>r[b].bank then wowzers:=r[b].bank;
    if wowzers<0 then wowzers:=0;
    r[b].credits:=r[b].credits+wowzers;
    r[b].bank:=r[b].bank-wowzers;
    str(r[b].bank:1:0,shit);
    printm('You now have '+shit+' credits in the bank');
  end;

procedure munitionbank;
  var
    readchar : char;
  begin
    cls;
    printm('Welcome to the Piggy Bank of Friend Computer');
    printm('Here is your statement:');
    nl;
    str(r[b].bank:1:0,shit);
    printm('You have '+shit+' credits in the bank');
    str(r[b].credits:1:0,shit);
    printm('You have '+shit+' credits sitting around');
    prtm('(D)eposit, (W)ithdraw, (Q)uit->');
    onek(readchar,'DWQ');
    case readchar of
      'D': depobank;
      'W': removebank;
      'Q': exit;
    end;
  end;

procedure orange;
  begin
    assign(infile,'gfiles\orange.par');
    reset(infile);
    searcher;
    battle;
  end;

procedure yellow;
  begin
    assign(infile,'gfiles\yellow.par');
    reset(infile);
    searcher;
    battle;
  end;

procedure green;
  begin
    assign(infile,'gfiles\green.par');
    reset(infile);
    searcher;
    battle;
  end;

procedure blue;
  begin
    assign(infile,'gfiles\blue.par');
    reset(infile);
    searcher;
    battle;
  end;

procedure indigo;
  begin
    assign(infile,'gfiles\indigo.par');
    reset(infile);
    searcher;
    battle;
  end;

procedure violet;
  begin
    assign(infile,'gfiles\violet.par');
    reset(infile);
    searcher;
    battle;
  end;

procedure ultraviolet;
  begin
    assign(infile,'gfiles\ultraviolet.par');
    reset(infile);
    searcher;
    battle;
  end;

procedure doggie;
  begin
   if dog<2 then
   begin
    cls;
    print('');
    repeat
     repeat
      prt('Which of the potent characters do you want to attack?');
      input(enemy,40);

      if enemy='?' then for a:=1 to keep do
       begin
        checkhangup;
        if hangup then leave;
        if r[a].name<>r[b].name then
         if r[a].status=0 then
          if r[a].lev>(r[b].lev-4) then
          begin
            str(r[a].lev:2:0,shit);
            print('Lev: '+shit+'  '+r[a].name);
          end;
       end;
      if enemy='' then exit;
      if enemy=r[b].name then exit;
      checkhangup;
     until (hangup) or (enemy<>'?');
     if hangup then leave;
     for a:=1 to keep do
       begin
         if enemy=r[a].name then
          begin
           if r[a].status=0 then
            if r[a].lev>(r[b].lev-4) then
             begin
               finder:=true;
               m:=a;
             end;
          end;
       end;
       checkhangup;
    until (hangup) or (finder=true);
    if hangup then leave;
      a:=m;
        begin
          opp.name:=r[a].name;
          opp.shield:=r[a].shield;
          f:=b;
          vary2:=supplant;
          doga:=true;
          d:=r[b].attack;
          e:=r[b].power;
          g:=r[b].weapon;
          b:=a;
          dog:=dog+1;
          opp.weapon:=find1;
          opp.weapon2:=find2;
          b:=f;
          r[b].weapon:=g;
          r[b].attack:=d;
          r[b].power:=e;
          opp.ship:=r[a].ship;
          opp.luk:=r[a].luk;
          opp.str:=r[a].str;
          opp.dex:=r[a].dex;
          opp.credits:=r[a].credits;
          if opp.credits<0 then opp.credits:=0;
          z:=r[a].exp/10;
          finder:=false;
          if enemy=r[b].ally then
           begin
            r[b].alliance:=0;
            r[a].alliance:=0;
           end;

          battle;
        end;

    end;

  end;


procedure red;
  begin
    assign(infile,'gfiles\red.par');
    reset(infile);
    searcher;
    battle;
  end;

procedure docs;
  begin
    printm('Now loading documentation');
    prtm('Press ENTER to continue');
    input(option,1);
    assign(infile,'gfiles\docs.par');
    reset(infile);
    readln(infile,number);
     a:=1;
       repeat
        checkhangup;
        if hangup then leave;
        readln(infile,doc);
        ansic(4);
        printam(doc);
        nl;
        if a=20 then
          begin
            prtm('Hit enter to continue');
            input(option,1);
          end;
        a:=a+1;
       until (a>number) or (abort) or (hangup);
     close(infile);
   end;


procedure create;
  begin
    print('');
    docs;
    print('');
    a:=keep+1;
    r[a].name:=thisuser.name;
    printm('You must be given a new character then!');
    printm('I will now make you a character that is just like you!');
    a:=keep+1;
    r[a].str:=spin;
    r[a].status:=0;
    keep:=keep+1;
    r[a].int:=spin;
    r[a].luk:=spin;
    r[a].alliance:=0;
    r[a].dex:=spin;
    r[a].con:=spin;
    r[a].cha:=spin;
    r[a].credits:=0;
    r[a].weapon:=1;
    r[a].ship:=1;
    r[a].exp:=0;
    r[a].bank:=(random(199)+1);
    r[a].lev:=1;
    r[a].shield:=(random*4+1)+r[a].con;
    r[a].flights:=3;
    print('');
    b:=a;
  end;



procedure universe;
 begin
  cls;
  uni:=true;
  while uni do
    begin
     if trips>9 then
        begin
          print('');
          printm('You have expended all your Clones!');
          printm('You are allowed 10 per fight.');
          uni:=false;
        end
      else
        begin
        if verbose then
          begin
            printm('"You look about you and notice different hallways of many colors.');
            printm('You somehow get the feeling that this just isnt you day');
            printm('but is it ever?....');
            print('');
            prtm('TYPE ENTER TO CONTINUE');
            input(shit,1);
            universeexplain;
          end;
        prtm('Hallway command?');
        input(option,1);
        if (option='?') and (verbose=false) then universeexplain;
        if option='Q' then uni:=false;
        if option='R' then red;
        if option='O' then orange;
        if option='Y' then yellow;
        if option='G' then green;
        if option='B' then blue;
        if option='I' then indigo;
        if option='V' then violet;
        if option='U' then ultraviolet;
        if option='H' then heal;
  end;
  end;
  end;

procedure strait;
  var
    p:integer;

  begin
    for p:=1 to 25-length(strip) do
      strip:=' '+strip;
  end;

procedure weaponlist;
  begin
    print('');
    print('');
     begin
       a:=1;
         repeat
           checkhangup;
           if hangup then leave;
           str(cost[a]:9:0,shit);
           str(a:2,opp.name);
           ansic(4);
           strip:=wname[a];
           strait;
           printa(opp.name+'.'+(strip)+'   '+shit+'  '+(sname[a]),abort,next);
           print('');
           a:=a+1;
         until (a>25) or (abort);

     end;
   end;


procedure readlist;
  begin
    assign(infile,'gfiles\character.par');
    reset(infile);
     readln(infile,keep);
      a:=1;
      while (a<=keep) do
        begin
          readln(infile,r[a].name);
          readln(infile,r[a].status);
          if r[a].status=1 then
            readln(r[a].killer);
          readln(infile,r[a].str,r[a].int,r[a].luk,r[a].dex,r[a].con,r[a].cha
          ,r[a].exp,r[a].lev,r[a].shield,r[a].weapon,r[a].ship,r[a].credits
          ,r[a].flights,r[a].bank);
            a:=a+1;
        end;
        close(infile);
      end;

procedure weaponquip;
  begin
    printm('You walk into the weapon area and are dazzled by the multitude of');
    printm('Battle Equipment.....Jackbots line the wall, watching your every"');
    printm('move.... You run over to one of the signs .......');
    printm('Oit seems to be a list of the Equipment in this room.....');
    print('');
    prtm('TYPE ENTER TO CONTINUE');
    input(shit,1);
    weaponlist;
  end;

procedure weaponshop;
  begin
    cls;
    print('');
    print('');
      option:='B';
      while option<>'' do

     begin
      repeat
      if verbose then weaponquip;
      prtm('Would you like to buy or sell(B or S)?');
      input(option,1);
      checkhangup;
      until (option='B') or (option='S') or (option='') or (option='Q') or hangup;
      if hangup then leave;
        if option='B' then
          begin
            print('');
           repeat
            {$I-}
            prtm('What number(0 for list)?');
            input(shit,5);
            buy:=value(shit);
            {$I+}
            j:=ioresult;
            checkhangup;
           until (hangup) or(j=0);
           if hangup then leave;

              if (buy=0) and (verbose=false) then weaponlist
              else
                begin
                 if buy>25 then printm('Excuse Me')
                 else if cost[round(buy)]>r[b].credits then printm('Not enough credits!')
                 else
                   begin
                     repeat
                     prtm('(W)eapon or (S)hip?');
                     input(option,1);
                     checkhangup;
                     until (hangup) or (option<>'D');
                     if hangup then leave;
                     if option='W' then
                       begin
                         r[b].credits:=r[b].credits-cost[round(buy)];
                         r[b].weapon:=buy;
                         printm('You have bought a '+wname[round(buy)]);
                         r[b].attack:=find1;
                         r[b].power:=find2;
                       end
                     else if option='S' then
                       begin
                         r[b].credits:=r[b].credits-cost[round(buy)];
                         r[b].ship:=buy;
                         printm('You have bought a '+sname[round(buy)]);
                       end
                     else printm('W or S, nothing else will be acknowledged!');
                   end;
                end;
            end
          else if option='S' then
            begin
              repeat
              prtm('Sell your (W)eapon or (S)hip?');
              input(option,1);
              checkhangup;
              until (hangup) or (option='W') or (option='S') or (option='') or (option='Q');
              if hangup then leave;
                if option='W' then
                  begin
                    y:=(round(r[b].weapon));
                    x:=r[b].cha;
                    x:=x*cost[y];
                    x:=((1/20)*x);
                    str(x:7:0,shit);
                    repeat
                    prtm('I can give you '+shit+' OK?');
                    input(option,1);
                    checkhangup;
                    until (hangup) or (option<>'D');
                    if hangup then leave;
                    if option='Y' then
                      begin
                        r[b].weapon:=1;
                        r[b].credits:=r[b].credits+x;

                      end;
                   end
                 else if option='S' then
                   begin
                     x:=((1/20)*(r[b].cha)*(cost[round(r[b].ship)]));
                     str(x:7:0,shit);
                     repeat
                     prtm('I can give you '+shit+' OK?');
                     input(option,1);
                     until (hangup) or (option<>'D');
                     if option='Y' then
                       begin
                         r[b].ship:=1;
                         r[b].credits:=r[b].credits+x;
                       end;
                    end;
            end;
       end;
end;

procedure threeslot(var hack:real);
  var
    win : array[1..3] of integer;
    n,o,p : integer;
    lucky : real;
  begin
      lucky:=(r[b].luk-15)/2;
      for o:=1 to 3 do
      begin
        checkhangup;
        if hangup then leave;
        for n:=1 to 15000 do
         for p:=1 to 1 do
           begin
           end;
        win[o]:=round(random(9)+1);
         if o>1 then
          begin
          if lucky<0 then
            begin
              if (lucky*(-1))>(random(100)+1) then
                  if win[o]=win[o-1] then win[o]:=round(random(9)+1);
            end
          else if lucky>0 then
            begin
              if lucky>(random(100)+1) then
                if win[o]<>win[o-1] then win[o]:=win[o-1];
            end;
          end;
          str(win[o],shit);
          if o<3 then prt(shit);
          if o=3 then print(shit);
        end;
      if (win[1]=win[2]) or (win[1]=win[3]) or (win[2]=win[3]) then
        begin
          if (win[1]=win[2]) and (win[2]=win[3]) then
            begin
              printm('You got a triple!');
              r[b].credits:=r[b].credits+(70*hack);
              str((70*hack):1:0,shit);
            end
          else
            begin
              printm('You got a double!');
              r[b].credits:=r[b].credits+(2.75*hack);
              str((2.75*hack):1:0,shit);
            end;
          end

          else
            begin
              printm('HAHA, you just lost your bet!');
            end;
 end;

procedure sevenslot(var bet : real);
  var
    wow:array[0..9] of integer;
    win:array[1..7] of integer;
    o,p,q,n : integer;
    payoff,lucky : real;
  begin
    lucky:=(r[b].luk-15)*2;
    win[1]:=round(random(10));
    str(win[1],shit);
      prt(shit);
    for o:=2 to 7 do
     begin
      win[o]:=round(random(10));
      if lucky<0 then
        begin
          if (lucky*(-1))>(random(100)+1) then
          if win[o]=win[o-1] then
            win[o]:=round(random(10));
        end
      else if lucky>0 then
        begin
          if lucky>(random(100)+1) then
           begin
              if win[o]<>7 then
              win[o]:=7;
           end;
        end;

      str(win[o],shit);
      prt(shit);
      for n:=1 to 15000 do
        begin
        end;
     end;
     nl;
     for o:=0 to 9 do
     wow[o]:=0;
     payoff:=0;
     for o:=0 to 9 do
      begin
       for p:=1 to 7 do
         if win[p]=o then wow[o]:=wow[o]+1;
      end;
     for o:=0 to 9 do
       if wow[o]>2 then
         begin
           if (wow[o]=3) and (payoff<3*bet) then
            begin
             payoff:=3*bet;
             printm('You got a triple!');
            end
           else if wow[o]=4 then
            begin
             payoff:=30*bet;
             printm('You got 4 of a kind!');
            end
           else if wow[o]=5 then
            begin
             payoff:=450*bet;
             printm('You got 5 of a kind!');
            end
           else if wow[o]=6 then
            begin
             printm('You got 6 of a kind!');
             payoff:=12500*bet;
            end
           else if wow[o]=7 then
            begin
             payoff:=(7500*bet);
             payoff:=(10*payoff);
             printm('How''d you do that????!!!');
            end;
         end;
         if payoff=0 then printm('Hah! You lost!');
         r[b].credits:=r[b].credits+payoff;
 end;

procedure slots;
  var
    hack,luck,spin : real;
    shitty : string[12];
    o : real;
    gam : integer;
    opt : char;

  begin
    cls;
    nl;
    writeln(date);
    printm('(T)hree slot machine');
    printm('(S)even slot machine');
    prtm('Which would you like?');
    onek(opt,'TS');
    repeat
    printm('Good Luck!');
    repeat
    if gamble>19 then
      begin
        printm('You have used your 20 gambles and I hope you are satisfied!');
        exit;
      end;
    str(r[b].credits:1:0,shit);
    printm('You have '+shit+' credits.');
    gam:=20-gamble;
    str(gam,shit);
    printm('You have '+shit+' gambles left.');
    printm('House Limit: 25000 ');
    prtm('How much you gonna bet?');
    {$I-}
    input(shit,5);
    hack:=value(shit);
    {$I+}
    if hack>25000 then
      begin
        printm('You mean the max of 25000!!!');
        hack:=25000;
      end;
    if hack>r[b].credits then
      begin
        printm('You don''t have that much!');
        printm('So you bet all you had?  hehe .. Geek!');
        hack:=r[b].credits;
      end;
    if hack<0 then
      begin
       hack:=0;
      end;
    if hack=0 then exit;
    j:=ioresult;
    checkhangup;
    until (j=0) or (hangup);
    if hangup then leave;
    gamble:=gamble+1;
    r[b].credits:=r[b].credits-hack;
    if opt='T' then threeslot(hack)
    else sevenslot(hack);


              checkhangup;
      until (hack=0) or (hangup);
      if hangup then leave;
  end;

procedure doglist;
  begin
    printm('This is a list of the encounters that have occured today:');
    readla;
    for a:=1 to number do
     begin
      checkhangup;
      if hangup then leave;
      printm(result[a]);
     end;
  end;


procedure help;
  var
    v:integer;
  begin
    print('');
    assign(infile,'gfiles\menu.par');
    reset(infile);
    readln(infile,number);
    v:=1;
    repeat
      print('');
      readln(infile,shit);
      ansic(3);
      printam(shit);
      v:=v+1;
    until (v>number) or (abort);
    close(infile);

  end;

procedure switch;
  begin
    if verbose=true then
      verbose:=false
    else verbose:=true;
  end;


begin
  errorptr:=ofs(error);
  sysoplog('Played Paranoia');
  hangup:=false;
  gamble:=0;
  allied:=false;
  iport;
  cls;
  vary:=supplant;
  dog:=0;
  doga:=false;
  for a:=1 to 74 do
    r[a].damage:=0;
  play:=true;
  trips:=0;
  verbose:=true;
  found:=true;
  verify:=0;
  repeat
  printfile('gfiles\comput.par');
  prtm('" Welcome, Trouble Shooter. Are you happy? " :');
  input(option,1);
  if option='N' then printm('" Failure to be happy is treason Trouble Shooter ".');
  if option='N' then print(' A tiny pill shoots out below the computer monitor.');
  if option='N' then printm('" Please take Drug to be happy Trouble Shooter ".');
  if option='N' then print(' You pause for a moment...');
  if option='N' then print(' You look at the pill and think..." Hey, why not? "');
  if option='Y' then prtm('Do you want verbose messages?');
  input(option,1);
  checkhangup;
  until (hangup) or (option<>'');
  if hangup then leave;
  if option='N' then verbose:=false;
    printm('Now for the log-on procedure:');
    name:=thisuser.name;
    printm('Welcome '+name+'!');
    if (name='OMINOUS COMPUTER') or (name='MADRAK') then
     begin
       printm('You must given a new character then!');
       prtm('HIT ENTER TO CONTINUE');
       input(shit,1);
       printm('Just kidding!');
     end;
      assign(infile,'gfiles\character.par');
      reset(infile);
      readln(infile,number);
      keep:=number;
      a:=1;
      b:=1;
      repeat
          readln(infile,r[a].name);
          readln(infile,r[a].status);
          if r[a].status=1 then readln(infile,r[a].killer);
          read(infile,r[a].str);
          read(infile,r[a].int);
          read(infile,r[a].luk);
          read(infile,r[a].dex);
          read(infile,r[a].con);
          read(infile,r[a].cha);
          read(infile,r[a].exp);
          read(infile,r[a].lev);
          read(infile,r[a].shield);
          read(infile,r[a].weapon);
          read(infile,r[a].ship);
          read(infile,r[a].credits);
          read(infile,r[a].flights);
          readln(infile,r[a].bank);
          a:=a+b;
          until (a>keep);
       close(infile);
       for a:=1 to keep do
         begin
          if r[a].name=name then found:=false;
          if r[a].name=name then b:=a;
         end;
       if found then
        begin
         create;
        end;
        checkday;
        if (r[b].flights<1) and (thisuser.sl<255) then
          begin
            printm('You are out of clones for today.  Call back tomorrow!');
            quickexit;
          end;
        r[b].flights:=r[b].flights-1;
       assign(infile,'gfiles\weapons.mou');
       reset(infile);
         for a:=1 to 25 do
          begin
           readln(infile,wname[a]);
           readln(infile,w2[a],w3[a]);
          end;
       close(infile);
       assign(infile,'gfiles\ships.mou');
       reset(infile);
         for a:=1 to 25 do
           readln(infile,sname[a]);
       print('');
       close(infile);
         assign(infile,'gfiles\prices.mou');
         reset(infile);
           for a:=1 to 25 do
             readln(infile,cost[a]);
         close(infile);
         r[b].attack:=find1;
         r[b].power:=find2;
       print('');
         assign(infile,'gfiles\experience.mou');
         reset(infile);
           for a:=1 to 28 do
             readln(infile,required[a]);
         close(infile);

        assign(infile,'gfiles\message.mou');
        reset(infile);
          repeat
            begin
              readln(infile,mess[a]);
              printm(mess[a]);
            end;
          until (eof(infile));
        close(infile);
        print('');
        if r[b].status=1 then printm('You were slain by '+r[b].killer+'!');
        r[b].status:=0;
        print('');
        vary2:=1;
        printm('Press ENTER or RETURN');
        repeat
        input(option,1);
        checkhangup;
        until (hangup) or (option='');
        if hangup then leave;
        statussheet;
        levelupdate;

        play:=true;
         repeat
           vary2:=1;
           if verbose then
             begin
               printm('You are standing in a hall way.  You see many different doors about you.');
               help;
             end;
           prtm('What option(? for list of current options)?');
           input(option,1);
             if option='Q' then play:=false
             else if option='A' then universe
             else if option='H' then heal
             else if option='S' then statussheet
             else if option='W' then weaponshop
             else if option='L' then levelupdate
             else if option='B' then doggie
             else if option='D' then docs
             else if option='V' then switch
             else if option='F' then doglist
             else if option='G' then slots
             else if option='P' then playerlist
             else if option='C' then munitionbank
             else
               begin
                 if not verbose then help;
               end;
             checkhangup;
          until (play=false) or (hangup);b0        leave;

end.