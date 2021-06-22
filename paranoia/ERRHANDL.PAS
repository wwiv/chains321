var
  n : integer;
  st : string[16];
  filename : string[80];
  fff : text;

procedure printhex (n : integer);
begin
  st := '0123456789ABCDEF';
  n := abs(n);
  if (n < 16) then write (st[n+1])
  else
    begin
      printhex (n DIV 16);
      printhex (n MOD 16);
    end;
end;

procedure printruntimeerror (err : integer);
begin
  case err of
   $01 : sysoplog ( 'Floating point overflow.' );
   $02 : sysoplog ( 'Division by zero attempted.' );
   $03 : sysoplog ( 'Sqrt argument error.' );
   $04 : sysoplog ( 'Ln argument error.' );
   $10 : sysoplog ( 'String length error.' );
   $11 : sysoplog ( 'Invalid string index.' );
   $90 : sysoplog ( 'Index out of range.' );
   $91 : sysoplog ( 'Scalar or subrange out of range.' );
   $92 : sysoplog ( 'Out of integer range.' );
   $F0 : sysoplog ( 'Overlay file not found.' );
   $FF : sysoplog ( 'Heap/Stack Collision.' );
  end;
end;

procedure printioerror (err : integer);
begin
  case err of
    $01 : sysoplog ( 'File does not exist.' );
    $02 : sysoplog ( 'File not open for input.' );
    $03 : sysoplog ( 'File not open for output.' );
    $04 : sysoplog ( 'File not open.' );
    $10 : sysoplog ( 'Error in numeric format.' );
    $20 : sysoplog ( 'Operation not allowed on a logical device.' );
    $21 : sysoplog ( 'Not allowed in direct mode.' );
    $22 : sysoplog ( 'Assign to std files not allowed.' );
    $90 : sysoplog ( 'Record length mismatch.' );
    $91 : sysoplog ( 'Seek beyond end-of-file.' );
    $99 : sysoplog ( 'Unexpected end-of-file.' );
    $F0 : sysoplog ( 'Disk write error.' );
    $F1 : sysoplog ( 'Directory is full.' );
    $F2 : sysoplog ( 'File size overflow.' );
    $F3 : sysoplog ( 'Too many open files.' );
    $FF : sysoplog ( 'File disappeared.' );
  end;
end;

procedure error (errno, erraddr: integer);
var
  changefile : text;
begin
  case hi(errno) of
    0 : sysoplog ('User typed control-c');
    1 : begin
          writeln ('I/O Error ', lo(errno) );
          printioerror (lo(errno));
        end;
    2 : begin
          writeln ('Run-Time Error ', lo(errno) );
          printruntimeerror (lo(errno));
        end;
  else writeln ('Unknown Error Type, Number ', lo(errno) )
  end;
  write ( 'Offset from CS: $');
  printhex (erraddr); writeln;
  assign(changefile,'C:moutrap.chn');
  erase(changefile);
  assign(changefile,'c:bbs.com');
  execute(changefile);
end;
