type
  txt = string[255];

var
  abort : boolean;

function spacing(holder : txt; mode : real;  wlength : integer) : txt;
  var
    loop : integer;
  begin
    for loop:=1 to wlength-length(holder) do
      begin
        if mode=1 then holder:=holder+' '
        else holder:=' '+holder;
      end;
    spacing:=holder;
  end;

procedure printm(i : txt);
  begin
    if spd<>'300' then centre(i);
    print(i);
  end;

procedure printam(i : txt);
  begin
    if spd<>'300' then centre(i);
    printa(i,abort,next);
  end;

procedure prtm(i : txt);
  begin
    if spd<>'300' then centre(i);
    prt(i);
  end;
