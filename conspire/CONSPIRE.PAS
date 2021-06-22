Program Conspiracy;
{Version 1.0}
{$I common.pas}
{Started 10/03, last mod on 12/07}

Const NumLocs = 50;
      MaxNumPlayers = 20;
      dL = 2;
Type  Field1 = Array[1..NumLocs,1..18] of integer;

Var
      sc              :array[0..MaxNumPlayers] of integer;
      file1, file2, file3, file4, file5,
      file6, file7, file8, file9, file10,
      file11, file12                     : String[30];
      sm           :integer; { start money}
      Allow_alias     :integer; {0 = true}
      Locs            :Field1;
      LocN            :Array[1..NumLocs]of String[80];
      Pl              :array[1..MaxNumPlayers,1..18] of integer; {player info}
      Name            :array[1..MaxNumPlayers] of string[40];
      Al              :array[0..MaxNumPlayers] of string[40]; {alias}
      Xp              :array[1..MaxNumPlayers] of byte;
      {End of Read in Data}


      fila,filb         :text;
      pc,player         :integer; {player count, players}
      sd,count          :integer;     {date, counter}
      l1,l2,l3,l4       :integer;  {loop control}
      w1,w2,w3,w4       :integer;  {work variables}
      s1,s2             :integer;  {Spy counters}
      po                :str; {all-purpose output}
      exprt             :boolean;  {is player in expert mode?}
      bl1,bl2,bl3,bl4   :boolean;  {work boolean variables}
      c1,c2,sz          :char;     {input control}
      stf,Lcstf         :array[1..18] of string[20];  {Player&local stuff}
      wages,attack      :array[1..9] of integer;   {wages, size of attacker}
      dm,defense        :array[1..10] of integer;  {dieing men, size of def.}
      kv                :array[1..9] of integer; {Kill value of each}


Procedure ReadData;
Var filc:file of field1;
Begin

    { players }
    Assign(fila,file2);
    Reset(fila);
    pc:=0;
    player:=0;
    Repeat
      pc:=pc+1;
      readln(fila,Name[pc]);
      if name[pc]=nam then player:=pc;
      readln(fila,al[pc]);
      readln(fila,xp[pc]);
      for l1:=1 to 18 do Readln(fila,Pl[pc,l1]);
    Until eof(fila);
    Close(fila);
    if player>0 then
      if xp[player]=1 then exprt:=true else exprt:=false;

    Assign(filc,file1);
    Reset(filc);
    Read(filc,locs);
    Close(filc);

    Assign(fila,file10);
    Reset(fila);
    for l1:=1 to NumLocs do Readln(fila,LocN[l1]);
    Close(fila);

    {Players inited. Next comes date.}
    Assign(fila,file3);
    reset(fila);
    readln(fila,sd);
    Close(fila);

    {Read in the constants}
    Assign(fila,file12);
    reset(fila);
    for l1:=1 to 12 do Readln(fila,Stf[l1]);
    for l1:=10 to 18 do Readln(fila,Lcstf[l1]);
    for l1:=1 to 9 do Readln(fila,Wages[l1]);
    for l1:=1 to 9 do Readln(fila,Kv[l1]);
    Close(fila);

    for l1:=13 to 18 do Stf[l1]:='used '+stf[l1-12];

    for l1:=1 to 9 do LcStf[l1]:=Stf[l1];


    Al[0]:='UNKNOWN';

End;

Procedure News;
Begin
  Assign(fila,file5);
  Append(fila);
  Writeln(fila,po);
  Close(fila);
End;

Procedure Listplayers;
  begin
    for l1:=1 to pc do if l1<>player then
      begin
        if (Name[l1]<>'dead') and (Pl[l1,10]>-1) then
           Print(cstr(l1)+'  '+al[l1]);
        if l1/24=trunc(l1/24) then pausescr;
      end;
  end;

Procedure MailRead;
Begin
  Assign(fila,file8);
  Reset(fila);
  Assign(filb,file9);
  Rewrite(filb);
  repeat
    Readln(fila,po);
    Readln(fila,w1);
    Readln(fila,w2);
    if w1=player then
      begin
        Print('Incoming message from '+al[w2]+'.');
        Print(po);
        Nl;
      end
    else
      begin
        Writeln(filb,po);
        Writeln(filb,w1);
        Writeln(filb,w2);
      end;
  until eof(fila)=true;
  close(fila);
  close(filb);
  Erase(fila);
  Rename(filb,file8);
end;

Procedure Ret;
Var filc:file of field1;
Begin
    if exprt=true then xp[player]:=1 else xp[player]:=0;
    { players }
    Assign(fila,file2);
    Rewrite(fila);
    for l3:=1 to pc do
      begin
        writeln(fila,Name[l3]);
        writeln(fila,al[l3]);
        writeln(fila,xp[l3]);
        for l1:=1 to 18 do Writeln(fila,Pl[l3,l1]);
      end;
    Close(fila);

    Assign(filc,file1);
    Rewrite(filc);
    Write(filc,locs);
    Close(filc);
    Return;
End;

Procedure GetInt;
{this procedure will get an integer value, and place it in w3}
Begin
  Ansic(6);
  Prompt('> ');
  if nsl<0 then ret;
  if hangup then ret;
  Input(po,5);
  w4:=0;
  Val(po,w3,w4);
  if w4>0 then w3:=0;
  if w3<0 then
    begin
      Print('No negative values!');
      w3:=0;
    end;
End;

Procedure Inc(Var x:integer);
Begin
x:=x+1;
End;

Procedure SendMail;
Begin
  Assign(fila,file8);
  Append(fila);
  Writeln(fila,po);
  Writeln(fila,w3);
  Writeln(fila,player);
  close(fila);
end;

Procedure WriteMail;
Begin
  repeat
    Print('Send mail to which player? 0 for list, Q to abort');
    GetInt;
    if po='0' then listplayers;
  until (((w3>1) and (w3<pc+1)and (name[w3]<>'dead'))
                 and (w3<>player)) or (w4>0);
  if w4=0 then
    begin
      Print('Enter your message (up to one line).');
      if hangup then ret;
      Inputl(po,80);
      Sendmail;
    end;
end;


Procedure Maintenance;
Var ft,op,si,di:integer;
    wg         :real;
Begin
if sd<daynum(date) then
  begin
    Print('Running daily maintenance program.');
    Assign(fila,file6);
    Erase(fila);
    Assign(fila,file5);
    Rename(fila,file6);
    Assign(fila,file5);
    Rewrite(fila);
    Writeln(fila,'------------------');
    Close(fila);

    {Score routine}
    for l1:=1 to pc do
        sc[l1]:=trunc(Pl[l1,10]/60)+Pl[l1,4]*1+Pl[l1,9]*2
                +Trunc(Pl[l1,12]/120);

         for l2:=1 to NumLocs do
          sc[Locs[l2,15]]:=sc[Locs[l2,15]]+Locs[l2,14]+Trunc(Locs[l2,18]/2);
    sc[0]:=-1;

    {stored in sc[ ]}
    Assign(fila,file4);
    Rewrite(fila);
    Writeln(fila,'High Score list:');
    Writeln(fila,'Ranking     Name                   Score');
    Writeln(fila,'----------------------------------------------------------');
    ft:=0;
    for l1:=1 to pc do if Pl[l1,10]>-1 then ft:=ft+1;
    for l1:=1 to ft do
      begin
        po:=cstr(l1)+'        ';
        if l1<10 then po:=po+' ';
        if l1<100 then po:=po+' ';
        w1:=1;
        for l2:=1 to pc do if sc[l2]>sc[w1] then w1:=l2;
        po:=po+al[w1];
        for l2:=1 to 30-length(al[w1]) do po:=po+' ';
        po:=po+'          ';
        po:=po+cstr(sc[w1]);
        if sc[w1]<10000 then po:=po+' ';
        if sc[w1]<1000 then po:=po+' ';
        if sc[w1]<100 then po:=po+' ';
        if sc[w1]<10 then po:=po+' ';
        Writeln(fila,po);
        sc[w1]:=-1;
      end;
    close(fila);
    Assign(fila,file3);
    Rewrite(fila);
    Writeln(fila,daynum(date));
    close(fila);

    {Restore reserves}
    For l1:=1 to pc do
      begin
        for l2:=13 to 18 do
          begin
            Pl[l1,l2-12]:=Pl[l1,l2-12]+Pl[l1,l2];
            Pl[l1,l2]:=0;
          end;
        {modify public opinion}
        Pl[l1,11]:=Pl[l1,11]+3;
      end;

        {Defense $$$ regeneration}
        for l1:=1 to NumLocs do
          begin
            w1:=-Locs[l1,18]+locs[l1,14]*5;
            if w1>locs[l1,14] then w1:=locs[l1,14];
            Locs[l1,18]:=Locs[l1,18]+w1;
            {Cvilian recovery}
            w1:=Locs[l1,16]-Locs[l1,17];
            if w1>trunc(Locs[l1,16]/5) then w1:=trunc(locs[l1,16]/5);
            if (w1=0) and (Locs[l1,16]-Locs[l1,17]>0) then w1:=1;
            Locs[l1,17]:=Locs[l1,17]+w1;
          end;


    {Income}
    for l1:=1 to NumLocs do if Locs[l1,15]>0 then
      begin
        op:=Locs[l1,15];
        si:=Locs[l1,11];
        if 2*si-Locs[l1,7]<0 then di:=0 else
        si:=(2*si-Locs[l1,7])*Locs[l1,7];
        di:=Locs[l1,10];
        if 3*di-Locs[l1,8]<0 then di:=0 else
        di:=(3*di-Locs[l1,8])*Locs[l1,8];
        Pl[op,10]:=Pl[op,10]+di+si+Locs[l1,14];
        {D&S income, takeover income done, next comes salaries}
        for l2:=1 to 9 do Pl[op,10]:=Pl[op,10]-wages[l2]*Locs[l1,l2];



      end;
    {Pay salaries for non-activated members of gang}
    for l1:=1 to pc do if PL[l1,10]>-1 then
      begin
        Pl[l1,10]:=Pl[l1,10]+25;
        for l2:=1 to 9 do Pl[l1,10]:=Pl[l1,10]-wages[l2]*Pl[l1,l2]
      end
    else
      begin
        Pl[l1,10]:=Pl[l1,10]-1;
        if Pl[l1,10]<-30 then Pl[l1,10]:=-1;
      end;
    {Recruitment}
    for l1:=1 to pc do
      for l2:=1 to Pl[l1,9] do
        begin
          Pl[l1,1]:=Pl[l1,1]+random(5);
          if random<0.8 then inc(Pl[l1,2]);
          if random<0.35 then inc(Pl[l1,3]);
          if random<0.20 then inc(Pl[l1,4]);
          if random<0.20 then inc(Pl[l1,5]);
          if random<0.10 then inc(Pl[l1,6]);
          if random<0.18 then inc(Pl[l1,7]);
          if random<0.18 then inc(Pl[l1,8]);
          if random<0.15 then inc(Pl[l1,9]);
        end;
     {gradual rebuilding of defenses}
    for l1:=1 to NumLocs do
    if Locs[l1,17]<Locs[l1,16] then Locs[l1,17]:=Locs[l1,17]+1;
  end;
end;

Procedure GetGuys; {This figures out how many agents/spies are used}
{s1 is number of spies, s2 is number of agents}
Var bfr:string[7];

  begin
    s1:=-1;
    if Pl[player,5]>0 then
      Repeat
        if Pl[player,5]=1 then bfr:=' spy' else bfr:=' spies';
        Print('You have '+cstr(Pl[player,5])+bfr+'. Use how many?');
        GetInt;
        if (w3<=Pl[player,5]) and (w3>-1) then s1:=w3
        else Print('Invalid number.');
      Until s1>-1
    else s1:=0;
    if Pl[player,6]>0 then
      Repeat
        if Pl[player,6]=1 then bfr:=' agent' else bfr:=' agents';
        Print('You have '+cstr(Pl[player,6])+bfr+'. Use how many?');
        GetInt;
        if (w3<=Pl[player,6]) and (w3>-1) then s2:=w3
        else Print('Invalid number.');
      Until s2>-1
    else s2:=0;
    Pl[player,5]:=Pl[player,5]-s1;
    Pl[player,6]:=Pl[player,6]-s2;
  end;

Procedure ListLocs;
  begin
    Print('Existing locations:');
    for l1:=1 to NumLocs do Print(cstr(l1)+' '+LocN[l1]);
  end;

Procedure Intelligence;
Var ca,ag,gn,ow:integer;
    Chance,roll   :real;
    sz:char;
Begin
Repeat
  nl;
  Print('Intelligence:');
  Print('1) Spy on gang');
  Print('2) Investigate location');
  Print('3) Leave Intelligence menu');
  OneK(sz,'123Q');
  Nl;
  if sz='1' then
    repeat
      Print('Spy on which gang? (0 lists, Q aborts)');
      GetInt;
      if (w3=0) and (w4=0) then ListPlayers;
      if (w3>0) and (w3<>player) and (w3<=pc) and (Pl[w3,10]>-1) then
        begin
        {intelligence on group}
          w1:=w3;
          GetGuys;
          if s1+s2>0 then
            Begin
              Print('Infiltrating '+Al[w1]+' with '+cstr(s1)+' spies and '+cstr(s2)+' agents.');
              Ca:=Pl[w1,5]+Pl[w1,6]*2;
              Ag:=s1+s2*2;
              Chance:=(0.2+Ag/(Ag+Ca))*0.7;
              roll:=random;
              if roll<=chance then
                begin {spying successful}
                  Print(Al[w1]+' has:');
                  for l1:=1 to 18 do
                    begin
                      gn:=trunc(Pl[w1,l1]*(1+(chance-roll)
                           -random*(chance-roll)));
                      Print(stf[l1]+': '+cstr(gn));
                    end;
                  nl;
                  pausescr;
                end
              else
                begin
                  Print('Spy mission failed!');
                  if (roll-chance>0.1) and (s1>0) and (roll-chance<0.3) then
                    begin
                      Print('We lost a spy!');
                      s1:=s1-1;
                      Po:='You captured my spy!';
                      w3:=w1;
                      Sendmail;
                      Po:=Al[player]+' was caught trying to spy on someone!';
                      news;
                    end
                  else if (roll-chance>0.3) and (s2>0) then
                    begin
                      Print('We lost an agent!');
                      s2:=s2-1;
                      if random<0.3 then w1:=random(pc) else w1:=0;
                      if w1=0 then Po:='You killed my agent!' else
                        Po:='You captured my spy!';
                      ca:=player;
                      Player:=w1;
                      SendMail;
                      Player:=ca;
                      Po:=Al[w1]+' was caught trying to spy one someone.';
                      news;
                    end;
                end;
              Pl[player,17]:=Pl[player,17]+s1;
              Pl[player,18]:=Pl[Player,18]+s2;
              w4:=1;
            End
          else Print('You must use someone to infiltrate!');
        end
      else if (w3>0) or (w4<0) then Print('That group does not exist.');
      nl;
    until (w4>0) or (w3>0);
  if sz='2' then
    repeat
      Print('Investigate which location? (1-'+cstr(numlocs)+'), 0 to list, Q quits ?');
      GetInt;
      Nl;
      if (w3=0) and (w4=0) then listlocs;
      if (w3>0) and (w3<=numlocs) then
        begin
          {Intelligence on location}
          w1:=w3;
          GetGuys;
          ag:=s1+s2;
          if ag=0 then Print('You must send somebody!')
          else
            begin
              ca:=Locs[w1,5]+2*Locs[w1,6];
              chance:=ag/(ag+ca+0.2)*1.1;
              roll:=random;
              if (roll<chance) or (Locs[w1,15]=0) then
                begin
                  Print('You have successfully scouted out '+LocN[w1]);
                  for l1:=1 to 14 do Print(Lcstf[l1]+': '+cstr(Locs[w1,l1]));
                  Print('Owner: '+cstr(Locs[w1,15]));
                  nl;
                  if w1=45 then
                    begin
                      Print('Duh duh ack! We doesn''t guarantee lines fer data! dar eek!');
                      Print('GTE overcharged you $20 for your phone bill.');
                      Pl[player,10]:=Pl[player,10]-20;
                    end;
                end
              else if roll<chance+0.4 then
                begin
                  Print('Mission failed!');
                  if s1>0 then
                    begin
                      s1:=s1-1;
                      Print('They captured a spy!');
                      Po:='You captured one of my spies!';
                      w3:=Locs[w1,15];
                      Sendmail;
                      Po:='A spy was found dead near '+LocN[w1]+' believed to belong to '+Al[player];
                      news;
                    end
                  else
                    begin
                      s2:=s2-1;
                      Print('They killed an agent!');
                      Po:='You killed one of my agents!';
                      w3:=Locs[w1,15];
                      ca:=player;
                      Player:=0;
                      Sendmail;
                      Player:=ca;
                      Po:='A spy was found dead near '+LocN[w1];
                    end;
                  end
              else if roll<chance+0.2 then
                Print('Mission failed');
              Pl[player,17]:=Pl[player,17]+s1;
              Pl[player,18]:=Pl[Player,18]+s2;
            end;
          w4:=1;
        end;
    until w4>0;
  nl;
Until (sz='3') or (sz='Q');
End;

Procedure ListYourLocs;
Var count:integer;
Begin
 count:=0;
 for l1:=1 to NumLocs do
 if Locs[l1,15]=player then
   begin
     Print(cstr(l1)+' '+LocN[l1]);
     count:=count+1;
   end;
 if count=0 then Print('You have control over no locations!');
End;

Procedure Checkdeath(ptc:integer);
var tally:integer;
Begin
tally:=Pl[ptc,4]+Pl[ptc,16];
for l1:=1 to NumLocs do if Locs[l1,15]=ptc then
  tally:=tally+Locs[l1,4];
if Pl[ptc,10]<0 then tally:=0;
if tally=0 then
  begin
    Po:=Al[ptc]+', known as '+Name[ptc]+', has died with the collapse of his empire.';
    news;
    Print(po);
    for l1:=1 to NumLocs do
      if Locs[l1,15]=ptc then for l2:=1 to 9 do Locs[l1,l2]:=0;
    for l1:=1 to 18 do Pl[ptc,l1]:=0;
    Pl[ptc,10]:=-1;
  end;
if (tally=0) and (ptc=player) then
  begin
    Print('Your gang is destroyed!');
    ret;
  end;
end;

Procedure Defend;
Var
    lm:integer;
Begin
Repeat
  Print('Defense menu:');
  Print('1) Upgrade personal defense $$$');
  Print('2) Upgrade local defense $$$');
  Print('3) Exit defense menu.');
  OneK(sz,'123Q');
  nl;
  lm:=Pl[player,10];
  if sz='1' then
    begin
      Print('Current defense $$$ is '+cstr(Pl[player,12]));
      Print('You have '+cstr(lm)+' available to allocate.');
      Prompt('Spend how much more, Q to abort? ');
      GetInt;
      if (w3>0) and (w3<=lm) then
        begin
          Print(cstr(w3)+' spent on defense.');
          Pl[player,12]:=Pl[player,12]+w3;
          Pl[player,10]:=Pl[player,10]-w3;
          Print('New defense $$$ total: '+cstr(Pl[player,12]));
        end
      else print('Aborted.');
    end
  else if sz='2' then
    begin
      Repeat
        Print('Spend money on which area, 0 to list your, Q to abort?');
        GetInt;
        If (w3=0) and (w4=0) then ListYourLocs
        else if (w3>0) and (w3<=NumLocs) and (Locs[w3,15]=player) then
          begin
            w1:=w3;
            Print('Defense for '+LocN[w1]);
            Print('Current defense $$$ in this location: '+cstr(Locs[w1,18]));
            Print('You have '+cstr(lm)+' availabe to spend.');
            Print('Allocate how much for defense here? ');
            GetInt;
            if (w4=0) and (w3>0) and (w3<=lm) then
              begin
                Locs[w1,18]:=Locs[w1,18]+w3;
                Pl[player,10]:=Pl[player,10]-w3;
                Print('New local defense: '+cstr(Locs[w1,18]));
                w4:=1;
              end
            else Print('Aborted.');
          end;
      until w4>0;
    end;
until (sz='3') or (sz='Q');
End;

Procedure Income;
Var op,si,di,st,dt,xtt,mo,su,sut:integer;
    gloph:array[1..9] of integer;
    bfr:string[20];
Begin
Print('Status report: incomes');
mo:=25;
st:=0; dt:=0; xtt:=0;
Print('Miscellaneous:     $'+cstr(mo));
for l1:=1 to NumLocs do if Locs[l1,15]=player then
  begin
    op:=Locs[l1,15];
    si:=Locs[l1,11];
    if 2*si-Locs[l1,7]>0 then
    st:=st+(2*si-Locs[l1,7])*Locs[l1,7];
    di:=Locs[l1,10];
    if 3*di-Locs[l1,8]>0 then
    dt:=dt+(3*di-Locs[l1,8])*Locs[l1,8];
    xtt:=xtt+Locs[l1,14];
  end;
Print('Drug sales profit: $'+cstr(dt));
Print('Prostitution:      $'+cstr(st));
Print('Extortion:         $'+cstr(xtt));
Print('__________________________');
Print('Total:             $'+cstr(mo+dt+st+xtt));
Pausescr;
nl;


for l1:=1 to 9 do gloph[l1]:=Pl[player,l1];
for l1:=1 to 6 do gloph[l1]:=gloph[l1]+Pl[player,l1+12];
for l1:=1 to NumLocs do
  if Locs[l1,15]=player then
    for l2:=1 to 9 do gloph[l2]:=gloph[l2]+Locs[l1,l2];
mo:=Pl[player,10];
Print('You have '+cstr(mo)+' dollars.');
Print('Your predicted salary expenses:');
sut:=0;
for l1:=1 to 9 do
  begin
    su:=gloph[l1]*wages[l1];
    sut:=sut+su;
    bfr:=' ';
    for l2:=20 downto length(stf[l1]) do bfr:=bfr+' ';
    Po:=(stf[l1]+bfr+cstr(gloph[l1])+' X '+cstr(wages[l1])+' = '+cstr(su));
    Print(po);
  end;
Print('Total expense: '+cstr(sut));
Print('Do you wish to keep all employees?');
if not yn then
  begin
    repeat
      Print('Fire which type, 0 to list, Q to end.');
      GetInt;
      if (w3=0) and (w4=0) then
        for l1:=1 to 9 do Print(cstr(l1)+' '+stf[l1]+' '+cstr(pl[player,l1]));
      if (w3>0) and (w3<10) and (w4=0) then
        begin
          w1:=w3;
          w2:=Pl[player,w1];
          Print('You have '+cstr(w2)+' '+stf[w1]+' in reserve.');
          Print('Fire how many?');
          GetInt;
          If (w4=0) and (w3>0) and (w3<=w2) then
            begin
              Print('Firing '+cstr(w3)+' '+stf[w1]);
              Pl[player,w1]:=Pl[player,w1]-w3;
              Print('You now have '+cstr(Pl[player,w1])+' '+stf[w1]+' left.');
            end
          else Print('Aborted.');
        end;
    until w4>0;
  end;
  nl;
Checkdeath(player);
End;

Procedure Fry;
Var toll,zot:real;
    dee,counts:integer;
    bfr:string[6];
Begin
  counts:=0;
  if Dm[10]>0 then Print('Encountering planned defenses.');
  toll:=w1*(random+0.3)/10;
  if toll<Dm[10]/10 then
    begin
      Dm[10]:=Dm[10]-trunc(toll*10);
      toll:=0;
    end
  else
    begin
      toll:=toll-Dm[10]/10;
      Dm[10]:=0;
    end;
  count:=0;
  for l1:=1 to 9 do count:=count+dm[l1];
  count:=count+trunc(Dm[10]/10);
  if toll>count then toll:=count;
  for l1:=1 to trunc(toll) do
    begin
      zot:=random;
      repeat
        dee:=0;
        if dm[1]>0 then dee:=1;
        if (dm[2]>0) and (zot>0.65) then dee:=2;
        if (dm[3]>0) and (zot>0.75) then dee:=3;
        if (dm[4]>0) and (zot>0.82) then dee:=4;
        if (dm[7]>0) and (zot>0.5)  then dee:=7;
        if (dm[8]>0) and (zot>0.65) then dee:=8;
        if (dm[9]>0) and (zot>0.85) then dee:=9;
        if (dm[5]>0) and (zot>0.88) then dee:=5;
        if (dm[6]>0) and (zot>0.94) then dee:=6;
        zot:=zot+0.1;
      until (dee>0) or (count=0);
      dm[dee]:=dm[dee]-1;
      count:=count-1;
      Print('Casualty! :'+Stf[dee]);
      counts:=counts+1;
    end;
  if count=0 then Print('Forces completely wiped out!');
  if counts=1 then bfr:=' man ' else bfr:=' men ';
  po:=cstr(counts)+bfr+'died!';
  Print(po);
  nl;
end;



Procedure Kill;
Var dama,damb,dugo,Nume:integer;
    rat:real;
Begin
  dama:=0;
  damb:=0;
  rat:= attack[1]/(attack[3]+0.01);
  if rat>5 then dugo:=attack[1]-attack[3]*5;
  if rat>5 then Print('Goons are attacking in chaos!');
  for l1:=1 to 6 do dama:=dama+attack[l1]*kv[l1];
  for l1:=1 to 9 do damb:=damb+defense[l1]*kv[l1];
  nume:=0;
  for l1:=1 to 9 do nume:=nume+defense[l1];
  if nume>0 then Print(cstr(nume)+' armed men resisting.');
  damb:=damb+trunc(defense[10]/5);
  if rat>5 then damb:=damb+dugo*3;
  for l1:=1 to 6 do dm[l1]:=attack[l1];
  for l1:=7 to 10 do dm[l1]:=0;
  Print('Attacker''s casualties:');
  w1:=damb;
  if sz='2' then dugo:=Locs[w3,12]-random(100) else dugo:=0;
  if dugo>0 then
    begin
      Print('The Police intervene!');
      w1:=w1+dugo*10;
      pausescr;
    end;
  fry;
  for l1:=1 to 6 do attack[l1]:=dm[l1];
  nl;
  if count=0 then
      Print('The attacker has been wiped out!');
  Print('Defender''s casualties:');
  for l1:=1 to 10 do dm[l1]:=defense[l1];
  w1:=dama;
  fry;
  for l1:=1 to 10 do defense[l1]:=dm[l1];
  if count=0 then Print('The defender has been wiped out!');


End;

Procedure Undo;
      begin
        Print('Attack aborted.');
        for l1:=1 to 6 do Pl[player,l1]:=Pl[player,l1]+Attack[l1];
        for l1:=1 to 6 do Pl[player,l1+12]:=Pl[player,l1+12]-Attack[l1];
      end;

Procedure Attacks;
Var
    place,defender:integer;
    zotz:real;
Begin
Print('Attack menu:');
Print('1) Attack player');
Print('2) Take over location');
Print('3) Leave attack menu');
OneK(sz,'123Q');

if (sz<>'3') and (sz<>'Q') then
  begin
    Print('You must select your attack force from reserves.');
    for l1:=1 to 9 do attack[l1]:=0;
    for l1:=1 to 6 do if Pl[player,l1]>0 then
      begin
        repeat
          Print('You have '+cstr(Pl[player,l1])+' '+stf[l1]+' available.');
          Prompt('Use how many ? ');
          GetInt;
          Attack[l1]:=w3;
          if w3>Pl[player,l1] then Print('You don''t have that many.');
        until (w4=0) and (Attack[l1]<=Pl[player,l1]);
      end
      else Attack[l1]:=0;
    
    if attack[4]<1 then
      begin
        Print('You must have a boss command the attack');
        for l1:=1 to 6 do attack[l1]:=0;
      end
    else for l1:=1 to 6 do Pl[player,l1]:=Pl[player,l1]-Attack[l1];
  end; {attack group assembled}


if (sz='1') and (attack[4]>0) then
  begin
    repeat
     repeat
       Print('Who do you want to attack, 0 to list, Q to abort?');
       GetInt;
       if (w4=0) and (w3=0) then ListPlayers;
       if w3>MaxNumPlayers then w3:=0;
       if w4>0 then w3:=1;
     until (w3>0) and (w3<>player);
    until (Pl[w3,10]>-1) or (w3=1);
    if w4=0 then
      begin
        for l1:=1 to 9 do defense[l1]:=Pl[w3,l1];
        defense[10]:=trunc(Pl[w3,12]);
        Print('Targeted gang: '+Al[w3]);
        kill;
        for l1:=1 to 9 do Pl[w3,l1]:=defense[l1];
        Pl[w3,12]:=defense[10];
        if w3>0 then checkdeath(w3);
        po:='You were attacked by me.';
        Sendmail;
      end
    else undo;
  end;

if (sz='2') and (attack[4]>0) then
  begin
    repeat
      Print('Which location do you wish to take over, 0 to list, Q to abort?');
      getint;
      if (w4=0) and (w3=0) then ListLocs;
      if (w3>NumLocs) then w3:=0;
    until (w3>0) or (w4>0);
    if w4=0 then
      begin
        Print('Target for takeover: '+LocN[w3]);
        place:=w3;
        for l1:=1 to 9 do defense[l1]:=Locs[place,l1];
        Defense[10]:=trunc(Locs[place,18])+Locs[place,17]*10;
        s1:=Locs[place,17]*10;
        Print(cstr(trunc(s1/10))+' civilians resisting.');
        kill;
        for l1:=1 to 9 do Locs[place,l1]:=Defense[l1];
        if s1>Defense[10]*10 then s1:=defense[10]*10;
        Locs[place,17]:=trunc(s1/10);
        Locs[place,18]:=defense[10]-s1;
        zotz:=random;
        l4:=0;
        if zotz<0.4 then l4:=player;
        if zotz<0.1 then l4:=random(pc);
        Po:=Al[l4]+' tried to takeover '+LocN[place];
        w1:=Locs[place,15];
        if w1>1 then Sendmail;
        if random(100)<Locs[place,13] then news;
        if (count=0) and (Attack[4]>0) then
          begin
            if Locs[w3,15]>0 then checkdeath(Locs[w3,15]);
            Print('You take control of '+LocN[w3]+'!');
            Print('They agree to pay you '+cstr(Locs[w3,14])+' dollars per day!');
            Locs[place,15]:=player;
          end;
      end
    else undo;
  end;


if (sz<>'3') and (sz<>'Q') then for l1:=1 to 6 do
     Pl[player,l1+12]:=Pl[player,l1+12]+Attack[l1];
  Checkdeath(player);
End;

Procedure Publicity;
Begin
  Repeat
  Print('Publicity menu:');
  Print('1) Random killings');
  Print('2) Charity');
  Print('3) Exit menu');
  OneK(sz,'123Q');
  if sz='1' then
    begin
      if Pl[player,1]<0 then Print('You must have goons for random killings!')
      else
        begin
          Pl[player,11]:=Pl[player,11]-random(20);
          Print('Random killing completed. The people don''t approve...');
        end;
    end;
  if sz='2' then
    begin
      Print('How much money would you like to spend on charity/positive publicity?');
      GetInt;
      if w3>Pl[player,10] then
        Print('You don''t have enough money!')
      else
        begin
          w1:=trunc(w3/50);
          Print('Your public opinion went up '+cstr(w1)+' points.');
          Pl[player,11]:=Pl[player,11]-w1;
        end;
    end;
  Until (sz='3') or (sz='Q');

End;

Procedure Status;
Begin
Repeat
  Print('Status menu:');
  Print('1)   Gang-status');
  Print('2)   Location-status');
  Print('3)   Exit status menu');
  OneK(sz,'123Q');
  if sz='1' then
    begin
      Print('Inventory for '+Al[player]);
      For l1:=1 to 18 do Print(stf[l1]+': '+cstr(Pl[player,l1]));
    end;
  if sz='2' then
    begin
      repeat
        Print('Which section of town, 0 to list yours, Q to abort?');
        GetInt;
        if (w3=0) and (w4=0) then listyourlocs;

        if (w3>0) and (w3<=NumLocs) then
          begin
            if (Locs[w3,15]=player) then
              begin
                for l1:=1 to 14 do if Locs[w3,l1]>0 then
                Print(LcStf[l1]+': '+cstr(Locs[w3,l1]));
                Print(LcStf[18]+': '+cstr(Locs[w3,18]));
                w4:=1;
              end
            else Print('You don''t have control over that!');
          end;
      until w4>0;
    end;
Until (sz='3') or (sz='Q');
End;

Procedure Maneuver;
Begin
Repeat
  Print('Move/withdraw men from which location, 0 to list, Q to abort?');
  GetInt;
  if (w3=0) and (w4=0) then ListYourLocs else
  if (w4=0) then
  if Locs[w3,15]<>player then Print('You do not control that.');
  if (w4=0) and (w3>0) and (w3<=NumLocs) then
   if (Locs[w3,15]=player) then
    begin
      Repeat
        if w3>0 then w1:=w3;
        Print('Change deployment of what, 0 to list, Q to abort?');
        GetInt;
        if (w3>0) and (w3<10) then
          if Pl[player,w3]+Locs[w1,w3]<1 then
            begin
              Print('You have no '+stf[w3]+' to maneuver!');
              w3:=0; w4:=-1;
            end;
        w2:=w3;
        if (w2=0) and (w4=0) then for l1:=1 to 9 do
           Print(cstr(l1)+' '+LcStf[l1]+': '+cstr(Locs[w1,l1]));
        if (w4=0) and (w2>0) and (w2<10) then
          begin
            po:=Stf[w2]+'- current:'+cstr(Locs[w1,w2])+'. Maximum deployable:';
            Pl[player,w2]:=Pl[player,w2]+Locs[w1,w2];
            Locs[w1,w2]:=0;
            po:=po+cstr(pl[player,w2]);
            Print(po);
            Prompt('New total to deploy? ');
            GetInt;
            if (w4=0) and (w3>0) and (w3<=pl[player,w2]) then
              begin
                Print('Redployment successful.');
                Locs[w1,w2]:=w3;
                Pl[player,w2]:=Pl[player,w2]-w3;
                Print('You have '+cstr(Pl[player,w2])+' '+Stf[w2]+' left in reserve.');
                w4:=1;
              end
            else Print('Redployment aborted.');
          end;
      Until w4>0;
      w4:=0;
    end;
Until w4>0;
End;

Procedure SysOop;
Begin
SysOpLog('Entering Conspiracy Sysop menu.');
Repeat
Nl;
Print('Sysop Menu: N)ew player, M)od player Attributes, Q)uit, L)ocal mod');
Print('            R)un Maintenance');
Po:='LMNQSR';
Onek(sz,po);
case sz of
'R':begin
      sd:=0;
      Maintenance;
      SysOpLog('SysOp calling for maintenance.');
    end;

'M':repeat
      Print('Change which attribute, 0 for list, Q to abort?');
      Repeat
        GetInt;
        if (w3=0) and (w4=0) then for l1:=1 to 18 do
        Print(cstr(l1)+' '+stf[l1]+' '+cstr(Pl[player,l1]));
      Until (w4>0) or ((w3>0) and (w3<19) and (w4=0));
      if w3>0 then
        begin
          Print('Modifying '+stf[w3]);
          Print('Old value: '+cstr(Pl[Player,w3]));
          w1:=w3;
          Prompt('Enter new value  ');
          GetInt;
          Pl[player,w1]:=w3;
        end;
    until w4>0;
'L':begin
      Repeat
        Print('Modify which location, 0 to list, Q to abort?');
        GetInt;
        if (w3=0) and (w4=0) then listlocs;
        if (w3>0) and (w3<=NumLocs) then
          begin
            Repeat
              if w3>0 then w1:=w3;
              Print('Adjusting '+LocN[w1]);
              Print('Modify which attribute, 0 to list, S to save?');
              GetInt;
              if (w3=0) and (w4=0) then for l1:=1 to 18 do
                Print(cstr(l1)+' '+LcStf[l1]+': '+cstr(Locs[w1,l1]));
              if (w3>0) and (w3<19) then
                begin
                  Print('Modifying '+LcStf[w3]);
                  Print('Old value: '+cstr(Locs[w1,w3]));
                  w2:=w3;
                  Prompt('New value, Q to abort ');
                  GetInt;
                  if w4=0 then Locs[w1,w2]:=w3 else
                   Print('Aborted.');
                  w4:=1;
                end;
            Until w4>0;
          end;
      Until w4>0;
    end;

'N':Begin
      Print('Current player is '+cstr(player));
      Repeat
        Print('Enter new player, q to abort, 0 to list.');
        GetInt;
        if (w3=0) and (w4=0) then for l1:=1 to pc do
          begin
            Prompt(cstr(l1)+'   '+Al[l1]+'   '+Name[l1]);
            if Pl[l1,10]<0 then Prompt('     (dead)');
            nl;
          end;
        if (w4=0) and (w3>0) then player:=w3;
      Until (w4>0) or ((w4=0) and (w3<=pc) and (w3>0));
      Print('You are now '+Al[player]);
    end;

end;

until sz='Q';
End;

Begin
Iport;
Print('Conspiracy v1.0 ');
Print('Written by Elihu Feustel');
Print('StrongPoint Alpha');
Print('812-877-4416');
Print('24 hours/3-12 baud');
SysOpLog('* Entered Conspiracy!');

Randomize;
      file1 := datapath+'Conslocs.dat'; {info on locations}
      file2 := datapath+'Consplay.dat'; {player info}
      file3 := datapath+'Consdate.dat'; {helps check for maintenance}
      file4 := gfilespath+'Conshigh.txt'; {high score file}
      file5 := gfilespath+'Consnews.txt'; {Today's news}
      file6 := gfilespath+'Consolds.txt'; {Yesterday's news}
      file7 := gfilespath+'Consdocs.txt'; {Docs}
      file8 := datapath+'Consmsgs.dat'; {Message base}
      file9 := gfilespath+'Conswork.txt'; {Work file for message base}
      file10:= gfilespath+'ConsLcNm.txt'; {Names of all the locations}
      file11:= gfilespath+'ConsMenu.txt'; {Main Menu}
      file12:= datapath+'Consvars.dat'; {Millions of constants}

Randomize;
ReadData;
Maintenance;

if player=0 then Print('Welcome, '+nam) else print('Welcome, '+al[player]);
Printfile(file4);
Pausescr;
Print('Today''s news:');
Printfile(file5);
Pausescr;
Print('Yesterday''s news:');
Printfile(file6);

if (player>0) then
  if (xp[player]=1) then exprt:=true else exprt:=false;

bl1:=false;
bl4:=false;
if player=0 then
  begin {init a new person}
    w4:=37;
    w1:=0;
    bl2:=false;
    repeat
      w1:=w1+1;
      bl3:=false;
      if (name[w1]='dead') or (w1>pc) then bl3:=true;
      if bl3 then
        begin
          player:=w1;
          name[player]:=nam;
          Print('Waste him, Mugsley');
          Delay(1000);
          Print('Wait. Maybe we can find *some* use for him...');
          Delay(1000);
          Print('Welcome to CONSPIRACY! New servants of the underground are welcome...');
          bl1:=true;
          bl2:=true;
        end;
      if w1=MaxNumPlayers then bl2:=true;
    until bl2;
    if bl1=false then
      begin
        Print('All spaces are occupied. Try later when people have been deleted.');
        ret;
      end;
  end;

{check to see if person is dead}
if (Pl[player,10]<0) and (w4<>37) then
  begin
    Print('You are dead.');
    if abs(Pl[player,10])<dl then
      begin
        Print('You can not play for '+cstr(dl+1+pl[player,10])+' more day(s).');
        ret;
      end
    else
      begin
        Print('You are being initialized.');
        bl1:=true;
      end;
  end;

{Player init routine if bl1 = true}
if bl1=true then
  begin
    name[player]:=nam;
    exprt:=false;
        repeat
          Print('What would you like your alias to be?');
          Prompt('> ');
          if hangup then ret;
          Inputl(po,40);
          al[player]:=po;
          if length(al[player])<3 then al[player]:=name[player];
          Prompt('Are you sure '+al[player]+ ' is correct? (Y/N)');
        until yn;
    if player>pc then pc:=player;
    Pl[player,1]:=10;
    Pl[player,2]:=2;
    Pl[Player,3]:=2;
    Pl[player,4]:=2;
    Pl[player,5]:=2;
    Pl[player,6]:=0;
    Pl[player,7]:=1;
    Pl[player,8]:=1;
    Pl[player,9]:=2;
    Pl[player,10]:=500;
    Pl[player,11]:=0;
    Pl[player,12]:=200;
    for l1:=13 to 18 do Pl[player,l1]:=0;
  end;

mailread;

income;

{The Main Loop}

Repeat
  if not exprt then
    begin
      Nl;
      Printfile(file11);
    end;
  po:='ABDFIHMPSQXW';
  if so then po:=po+']';
  if (hangup) or (nsl<0) then ret;
  Print(po);
  OneK(c1,po);
  Nl;
  case c1 of
  'A':Attacks;
  'B':begin
        Printfile(file4);
        Pausescr;
        Print('Today''s news:');
        Printfile(file5);
        Pausescr;
        Print('Yesterday''s news:');
        Printfile(file6);
      end;
  'D':defend;
  'F':income;
  'I':Intelligence;
  'H':Printfile(gfilespath+'Conshelp.txt');
  'M':maneuver;
  'P':publicity;
  'Q':begin
       Prompt('Are you sure you want to quit?');
       if not yn then c1:='A';
     end;
  'S':status;
  'X':if exprt then exprt:=false else exprt:=true;
  'W':writemail;
  ']':SysOop;
  end;
Until c1='Q';
ret;

end.
