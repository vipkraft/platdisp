unit rserver;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZDataset, ZConnection,  LazFileUtils, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Grids, LazUTF8, strutils;

type

  { TFormR }

  TFormR = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    StringGrid2: TStringGrid;
    ZConnection2: TZConnection;
    ZReadOnlyQuery2: TZReadOnlyQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure StringGrid2SelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
    procedure zagruzka_mest; //ЗАГРУЖАЕМ В МАССИВ МЕСТА АТС
    procedure fill_grid; //заполнить грид номерами мест
    procedure get_info;  // Обновляем информацию о месте
    procedure change_layer;// Смена этажа
    procedure fill_mas_seats;// Заполняем массив с местами в атобусе
    procedure load_trip; //ЗАБИРАЕМ ДАННЫЕ С УДАЛЕННОГО СЕРВЕРА
    procedure vedom_remote;//просмотр и печать ведомости с удаленного сервера
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormR: TFormR;

implementation

{$R *.lfm}

uses
  platproc,maindisp,sostav_main;

var
   tstatus,tetaz,tats_type:integer;
   tek_id_ats,tek_type_rejs,tname,ttime,tdate,tremark,tats,tatp,tdriver1,tdriver2,tdriver3,tdriver4,tputevka,ats_mest,tid_atp:string;
   mesta:array of array of array of string;
   idx:integer=-1;

{ TFormR }

//просмотр и печать ведомости с удаленного сервера
procedure TFormR.vedom_remote;
var
   m,sit,k,n:integer;
   t1:string;
begin
 Setlength(vedom_mas,0,0);
SetLength(Vedom_mas,length(vedom_mas)+1,vedom_size);
       vedom_mas[length(vedom_mas)-1,1] := full_mas[idx,1];    // [n,1]  - id_shedule
       vedom_mas[length(vedom_mas)-1,2] := FormatDateTime('dd/mm/yyyy',work_date); // [n,2]  - date_trip
       vedom_mas[length(vedom_mas)-1,3] := rid_point;    // [n,3]  - ot_id_point
       vedom_mas[length(vedom_mas)-1,4] := rorder;  // [n,4]  - ot_order
       vedom_mas[length(vedom_mas)-1,5] := full_mas[idx,5];   // [n,5]  - ot_name
       vedom_mas[length(vedom_mas)-1,6] := full_mas[idx,6];   // [n,6]  - do_id_point
       vedom_mas[length(vedom_mas)-1,7] := full_mas[idx,7];   // [n,7]  - do_order
       vedom_mas[length(vedom_mas)-1,8] := full_mas[idx,8];   // [n,8]  - do_name
       vedom_mas[length(vedom_mas)-1,9] := Formatdatetime('yyyymmdd', work_date)+copy(rtime,1,2)+copy(rtime,4,2)+
          PadL(rorder,'0',2) +PadL(full_mas[idx,7],'0',2)+full_mas[idx,1]+'-'+ConnectIni[14];  // [n,9]  - vedom
       vedom_mas[length(vedom_mas)-1,10] := rtime;   // [n,10] - t_o
       vedom_mas[length(vedom_mas)-1,11] := FormatDateTime('hhnnss',time()); // [n,11] - t_o_fact
       vedom_mas[length(vedom_mas)-1,12] := FormatDateTime('dd/mm/yyyy',date()); // [n,12] - createdate
       vedom_mas[length(vedom_mas)-1,13] := tputevka;  // [n,13] - putevka
       vedom_mas[length(vedom_mas)-1,14] := tdriver1;  // [n,14] - driver1
       vedom_mas[length(vedom_mas)-1,15] := tdriver2;   // [n,15] - driver2
       vedom_mas[length(vedom_mas)-1,16] := tdriver3;   // [n,16] - driver3
       vedom_mas[length(vedom_mas)-1,17] := tdriver4;   // [n,17] - driver4
       vedom_mas[length(vedom_mas)-1,18] := tid_atp;  // [n,18] - kontr_id
       vedom_mas[length(vedom_mas)-1,19] := tatp;  // [n,19] - kontr_name
       vedom_mas[length(vedom_mas)-1,20] := tek_id_ats;   // [n,20] - ats_id
       vedom_mas[length(vedom_mas)-1,21] := tats;  // [n,21] - ats_name
       vedom_mas[length(vedom_mas)-1,22] := ats_mest;   // [n,22] - ats_seats
       vedom_mas[length(vedom_mas)-1,23] := tats; // [n,23] - ats_reg
       vedom_mas[length(vedom_mas)-1,24] := inttostr(tats_type);   // [n,27] - ats_type
       vedom_mas[length(vedom_mas)-1,25] := '';   // [n,29] - doobil
       vedom_mas[length(vedom_mas)-1,26] := inttostr(id_user);   // [n,31] - id_user   //
       vedom_mas[length(vedom_mas)-1,27] := name_user_active;  // [n,32] - name   //пользователь совершивший операцию
       //with form4 do
       begin
    //заполнить массив билетов данного рейса

 If not form4.Zconnection1.Connected then
 begin
   showmessagealt('ОТСУТСТВУЕТ СОЕДИНЕНИЕ С УДАЛЕННЫМ СЕРВЕРОМ !');
   exit;
 end;


 form4.ZReadOnlyQuery1.SQL.Clear;


 form4.ZReadOnlyQuery1.SQL.Add('SELECT COALESCE(agr.count,0) bags,COALESCE(agr.sum,0) bags_sum ');
 form4.ZReadOnlyQuery1.SQL.Add(',CASE WHEN position(''[u3]'' in a.uslugi_text)>0 THEN cast(split_part(a.uslugi_text,''|'',2) as numeric) ELSE 0 END as strah_sbor_nal ');
 form4.ZReadOnlyQuery1.SQL.Add(',CASE WHEN position(''[u4]'' in a.uslugi_text)>0 THEN cast(split_part(a.uslugi_text,''|'',2) as numeric) ELSE 0 END as strah_sbor_credit ');
 form4.ZReadOnlyQuery1.SQL.Add(',CASE WHEN position(''[u5]'' in a.uslugi_text)>0 THEN cast(split_part(a.uslugi_text,''|'',5) as numeric) ELSE 0 END as kom_sbor ');
 form4.ZReadOnlyQuery1.SQL.Add(',b.name,a.* FROM av_ticket a ');
 form4.ZReadOnlyQuery1.SQL.Add('LEFT JOIN (SELECT ticket_num, SUM(sum_cash), COUNT(*) FROM av_ticket c ');
 form4.ZReadOnlyQuery1.SQL.Add('WHERE c.type_ticket=2 AND c.type_oper=1 AND c.bagage_num<>'''' GROUP BY c.ticket_num ');
 form4.ZReadOnlyQuery1.SQL.Add(') agr ON agr.ticket_num=a.ticket_num ');
 form4.ZReadOnlyQuery1.SQL.Add(' LEFT JOIN av_spr_point b ON b.del=0 AND a.id_do=b.id ');
 form4.ZReadOnlyQuery1.SQL.Add(' WHERE a.trip_date='+Quotedstr(datetostr(work_date)));
 form4.ZReadOnlyQuery1.SQL.Add(' AND a.id_shedule='+full_mas[idx,1]);
 form4.ZReadOnlyQuery1.SQL.Add(' AND a.trip_time='+QuotedStr(rtime));
 form4.ZReadOnlyQuery1.SQL.Add(' AND a.type_oper=1 AND a.type_ticket=1 AND a.unused=0 AND a.ticket_num<>'''' ORDER BY a.mesto; ');

  //showmessage(ZReadOnlyQuery2.SQL.text);
   try
    form4.ZReadOnlyQuery1.open;
   except
     showmessage('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+form4.ZReadOnlyQuery1.SQL.Text);
     exit;
   end;
  Setlength(tick_mas,0,0);
  If form4.ZReadOnlyQuery1.RecordCount>0 then
    begin
     //заполняем массив билетов
    for m:=0 to form4.ZReadOnlyQuery1.RecordCount-1 do
     begin
     ///если нет номер билета, значит билет- пустышка
       If trim(form4.ZReadOnlyQuery1.FieldByName('ticket_num').AsString)='' then continue;
       Setlength(tick_mas,length(tick_mas)+1,tick_size);
       tick_mas[length(tick_mas)-1,0] :=form4.ZReadOnlyQuery1.FieldByName('mesto').AsString; //mesto
       tick_mas[length(tick_mas)-1,1] :=form4.ZReadOnlyQuery1.FieldByName('ticket_num').AsString; //ticket_num
       tick_mas[length(tick_mas)-1,2] := FormatDateTime('yyyymmdd',form4.ZReadOnlyQuery1.FieldByName('createdate').AsDateTime);    // createdate date
       tick_mas[length(tick_mas)-1,3] := FormatDateTime('hhnn',form4.ZReadOnlyQuery1.FieldByName('createdate').AsDateTime);    //createdate time
       tick_mas[length(tick_mas)-1,4] := ''; //билеты требуемой ведомости
       tick_mas[length(tick_mas)-1,5] :=form4.ZReadOnlyQuery1.FieldByName('type_full_half').AsString; //type_full_half  - Тип Полный Детский
       tick_mas[length(tick_mas)-1,6] :=form4.ZReadOnlyQuery1.FieldByName('type_norm_lgot_war').AsString; //type_norm_lgot_war - Тип Обычный Льготный Воинский
       tick_mas[length(tick_mas)-1,7] :=form4.ZReadOnlyQuery1.FieldByName('name').AsString; //name - Пункт назначения
       tick_mas[length(tick_mas)-1,8] :=form4.ZReadOnlyQuery1.FieldByName('lgot_sum').AsString; //lgot_sum
       tick_mas[length(tick_mas)-1,9] :=form4.ZReadOnlyQuery1.FieldByName('sum_credit').AsString; //sum_credit
       tick_mas[length(tick_mas)-1,10] :=form4.ZReadOnlyQuery1.FieldByName('tarif_calculated').AsString; //sum_cash
       tick_mas[length(tick_mas)-1,11] :=form4.ZReadOnlyQuery1.FieldByName('fio').AsString;
       tick_mas[length(tick_mas)-1,12] :=form4.ZReadOnlyQuery1.FieldByName('doctype').AsString;
       tick_mas[length(tick_mas)-1,13] :=form4.ZReadOnlyQuery1.FieldByName('doc').AsString;
       tick_mas[length(tick_mas)-1,14] :=form4.ZReadOnlyQuery1.FieldByName('bags').AsString;
       tick_mas[length(tick_mas)-1,15] :=form4.ZReadOnlyQuery1.FieldByName('bags_sum').AsString;
       tick_mas[length(tick_mas)-1,16] := '';//аббревиатура типа билета
       tick_mas[length(tick_mas)-1,17] :=form4.ZReadOnlyQuery1.FieldByName('strah_sbor_nal').AsString;
       tick_mas[length(tick_mas)-1,18] :=form4.ZReadOnlyQuery1.FieldByName('strah_sbor_credit').AsString;
       tick_mas[length(tick_mas)-1,19] :=form4.ZReadOnlyQuery1.FieldByName('kom_sbor').AsString;
       tick_mas[length(tick_mas)-1,20] := form4.ZReadOnlyQuery1.FieldByName('name_otkuda').AsString;
       tick_mas[length(tick_mas)-1,21] := '0';
        //Тип Полный Детский
       case form4.ZReadOnlyQuery1.FieldByName('type_full_half').AsInteger of
       1: tick_mas[length(tick_mas)-1,16]:= 'П';
       2: tick_mas[length(tick_mas)-1,16]:= 'Д';
       end;
       case form4.ZReadOnlyQuery1.FieldByName('type_norm_lgot_war').AsInteger of
       2: tick_mas[length(tick_mas)-1,16]:= tick_mas[length(tick_mas)-1,16] + 'Л';   //Если льготный
       3: tick_mas[length(tick_mas)-1,16]:= tick_mas[length(tick_mas)-1,16] + 'В';   //Если воинский
       end;
      form4.ZReadOnlyQuery1.Next;
     end;
     end;
   //========================= кол-во транзитных мест //
   sit:=0;
   If trim(full_mas[idx,9])='0' then
     begin
        form4.ZReadOnlyQuery1.sql.Clear;
        form4.ZReadOnlyQuery1.sql.add('select * from get_seats_status('+quotedstr(datetostr(work_date))+','+sale_server+','+full_mas[idx,6]+','+full_mas[idx,18]+',');
        form4.ZReadOnlyQuery1.sql.add(full_mas[idx,1]+','+quotedstr(full_mas[idx,10])+','+full_mas[idx,20]+','+full_mas[idx,9]);
        form4.ZReadOnlyQuery1.sql.add(','+full_mas[idx,46]+','+full_mas[idx,7]+',1) as free;');
 //showmessage(ZReadOnlyQuery1.sql.Text);//$
 try
     form4.ZReadOnlyQuery1.open;
 except
     showmessagealt('ОШИБКА ЗАПРОСА !'+#13+'Команда: '+form4.ZReadOnlyQuery1.SQL.Text);
     form4.ZReadOnlyQuery1.Close;
     form4.Zconnection1.disconnect;
     exit;
 end;

 if form4.ZReadOnlyQuery1.RecordCount>0 then
       begin
       m:=1;
       k:=1;
          for n:=1 to utf8Length(form4.ZReadOnlyQuery1.FieldByName('free').asString) do
     begin
      // k - 1 номер места
      // k - 2 статус
      // m - текущее начало вырезки
      if UTF8Copy(form4.ZReadOnlyQuery1.FieldByName('free').asString,n,1)='|' then
         begin
           t1:=UTF8Copy(form4.ZReadOnlyQuery1.FieldByName('free').asString,m,(n-m));
           m:=n+1;
           if k=1 then
              begin
               k:=3;
              end;
           if k=2 then
              begin
               //SetLength(mas_s,Length(mas_s)+1,2);
               //статус места
               If t1='9' then sit:=sit+1;
               k:=1;
              end;
           if k=3 then k:=2;
         end;
      end;
      end;
     //for n:=low(tick_mas) to high(tick_mas) do
     // begin
     //   tick_mas[n,21]:=inttostr(sit);//кол-во транзитов
     // end;
    end;

  end;
 //showmas(tick_mas);
 // сразу печать
 form1.Vedom_print(0,idx); //вывод ведомости
end;



// Обновляем информацию о месте
procedure TformR.get_info;
var
   n,m:integer;
begin
 // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
 // mesta[n,m,1] - номер места
 // mesta[n,m,2] - статус места
   //0-свободно
   //1-броня ОПП
   //3-броня диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-броня справки
   //8-вычеркнутый билет
   //9-транзит
      // mesto
      Label25.caption:='';
      // sost
      Label26.caption:='';
       // prim
      Label27.caption:='';
      // data
      Label28.caption:='';
      // fio
      Label29.caption:='';
     n:=StringGrid2.Col+((strtoint(label4.Caption)-1)*25); //место
     m:=4-StringGrid2.Row; //ряд

  // если места нет
  if trim(mesta[n,m,1])='0' then exit;

  // mesto
  Label25.caption:=trim(mesta[n,m,1]);

    // БРОНЯ ОПП
  if (trim(mesta[n,m,2])='1') then
     begin
      // sost
      Label26.caption:='ЗАБРОНИРОВАНО ОПП';
      // prim
      Label27.caption:='';
      // data
      Label28.caption:=trim(mesta[n,m,5]);
      // fio
      Label29.caption:=trim(mesta[n,m,4]);
      exit;
     end;

  // БРОНЯ ДИСПЕТЧЕР
  if (trim(mesta[n,m,2])='3') then
     begin
      // sost
      Label26.caption:='БРОНЬ ДИСПЕТЧЕР';
      // prim
      Label27.caption:=trim(mesta[n,m,3]);
      // data
      Label28.caption:=trim(mesta[n,m,5]);
      // fio
      Label29.caption:=trim(mesta[n,m,4]);
      exit;
     end;

    // Вычеркнутый билет
  if (trim(mesta[n,m,2])='8') then
     begin
      // sost
      Label26.caption:='ВЫЧЕРКНУТЫЙ БИЛЕТ';
      // prim
      Label27.caption:=trim(mesta[n,m,3]);
      // data
      Label28.caption:=trim(mesta[n,m,5]);
      // fio
      Label29.caption:=trim(mesta[n,m,4]);
      exit;
     end;

   // Место свободно
  case trim(mesta[n,m,2]) of
      '0' : Label26.caption:='СВОБОДНО';    // sost
      '4' : Label26.caption:='МЕСТО В ПРОДАЖЕ';
      '5' : Label26.caption:='МЕСТО ПРОДАНО';
      '7' : Label26.caption:='ЗАБРОНИРОВАНО СПРАВКА';
      '8' : Label26.caption:='ВЫЧЕРКНУТО';
      '9' : Label26.caption:='ТРАНЗИТ';
      else
        exit;
    end;
end;

//********************************************** Смена этажа     *********************************
procedure TFormR.change_layer();
begin
  if (trim(label4.caption)='1') and (trim(label13.caption)='2') then
     begin
       label4.caption:='2';
       fill_grid;
     end;
  if (trim(label4.caption)='2') then
     begin
       label4.caption:='1';
       fill_grid;
     end;
end;

//******************************** заполнить грид номерами мест ********************************
procedure TFORMR.fill_grid;
 var
   n,m,k:integer;
begin
  with formR do
  begin
    Stringgrid2.Visible:=false;

 if trim(label4.Caption)='1' then k:=0 else k:=25;
 for n:=0 to 24 do
   begin
     for m:=0 to 4 do
      begin
        try
        // Номер места
        if not(strtoint(mesta[n+k,m,1])=0) then
        begin
           StringGrid2.Cells[n,4-m]:=inttostr(strtoint(mesta[n+k,m,1]));
        end;
        except
          continue;
        end;
      end;
   end;
  Stringgrid2.Visible:=true;
   FormR.StringGrid2.SetFocus;
  end;
end;


// Заполняем массив статусов мест
procedure TFormR.fill_mas_seats;
  var
   n,m,k:integer;
   t1,t2,t3:string;
   mas_s:array of array of string;
 begin
 // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
 // mesta[n,m,1] - номер места
 // mesta[n,m,2] - статус места
  //0-свободно
   //1-броня ОПП
   //3-броня диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-броня справки
   //8-вычеркнутый билет
   //9-транзит

  // mesta[n,m,3] - id диспетчера
  // mesta[n,m,4] - имя диспетчера
  // mesta[n,m,5] - дата операции

  with form4 do
  begin
 // -------------------- Соединяемся с локальным сервером ----------------------
 If not(Connect2(Zconnection1, 1)) then
  begin
   showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
   exit;
  end;

 //========================= Состояние мест по рейсу =============================//
 ZReadOnlyQuery2.sql.Clear;
 ZReadOnlyQuery2.sql.add('select * from get_seats_status('+quotedstr(datetostr(work_date))+','+sale_server+','+full_mas[idx,6]+','+full_mas[idx,18]+',');
 ZReadOnlyQuery2.sql.add(full_mas[idx,1]+','+quotedstr(full_mas[idx,10])+','+full_mas[idx,20]+','+full_mas[idx,9]);
 ZReadOnlyQuery2.sql.add(','+full_mas[idx,46]+','+full_mas[idx,7]+',1) as free;');
 //showmessage(ZReadOnlyQuery2.sql.Text);//&
 try
     ZReadOnlyQuery2.open;
 except
     showmessagealt('Нет соединения с сервером !!!'+#13+'Обратитесь к администратору или попробуйте снова !!!');
     ZReadOnlyQuery2.Close;
     Zconnection1.disconnect;
     exit;
 end;
 // Если нет рейсов
 if ZReadOnlyQuery2.RecordCount=0 then
    begin
      showmessagealt('Нет соединения с сервером !!!'+#13+'Обратитесь к администратору или попробуйте снова !!!');
      ZReadOnlyQuery2.Close;
      Zconnection1.disconnect;
      exit;
    end;

  // Расставляем статусы мест
  SetLength(mas_s,0,0);

  // Заполняем временный массив статусов мест
  m:=1;
  k:=1;
  for n:=1 to utf8Length(ZReadOnlyQuery2.FieldByName('free').asString) do
    begin
      // k - 1 номер места
      // k - 2 статус
      // m - текущее начало вырезки
      if UTF8Copy(ZReadOnlyQuery2.FieldByName('free').asString,n,1)='|' then
         begin
           t1:=UTF8Copy(ZReadOnlyQuery2.FieldByName('free').asString,m,(n-m));
           m:=n+1;
           if k=1 then
              begin
                //номер места
               SetLength(mas_s,Length(mas_s)+1,2);
               mas_s[Length(mas_s)-1,1]:=PadL(t1,'0',3);
               k:=3;
              end;
           if k=2 then
              begin
               //SetLength(mas_s,Length(mas_s)+1,2);
               //статус места
               mas_s[Length(mas_s)-1,0]:=t1;
               k:=1;
              end;

           if k=3 then k:=2;
         end;
    end;
  //showmas(mas_s);
  //for m:=0 to length(mesta)-1 do
  for m:=0 to 49 do
   begin
    //for n:=0 to length(mesta[0])-1 do
    for n:=0 to 4 do
      begin
        for k:=0 to length(mas_s)-1 do
          begin
            // Если номера мест совпадают, ставим Статус места
            if mas_s[k,1]=mesta[m,n,1] then
                mesta[m,n,2]:=mas_s[k,0];
          end;
      end;
   end;
   //t1:='';
   //for n:=0 to length(mas_s)-1 do
   //  begin
   //    t1:=t1+mas_s[n,1]+'-'+mas_s[n,0]+'|';
   //  end;
   //showmessage(t1);
   ZReadOnlyQuery2.Close;
   Zconnection1.disconnect;
  end;
 end;


//*************************************** ЗАГРУЖАЕМ В МАССИВ МЕСТА АТС ***************************************
procedure TFormR.zagruzka_mest;
 var
   n,m,k:integer;
  begin
  // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
  // mesta[n,m,1] - номер места
  // mesta[n,m,2] - статус места
   //0-свободно
   //1-броня ОПП
   //2-броня справки
   //3-броня диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-вычеркнутый билет
   //9-транзит
  // mesta[n,m,3] - id диспетчера
  // mesta[n,m,4] - имя диспетчера
  // mesta[n,m,5] - дата операции
  with FOrmR do
  begin
   // Подключаемся к серверу
    If not(Connect2(ZConnection2, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     close;
    end;

   //запрос списка мест из av_str_ats
   ZReadOnlyQuery2.SQL.Clear;
   ZReadOnlyQuery2.SQL.add('SELECT (one_one||one_two||one_three||one_four||one_five) as etag1, ');
   ZReadOnlyQuery2.SQL.add('(two_one||two_two||two_three||two_four||two_five) as etag2,level,m_down+m_up+m_lay+m_down_two+m_up_two+m_lay_two as mest ');
   ZReadOnlyQuery2.SQL.add('FROM av_spr_ats where id='+tek_id_ats+' and del=0;');
   //showmessage(ZReadOnlyQuery2.SQL.Text);//$
    try
      ZReadOnlyQuery2.open;
     except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
       ZReadOnlyQuery2.Close;
       ZConnection2.disconnect;
       exit;
     end;
   if ZReadOnlyQuery2.RecordCount=0 then
     begin
      showmessagealt('Не определены места для данного АТС !!!'+#13+'Обратитесь к АДМИНИСТРАТОРУ !!!');
      ZReadOnlyQuery2.Close;
      ZConnection2.disconnect;
      exit;
     end;

   // Проставляем количество этажей
   Label13.caption:=ZReadOnlyQuery2.FieldByName('level').asString;
   ats_mest:=ZReadOnlyQuery2.FieldByName('mest').asString;
   FormR.Label31.Caption:=ats_mest+'/ ';
   // Создаем массив и разбираем места кроме стоя
   SetLength(mesta,0,0,0);
   SetLength(mesta,50,5,6);
   for n:=0 to 1 do     // Этаж
     begin
       for m:=0 to 4 do  // Ряд
         begin
           for k:=0 to 24 do   // Место
             begin
               // Тип места
               //1 - сидя 3 - лежа
               mesta[k+(n*25),m,0]:=Copy(ifthen(n=0,ZReadOnlyQuery2.FieldByName('etag1').asString, ZReadOnlyQuery2.FieldByName('etag2').asString),(k*4+1)+(m*100),1);
               // Номер места
               mesta[k+(n*25),m,1]:=Copy(ifthen(n=0,ZReadOnlyQuery2.FieldByName('etag1').asString, ZReadOnlyQuery2.FieldByName('etag2').asString),(k*4+1)+(m*100)+1,3);
               //showmessage(mesta[k+(n*25),m,1]);
               // Убираем места стоя
               //if mesta[k+(n*25),m,0]='2' then
               //  begin
               //    mesta[k+(n*25),m,0]:='0';
               //    mesta[k+(n*25),m,1]:='0';
               //  end;
               // Ставим все для транзита бронированными по умолчанию
               if not(trim(mesta[k+(n*25),m,0])='0') and (trim(tek_type_rejs)='0') then
                 begin
                   mesta[k+(n*25),m,2]:='9';
                 end
               else
                mesta[k+(n*25),m,2]:='0'; //сбрасываем состояние места
             end;
         end;
     end;
  ZReadOnlyQuery2.Close;
  ZConnection2.Disconnect;
  end;
end;


//*******************************************************  ЗАБИРАЕМ ДАННЫЕ С УДАЛЕННОГО СЕРВЕРА ******************************************************************
procedure TFormR.load_trip();
var
  n,m,tn,tm:integer;
  lg:boolean;
begin
// ТИП РЕЙСА
   tek_type_rejs:=trim(full_mas[idx,9]);
   IF (trim(full_mas[idx,0])='3') or (trim(full_mas[idx,0])='4') THEN
   begin
    tek_type_rejs:='3';
   end;
 If not form4.Zconnection1.Connected then
 begin
   showmessagealt('ОТСУТСТВУЕТ СОЕДИНЕНИЕ С УДАЛЕННЫМ СЕРВЕРОМ !');
   exit;
 end;
  form1.paintmess(formR.StringGrid2,'ЗАГРУЗКА ДАННЫХ ! ПОДОЖДИТЕ...',clBlue);
  with Form4 do
  begin


 //*********************** запрос к расписаниям av_trip **************************************************
 ZReadOnlyQuery2.SQL.Clear;
 ZReadOnlyQuery2.SQL.Add('SELECT * from shedule_current_status(''ished'','+Quotedstr(datetostr(work_date))+','+full_mas[idx,1]+','+inttostr(id_user)+');');
 ZReadOnlyQuery2.SQL.Add('Fetch all in ished;');
 //showmessage(ZReadOnlyQuery2.SQL.Text);//$
  try
     ZReadOnlyQuery2.open;
   except
         showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
         //ZReadOnlyQuery2.Close;
         //ZConnection2.disconnect;
         FormR.Close;
         exit;
   end;

  If ZReadOnlyQuery2.RecordCount=0 then
      begin
        showmessagealt('Нет данных по рейсу на сервере: '+form4.StringGrid2.Cells[1,form4.StringGrid2.row]);
        FormR.Close;
        exit;
      end;
  lg:=true;
  for n:=1 to ZReadOnlyQuery2.RecordCount do
    begin
      If (ZReadOnlyQuery2.FieldByName('ot_order').AsString=full_mas[idx,4]) and (ZReadOnlyQuery2.FieldByName('do_order').AsString=full_mas[idx,7]) then
          begin
            FormR.Label42.Caption:=form4.StringGrid2.Cells[1,form4.StringGrid2.row];//наименование сервера
            FormR.Label41.Caption:='['+trim(full_mas[idx,1])+']  '+trim(full_mas[idx,5])+' - '+trim(full_mas[idx,8]);//рейс
            FormR.Label46.Caption:=rtime;//время отправления
            FormR.Label49.Caption:=datetostr(work_date);//дата отправления
            lg:=false;
            break;
          end;
      ZReadOnlyQuery2.Next;
    end;
  If lg then
      begin
        showmessagealt('Нет данных по рейсу №'+full_mas[idx,1]+'['+full_mas[idx,4]+'-'+full_mas[idx,7]+']'+#13+' на удаленном сервере: '+form4.StringGrid2.Cells[1,form4.StringGrid2.row]);
        FormR.Close;
        exit;
        end;

 //************************  запрос к диспетчерским операциям
 // Запрос к av_disp_oper
        ZReadOnlyQuery2.SQL.Clear;
        ZReadOnlyQuery2.SQL.Add('SELECT a.trip_date,a.vid_sriva,a.remark,a.avto_type,a.avto_seats,a.avto_name,a.atp_name,');
        ZReadOnlyQuery2.SQL.Add('a.driver4,a.driver3,a.driver2,a.driver1,a.trip_flag,a.putevka,a.platform,a.avto_id,a.trip_id_point,');
        ZReadOnlyQuery2.SQL.Add('a.point_order,a.id_point_oper,a.trip_time,a.trip_type,a.createdate,a.id_user,a.atp_id,a.id_oper,a.id_shedule ');
        ZReadOnlyQuery2.SQL.Add(',coalesce((SELECT b.name from av_users b WHERE b.del=0 AND b.id=a.id_user ORDER BY b.createdate DESC LIMIT 1 OFFSET 0),''нет'') as name ');
        ZReadOnlyQuery2.SQL.Add(' from av_disp_oper as a ');
        ZReadOnlyQuery2.SQL.Add('WHERE a.del=0 AND a.trip_date='+Quotedstr(datetostr(work_date))+' AND a.id_shedule='+full_mas[idx,1]+' order by a.trip_time,a.createdate;');
        //showmessage(ZReadOnlyQuery2.SQL.text);//$
          try
            ZReadOnlyQuery2.open;
          except
             showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
             ZReadOnlyQuery2.Close;
             Zconnection2.disconnect;
             FormR.Close;
             exit;
          end;
//=======================================================
//============  СОСТОЯНИЯ РЕЙСА   =======================
//0 - НЕОПРЕДЕЛЕНО (ОТКРЫТ)
//1 - ДООБИЛЕЧИВАНИЕ (ОТКРЫТ) повторно
//2 - ОТМЕЧЕН КАК ПРИБЫВШИЙ
//3 - ОТМЕЧЕН КАК ОПАЗДЫВАЮЩИЙ (ОТКРЫТ)
//4 - ОТПРАВЛЕН (Закрыт)
//5 - СРЫВ ПО ВИНЕ АТП (ЗАКРЫТ)
//6 - ЗАКРЫТ ПРИНУДИТЕЛЬНО

         If ZReadOnlyQuery2.RecordCount>0 then
             begin


          For m:=1 to ZReadOnlyQuery2.RecordCount do
            begin
               //находим все рейсы измененного расписания
                  IF (full_mas[idx,1]=ZReadOnlyQuery2.FieldByName('id_shedule').AsString) then
                    begin
                      If ((full_mas[idx,3]=ZReadOnlyQuery2.FieldByName('trip_id_point').AsString) AND
                          (full_mas[idx,4]=ZReadOnlyQuery2.FieldByName('point_order').AsString)) OR
                      //или если рейс прибытия
                          ((full_mas[idx,6]=ZReadOnlyQuery2.FieldByName('trip_id_point').AsString) AND
                           (full_mas[idx,7]=ZReadOnlyQuery2.FieldByName('point_order').AsString)) then
                             begin
                                tid_atp:= ZReadOnlyQuery2.FieldByName('atp_id').asString;
                                tatp:= trim(ZReadOnlyQuery2.FieldByName('atp_name').asString);
                                tek_id_ats:= ZReadOnlyQuery2.FieldByName('avto_id').asString;
                                tats:= trim(ZReadOnlyQuery2.FieldByName('avto_name').asString);
                                //tseats:= ZReadOnlyQuery2.FieldByName('avto_seats').asInteger;
                                tats_type:= ZReadOnlyQuery2.FieldByName('avto_type').asInteger;
                                tstatus:= ZReadOnlyQuery2.FieldByName('trip_flag').asInteger;
                                tdate:= FormatDateTime('dd-mm-yyyy',ZReadOnlyQuery2.FieldByName('createdate').AsDateTime);
                                ttime:= FormatDateTime('hh:nn:ss',ZReadOnlyQuery2.FieldByName('createdate').AsDateTime);
                                If trim(ZReadOnlyQuery2.FieldByName('name').asString)<>'' then
                                tname:= trim(ZReadOnlyQuery2.FieldByName('name').asString);
                                If trim(ZReadOnlyQuery2.FieldByName('remark').asString)<>'' then
                                tremark:= trim(ZReadOnlyQuery2.FieldByName('remark').asString);
                                If trim(ZReadOnlyQuery2.FieldByName('putevka').asString)<>'' then
                                tputevka:= trim(ZReadOnlyQuery2.FieldByName('putevka').asString);
                                If trim(ZReadOnlyQuery2.FieldByName('driver1').asString)<>'' then
                                tdriver1:= trim(ZReadOnlyQuery2.FieldByName('driver1').asString);
                                If trim(ZReadOnlyQuery2.FieldByName('driver2').asString)<>'' then
                                tdriver2:= trim(ZReadOnlyQuery2.FieldByName('driver2').asString);
                                If trim(ZReadOnlyQuery2.FieldByName('driver3').asString)<>'' then
                                tdriver3:= trim(ZReadOnlyQuery2.FieldByName('driver3').asString);
                                If trim(ZReadOnlyQuery2.FieldByName('driver4').asString)<>'' then
                                tdriver4:= trim(ZReadOnlyQuery2.FieldByName('driver4').asString);
                                ZReadOnlyQuery2.Next;
                                continue;
                             end;
                          //showmessage(full_mas[n,1]+full_mas[n,19]+full_mas[n,21]);

              //     //если рейс закрыт или сорван, то связанные рейсы пропускаем
              //     IF ZReadOnlyQuery2.FieldByName('trip_flag').AsInteger=5 then continue;
              //     IF ZReadOnlyQuery2.FieldByName('trip_flag').AsInteger=6 then continue;
              //
              //
              ////корректируем связанные рейсы
              //   tn :=0; //время отправления/прибытия по графику
              //   tm :=0; //время отправления/прибытия фактическое
              //   //если рейс отправления
              //     If (full_mas[idx,16]='1') then
              //       begin
              //         try
              //           tn := strtoint(copy(full_mas[idx,10],1,2)+copy(full_mas[idx,10],4,2));
              //         except
              //           on exception: EConvertError do continue;
              //         end;
              //       end;
              //    //если рейс прибытия
              //     If (full_mas[idx,16]='2') then
              //       begin
              //           //если время прибытия больше, чем в операции
              //         try
              //           tn := strtoint(copy(full_mas[idx,12],1,2)+copy(full_mas[idx,12],4,2));
              //         except
              //           on exception: EConvertError do continue;
              //         end;
              //        end;
              //
              //  try
              //     tm := strtoint(copy(ZReadOnlyQuery2.FieldByName('trip_time').AsString,1,2)+copy(ZReadOnlyQuery2.FieldByName('trip_time').AsString,4,2));
              //  except
              //     on exception: EConvertError do continue;
              //  end;
              //   //если время отправления/прибытия больше, чем в операции
              //         If (tn>tm) AND (tn>0) AND (tm>0) then
              //           begin
              //            tid_atp:= ZReadOnlyQuery2.FieldByName('atp_id').asInteger;
              //                  tatp:= trim(ZReadOnlyQuery2.FieldByName('atp_name').asString);
              //                  tek_id_ats:= ZReadOnlyQuery2.FieldByName('avto_id').asString;
              //                  tats:= trim(ZReadOnlyQuery2.FieldByName('avto_name').asString);
              //                  tseats:= ZReadOnlyQuery2.FieldByName('avto_seats').asInteger;
              //                  tats_type:= ZReadOnlyQuery2.FieldByName('avto_type').asInteger;
              //                  tstatus:= ZReadOnlyQuery2.FieldByName('trip_flag').asInteger;
              //                  tdate:= FormatDateTime('dd-mm-yyyy',ZReadOnlyQuery2.FieldByName('createdate').AsDateTime);
              //                  ttime:= FormatDateTime('hh:nn:ss',ZReadOnlyQuery2.FieldByName('createdate').AsDateTime);
              //                  If trim(ZReadOnlyQuery2.FieldByName('name').asString)<>'' then
              //                  tname:= trim(ZReadOnlyQuery2.FieldByName('name').asString);
              //                  If trim(ZReadOnlyQuery2.FieldByName('remark').asString)<>'' then
              //                  tremark:= trim(ZReadOnlyQuery2.FieldByName('remark').asString);
              //                  If trim(ZReadOnlyQuery2.FieldByName('putevka').asString)<>'' then
              //                  tputevka:= trim(ZReadOnlyQuery2.FieldByName('putevka').asString);
              //                  If trim(ZReadOnlyQuery2.FieldByName('driver1').asString)<>'' then
              //                  tdriver1:= trim(ZReadOnlyQuery2.FieldByName('driver1').asString);
              //                  If trim(ZReadOnlyQuery2.FieldByName('driver2').asString)<>'' then
              //                  tdriver2:= trim(ZReadOnlyQuery2.FieldByName('driver2').asString);
              //                  If trim(ZReadOnlyQuery2.FieldByName('driver3').asString)<>'' then
              //                  tdriver3:= trim(ZReadOnlyQuery2.FieldByName('driver3').asString);
              //                  If trim(ZReadOnlyQuery2.FieldByName('driver4').asString)<>'' then
              //                  tdriver4:= trim(ZReadOnlyQuery2.FieldByName('driver4').asString);
                         //end;
                    end;

             ZReadOnlyQuery2.Next;
            end;
          case tstatus of
              0: FormR.Label5.Caption:='ОТКРЫТ';
              1: FormR.Label5.Caption:='ДООБИЛЕЧИВАНИЕ';
              2: FormR.Label5.Caption:='ПРИБЫЛ';
              3: FormR.Label5.Caption:='ОПАЗДЫВАЕТ';
              4: FormR.Label5.Caption:='ОТПРАВЛЕН';
              5: FormR.Label5.Caption:='СРЫВ';
              6: FormR.Label5.Caption:='ЗАКРЫТ';
          end;
          FormR.Label33.Caption:=ttime;
          FormR.Label36.Caption:=tdate;
          FormR.Label38.Caption:=tname;
          FormR.Label40.Caption:=tremark;
          FormR.Label51.Caption:=tputevka;
          FormR.Label55.Caption:=tdriver1+' , '+tdriver2+' , '+tdriver3+' , '+tdriver4;
          end
          else
          begin
          showmessagealt('НЕ НАЙДЕНО ОПЕРАЦИЙ С ЭТИМ РЕЙСОМ !');//+#13+ZReadOnlyQuery2.SQL.text);
          tek_id_ats:= full_mas[idx,20];
          tats:= full_mas[idx,21];
          tid_atp:= full_mas[idx,18];
          tatp:= full_mas[idx,19];
          tats_type:= strtoint(full_mas[idx,27]);
          end;

          FormR.Label7.Caption:='['+tid_atp+'] '+tatp;
          If tats_type=1 then
          FormR.Label9.Caption:='М2' else FormR.Label9.Caption:='М3';
          FormR.Label11.Caption:='['+tek_id_ats+'] '+tats;
          FormR.Label13.Caption:='';
  end;
 // Количество этажей

 // Мест всего

 // ТИП АТС

 // Загрузка мест в карту АТС
 zagruzka_mest;
 // Заполняем массив статусов мест
 fill_mas_seats;
 // Рисуем GRID
 fill_grid;
 // Расставляем информацию и элементы если режим редактирования
  //get_info;
  //StringGrid2.Enabled:=true;

end;


//******************************************* ВОЗНИКНОВЕНИЕ ФОРМЫ ************************************
procedure TFormR.FormShow(Sender: TObject);
begin
 //Выравниваем форму
 CentrForm(FormR);

 idx:= masnum;
 with FormR do
 begin
 Label5.Caption:='';
 Label7.Caption:='';
 Label9.Caption:='';
 Label11.Caption:='';
 Label13.Caption:='';
 Label31.Caption:='';
 Label33.Caption:='';
 Label36.Caption:='';
 Label38.Caption:='';
 Label40.Caption:='';
 Label42.Caption:='';
 Label41.Caption:='';
 Label46.Caption:='';
 Label49.Caption:='';
 Label25.Caption:='';
 Label26.Caption:='';
 Label27.Caption:='';
 Label28.Caption:='';
 Label51.Caption:='';
 Label55.Caption:='';
 load_trip();
 end;
end;



//**************************************************    РИСУЕМ ГРИД **************************************************
procedure TFormR.StringGrid2DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
  tw,th:integer;
begin
 If not formr.stringgrid2.Focused then exit;
 with Sender as TStringGrid, Canvas do
  begin
    // Фон по сотсоянию места
     // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
  // mesta[n,m,1] - номер места
  // mesta[n,m,2] - статус места
   //0-свободно
    //1-броня ОПП
    //3-броня диспетчера
    //4-продается
    //5-продан
    //6-выбран самим для продажи
    //7-броня справки
    //8-вычеркнутый билет
    //9-транзит

      // Если Свободное
    if trim(mesta[aCol,4-aRow,2])='0' then
        begin
         Font.Color := clMaroon;
         brush.Color:=clWhite;
        end;

    // Если неактивное
    if trim(mesta[aCol,4-aRow,1])='0' then
        begin
         brush.Color:=clSilver;
        end;

    // Если ОПП
    if trim(mesta[aCol,4-aRow,2])='1' then
        begin
         brush.Color:=$00ff8e4c;
         Font.Color := clWhite;
        end;

    // Если ДИСПЕТЧЕР
    if trim(mesta[aCol,4-aRow,2])='3' then
        begin
         brush.Color:=$0088F5F6;
         Font.Color := clBlack;
        end;


      // Если Продано
    if trim(mesta[aCol,4-aRow,2])='5' then
        begin
         brush.Color:=$00A5A5EF;
         Font.Color := clBlack;
        end;

      // Если БРОНЯ СПРАВКИ
    if trim(mesta[aCol,4-aRow,2])='7' then
        begin
         brush.Color:=$0086AF8E;
         Font.Color := clWhite;
        end;

     // Если Вычеркнутый
    if trim(mesta[aCol,4-aRow,2])='8' then
        begin
         brush.Color:=clBlack;
         Font.Color := clWhite;
        end;

     // Если Транзит
    if trim(mesta[aCol,4-aRow,2])='9' then
        begin
         brush.Color:=clGray;
         Font.Color := clWhite;
        end;


    if not(trim(Cells[aCol,aRow])='') then FillRect(aRect);

    // Рисуем рамку места
   if not(trim(Cells[aCol,aRow])='') then
     begin
       pen.Width:=2;
       pen.Color:=clBlack;
       //FillRect(aRect);
       Rectangle(aRect.left+1,aRect.Top+1,aRect.Right-2,aRect.Bottom-2);
     end;

   if (gdFocused in aState) then
      begin
        //Brush.Color := clRed;
        pen.Width:=3;
        pen.Color:=clRed;
        Rectangle(aRect.left+1,aRect.Top+1,aRect.Right-2,aRect.Bottom-2);
      end;
   //else
   //  begin
      // Рисуем место в зависимости от типа
     if not(trim(Cells[aCol,aRow])='') then
         begin
           //Font.Color := clMaroon;
           font.Size:=14;
           font.Style:=[fsBold];
           tw:=textwidth(Cells[aCol, aRow]);
           th:=textheight(Cells[aCol, aRow]);
           TextOut(aRect.left+((aRect.Right-aRect.left) div 2)-(tw div 2),aRect.top+((aRect.bottom-aRect.top) div 2)-(th div 2) , Cells[aCol, aRow]);
         end;
     //end;
  end;
end;


procedure TFormR.StringGrid2SelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
begin
  formR.get_info;
end;


//**************************** HOT KEYS *********************************************
procedure TFormR.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    // ESC
   if (Key=27) then
       begin
         formR.StringGrid2.Visible:=false;
         formR.Close;
       end;

   // F1 - Справка
   if (Key=112) then showmessagealt('F1 - СПРАВКА'+#13+'F2 - ЭТАЖ СМЕНИТЬ'+#13+'F6 - ВЕДОМОСТЬ'+#13+'ESC - ВЫХОД');

   // F2 - Смена этажа
   if (Key=113) then
       begin
         formR.change_layer();
       end;

   // F6 - Печать ведомости
   if (Key=117) then
       begin
         vedom_remote;
       end;
  If (key=13) OR (key=27) OR (key=32) OR (key=117) OR (key=113) OR (key=112) then key:=0;
end;

procedure TFormR.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;

procedure TFormR.FormPaint(Sender: TObject);
begin
  with formR do
  begin
   Canvas.Brush.Color:=clSilver;
   Canvas.Pen.Color:=clBlack;
   Canvas.Pen.Width:=2;
   Canvas.Rectangle(2,2,Width-2,Height-2);
  end;
end;



end.

