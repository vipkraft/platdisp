unit bron_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,  LazFileUtils, Forms, Controls, Graphics,
  Dialogs,StdCtrls,Grids,ExtCtrls,strutils,LazUTF8;

type

  { TForm7 }

  TForm7 = class(TForm)
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
    Label4: TLabel;
    Label44: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Shape1: TShape;
    Shape10: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    StringGrid2: TStringGrid;
    ZConnection1: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    ZReadOnlyQuery2: TZReadOnlyQuery;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; aCol, aRow: Integer;      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid2Selection(Sender: TObject; aCol, aRow: Integer);
    procedure zagruzka_mest;
    procedure fill_grid;
    // Ставим бронь где возможно или снимаем
    procedure Check_bron;
    // Обновляем информацию о месте
    procedure get_info;
    // Смена этажа
    procedure change_layer();
    // Заполняем массив с местами в атобусе
    procedure fill_mas_seats;
    // Настраиваем форму
   procedure set_form;
   // Вычеркнутый Устанавливаем\Снимаем
   procedure Mark;
   // Сохраняем данные
  procedure Save_bron();
  // Сохраняем Вычеркнутые
  procedure Save_unused();
  // проверка рейса для вычеркнутых билетов
  //function check_trip():boolean;
  //установка невидимой брони
  procedure SetShadowBron();
  procedure UNSetShadowBron();
  //двигаемся по карте автобуса
  //procedure    move_cell;

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form7: TForm7;

implementation

uses
  platproc,maindisp,menu;

var
   tek_id_ats,maxmesto:integer;
   fl_transit:boolean;
   tek_type_rejs,st1,tripdate:string;
   mesta:array of array of array of string;
  // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
 // mesta[n,m,1] - номер места
 // mesta[n,m,2] - статус места
  //0-свободно
   //1-бронь ОПП
   //3-бронь диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-бронь справки
   //8-вычеркнутый билет
   //9-транзит
   //11-неснимаемая бронь
   //13 - спец бронь
  // mesta[n,m,3] - ремарка
  // mesta[n,m,4] - id диспетчера
  // mesta[n,m,5] - имя диспетчера
  // mesta[n,m,6] - дата операции
  // mesta[n,m,7] - старый статус места
  // mesta[n,m,8] - старая ремарка
   locks:array of string;
   idx:integer=-1;
   flchange,remote_trip,fl_lock:boolean;
   prim:string='';

{$R *.lfm}


//****************************************** проверка рейса для вычеркнутых билетов
//function TForm7.check_trip():boolean;
//var
//   status_trip : byte=0;
//begin
// with Form7 do
// begin
//   Result := false;
//  If not(Connect2(Form7.Zconnection1, flagProfile)) then
//    begin
//     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
//     Form7.close;
//    end;
//
//  //запрос на диспетчерские операции над рейсом
//  ZReadOnlyQuery1.SQL.Add('SELECT trip_flag from av_disp_oper WHERE del=0 AND trip_type=1 ');
//  ZReadOnlyQuery1.SQL.Add(' AND id_shedule='+full_mas[idx,1]+' AND trip_time='+Quotedstr(full_mas[idx,10])+' AND trip_id_point='+full_mas[idx,3]+' AND point_order='+full_mas[idx,4]);
//  ZReadOnlyQuery1.SQL.Add(' AND trip_date='+Quotedstr(tripdate)+' AND id_point_oper='+ConnectINI[14]+' order by createdate DESC;');
//  //showmessage(ZReadOnlyQuery1.SQL.Text);//$
//  try
//  ZReadOnlyQuery1.open;
// except
//  showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
//  ZReadOnlyQuery1.Close;
//  Zconnection1.disconnect;
//  exit;
// end;
//  If ZReadOnlyQuery1.RecordCount>0 then
//    begin
//       status_trip := ZReadOnlyQuery1.FieldByName('trip_flag').AsInteger;
//       If status_trip=4 then Result:=true; //если рейс отправлен, тогда можно вычеркивать
//       If status_trip<>4 then showmessagealt('Сначала необходимо отправить рейс !');
//    end;
//  end;
// end;


 // Заполняем массив статусов мест
procedure TForm7.fill_mas_seats;
  var
   n,m,k,i,y,seatnum:integer;
   t1,t2,t3,sss:string;
   flf:boolean;
   mas_s:array of array of string;
 begin
 // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
 // mesta[n,m,1] - номер места
 // mesta[n,m,2] - статус места
  //0-свободно
   //1-бронь ОПП
   //3-бронь диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-бронь справки
   //8-вычеркнутый билет
   //9-транзит

  // mesta[n,m,3] - ремарка
  // mesta[n,m,4] - id диспетчера
  // mesta[n,m,5] - имя диспетчера
  // mesta[n,m,6] - дата операции
  // mesta[n,m,7] - старый статус места
  // mesta[n,m,8] - старая ремарка

  with Form7 do
  begin
 // -------------------- Соединяемся с локальным сервером ----------------------
 //If not(Connect2(Zconnection1, flagProfile)) then
 // begin
 //  showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
 //  exit;
 // end;

    //========================= Состояние брони по рейсу =============================//
 ZReadOnlyQuery1.sql.Clear;
 ZReadOnlyQuery1.sql.add('select a.id_user,a.bron,a.createdate,(SELECT name FROM av_users b WHERE b.del=0 AND b.id=a.id_user ORDER BY b.createdate DESC limit 1 OFFSET 0) as name ');
 ZReadOnlyQuery1.sql.add('from av_disp_bron a WHERE a.del=0 AND a.date_trip='+quotedstr(tripdate)+' AND a.ot_id_point='+sale_server);
 ZReadOnlyQuery1.sql.add(' AND a.id_shedule='+full_mas[idx,1]+' AND a.time_trip='+quotedstr(full_mas[idx,10])+' AND a.ot_point_order='+full_mas[idx,4]+';');
 //showmessage(ZReadOnlyQuery1.sql.Text);//$
 try
     ZReadOnlyQuery1.open;
 except
     showmessagealt('ОШИБКА ЗАПРОСА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
     ZReadOnlyQuery1.Close;
     Zconnection1.disconnect;
     exit;
 end;
   SetLength(mas_s,0,0);
 // Если есть бронь
 if ZReadOnlyQuery1.RecordCount>0 then
    begin
    m:=1;
    //showmessage(ZReadOnlyQuery1.FieldByName('bron').asString);//$
  for n:=1 to utf8Length(ZReadOnlyQuery1.FieldByName('bron').asString) do
    begin
      // k - 1 номер места
      // k - 2 статус
      // m - текущее начало вырезки
      if UTF8Copy(ZReadOnlyQuery1.FieldByName('bron').asString,n,1)='|' then
         begin
           t1:=UTF8Copy(ZReadOnlyQuery1.FieldByName('bron').asString,m,(n-m));
           //showmessage(t1);//$
           m:=n+1;
           SetLength(mas_s,Length(mas_s)+1,6);
           y:=1;
           k:=1;
           for i:=0 to UTF8length(t1) do
             begin
               If y>6 then break;
               if UTF8Copy(t1,i,1)='-' then
                  begin
                    //номер места
                   If y=1 then mas_s[Length(mas_s)-1,y-1]:=PadL(UTF8Copy(t1,k,i-k),'0',3)
                   else mas_s[Length(mas_s)-1,y-1]:=UTF8Copy(t1,k,i-k);
                   //If y=3 then showmessage(UTF8Copy(t1,k,i-k));//$
                   k:=i+1;
                   y:=y+1;
                  end;
             end;
          //если бронь ставил последний исправлявший
          If trim(mas_s[Length(mas_s)-1,3])='' then
          begin
            mas_s[Length(mas_s)-1,3]:=ZReadOnlyQuery1.FieldByName('id_user').asString;
            mas_s[Length(mas_s)-1,4]:=ZReadOnlyQuery1.FieldByName('name').asString;
            mas_s[Length(mas_s)-1,5]:=FormatDateTime('hh:nn dd/mm/yy',ZReadOnlyQuery1.FieldByName('createdate').asDateTime);
          end;
         end;
    end;

     //заполняем массив мест информацией
for k:=0 to length(mas_s)-1 do
     begin
      flf:=false;
   for m:=0 to 49 do
    begin
       If flf then break;
    //for n:=0 to length(mesta[0])-1 do
    for n:=0 to 4 do
      begin
         // Если номера мест совпадают, ставим Статус места
           if mas_s[k,0]=mesta[m,n,1] then
              begin
                mesta[m,n,2]:=mas_s[k,1];//статус места
                mesta[m,n,3]:=mas_s[k,2];//ремарка
                mesta[m,n,4]:=mas_s[k,3];//id_пользователя
                mesta[m,n,5]:=mas_s[k,4];//имя пользователя
                mesta[m,n,6]:=mas_s[k,5];//время дата
                mesta[m,n,7]:=mas_s[k,1];//статус места
                mesta[m,n,8]:=mas_s[k,2];//старая ремарка
                flf:=true;
                break;
               end;
        end;
      end;

   //если такого места нет в массиве мест, то добавим его
    If not flf then
       begin
     for m:=0 to 49 do
      begin
      If flf then break;
      for n:=0 to 4 do
          begin
            // Если номера мест совпадают, ставим Статус места
            If (trim(mesta[m,n,1])='') or (mesta[m,n,1]='000') then
               begin
                //showmessage(mesta[m,n,1]+#13+mas_s[k,0]);
                mesta[m,n,1]:=mas_s[k,0]; // !!! Добавляем место
                mesta[m,n,2]:=mas_s[k,1];//статус места
                mesta[m,n,3]:=mas_s[k,2];//ремарка
                mesta[m,n,4]:=mas_s[k,3];//id_пользователя
                mesta[m,n,5]:=mas_s[k,4];//имя пользователя
                mesta[m,n,6]:=mas_s[k,5];//время дата
                mesta[m,n,7]:=mas_s[k,1];//статус места
                mesta[m,n,8]:=mas_s[k,2];//старая ремарка
                flf:=true;
                break;
               end;
          end;
      end;
       end;
   end;
  end;

 //========================= Состояние мест по рейсу =============================//
 ZReadOnlyQuery1.sql.Clear;
 ZReadOnlyQuery1.sql.add('select * from get_seats_status('+quotedstr(tripdate)+','+sale_server+','+full_mas[idx,6]+','+full_mas[idx,18]+',');
 ZReadOnlyQuery1.sql.add(full_mas[idx,1]+','+quotedstr(full_mas[idx,10])+','+full_mas[idx,20]+','+tek_type_rejs);
 ZReadOnlyQuery1.sql.add(','+full_mas[idx,46]+','+full_mas[idx,7]+',1) as free;');
 //showmessage(ZReadOnlyQuery1.sql.Text);//$
 try
     ZReadOnlyQuery1.open;
 except
     showmessagealt('ОШИБКА ЗАПРОСА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
     ZReadOnlyQuery1.Close;
     Zconnection1.disconnect;
     exit;
 end;
 // Если нет рейсов
 if ZReadOnlyQuery1.RecordCount=0 then
    begin
      showmessagealt('ОШИБКА ! НЕТ ДАННЫХ ПО СОСТОЯНИЕ МЕСТ !'+#13+'Обратитесь к администратору или попробуйте снова !!!');
      ZReadOnlyQuery1.Close;
      Zconnection1.disconnect;
      exit;
    end;

  // Расставляем статусы мест
  SetLength(mas_s,0,0);


  //showmessage(ZReadOnlyQuery1.FieldByName('free').asString);
  // Заполняем временный массив статусов мест
  m:=1;
  k:=1;
  for n:=1 to utf8Length(ZReadOnlyQuery1.FieldByName('free').asString) do
    begin
      // k - 1 номер места
      // k - 2 статус
      // m - текущее начало вырезки
      if UTF8Copy(ZReadOnlyQuery1.FieldByName('free').asString,n,1)='|' then
         begin
           t1:=UTF8Copy(ZReadOnlyQuery1.FieldByName('free').asString,m,(n-m));

           m:=n+1;
           if k=1 then
              begin
                //showmessage(t1);//$
                //номер места
               SetLength(mas_s,Length(mas_s)+1,2);
               mas_s[Length(mas_s)-1,1]:=PadL(t1,'0',3);
               k:=3;
              end;
           if k=2 then
              begin
                If not specbron and (trim(t1)='13') then t1:='5';
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
  //заполняем массив мест информацией
  for k:=0 to length(mas_s)-1 do
    begin
    flf:=false;
    for m:=0 to 49 do
      begin
      If flf then break;
    //for n:=0 to length(mesta[0])-1 do
      for n:=0 to 4 do
          begin
            // Если номера мест совпадают, ставим Статус места
            if mas_s[k,1]=mesta[m,n,1] then
               begin
                //showmessage(mesta[m,n,1]+#13+mas_s[k,0]);
                mesta[m,n,2]:=mas_s[k,0];
                mesta[m,n,7]:=mas_s[k,0];
                flf:=true;
                break;
               end;
          end;
      end;
  seatnum:=0;
  //если такого места нет в массиве мест, то добавим его
  If not flf then
      begin
       sss:='';
     for m:=0 to 49 do
      begin
         //sss:=sss+inttostr(m+1)+') '+mas_s[k,1]+' - ';
      If flf then break;
      for n:=0 to 4 do
          begin
          //считаем кол-во реальных мест
          If strtoint(mesta[m,n,1])<>0 then
           seatnum:=seatnum+1;
           //sss:=sss+'/'+mesta[m,n,1];
          //Если не все места еще пройдены и место свободно или транзит, то меняем номер места и ставим туда билет
          If ((seatnum<maxmesto) and (mesta[m,n,1]<>'000') and ((mesta[m,n,2]='0') or (mesta[m,n,2]='9')))
            //или все места уже проверили и следующее место пустое
            OR ((seatnum>=maxmesto) and ((trim(mesta[m,n,1])='') or (mesta[m,n,1]='000'))) then
               begin
                //showmessage(mesta[m,n,1]+#13+mas_s[k,0]);
                mesta[m,n,1]:=mas_s[k,1];
                mesta[m,n,2]:=mas_s[k,0];
                mesta[m,n,7]:=mas_s[k,0];
                flf:=true;
                break;
               end;
          end;
        //sss:=sss+#13;
      end;
      //showmessage(sss);
     end;
   end;
  Form7.Stringgrid2.Refresh;
   //t1:='';
   //for n:=0 to length(mas_s)-1 do
   //  begin
   //    t1:=t1+mas_s[n,1]+'-'+mas_s[n,0]+'|';
   //  end;
   //showmessage(t1);
   //ZReadOnlyQuery1.Close;
   //Zconnection1.disconnect;
  end;
end;


//******************************************************************************
procedure TForm7.zagruzka_mest;
 var
   n,m,k,nmesto:integer;
begin
  // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
  // mesta[n,m,1] - номер места
  // mesta[n,m,2] - статус места
   //0-свободно
   //1-бронь ОПП
   //3-бронь диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-бронь справки
   //8-вычеркнутый билет
   //9-транзит
   // mesta[n,m,3] - ремарка
   // mesta[n,m,4] - id диспетчера
   // mesta[n,m,5] - имя диспетчера
   // mesta[n,m,6] - дата операции
   // mesta[n,m,7] - старый статус места

  SetLength(mesta,0,0,0);

   //запрос списка мест из av_str_ats
   Form7.ZReadOnlyQuery1.SQL.Clear;
   Form7.ZReadOnlyQuery1.SQL.add('SELECT (one_one||one_two||one_three||one_four||one_five) as etag1, ');
   Form7.ZReadOnlyQuery1.SQL.add('(two_one||two_two||two_three||two_four||two_five) as etag2,level ');
   Form7.ZReadOnlyQuery1.SQL.add('FROM av_spr_ats where id='+inttostr(tek_id_ats)+' and del=0;');
   //showmessage(ZReadOnlyQuery1.SQL.Text);//$
 try
      Form7.ZReadOnlyQuery1.open;
 except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+Form7.ZReadOnlyQuery1.SQL.Text);
       Form7.ZReadOnlyQuery1.Close;
       Form7.Zconnection1.disconnect;
       exit;
 end;
   if Form7.ZReadOnlyQuery1.RecordCount=0 then
     begin
      showmessagealt('Не определены места для данного АТС !!!'+#13+'Обратитесь к АДМИНИСТРАТОРУ !!!');
      Form7.ZReadOnlyQuery1.Close;
      Form7.Zconnection1.disconnect;
      exit;
     end;

   // Проставляем количество этажей
   Form7.Label11.caption:=Form7.ZReadOnlyQuery1.FieldByName('level').asString;

   // Создаем массив и разбираем места кроме стоя

   SetLength(mesta,50,5,9);
   for n:=0 to 1 do     // Этаж
     begin
       for m:=0 to 4 do  // Ряд
         begin
           for k:=0 to 24 do   // Место
             begin
               // Тип места
               //1 - сидя 3 - лежа
               mesta[k+(n*25),m,0]:=Copy(ifthen(n=0,Form7.ZReadOnlyQuery1.FieldByName('etag1').asString, Form7.ZReadOnlyQuery1.FieldByName('etag2').asString),(k*4+1)+(m*100),1);
               // Номер места
               mesta[k+(n*25),m,1]:=Copy(ifthen(n=0,Form7.ZReadOnlyQuery1.FieldByName('etag1').asString, Form7.ZReadOnlyQuery1.FieldByName('etag2').asString),(k*4+1)+(m*100)+1,3);
               try
               nmesto:=strtoint(mesta[k+(n*25),m,1]);
               If nmesto>maxmesto then maxmesto:=nmesto;
               except
                 on exception: EConvertError do continue;
               end;
               //If n=1 then showmessage(mesta[k+(n*25),m,1]);//$
               //showmessage(mesta[k+(n*25),m,1]);
               // Убираем места стоя
               //if mesta[k+(n*25),m,0]='2' then
               //  begin
               //    mesta[k+(n*25),m,0]:='0';
               //    mesta[k+(n*25),m,1]:='0';
               //  end;

               mesta[k+(n*25),m,3]:='';
               mesta[k+(n*25),m,4]:='';
               mesta[k+(n*25),m,5]:='';
               mesta[k+(n*25),m,6]:='';
               // Ставим все для транзита бронированными по умолчанию
               if not(trim(mesta[k+(n*25),m,0])='0') and (trim(tek_type_rejs)='0') then
                 begin
                   mesta[k+(n*25),m,2]:='9';
                   mesta[k+(n*25),m,7]:='9';
                 end
               else
                begin
                 mesta[k+(n*25),m,2]:='0'; //сбрасываем состояние места
                 mesta[k+(n*25),m,7]:='0';
                end;
             end;
         end;
     end;
end;


// Смена этажа
procedure TForm7.change_layer();
begin
  if (trim(Form7.label4.caption)='1') and (trim(Form7.label11.caption)='2') then
     begin
       Form7.label4.caption:='2';
       Form7.fill_grid;
       exit;
     end;
  if (trim(Form7.label4.caption)='2') then
     begin
       Form7.label4.caption:='1';
       Form7.fill_grid;
     end;
end;


// Сохраняем Вычеркнутые
procedure TForm7.Save_unused();
var
   n,m,k,nseat:integer;
   seat_status,tmp:string;
   tip:string='';
   untip:string='';
begin
 //   If not flchange then
 //   begin
 //       If form1.ZConnection1.Connected then
 //          begin
 //           If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
 //           form1.ZConnection1.disconnect;
 //          end;
 //        If Form7.ZConnection1.Connected then
 //          begin
 //           If Form7.ZConnection1.InTransaction then Form7.Zconnection1.Rollback;
 //           Form7.ZConnection1.disconnect;
 //          end;
 //         showmessagealt('Изменений не было !');
 //         Form7.Close;
 //         exit;
 //     end;
 //
 // //Если операция не в транзакции, то открываем повторно
 // If not form1.ZConnection1.Connected then
 //    begin
 //     showmessagealt('ОШИБКА Транзакции ! Обратитесь к администратору !');//$
 // end
 //else
 //   //если транзакция открыта
 //    begin
 //     //showmessage('unused_2');//$
 //     try
 //  //(ищем вычеркнутые билеты и багаж, отправляющиеся с данного пунтка по этому рейсу)
 //  form1.ZReadOnlyQuery1.sql.Clear;
 //  form1.ZReadOnlyQuery1.SQL.add('SELECT unused,mesto FROM av_ticket WHERE type_oper=1 AND id_ot='+ConnectINI[14]);//+' AND mesto='+mesta[n,m,1]);
 //  form1.ZReadOnlyQuery1.SQL.add(' AND trip_date='+Quotedstr(tripdate));
 //  form1.ZReadOnlyQuery1.SQL.add(' AND trip_time='+quotedstr(full_mas[idx,10]));
 //  form1.ZReadOnlyQuery1.SQL.add(' AND id_shedule='+full_mas[idx,1]+' AND id_trip_ot='+full_mas[idx,3]+' AND id_trip_do='+full_mas[idx,6]);
 //  form1.ZReadOnlyQuery1.SQL.add(' AND order_trip_ot='+full_mas[idx,4]+' AND order_trip_do='+full_mas[idx,7]+' ;');
 //  //showmessage(form1.ZReadOnlyQuery1.SQL.Text);//$
 //      form1.ZReadOnlyQuery1.open;//*
 //
 //  If form1.ZReadOnlyQuery1.RecordCount=0 then
 //     begin
 //      If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
 //      form1.ZConnection1.disconnect;
 //      showmessagealt('ОШИБКА ! НЕТ ДАННЫХ ПО ЗАПРАШИВАЕМЫМ МЕСТАМ !');
 //      Form7.close;
 //      exit;
 //     end;
 //  //проверяем все места этого рейса  на факт изменения состояния места
 //  //(ищем вычеркнутые билеты и багаж, отправляющиеся с данного пунтка по этому рейсу)
 //  for k:=1 to form1.ZReadOnlyQuery1.RecordCount do
 //    begin
 //     for n:=0 to length(mesta)-1 do  // Место
 //      begin
 //    for m:=0 to length(mesta[0])-1 do   //ряд
 //     begin
 //      try
 //       nseat:=strtoint(mesta[n,m,1]);
 //      except
 //         continue;
 //      end;
 //      If nseat=13 then
 //          form1.ZReadOnlyQuery1.FieldByName('mesto').AsInteger;
 //      If nseat=form1.ZReadOnlyQuery1.FieldByName('mesto').AsInteger then
 //          begin
 //      seat_status:= trim(mesta[n,m,2]);
 //       If seat_status='' then continue;
 //       If not((seat_status='5') OR (seat_status='8')) then break;  //если место не продано или не вычеркнуто, то не наш случай
 //       If seat_status='8' then
 //          begin
 //           tip:='0'; //не было вычеркнуто
 //           untip:='1';//установить вычеркнутым
 //          end;
 //       If seat_status='5' then
 //          begin
 //           tip:='1'; //было вычеркнуто
 //           untip:='0'; //снять признак вычеркнутого
 //          end;
 //
 //   //Если состояние места не измениль - пропуск
 //   If form1.ZReadOnlyQuery1.FieldByName('unused').AsString=untip then break;
 //
 //  //добавляем в запрос к данным по дисп.операции, данные билета
 //   //помечаем место
 //  form1.ZReadOnlyQuery3.SQL.add('UPDATE av_ticket SET unused='+untip+',unused_id_user='+inttostr(id_user)+',unused_createdate=now() ');
 //  form1.ZReadOnlyQuery3.SQL.add(' WHERE id_ot='+ConnectINI[14]+' AND mesto='+inttostr(nseat));
 //  form1.ZReadOnlyQuery3.SQL.add(' AND trip_date='+Quotedstr(tripdate));
 //  form1.ZReadOnlyQuery3.SQL.add(' AND trip_time='+quotedstr(full_mas[idx,10]));
 //  form1.ZReadOnlyQuery3.SQL.add(' AND id_shedule='+full_mas[idx,1]+' AND id_trip_ot='+full_mas[idx,3]+' AND id_trip_do='+full_mas[idx,6]);
 //  form1.ZReadOnlyQuery3.SQL.add(' AND order_trip_ot='+full_mas[idx,4]+' AND order_trip_do='+full_mas[idx,7]);
 //  form1.ZReadOnlyQuery3.SQL.add(' AND unused='+tip+' AND type_oper=1;');
 //   break;
 //   end;
 //  end;
 // end;
 // form1.ZReadOnlyQuery1.Next;
 //end;
 //   //showmessage(form1.ZReadOnlyQuery3.SQL.Text);//$
 //  form1.ZReadOnlyQuery1.open;
 //   form1.ZReadOnlyQuery3.open;
 //   form1.Zconnection1.Commit;
 //   //showmessagealt('ДАННЫЕ УСПЕШНО СОХРАНЕНЫ !');
 //   except
 //     If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
 //     form1.ZConnection1.disconnect;
 //     showmessage('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL2: '+form1.ZReadOnlyQuery1.SQL.Text);
 //     exit;
 //   end;
 //   form1.ZConnection1.disconnect;
 //   form1.ZReadOnlyQuery3.Close;
 //   form1.ZReadOnlyQuery1.Close;
 // end;
 //  Form7.Close;
end;


// Сохраняем данные Брони
procedure TForm7.Save_bron();
var
   n,m,k:integer;
   flag:byte=0;
begin
    flag:=0;
  // Проверяем что есть что сохранять
         for n:=0 to 49 do
          begin
            for m:=0 to 4 do
              begin
                If trim(mesta[n,m,1])='000' then continue;
                If trim(mesta[n,m,1])='' then continue;
                If (fl_transit and (mesta[n,m,2]='9'))
                OR (trim(mesta[n,m,2])='0')
                or (trim(mesta[n,m,2])='3') then
                 begin
                   flag:=1;
                   break;
                 end;
              end;
            If flag=1 then break;
          end;

  //если нечего сохранять
  if flag=0 then
      begin
        If form1.ZConnection1.Connected then
           begin
            If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
            form1.ZConnection1.disconnect;
           end;
           If Form7.ZConnection1.Connected then
           begin
            If Form7.ZConnection1.InTransaction then Form7.Zconnection1.Rollback;
            Form7.ZConnection1.disconnect;
           end;
          Form7.Close;
          exit;
      end;

  If not flchange then
    begin
       If form1.ZConnection1.Connected then
           begin
            If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
            form1.ZConnection1.disconnect;
           end;
        If Form7.ZConnection1.Connected then
           begin
            If Form7.ZConnection1.InTransaction then Form7.Zconnection1.Rollback;
            Form7.ZConnection1.disconnect;
           end;
          showmessagealt('Изменений не было !');
          Form7.Close;
          exit;
      end;

  //если транзитный рейс отправления, то проверяем, что проставлены данные прибытия
  //If remote_trip and (full_mas[idx,9]='0') and (full_mas[idx,16]='1') then
  If (-1=1) and not remote_trip and fl_transit and (full_mas[idx,16]='1') then
  //If not remote_trip then
  //   If (full_mas[idx,9]='0') then
  //      If (full_mas[idx,16]='1') then
    begin
       // Подключаемся к серверу
    If not(Connect2(Form7.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k19-');
     Form7.close;
     exit;
    end;
      Form7.ZReadOnlyQuery1.SQL.Clear;
      Form7.ZReadOnlyQuery1.SQL.add('SELECT * FROM av_disp_oper WHERE trip_type=2 AND id_shedule='+full_mas[idx,1]+' AND trip_id_point='+full_mas[idx,6]);
      Form7.ZReadOnlyQuery1.SQL.add(' AND point_order='+full_mas[idx,7]+' AND trip_date='+quotedstr(tripdate)+';');
     //showmessage(Form7.ZReadOnlyQuery1.SQL.Text);//$
      try
        Form7.ZReadOnlyQuery1.Open;
      except
       Form7.Zconnection1.Disconnect;
       showmessagealt('ОШИБКА ! Запрос: '+Form7.ZReadOnlyQuery1.SQL.Text);
       exit;
      end;
      If Form7.ZReadOnlyQuery1.RecordCount=0 then
      begin
        Form7.Zconnection1.Disconnect;
        showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'ВНЕСИТЕ РЕКВИЗИТЫ ПРИБЫТИЯ ДАННОГО РЕЙСА !');
        Form7.Close;
        exit;
      end;
      Form7.Zconnection1.Disconnect;
  end;

   //Если операция не в транзакции, то открываем повторно
  If not form1.ZConnection1.Connected then
     begin
       //showmessage('bron_1');//$
       formmenu.insert_oper(Form7.ZConnection1,Form7.ZReadOnlyQuery1,Form7.ZReadOnlyQuery2,operation);

     //если операция сброшена (кто-то держит или ошибки в транзакции), то - отвал
   //если транзакция отменена (кто-то держит или нет записей для блокировки), то - отвал
    If operation=0 then
       begin
         If form1.ZConnection1.Connected then
           begin
            If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
            form1.ZConnection1.disconnect;
           end;
         If Form7.ZConnection1.Connected then
           begin
            If Form7.ZConnection1.InTransaction then Form7.Zconnection1.Rollback;
            Form7.ZConnection1.disconnect;
           end;
       exit;
       end;
  If not Form7.ZConnection1.Connected then
   begin
      If form1.ZConnection1.Connected then
           begin
            If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
            form1.ZConnection1.disconnect;
           end;
     showmessagealt('ОШИБКА ВЫПОЛНЕНИЯ ТРАНЗАКЦИИ !');
    exit;
    end;
      try
          //Проверяем места на блокировку и на факт изменения состояния места
        SetLength(locks,0);
        Form7.ZReadOnlyQuery1.sql.Clear;
        Form7.ZReadOnlyQuery1.sql.add('select * from seats_in_sale('+quotedstr(tripdate)+','+sale_server+',');
        Form7.ZReadOnlyQuery1.sql.add(full_mas[idx,1]+','+quotedstr(full_mas[idx,10])+','+full_mas[idx,4]+','+full_mas[idx,25]+') as sale;');
        //showmessage(Form7.ZReadOnlyQuery1.SQL.Text);//$
        Form7.ZReadOnlyQuery1.open;
        If Form7.ZReadOnlyQuery1.RecordCount=1 then
         begin
          //если есть места в блокировки
           If utf8copy(Form7.ZReadOnlyQuery1.FieldByName('sale').asString,1,1)='1' then
            begin
          //переписываем массив мест
           m:=3;
           st1:='';
           for n:=3 to utf8Length(Form7.ZReadOnlyQuery1.FieldByName('sale').asString) do
            begin
             // m - текущее начало вырезки
              if UTF8Copy(Form7.ZReadOnlyQuery1.FieldByName('sale').asString,n,1)='|' then
               begin
                st1:=UTF8Copy(Form7.ZReadOnlyQuery1.FieldByName('sale').asString,m,(n-m));
                //showmessage(st1);//$
                m:=n+1;
                //номер места
                SetLength(locks,Length(locks)+1);
                locks[Length(locks)-1]:=PadL(st1,'0',3);
               end;
            end;
            end;
          end;
  Form7.ZReadOnlyQuery1.SQL.Clear;
  Form7.ZReadOnlyQuery1.SQL.add('UPDATE av_disp_bron SET del=1 WHERE ');
  Form7.ZReadOnlyQuery1.SQL.add('id_shedule='+full_mas[idx,1]+' and ');
  Form7.ZReadOnlyQuery1.SQL.add('time_trip='+quotedstr(full_mas[idx,10])+' and ');
  Form7.ZReadOnlyQuery1.SQL.add('date_trip='+quotedstr(tripdate)+' AND ot_point_order='+full_mas[idx,4]);
  Form7.ZReadOnlyQuery1.SQL.add(';');
  Form7.ZReadOnlyQuery1.SQL.add('INSERT INTO av_disp_bron (id_shedule, time_trip, ot_id_point,');
  //Form7.ZReadOnlyQuery1.SQL.add('do_id_point, id_ats, id_kontr, bron, ot_point_order, do_point_order,');
  //Form7.ZReadOnlyQuery1.SQL.add('id_point, date_trip, id_user, createdate, del) VALUES (');
  Form7.ZReadOnlyQuery1.SQL.add('bron, ot_point_order,');
  Form7.ZReadOnlyQuery1.SQL.add('id_point, date_trip, id_user, createdate, del) VALUES (');
  Form7.ZReadOnlyQuery1.SQL.add(full_mas[idx,1]+',');
  Form7.ZReadOnlyQuery1.SQL.add(quotedstr(trim(full_mas[idx,10]))+',');
  Form7.ZReadOnlyQuery1.SQL.add(sale_server+',');
  //Form7.ZReadOnlyQuery1.SQL.add(full_mas[idx,6]+',');
  //Form7.ZReadOnlyQuery1.SQL.add(full_mas[idx,20]+',');
  //Form7.ZReadOnlyQuery1.SQL.add(full_mas[idx,18]+',');
  //бронь
        for n:=0 to 49 do
          begin
            for m:=0 to 4 do
              begin
                If trim(mesta[n,m,1])='000' then continue;
                If trim(mesta[n,m,1])='' then continue;
                If (fl_transit and (mesta[n,m,2]='9'))
                OR (trim(mesta[n,m,2])='0')
                or (trim(mesta[n,m,2])='3') then
                    begin
                        //если место не изменилось и с ним ничего не делали
                    If (mesta[n,m,2]=mesta[n,m,7]) and (trim(mesta[n,m,4])='') then
                        begin
                         If (mesta[n,m,2]='0') and not fl_transit then continue;
                         If (mesta[n,m,2]='9') and fl_transit then continue;
                        end;

                      //если место забронировано только сейчаc, то проверяем на блокировку
                     If (mesta[n,m,2]='3') and (mesta[n,m,2]<>mesta[n,m,7]) then
                      begin
                     fl_lock:=false;
                     //проверяем место на блокировку
                      for k:=low(locks) to high(locks) do
                        begin
                         If trim(mesta[n,m,1])=locks[k] then
                             begin
                              fl_lock:=true;
                              try
                              showmessagealt('1 Операция временно недоступна !'+#13+'МЕСТO № '+inttostr(strtoint(mesta[n,m,1]))+' В ПРОДАЖЕ !');
                              except
                                on exception: EConvertError do showmessagealt('1 Операция временно недоступна !'+#13+'МЕСТO № '+(mesta[n,m,1])+' В ПРОДАЖЕ !');
                              end;
                              break;
                             end;
                         end;
                      If fl_lock then continue;
                      end;

                      Form7.ZReadOnlyQuery1.SQL.TextLineBreakStyle:=tlbsLF;
                      try
                      Form7.ZReadOnlyQuery1.SQL.append(quotedstr(trim(inttostr(strtoint(mesta[n,m,1])))+'-'+trim(mesta[n,m,2])+'-')+'||'+quotedstr(''));
                      except
                          on exception: EConvertError do continue;
                      end;
                       //если тот же пользователь или место изменилось
                       If (inttostr(id_user)=mesta[n,m,4]) or (mesta[n,m,2]<>mesta[n,m,7]) then
                       Form7.ZReadOnlyQuery1.SQL.append(quotedstr(trim(mesta[n,m,3])+'---|')+'||'+quotedstr(''))
                        else
                          Form7.ZReadOnlyQuery1.SQL.append(quotedstr(trim(mesta[n,m,3])+'-'+trim(mesta[n,m,4])+'-'+trim(mesta[n,m,5])+'-'+trim(mesta[n,m,6])+'|')+'||'+quotedstr(''));


                      // //если осталась бронь предыдущего диспетчера
                      //If (mesta[n,m,2]=mesta[n,m,7]) AND (mesta[n,m,2]='3') then
                      // begin
                      //   Form7.ZReadOnlyQuery1.SQL.TextLineBreakStyle:=tlbsLF;
                      //   Form7.ZReadOnlyQuery1.SQL.append(quotedstr(trim(inttostr(strtoint(mesta[n,m,1])))+'-'+trim(mesta[n,m,2])+'-')+'||'+quotedstr(''));
                      //   //если тот же пользователь
                      //   If inttostr(id_user)=mesta[n,m,4] then
                      //   Form7.ZReadOnlyQuery1.SQL.append(quotedstr(trim(mesta[n,m,3])+'---|')+'||'+quotedstr(''))
                      //   else
                      //   Form7.ZReadOnlyQuery1.SQL.append(quotedstr(trim(mesta[n,m,3])+'-'+trim(mesta[n,m,4])+'-'+trim(mesta[n,m,5])+'-'+trim(mesta[n,m,6])+'|')+'||'+quotedstr(''));
                      //   continue;
                      //  end;
                  end;
              end;
          end;
  Form7.ZReadOnlyQuery1.SQL.add(',');
  Form7.ZReadOnlyQuery1.SQL.add(full_mas[idx,4]+',');
  //Form7.ZReadOnlyQuery1.SQL.add(full_mas[idx,7]+',');
  Form7.ZReadOnlyQuery1.SQL.add(ConnectINI[14]+',');
  Form7.ZReadOnlyQuery1.SQL.add(quotedstr(tripdate)+',');
  Form7.ZReadOnlyQuery1.SQL.add(inttostr(id_user)+',now(),0);');
  //showmessage('1'+#13+Form7.ZReadOnlyQuery1.SQL.Text);//$
  //showmessage('1'+#13+Form7.ZReadOnlyQuery2.SQL.Text);//$
  Form7.ZReadOnlyQuery1.ExecSQL;
  Form7.ZReadOnlyQuery2.ExecSQL;
  Form7.Zconnection1.Commit;

  //если удаленка, то забираем данные по готовой операции
   If remote_trip then
    Form1.get_disp_oper(Form7.ZReadOnlyQuery2,idx);
  //showmessagealt('ДАННЫЕ УСПЕШНО СОХРАНЕНЫ !');
  except
    If Form7.ZConnection1.InTransaction then
       begin
        Form7.Zconnection1.Rollback;
        //showmessagealt('11');//$
       end;
    Form7.ZConnection1.disconnect;
    showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL1: '+Form7.ZReadOnlyQuery1.SQL.Text);
    exit;
  end;
  Form7.ZConnection1.disconnect;
  Form7.ZReadOnlyQuery2.Close;
  Form7.ZReadOnlyQuery1.Close;
end
 else
   //если транзакция открыта
     begin
      //showmessage('bron_2');//$
      try
          //Проверяем места на блокировку и на факт изменения состояния места
        SetLength(locks,0);
        form1.ZReadOnlyQuery1.sql.Clear;
        form1.ZReadOnlyQuery1.sql.add('select * from seats_in_sale('+quotedstr(tripdate)+','+sale_server+',');
        form1.ZReadOnlyQuery1.sql.add(full_mas[idx,1]+','+quotedstr(full_mas[idx,10])+','+full_mas[idx,4]+','+full_mas[idx,25]+') as sale;');
        //showmessage(form1.ZReadOnlyQuery1.SQL.Text);//$
        form1.ZReadOnlyQuery1.open;
        If form1.ZReadOnlyQuery1.RecordCount=1 then
         begin
          //если есть места в блокировки
           If utf8copy(form1.ZReadOnlyQuery1.FieldByName('sale').asString,1,1)='1' then
            begin
          //переписываем массив мест
           m:=3;
           st1:='';
           for n:=3 to utf8Length(form1.ZReadOnlyQuery1.FieldByName('sale').asString) do
            begin
             // m - текущее начало вырезки
              if UTF8Copy(form1.ZReadOnlyQuery1.FieldByName('sale').asString,n,1)='|' then
               begin
                st1:=UTF8Copy(form1.ZReadOnlyQuery1.FieldByName('sale').asString,m,(n-m));
                //showmessage(st1);//$
                m:=n+1;
                //номер места
                SetLength(locks,Length(locks)+1);
                locks[Length(locks)-1]:=PadL(st1,'0',3);
               end;
            end;
            end;
          end;
  form1.ZReadOnlyQuery1.SQL.Clear;
  form1.ZReadOnlyQuery1.SQL.add('UPDATE av_disp_bron SET del=2 WHERE ');
  form1.ZReadOnlyQuery1.SQL.add('id_shedule='+full_mas[idx,1]+' and ');
  form1.ZReadOnlyQuery1.SQL.add('time_trip='+quotedstr(full_mas[idx,10])+' and ');
  form1.ZReadOnlyQuery1.SQL.add('date_trip='+quotedstr(tripdate)+' AND ot_point_order='+full_mas[idx,4]);
  form1.ZReadOnlyQuery1.SQL.add(';');
  form1.ZReadOnlyQuery1.SQL.add('INSERT INTO av_disp_bron (id_shedule, time_trip, ot_id_point,');
  //form1.ZReadOnlyQuery1.SQL.add('do_id_point, id_ats, id_kontr, bron, ot_point_order, do_point_order,');
  //form1.ZReadOnlyQuery1.SQL.add('id_point, date_trip, id_user, createdate, del) VALUES (');
  form1.ZReadOnlyQuery1.SQL.add('bron, ot_point_order,');
  form1.ZReadOnlyQuery1.SQL.add('id_point, date_trip, id_user, createdate, del) VALUES (');
  form1.ZReadOnlyQuery1.SQL.add(full_mas[idx,1]+',');
  form1.ZReadOnlyQuery1.SQL.add(quotedstr(trim(full_mas[idx,10]))+',');
  form1.ZReadOnlyQuery1.SQL.add(sale_server+',');
  //form1.ZReadOnlyQuery1.SQL.add(full_mas[idx,6]+',');
  //form1.ZReadOnlyQuery1.SQL.add(full_mas[idx,20]+',');
  //form1.ZReadOnlyQuery1.SQL.add(full_mas[idx,18]+',');
  //бронь
        for n:=0 to 49 do
          begin
            for m:=0 to 4 do
              begin
                If trim(mesta[n,m,1])='000' then continue;
                If trim(mesta[n,m,1])='' then continue;
                If (fl_transit and (mesta[n,m,2]='9'))
                OR (trim(mesta[n,m,2])='0')
                or (trim(mesta[n,m,2])='3') then
                   begin
                     //st1:=mesta[n,m,1];
                     //If st1='0' then showmessage(mesta[n,m,1]);
                     //если место не изменилось и с ним ничего не делали
                    If (mesta[n,m,2]=mesta[n,m,7]) and (trim(mesta[n,m,4])='') then
                        begin
                         If (mesta[n,m,2]='0') and not fl_transit then continue;
                         If (mesta[n,m,2]='9') and fl_transit then continue;
                        end;

                     //если место забронировано только сейчаc, то проверяем на блокировку
                     If (mesta[n,m,2]='3') and (mesta[n,m,2]<>mesta[n,m,7]) then
                      begin
                     fl_lock:=false;
                     //проверяем место на блокировку
                      for k:=low(locks) to high(locks) do
                        begin
                         If trim(mesta[n,m,1])=locks[k] then
                             begin
                             fl_lock:=true;
                              try
                              showmessagealt('1 Операция временно недоступна !'+#13+'МЕСТO № '+inttostr(strtoint(mesta[n,m,1]))+' В ПРОДАЖЕ !');
                              except
                                  on exception: EConvertError do continue;
                              end;
                              break;
                             end;
                         end;
                      If fl_lock then continue;
                      end;

                      form1.ZReadOnlyQuery1.SQL.TextLineBreakStyle:=tlbsLF;
                      try
                      form1.ZReadOnlyQuery1.SQL.append(quotedstr(trim(inttostr(strtoint(mesta[n,m,1])))+'-'+trim(mesta[n,m,2])+'-')+'||'+quotedstr(''));
                       except
                                  on exception: EConvertError do continue;
                              end;
                       //если тот же пользователь  или место изменилось
                       If (inttostr(id_user)=mesta[n,m,4]) or (mesta[n,m,2]<>mesta[n,m,7]) then
                       form1.ZReadOnlyQuery1.SQL.append(quotedstr(trim(mesta[n,m,3])+'---|')+'||'+quotedstr(''))
                        else
                          form1.ZReadOnlyQuery1.SQL.append(quotedstr(trim(mesta[n,m,3])+'-'+trim(mesta[n,m,4])+'-'+trim(mesta[n,m,5])+'-'+trim(mesta[n,m,6])+'|')+'||'+quotedstr(''));
                     end;
                  end;
              end;
  form1.ZReadOnlyQuery1.SQL.add(',');
  form1.ZReadOnlyQuery1.SQL.add(full_mas[idx,4]+',');
  //form1.ZReadOnlyQuery1.SQL.add(full_mas[idx,7]+',');
  form1.ZReadOnlyQuery1.SQL.add(ConnectINI[14]+',');
  form1.ZReadOnlyQuery1.SQL.add(quotedstr(tripdate)+',');
  form1.ZReadOnlyQuery1.SQL.add(inttostr(id_user)+',now(),0);');

  //showmessage('2'+#13+form1.ZReadOnlyQuery1.SQL.Text);//$
  //showmessage('2'+#13+form1.ZReadOnlyQuery3.SQL.Text);//$

  form1.ZReadOnlyQuery1.ExecSQL;
  form1.ZReadOnlyQuery3.ExecSQL;
  form1.Zconnection1.Commit;

  //если удаленка, то обновляем инфу по рейсу
   If remote_trip then
    Form1.get_disp_oper(form1.ZReadOnlyQuery3,idx);

  except
     If form1.ZConnection1.InTransaction then
        begin
         form1.Zconnection1.Rollback;
         //showmessage('22');//$
        end;
    showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL2: '+form1.ZReadOnlyQuery1.SQL.Text);
    form1.ZConnection1.disconnect;
    exit;
  end;
  form1.ZConnection1.disconnect;
  form1.ZReadOnlyQuery3.Close;
  form1.ZReadOnlyQuery1.Close;
  //showmessagealt('ДАННЫЕ УСПЕШНО СОХРАНЕНЫ !');
end;


     //если операция по удаленке, то записать локально
   If remote_trip then
    begin
   formmenu.insert_remote_oper(Form7.ZConnection1,Form7.ZReadOnlyQuery1,6,full_mas[idx,13], formatDatetime('dd-mm-yyyy hh:nn:ss',now()));
   //если транзакция еще открыта - откатываемся
    If Form7.Zconnection1.Connected then
      begin
       Form7.ZReadOnlyQuery1.Close;
       If Form7.ZConnection1.InTransaction then Form7.Zconnection1.Rollback;
       Form7.ZConnection1.disconnect;
       end;
   end;


 Form7.Close;
end;


// Обновляем информацию о месте
procedure TForm7.get_info;
var
   n,m:integer;
begin
 // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
 // mesta[n,m,1] - номер места
 // mesta[n,m,2] - статус места
   //0-свободно
   //1-бронь ОПП
   //3-бронь диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-бронь справки
   //8-вычеркнутый билет
   //9-транзит
      // mesto
      Form7.Label25.caption:='';
      // sost
      Form7.Label26.caption:='';
       // prim
      Form7.Label27.caption:='';
      // data
      Form7.Label28.caption:='';
      // fio
      Form7.Label29.caption:='';
      try
     n:=Form7.StringGrid2.Col+((strtoint(Form7.label4.Caption)-1)*25); //место
      except
        on exception: EConvertError do exit;
      end;
     m:=4-Form7.StringGrid2.Row; //ряд

  If length(mesta)=0 then exit;
  // если места нет
  if trim(mesta[n,m,1])='0' then exit;

  // mesto
  Form7.Label25.caption:=trim(mesta[n,m,1]);

  //  // бронь ОПП
  //if (trim(mesta[n,m,2])='1') then
  //   begin
  //    // sost
  //    //Form7.Label26.caption:='ЗАБРОНИРОВАНО ОПП';
  //    // data
  //    Form7.Label28.caption:=trim(mesta[n,m,6]);
  //    // fio
  //    Form7.Label29.caption:='['+mesta[n,m,4]+'] '+mesta[n,m,5];
  //   end;
  //
  //// бронь ДИСПЕТЧЕР
  //if (trim(mesta[n,m,2])='3') then
  //   begin
  //    // sost
  //    //Form7.Label26.caption:='БРОНЬ ДИСПЕТЧЕР';
  //    // prim
  //    Form7.Label27.caption:=trim(mesta[n,m,3]);
  //    // data
  //    Form7.Label28.caption:=trim(mesta[n,m,6]);
  //    // fio
  //    Form7.Label29.caption:='['+mesta[n,m,4]+'] '+mesta[n,m,5];
  //   end;


    // Вычеркнутый билет
  //if (trim(mesta[n,m,2])='8') then
     //begin
      // sost
      //Form7.Label26.caption:='ВЫЧЕРКНУТЫЙ БИЛЕТ';
      // prim remark
      Form7.Label27.caption:=trim(mesta[n,m,3]);
      // data
      Form7.Label28.caption:=trim(mesta[n,m,6]);
      // fio
      If trim(mesta[n,m,4])<>'' then
      Form7.Label29.caption:='['+mesta[n,m,4]+'] '+mesta[n,m,5];
     //end;

   // Место свободно
  case trim(mesta[n,m,2]) of
      '0' : Form7.Label26.caption:='СВОБОДНО';    // sost
      '1' : Form7.Label26.caption:='БРОНЬ ОПП';
      '3' : Form7.Label26.caption:='БРОНЬ ДИСПЕТЧЕР';
      '4' : Form7.Label26.caption:='МЕСТО В ПРОДАЖЕ';
      '5' : Form7.Label26.caption:='МЕСТО ПРОДАНО';
      '7' : Form7.Label26.caption:='БРОНЬ СПРАВКИ';
      '8' : Form7.Label26.caption:='ВЫЧЕРКНУТО';
      '9' : Form7.Label26.caption:='ТРАНЗИТ';
      '11' : Form7.Label26.caption:='НЕСНИМАЕМАЯ БРОНЬ';
      '13' : Form7.Label26.caption:='СПЕЦ БРОНЬ';
      else
        exit;
    end;
end;

// Устанавливаем/снимаем вычеркнутые места
procedure TForm7.Mark;
 var
   n,m:integer;
begin
  // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
 // mesta[n,m,1] - номер места
 // mesta[n,m,2] - статус места
  //0-свободно
   //1-бронь ОПП
   //3-бронь диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-бронь справки
   //8-вычеркнутый билет
   //9-транзит
 //try
 //n:=Form7.StringGrid2.Col+((strtoint(Form7.label4.Caption)-1)*25);
 //except
 //  on exception: EConvertError do exit;
 //end;
 //m:=4-Form7.StringGrid2.Row;
 //
 //  If trim(mesta[n,m,1])='0' then exit; //если нет места
 //  case trim(mesta[n,m,2]) of
 //  //если место продано, то вычеркиваем
 //  '5': mesta[n,m,2]:='8';
 //  //если место вычеркнуто, ставим продано
 //  '8': mesta[n,m,2]:='5';
 //  end;
end;

//установка невидимой брони
procedure TForm7.SetShadowBron();
var
     sost:string='';
     prim:string;
     n,m,mesto,k,l:integer;
  begin
  try
    n:=Form7.StringGrid2.Col+((strtoint(Form7.label4.Caption)-1)*25);
    except
        on exception: EConvertError do
        begin
        showmessagealt('ОШИБКА ! Неверный номер места !');
        exit;
        end;
      end;
    m:=4-Form7.StringGrid2.Row;
   If (trim(mesta[n,m,1])='000') or (trim(mesta[n,m,1])='0') or (trim(mesta[n,m,1])='') then exit; //если нет места
  sost:=trim(mesta[n,m,2]);
  try
    mesto:=strtoint(mesta[n,m,1]);
  except
   on exception: EConvertError do
   begin
    showmessagealt('ОШИБКА ! Неверный номер места !');
    exit;
    end;
  end;
  // Если НЕТ полномочий
  if (sost='13') or (sost='8') or (sost='4')  or (sost='5') or (sost='') then exit;

     //вносим свою бронь
     //prim:=InputBox('УСТАНОВКА НЕСНИМАЕМОЙ БРОНИ','ПРИМЕЧАНИЕ...',prim);
     //if not(prim='') then
       //begin
        mesta[n,m,2]:='13';
        mesta[n,m,3]:=prim;
       //end;
    If mesta[n,m,2]<>'13' then exit;
       // Подключаемся к серверу
    If not(Connect2(Form7.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k19-');
     Form7.close;
     exit;
    end;
    //Открываем транзакцию
try
   If not Form7.ZConnection1.InTransaction then
     begin
      Form7.ZConnection1.StartTransaction;
     end
   else
     begin
       If Form7.ZConnection1.InTransaction then Form7.ZConnection1.Rollback;
       Form7.ZConnection1.disconnect;
        showmessagealt('Ошибка ! Незавершенная транзакция !'+#13+'Попробуйте снова !');
      exit;
     end;
     Form7.ZReadOnlyQuery1.SQL.Clear;
  Form7.ZReadOnlyQuery1.SQL.add('UPDATE av_shadow_bron SET del=1,id_user='+inttostr(id_user)+',createdate=now() WHERE ');
  Form7.ZReadOnlyQuery1.SQL.add('id_shedule='+full_mas[idx,1]+' and mesto='+mesta[n,m,1]);
  Form7.ZReadOnlyQuery1.SQL.add('AND trip_time='+quotedstr(full_mas[idx,10]));
  Form7.ZReadOnlyQuery1.SQL.add('AND trip_date='+quotedstr(tripdate)+' AND ot_id_point='+full_mas[idx,3]);
  Form7.ZReadOnlyQuery1.SQL.add(';');
  Form7.ZReadOnlyQuery1.SQL.add('INSERT INTO av_shadow_bron(id_shedule,ot_id_point,trip_date,trip_time,mesto,remark,id_user,id_point_oper,createdate,del) VALUES (');
  //Form7.ZReadOnlyQuery1.SQL.add('INSERT INTO av_disp_bron (id_shedule, time_trip, ot_id_point,');
  //Form7.ZReadOnlyQuery1.SQL.add('do_id_point, id_ats, id_kontr, bron, ot_point_order, do_point_order,');
  //Form7.ZReadOnlyQuery1.SQL.add('id_point, date_trip, id_user, createdate, del) VALUES (');
  //Form7.ZReadOnlyQuery1.SQL.add('bron, ot_point_order,');
  //Form7.ZReadOnlyQuery1.SQL.add('id_point, date_trip, id_user, createdate, del) VALUES (');
  Form7.ZReadOnlyQuery1.SQL.add(full_mas[idx,1]+','+sale_server+','+quotedstr(tripdate)+','+quotedstr(trim(full_mas[idx,10]))+',');
  Form7.ZReadOnlyQuery1.SQL.add(mesta[n,m,1]+','+Quotedstr(mesta[n,m,3])+',');
  Form7.ZReadOnlyQuery1.SQL.add(inttostr(id_user)+','+ConnectINI[14]+',now(),0);');
  //showmessage('1'+#13+Form7.ZReadOnlyQuery1.SQL.Text);//$
  //showmessage(Form7.ZReadOnlyQuery1.SQL.Text);//$
  Form7.ZReadOnlyQuery1.ExecSQL;
  Form7.Zconnection1.Commit;

  except
    If Form7.ZConnection1.InTransaction then
       begin
        Form7.Zconnection1.Rollback;
        //showmessagealt('11');//$
       end;
    Form7.ZConnection1.disconnect;
    showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+Form7.ZReadOnlyQuery1.SQL.Text);
    exit;
  end;

end;

//установка невидимой брони
procedure TForm7.UNSetShadowBron();
var
     sost:string='';
     prim:string;
     n,m,mesto,k,l:integer;
  begin
  try
    n:=Form7.StringGrid2.Col+((strtoint(Form7.label4.Caption)-1)*25);
    except
        on exception: EConvertError do
        begin
        showmessagealt('ОШИБКА ! Неверный номер места !');
        exit;
        end;
      end;
    m:=4-Form7.StringGrid2.Row;
   If (trim(mesta[n,m,1])='000') or (trim(mesta[n,m,1])='0') or (trim(mesta[n,m,1])='') then exit; //если нет места
  sost:=trim(mesta[n,m,2]);
  try
    mesto:=strtoint(mesta[n,m,1]);
  except
   on exception: EConvertError do
   begin
    showmessagealt('ОШИБКА ! Неверный номер места !');
    exit;
    end;
  end;

  if (sost<>'13') then exit;

       // Подключаемся к серверу
    If not(Connect2(Form7.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k19-');
     Form7.close;
     exit;
    end;
    //Открываем транзакцию
try
   If not Form7.ZConnection1.InTransaction then
     begin
      Form7.ZConnection1.StartTransaction;
     end
   else
     begin
       If Form7.ZConnection1.InTransaction then Form7.ZConnection1.Rollback;
       Form7.ZConnection1.disconnect;
        showmessagealt('Ошибка ! Незавершенная транзакция !'+#13+'Попробуйте снова !');
      exit;
     end;
     Form7.ZReadOnlyQuery1.SQL.Clear;
  Form7.ZReadOnlyQuery1.SQL.add('UPDATE av_shadow_bron SET del=1,id_user='+inttostr(id_user)+',createdate=now() WHERE ');
  Form7.ZReadOnlyQuery1.SQL.add('id_shedule='+full_mas[idx,1]+' and mesto='+mesta[n,m,1]);
  Form7.ZReadOnlyQuery1.SQL.add('AND trip_time='+quotedstr(full_mas[idx,10]));
  Form7.ZReadOnlyQuery1.SQL.add('AND trip_date='+quotedstr(tripdate)+' AND ot_id_point='+full_mas[idx,3]);
  Form7.ZReadOnlyQuery1.SQL.add(';');
  //showmessage(Form7.ZReadOnlyQuery1.SQL.Text);//$
  Form7.ZReadOnlyQuery1.ExecSQL;
  Form7.Zconnection1.Commit;
   //если рейс транзитный - то установить транзит обратно
        If fl_transit then mesta[n,m,2]:='9'
         else  mesta[n,m,2]:='0';
  except
    If Form7.ZConnection1.InTransaction then
       begin
        Form7.Zconnection1.Rollback;
        //showmessagealt('11');//$
       end;
    Form7.ZConnection1.disconnect;
    showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+Form7.ZReadOnlyQuery1.SQL.Text);
    exit;
  end;
end;


// Ставим бронь где возможно или снимаем
procedure TForm7.Check_bron;
 var
    sost:string='';
     n,m,mesto,k,l:integer;
begin
  // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
 // mesta[n,m,1] - номер места
 // mesta[n,m,2] - статус места
  //0-свободно
   //1-бронь ОПП
   //3-бронь диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-бронь справки
   //8-вычеркнутый билет
   //9-транзит
   //11-неснимаемая бронь
   //13-shadow_bron

   // Если место пустое то просто отвал
   //if trim(form1.StringGrid2.Cells[form1.StringGrid2.Col,form1.StringGrid2.row])='' then exit;
    try
    n:=Form7.StringGrid2.Col+((strtoint(Form7.label4.Caption)-1)*25);
    except
        on exception: EConvertError do
        begin
        showmessagealt('ОШИБКА ! Неверный номер места !');
        exit;
        end;
      end;
    m:=4-Form7.StringGrid2.Row;
   If (trim(mesta[n,m,1])='000') or (trim(mesta[n,m,1])='0') or (trim(mesta[n,m,1])='') then exit; //если нет места
  sost:=trim(mesta[n,m,2]);
  try
    mesto:=strtoint(mesta[n,m,1]);
  except
   on exception: EConvertError do
   begin
    showmessagealt('ОШИБКА ! Неверный номер места !');
    exit;
    end;
  end;
  //showmessage(sost+' '+sost2);
  // Если НЕТ полномочий
  if (sost='13') or (sost='11') or (sost='8') or (sost='4')  or (sost='5') or (sost='') then exit;


  flchange:=true;//флаг внесения изменения

  //Check_bron

  // Если транзит то снимаем
  if sost='9' then
    begin
     mesta[n,m,2]:='0';
     mesta[n,m,3]:='';
     //mesta[n,m,4]:='';
     //mesta[n,m,5]:='';
    end;

  // Если свободно то ставим бронь ДИСПЕТЧЕРА
  if sost='0' then
    begin
     //если была чужая бронь - возвращаем
      If (mesta[n,m,7]='3') then
         begin
          mesta[n,m,2]:=mesta[n,m,7];
          mesta[n,m,3]:=mesta[n,m,8];
          exit;
         end;
      //вносим свою бронь

     prim:=InputBox('БРОНИРОВАНИЕ МЕСТ ДИСПЕТЧЕРОМ','ПРИМЕЧАНИЕ...',prim);
     if not(prim='') then
       begin
        mesta[n,m,2]:='3';
        mesta[n,m,3]:=prim;
       end;
    end;

  // Если снимаем броню ДИСПЕТЧЕРА или ОПП или справки
  if (sost='3') or (sost='1') or (sost='7') then
    begin
     prim:='';
    if (sost='3') or (sost='7') then
     //если была бронь другого пользователя
     If (mesta[n,m,4]<>'') and (mesta[n,m,4]<>inttostr(id_user)) then
      If DialogMess('Подтверждаете снятие брони с места ?')=7 then exit;
      //если была бронь ОПП или справки - возвращаем
      If (sost='3') and ((mesta[n,m,7]='1') or (mesta[n,m,7]='7')) then
         begin
          //showmessage(mesta[n,m,7]+#13+mesta[n,m,8]);
          mesta[n,m,2]:=mesta[n,m,7];
          mesta[n,m,3]:=mesta[n,m,8];
         end
      else
       begin
       //если рейс транзитный - то установить транзит обратно
        If fl_transit then mesta[n,m,2]:='9'
         else  mesta[n,m,2]:='0';
       end;
    end;

   //bit:=false;
   If trim(label4.Caption)='1' then
   begin
   k:=0;
   l:=24;
   end
 else
  begin
   k:=25;
   l:=49;
   end;
   // ищем подходящее место, куда стать, больше текущего
      for n:=k to l do
        begin
            for m:=0 to 4 do
              begin
               try
               if (strtoint(mesta[n,m,1])=mesto+1) then
                 begin
                 //если статус найденого места не соответствует, ищем место дальше
                   If (trim(mesta[n,m,2])='4') OR (trim(mesta[n,m,2])='5') OR (trim(mesta[n,m,2])='8') OR (trim(mesta[n,m,2])='11') then
                   begin
                     mesto:=mesto+1;
                     continue;
                   end;
                   ////если место на втором этаже
                   //If ((n-25)>=0) then
                   // begin
                   //  If (trim(label4.Caption)='1') then
                   //     begin
                   //     change_layer();
                   //     bit:=true;
                   //     end;
                   // end
                   //else
                   // //если место на 1 первом этаже
                   //begin
                   //  If (trim(label4.Caption)='2') then
                   //  begin
                   //     change_layer();
                   //     bit:=true;
                   //  end;
                   //end;

                   // Ставим место
                   Form7.StringGrid2.row:=4-m;
                   If (n-25)>=0 then
                   Form7.StringGrid2.col:=n-25
                   else
                   Form7.StringGrid2.col:=n;
                   Form7.StringGrid2.Refresh;
                   //showmessage('k='+inttostr(k)+' - '+'trim(mesta[n,m,1])='+trim(mesta[n,m,1])+'  row='+inttostr(n)+' col='+inttostr(m));
                   exit;
                 end;
               except
                 continue;
               end;
              end;
         end;


   //меняем этаж , - ищем заново
    change_layer();
 If trim(label4.Caption)='1' then
   begin
   k:=0;
   l:=24;
   end
 else
  begin
   k:=25;
   l:=49;
   end;

      for n:=k to l do
        begin
            for m:=0 to 4 do
              begin
               try
               if (strtoint(mesta[n,m,1])=mesto+1) then
                 begin
                 //если статус найденого места не соответствует, ищем место дальше
                   If (trim(mesta[n,m,2])='4') OR (trim(mesta[n,m,2])='5') OR (trim(mesta[n,m,2])='8') OR (trim(mesta[n,m,2])='11') then
                   begin
                     mesto:=mesto+1;
                     continue;
                   end;
                   //если место на втором этаже
                   //If ((n-25)>=0) then
                   // begin
                   //  If (trim(label4.Caption)='1') then
                   //     begin
                   //     change_layer();
                   //     bit:=true;
                   //     end;
                   // end
                   //else
                   // //если место на 1 первом этаже
                   //begin
                   //  If (trim(label4.Caption)='2') then
                   //  begin
                   //     change_layer();
                   //     bit:=true;
                   //  end;
                   //end;

                   // Ставим место
                   Form7.StringGrid2.row:=4-m;
                   If (n-25)>=0 then
                   Form7.StringGrid2.col:=n-25
                   else
                   Form7.StringGrid2.col:=n;
                   Form7.StringGrid2.Refresh;
                   //showmessage('k='+inttostr(k)+' - '+'trim(mesta[n,m,1])='+trim(mesta[n,m,1])+'  row='+inttostr(n)+' col='+inttostr(m));
                   exit;
                 end;
               except
                 continue;
               end;
         end;
      end;

      mesto:=0;
    // Если не найдено от текущего то ищем сначала
       for n:=0 to 49 do
        begin
            for m:=0 to 4 do
              begin
               try
               if (strtoint(mesta[n,m,1])=mesto+1) then
                 begin
                 //если статус найденого места не соответствует, ищем место дальше
                    If (trim(mesta[n,m,2])='4') OR (trim(mesta[n,m,2])='5') OR (trim(mesta[n,m,2])='8') OR (trim(mesta[n,m,2])='11') then
                   begin
                     mesto:=mesto+1;
                     continue;
                   end;
                     //если место на втором этаже
                   If ((n-25)>=0) then
                    begin
                     If (trim(label4.Caption)='1') then change_layer();
                    end
                   else
                    //если место на 1 первом этаже
                   begin
                     If (trim(label4.Caption)='2') then change_layer();
                   end;
                   // Ставим место
                   Form7.StringGrid2.row:=4-m;
                   If (n-25)>=0 then
                   Form7.StringGrid2.col:=n-25
                   else
                   Form7.StringGrid2.col:=n;
                   Form7.StringGrid2.Refresh;
                   //showmessage('k='+inttostr(k)+' - '+'trim(mesta[n,m,1])='+trim(mesta[n,m,1])+'  row='+inttostr(n)+' col='+inttostr(m));
                   exit;
                 end;
               except
                 continue;
               end;
              end;
  end;
end;


//******************************** заполнить грид номерами мест ********************************
procedure TForm7.fill_grid;
 var
   n,m,k,mesto,min,x,y:integer;
begin
 mesto:=999;
 x:=0;//координаты установки фокуса
 y:=0;//координаты установки фокуса
 if trim(Form7.label4.Caption)='1' then k:=0 else k:=25;
 If length(mesta)=0 then exit;

 for n:=0 to 24 do
   begin
     for m:=0 to 4 do
      begin
        //обнуляем ячейку
       Form7.StringGrid2.Cells[n,4-m]:='';
        try
        // Номер места
        if not(strtoint(mesta[n+k,m,1])=0) then
        begin
        //поиск минимального места в карте
          //If strtoint(mesta[n+k,m,1])<mesto then
          //begin
           //mesto:=strtoint(mesta[n+k,m,1]);
           //x:=n;
           //y:=4-m;
          //end;
           Form7.StringGrid2.Cells[n,4-m]:=inttostr(strtoint(mesta[n+k,m,1]));
         end;
        except
          continue;
        end;
      end;
   end;
end;


procedure TForm7.StringGrid2DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
  tw,th:integer;
begin
 with Sender as TStringGrid, Canvas do
 begin
   If length(mesta)=0 then exit;
   // Фон по сотсоянию места
    // mesta[n,m,0] - тип места 1-сидя,2-стоя,3-лежа
 // mesta[n,m,1] - номер места
 // mesta[n,m,2] - статус места
  //0-свободно
   //1-бронь ОПП
   //3-бронь диспетчера
   //4-продается
   //5-продан
   //6-выбран самим для продажи
   //7-бронь справки
   //8-вычеркнутый билет
   //9-транзит
    //13-shadow bron
  // Если Свободное
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='0' then
       begin
        Font.Color := clMaroon;
        brush.Color:=clWhite;
       end;

   // Если неактивное
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,1])='0' then
       begin
        brush.Color:=clSilver;
       end;

   // Если ОПП
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='1' then
       begin
        brush.Color:=$00ff8e4c;
        Font.Color := clWhite;
       end;

      // Если неснимаемая бронь ОПП
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='11' then
       begin
        brush.Color:=$00CB0909;
        Font.Color := clWhite;
       end;

   // Если ДИСПЕТЧЕР
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='3' then
       begin
        brush.Color:=$0088F5F6;
        Font.Color := clBlack;
       end;

     // Если Продано
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='5' then
       begin
        brush.Color:=$00A5A5EF;
        Font.Color := clBlack;
       end;

      // Если в продаже
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='4' then
       begin
        brush.Color:= clRed;
        Font.Color := clBlack;
       end;

     // Если бронь СПРАВКИ
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='7' then
       begin
        brush.Color:=$0086AF8E;
        Font.Color := clWhite;
       end;

    // Если Вычеркнутый
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='8' then
       begin
        brush.Color:=clBlack;
        Font.Color := clWhite;
       end;

    // Если Транзит
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='9' then
       begin
        brush.Color:=clGray;
        Font.Color := clWhite;
       end;

    // Если невидимая бронь
   if trim(mesta[aCol+((strtoint(Form7.label4.Caption)-1)*25),4-aRow,2])='13' then
       begin
        brush.Color:=$00CB26EF;
        Font.Color := clBlack;
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


procedure TForm7.StringGrid2Selection(Sender: TObject; aCol, aRow: Integer);
begin
 //showmessage('fsabgd');
  Form7.get_info;
end;

procedure TForm7.FormPaint(Sender: TObject);
begin
   Form7.Canvas.Brush.Color:=clSilver;
   Form7.Canvas.Pen.Color:=clBlack;
   Form7.Canvas.Pen.Width:=2;
   Form7.Canvas.Rectangle(2,2,Form7.Width-2,Form7.Height-2);
end;


//**************************************************  HOT KEYS **********************************************
procedure TForm7.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState  );
var
  n,l,k:integer;
begin
  //if not(Key=16) then
 //SHOWMEssage(inttostr(key));//$
    // ESC
   if (Key=27) then
       begin
        key:=0;
         Form7.Close;
          exit;
       end;

   // F1 - Справка
   if (Key=112) then showmessagealt('F1 - СПРАВКА'+#13+'F2 - ЭТАЖ СМЕНИТЬ'+#13+'F8 - СПЕЦ БРОНЬ установка'+#13+'F9 - СПЕЦ БРОНЬ снятие'+#13
   +'F12 - СОХРАНИТЬ ИЗМЕНЕНИЯ'+#13+'ПРОБЕЛ - БРОНЬ СНЯТЬ/УСТАНОВИТЬ'+#13+'DEL - ВЫЧЕРКНУТЬ БИЛЕТ'+#13+'ESC - ВЫХОД');

   // F2 - Смена этажа
   if (Key=113) then
       begin
        key:=0;
         Form7.change_layer();
         exit;
       end;

   // F6 - Печать ведомости
    if (Key=117) and remote_trip then
       begin
        key:=0;
        form1.Vedom_get(idx,0); //вывод списка ведомостей на печать
        exit;
       end;
    // F8 - Установка shadow_bron
    if (Key=119) then
       begin
        key:=0;
        If specbron then
        begin
        Form7.SetShadowBron();
        Form7.fill_grid;
        Form7.get_info;
        end;
        exit;
       end;

    // F9 - Снятие shadow_bron
    if (Key=120) then
       begin
        key:=0;
        If specbron then
        begin
        Form7.UNSetShadowBron();
        Form7.fill_grid;
        Form7.get_info;
        end;
        exit;
       end;

   // F12 - Запись операции в базу
   if (Key=123) and bron_edit then
       begin
         key:=0;
         form1.paintmess(Form7.StringGrid2,'ЗАПИСЬ В БАЗУ ! ПОДОЖДИТЕ...',clRed);
         //запрет записи брони в базу другого реального сервера
           //If remote_trip and not form1.virt_server() then
           //begin
             //showmessagealt('Операция ЗАПРЕЩЕНА ! '+#13+'Для УДАЛЕННОГО подразделения');
             //exit;
           //end;
         If bron_edit then Save_bron();
         //If fl_unused then Save_unused();
         exit;
       end;

   // Если DEL на Grid
   //if (Key=46) and fl_unused then
   //    begin
   //      key:=0;
   //       flchange:=true;
   //     Form7.mark;
   //     Form7.fill_grid;
   //     Form7.get_info;
   //      exit;
   //    end;

   // Если пробел на Grid
   if (Key=32) and bron_edit then
       //and (Form7.StringGrid2.Focused=true)
       begin
        key:=0;
        //Form7.StringGrid2.SetFocus;
        Form7.Check_bron;
        Form7.fill_grid;
        Form7.get_info;
        exit;
       end;

   //вверх
   If (Key=38) then
   begin
   key:=0;
   n:=0;
   l:=Form7.StringGrid2.Col+((strtoint(Form7.label4.Caption)-1)*25);
   k:=Form7.StringGrid2.Row;
     while n<5 do
   begin
    n:=n+1;
    k:=k-1;
    If k<0 then k:=4;
   //если нет места
    If trim(Form7.StringGrid2.Cells[Form7.StringGrid2.Col,k])<>'' then
   begin
      // Ставим место
     Form7.StringGrid2.row:=k;
     //If (n-25)>=0 then
     //Form7.StringGrid2.col:=n-25
      //else
     //Form7.StringGrid2.col:=n;
     Form7.StringGrid2.Refresh;
     break;
   end;
   end;
   exit;
   end;

   //вниз
   If (Key=40) and Form7.StringGrid2.Focused then
   begin
   key:=0;
   n:=0;
   l:=Form7.StringGrid2.Col+((strtoint(Form7.label4.Caption)-1)*25);
   k:=Form7.StringGrid2.Row;
     while n<5 do
   begin
    n:=n+1;
    k:=k+1;
    If k>4 then k:=0;
   //если нет места
   If trim(Form7.StringGrid2.Cells[Form7.StringGrid2.Col,k])<>'' then
   begin
      // Ставим место
     Form7.StringGrid2.row:=k;
     Form7.StringGrid2.Refresh;
     break;
   end;
   end;
   exit;
   end;

     //вниз
   If (Key=40) and Form7.StringGrid2.Focused then
   begin
   key:=0;
   n:=0;
   l:=Form7.StringGrid2.Col+((strtoint(Form7.label4.Caption)-1)*25);
   k:=Form7.StringGrid2.Row;
     while n<5 do
   begin
    n:=n+1;
    k:=k+1;
    If k>4 then k:=0;
   //если нет места
   If trim(Form7.StringGrid2.Cells[Form7.StringGrid2.Col,k])<>'' then
   begin
      // Ставим место
     Form7.StringGrid2.row:=k;
     Form7.StringGrid2.Refresh;
     break;
   end;
   end;
   exit;
   end;

     //вправо
   If (Key=39) and Form7.StringGrid2.Focused then
   begin
   key:=0;
   n:=0;
   l:=Form7.StringGrid2.Col;
   k:=Form7.StringGrid2.Row;
     while n<25 do
   begin
    n:=n+1;
    l:=l+1;
    If l>24 then l:=0;
   //если есть места
   If trim(Form7.StringGrid2.Cells[l,Form7.StringGrid2.Row])<>'' then
   begin
      // Ставим место
     Form7.StringGrid2.col:=l;
     Form7.StringGrid2.Refresh;
     break;
   end;
   end;
   exit;
   end;

        //вправо
   If (Key=37) and Form7.StringGrid2.Focused then
   begin
   key:=0;
   n:=0;
   l:=Form7.StringGrid2.Col;
   k:=Form7.StringGrid2.Row;
     while n<25 do
   begin
    n:=n+1;
    l:=l-1;
    If l<0 then l:=24;
   //если есть места
   If trim(Form7.StringGrid2.Cells[l,Form7.StringGrid2.Row])<>'' then
   begin
      // Ставим место
     Form7.StringGrid2.col:=l;
     Form7.StringGrid2.Refresh;
     break;
   end;
   end;
   exit;
   end;
end;


procedure TForm7.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SetLength(mesta,0,0,0);
  mesta:=nil;
  flchange:=false;
  bron_edit:=false;
  setlength(locks,0);
  locks:=nil;
  specbron:=false;
  //sale_server:=trim(connectini[14]);
  //remote_ind:=-1;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;


// Настраиваем форму
procedure TForm7.set_form;
var
   n,m,k,mesto,min,x,y:integer;
begin
 // Определяем номер элемента в массиве
 idx:=-1;
 idx:= masindex;
 If (idx<0) or (idx>high(full_mas)) then
   begin
     showmessagealt('Данный рейс НЕ НАЙДЕН !');
     Form7.Close;
    exit;
   end;
   If (trim(full_mas[idx,22])='') or (full_mas[idx,22]='0') then
   begin
     showmessagealt('Данный рейс неактивен !');
     Form7.Close;
     exit;
   end;

  tripdate:=datetostr(work_date);
 remote_trip:=false;
 //проверка на удаленный рейс
 If (full_mas[idx,0]='3') or (full_mas[idx,0]='4') then
  begin
  remote_trip:=true;
  sale_server:=full_mas[idx,45];
  //если операция по удаленке, то записать локально
   formmenu.insert_remote_oper(Form7.ZConnection1,Form7.ZReadOnlyQuery1,6,full_mas[idx,13], (full_mas[idx,30]+' '+full_mas[idx,31]));
   //если транзакция еще открыта - откатываемся
    If Form7.Zconnection1.Connected then
      begin
       Form7.ZReadOnlyQuery1.Close;
       If Form7.ZConnection1.InTransaction then Form7.Zconnection1.Rollback;
       Form7.ZConnection1.disconnect;
       end;
  end;
 If (full_mas[idx,0]='5') then
 begin
   remote_trip:=true;
  sale_server:=full_mas[idx,45];
  end;

 // Подключаемся к серверу
 If not(Connect2(Form7.Zconnection1, 1)) then
   begin
        showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k20-');
        Form7.close;
        exit;
   end;

 //если удаленка и текущее время меньше даты в времени отправления рейса, то недоступно
 If remote_trip then
    begin
      tripdate:=full_mas[idx,11];
     //showmessage('удаленка ');//$
    Form7.Label33.Visible:=true;
    Form7.Label35.Visible:=true;
    Form7.Label38.Caption:=otkuda_name;
    Form7.Label38.Visible:=true;
    bron_edit:=true;
    //fl_unused:=true;
    //если бронирование и текущее время больше даты в времени отправления рейса, то недоступно
    If not(full_mas[idx,0]='5') then
     If (strtodatetime(full_mas[idx,11]+' '+full_mas[idx,10],MySettings)<now()) then bron_edit:=false;
    //If (strtodatetime(full_mas[idx,11],mySettings)+1+strtodatetime(full_mas[idx,10],MySettings)<now()) then bron_edit:=false;
    //если удаленка и текущее время меньше даты в времени отправления рейса, то недоступно
     //If (strtodatetime(full_mas[idx,11],mySettings)+1+strtodatetime(full_mas[idx,10])>now()) then fl_unused:=false;
    end;

  form1.paintmess(Form7.StringGrid2,'ЗАГРУЗКА ДАННЫХ ! ПОДОЖДИТЕ...',clBlue);
 //********** если проставление вычеркнутых - проверяем, что рейс отправлен
 //If fl_unused then AND not check_trip() then
 //   begin
 //    Form7.Close;
 //    exit;
 //   end;

 // строка наименование рейса
 Form7.Label37.Caption:='['+trim(full_mas[idx,1])+']  '+trim(full_mas[idx,5])+' - '+trim(full_mas[idx,8])+'  Время отпр-я: '+trim(full_mas[idx,10])+'  '+tripdate;

 // Наименование перевозчика
 //tek_id_atp:=strtoint(trim(full_mas[idx,18]));
 Form7.Label8.Caption:= UpperALL('['+trim(full_mas[idx,18])+'] '+trim(full_mas[idx,19]));
 //form2.edit1.Text:='['+trim(full_mas[idx,18])+'] '+trim(full_mas[idx,19]);

 // id и наименование АТС
 try
 tek_id_ats:= strtoint(trim(full_mas[idx,20]));
 except
        on exception: EConvertError do
        begin
        showmessagealt('Неверный номер Автобуса !');
        exit;
        end;
 end;
 Form7.Label9.Caption:= UpperAll('['+trim(full_mas[idx,20])+'] '+trim(full_mas[idx,21]));

 // ТИП РЕЙСА
 tek_type_rejs:='1'; //по умолчанию - ФОРМИРУЮЩИЙСЯ
 tek_type_rejs:=trim(full_mas[idx,9]);
 fl_transit:=false;
 If tek_type_rejs='0' then fl_transit:=true;
 Form7.Label10.Caption:=IFTHEN(not fl_transit,'ФОРМИРУЮЩИЙСЯ','ТРАНЗИТНЫЙ');

 IF trim(full_mas[idx,0])='2' THEN
    begin
     Form7.Label10.Caption:='ЗАКАЗНОЙ';
     //tek_type_rejs:='3';
    end;

 // Количество этажей

 // Мест всего
 Form7.Label12.Caption:=trim(full_mas[idx,25]);

 // ТИП АТС
 Form7.Label13.Caption:=IFTHEN(trim(full_mas[idx,27])='1','М2','М3');


 // Загрузка мест в карту АТС
 Form7.zagruzka_mest;

      //загрузить диспетчерские операции для удаленного рейса
      //If Form7.ZConnection1.Connected then form1.get_disp_oper(Form7.ZReadOnlyQuery1,idx);

 //проверяем статусы мест
 If Form7.ZConnection1.Connected then Form7.fill_mas_seats;

 If Form7.ZConnection1.Connected then
    begin
        If Form7.ZConnection1.InTransaction then Form7.Zconnection1.Rollback;
        Form7.ZConnection1.Disconnect;
        Form7.ZReadOnlyQuery1.Close;
    end;

 // Рисуем GRID
 Form7.fill_grid;

 //******************************** заполнить грид номерами мест ********************************

 mesto:=999;
 x:=0;//координаты установки фокуса
 y:=0;//координаты установки фокуса
 if trim(Form7.label4.Caption)='1' then k:=0 else k:=25;
 If length(mesta)=0 then exit;

 for n:=0 to 24 do
   begin
     for m:=0 to 4 do
      begin
        try
        // Номер места
        if not(strtoint(mesta[n+k,m,1])=0) then
        begin
        //поиск минимального места в карте
          If strtoint(mesta[n+k,m,1])<mesto then
          begin
           mesto:=strtoint(mesta[n+k,m,1]);
           x:=n;
           y:=4-m;
          end;
         end;
        except
          continue;
        end;
      end;
   end;
  Form7.StringGrid2.SetFocus;
  Form7.StringGrid2.Col:=x;
  Form7.StringGrid2.Row:=y;

 // Расставляем информацию и элементы если режим редактирования
 //if bron_edit or fl_unused then
     Form7.get_info;

end;


//******************************************* ВОЗНИКНОВЕНИЕ ФОРМЫ ************************************
procedure TForm7.FormShow(Sender: TObject);
begin
 //Выравниваем форму
 Form7.Left:=form1.Left+(form1.Width div 2)-(Form7.Width div 2);
 Form7.Top:=form1.Top+(form1.Height div 2)-(Form7.Height div 2);

 fl_transact:=true;
 prim:='';
 Form7.set_form;
  flchange:=false;
end;


end.

