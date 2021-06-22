overlay procedure maintenance;

const
     milkeep:array[1..4] of real=(50,1000,3000,8000);
     nukekeep:array[1..5] of real=(500,3000,8000,5000,25000);

type barray=array[1..20] of boolean;

var f,i,ff,ii:integer;
    e,g,h,hm,hw,zz,rp,prodrev:real;
    afile:file of bigstring;
    da:bigstring;
    p,noem:barray;
    ur,ur1:array[1..20] of real;
    holdfile:text;

function blank(p:barray):boolean;
var x:integer;
    y:boolean;
begin
     y:=false;
     for x:=1 to 20 do y:=y or p[x];
     blank:=not y;
end;

function yesem(p:integer):boolean;
var f:integer;
    g:boolean;
begin
     g:=false;
     for f:=1 to 20 do with nation[f] do g:=g or (embarg[p]>0);
     yesem:=g;
end;




procedure closeSfile;
begin
  rewrite(holdfile);
  writeln(holdfile,Stuffx.Stuff);
  close(holdfile);
end;


begin
  assign(holdfile,datapath+'STUFFX.GEO');
  reset(holdfile);
  readln(holdfile,Stuffx.Stuff);
  If ((Timer>0.0) and (Timer<28800.0) and (Stuffx.stuff<>1)) or
       ((Timer>28799.0) and (Timer<57600.0) and (Stuffx.stuff<>2)) or
         ((Timer>57599.0) and (Timer<86399.0) and (Stuffx.Stuff<>3)) then begin
      print('Running MAINTENANCE program...this might take a while...');
      Stuffx.stuff:=Stuffx.Stuff+1;
      if Stuffx.Stuff>3 then Stuffx.Stuff:=1;
    with world do begin
         print('Changing date . . . ');
         currmonth:=currmonth+1;
         assign(afile,datapath+'THISYEAR.GEO');
         reset(afile);
         seek(afile,filesize(afile));
         da:=mnames[currmonth];
         if currmonth<13 then write(afile,da);
         close(afile);
         if currmonth>12 then begin
            currmonth:=1;
            curryear:=curryear+1;
            assign(afile,datapath+'LASTYEAR.GEO');
            erase(afile);
            assign(afile,datapath+'THISYEAR.GEO');
            rename(afile,datapath+'LASTYEAR.GEO');
            close(afile);
            assign(afile,datapath+'THISYEAR.GEO');
            rewrite(afile);
            da:='--International News Agency Monthly Compendium--';
            write(afile,da);
            da:='JAN';
            write(afile,da);
            close(afile);
            currdate:=convert(currmonth,curryear);
         end;
         if currmonth div 3=0 then begin
            if radiation>=1 then radiation:=radiation-1;
            if nukewinter>=1 then nukewinter:=nukewinter-1;
         end;
    end;
    print('Developing new commodities . . .');
    for f:=1 to 20 do with nation[f] do for ff:=1 to 6 do begin
            e:=0;
            for ii:=1 to 80 do with region[ii] do if controller=f then e:=e+minn(comm[ff].devel,(3*men+wandc)/300);
            if ff=1 then e:=e-e*world.nukewinter/100;
            case ff of
                 1:e:=e-e*world.nukewinter/100;
                 5:begin
                        e:=minn(e,ncomm[2]*2);
                        e:=minn(e,ncomm[3]*3);
                        e:=minn(e,ncomm[4]*3);
                        ncomm[2]:=ncomm[2]-int(e/2);
                        ncomm[3]:=ncomm[3]-int(e/3);
                        ncomm[4]:=ncomm[4]-int(e/3);
                   end;
                 6:begin
                        e:=minn(e,ncomm[5]*2);
                        e:=minn(e,ncomm[2]*3);
                        e:=minn(e,ncomm[3]*4);
                        ncomm[5]:=ncomm[5]-int(e/2);
                        ncomm[2]:=ncomm[2]-int(e/3);
                        ncomm[3]:=ncomm[3]-int(e/4);
                   end;
            end;
            if exim[ff]>0 then begin
               tcomm[ff]:=tcomm[ff]+minn(exim[ff],e);
               e:=e-minn(exim[ff],e);
            end;
            ncomm[ff]:=ncomm[ff]+e;
    end;
    print('Trading commodities . . . (could take a while)');
    for ff:=1 to 20 do noem[ff]:=not yesem(ff);
    for ff:=1 to 6 do for f:=1 to 20 do if (nation[f].exim[ff]<0) and noem[f] then begin
        for i:=1 to 20 do p[i]:=(nation[i].tcomm[ff]>0)
          and (adprice(i,f,ff)<=nation[f].price[ff]) and not (nation[i].rel[f] in ['H','W']) and noem[i];
        e:=-nation[f].exim[ff];
        while not blank(p) and (e>0) do begin
              h:=nation[f].price[ff];
              i:=0;
              for ii:=1 to 20 do with nation[ii] do
       if p[ii] and ((adprice(ii,f,ff)<h) or ((adprice(ii,f,ff)=h) and ((random<0.2) or (i=0)))) and (tcomm[ff]>0) then begin
                  i:=ii;
                  h:=adprice(ii,f,ff);
              end;
              g:=minn(e,nation[i].tcomm[ff]);
              with nation[i] do tcomm[ff]:=tcomm[ff]-g;
              with nation[f] do ncomm[ff]:=ncomm[ff]+g;
              with nation[i] do dinero:=dinero+g*adprice(i,f,ff);
              with nation[f] do dinero:=dinero-g*adprice(i,f,ff);
              p[i]:=false;
              e:=e-g;
        end;
    end;
    prompt('Updating nation   ');
    for f:=1 to 20 do with nation[f] do begin
        prompt(#8+#8+st(f,2));
        ispy:=5+random(5);
        hm:=0;
        hw:=0;
        prodrev:=0;
        for i:=1 to 80 do with region[i] do if controller=f then begin
            hm:=hm+men;
            hw:=hw+wandc;
            for ii:=1 to 6 do prodrev:=prodrev+comm[ii].devel*commworth[ii]/100;
        end;
        dinero:=dinero-(hm+hw)*percapita;
        for ii:=1 to 4 do dinero:=dinero-military[ii]*milkeep[ii];
        for ii:=1 to 5 do dinero:=dinero-nukes[ii]*nukekeep[ii];
        dinero:=dinero-defense*2500;
        dinero:=dinero+tax*(hm*17+hw*4+prodrev)/5;
        attacks:=1;
        h:=0;
        for ff:=1 to 80 do with region[ff] do if controller=f then h:=h+men+wandc;
        h:=h+military[1];
        h:=h/1000;
        e:=0;
        for ff:=1 to 2 do if h>ncomm[ff] then e:=e+(h-ncomm[ff])/h;
        ur1[f]:=e;
        e:=0;
        for ff:=1 to 6 do if h>ncomm[ff] then e:=e+(h-ncomm[ff])/(h*ff);
        ur[f]:=e;
        for ff:=1 to 6 do ncomm[ff]:=ncomm[ff]-minn(ncomm[ff],h);
    end;
    nl;
    getzap;
    prompt('Updating region   ');
    for f:=1 to 80 do with region[f] do begin
        prompt(#8+#8+st(f,2));
        rp:=unrest(f)+ur[controller];
        g:=1/((comm[6].devel+1)*12)-(world.radiation/1200)-(ur1[controller])/400;
        men:=int(men+g*men);
        if men<0 then men:=1;
        wandc:=int(wandc+g*wandc);
        if wandc<0 then wandc:=1;
        g:=int(men*rp/300);
        men:=men-g;
        rebels[1]:=rebels[1]+g;
        g:=int(wandc*rp/800);
        wandc:=wandc-g;
        rebels[1]:=rebels[1]+g;
        g:=int(nation[controller].military[1]*rp/500);
        with nation[controller] do military[1]:=military[1]-g;
        rebels[1]:=rebels[1]+g;
        if rp=0 then begin
           g:=minn(5+rebels[1]/10,rebels[1]);
           men:=men+g;
           rebels[1]:=rebels[1]-g;
        end;
        g:=strength(rebels)/500;
        for i:=1 to 6 do with comm[i] do devel:=devel-minn(devel,int(g/(i*4)));
        if rebels[1]>men+nation[controller].military[1]/2 then begin
           art.por:=controller;
           art.from:=21;
           newnat(f);
           art.mess:=nombre+' revolted and joined '+nation[controller].nombre;
           sendmess;
           art.mess:=nombre+' joined your nation';
           art.por:=controller;
           sendmess;
        end;
        with comm[1] do if credit>0 then begin
           credit:=credit-1;
           devel:=devel+1;
        end;
        for ii:=2 to 4 do with comm[ii] do if (credit>0) and (world.currmonth mod 2=0) then begin
           credit:=credit-1;
           devel:=devel+1;
        end;
        with comm[5] do if (credit>0) and (world.currmonth mod 3=0) then begin
           credit:=credit-1;
           devel:=devel+1;
        end;
        with comm[6] do if (credit>0) and (world.currmonth mod 4=0) then begin
           credit:=credit-1;
           devel:=devel+1;
        end;
    end;
    nl;
    print('Ok, all done.');
    census;
    closeSfile;
 end;
end;