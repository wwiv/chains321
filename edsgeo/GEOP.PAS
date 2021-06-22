program GEOPOLITIK; {v 1.0}
{$I COMMON.PAS}
type {I considered any variables without comments to be self evident}
    bigstring=string[160];
    namstring=string[25];
    force=array[1..4] of real;
    percent=real;
    index=record
           devel,credit:real;
    end;
    area=record
           nombre:namstring; {name}
           comm:array[1..6] of index; {commodity development levels}
           men,wandc:real; {woman and children}
           rebels:force;
           controller:integer;
    end;
    country=record
           controller:namstring;
           nombre:namstring;
           military:force;
           nukes:array[1..5] of real;
           defense:percent;
           self,ally,friend:percent; {retaliation levels}
           rel:array[1..20] of char; {diplomatic relations}
           percapita:real; {social expenditures}
           dinero:real; {money for you gringos}
           intel:percent; {intelligence}
           embarg:array[1..20] of real; {embargoes}
           lmnth,attacks:integer; {last month on}
           ncomm,tcomm:array[1..6] of real; {national and trade stockpiles}
           price,exim:array[1..6] of real; {export/import level}
           tax:percent;
           ispy:integer; {spies left}
    end;
    planet=record
          pop:real; {total population}
          radiation,nukewinter:percent;
          lstdate:bigstring;
          currmonth,curryear:integer;
    end;
    message=record
           mess:bigstring;
           from,por:integer;
    end;
    Stuffy=record
           Stuff:Integer;
    end;

const
     commods:array[1..6] of string[11]=('Agriculture','Energy','Metals','Nonmetals','Industry','Technology');
     commworth:array[1..6] of real=(25000.0,60000.0,40000.0,50000.0,80000.0,100000.0);
     weaps:array[1..4] of string[6]=('troops','tanks','planes','ships');
     pweaps:array[2..4] of string[8]=('[T]anks','[P]lanes','[S]hips');
     nuke:array[1..5] of string[15]=('Minuteman silos','MX silos','submarines','bombers','space platforms');
     pnuke:array[1..5] of string[17]=('[M]inuteman silos','M[X] silos','[S]ubmarines','[B]ombers','space [P]latforms');
     weapcost:array[2..4,3..6] of integer=((4,2,5,7),(4,3,7,10),(12,10,13,9));
     weapmon:array[2..4] of real=(1,1,2);
     nukecost:array[1..5,3..6] of integer=((5,7,20,18),(10,13,30,70),(13,15,50,60),(7,5,43,50),(50,60,85,170));
     nukemon:array[1..5] of real=(2,14,18,13,40);
     wh:array[1..5] of real=(1,10,10,7,30);
     mnames:array[1..12] of string[3]=('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC');
     rheader='                   Region( #)';
     rqual='                   ==========';

var
    nation:array[1..20] of country;
    region:array[1..80] of area;
    world:planet;
    Stuffx:stuffy;
    Stufffile:file of Stuffy;
    nations:file of country;
    regions:file of area;
    newspaper:file of bigstring;
    letters:file of message;
    worldfile:file of planet;
    trashcan:file of bigstring;
    co,victor,cn,c1,c2:integer;
    sel:char;
    dummy,m:message;
    currdate:string[10];
    ab,nx,qut,inv,yah,ok2play:boolean;
    lilmess:bigstring;
    baduser,handl:bigstring;
    art:message;
    zap:real; {average wealth/number of regions}

procedure pa(i:bigstring); {print a string allowing for abort}
begin
     if not ab then printacr(i,ab,nx);
end;

procedure pra(i:bigstring); {same as pa, but without a carriage return}
begin
     if not ab then printa(i,ab,nx);
end;

procedure goodbye; {exit to BBS}
begin
     print('* * * Saving * * *');
     rewrite(nations);
     for c1:=1 to 20 do write(nations,nation[c1]);
     close(nations);
     rewrite(regions);
     for c1:=1 to 80 do write(regions,region[c1]);
     close(regions);
     rewrite(worldfile);
     write(worldfile,world);
     close(worldfile);
     return;
end;

procedure inputn(var p:namstring); {input country's name}
var a:bigstring;
begin
     checkhangup;
     if hangup then goodbye;
     inputl(a,25);
     if hangup then goodbye;
     p:=a;
end;

procedure silly(var a,b:real;c:integer;d:percent); {get nuclear retaliation levels}
var
   e,f:real;
begin
     e:=d/100;
     with nation[c] do begin
          f:=int(e*nukes[1]);
          a:=a+f;
          nukes[1]:=nukes[1]-f;
          f:=int(e*nukes[2]);
          a:=a+f*10;
          nukes[2]:=nukes[2]-f;
          f:=int(e*nukes[3]);
          b:=b+f*10;
          nukes[3]:=nukes[3]-f;
          f:=int(e*nukes[4]);
          a:=a+f*7;
          nukes[4]:=nukes[4]-f;
          f:=int(e*nukes[5]);
          a:=a+f*30;
          nukes[5]:=nukes[5]-f;
     end;
end;

procedure census; {determine world.pop}
var f:integer;
begin
     world.pop:=0;
     for f:=1 to 80 do world.pop:=world.pop+region[f].men+region[f].wandc+region[f].rebels[1];
     for f:=1 to 20 do world.pop:=world.pop+nation[f].military[1];
end;

function cont(p:integer):integer; {how many regions controlled by nation[p]}
var f,g:integer;
begin
     g:=0;
     for f:=1 to 80 do if region[f].controller=p then g:=g+1;
     cont:=g;
end;

function pad(p:bigstring;q:integer):bigstring; {pad a string out to length q}
var f,g:integer;
    h:bigstring;
begin
     g:=q-length(p);
     h:='';
     for f:=1 to g do h:=h+' ';
     pad:=h+p;
end;

function st(a:real;b:integer):bigstring; {convert number to string with commas}
var p:bigstring;
    f:integer;
begin
     str(a:0:0,p);
     f:=length(p);
     if f>4 then while f>3 do begin
           f:=f-3;
           if not ((f=1) and (p[1]='-')) then insert(',',p,f+1);
     end;
     st:=pad(p,b);
end;

function rname(f:integer):bigstring; {name of region with number}
begin
     rname:=pad(region[f].nombre+'('+st(f,2)+')',29);
end;

function nname(f:integer):bigstring; {name of nation with number}
begin
     nname:=pad(nation[f].nombre+'('+st(f,2)+')',29);
end;

function skew(a:real;c:integer):bigstring; {same as st, only the number is distorted depending on intelligence level}
var f,g:real;
    h:integer;
begin
     h:=round(100-nation[cn].intel);
     if random<0.5 then g:=1 else g:=-1;
     f:=int(a+g*a*random(h)/100);
     skew:=st(f,c);
end;

function convert(a,b:integer):bigstring; {number -> month name}
begin
     convert:=mnames[a]+' '+st(b,0);
end;

function mon2int(a:bigstring):integer; {month name -> number}
var f:integer;
begin
     mon2int:=0;
     for f:=1 to 12 do if mnames[f]=a then mon2int:=f;
end;

function embargo:boolean; {check for embargoes}
var f:integer;
    g:boolean;
begin
     g:=false;
     for f:=1 to 20 do with nation[f] do if embarg[cn]>0 then begin
         print(nombre+' is embargoing you with '+st(embarg[cn],0)+' ships.');
         g:=true;
     end;
     embargo:=g;
     if g then print('You may not trade or carry out attacks until all embargoing ships are destroyed.');
end;

function strength(p:force):real; {strength of a military force}
begin
     strength:=p[1]+25*p[2]+50*p[3];
end;

procedure pstock; {print out current national stockpile}
var f:integer;
begin
     prompt('Your national stockpile contains');
     for f:=1 to 6 do prompt(' ['+st(nation[cn].ncomm[f],0)+' '+copy(commods[f],1,3)+'] ');
     print(#8);
end;

procedure pmoney; {show contents of treasury}
begin
     with nation[cn] do if dinero>0 then print('You have $'+st(dinero,0)+'.')
                                    else print('You are $'+st(-dinero,0)+' in debt.');
end;

procedure ppop; {population for all controlled regions}
var
   f:integer;
   h:real;
begin
     h:=0;
     for f:=1 to 80 do with region[f] do if controller=cn then h:=h+wandc+men;
     h:=h+nation[cn].military[1];
     print('National population is '+st(h,0));
end;

procedure getreal(var z:real;a,b:real); {input a number}
var
   q:bigstring;
   err:integer;
   bk:real;
begin
     a:=int(a);
     b:=int(b);
     bk:=z;
     if a=b then begin
        print(st(a,0));
        z:=a;
        exit;
     end;
     repeat
           checkhangup;
           if hangup then goodbye;
           inputl(q,20);
           if hangup then goodbye;
           if q='' then q:='0';
           if upcase(q[1])='Q' then begin
              z:=bk;
              qut:=true;
              exit;
           end;
           val(q,z,err);
           z:=int(z);
           if (z<a) or (z>b) then err:=1;
           if err>0 then ynq('Numbers from '+st(a,0)+' to '+st(b,0)+' only (Q aborts):  ');
     until err=0;
end;

function minn(x,y:real):real; {take the minimum of x and y}
begin
     if x>y then minn:=int(y) else minn:=int(x);
end;

function kill(x:real;y:real):real; {determine casualties}
begin
     kill:=int(random*x*y/100);
end;

procedure fleetbattle(var a1,a2:real;ac:real); {too obvious for comment}
var f2,f3,f4:real;
begin
     f4:=ac;
     print('Air cover ratio is '+st(f4*100,0)+'%');
     f4:=f4+(1-f4)/2;
     if (a1>0) and (a2>0) then repeat
        print('Your navy of '+st(a1,0)+' ships attacks the enemy fleet of '+st(a2,0)+' ships.');
        f2:=minn(kill(a2,30)+1,a1);
        f3:=minn(kill(a1,20)*f4+1,a2);
        a1:=a1-f2;
        a2:=a2-f3;
        print('Your fleet lost '+st(f2,0)+' ship(s).');
        print('The enemy navy lost '+st(f3,0)+' ship(s).');
        yah:=true;
        if (a1>0) and (a2>0) then begin
           ynq('Continue the attack? ');
           yah:=yn;
        end;
     until (a1=0) or (a2=0) or (a1>a2*2) or not yah;
end;

procedure fight(var a1,a2:force;m:real); {land battle}
var
   f1:integer;
   f2,f3,f4,f5,f6,f7,f8,f9,f10:real;
begin
     yah:=true;
     f4:=a1[3]/(a2[3]+1);
     if (a1[4]>0) and (a2[4]>0) then fleetbattle(a1[4],a2[4],f4);
     if yah and (a1[4]>0.5) then print('The enemy fleet is vanquished.');
     if ((a1[4]>=10) and yah) or (m=11) then repeat
           print('Your army attacks the enemy forces.');
           f2:=minn(kill(a2[3],3*m)+kill(a2[2],0.5*m)+kill(a2[1],m*0.1),a1[3]);
           f3:=minn(kill(a1[3],3)+kill(a1[2],0.5)+kill(a1[1],0.1)+1,a2[3]);
           f4:=minn(kill(a2[3],4*m)+kill(a2[2],2*m)+kill(a2[1],0.02*m),a1[2]);
           f5:=minn(kill(a1[3],4)+kill(a1[2],2)+kill(a1[1],0.02)+1,a2[2]);
           f6:=minn(kill(a2[3],100*m)+kill(a2[2],25*m)+kill(a2[1],4*m),a1[1]);
           f7:=minn(kill(a1[3],100)+kill(a1[2],25)+kill(a1[1],4)+1,a2[1]);
           if m<>2 then begin
              f2:=minn(f2+1,a1[3]);
              f4:=minn(f4+1,a1[2]);
              f6:=minn(f6+1,a1[1]);
           end;
           a1[3]:=a1[3]-f2;
           a2[3]:=a2[3]-f3;
           a1[2]:=a1[2]-f4;
           a2[2]:=a2[2]-f5;
           a1[1]:=a1[1]-f6;
           a2[1]:=a2[1]-f7;
           prompt('Your army has '+st(a1[1],0)+' troop(s), ');
           print(st(a1[2],0)+' tank(s), and '+st(a1[3],0)+' plane(s) left.');
           print('(Total strength:  '+st(strength(a1),0)+')');
           prompt('The enemy army has '+st(a2[1],0)+' troop(s), ');
           print(st(a2[2],0)+' tank(s), and '+st(a2[3],0)+' plane(s) left.');
           print('(Total strength:  '+st(strength(a2),0)+')');
           yah:=true;
           if strength(a2)*5*m>strength(a1) then begin
              ynq('Continue the attack? ');
              yah:=yn;
           end;
     until ((a1[1]=0) and (a1[2]=0) and (a1[3]=0)) or (strength(a2)*5*m<strength(a1)) or not yah
     else begin
          print('You must have a fleet of at least 10 ships with a 2-1 fleet ratio for a mainland attack');
          victor:=0;
          exit;
     end;
     if strength(a2)*5>strength(a1) then victor:=2 else
      if strength(a2)*5*m<strength(a1) then victor:=1 else victor:=0;
end;

function rworth(p:integer):real; {worth of a single region}
var f:integer;
    z:real;
begin
     z:=0;
     with region[p] do for f:=1 to 6 do z:=z+comm[f].devel*commworth[f];
     rworth:=z;
end;

procedure addon(lmess:bigstring); {write a newspaper article}
begin
     assign(newspaper,datapath+'THISYEAR.GEO');
     reset(newspaper);
     seek(newspaper,filesize(newspaper));
     write(newspaper,lmess);
     close(newspaper);
end;

function checkk(a,r:char):boolean; {used by getreg and getnat}
var p:boolean;
begin
   case a of
     'S': p:=(r='S');
     'A': p:=(r<>'S');
     'F': p:=(r in ['F','N','H','W']);
     'N': p:=(r in ['N','H','W']);
     'H': p:=(r in ['H','W']);
     'W': p:=(r='W');
     else p:=true;
   end;
   if inv and (a<>'S') then p:=not p;
   checkk:=p;
end;

procedure nomesg(r:char;p:boolean); {ditto}
begin
     if p then case r of
        'S':print('You own all the regions!.');
        'A':print('All other nations are allied to you.');
        'F':print('All other nations are either friends or allies.');
        'N':print('You are not at war with or hostile to any other nation.');
        'H':print('You are not at war with any other nation.');
        'W':print('Curiouser and curiouser.');
     end
     else case r of
        'S':print('You own no regions!');
        'A':print('You have no allies.');
        'F':print('You have neither allies nor friends.');
        'N':print('No nation is even neutral towards you.');
        'H':print('Every nation is at war with you.');
        'W':print('Something fishy is going on.');
     end;
end;

function adprice(nat1,nat2,commodity:integer):real; {adjusted price for friends/allies}
var z:real;
begin
     z:=nation[nat1].price[commodity];
     if nation[nat1].rel[nat2]='F' then z:=z-z/10;
     if nation[nat1].rel[nat2]='A' then z:=z-z/5;
     adprice:=z;
end;

procedure getnat(mmm:bigstring;var which:integer;restrict,info:char); {input a nation's name or number}
const nheader='                   Nation( #)';
      nqual='                    =========';
var
   bk,f,h:integer;
   g:namstring;
   p:array[1..20] of boolean;
   q:boolean;
   hd:string[80];
begin
     bk:=which;
     which:=0;
     for f:=1 to 20 do if inv then p[f]:=checkk(nation[cn].rel[f],restrict)
                              else p[f]:=checkk(nation[f].rel[cn],restrict);
     q:=false;
     for f:=1 to 20 do q:=q or p[f];
     if not q then begin
        nomesg(restrict,inv);
        qut:=true;
        inv:=false;
        exit;
     end;
     repeat
           ynq(mmm+'what nation? [? for list, Q aborts] ');
           checkhangup;
           if hangup then goodbye;
           inputn(g);
           if hangup then goodbye;
           if ((upcase(g[1])='Q') and (length(g)=1)) or (g='') then begin
              qut:=true;
              which:=bk;
              inv:=false;
              exit;
           end;
           if g='?' then case info of
                'D':begin
                         print(nheader+'   You   Them');
                         print(nqual+'   ===   ===');
                    end;
                'E':begin
                         print(nheader+'   Your Embargo   Their Embargo');
                         print(nqual+'   ============   =============');
                    end;
                'W':begin
                         print(nheader+'   Warheads');
                         print(nqual+'   ========');
                    end;
                'R':begin
                         print(nheader+'   Regions');
                         print(nqual+'   =======');
                    end;
                'C':begin
                         print(nheader+'   AGR   ENE   MET   NON   IND   TEC');
                         print(nqual+'   ===   ===   ===   ===   ===   ===');
                   end;
                'P':begin
                         print(nheader+'   Price/unit   Volume');
                         print(nqual+'   ==========   ======');
                    end;
           end;
           ab:=false;
           if g='?' then for f:=1 to 20 do if p[f] then with nation[f] do begin
            hd:=nname(f);
            case info of
             'I':pa(hd);
             'D':pa(hd+pad(nation[cn].rel[f],6)+pad(rel[cn],6));
             'E':pa(hd+st(nation[cn].embarg[f],15)+st(nation[f].embarg[cn],16));
             'W':pa(hd+skew(nukes[1]+nukes[2]*10+nukes[3]*10+nukes[4]*5+nukes[5]*30,11));
             'R':pa(hd+st(cont(f),10));
            'C':pa(hd+skew(ncomm[1],6)+skew(ncomm[2],6)+skew(ncomm[3],6)+skew(ncomm[4],6)+skew(ncomm[5],6)+skew(ncomm[6],6));
             'P':if nation[f].tcomm[co]>0 then pa(hd+st(adprice(f,cn,co),13)+st(nation[f].tcomm[co],9));
            end;
           end;
           if g<>'?' then for f:=1 to 20 do if (nation[f].nombre=g) and p[f] then which:=f;
           if which=0 then begin
              val(g,f,h);
              if (h=0) and (0<f) and (f<=20) and p[f] then which:=f;
           end;
     until which<>0;
     inv:=false;
end;

procedure getreg(mmm:bigstring;var which:integer;restrict,info:char); {input a region's name or number}
var
   bk,f,h,f1:integer;
   g:namstring;
   p:array[1..80] of boolean;
   q:boolean;
   t:real;
   hd,hd1:string[80];
begin
     bk:=which;
     which:=0;
     for f:=1 to 80 do if inv then p[f]:=checkk(nation[cn].rel[region[f].controller],restrict)
                              else p[f]:=checkk(nation[region[f].controller].rel[cn],restrict);
     q:=false;
     for f:=1 to 80 do q:=q or p[f];
     if not q then begin
        nomesg(restrict,inv);
        qut:=true;
        inv:=false;
        exit;
     end;
     repeat
           ynq(mmm+'what region? [? for list, Q aborts] ');
           checkhangup;
           if hangup then goodbye;
           inputn(g);
           if hangup then goodbye;
           if ((upcase(g[1])='Q') and (length(g)=1)) or (g='') then begin
              inv:=false;
              qut:=true;
              which:=bk;
              exit;
           end;
           if g='?' then case info of
                'D':begin
                         print('                                   Development/Credits');
                         print(rheader+'     AGR     ENE     MET     NON     IND     TEC');
                         print(rqual+'     ===     ===     ===     ===     ===     ===');
                    end;
                'W':begin
                         print(rheader+'            Worth');
                         print(rqual+'            =====');
                    end;
                'T':begin
                         print(rheader+'   Eligible men');
                         print(rqual+'   ============');
                    end;
                'R':begin
                         print(rheader+'   Rebel strength');
                         print(rqual+'   ==============');
                    end;
                'P':begin
                         print(rheader+'     Men     Women&kids');
                         print(rqual+'     ===     ==========');
                    end;
           end;
           ab:=false;
           if g='?' then for f:=1 to 80 do if p[f] then with region[f] do begin
            hd:=rname(f);
            case info of
              'D':begin
                       hd1:=hd;
                       for f1:=1 to 6 do hd1:=hd1+pad(st(comm[f1].devel,0)+'/'+st(comm[f1].credit,0),8);
                       pa(hd1);
                  end;
              'W':pa(hd+pad('$'+st(rworth(f),0),17));
              'T':pa(hd+st(men,15));
              'R':pa(hd+st(strength(rebels),17));
              'P':pa(hd+st(men,8)+st(wandc,15));
            end;
           end;
           if g<>'?' then for f:=1 to 80 do if (region[f].nombre=g) and p[f] then which:=f;
           if which=0 then begin
              val(g,f,h);
              if (h=0) and (0<f) and (f<=80) and p[f] then which:=f;
           end;
     until which<>0;
     inv:=false;
end;

function worth(p:integer):real; {national worth}
var f:real;
    g:integer;
begin
     f:=0;
     for g:=1 to 80 do if region[g].controller=p then f:=f+rworth(g);
     f:=f+nation[p].dinero;
     worth:=f;
end;

procedure newnat(f:integer); {determine where a region will attach itself to}
var z,f1,n:integer;
    r:real;
begin
     z:=region[f].controller;
     r:=worth(z);
     n:=0;
     if n=0 then repeat
        n:=random(20)+1;
     until (n<>z) and (nation[n].dinero>0);
     addon(region[f].nombre+' revolted from '+nation[z].nombre);
     addon('and joined '+nation[n].nombre);
     region[f].controller:=n;
     with nation[n] do for f1:=1 to 4 do military[f1]:=military[f1]+region[f].rebels[f1];
     with region[f] do for f1:=1 to 4 do rebels[f1]:=0;
end;

procedure getzap; {determine average worth/number of regions}
var i:real;
    f:integer;
begin
     i:=0;
     for f:=1 to 20 do i:=i+worth(f)/(cont(f)+1);
     zap:=i/20;
end;

procedure sendmess; {send message}
begin
     assign(letters,datapath+'MESSAGES.GEO');
     reset(letters);
     dummy.por:=1;
     while not eof(letters) and not (dummy.por=0) do read(letters,dummy);
     if not eof(letters) then seek(letters,filepos(letters)-1);
     write(letters,art);
     close(letters);
end;

function bestnat:integer; {determine the wealthiest nation}
var f:integer;
    g:real;
begin
     bestnat:=1;
     g:=worth(1)/(cont(1)+1);
     for f:=2 to 20 do if worth(f)/(cont(f)+1)>g then begin
         bestnat:=f;
         g:=worth(f)/(cont(f)+1);
     end;
end;

function unrest(a:integer):real; {determine unrest in region a}
var rp,e:real;
begin
     with region[a] do begin
        rp:=0;
        e:=int(men/(wandc+1)*100);
        if e<20 then rp:=rp+(20-e);
        with nation[controller] do rp:=rp-int(percapita)+int(tax);
        rp:=rp-int(20*sin(pi*(5/7)*((worth(controller)/(cont(controller)+1))/zap-0.7)));
        if rp>100 then rp:=100;
        if rp<0 then rp:=0;
     end;
     unrest:=rp;
end;

function state(a:integer):bigstring; {convert unrest into a string}
var r:real;
begin
     r:=unrest(a);
     case round(r) of
          0: state:='Happy';
          1..7: state:='Restless';
          8..24: state:='Grumbling';
          25..100: state:='In Revolt';
     end;
end;

overlay procedure papers;
var p,m1,m2,xyzzy:bigstring;
    sel:char;
    r1,r2,r3,m3,f:integer;
begin
     cls;
     print('It''s '+currdate);
     prt('[T]his year''s paper or [L]ast year''s? ');
     onek(sel,'TL');
     if sel='T' then xyzzy:='THISYEAR.GEO' else xyzzy:='LASTYEAR.GEO';
     assign(newspaper,datapath+xyzzy);
     for f:=1 to 12 do prompt(mnames[f]+' ');
     nl;
     r3:=nation[cn].lmnth;
     if r3>world.currmonth then r3:=1;
     prt('Starting month ['+mnames[r3]+'] ');
     checkhangup;
     if hangup then goodbye;
     input(m1,3);
     if hangup then goodbye;
     r1:=mon2int(m1);
     if r1=0 then r1:=r3;
     print(mnames[r1]);
     reset(newspaper);
     repeat read(newspaper,lilmess) until (lilmess=mnames[r1]) or eof(newspaper);
     ab:=false;
     while not eof(newspaper) and not ab do begin
           read(newspaper,lilmess);
           pa(lilmess);
     end;
     if ab then print('Aborted.');
     close(newspaper);
     nation[cn].lmnth:=world.currmonth;
end;

overlay procedure worldstat;
var f,g:integer;
    a,b:real;
    d:char;
begin
     cls;
     ab:=false;
     pa('World status as of '+currdate);
     pa('World population:  '+st(world.pop,0));
     pa('Radiation levels:  '+st(world.radiation,0)+'%');
     pa('Fallout cloud cover:  '+st(world.nukewinter,0)+'%');
     pa('** World Market Report **');
     pa('  Commodity   Volume   Development');
     pa('  =========   ======   ===========');
     for f:=1 to 6 do begin
         a:=0;
         b:=0;
         for g:=1 to 80 do b:=b+region[g].comm[f].devel;
         for g:=1 to 20 do a:=a+nation[g].ncomm[f]+nation[g].tcomm[f];
         pa(pad(commods[f],11)+st(a,9)+st(b,14));
     end;
     ynq('See nation list? ');
     yah:=yn;
     ab:=false;
     if yah then begin
        print('                       Nation   Regions   Economic Worth ($)');
        print('                       ======   =======   ==================');
        for f:=1 to 20 do pa(nname(f)+st(cont(f),10)+st(worth(f),21));
     end;
end;

{$I ROUTINE1.PAS}

{$I ROUTINE2.PAS}

{$I MAINTEN.PAS}


begin
     main;
     maintenance;
     with world do currdate:=convert(currmonth,curryear);
     print(currdate);
     census;
     repeat
         topscr;
         If (Nation[cn].dinero)<-100000000.0 then begin
           with nation[cn] do if cont(cn)=0 then controller:='NOBODY'
             else controller:='&&&';
           reset(trashcan);
           seek(trashcan,filesize(trashcan)+1);
           write(trashcan,handl);
           close(trashcan);
           Cls;
           Checkhangup;
           if hangup then goodbye;
           Printfile(gfilespath+'ASSASS1.GEO');
           Checkhangup;
           if hangup then goodbye;
           Pausescr;
           Cls;
           print('Enter your final words now (75 characters): ');
           checkhangup;
           if hangup then goodbye;
           inputl(lilmess,75);
           if hangup then goodbye;
           {goto ex;}
           addon(' ');
           addon(nation[cn].nombre+' was assassinated!  His final words were:');
           addon('--- '+lilmess);
           addon(' ');
           Cls;
           Printfile(gfilespath+'ASSASS2.GEO');
           Goodbye;
         end;
         prt('Department [A,D,E,H,I,M,N,P,Q,S,W,?] ');
         onek(sel,'ADEHIMNPQSW?');
         case sel of
              'S':domestic;
              'W':worldstat;
              'D':diplomacy;
              'E':economy;
              'M':milit;
              'N':nuclear;
              'P':papers;
              'I':intelligence;
              'H':printfile(gfilespath+'HELPB.GEO');
              'A':printfile(gfilespath+'HISTORY.GEO');
              '?':begin
                       ab:=false;
                       pa('    [A] history lesson');
                       pa('    [D]iplomacy');
                       pa('    [E]conomy');
                       pa('    [H]elp');
                       pa('    [I]ntelligence');
                       pa('    [M]ilitary');
                       pa('    [N]uclear');
                       pa('    news[P]apers');
                       pa('    [Q]uit');
                       pa('    dome[S]tic');
                       pa('    [W]orld status');
                  end;
              'Q':begin
                       ynq('Are you sure? ');
                       yah:=yn;
                       if not yah then sel:='*';
                  end;
         end;
         nl;
     until sel='Q';
     goodbye;
end.