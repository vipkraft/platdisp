unit sostav_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,  LazFileUtils, Forms, Controls, Graphics,
  Grids,LazUTF8, StdCtrls,StrUtils, rserver, dialogs;

type

  { TForm4 }

  TForm4 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label43: TLabel;
    StringGrid2: TStringGrid;
    ZConnection1: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; aCol, aRow: Integer;   aRect: TRect; aState: TGridDrawState);
    // Заполняем grid данными
    procedure draw_grid();
    function load_tarif():boolean; //загружаем тариф расписания
    function load_sostav(server:string):boolean;//загружаем состав расписания

    procedure Rconnect();//подключение к удаленному серверу

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form4: TForm4;
  masnum:integer;
  index_a:integer;
  rtime,rid_point,rorder,rform:string;


implementation
uses
   maindisp,platproc,menu;
 var

    mas_sostav:array of array of string;
      //mas_sostav[n,0] := id_point
      //mas_sostav[n,1] := name_locality
      //mas_sostav[n,2] := km
      //mas_sostav[n,3] := t_p
      //mas_sostav[n,4] := t_s
      //mas_sostav[n,5] := t_o
      //mas_sostav[n,6] := t_d
      //mas_sostav[n,7] := form
      //mas_sostav[n,8] := hard
      //mas_sostav[n,9]:= soft
      //mas_sostav[n,10]:= bagazh
      //mas_sostav[n,11]:= remote server
      //mas_sostav[n,12]:= point_order
       mas_sostav_size:integer=13;
       doorder,otorder,dopoint,otpoint,idshed,timedep:string;
       timemy,timeform:integer;
       arnum : array of string;
     tripdate:string;
{$R *.lfm}

{ TForm4 }


procedure TForm4.Rconnect();//подключение к удаленному серверу
 var
  str:string;
  n,ind:integer;
begin
    with form4 do
     begin
     str := Stringgrid2.Cells[0,Stringgrid2.Row];
     If (trim(str)='') or (Stringgrid2.rowcount<1) then exit;
     rid_point:= trim(copy(str,pos('[',str)+1,pos(']',str)-pos('[',str)-1));
     //проверка строчки меню
   rorder := trim(copy(Stringgrid2.Cells[0,Stringgrid2.Row],1,pos('[',Stringgrid2.Cells[0,Stringgrid2.Row])-1));
   otorder:='0';
   doorder:='0';
   ind:=-1;
   //ищем пункт в массиве состава расписания
   for n:=0 to length(mas_sostav)-1 do
   begin
     If (mas_sostav[n,0]=rid_point) and (mas_sostav[n,12]=rorder) then
     begin
       ind:=n;
       rform:=mas_sostav[n,7];
       rtime:=mas_sostav[n,5];
       break;
     end;
   end;
   If ind=-1 then
     begin
      showmessagealt('НЕ найден выбранный пункт в массиве !');
      exit;
    end;

     masnum:=masindex;

   //если выпал список состава из нескольких рейсов, ищем тот отрезок расписания, в котором выбрали удаленный сервер
   If length(arnum)>1 then
    begin
   //определяем отрезок расписания
  for n:=0 to length(mas_sostav)-1 do
   begin
   If mas_sostav[n,7]<>'1' then continue;
     If n<=ind then
      begin
        If (n=ind) and (n<(length(mas_sostav)-1)) then
          begin
            otorder:=mas_sostav[n,12];
            otpoint:=mas_sostav[n,0];
            timedep:=mas_sostav[n,5];
          end;
        If (n<ind) then
          begin
            otorder:=mas_sostav[n,12];
            otpoint:=mas_sostav[n,0];
            timedep:=mas_sostav[n,5];
          end;
      end;
     If (n>=ind) then
      begin
        If n>ind then
         begin
        doorder:=mas_sostav[n,12];
        dopoint:=mas_sostav[n,0];
        break;
         end;
        If (n=ind) and (otorder<>mas_sostav[n,12]) then
         begin
          doorder:=mas_sostav[n,12];
          dopoint:=mas_sostav[n,0];
          break;
         end;
      end;
   end;
  try
     If trim(timedep)='' then timeform:=0 else
     timeform:=strtoint(copy(timedep,1,2)+copy(timedep,4,2));
  except
    showmessagealt('ОШИБКА ПРЕОБРАЗОВАНИЯ В ЦЕЛОЕ !');
    exit;
  end;
  masnum:=-1;
  //n:=masindex;
  //showmessage(full_mas[n,1]+idshed+#13+inttostr(timemy)+inttostr(timeform)+#13+full_mas[n,3]+otpoint+#13+full_mas[n,4]+otorder+#13+full_mas[n,6]+dopoint+#13+full_mas[n,7]+doorder);
  //определяем индекс в массиве рейсов
  for n:=0 to length(full_mas)-1 do
   begin
    try
     If trim(full_mas[n,10])='' then timemy:=0 else
     timemy:=strtoint(copy(full_mas[n,10],1,2)+copy(full_mas[n,10],4,2));
  except
    showmessagealt('ОШИБКА ПРЕОБРАЗОВАНИЯ В ЦЕЛОЕ !');
    exit;
  end;
     If (full_mas[n,1]=idshed) and (timemy>=timeform) and (full_mas[n,3]=otpoint) and (full_mas[n,4]=otorder) and (full_mas[n,6]=dopoint) and (full_mas[n,7]=doorder) then
      begin
       masnum:=n;
       break;
      end;
   end;
  if masnum=-1 then
   begin
      showmessagealt('Запрашиваемый рейс НЕ НАЙДЕН в массиве !');
      exit;
    end;
   end;
  //showmessage(otorder+','+otpoint+','+doorder+','+dopoint);//$
   //определяем id удаленного id_point
  try
   sale_server:= rid_point;
  except
     showmessagealt('Ошибка преобразования кода сервера !');
     exit;
  end;
   //определяем id локального сервера
    try
   Real_Server:=strtoint(mas_otkuda[0,0]);
   except
     showmessagealt('Ошибка преобразования кода сервера !');
     exit;
     end;

  //set_server('remote');//устанавливаем настройки подключения
   end;
  // -------------------- Соединяемся с удаленным сервером ----------------------
   //If not(Connect2(form4.Zconnection1, 2)) then
    //begin
     //showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     //exit;
    //end;
    //FormR:=TFormR.create(self);
    //FormR.ShowModal;
    //FreeAndNil(FormR);

   //form4.ZReadOnlyQuery1.Close;
   //form4.ZConnection1.Disconnect;
end;


//****************************  загружаем состав расписания  ********************
function TForm4.load_sostav(server:string):boolean;
var
   n,m:integer;
   flag_atp:string='0';
   flag_i:byte=0;
   atst:byte=0;
   suffics : string;
begin
  Result := true;
  SetLength(mas_sostav,0,0);
  with form4 do
   begin
   // -------------------- Соединяемся с локальным сервером ----------------------
   If not(Connect2(Zconnection1, 2)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     exit;
    end;

   //запрашиваем все формирующиеся пункты расписания, кроме более поздних отрезков
   ZReadOnlyQuery1.SQL.Clear;
   //рассчитать по составу до нашего сервера
    ZReadOnlyQuery1.SQL.Add('SELECT * ');
   ZReadOnlyQuery1.SQL.Add(',sum(v.km) OVER (ORDER BY v.point_order RANGE UNBOUNDED PRECEDING) as calculated_km ');
   ZReadOnlyQuery1.SQL.Add(',((sum(v.t_s::interval) OVER (ORDER BY v.point_order RANGE UNBOUNDED PRECEDING)-v.t_s::interval) ');
   ZReadOnlyQuery1.SQL.Add(' +(sum(v.t_d::interval) OVER (ORDER BY v.point_order RANGE UNBOUNDED PRECEDING))) as vputi ');
   ZReadOnlyQuery1.SQL.Add(' FROM ');
   ZReadOnlyQuery1.SQL.Add('( ');
   ZReadOnlyQuery1.SQL.Add('(SELECT id_user,id_point, name, form, t_o, ''00:00'' as t_s,0 as km,''00:00'' as t_d, ');
   ZReadOnlyQuery1.SQL.Add('  t_p, point_order ');
   ZReadOnlyQuery1.SQL.Add('FROM av_shedule_sostav ');
   ZReadOnlyQuery1.SQL.Add('WHERE del=0 AND id_shedule='+idshed+' AND point_order='+full_mas[index_a,4]+' AND point_order<'+server+' ORDER BY point_order) ');
   ZReadOnlyQuery1.SQL.Add('UNION ALL ');
   ZReadOnlyQuery1.SQL.Add('(SELECT id_user,id_point, name, form, t_o, t_s, km, t_d, ');
   ZReadOnlyQuery1.SQL.Add('  t_p, point_order ');
   ZReadOnlyQuery1.SQL.Add('FROM av_shedule_sostav ');
   ZReadOnlyQuery1.SQL.Add('WHERE del=0 AND id_shedule='+idshed+' AND point_order>'+full_mas[index_a,4]+' AND point_order<'+server+' ORDER BY point_order) ');
   ZReadOnlyQuery1.SQL.Add(') v ');
   //рассчитать по составу от нашего сервера
   ZReadOnlyQuery1.SQL.Add('UNION ALL ');
   ZReadOnlyQuery1.SQL.Add('SELECT * ');
   ZReadOnlyQuery1.SQL.Add(',sum(v.km) OVER (ORDER BY v.point_order RANGE UNBOUNDED PRECEDING) as calculated_km ');
   ZReadOnlyQuery1.SQL.Add(',((sum(v.t_s::interval) OVER (ORDER BY v.point_order RANGE UNBOUNDED PRECEDING)-v.t_s::interval) ');
   ZReadOnlyQuery1.SQL.Add(' +(sum(v.t_d::interval) OVER (ORDER BY v.point_order RANGE UNBOUNDED PRECEDING))) as vputi ');
   ZReadOnlyQuery1.SQL.Add(' FROM ');
   ZReadOnlyQuery1.SQL.Add('( ');
   ZReadOnlyQuery1.SQL.Add('(SELECT id_user,id_point, name, form, t_o, ''00:00'' as t_s,0 as km,''00:00'' as t_d, ');
   ZReadOnlyQuery1.SQL.Add('  t_p, point_order ');
   ZReadOnlyQuery1.SQL.Add('FROM av_shedule_sostav ');
   ZReadOnlyQuery1.SQL.Add('WHERE del=0 AND id_shedule='+idshed+' AND point_order='+server+' ORDER BY point_order) ');
   ZReadOnlyQuery1.SQL.Add('UNION ALL ');
   ZReadOnlyQuery1.SQL.Add('(SELECT id_user,id_point, name, form, t_o, t_s, km, t_d, ');
   ZReadOnlyQuery1.SQL.Add('  t_p, point_order ');
   ZReadOnlyQuery1.SQL.Add('FROM av_shedule_sostav ');
   ZReadOnlyQuery1.SQL.Add('WHERE del=0 AND id_shedule='+idshed+' AND point_order>'+server+' AND point_order<='+full_mas[index_a,7]+' ORDER BY point_order) ');
   ZReadOnlyQuery1.SQL.Add(') v ; ');
  //showmessage(ZReadOnlyQuery1.SQL.Text);//$
   try
      ZReadOnlyQuery1.open;
   except
         showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
         ZReadOnlyQuery1.Close;
         Zconnection1.disconnect;
         Result := false;
         exit;
   end;
   for n:=1 to ZReadOnlyQuery1.RecordCount do
     begin
      SetLength(mas_sostav,length(mas_sostav)+1,mas_sostav_size);
      mas_sostav[length(mas_sostav)-1,0] := ZReadOnlyQuery1.FieldByName('id_point').asString;
      mas_sostav[length(mas_sostav)-1,1] := ZReadOnlyQuery1.FieldByName('name').asString;
      mas_sostav[length(mas_sostav)-1,2] := ZReadOnlyQuery1.FieldByName('calculated_km').asString;
      mas_sostav[length(mas_sostav)-1,3] := ZReadOnlyQuery1.FieldByName('t_p').asString;
      mas_sostav[length(mas_sostav)-1,4] := ZReadOnlyQuery1.FieldByName('t_s').asString;
      mas_sostav[length(mas_sostav)-1,5] := ZReadOnlyQuery1.FieldByName('t_o').asString;
      mas_sostav[length(mas_sostav)-1,6] := copy(ZReadOnlyQuery1.FieldByName('vputi').asString,1,5);
      mas_sostav[length(mas_sostav)-1,7] := ZReadOnlyQuery1.FieldByName('form').asString;
      mas_sostav[length(mas_sostav)-1,8] := '--';
      mas_sostav[length(mas_sostav)-1,9] := '--';
      mas_sostav[length(mas_sostav)-1,10]:= '--';
      mas_sostav[length(mas_sostav)-1,11]:= '';//признак удаленного сервера
      mas_sostav[length(mas_sostav)-1,12]:= ZReadOnlyQuery1.FieldByName('point_order').asString;
      ZReadOnlyQuery1.Next;
      end;
   //showmas(mas_sostav);
   ZReadOnlyQuery1.Close;
   Zconnection1.disconnect;

 //отмечаем типы серверов в массиве (локальный,удаленный)
        for n:=0 to length(mas_otkuda)-1 do
          begin
            for m:=0 to length(mas_sostav)-1 do
              begin
                If mas_sostav[m,0]=mas_otkuda[n,0] then
                begin
                  If mas_sostav[m,0]=sale_server then
                  mas_sostav[m,11]:='2' //локальный
                  else
                  mas_sostav[m,11]:='1'; //удаленный
                  continue;
                end;
              end;
          end;

 end;
end;


//****************************  загружаем тариф рейса  ********************
function TForm4.load_tarif():boolean; //загружаем тариф рейса
var
   n,m,nrw:integer;
   flag_atp:string='0';
   flag_i:byte=0;
   atst:byte=0;
   suffics,my_order : string;
begin
  Result:= true;
  with form4 do
   begin
   If (Stringgrid2.RowCount<2) or (trim(Stringgrid2.Cells[0,Stringgrid2.Row])='') then
    begin
     showmessagealt('Выберите остановочный пункт !');
     Result:=false;
     exit;
    end;

   // -------------------- Соединяемся с локальным сервером ----------------------
   If not(Connect2(Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     exit;
    end;

   //тип атс
   If  trim(full_mas[index_a,27])='1' then atst:=1; //М2
   If  trim(full_mas[index_a,27])='2' then atst:=2; //М3

  my_order:='';
  nrw:=-1;
  //если рейс прибытия расчет ведем сначала
  if full_mas[index_a,16]='2' then Stringgrid2.Row :=1;

  my_order:=utf8copy(Stringgrid2.Cells[0,Stringgrid2.Row],1,utf8pos('[',Stringgrid2.Cells[0,Stringgrid2.Row])-1);
    nrw:=Stringgrid2.Row;
 //ищем формирующийся до пункта, на котором стоим
  //If Stringgrid2.Cells[10,Stringgrid2.Row]='1' then
   //begin
    //my_order:=utf8copy(Stringgrid2.Cells[0,Stringgrid2.Row],1,utf8pos('[',Stringgrid2.Cells[0,Stringgrid2.Row])-1);
    //nrw:=Stringgrid2.Row;
   //end
  //else
  //begin
   //for n:= 1 to Stringgrid2.Row-1 do
     //begin
       //If Stringgrid2.Cells[10,n]='1' then
        //begin
        //my_order:=utf8copy(Stringgrid2.Cells[0,n],1,utf8pos('[',Stringgrid2.Cells[0,n])-1);
        //nrw:=n;
        //end;
     //end;
  //end;

  If (my_order='') or (nrw=-1) then
   begin
     showmessagealt('ОШИБКА ! НЕ НАЙДЕН формирующийся пункт !');
     Result:=false;
     exit;
   end;
  //showmessage(inttostr(Stringgrid2.RowCount));
    // Загружаем тарифы
   ZReadOnlyQuery1.SQL.Clear;
   ZReadOnlyQuery1.SQL.Add('select gettarif('+quotedstr('tarif')+', '+idshed+','+Quotedstr(tripdate)+','+full_mas[index_a,18]+','+my_order+');');   //full_mas[index_a,4]
   ZReadOnlyQuery1.sql.add('FETCH ALL IN tarif;');
   //showmessage(ZReadOnlyQuery1.SQL.Text);//$
   try
      ZReadOnlyQuery1.open;
    except
         showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
         ZReadOnlyQuery1.Close;
         Zconnection1.disconnect;
         Result := false;
         exit;
    end;
  If ZReadOnlyQuery1.RecordCount=0 then
    begin
      //showmessagealt('Нет данных по тарифам расписания !!!'+#13+'Обратитесь к администратору ...');
       ZReadOnlyQuery1.Close;
       Zconnection1.disconnect;
       Result:=false;
        exit;
    end;
   // Загружаем данные в грид
   Stringgrid2.Visible:=false;
  ZReadOnlyQuery1.First;
  for n:=0 to ZReadOnlyQuery1.RecordCount-1 do
   begin
     If Stringgrid2.RowCount<(nrw+n+1) then
       begin
          showmessagealt('ОШИБКА РАСЧЕТА ТАРИФА РЕЙСА !'+#13+inttostr(n));
          result:=false;
          break;
         end;

     //если используется цена багажа как процент от стоимости билета, то выводим знак процента
     suffics:='';
     If (n>0) and (atst=1) then
         begin
           If (ZReadOnlyQuery1.FieldByName('bagazh_softm2').asString<>'0')
           or (ZReadOnlyQuery1.FieldByName('bagazh_hardm2').asString<>'0') then
           begin
           If trim(ZReadOnlyQuery1.FieldByName('bag').asString)='0' then
           begin
               suffics:='%';
           end;
           end;
         end;
     If (n>0) and (atst=2) then
      begin
        If (ZReadOnlyQuery1.FieldByName('bagazh_softm3').asFloat>0)
        or (ZReadOnlyQuery1.FieldByName('bagazh_hardm3').asFloat>0) then
        If (ZReadOnlyQuery1.FieldByName('bag').asString='0') then
        begin
          suffics:='%';
        end;
      end;

      //showmessage(ZReadOnlyQuery1.FieldByName('calculated_km').asString+#13+
      //ZReadOnlyQuery1.FieldByName('bagazh_softm2').AsString+#13+
      //ZReadOnlyQuery1.FieldByName('bagazh_hardm2').AsString+#13+
      // ZReadOnlyQuery1.FieldByName('bagazh_softm3').AsString+#13+
      //ZReadOnlyQuery1.FieldByName('bagazh_hardm3').AsString+#13+
      //ZReadOnlyQuery1.FieldByName('bag').asString+#13+
      //  ZReadOnlyQuery1.FieldByName('bagazh').AsString+#13+'suffics='+suffics);

      form4.StringGrid2.Cells[3,nrw+n]:= ZReadOnlyQuery1.FieldByName('calculated_km').asString;
      form4.StringGrid2.Cells[7,nrw+n]:= ZReadOnlyQuery1.FieldByName('ssoftm2').asString; //FormatNum(IFTHEN(trim(full_mas[index_a,27])='1', ZReadOnlyQuery1.FieldByName('shardm2').asString, ZReadOnlyQuery1.FieldByName('shardm3').asString),2);
      form4.StringGrid2.Cells[8,nrw+n]:= ZReadOnlyQuery1.FieldByName('ssoftm3').asString; //FormatNum(IFTHEN(trim(full_mas[index_a,27])='1', ZReadOnlyQuery1.FieldByName('ssoftm2').asString, ZReadOnlyQuery1.FieldByName('ssoftm3').asString),2);
      form4.StringGrid2.Cells[9,nrw+n]:= ZReadOnlyQuery1.FieldByName('bagazh').asString+ suffics;
      ZReadOnlyQuery1.Next;
      end;
     Stringgrid2.Visible:=true;
   //showmas(mas_sostav);
   ZReadOnlyQuery1.Close;
   Zconnection1.disconnect;
  end;

end;


// Заполняем grid данными
procedure TForm4.draw_grid();
 var
   n,sh:integer;
begin
   form4.StringGrid2.Visible:=false;
   form4.StringGrid2.RowCount:=1;

   for n:=0 to length(mas_sostav)-1 do
     begin
       form4.StringGrid2.RowCount:=form4.StringGrid2.RowCount+1;
       form4.StringGrid2.Cells[0, form4.StringGrid2.RowCount-1] :=mas_sostav[n,12]+' ['+mas_sostav[n,0]+']';
       form4.StringGrid2.Cells[1, form4.StringGrid2.RowCount-1] :=mas_sostav[n,1];
       form4.StringGrid2.Cells[2, form4.StringGrid2.RowCount-1] :=mas_sostav[n,6];
       form4.StringGrid2.Cells[3, form4.StringGrid2.RowCount-1] :=mas_sostav[n,2];
       form4.StringGrid2.Cells[4, form4.StringGrid2.RowCount-1] :=mas_sostav[n,3];
       form4.StringGrid2.Cells[5, form4.StringGrid2.RowCount-1] :=mas_sostav[n,4];
       form4.StringGrid2.Cells[6, form4.StringGrid2.RowCount-1] :=mas_sostav[n,5];
       form4.StringGrid2.Cells[7, form4.StringGrid2.RowCount-1] :=mas_sostav[n,8];
       form4.StringGrid2.Cells[8, form4.StringGrid2.RowCount-1] :=mas_sostav[n,9];
       form4.StringGrid2.Cells[9,form4.StringGrid2.RowCount-1] :=mas_sostav[n,10]; //багаж
       form4.StringGrid2.Cells[10,form4.StringGrid2.RowCount-1] :=mas_sostav[n,7]; //признак формирующегося
       form4.StringGrid2.Cells[11,form4.StringGrid2.RowCount-1] :=mas_sostav[n,11];//признал удаленного сервера

     end;


  form4.StringGrid2.RowHeights[0]:=40;//заголовок
  sh := 33*(form4.StringGrid2.RowCount-1)+form4.StringGrid2.RowHeights[0]+10;
  If sh<440 then sh:=440;
  If sh>(768-80) then sh:=(768-80);

  form4.Height:= sh+80;
  //application.ProcessMessages;
  //form4.Invalidate;
  centrform(form4);
  //showmessagealt(inttostr(sh));
  form4.StringGrid2.Height:=sh;
  If ((sh-form4.StringGrid2.RowHeights[0]-10) div (form4.StringGrid2.RowCount-1))>55 then form4.StringGrid2.DefaultRowHeight:=55 else
  form4.StringGrid2.DefaultRowHeight:=(sh-form4.StringGrid2.RowHeights[0]-10) div (form4.StringGrid2.RowCount-1) ;
  form4.StringGrid2.RowHeights[0]:=40;//заголовок
  form4.StringGrid2.Invalidate;
  form4.StringGrid2.Visible:=true;
   form4.Label2.Caption:= inttostr(form4.Height);
   form4.Label2.Visible:=true;
end;



procedure TForm4.StringGrid2DrawCell(Sender: TObject; aCol, aRow: Integer;  aRect: TRect; aState: TGridDrawState);
 var
   n,pred,kolslow,nTop,horiz,vert,margin:integer;
   s1,s2,sFlag:string;
   m:real;
 begin
     If not form4.StringGrid2.visible or not form4.StringGrid2.enabled  then exit;

  with Sender as TStringGrid, Canvas do
   begin
   Canvas.AntialiasingMode:=amOff;
   Canvas.Font.Quality:=fqDraft;
   If (aCol>9) then exit;
 // Фон ячеек для прибытия и отправления
       if (aRow>0) then
          begin
            If (Cells[11,aRow]='1') then
                Brush.Color:=rgbtocolor(240,200,180)
             else
             Brush.Color:=rgbtocolor(224,240,247);

           FillRect(aRect);
          end;
       margin:=2;
     horiz:=0;
     vert:=0;
     horiz:=((aRect.Right-aRect.left) div 2);
     vert:=(RowHeights[aRow]) div 2;
     If horiz/vert<1 then vert:=trunc(horiz*horiz/vert);
     m:=0.75;
     while vert>28 do
     begin
       vert:=trunc(vert*m);
       m:=m+0.05;
     end;
     If vert>20 then margin:=6;
     //label3.Caption:=inttostr(horiz)+'|'+inttostr(vert);
     label3.Caption:='|'+inttostr(vert);
      if (gdSelected in aState) then
            begin
             pen.Width:=6;
             pen.Color:=clMaroon;
             MoveTo(aRect.left,aRect.bottom-2);
             LineTo(aRect.right,aRect.Bottom-2);
             MoveTo(aRect.left,aRect.top+1);
             LineTo(aRect.right,aRect.Top+1);
            end
          else
           begin
             //pen.Width:=1;
             //pen.Color:=clTeal;
             //MoveTo(aRect.left,aRect.bottom-1);
             //LineTo(aRect.right,aRect.Bottom-1);
           end;
       //// ===============================================================
       Font.Color := clBlack;
       font.height:=vert-margin;
       font.Style:=[];

       // id | order+наименование
       if (aRow>0) and (aCol<2) then
         begin
           // Формирующийся
           if (cells[10,aRow]='1') then
             begin
               font.Color:=clRed;
               font.Style:=[fsBold];
             end;
            //если локальный сервер
           If (aCol=1) and (Cells[11,aRow]='2') then
             begin
             font.Color:=clNavy;
             font.Style:=[fsBold];
             end;
           //если удаленный сервер
           If (aCol=1) and (Cells[11,aRow]='1') then
             begin
             font.Color:=clMaroon;
             font.Style:=[fsBold];
             end;
           TextOut(aRect.left+2, aRect.Top+((aRect.bottom-aRect.top) div 2)-font.height div 2 -4, cells[aCol,aRow]);

             //если удаленный сервер
           //If (aCol=1) and (Cells[11,aRow]='1') then
           //  begin
           //    font.height:=6+ vert div 3; // margin-5;
           //  TextOut(aRect.Right -canvas.TextWidth('[enter] - подключиться...')-10, aRect.bottom-5-font.height, '[enter] - подключиться...');
           //  end;
          end;
      //не отображать нули первой строки
        //время отправления
       if (aRow=1) and (aCol=6) then
         begin
           //font.height:=(vert);
           TextOut(aRect.left+horiz - (canvas.TextWidth(cells[aCol,aRow]) div 2), aRect.Top+((aRect.bottom-aRect.top) div 2)-font.height div 2, cells[aCol,aRow]);
         end;


       // Остальные
       if (aRow>1) and ((aCol>1) and (aCol<7)) then
         begin
           If (aCol=2) or (aCol=3) then font.height:=(vert);
           TextOut(aRect.left+horiz - (canvas.TextWidth(cells[aCol,aRow]) div 2), aRect.Top+((aRect.bottom-aRect.top) div 2)-font.height div 2, cells[aCol,aRow]);
         end;

       // Тариф багаж
       if (aRow>1) and (aCol=9) then
         begin
           Font.Color := clBlack;
           TextOut(aRect.left+horiz - (canvas.TextWidth(cells[aCol,aRow]) div 2), aRect.Top+((aRect.bottom-aRect.top) div 2)-font.height div 2, cells[aCol,aRow]);
         end;

       // Тариф М2
       if (aRow>1) and (aCol=8) then
         begin
           Font.Color := clBlue;
           TextOut(aRect.left+horiz - (canvas.TextWidth(cells[aCol,aRow]) div 2), aRect.Top+((aRect.bottom-aRect.top) div 2)-font.height div 2, cells[aCol,aRow]);
         end;

        // Тариф М3
        if (aRow>1) and (aCol=7) then
          begin
            Font.Color := clGreen;
            TextOut(aRect.left+horiz - (canvas.TextWidth(cells[aCol,aRow]) div 2), aRect.Top+((aRect.bottom-aRect.top) div 2)-font.height div 2, cells[aCol,aRow]);
          end;

        // Заголовок
        if (aRow=0) then
          begin
            Brush.Color:=form4.StringGrid2.Color;
            FillRect(aRect);
            Font.Color := clBlack;
            font.Style :=[fsBold];
            font.height:=12;
            s1:=trim(cells[aCol, aRow]);
            s2:='';
            pred:=0;
            kolslow:=0;
            for n:=1 to UTF8Length(s1) do
              begin
                if UTF8copy(s1,n,1)='*' then
                  begin
                   s2:=UTF8copy(s1,pred+1,n-pred-1);
                   TextOut(aRect.left+horiz -(canvas.TextWidth(s2) div 2), aRect.Top+(font.height*kolslow)+3, s2);
                   kolslow:=kolslow+1;
                   s2:='';
                   pred:=n;
                  end;
                if (n=UTF8Length(s1)) and not(UTF8copy(s1,n,1)='*') then
                  begin
                    s2:=UTF8copy(s1,pred+1,n-pred);
                    TextOut(aRect.left+horiz -(canvas.TextWidth(s2) div 2), aRect.Top+(font.Height*kolslow)+3, s2);
                  end;
                // Высота заголовка
                //if (canvas.TextHeight(cells[aCol, aRow])*kolslow+12+3)>RowHeights[aRow] then
                  //begin
                    //RowHeights[aRow]:=(canvas.TextHeight(cells[aCol, aRow])*(kolslow+1)+3);
                  //end;
              end;
          end;
    end;
end;


//****************************  ВОЗНИКНОВЕНИЕ ФОРМЫ ***********************************************        /
procedure TForm4.FormShow(Sender: TObject);
var
 n,m:integer;
begin
  // Позиция
  form4.Left:=form1.left+(form1.width div 2)-(form4.Width div 2);
  form4.Top:=form1.top+(form1.Height div 2)-(form4.Height div 2);

  index_a:=-1;
  // Нижняя строка заголовка
  index_a:=masindex;
  // ------------------------- Находим рейс в массиве ----------------------------
  if index_a=-1 then
   begin
     showmessagealt('Нет данных о текущем рейсе !'+#13+'Проверьте параметры маршрутной сети...');
     form4.Close;
     exit;
   end;
  idshed:=full_mas[index_a,1];

 tripdate:=datetostr(work_date);
 //проверка на удаленный рейс
 If (full_mas[index_a,0]='3') or (full_mas[index_a,0]='4') or (full_mas[index_a,0]='5') then tripdate:=full_mas[index_a,11];

  //If (trim(full_mas[idx,22])='') or (full_mas[idx,22]='0') then
  // begin
  //   showmessagealt('Данный рейс не активен !');
  //   form4.Close;
  //   exit;
  // end;
  //showmessage('idshedule '+full_mas[index_a,1]+#13+'ot_p/ot_order '+full_mas[index_a,3]+'/'+full_mas[index_a,4]+#13+'do_p/do_order '+full_mas[index_a,6]+'/'+full_mas[index_a,7]
  //+#13+'form '+full_mas[index_a,9]+#13+'namp '+full_mas[index_a,16]+#13+'t_o/t_p '+full_mas[index_a,10]+'/'+full_mas[index_a,12]);//$
  form4.Label1.Caption:='['+idshed+'] '+trim(full_mas[index_a,5])+' - '+trim(full_mas[index_a,8])+'    на '+tripdate;

  form1.paintmess(form4.StringGrid2,'ЗАГРУЗКА ДАННЫХ ! ПОДОЖДИТЕ...',clBlue);
  // Выводим ПАНЕЛЬ на экран
  //if get_data() then
  if not load_sostav(full_mas[index_a,46]) then
     begin
       form4.close;
       exit;
     end;

   form4.StringGrid2.RowCount:=1;
   form4.StringGrid2.ColCount:=12;
   //Заголовки
   form4.StringGrid2.Cells[0,0]  :='№*ост.п';
   form4.StringGrid2.Cells[1,0]  :='Наименование*остановочного*пункта';
   form4.StringGrid2.Cells[2,0]  :='Время*в пути*(чч:мм)';
   form4.StringGrid2.Cells[3,0]  :='Путь*(км)';
   form4.StringGrid2.Cells[4,0]  :='Время*прибытия*(чч:мм)';
   form4.StringGrid2.Cells[5,0]  :='Стоянка*(чч:мм)';
   form4.StringGrid2.Cells[6,0]  :='Время*отправ-я*(чч:мм)';
   form4.StringGrid2.Cells[7,0]  :='Тариф*М2 (руб)';
   form4.StringGrid2.Cells[8,0]  :='Тариф*M3 (руб)';
   form4.StringGrid2.Cells[9,0]  :='Тариф*багаж*(руб / %)';
  //Размер колонок GRID
  form4.StringGrid2.ColWidths[0] := 80;
  form4.StringGrid2.ColWidths[1] := 230;
  form4.StringGrid2.ColWidths[2] := 70;
  form4.StringGrid2.ColWidths[3] := 90;
  form4.StringGrid2.ColWidths[4] := 80;
  form4.StringGrid2.ColWidths[5] := 65;
  form4.StringGrid2.ColWidths[6] := 90;
  form4.StringGrid2.ColWidths[7] := 100;
  form4.StringGrid2.ColWidths[8] := 100;
  form4.StringGrid2.ColWidths[9] := 80;
  form4.StringGrid2.ColWidths[10] := 0;
  form4.StringGrid2.ColWidths[11] := 0;


  // Выводим информацию на GRID
   draw_grid();

   //Если рейс отправления - ищем сервер в списке и становимся на него
   if full_mas[index_a,16]='1' then
   begin
   for n:=1 to form4.StringGrid2.RowCount-1 do
     begin
      IF trim(utf8copy(form4.StringGrid2.Cells[0,n],1,utf8pos(' [',form4.StringGrid2.Cells[0,n])))=trim(full_mas[index_a,46]) then
       begin
       form4.StringGrid2.Row:=n;
       break;
       end;
     end;
   end
   else
     form4.StringGrid2.Row :=1;

    //Если пунктов немного, сразу считаем тариф
  If length(mas_sostav)<6 then load_tarif();

  //form4.Label1.Caption:= timetostr(time-t1);
end;


procedure TForm4.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState );
var
 rr:integer;
begin
     // ESC
   if (Key=27) then
     begin
        form4.StringGrid2.Visible:=false;
         form4.Close;
         key:=0;
     end;
  //F5  //загрузить тариф
  If (key=116) then
    begin
      key:=0;
      form1.paintmess(form4.StringGrid2,'ЗАГРУЗКА ТАРИФА ...',clBlue);
      rr:=form4.StringGrid2.row;
      //showmessage(trim(utf8copy(form4.StringGrid2.Cells[0,rr],1,utf8pos(' [',form4.StringGrid2.Cells[0,rr]))));
      If not load_sostav(trim(utf8copy(form4.StringGrid2.Cells[0,rr],1,utf8pos(' [',form4.StringGrid2.Cells[0,rr])))) then exit;
      draw_grid();
      form4.StringGrid2.Row:=rr;
      load_tarif();
      exit;
      end;
  // ENTER - выбор пунтка меню
  //IF (Key=13) then
  // begin
  //   If form4.StringGrid2.Cells[11,form4.StringGrid2.row]='1' then
  //    Rconnect();//подключение к удаленному серверу
  //    //сбрасываем настройки локального сервера и подключения к нему
  //    sale_server:=ConnectINI[14];
  //    set_server('local');
  //    key:=0;
  //    exit;
  //  end;
end;

procedure TForm4.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  setlength(arnum,0);
   arnum:=nil;
 setlength(mas_sostav,0,0);
 mas_sostav:=nil;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;


procedure TForm4.FormPaint(Sender: TObject);
begin
 with form4 do
  begin
   Canvas.Brush.Color:=clSilver;
   Canvas.Pen.Color:=clBlack;
   Canvas.Pen.Width:=2;
   Canvas.Rectangle(2,2,Width-2,Height-2);
  end;
end;

end.

