overlay procedure nuclear;
procedure nukereg(a:integer;b,c:real);
var f,g:real;
    h:integer;
begin
     f:=0;
     while f<b do begin
           if random>(nation[region[a].controller].defense/100) then c:=c+1;
           f:=f+1;
     end;
     if c>0 then with region[a] do begin
          ansic(8);
          print('--- Damage report for '+nombre+' ---');
          f:=minn(random*c*2000,wandc);
          g:=minn(random*c*1000,men);
          ansic(8);
          print(st(f+g,0)+' people killed by airbursts in '+nombre+'.');
          wandc:=wandc-f;
          men:=men-g;
          f:=minn(int(random*c/10),nation[controller].nukes[1]);
          g:=minn(int(random*c/20),nation[controller].nukes[2]);
          ansic(8);
          print(st(f,0)+' minuteman and '+st(g,0)+' MX silos destroyed by groundbursts.');
          with nation[controller] do nukes[1]:=nukes[1]-f;
          with nation[controller] do nukes[2]:=nukes[2]-g;
          for h:=1 to 6 do with comm[h] do begin
              f:=minn(int(random*c),devel);
              devel:=devel-f;
              ansic(8);
              print('Development of '+commods[h]+' reduced '+st(f,0)+' points');
          end;
          with world do nukewinter:=minn(nukewinter+round(c*random/10)+random(2),99);
          with world do radiation:=minn(radiation+round(c*random/5)+random(2),99);
          ansic(0);
     end;
end;
procedure nukenat(b,c:real);
var f:integer;
    p:real;
begin
     p:=0;
     while p<b do begin
           if random>(nation[cn].defense/100) then c:=c+1;
           p:=p+1;
     end;
     p:=minn(random*c*1000,nation[cn].military[1]);
     print('Your army loses '+st(p,0)+' troops.');
     with nation[cn] do military[1]:=military[1]-p;
     f:=1;
     if cont(cn)>0 then begin
        p:=int(c/cont(cn));
        if p=0 then p:=1;
        while c>0 do begin
              if region[f].controller=cn then begin
                 nukereg(f,0,minn(c,p));
                 c:=c-p;
              end;
              f:=f+1;
              if f=81 then f:=1;
        end;
     end;
end;
label ex;
var
   f1,f2,f3,f5:integer;
   f4,f6,f7,f8,f9,f10,f11:real;
   sel,sel1:char;
   p:array[1..20] of boolean;
   go:boolean;
   ccomm:array[1..6] of real;
begin
     cls;
     repeat
           nl;
           prt('Nuclear option [A,B,D,H,Q,R,U,V,?] ');
           onek(sel,'ABDHQRUV?');
           case sel of
                'H':printfile(gfilespath+'HELPN.GEO');
                'A':begin
                         print('Select target nations, and hit "Q" after last one.');
                         print('"Q" will NOT abort.');
                         for f1:=1 to 20 do p[f1]:=false;
                         repeat
                               inv:=true;
                               getnat('Toggle ',f1,'H','W');
                               if not qut then begin
                                  p[f1]:=not p[f1];
                                  if p[f1] then print(nation[f1].nombre+' is now a target.')
                                   else print(nation[f1].nombre+' is no longer a target.');
                               end;
                         until qut;
                         go:=false;
                         for f1:=1 to 80 do go:=go or (p[f1] and (cont(f1)>0));
                         if not go then begin
                            print('No regions targeted.');
                            goto ex;
                         end;
                         print('Target nation(s):');
                         for f1:=1 to 20 do if p[f1] then print(nation[f1].nombre);
                         ynq('Do you really wish to launch the attack? ');
                         yah:=yn;
                         qut:=false;
                         if not yah then goto ex;
                         f7:=0;
                         f8:=0;
                         for f1:=1 to 20 do if p[f1] then for f2:=1 to 20 do case nation[f2].rel[f1] of
                               'S':silly(f7,f8,f2,nation[f2].self);
                               'A':if not p[f2] and (cn<>f2) then silly(f7,f8,f2,nation[f2].ally);
                               'F':if not p[f2] and (cn<>f2) then silly(f7,f8,f2,nation[f2].friend);
                         end;
                         prompt(st(f7+f8,0)+' warhead(s) will be launched in retaliation, ');
                         print(st(f8,0)+' of them from submarines.');
                         print('Select forces to use:');
                         f4:=0;
                         go:=false;
                         for f1:=1 to 5 do with nation[cn] do begin
                             ynq(nuke[f1]+' ['+st(nukes[f1],0)+'] :');
                             getreal(f9,0,nukes[f1]);
                             go:=go or (f9>0);
                             nukes[f1]:=nukes[f1]-f9;
                             if f1<>3 then f4:=f4+wh[f1]*f9 else f6:=wh[f1]*f9;
                         end;
                         f1:=1;
                         repeat
                             if p[region[f1].controller] then begin
                                print('Targetting '+region[f1].nombre);
                                print(st(f4,0)+' vulnerable warhead(s) and '+st(f6,0)+' sub warhead(s) left.');
                                ynq('Drop how many normal warheads? ');
                                getreal(f9,0,f4);
                                f4:=f4-f9;
                                ynq('Drop how many submarine warheads? ');
                                getreal(f10,0,f6);
                                f6:=f6-f10;
                                nukereg(f1,f9,f10);
                             end;
                             f1:=f1+1;
                             if f1=81 then f1:=1;
                         until (f4<1) and (f6<1);
                         nl;
                         if (f7>0) or (f8>0) then print('Now tracking incoming enemy missiles. . .');
                         nl;
                         nukenat(f7,f8);
                        if go then begin
                         addon('**** '+nation[cn].nombre+' launched a nuclear attack.');
                         addon('Target nations:');
                         for f1:=1 to 20 do if p[f1] then addon('   '+nation[f1].nombre);
                        end;
                         census;
                         for f1:=1 to 20 do if p[f1] then begin
                             art.por:=f1;
                             art.from:=21;
                             art.mess:=#7+#7+#7+nation[cn].nombre+' nuked you!';
                             sendmess;
                         end;
                    end;
                'B':repeat
                      if nation[cn].dinero<-50000000.0 then begin
                        writeln('The World Bank will not let you purchase Nukes if you are more');
                        writeln('than $50,000,000 in debt');
                        writeln;
                        goto ex;
                        end;
                          pmoney;
                          pstock;
                          repeat
                                prt('Build what [B,M,P,Q,S,X,?] ');
                                onek(sel1,'BMXPQS?');
                                if sel1='?' then begin
                                   print('                     [cost/weapon]');
                                   print('           Weapon   Owned   MET   NON   IND   TEC   Money (millions of $)');
                                   print('           ======   =====   ===   ===   ===   ===   =====');
                                   with nation[cn] do for f5:=1 to 5 do print(pad(pnuke[f5],17)+st(nukes[f5],8)
                    +st(nukecost[f5,3],6)+st(nukecost[f5,4],6)+st(nukecost[f5,5],6)+st(nukecost[f5,6],6)+st(nukemon[f5],8));
                                   print('or [Q]uit');
                                end;
                          until sel1<>'?';
                          case sel1 of
                               'M':f1:=1;
                               'X':f1:=2;
                               'S':f1:=3;
                               'B':f1:=4;
                               'P':f1:=5;
                               'Q':goto ex;
                          end;
                          f4:=nation[cn].ncomm[3]/nukecost[f1,3];
                          with nation[cn] do for f5:=4 to 6 do f4:=minn(f4,ncomm[f5]/nukecost[f1,f5]);
                          if f4>0 then with nation[cn] do begin
                             ynq('How many '+nuke[f1]+' do you wish to build? ');
                             getreal(f6,0,f4);
                             if qut then goto ex;
                             if (nation[cn].dinero-f6*nukemon[f1]*1000000.0)<-50000000.0
                               then begin
                                 writeln('The World Bank will not let you bankrupt your nation');
                                 writeln;
                                 goto ex;
                               end;
                             for f5:=3 to 6 do ncomm[f5]:=ncomm[f5]-f6*nukecost[f1,f5];
                             nukes[f1]:=nukes[f1]+f6;
                             dinero:=dinero-f6*nukemon[f1]*1000000.0;
                          end
                          else print('Not enough commodities and/or money available to build '+nuke[f1]+'.');
                          ynq('Build more nuclear weapons? ');
                          yah:=yn;
                    until not yah;
                'D':with nation[cn] do for f1:=1 to 5 do begin
                        print(nombre+' has '+st(nukes[f1],0)+' '+nuke[f1]);
                        ynq('Destroy how many? ');
                        getreal(f4,0,nukes[f1]);
                        if qut then goto ex;
                        if f4>0 then begin
                         for f2:=3 to 6 do ccomm[f2]:=f4*nukecost[f1,f2]/2;
                         print('Salvage value:');
                         print('MET: '+st(ccomm[3],0)+' NON:'+st(ccomm[4],0)+' IND:'+st(ccomm[5],0)+' TEC:'+st(ccomm[6],0));
                         ynq('Scrap the '+nuke[f1]+'? ');
                         yah:=yn;
                         if yah then begin
                            nukes[f1]:=nukes[f1]-f4;
                            for f2:=3 to 6 do ncomm[f2]:=ncomm[f2]+ccomm[f2];
                         end;
                        end;
                    end;
                'U':with nation[cn] do begin
                         if dinero<-50000000.0 then begin
                           writeln('The World Bank will not loan you the money');
                           writeln;
                           goto ex;
                         end;
                         print('Defense is currently at '+st(defense,0)+'%');
                         print('Each point costs:');
                         print('   $3,000,000');
                         print('   5 units of metals');
                         print('   7 units of nonmetals');
                         print('   10 units of industry');
                         print('   20 units of technology');
                         pmoney;
                         pstock;
                         f4:=minn(minn(minn(ncomm[3]/5,ncomm[4]/7),ncomm[5]/10),ncomm[6]/20);
                         f4:=minn(f4,99-defense);
                         ynq('Increase defense how many points? ');
                         getreal(f6,0,f4);
                         if qut or (f6=0) then goto ex;
                         if (dinero-f6*3000000.0)<-50000000.0 then
                           begin
                             writeln('The World Bank will not let you impoverish your country');
                             writeln;
                             goto ex;
                           end;
                         ncomm[3]:=ncomm[3]-f6*5;
                         ncomm[4]:=ncomm[4]-f6*7;
                         ncomm[5]:=ncomm[5]-f6*10;
                         ncomm[6]:=ncomm[6]-f6*20;
                         defense:=defense+f6;
                         dinero:=dinero-f6*3000000.0;
                         pmoney;
                    end;
                'R':with nation[cn] do begin
                         print('Enter new nuclear retaliation levels for nuclear attacks');
                         ynq('on home country:  ');
                         getreal(self,0,100);
                         if qut then goto ex;
                         ynq('on allies:  ');
                         getreal(ally,0,100);
                         if qut then goto ex;
                         ynq('on friends:  ');
                         getreal(friend,0,100);
                    end;
                'V':with nation[cn] do begin
                         for f1:=1 to 5 do print(nuke[f1]+':  '+st(nukes[f1],0));
                         print('Defense:  '+st(defense,0)+'%');
                         print('Retaliation to attack on '+nombre+':  '+st(self,0)+'%');
                         print('Retaliation to attack on ally:  '+st(ally,0)+'%');
                         print('Retaliation to attack on friend:  '+st(friend,0)+'%');
                    end;
                '?':begin
                         ab:=false;
                         pa('    [A]ttack enemy region');
                         pa('    [B]uild forces');
                         pa('    [D]estroy forces');
                         pa('    [H]elp');
                         pa('    [Q]uit to main menu');
                         pa('    [R]etaliation levels');
                         pa('    [U]pgrade defense');
                         pa('    [V]iew forces');
                    end;
           end;
ex:        qut:=false;
     until sel='Q';
end;

overlay procedure intelligence;
label ex;
var
   sel:char;
   f,g,f1,f2,f3,f7:integer;
   f4,f5,f6:real;
   p:boolean;
begin
     cls;
     repeat
           nl;
           prt('Intelligence ('+st(nation[cn].intel,0)+'%) command [A,C,D,E,H,I,M,N,Q,S,?] ');
           onek(sel,'ACDEHIMNQS?');
           case sel of
                'H':printfile(gfilespath+'HELPI.GEO');
                'A':if nation[cn].dinero>0 then begin
                         pmoney;
                         getnat('Send money to ',f1,'N','I');
                         if qut then goto ex;
                         ynq('Send how much? ');
                         getreal(f4,0,nation[cn].dinero);
                         if qut then goto ex;
                         ynq('Send aid covertly?');
                         yah:=yn;
                         if qut then goto ex;
                         with nation[cn] do dinero:=dinero-f4;
                         with nation[f1] do dinero:=dinero+f4;
                         if not yah or (random(100)<nation[cn].intel) then begin
                            addon('* '+nation[cn].nombre+' sent economic aid to '+nation[f1].nombre+'.');
                            if yah then print('Covert operations uncovered!');
                         end;
                         art.por:=f1;
                         art.from:=21;
                         art.mess:=nation[cn].nombre+' sent you $'+st(f4,0);
                         sendmess;
                    end else print('You are in debt');
                'C':if nation[cn].ispy>0 then begin
                       getnat('Intercept communications of ',f2,'W','I');
                       if qut then goto ex;
                       reset(letters);
                       p:=false;
                       while not eof(letters) do begin
                             read(letters,m);
                             if m.por=f2 then begin
                                if m.from<>21 then print('Message from '+nation[m.from].nombre+':');
                                for f1:=1 to length(m.mess) do if nation[cn].intel>random(110) then prompt(m.mess[f1])
                                    else prompt('_');
                                nl;
                                p:=true;
                             end;
                       end;
                       if not p then print('No messages found.');
                       with nation[cn] do ispy:=ispy-1;
                    end else print('Too risky to spy any more this month.');
                'D':if nation[cn].ispy>0 then begin
                         getnat('Spy on domestic status of ',f2,'W','I');
                         if qut then goto ex;
                         f1:=bestnat;
                         zap:=worth(f1)/(cont(f1)+1);
                         if cont(f2)>0 then begin
                            print(nation[f2].nombre+' controlls the following regions:');
                            print(rheader+'      Men   Women&Kids   Rebel strength     People');
                            print(rqual+'      ===   ==========   ==============     ======');
                            for f1:=1 to 80 do with region[f1] do if controller=f2 then
                                print(rname(f1)+skew(men,9)+skew(wandc,13)+skew(strength(rebels),17)+pad(state(f1),11));
                            nl;
                         end
                         else print(nation[f2].nombre+' controls no regions.');
                         print('Military population:  '+skew(nation[f2].military[1],0));
                         print('Treasury:  $'+skew(nation[f2].dinero,0));
                         with nation[cn] do ispy:=ispy-1;
                    end else print('Too risky to spy any more this month.');
                'E':if nation[cn].ispy>0 then begin
                     getnat('Spy on economics of ',f1,'W','I');
                     if qut then goto ex;
                     with nation[f1] do begin
                         print(nombre+' controls the following regions:');
                         ab:=false;
                         pa('                                         [Development]');
                         pa(rheader+'   AGR   ENE   MET   NON   IND   TEC');
                         pa(rqual+'   ===   ===   ===   ===   ===   ===');
                         for f:=1 to 80 do if region[f].controller=f1 then with region[f] do
                         pa(rname(f)+skew(comm[1].devel,6)+skew(comm[2].devel,6)+skew(comm[3].devel,6)+skew(comm[4].devel,6)
                                        +skew(comm[5].devel,6)+skew(comm[6].devel,6));
                         nl;
                         pa('                [Stockpiles]     [Monthly levels]');
                         pa('  Commodity   Domestic   Trade   Export   Import   ExIm Price');
                         pa('  =========   ========   =====   ======   ======   ==========');
                         for co:=1 to 6 do pa(pad(commods[co],11)+skew(ncomm[co],11)+skew(tcomm[co],8)
                                 +skew((exim[co]+abs(exim[co]))/2,9)+skew((-exim[co]+abs(exim[co]))/2,9)+st(price[co],13));
                     end;
                     with nation[cn] do ispy:=ispy-1;
                    end else print('Too risky to spy any more this month.');
                'I':begin
                         pmoney;
                         print('Intelligence is currently at '+st(nation[cn].intel,0)+'% accuracy.');
                         ynq('Increase how many points? ');
                         getreal(f6,0,99-nation[cn].intel);
                         if qut or (f6=0) then goto ex;
                         f4:=0;
                         f3:=round(nation[cn].intel);
                         for f2:=1 to round(f6) do begin
                             f4:=f4+f3*1000.0;
                             f3:=f3+1;
                         end;
                         print('Increase would cost $'+st(f4,0)+'.');
                         ynq('Do it? ');
                         yah:=yn;
                         if yah then begin
                            with nation[cn] do dinero:=dinero-f4;
                            with nation[cn] do intel:=intel+f6;
                            print('Intelligence now at '+st(nation[cn].intel,0)+'%');
                            pmoney;
                         end;
                    end;
                'M':if nation[cn].ispy>0 then begin
                         getnat('Spy on military of ',f1,'W','I');
                         if qut then goto ex;
                         with nation[f1] do begin
                              for f2:=1 to 4 do print(weaps[f2]+':  '+skew(military[f2],0));
                              print('Total strength:  '+skew(strength(military),0));
                         end;
                         with nation[cn] do ispy:=ispy-1;
                    end else print('Too risky to spy any more this month.');
                'N':if nation[cn].ispy>0 then begin
                         getnat('Spy on nuclear forces of ',f1,'W','I');
                         if qut then goto ex;
                         with nation[f1] do begin
                              for f7:=1 to 5 do print(nuke[f7]+':  '+skew(nukes[f7],0));
                              print('Defense:  '+skew(defense,0)+'%');
                         end;
                         with nation[cn] do ispy:=ispy-1;
                    end else print('Too risky to spy any more this month.');
                'S':begin
                         inv:=true;
                         getreg('Send arms to rebels in ',f1,'N','R');
                         if qut then goto ex;
                         for f2:=1 to 4 do begin
                             print('Rebels currently have '+st(region[f1].rebels[f2],0)+' '+weaps[f2]);
                             print('You currently have '+st(nation[cn].military[f2],0)+' '+weaps[f2]);
                             ynq('Send how many '+weaps[f2]+'? ');
                             getreal(f4,0,nation[cn].military[f2]);
                             if qut or (f4=0) then goto ex;
                             with region[f1] do rebels[f2]:=rebels[f2]+f4;
                             with nation[cn] do military[f2]:=military[f2]-f4;
                         end;
                         ynq('Send aid covertly?');
                         yah:=yn;
                         if qut then goto ex;
                         if not yah or (random(100)<nation[cn].intel) then begin
                            addon('* '+nation[cn].nombre+' sent military aid to rebels in '+nation[f1].nombre+'.');
                            print('Covert operations uncovered!');
                         end;
                    end;
                '?':begin
                         ab:=false;
                         pa('    monetary [A]id');
                         pa('    [C]ommunications');
                         pa('    [D]omestic intelligence');
                         pa('    [E]conomic intelligence');
                         pa('    [H]elp');
                         pa('    [I]ncrease accuracy');
                         pa('    [M]ilitary intelligence');
                         pa('    [N]uclear intelligence');
                         pa('    [Q]uit');
                         pa('    [S]end arms to rebels in hostile region');
                    end;
           end;
ex:        qut:=false;
     until sel='Q';
end;

overlay procedure domestic;
label ex;
var f,g,f1,f2,f3:integer;
    f4,f5:real;
    sel:char;
begin
     cls;
     repeat
           nl;
           prt('Domestic command [A,C,H,M,Q,R,T,V,?] ');
           onek(sel,'ACHMQRTV?');
           case sel of
                'H':printfile(gfilespath+'HELPS.GEO');
                'A':begin
                         pmoney;
                         ppop;
                         print('Current social expenditure is $'+st(nation[cn].percapita,0)+' per person per month.');
                         ynq('Enter new rate:  ');
                         getreal(nation[cn].percapita,0,20);
                    end;
                'C':begin
                         getreg('Cede ',f1,'S','W');
                         if qut then goto ex;
                         getnat('Release '+region[f1].nombre+' to ',f2,'W','R');
                         if qut then goto ex;
                         region[f1].controller:=f2;
                         art.from:=21;
                         art.por:=f2;
                         art.mess:=nation[cn].nombre+' signed '+region[f1].nombre+' over to you.';
                         sendmess;
                         addon(nation[cn].nombre+' ceded '+region[f1].nombre+' to '+nation[f2].nombre);
                    end;
                'M':begin
                         getreg('Move people from ',f1,'S','P');
                         if qut then goto ex;
                         with region[f1] do begin
                              ynq('Migrate how many men ['+st(men,0)+']: ');
                              getreal(f4,0,men);
                              ynq('Migrate how many women and children ['+st(wandc,0)+']: ');
                              getreal(f5,0,wandc);
                         end;
                         getreg('Move people to ',f2,'S','P');
                         if qut then f2:=f1;
                         with region[f1] do men:=men-f4;
                         with region[f2] do men:=men+f4;
                         with region[f1] do wandc:=wandc-f5;
                         with region[f2] do wandc:=wandc+f5;
                         print('The long march begins. . .');
                    end;
                'R':begin
                         print('Insurgencies in '+nation[cn].nombre+':');
                         print(rheader+'   Troops   Tanks   Planes   Ships');
                         print(rqual+'   ======   =====   ======   =====');
                         for f1:=1 to 80 do if region[f1].controller=cn then with region[f1] do
                             print(rname(f1)+st(rebels[1],9)+st(rebels[2],8)+st(rebels[3],9)+st(rebels[4],8));
                         repeat
                               getreg('Attack rebels in ',f1,'S','R');
                               if qut then goto ex;
                         until strength(region[f1].rebels)>0;
                         fight(nation[cn].military,region[f1].rebels,2);
                         case victor of
                              0:print('The rebels sign a temporary truce.');
                              1:begin
                                     print('The rebel forces are routed into chaos and disband!');
                                     with region[f1] do for f2:=1 to 4 do rebels[f2]:=0;
                                end;
                              2:begin
                                     print('The rebel forces crush the national army and win freedom for their region.');
                                     newnat(f1);
                                     with region[f1] do print(nombre+' allies itself with '+nation[controller].nombre+'.');
                                end;
                         end;
                         census;
                    end;
                'V':begin
                         f1:=bestnat;
                         zap:=worth(f1)/(cont(f1)+1);
                         if cont(cn)>0 then begin
                            ab:=false;
                            print(nation[cn].nombre+' controls the following regions:');
                            pa(rheader+'      Men   Women&Kids   Rebels      People');
                            pa(rqual+'      ===   ==========   ========    ======');
                            for f1:=1 to 80 do with region[f1] do if controller=cn then
                             pa(rname(f1)+st(men,9)+st(wandc,13)+st(strength(rebels),9)+pad(state(f1),12));
                            nl;
                         end
                         else print(nation[cn].nombre+' controls no regions.');
                         print('Military population:  '+st(nation[cn].military[1],0));
                         ppop;
                         pmoney;
                         print('Social expenditures per capita:  $'+st(nation[cn].percapita,0));
                         print('Tax rate:  '+st(nation[cn].tax,0)+'%');
                         if embargo then cn:=cn;
                    end;
                'T':with nation[cn] do begin
                         print('Current tax rate is '+st(tax,0)+'%');
                         ynq('Enter new rate:  ');
                         getreal(tax,0,100);
                    end;
                '?':begin
                         ab:=false;
                         pa('    [A]djust per capita expenditures');
                         pa('    [C]ede region');
                         pa('    [H]elp');
                         pa('    [M]ove people');
                         pa('    [Q]uit');
                         pa('    attack [R]ebels');
                         pa('    [T]ax rate');
                         pa('    [V]iew domestic status');
                    end;
           end;
ex:        qut:=false;
     until sel='Q';
end;

overlay procedure main;
begin
     iport;
     randomize;
     cls;
     ansic(8);
     print('Programmer..............Screaming Sushi');
     print('Esthetics...............John Keats (not the poet)');
     print('Design Help.............Alex Tobias & All The Wonderland Playtesters');
     ansic(0);
     pausescr;
     cls;
     printfile(gfilespath+'PIC.GEO');
     print('* * * Loading * * *');
     assign(nations,datapath+'NATIONS.GEO');
     reset(nations);
     for c1:=1 to 20 do read(nations,nation[c1]);
     close(nations);
     assign(regions,datapath+'REGIONS.GEO');
     reset(regions);
     for c1:=1 to 80 do read(regions,region[c1]);
     close(regions);
     assign(worldfile,datapath+'WORLD.GEO');
     reset(worldfile);
     read(worldfile,world);
     close(worldfile);
     qut:=false;
     inv:=false;
     cn:=0;
     handl:=nam;
     ok2play:=true;
     assign(trashcan,datapath+'TRASHCAN.GEO');
     reset(trashcan);
     while not eof(trashcan) do begin
           read(trashcan,baduser);
           if baduser=handl then ok2play:=false;
     end;
     close(trashcan);
     if not ok2play then begin
        print('You''ll have to wait until the next game starts, sorry.');
        goodbye;
     end;
     for c1:=1 to 20 do if nation[c1].controller=handl then cn:=c1;
     if cn=0 then begin
        c1:=0;
        repeat c1:=c1+1 until (c1=21) or (nation[c1].controller='&&&');
        if c1<>21 then begin
           print(nation[c1].nombre+' is leaderless, and controls the following regions:');
           for c2:=1 to 80 do with region[c2] do if controller=c1 then print(nombre);
           ynq('Do you wish to take control of it? ');
           yah:=yn;
           if not yah then begin
              print('Beggars can''t be choosers. . . ');
              goodbye;
           end;
           nation[c1].controller:=handl;
           cn:=c1;
        end
        else begin
             print('Sorry, all twenty nations are taken.  Try again some other time.');
             goodbye;
        end;
     end;
     sysoplog('/\/\/'+handl+' played Geopolitik as '+nation[cn].nombre);
     assign(letters,datapath+'MESSAGES.GEO');
     reset(letters);
     while not eof(letters) do begin
           read(letters,m);
           if m.por=cn then begin
              if m.from<>21 then print('Message from '+nation[m.from].nombre+':');
              print(m.mess);
              print('-----');
              dummy.por:=0;
              seek(letters,filepos(letters)-1);
              write(letters,dummy);
           end;
     end;
     close(letters);
end;