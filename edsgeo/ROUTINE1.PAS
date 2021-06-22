overlay procedure diplomacy; {Overlay source for Geopolitik v 1.0}
label ex;
var
   sel,p1:char;
   f1,f2:integer;
   p,sak:bigstring;
   lm1,lm2:bigstring;
   newname:namstring;
begin
   cls;
   repeat
     nl;
     prt('Diplomacy command [A,C,D,H,L,M,Q,S,V,?] ');
     onek(sel,'ACDHLMQSV?');
     case sel of
          'H':printfile(gfilespath+'HELPD.GEO');
          'L':begin
                 ab:=false;
                 for f1:=1 to 20 do begin
                  ansic(2);
                  pa(nation[f1].nombre+' controls:');
                  ansic(0);
                  for f2:=1 to 80 do with region[f2] do if (controller=f1) then pa('   '+nombre);
                 end;
              end;
          'A':begin
                   print('If you really wish to abdicate, type "I''M A QUITTER"');
                   checkhangup;
                   if hangup then goodbye;
                   input(p,13);
                   if hangup then goodbye;
                   if p='I''M A QUITTER' then begin
                      with nation[cn] do if cont(cn)=0 then controller:='NOBODY' else controller:='&&&';
                      reset(trashcan);
                      seek(trashcan,filesize(trashcan)+1);
                      write(trashcan,handl);
                      close(trashcan);
                      print('Now slink off to the main menu and hit "Q"');
                   end
              end;
          'M':begin
                   print('Announcement (75 characters, RETURN aborts): ');
                   checkhangup;
                   if hangup then goodbye;
                   inputl(lilmess,75);
                   if hangup then goodbye;
                   if lilmess='' then begin
                      print('Aborted.');
                      goto ex;
                   end;
                   addon(nation[cn].nombre+' made an announcement:');
                   addon('--- '+lilmess);
              end;
          'D':begin
                   getnat('Change diplomatic relations with ',f1,'W','D');
                   if qut then goto ex;
                   repeat
                         prt('New diplomatic posture toward '+nation[f1].nombre+' [A,F,H,N,Q,W,?] ');
                         onek(p1,'AFHNWQ?');
                         if p1='?' then begin
                            ab:=false;
                            pa('[A]llied');
                            pa('[F]riendly');
                            pa('[H]ostile');
                            pa('[N]eutral');
                            pa('[Q]uit');
                            pa('at [W]ar');
                         end;
                   until p1<>'?';
                   case p1 of
                        'H':begin
                                 nation[cn].rel[f1]:='H';
                                 if nation[f1].rel[cn] in ['A','F'] then nation[f1].rel[cn]:='N';
                            end;
                        'N':nation[cn].rel[f1]:='N';
                        'F':nation[cn].rel[f1]:='F';
                        'A':if nation[f1].rel[cn] in ['A','F'] then nation[cn].rel[f1]:='A'
                               else print(nation[f1].nombre+' is not friendly towards you.');
                        'W':if nation[cn].rel[f1]='W' then print('Already at war.') else begin
                               nation[cn].rel[f1]:='W';
                               if nation[f1].rel[cn] in ['A','F'] then nation[f1].rel[cn]:='N';
                               addon('* '+nation[cn].nombre+' declared war on '+nation[f1].nombre);
                               nation[cn].attacks:=1;
                            end;
                   end;
              end;
          'S':begin
                   getnat('Send message to ',art.por,'W','D');
                   if qut then goto ex;
                   art.from:=cn;
                   print('Type in message now (75 characters, RETURN to abort):');
                   checkhangup;
                   if hangup then goodbye;
                   inputl(lm1,75);
                   if hangup then goodbye;
                   art.mess:=lm1;
                   if art.mess='' then print('Aborted.') else sendmess;
              end;
          'C':begin
                   prt('Enter new name for '+nation[cn].nombre+':  ');
                   checkhangup;
                   if hangup then goodbye;
                   inputn(newname);
                   if hangup then goodbye;
                   if length(newname)<3 then begin
                      print('Aborted.  Name must be at least 3 characters.');
                      goto ex;
                   end;
                   print('New name will be '+newname);
                   ynq('Is this what you want? ');
                   yah:=yn;
                   if yah then begin
                      addon(nation[cn].nombre+' changed its name to '+newname+'.');
                      nation[cn].nombre:=newname;
                   end;
              end;
          'V':begin
                   print('                       Nation   1 2 3 4 5 6 7 8 9 1 1 1 1 1 1 1 1 1 1 2');
                   print('                       ======                     0 1 2 3 4 5 6 7 8 9 0');
                   ab:=false;
                   for f1:=1 to 20 do if not ab then begin
                       if f1=cn then ansic(4);
                       pra(nname(f1)+'   ');
                       for f2:=1 to 20 do begin
                           case nation[f1].rel[f2] of
                                'W': p1:='W';
                                'H': p1:='H';
                                'N': p1:='.';
                                'F': p1:='F';
                                'A': p1:='A';
                                'S': p1:=' ';
                           end;
                           if f2=cn then ansic(4);
                           pra(p1+' ');
                           if (f2=cn) and (f1<>cn) then ansic(0);
                       end;
                       if f1=cn then ansic(0);
                       nl;
                   end;
                   pa('A=Allied F=Friendly .=Neutral H=Hostile W=Warring');
              end;
          '?':begin
                   ab:=false;
                   pa('    [A]bdicate');
                   pa('    [C]hange country''s name');
                   pa('    [D]iplomatic relations');
                   pa('    [H]elp');
                   pa('    [L]ist nations');
                   pa('    [M]ake announcement');
                   pa('    [Q]uit to main menu');
                   pa('    [S]end message');
                   pa('    [V]iew global relationships');
              end;
     end;
ex:  qut:=false;
   until sel='Q';
end;

overlay procedure economy;
label ex;
var
   f,g,f2,f4:integer;
   f1,f3:real;
   sel,sel1,p:char;
   regs:string[20];
   hell,ski_resort,auntiem:boolean;
   hd,hd1:bigstring;
   tots:array[1..6] of index;
procedure getcom(b:boolean);
var p:char;
begin
     repeat
           prt('which commodity [A,E,M,N,I,T,Q,?] ');
           onek(p,'AEMNIT?Q');
           if p='?' then if not b then begin
              ab:=false;
              pa('[A]griculture');
              pa('[E]nergy');
              pa('[M]etals');
              pa('[N]onmetals');
              pa('[I]ndustry');
              pa('[T]echnology');
              pa('[Q]uit');
           end
           else with region[f2] do begin
                print('            Commodity   Current Level   Price/Point   Credits');
                print('            =========   =============   ===========   =======');
                for co:=1 to 6 do print(pad(commods[co],21)+st(comm[co].devel,16)
                                        +st(commworth[co]*10,14)+st(comm[co].credit,10));
           end;
     until p<>'?';
     case p of
          'A':co:=1;
          'E':co:=2;
          'M':co:=3;
          'N':co:=4;
          'I':co:=5;
          'T':co:=6;
          'Q':qut:=true;
     end;
end;
begin
     cls;
     hell:=true;
     ski_resort:=false;
     repeat
           nl;
           prt('Economic option [B,E,G,H,I,O,P,Q,V,?] ');
           onek(sel,'BDEGHIOPQV?');
           case sel of
                'H':printfile(gfilespath+'HELPE.GEO');
                'O':with nation[cn] do repeat
                          prt('Organize ');
                          getcom(false);
                          if qut then goto ex;
                          f1:=ncomm[co]+tcomm[co];
                          print('You have '+st(f1,0)+' units of '+commods[co]+' total.');
                          ynq('Place how many in domestic stockpile? ');
                          getreal(f3,0,f1);
                          ncomm[co]:=f3;
                          tcomm[co]:=f1-f3;
                          print('You have '+st(tcomm[co],0)+' units left in your trade stockpile.');
                    until hell=ski_resort;
                'E':with nation[cn] do repeat
                         prt('Set export-import levels for ');
                         getcom(false);
                         if qut then goto ex;
                         print('Negative numbers represent import quotas; positive numbers indicate export.');
                         ynq('Import-export level for '+commods[co]+':  ');
                         getreal(exim[co],-100000.0,100000.0);
                    until hell=ski_resort;
                'V':begin
                         for f4:=1 to 6 do begin
                             tots[f4].devel:=0;
                             tots[f4].credit:=0;
                         end;
                         ab:=false;
                         pa('                                   Development/Credits');
                         pa(rheader+'     AGR     ENE     MET     NON     IND     TEC');
                         pa(rqual+'     ===     ===     ===     ===     ===     ===');
                         for f2:=1 to 80 do with region[f2] do if controller=cn then begin
                             hd:=rname(f2);
                             hd1:=hd;
                             for f4:=1 to 6 do hd1:=hd1+pad(st(comm[f4].devel,0)+'/'+st(comm[f4].credit,0),8);
                             for f4:=1 to 6 do begin
                                 tots[f4].devel:=tots[f4].devel+comm[f4].devel;
                                 tots[f4].credit:=tots[f4].credit+comm[f4].credit;
                             end;
                             pa(hd1);
                         end;
                         hd:=pad('Total:',length(rname(1)));
                         for f4:=1 to 6 do hd:=hd+pad(st(tots[f4].devel,0)+'/'+st(tots[f4].credit,0),8);
                         pa(hd);
                         nl;
                         pa('                [Stockpiles]     [Monthly levels]');
                         pa('  Commodity   Domestic   Trade   Export   Import   ExIm Price');
                         pa('  =========   ========   =====   ======   ======   ==========');
                         with nation[cn] do for co:=1 to 6 do pa(pad(commods[co],11)+st(ncomm[co],11)+st(tcomm[co],8)
                                       +st((exim[co]+abs(exim[co]))/2,9)+st((-exim[co]+abs(exim[co]))/2,9)+st(price[co],13));
                    end;
                'B':repeat
                        if embargo then goto ex;
(* MOD BEGIN *)         if (nation[cn].Dinero<-50000000.0) then begin
                          Pa('You are too deeply in debt to purchase anything.');
                          pa('You are '+st(abs(nation[cn].dinero),0)+' in debt');
                          pa('The world bank will only lend you money if you are less than');
                          pa('50 million dollars in debt');
                          Goto ex;
(* MOD END *)           end;
                        pmoney;
                        prt('Buy ');
                        getcom(false);
                        if qut then goto ex;
                        print('(? for sellers list)');
                        getnat('Buy from ',f2,'N','P');
                        if qut then goto ex;
                        auntiem:=false;
                        for f4:=1 to 20 do with nation[f4] do auntiem:=auntiem or (embarg[f2]>0);
                        if not auntiem then begin
                           ynq('How many units? ');
                           getreal(f3,0,nation[f2].tcomm[co]);
                           if qut then goto ex;
                           f1:=adprice(f2,cn,co)*f3;
                           print('Cost would be $'+st(f1,0));
                           ynq('Deal? ');
                           yah:=yn;
                           if (nation[cn].dinero-f1)<-50000000.0 then
                             begin
                               pa('The world bank will not lend to heavy debtors');
                               pa('The world bank will not let you go higher than 50 million in debt');
                               goto ex;
                             end;
                           if yah then begin
                              with nation[cn] do dinero:=dinero-f1;
                              with nation[cn] do ncomm[co]:=ncomm[co]+f3;
                              with nation[f2] do dinero:=dinero+f1;
                              with nation[f2] do tcomm[co]:=tcomm[co]-f3;
                              print('Done.');
                           end else print('No transaction, then.');
                        end
                        else print('Sorry, '+nation[f2].nombre+' is currently being embargoed.');
                    until hell=ski_resort;
                'I':begin
(* BEGIN MOD *)      if (nation[cn].dinero<-75000000.0) then begin
                       pa('The World Bank doesn''t credit heavy debtors.');
                       pa('The World Bank will not lend you money to go higher than 75 million');
                       pa('dollars in debt when increasing Development');
                       goto ex;
(* END MOD *)        end;
                     getreg('Increase development in ',f2,'S','D');
                     if qut then goto ex;
                     with region[f2] do repeat
                         prt('Develop ');
                         getcom(true);
                         if qut then goto ex;
                         pmoney;
                         ynq('Buy how many credits? ');
                         getreal(f1,0,100);
                         f3:=commworth[co]*f1*10;
                         yah:=true;
                         if f1>0 then ynq('Credits will cost $'+st(f3,0)+'.  Do it? ') else yah:=false;;
                         if yah then yah:=yn;
                         if not yah then qut:=true;
                         if not qut then begin
                            if (nation[cn].dinero-f3)<-75000000.0
                              then begin
                                pa('The World Bank will not let you go higher than 75 million dollars');
                                pa('in debt when increasing Development');
                                goto ex;
                              end;
                            nation[cn].dinero:=nation[cn].dinero-f3;
                            comm[co].credit:=comm[co].credit+f1;
                         end;
                     until hell=ski_resort;
                    end;
                'G':begin
                      if embargo then goto ex;
                      getnat('Send commodities to ',f2,'F','C');
                      if qut then goto ex;
                      art.mess:=nation[cn].nombre+' sent you ';
                      for co:=1 to 6 do begin
                         print('You have '+st(nation[cn].ncomm[co],0)+' units of '+commods[co]+'.');
                         ynq('Send how many units? ');
                         getreal(f3,0,nation[cn].ncomm[co]);
                         if qut then goto ex;
                         with nation[f2] do ncomm[co]:=ncomm[co]+f3;
                         with nation[cn] do ncomm[co]:=ncomm[co]-f3;
                         art.mess:=art.mess+st(f3,0)+copy(commods[co],1,3)+': '+st(f3,0);
                         if co<>6 then art.mess:=art.mess+'/';
                      end;
                      art.from:=21;
                      art.por:=f2;
                      sendmess;
                    end;
                'P':repeat
                          with nation[cn] do print('Your asking price ($) AGR:'+st(price[1],0)+'   ENE:'+st(price[2],0)+
                    '   MET:'+st(price[3],0)+'   NON:'+st(price[4],0));
                          print('IND:'+st(nation[cn].price[5],0)+'   TEC:'+st(nation[cn].price[6],0));
                          prt('Change price for ');
                          getcom(false);
                          if not qut then begin
                             ab:=false;
                             pa('Sellers list for '+commods[co]);
                             pa('                       Nation     Volume     Price/unit');
                             pa('                       ======     ======     ==========');
                             for f2:=1 to 20 do if f2<>cn then with nation[f2] do
                                 pa(nname(f2)+st(tcomm[co],11)+st(price[co],15));
                             ynq('New price? ');
                             getreal(f1,0,10000000000.0);
                             if qut then goto ex;
                             if f1>0 then nation[cn].price[co]:=f1;
                          end;
                    until qut;
                '?':begin
                         ab:=false;
                         pa('    [B]uy commodities');
                         pa('    [E]xport-Import control');
                         pa('    send [G]oods to friendly nation');
                         pa('    [H]elp');
                         pa('    [I]ncrease development levels');
                         pa('    [O]rganize domestic and trade stockpiles');
                         pa('    [P]rices');
                         pa('    [Q]uit to main menu');
                         pa('    [V]iew national economic status');
                    end;
           end;
ex:        qut:=false;
     until sel='Q';
end;

overlay procedure milit;
label ex;
var
   f1,f2,f3,f5:integer;
   f4,f6,f7:real;
   sel,sel1:char;
   reserve,reserve2:force;
   ccomm:array[1..6] of real;
   q:boolean;
begin
     cls;
     repeat
           nl;
           prt('Military command [A,B,D,E,H,N,Q,S,T,V,?] ');
           onek(sel,'ABDHENQSTV?');
           case sel of
                'H':printfile(gfilespath+'HELPM.GEO');
                'A':if nation[cn].attacks>0 then begin
                        if embargo then goto ex;
                        inv:=true;
                        getreg('Attack ',f1,'H','W');
                        if qut then goto ex;
                        f2:=region[f1].controller;
                        for f3:=1 to 4 do begin
                            ynq('Use how many '+weaps[f3]+' [0..'+st(nation[cn].military[f3],0)+']? ');
                            getreal(reserve[f3],0,nation[cn].military[f3]);
                            if qut then goto ex;
                            reserve[f3]:=nation[cn].military[f3]-reserve[f3];
                        end;
                        for f3:=1 to 4 do with nation[cn] do military[f3]:=military[f3]-reserve[f3];
                        for f3:=1 to 4 do with nation[f2] do begin
                            f7:=int(military[f3]/4);
                            military[f3]:=military[f3]-f7;
                            reserve2[f3]:=f7;
                        end;
                        with nation[cn] do begin
                             ccomm[1]:=int(2*military[1]/500);
                             ccomm[2]:=int(military[1]/500)+military[2]+2*military[3]+3*military[4];
                             ccomm[3]:=military[2]+military[3]+2*military[4];
                             ccomm[4]:=int(military[1]/500)+2*military[2]+3*military[3]+5*military[4];
                             ccomm[5]:=3*military[2]+3*military[3]+4*military[4];
                             ccomm[6]:=military[2]+military[3]+military[4];
                             for f3:=1 to 6 do ccomm[f3]:=int(ccomm[f3]/5);
                        end;
                        q:=false;
                        with nation[cn] do for f3:=1 to 3 do q:=q or (ccomm[f3]>ncomm[f3]);
                        print('The attack will consume:');
                        for f3:=1 to 6 do print('   '+st(ccomm[f3],0)+' units of '+commods[f3]);
                        pstock;
                        ynq('Go through with the attack? ');
                        yah:=false;
                        if q then print('No (not enough commodities in national stockpile)') else yah:=yn;
                        if not yah then for f3:=1 to 4 do begin
                           with nation[cn] do military[f3]:=military[f3]+reserve[f3];
                           with nation[f2] do military[f3]:=military[f3]+reserve2[f3];
                        end;
                        if yah then begin
                         for f3:=1 to 3 do with nation[cn] do ncomm[f3]:=ncomm[f3]-ccomm[f3];
                         fight(nation[cn].military,nation[f2].military,10/(cont(f2)+5));
                         addon('*** Conflict in '+region[f1].nombre);
                         case victor of
                              0:begin
                                     print('Stalemate.');
                                     addon('   '+nation[f2].nombre+' and '+nation[cn].nombre+' fought to a standstill.');
                                end;
                              1:begin
                                     print('Victory!  '+nation[cn].nombre+' now controls '+region[f1].nombre+'.');
                                     addon('   '+nation[cn].nombre+' defeated '+nation[f2].nombre+' and took the region.');
                                     region[f1].controller:=cn;
                                     with region[f1] do begin
                                          f7:=men/10;
                                          men:=men-f7;
                                          rebels[1]:=rebels[1]+f7;
                                     end;
                                end;
                              2:begin
                                     print('Miserable defeat.');
                                   addon('   '+nation[f2].nombre+' decisively defeated the invader, '+nation[cn].nombre+'.');
                                end;
                         end;
                         census;
                         for f3:=1 to 4 do begin
                             with nation[f2] do military[f3]:=military[f3]+reserve2[f3];
                             with nation[cn] do military[f3]:=military[f3]+reserve[f3];
                         end;
                         nation[cn].attacks:=0;
                        end;
                    end
                    else print('Your army may not attack again this month.');
                'B':repeat
                      if (nation[cn].dinero<-50000000.0) then
                        begin
                          writeln;
                          print('You are too heavily in debt');
                          writeln;
                          goto ex;
                        end;
                          pmoney;
                          pstock;
                          repeat
                                prt('Build what [T,P,Q,S,?] ');
                                onek(sel1,'TPQS?');
                                if sel1='?' then begin
                                   print('                     [cost/weapon]');
                                   print('  Weapon   Owned   MET   NON   IND   TEC   Money (millions of $)');
                                   print('  ======   =====   ===   ===   ===   ===   =====');
                                   with nation[cn] do for f5:=2 to 4 do print(pad(pweaps[f5],8)+st(military[f5],8)
                     +st(weapcost[f5,3],6)+st(weapcost[f5,4],6)+st(weapcost[f5,5],6)+st(weapcost[f5,6],6)+st(weapmon[f5],8));
                                   print('or [Q]uit');
                                end;
                          until sel1<>'?';
                          case sel1 of
                               'T':f1:=2;
                               'P':f1:=3;
                               'S':f1:=4;
                               'Q':goto ex;
                          end;
                          f4:=nation[cn].ncomm[3]/weapcost[f1,3];
                          with nation[cn] do for f5:=4 to 6 do f4:=minn(f4,ncomm[f5]/weapcost[f1,f5]);
                          if f4>0 then with nation[cn] do begin
                             ynq('How many '+weaps[f1]+' do you wish to build? ');
                             getreal(f6,0,f4);
                             if qut then goto ex;
                             if (nation[cn].dinero-f6*weapmon[f1]*1000000.0)<-50000000.0
                               then begin
                                 writeln('You will be too heavily in debt to buy that much');
                                 writeln;
                                 goto ex;
                               end;
                             for f5:=3 to 6 do ncomm[f5]:=ncomm[f5]-f6*weapcost[f1,f5];
                             military[f1]:=military[f1]+f6;
                             dinero:=dinero-f6*weapmon[f1]*1000000.0;
                          end
                          else print('Not enough commodities available to build '+weaps[f1]+'.');
                          ynq('Build more weapons? ');
                          yah:=yn;
                    until not yah;
                'D':with nation[cn] do for f1:=2 to 4 do begin
                        print(nombre+' has '+st(military[f1],0)+' '+weaps[f1]);
                        ynq('Destroy how many? ');
                        getreal(f4,0,military[f1]);
                        if qut then goto ex;
                        if f4>0 then begin
                         for f2:=3 to 6 do ccomm[f2]:=f4*weapcost[f1,f2]/2;
                         print('Salvage value:');
                         print('MET: '+st(ccomm[3],0)+' NON:'+st(ccomm[4],0)+' IND:'+st(ccomm[5],0)+' TEC:'+st(ccomm[6],0));
                         ynq('Destroy the '+weaps[f1]+'?');
                         yah:=yn;
                         if yah then begin
                            military[f1]:=military[f1]-f4;
                            for f2:=3 to 6 do ncomm[f2]:=ncomm[f2]+ccomm[f2];
                         end;
                        end;
                    end;
                'E':with nation[cn] do begin
                         f6:=military[4];
                         getnat('Change embargo on ',f1,'W','E');
                         if qut then goto ex;
                         f7:=embarg[f1];
                         print('You have '+st(f6,0)+' ships available in your navy.');
                         print('You have '+st(f7,0)+' ships embargoing '+nation[f1].nombre);
                         ynq('How many ships do you want to embargo '+nation[f1].nombre+' with? ');
                         getreal(f4,0,f6+f7);
                         if qut then goto ex;
                         embarg[f1]:=f4;
                         military[4]:=f6+f7-f4;
                         if (f7=0) and (f4>0) then addon(nation[cn].nombre+' embargoed '+nation[f1].nombre);
                         if (f7>0) and (f4=0) then addon(nation[cn].nombre+' lifted its embargo on '+nation[f1].nombre);
                    end;
                'N':begin
                         if embargo then cn:=cn else begin
                            print('No embargoes against you.');
                            goto ex;
                         end;
                         getnat('Break embargo of ',f1,'W','E');
                         if qut then goto ex;
                         with nation[f1] do if embarg[cn]=0 then begin
                              print(nombre+' has no ships embargoing you.');
                              goto ex;
                         end;
                         f4:=nation[cn].military[3]/(nation[f1].military[3]+1);
                         repeat
                               fleetbattle(nation[cn].military[4],nation[f1].embarg[cn],f4);
                         until not yah or (nation[cn].military[4]=0) or (nation[f1].embarg[cn]=0);
                         if yah and (nation[cn].military[4]>0) then begin
                            print('Embargo broken!');
                            art.mess:=nation[cn].nombre+' broke your embargo.';
                            art.from:=21;
                            art.por:=f1;
                            sendmess;
                         end;
                         addon(nation[cn].nombre+' attacked the embargo of '+nation[f1].nombre);
                    end;
                'T':begin
                         getreg('Transfer soldiers to/from ',f1,'S','T');
                         if qut then goto ex;
                         print('Army has '+st(nation[cn].military[1],0)+' men in it.');
                         with region[f1] do print(nombre+' has '+st(men,0)+' eligible men.');
                         print('(Positive for draft, negative for discharge)');
                         ynq('How many soldiers do you wish to transfer? ');
                         getreal(f4,-nation[cn].military[1],region[f1].men);
                         if qut then goto ex;
                         with nation[cn] do military[1]:=military[1]+f4;
                         with region[f1] do men:=men-f4;
                         print('Army now has '+st(nation[cn].military[1],0)+' men in it.');
                         with region[f1] do print(nombre+' now has '+st(men,0)+' eligible men left in it.');
                    end;
                'V':begin
                         with nation[cn] do for f1:=1 to 4 do print(weaps[f1]+':  '+st(military[f1],0));
                         print('Total strength:  '+st(strength(nation[cn].military),0));
                         with nation[cn] do for f1:=1 to 20 do if embarg[f1]>0 then
                          print('You have '+st(embarg[f1],0)+' ships embargoing '+nation[f1].nombre);
                    end;
                'S':begin
                         inv:=true;
                         getreg('Bomb ',f1,'H','W');
                         if qut then goto ex;
                         f2:=region[f1].controller;
                         ynq('Use how many planes, up to '+st(nation[cn].military[3],0)+'? ');
                         getreal(f4,0,nation[cn].military[3]);
                         if qut or (f4=0) then goto ex;
                         prt('[P]opulation centers or [F]actories? ');
                         onek(sel1,'PFQ');
                         if sel1='Q' then goto ex;
                         print('Encountering enemy air defenses...');
                         f6:=int(random*f4);
                         if nation[f2].military[3]<nation[cn].military[3] then f6:=f6/2;
                         if nation[f2].military[3]<3 then f6:=f6/2;
                         f6:=minn(f6,f4)+1;
                         prompt('You lost '+st(f6,0)+' plane(s) in the raid...');
                         with nation[cn] do military[3]:=military[3]-f6;
                         f4:=f4-f6;
                         if f4=0 then begin
                            print('No planes left to bomb with.');
                            goto ex;
                         end;
                         case sel1 of
                              'P':begin
                                       f7:=int(random(round(region[f1].wandc+region[f1].men))*minn(100,f4)/100);
                                       print('but killed '+st(f7,0)+' people!');
                                       with region[f1] do begin
                                            wandc:=wandc-round(2*f7/3);
                                            men:=men-round(f7/3);
                                       end;
                                  end;
                              'F':begin
                                       f3:=random(6)+1;
                                       f5:=round(minn(f4/3,random(10)+1))+1;
                                       f5:=round(minn(f5,region[f1].comm[f3].devel));
                                       print('but reduced production of '+commods[f3]+' by '+st(f5,0)+' units!');
                                       with region[f1].comm[f3] do devel:=devel-f5;
                                  end;
                         end;
                    end;
                '?':begin
                         ab:=false;
                         pa('    [A]ttack enemy region');
                         pa('    [B]uild weapons');
                         pa('    [D]estroy weapons');
                         pa('    [E]mbargo levels');
                         pa('    [H]elp');
                         pa('    attack embargoing [N]avies');
                         pa('    [Q]uit to main menu');
                         pa('    air[S]trike enemy region');
                         pa('    change [T]roop size');
                         pa('    [V]iew military');
                    end;
           end;
ex:        qut:=false;
     until sel='Q';
end;