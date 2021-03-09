unit u2048;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, ComCtrls, Math;

type
  Tf2048 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    PaintBox1: TPaintBox;
    MainMenu1: TMainMenu;
    links1: TMenuItem;
    Tasten1: TMenuItem;
    rechts1: TMenuItem;
    hoch1: TMenuItem;
    runter1: TMenuItem;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Button2: TButton;
    CheckBox2: TCheckBox;
    Label4: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure links1Click(Sender: TObject);
    procedure rechts1Click(Sender: TObject);
    procedure hoch1Click(Sender: TObject);
    procedure runter1Click(Sender: TObject);
    procedure auswertung(Sender: TObject);
    procedure auswertungzeigen(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    feld,feld2 : array[0..10,0..10] of integer;
    richtung : integer;
    geschafft,ende:boolean;
    punkte:integer;
    groesse,groesse2:integer;
    zweiterwert:integer;
    testabbruch:boolean;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  f2048: Tf2048;

implementation

{$R *.DFM}

procedure Tf2048.PaintBox1Paint(Sender: TObject);
var b,h,breite,xoffset,yoffset : integer;
    i,j:integer;
    bitmap:tbitmap;
    ziel:tcanvas;
    k:string;
    buchstabe,wert:integer;
begin
    b:=paintbox1.width;
    h:=paintbox1.height;
    bitmap:=tbitmap.create;
    bitmap.width:=b;
    bitmap.height:=h;
    ziel:=bitmap.canvas;
    ziel.font.name:='Verdana';
    ziel.font.size:=round(32*4/max(groesse,groesse2));
    if checkbox1.checked then
      ziel.font.size:=round(48*4/max(groesse,groesse2));

    breite:=(b-40) div groesse;
    if (h-40) div groesse2 < breite then
      breite:=(h-40) div groesse2;
    xoffset:=(b-groesse*breite) div 2;
    yoffset:=(h-groesse2*breite) div 2;
    for i:=0 to groesse-1 do
      for j:=0 to groesse2-1 do
      begin
        if feld[i+1,j+1]<>0 then
        begin
         case feld[i+1,j+1] of
          2 : ziel.brush.color:=$00ffd0d0;
          4 : ziel.brush.color:=$00ffa0a0;
          8 : ziel.brush.color:=$00ff8080;
         16 : ziel.brush.color:=$00a08080;
         32 : ziel.brush.color:=$00808080;
         64 : ziel.brush.color:=$00a0a080;
        128 : ziel.brush.color:=$00a0d080;
        256 : ziel.brush.color:=$00a0ff80;
        512 : ziel.brush.color:=$00a0ffa0;
       1024 : ziel.brush.color:=$00a0ffc0;
       2048 : ziel.brush.color:=$00a0ffff;
          end;
        end;
        ziel.rectangle(xoffset+i*breite,yoffset+j*breite,
                       xoffset+(i+1)*breite+1,yoffset+(j+1)*breite+1);
        if feld[i+1,j+1]>0 then
        begin
           k:=inttostr(feld[i+1,j+1]);
           if checkbox1.checked then
           begin
             buchstabe:=0;
             wert:=feld[i+1,j+1];
             repeat
               wert:=wert div 2;
               inc(buchstabe);
             until wert mod 2 = 1;
             k:=chr(64+buchstabe);
           end;
           if length(k)>3 then ziel.font.style:=[]
                          else ziel.font.style:=[fsbold];

           ziel.brush.style:=bsclear;
           ziel.textout(xoffset+i*breite+breite div 2-ziel.textwidth(k) div 2,
                        yoffset+j*breite+breite div 2-ziel.textheight(k) div 2,k);
        end;
      end;

    paintbox1.canvas.draw(0,0,bitmap);
    bitmap.free;

    geschafft:=false;
    for i:=1 to groesse do
      for j:=1 to groesse2 do
        if feld[i,j]=2048 then geschafft:=true;
    ende:=true;
    for i:=1 to groesse do
      for j:=1 to groesse2 do
        if feld[i,j]=0 then ende:=false;
    for i:=1 to groesse do
      for j:=1 to groesse2 do
      begin
        if feld[i,j]=feld[i+1,j] then ende:=false;
        if feld[i,j]=feld[i-1,j] then ende:=false;
        if feld[i,j]=feld[i,j+1] then ende:=false;
        if feld[i,j]=feld[i,j-1] then ende:=false;
      end;
    if geschafft or ende then auswertungzeigen(sender);
end;

procedure Tf2048.auswertungzeigen(Sender: TObject);
begin
    if punkte>0 then
    begin
      if geschafft then showmessage('Gratulation! Ein Feld hat den Wert 2048. Erreichte Punktzahl '+inttostr(punkte));
      if ende then showmessage('Schade! Spielende! Erreichte Punktzahl '+inttostr(punkte));
      punkte:=0;
    end;
end;

procedure Tf2048.FormActivate(Sender: TObject);
begin
    button1click(sender);
end;

procedure Tf2048.Button1Click(Sender: TObject);
var i,j:integer;
begin
    fillchar(feld,sizeof(feld),1);
    for i:=1 to groesse do
      for j:=1 to groesse2 do feld[i,j]:=0;
    randomize;
    i:=random(groesse);
    j:=random(groesse2);
    feld[i+1,j+1]:=2;
    i:=random(groesse);
    j:=random(groesse2);
    while feld[i+1,j+1]>0 do
    begin
      i:=random(groesse);
      j:=random(groesse2);
    end;
    feld[i+1,j+1]:=2;
    punkte:=4;
    label2.caption:=inttostr(punkte);
    paintbox1paint(sender);
end;

procedure Tf2048.links1Click(Sender: TObject);
begin
    richtung:=0;
    auswertung(sender);
end;

procedure Tf2048.rechts1Click(Sender: TObject);
begin
    richtung:=1;
    auswertung(sender);
end;

procedure Tf2048.hoch1Click(Sender: TObject);
begin
    richtung:=2;
    auswertung(sender);
end;

procedure Tf2048.runter1Click(Sender: TObject);
begin
    richtung:=3;
    auswertung(sender);
end;

procedure Tf2048.auswertung(Sender: TObject);
var i,j,z:integer;
    nochleer:boolean;
begin
    case richtung of
      0 : begin
            for j:=1 to groesse2 do
            begin
              i:=1;
              repeat
                if feld[i,j]>0 then
                begin
                  z:=i+1;
                  repeat
                    if feld[i,j]=feld[z,j] then
                    begin
                      feld[i,j]:=2*feld[i,j];
                      feld[z,j]:=0;
                      i:=z;
                      z:=groesse+1
                    end
                    else
                    begin
                      if feld[z,j]=0 then inc(z)
                                     else z:=groesse+1;
                    end;
                  until z>groesse;
                end;
                inc(i);
              until i>groesse;
            end;

            for j:=1 to groesse2 do
            begin
              for i:=2 to groesse do
              begin
                if feld[i,j]<>0 then
                begin
                  z:=0;
                  while feld[i-1-z,j]=0 do inc(z);
                  if z>0 then
                  begin
                    feld[i-z,j]:=feld[i,j];
                    feld[i,j]:=0;
                  end;
                end;
              end;
            end;
          end;
      1 : begin
            for j:=1 to groesse2 do
            begin
              i:=groesse;
              repeat
                z:=i-1;
                repeat
                  if feld[i,j]=feld[z,j] then
                  begin
                    feld[i,j]:=2*feld[i,j];
                    feld[z,j]:=0;
                    i:=z;
                    z:=0
                  end
                  else
                  begin
                    if feld[z,j]=0 then dec(z)
                                   else z:=0;
                  end;
                until z<1;
                dec(i);
              until i<1;
            end;

            for j:=1 to groesse2 do
            begin
              for i:=groesse-1 downto 1 do
              begin
                if feld[i,j]<>0 then
                begin
                  z:=0;
                  while feld[i+1+z,j]=0 do inc(z);
                  if z>0 then
                  begin
                    feld[i+z,j]:=feld[i,j];
                    feld[i,j]:=0;
                  end;
                end;
              end;
            end;
          end;
      2 : begin
            for j:=1 to groesse do
            begin
              i:=1;
              repeat
                z:=i+1;
                repeat
                  if feld[j,i]=feld[j,z] then
                  begin
                    feld[j,i]:=2*feld[j,i];
                    feld[j,z]:=0;
                    i:=z;
                    z:=groesse2+1
                  end
                  else
                  begin
                    if feld[j,z]=0 then inc(z)
                                   else z:=groesse2+1;
                  end;
                until z>groesse2;
                inc(i);
              until i>groesse2;
            end;

            for i:=1 to groesse do
            begin
              for j:=2 to groesse2 do
              begin
                if feld[i,j]<>0 then
                begin
                  z:=0;
                  while feld[i,j-1-z]=0 do inc(z);
                  if z>0 then
                  begin
                    feld[i,j-z]:=feld[i,j];
                    feld[i,j]:=0;
                  end;
                end;
              end;
            end;
          end;
      3 : begin
            for j:=1 to groesse do
            begin
              i:=groesse2;
              repeat
                z:=i-1;
                repeat
                  if feld[j,i]=feld[j,z] then
                  begin
                    feld[j,i]:=2*feld[j,i];
                    feld[j,z]:=0;
                    i:=z;
                    z:=0
                  end
                  else
                  begin
                    if feld[j,z]=0 then dec(z)
                                   else z:=0;
                  end;
                until z<1;
                dec(i);
              until i<1;
            end;

            for i:=1 to groesse do
            begin
              for j:=groesse2-1 downto 1 do
              begin
                if feld[i,j]<>0 then
                begin
                  z:=0;
                  while feld[i,j+z+1]=0 do inc(z);
                  if z>0 then
                  begin
                    feld[i,j+z]:=feld[i,j];
                    feld[i,j]:=0;
                  end;
                end;
              end;
            end;
          end;
    end;

      nochleer:=false;
      for i:=1 to groesse do
        for j:=1 to groesse2 do
          if feld[i,j]=0 then nochleer:=true;

      if nochleer then
      begin
        i:=random(groesse);
        j:=random(groesse2);
        while feld[i+1,j+1]>0 do
        begin
          i:=random(groesse);
          j:=random(groesse2);
        end;
          if random>0.1 then feld[i+1,j+1]:=2
                        else feld[i+1,j+1]:=zweiterwert;
      end;

    paintbox1paint(sender);
    punkte:=0;
    for i:=1 to groesse do
      for j:=1 to groesse2 do
        punkte:=punkte+feld[i,j];
    label2.caption:=inttostr(punkte);
end;

procedure Tf2048.Edit1Change(Sender: TObject);
var k:string;
    code:integer;
begin
    k:=edit1.text;
    val(k,groesse,code);
    if groesse<3 then groesse:=4;
    button1click(sender);
end;

procedure Tf2048.Button2Click(Sender: TObject);
var arichtung:array[0..3,0..3,0..3,0..3,0..3] of integer;
    neuerichtung,maximum:integer;
    i,j,n,m,o:integer;
    unterschied:integer;
    schritte:integer;
procedure testschieben(richtung2:integer);
var i,j,z:integer;
    nochleer:boolean;
begin
    case richtung2 of
      0 : begin
            for j:=1 to groesse2 do
            begin
              i:=1;
              repeat
                if feld2[i,j]>0 then
                begin
                  z:=i+1;
                  repeat
                    if feld2[i,j]=feld2[z,j] then
                    begin
                      feld2[i,j]:=2*feld2[i,j];
                      feld2[z,j]:=0;
                      i:=z;
                      z:=groesse+1
                    end
                    else
                    begin
                      if feld2[z,j]=0 then inc(z)
                                     else z:=groesse+1;
                    end;
                  until z>groesse;
                end;
                inc(i);
              until i>groesse;
            end;

            for j:=1 to groesse2 do
            begin
              for i:=2 to groesse do
              begin
                if feld2[i,j]<>0 then
                begin
                  z:=0;
                  while feld2[i-1-z,j]=0 do inc(z);
                  if z>0 then
                  begin
                    feld2[i-z,j]:=feld2[i,j];
                    feld2[i,j]:=0;
                  end;
                end;
              end;
            end;
          end;
      1 : begin
            for j:=1 to groesse2 do
            begin
              i:=groesse;
              repeat
                z:=i-1;
                repeat
                  if feld2[i,j]=feld2[z,j] then
                  begin
                    feld2[i,j]:=2*feld2[i,j];
                    feld2[z,j]:=0;
                    i:=z;
                    z:=0
                  end
                  else
                  begin
                    if feld2[z,j]=0 then dec(z)
                                   else z:=0;
                  end;
                until z<1;
                dec(i);
              until i<1;
            end;

            for j:=1 to groesse2 do
            begin
              for i:=groesse-1 downto 1 do
              begin
                if feld2[i,j]<>0 then
                begin
                  z:=0;
                  while feld2[i+1+z,j]=0 do inc(z);
                  if z>0 then
                  begin
                    feld2[i+z,j]:=feld2[i,j];
                    feld2[i,j]:=0;
                  end;
                end;
              end;
            end;
          end;
      2 : begin
            for j:=1 to groesse do
            begin
              i:=1;
              repeat
                z:=i+1;
                repeat
                  if feld2[j,i]=feld2[j,z] then
                  begin
                    feld2[j,i]:=2*feld2[j,i];
                    feld2[j,z]:=0;
                    i:=z;
                    z:=groesse2+1
                  end
                  else
                  begin
                    if feld2[j,z]=0 then inc(z)
                                   else z:=groesse2+1;
                  end;
                until z>groesse2;
                inc(i);
              until i>groesse2;
            end;

            for i:=1 to groesse do
            begin
              for j:=2 to groesse2 do
              begin
                if feld2[i,j]<>0 then
                begin
                  z:=0;
                  while feld2[i,j-1-z]=0 do inc(z);
                  if z>0 then
                  begin
                    feld2[i,j-z]:=feld2[i,j];
                    feld2[i,j]:=0;
                  end;
                end;
              end;
            end;
          end;
      3 : begin
            for j:=1 to groesse do
            begin
              i:=groesse2;
              repeat
                z:=i-1;
                repeat
                  if feld2[j,i]=feld2[j,z] then
                  begin
                    feld2[j,i]:=2*feld2[j,i];
                    feld2[j,z]:=0;
                    i:=z;
                    z:=0
                  end
                  else
                  begin
                    if feld2[j,z]=0 then dec(z)
                                   else z:=0;
                  end;
                until z<1;
                dec(i);
              until i<1;
            end;

            for i:=1 to groesse do
            begin
              for j:=groesse2-1 downto 1 do
              begin
                if feld2[i,j]<>0 then
                begin
                  z:=0;
                  while feld2[i,j+z+1]=0 do inc(z);
                  if z>0 then
                  begin
                    feld2[i,j+z]:=feld2[i,j];
                    feld2[i,j]:=0;
                  end;
                end;
              end;
            end;
          end;
    end;

      nochleer:=false;
      for i:=1 to groesse do
        for j:=1 to groesse2 do
          if feld2[i,j]=0 then nochleer:=true;

      if nochleer then
      begin
        i:=random(groesse);
        j:=random(groesse2);
        while feld2[i+1,j+1]>0 do
        begin
          i:=random(groesse);
          j:=random(groesse2);
        end;
          if random>0.1 then feld2[i+1,j+1]:=2
                        else feld2[i+1,j+1]:=zweiterwert;
      end;
end;
function zaehlen(r1,r2,r3,r4,r5:integer):integer;
var  i,j,s:integer;
begin
      feld2:=feld;
      testschieben(r1);
      s:=0;
      for i:=1 to groesse do
        for j:=1 to groesse2 do
          if feld2[i,j]=0 then inc(s);
      testschieben(r2);
      for i:=1 to groesse do
        for j:=1 to groesse2 do
          if feld2[i,j]=0 then inc(s);
      testschieben(r3);
      for i:=1 to groesse do
        for j:=1 to groesse2 do
          if feld2[i,j]=0 then inc(s);
      testschieben(r4);
      for i:=1 to groesse do
        for j:=1 to groesse2 do
          if feld2[i,j]=0 then inc(s);
      testschieben(r5);
      for i:=1 to groesse do
        for j:=1 to groesse2 do
          if feld2[i,j]=0 then inc(s);
      zaehlen:=s;
end;

begin
   if not testabbruch then
   begin
     testabbruch:=true;
     exit;
   end;
   button1.enabled:=false;
   button2.caption:='Abbruch';
   button1click(sender);
   testabbruch:=false;
   schritte:=0;

   repeat
     neuerichtung:=-1;
     fillchar(arichtung,sizeof(arichtung),0);

     for i:=0 to 3 do
       for j:=0 to 3 do
         for n:=0 to 3 do
           for m:=0 to 3 do
             for o:=0 to 3 do
               arichtung[i,j,n,m,o]:=zaehlen(i,j,n,m,o);

     maximum:=0;
     for i:=0 to 3 do
       for j:=0 to 3 do
         for n:=0 to 3 do
           for m:=0 to 3 do
             for o:=0 to 3 do
               begin
                 if arichtung[i,j,n,m,o]>maximum then
                 begin
                   maximum:=arichtung[i,j,n,m,o];
                   neuerichtung:=i;
                 end;
               end;

     if (neuerichtung>-1) and (maximum>0) then richtung:=neuerichtung
                                          else richtung:=random(4);
     feld2:=feld;
     auswertung(sender);

     unterschied:=0;
     for i:=1 to groesse do
       for j:=1 to groesse2 do
         if feld[i,j]<>feld2[i,j] then inc(unterschied);
     if unterschied=0 then
     begin
       richtung:=random(4);
       auswertung(sender);
     end;
     inc(schritte);
     if schritte and 31 = 0 then application.processmessages;
   until ende or geschafft or testabbruch;
   testabbruch:=true;

   button1.enabled:=true;
   button2.caption:='Suchen';
end;

procedure Tf2048.CheckBox2Click(Sender: TObject);
begin
    if checkbox2.checked then zweiterwert:=2
                         else zweiterwert:=4;
end;

procedure Tf2048.Edit2Change(Sender: TObject);
var k:string;
    code:integer;
begin
    k:=edit2.text;
    val(k,groesse2,code);
    if groesse2<3 then groesse2:=4;
    button1click(sender);
end;

procedure Tf2048.FormCreate(Sender: TObject);
begin
    groesse:=4;
    groesse2:=4;
    zweiterwert:=4;
    testabbruch:=true;
end;

end.
