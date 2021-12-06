unit Unused;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,  LazFileUtils, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Grids,strutils;

type

  { TForm9 }

  TForm9 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label33: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label44: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    StringGrid1: TStringGrid;
    ZConnection1: TZConnection;
    ZReadOnlyQuery4: TZReadOnlyQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //Сохраняем Вычеркнутые
    procedure Save_unused();
    //загрузка мест в грид
    procedure mesta_load;
    //Настраиваем форму
    procedure set_form;
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure user_group;
    function timecontrol():boolean;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form9: TForm9;

implementation

 uses
  platproc,maindisp,menu;

var
  flchange:boolean;
  tek_type_rejs,tripdate:string;
  locks:array of string;
  idx:integer=-1;
  remote_trip:boolean;
  //deny:boolean=false;
  flg:integer;
  wid:integer;
  fact_time,plan_time: Tdatetime;


{$R *.lfm}

{ TForm9 }


function TForm9.timecontrol():boolean;
var
  curdate,curtime:string;
  //razn:string;
begin
 result := true;
 if id_user=1 then exit;

 If remote_trip then exit;

 //если виртуальный сервер - нахрен все запреты
  If form1.virt_server()  then exit;


  // Подключаемся к серверу
    If not(Connect2(Form9.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     Form9.close;
     exit;
    end;


   //запрос списка мест из av_str_ats
   form9.ZReadOnlyQuery4.SQL.Clear;
   form9.ZReadOnlyQuery4.SQL.add('Select now();');
   //showmessage(form9.ZReadOnlyQuery4.SQL.Text);//$
 try
      form9.ZReadOnlyQuery4.open;
 except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+form9.ZReadOnlyQuery4.SQL.Text);
       form9.ZReadOnlyQuery4.Close;
       form9.Zconnection1.disconnect;
       exit;
 end;
   if form9.ZReadOnlyQuery4.RecordCount>0 then
     begin
       curdate:=FormatDateTime('dd-mm-yyyy',form9.ZReadOnlyQuery4.Fields[0].AsDateTime);
       curtime:=FormatDateTime('hh:nn',     form9.ZReadOnlyQuery4.Fields[0].AsDateTime);
     end;
    form9.ZReadOnlyQuery4.Close;
    Form9.ZConnection1.Disconnect;
   if (curdate='') or (curtime='') then exit;

    //****** Проверка на возможность вычеркивания по времени *****//

   //если не сегодняшний день то без вариантов
    If strtodate(tripdate)<=(strtodate(curdate) - days_before) then
    begin
      result:=true;
    end;
    //если текущий день то смотреть на настройку по дням
     If (strtodate(tripdate)=strtodate(curdate)) and
        ((days_before=0) or (strtodate(tripdate)=strtodate(curdate) - days_before +1)) then
    begin
   try
    If trim(full_mas[idx,10])<>'' then
       plan_time:=strtotime(full_mas[idx,10]);
    If trim(full_mas[idx,31])<>'' then
      begin
       fact_time:=strtotime(full_mas[idx,31]);
      If plan_time>fact_time then fact_time:=plan_time;
      end;
   except
       showmessagealt('Ошибка определения времени отправления рейса !');
        exit;
   end;
   //если рейс не отработал или уже прошло время на вычеркивание - ЗАПРЕТ
   //showmessage(timetostr(time())+' '+ timetostr(fact_time));
   If unused_critical_time>0 then
      IF (strtotime(curtime)-fact_time)>un_critical_time then result:=false;
   end;
    //showmessage(timetostr(time()-fact_time)+#13+timetostr(fact_time)+#13+timetostr(un_critical_time));
    //******                       *****//

end;

// Сохраняем Вычеркнутые
procedure TForm9.Save_unused();
var
   n,m,k,nseat:integer;
   seat_status,tmp:string;
   tip:string='';
   untip:string='';
   yep:boolean = false;
begin
    If not flchange then
    begin
        If form9.ZConnection1.Connected then
           begin
            If form9.ZConnection1.InTransaction then form9.Zconnection1.Rollback;
            form9.ZConnection1.disconnect;
           end;
         If Form9.ZConnection1.Connected then
           begin
            If Form9.ZConnection1.InTransaction then Form9.Zconnection1.Rollback;
            Form9.ZConnection1.disconnect;
           end;
          showmessagealt('Изменений не было !');
          Form9.Close;
          exit;
      end;

  //Если операция не в транзакции, то открываем повторно
  If not form1.ZConnection1.Connected then
     begin
      showmessagealt('ОШИБКА Транзакции ! Обратитесь к администратору !');//$
     end
 else
    //если транзакция открыта
     begin
      //showmessage('unused_2');//$
      try
   //(ищем вычеркнутые билеты и багаж, отправляющиеся с данного пунтка по этому рейсу)
   form1.ZReadOnlyQuery1.sql.Clear;
   form1.ZReadOnlyQuery1.SQL.add('SELECT unused,mesto,(CASE type_ticket WHEN 1 THEN ticket_num WHEN 2 THEN bagage_num END) as ticket  FROM av_ticket ');
   form1.ZReadOnlyQuery1.SQL.add(' WHERE type_oper=1 and (sum_cash>0 or sum_credit>0) AND id_ot='+sale_server);//+' AND mesto='+mesta[n,m,1]);
   form1.ZReadOnlyQuery1.SQL.add(' AND trip_date='+Quotedstr(tripdate));
   form1.ZReadOnlyQuery1.SQL.add(' AND trip_time='+quotedstr(full_mas[idx,10]));
   form1.ZReadOnlyQuery1.SQL.add(' AND id_shedule='+full_mas[idx,1]+';');
   //showmessage(form1.ZReadOnlyQuery1.SQL.Text);//$
    //try
       form1.ZReadOnlyQuery1.open;//*
    //except
      //If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
      //form1.ZConnection1.disconnect;
       //showmessagealt('Операция временно недоступна !'+#13+'С данным местом уже работают !');
       //exit;
    //end;
   If form1.ZReadOnlyQuery1.RecordCount=0 then
      begin
       If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
       form1.ZConnection1.disconnect;
       showmessagealt('ОШИБКА ! НЕТ ДАННЫХ ПО ЗАПРАШИВАЕМЫМ МЕСТАМ !');
       form9.close;
       exit;
      end;

   yep:=false;
   //проверяем все места этого рейса  на факт изменения состояния места
   //(ищем вычеркнутые билеты и багаж, отправляющиеся с данного пунтка по этому рейсу)
   for k:=1 to form1.ZReadOnlyQuery1.RecordCount do
     begin
      for n:=1 to Form9.StringGrid1.Rowcount-1 do  // Место
       begin
       try
        nseat:=strtoint(Form9.StringGrid1.Cells[1,n]);
       except
          continue;
       end;
       If nseat=form1.ZReadOnlyQuery1.FieldByName('mesto').AsInteger then
           begin
            //сверяем номера чеков
             If Form9.StringGrid1.Cells[7,n]<>form1.ZReadOnlyQuery1.FieldByName('ticket').AsString then continue;
             seat_status:= trim(Form9.StringGrid1.Cells[0,n]);
        If seat_status='' then continue;
        //если статус не изменился
        If seat_status=form1.ZReadOnlyQuery1.FieldByName('unused').AsString then break;  //если место не продано или не вычеркнуто, то не наш случай
        //проверка прав
        writelog('Вычеркивание: shed='+full_mas[idx,1]+' trip_time='+full_mas[idx,10]+' mesto='+inttostr(nseat)+' unused='+seat_status+' client_time='+timetostr(time()));

        //вычеркнуть
        If seat_status='1' then
           begin
            tip:='0'; //не было вычеркнуто
           end;
        //восстановить
        If seat_status='0' then
           begin
            tip:='1'; //было вычеркнуто
           end;

   //добавляем в запрос к данным по дисп.операции, данные билета
    //помечаем место
   form1.ZReadOnlyQuery3.SQL.add('UPDATE av_ticket SET unused='+seat_status+',unused_id_user='+inttostr(id_user)+',unused_createdate=now() ');
   form1.ZReadOnlyQuery3.SQL.add(' WHERE id_ot='+sale_server+' AND mesto='+inttostr(nseat));
   form1.ZReadOnlyQuery3.SQL.add(' AND trip_date='+Quotedstr(tripdate));
   form1.ZReadOnlyQuery3.SQL.add(' AND trip_time='+quotedstr(full_mas[idx,10]));
   form1.ZReadOnlyQuery3.SQL.add(' AND id_shedule='+full_mas[idx,1]); //+' AND id_trip_ot='+full_mas[idx,3]+' AND id_trip_do='+full_mas[idx,6]);
   //form1.ZReadOnlyQuery3.SQL.add(' AND order_trip_ot='+full_mas[idx,4]+' AND order_trip_do='+full_mas[idx,7]);
   If Form9.StringGrid1.Cells[6,n]='1' then
       form1.ZReadOnlyQuery3.SQL.add(' AND type_ticket=1 AND ticket_num='+Quotedstr(Form9.StringGrid1.Cells[7,n]));
    If Form9.StringGrid1.Cells[6,n]='2' then
       form1.ZReadOnlyQuery3.SQL.add(' AND type_ticket=2 AND bagage_num='+Quotedstr(Form9.StringGrid1.Cells[7,n]));
   form1.ZReadOnlyQuery3.SQL.add(' AND unused='+tip+' AND type_oper=1;');
    yep:=true;
    break;
    end;
  end;
  form1.ZReadOnlyQuery1.Next;
 end;
   if yep then
      begin
    //showmessage(form1.ZReadOnlyQuery3.SQL.Text);//$
    form1.ZReadOnlyQuery3.ExecSQL;
    form1.Zconnection1.Commit;
      end;
    //showmessagealt('ДАННЫЕ УСПЕШНО СОХРАНЕНЫ !');
    except
      If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
      form1.ZConnection1.disconnect;
      showmessage('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL3: '+form1.ZReadOnlyQuery3.SQL.Text);//$
      exit;
    end;
    form1.ZConnection1.disconnect;
    form1.ZReadOnlyQuery3.Close;
    form1.ZReadOnlyQuery1.Close;
  END;
   Form9.Close;
end;


procedure TForm9.FormPaint(Sender: TObject);
begin
   form9.Canvas.Brush.Color:=clSilver;
   form9.Canvas.Pen.Color:=clBlack;
   form9.Canvas.Pen.Width:=2;
   form9.Canvas.Rectangle(2,2,form9.Width-2,form9.Height-2);
end;

procedure TForm9.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState   );
var
  n:integer;
begin
    // ESC
   if (Key=27) then
       begin
        key:=0;
         form9.Close;
          exit;
       end;

   // F1 - Справка
   if (Key=112) then showmessagealt('F1 - СПРАВКА'+#13+'F12 - СОХРАНИТЬ ИЗМЕНЕНИЯ'+#13+'DEL - ВЫЧЕРКНУТЬ БИЛЕТ'+#13+'F6 - ВЕДОМОСТЬ ПРОДАЖИ БИЛЕТОВ'+#13+'ESC - ВЫХОД');

   // F12 - Запись операции в базу
   if (Key=123) then
       begin
         key:=0;
          If remote_trip and not form1.virt_server() then
           begin
             showmessagealt('Операция ЗАПРЕЩЕНА ! '+#13+'Для УДАЛЕННОГО подразделения');
             exit;
           end;
          if (id_user>2) and (vicherknut=0) then
               begin
                showmessagealt('Операция ЗАПРЕЩЕНА !'+#13+'Недостаточно прав !¯\_(ツ)_/¯');
                exit;
               end;
         form1.paintmess(form9.StringGrid1,'ЗАПИСЬ В БАЗУ ! ПОДОЖДИТЕ...',clRed);
          If not timecontrol() then
               begin
                showmessagealt('¯\_(ツ)_/¯ Операция ЗАПРЕЩЕНА !!!'+#13+'Прошло больше ' +inttostr(unused_critical_time)+ ' минут !'+#13+'Time is '+timetostr(time()));
                //showmessagealt('┌∩┐_Операция ЗАПРЕЩЕНА !'+#13+'Прошло больше ' +inttostr(unused_critical_time)+ ' минут !'+
                //#13+timetostr(time()-fact_time)+#13+timetostr(fact_time)+#13+timetostr(un_critical_time));
                exit;
               end;
         Save_unused();
         exit;
       end;

   // F6 - Печать ведомости
    if (Key=117) then
       begin
        key:=0;
        form1.Vedom_get(idx,0); //вывод списка ведомостей на печать
        exit;
       end;

   // Если DEL на Grid
   if (Key=46) then
       //and (form7.StringGrid2.Focused=true)
       begin
         key:=0;
         //еще не вычеркнут
         If trim(Form9.StringGrid1.Cells[0,Form9.StringGrid1.row])='0' then
           begin
             flchange:=true;
             Form9.StringGrid1.Cells[0,Form9.StringGrid1.row]:='1';
            If form9.StringGrid1.Row<>(form9.StringGrid1.RowCount-1) then
           begin
             for n:=Form9.StringGrid1.row+1 to form9.StringGrid1.RowCount-1 do
              begin
              //ищем багажи на это же место
               If (trim(Form9.StringGrid1.Cells[1,n])<>Form9.StringGrid1.Cells[1,Form9.StringGrid1.row]) then break;
               If (trim(Form9.StringGrid1.Cells[0,n])='0') then
                Form9.StringGrid1.Cells[0,n]:='1';
               end;
             form9.StringGrid1.Row:=form9.StringGrid1.Row+1;
            end
             else
              begin
              form9.StringGrid1.Row:=1;
              end;
             Form9.StringGrid1.Refresh;
             exit;
           end;
         //пока вычеркнут
         If trim(Form9.StringGrid1.Cells[0,Form9.StringGrid1.row])='1' then
             begin
             If not flchange then
               If not timecontrol() then
                 //If (id_user>11) then
               begin
                showmessagealt('(つ.•́ _ʖ •̀ .)つ Операция ЗАПРЕЩЕНА !'+#13+'Прошло больше ' +inttostr(unused_critical_time)+ ' минут !'+#13+'Client_time='+timetostr(time()));
                exit;
               end;
             flchange:=true;
             Form9.StringGrid1.Cells[0,Form9.StringGrid1.row]:='0';
             If form9.StringGrid1.Row=(form9.StringGrid1.RowCount-1) then
                form9.StringGrid1.Row:=1 else form9.StringGrid1.Row:=form9.StringGrid1.Row+1;
             Form9.StringGrid1.Refresh;
             exit;
             end;
       end;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;


//******************************************************************************
procedure Tform9.user_group();
var
   n,m,k:integer;
begin
   // Подключаемся к серверу
    If not(Connect2(Form9.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     Form9.close;
     exit;
    end;
    If remote_trip then form9.Label33.Visible:=true;

   //запрос списка мест из av_str_ats
   form9.ZReadOnlyQuery4.SQL.Clear;
   form9.ZReadOnlyQuery4.SQL.add('Select group_id from av_users_group where del=0 and user_id='+inttostr(id_user));
   //showmessage(form9.ZReadOnlyQuery4.SQL.Text);//$
 try
      form9.ZReadOnlyQuery4.open;
 except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+form9.ZReadOnlyQuery4.SQL.Text);
       form9.ZReadOnlyQuery4.Close;
       form9.Zconnection1.disconnect;
       exit;
 end;
   if form9.ZReadOnlyQuery4.RecordCount=0 then
     begin
      form9.ZReadOnlyQuery4.Close;
      form9.Zconnection1.disconnect;
      exit;
     end;

   for n:=0 to form9.ZReadOnlyQuery4.RecordCount-1 do
     begin
      //если группа админа или бухгалтера
       If (form9.ZReadOnlyQuery4.FieldByName('group_id').AsInteger=1) or (form9.ZReadOnlyQuery4.FieldByName('group_id').AsInteger=6) then
         vicherknut:=1;
        form9.ZReadOnlyQuery4.Next;
     end;

    form9.ZReadOnlyQuery4.Close;
    Form9.ZConnection1.Disconnect;
end;


//******************************************************************************
procedure Tform9.mesta_load;
 var
   n,m,k:integer;
begin
   form9.StringGrid1.RowCount:=1;

   // Подключаемся к серверу
    If not(Connect2(Form9.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     Form9.close;
     exit;
    end;
    If remote_trip then form9.Label33.Visible:=true;

   //запрос списка мест из av_str_ats
   form9.ZReadOnlyQuery4.SQL.Clear;
   form9.ZReadOnlyQuery4.SQL.add('Select * ');
   form9.ZReadOnlyQuery4.SQL.add(',(SELECT b.name FROM av_users b WHERE b.id=z.iduser AND b.del=0 ORDER BY b.createdate DESC LIMIT 1 OFFSET 0) as kto ');
   form9.ZReadOnlyQuery4.SQL.add(',(SELECT b.name FROM av_spr_point b WHERE b.id=z.id_do AND b.del=0 ORDER BY b.createdate DESC LIMIT 1 OFFSET 0) as kuda ');
   form9.ZReadOnlyQuery4.SQL.add(',(CASE z.type_ticket WHEN 1 THEN right(z.ticket_num,15) WHEN 2 THEN right(z.bagage_num,11) END) as ticket_for_check ');
   form9.ZReadOnlyQuery4.SQL.add(',(CASE z.type_ticket WHEN 1 THEN z.ticket_num WHEN 2 THEN z.bagage_num END) as ticket ');
   form9.ZReadOnlyQuery4.SQL.add(',(CASE WHEN z.unused_createdate>z.createdate THEN z.unused_createdate ELSE z.createdate END) as stamp ');
   form9.ZReadOnlyQuery4.SQL.add(' FROM ( ');
   form9.ZReadOnlyQuery4.SQL.add('SELECT a.unused,a.mesto,a.id_do,a.type_ticket,a.unused_createdate,a.createdate,a.ticket_num,a.bagage_num ');
   form9.ZReadOnlyQuery4.SQL.add(',(CASE WHEN a.unused_createdate>a.createdate THEN a.unused_id_user ELSE a.id_user END) as iduser ');
   form9.ZReadOnlyQuery4.SQL.add('FROM av_ticket a where a.type_oper=1 AND (a.sum_cash>0 OR a.sum_credit>0) ');
   form9.ZReadOnlyQuery4.SQL.add(' AND a.trip_date='+Quotedstr(tripdate));
   form9.ZReadOnlyQuery4.SQL.add(' AND a.trip_time='+quotedstr(full_mas[idx,10]));
   form9.ZReadOnlyQuery4.SQL.add(' AND a.id_shedule='+full_mas[idx,1]); //+' AND a.id_trip_ot='+full_mas[idx,3]+' AND a.id_trip_do='+full_mas[idx,6]);
 //  form9.ZReadOnlyQuery4.SQL.add(' AND a.order_trip_ot='+full_mas[idx,4]+' AND a.order_trip_do='+full_mas[idx,7]);
   form9.ZReadOnlyQuery4.SQL.add(' UNION ALL ');
   form9.ZReadOnlyQuery4.SQL.add(' SELECT a.unused,a.mesto,a.id_do,a.type_ticket,a.unused_createdate,a.createdate,a.ticket_num,a.bagage_num ');
   form9.ZReadOnlyQuery4.SQL.add(',(CASE WHEN a.unused_createdate>a.createdate THEN a.unused_id_user ELSE a.id_user END) as iduser ');
   form9.ZReadOnlyQuery4.SQL.add('FROM av_ticket_local a where a.type_oper=1 AND (a.sum_cash>0 OR a.sum_credit>0) ');
   form9.ZReadOnlyQuery4.SQL.add(' AND a.trip_date='+Quotedstr(tripdate));
   form9.ZReadOnlyQuery4.SQL.add(' AND a.trip_time='+quotedstr(full_mas[idx,10]));
   form9.ZReadOnlyQuery4.SQL.add(' AND a.id_shedule='+full_mas[idx,1]); //+' AND a.id_trip_ot='+full_mas[idx,3]+' AND a.id_trip_do='+full_mas[idx,6]);
 //  form9.ZReadOnlyQuery4.SQL.add(' AND a.order_trip_ot='+full_mas[idx,4]+' AND a.order_trip_do='+full_mas[idx,7]);
   form9.ZReadOnlyQuery4.SQL.add(' ) z ');
   form9.ZReadOnlyQuery4.SQL.add(' ORDER BY z.mesto,z.type_ticket; ');

   //showmessage(form9.ZReadOnlyQuery4.SQL.Text);//$
 try
      form9.ZReadOnlyQuery4.open;
 except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+form9.ZReadOnlyQuery4.SQL.Text);
       form9.ZReadOnlyQuery4.Close;
       form9.Zconnection1.disconnect;
       exit;
 end;
   if form9.ZReadOnlyQuery4.RecordCount=0 then
     begin
      If remote_trip then
        begin
        If remote_ind=-1 then
            showmessagealt('Не определены места для данного АТС !!!'+#13+'Обратитесь к АДМИНИСТРАТОРУ !!!')
        end
        else
             showmessage('НЕТ проданных билетов на данный рейс !');
      form9.ZReadOnlyQuery4.Close;
      form9.Zconnection1.disconnect;
      exit;
     end;

   // Проставляем количество этажей
   //form9.Label11.caption:=form9.ZReadOnlyQuery4.FieldByName('level').asString;

   // Заполняем грид местами
   for n:=0 to form9.ZReadOnlyQuery4.RecordCount-1 do
     begin
        form9.StringGrid1.RowCount:=form9.StringGrid1.RowCount+1;
        form9.StringGrid1.Cells[0,form9.StringGrid1.RowCount-1]:=form9.ZReadOnlyQuery4.FieldByName('unused').AsString;
        form9.StringGrid1.Cells[1,form9.StringGrid1.RowCount-1]:=form9.ZReadOnlyQuery4.FieldByName('mesto').AsString;
        //если билет
        If form9.ZReadOnlyQuery4.FieldByName('type_ticket').AsInteger=1 then
          begin
        form9.StringGrid1.Cells[2,form9.StringGrid1.RowCount-1]:=form9.ZReadOnlyQuery4.FieldByName('ticket_for_check').AsString;
        form9.StringGrid1.Cells[3,form9.StringGrid1.RowCount-1]:=form9.ZReadOnlyQuery4.FieldByName('kuda').AsString;
          end;
        //если багаж
         If form9.ZReadOnlyQuery4.FieldByName('type_ticket').AsInteger=2 then
           begin
        form9.StringGrid1.Cells[2,form9.StringGrid1.RowCount-1]:='БАГАЖ '+form9.ZReadOnlyQuery4.FieldByName('ticket_for_check').AsString;
        form9.StringGrid1.Cells[3,form9.StringGrid1.RowCount-1]:='';
           end;
        form9.StringGrid1.Cells[4,form9.StringGrid1.RowCount-1]:=form9.ZReadOnlyQuery4.FieldByName('kto').AsString;
        form9.StringGrid1.Cells[5,form9.StringGrid1.RowCount-1]:=FormatDateTime('hh:nn dd/mm',form9.ZReadOnlyQuery4.FieldByName('stamp').AsDateTime);
        form9.StringGrid1.Cells[6,form9.StringGrid1.RowCount-1]:=form9.ZReadOnlyQuery4.FieldByName('type_ticket').AsString;
        form9.StringGrid1.Cells[7,form9.StringGrid1.RowCount-1]:=form9.ZReadOnlyQuery4.FieldByName('ticket').AsString;

        form9.ZReadOnlyQuery4.Next;
     end;

    form9.ZReadOnlyQuery4.Close;
    Form9.ZConnection1.Disconnect;

   wid:=Form9.StringGrid1.Width;
 Form9.StringGrid1.ColWidths[0]:=1;
 Form9.StringGrid1.ColWidths[1]:=trunc(wid*0.08);
 Form9.StringGrid1.ColWidths[2]:=trunc(wid*0.30);
 Form9.StringGrid1.ColWidths[3]:=trunc(wid*0.21);
 Form9.StringGrid1.ColWidths[4]:=trunc(wid*0.21);
 Form9.StringGrid1.ColWidths[5]:=trunc(wid*0.18);
 form9.StringGrid1.visible:=true;
end;



// Настраиваем форму
procedure TForm9.set_form;
begin
 // Определяем номер элемента в массиве
 idx:=-1;
 idx:= masindex;
 If (idx<0) or (idx>high(full_mas)) then
   begin
     showmessagealt('Данный рейс НЕ НАЙДЕН !');
     Form9.Close;
    exit;
   end;

 tripdate:=datetostr(work_date);
 remote_trip:=false;
 //проверка на удаленный рейс
 If not (full_mas[idx,0]='1') and  not(full_mas[idx,0]='2') then
    begin
      remote_trip:=true;
      tripdate:=full_mas[idx,11];

      //если операция по удаленке, то записать локально
   formmenu.insert_remote_oper(form9.ZConnection1,form9.ZReadOnlyQuery4,9,full_mas[idx,13],QuotedStr(full_mas[idx,30]+' '+full_mas[idx,31]));
      //если транзакция еще открыта - откатываемся
    If form9.Zconnection1.Connected then
      begin
       form9.ZReadOnlyQuery4.Close;
       If form9.ZConnection1.InTransaction then form9.Zconnection1.Rollback;
       form9.ZConnection1.disconnect;
       end;
     //showmessage('удаленка ');//$
    //если удаленка и текущее время меньше даты в времени отправления рейса, то недоступно
     //If (strtodatetime(full_mas[idx,11]+' '+full_mas[idx,10],mysettings)>now()) then fl_unused:=false;
    end;

 If not remote_trip and ((trim(full_mas[idx,22])='') or (full_mas[idx,22]='0')) then
   begin
     showmessagealt('Данный рейс неактивен !');
     Form9.Close;
     exit;
   end;


  form1.paintmess(Form9.StringGrid1,'ЗАГРУЗКА ДАННЫХ ! ПОДОЖДИТЕ...',clBlue);
 //********** если проставление вычеркнутых - проверяем, что рейс отправлен
 //If fl_unused then AND not check_trip() then
 //   begin
 //    Form9.Close;
 //    exit;
 //   end;

 // строка наименование рейса
 Form9.Label37.Caption:='['+trim(full_mas[idx,1])+']  '+trim(full_mas[idx,5])+' - '+trim(full_mas[idx,8]);
 Form9.Label38.Caption:='Отправление: '+trim(full_mas[idx,10])+'  '+tripdate;

 // Наименование перевозчика
 Form9.Label8.Caption:= UpperALL('['+trim(full_mas[idx,18])+'] '+trim(full_mas[idx,19]));
 //form2.edit1.Text:='['+trim(full_mas[idx,18])+'] '+trim(full_mas[idx,19]);

 // id и наименование АТС
 Form9.Label9.Caption:= UpperAll('['+trim(full_mas[idx,20])+'] '+trim(full_mas[idx,21]));

 // ТИП РЕЙСА
 Form9.Label10.Caption:=IFTHEN(trim(full_mas[idx,9])='1','ФОРМИРУЮЩИЙСЯ','ТРАНЗИТНЫЙ');
 tek_type_rejs:=trim(full_mas[idx,9]);
 IF trim(full_mas[idx,0])='2' THEN
    begin
     Form9.Label10.Caption:='ЗАКАЗНОЙ';
     tek_type_rejs:='3';
    end;

 // Количество этажей

 // Мест всего
 Form9.Label12.Caption:=trim(full_mas[idx,25]);

 // ТИП АТС
 Form9.Label13.Caption:=IFTHEN(trim(full_mas[idx,27])='1','М2','М3');

 //информация по правам доступа
 Form9.user_group();

 // Загрузка мест в карту АТС
 Form9.mesta_load;

  Form9.stringgrid1.SetFocus;
  //form9.StringGrid1.Row:=2;
end;


//******************************** ОТРИСОВКА ГРИДА *****************************************
procedure TForm9.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
   n,pred,kolslow,nTop:integer;
   s1,s2,sFlag:string;
   //fltransit,vihod:boolean;
begin

   If (aCol>5) then exit;//не рисовать лишние столбцы
   If not form1.StringGrid1.visible then exit;
  //if form1.Panel5.Visible=true then exit;
  with Sender as TStringGrid, Canvas do
   begin
    //margin:=12;
    //horiz:=((aRect.Right-aRect.left) div 2);
    //vert:=(form1.StringGrid1.RowHeights[aRow]) div 2;

    AntialiasingMode:=amOff;
    Font.Quality:=fqDraft;

    Brush.Color:=clWhite;
    Font.Color:=clBlack;
    font.Style:=[];
    //если вычеркнутый, меняем цвета
    If trim(form9.StringGrid1.Cells[0,aRow])='1' then
    begin
        Brush.Color:=clBlack;
        Font.Color:=clWhite;
     end;
     FillRect(aRect);    //делаем фон

   //при выделении
   if (gdSelected in aState) then
         begin
         //линии выделения
          pen.Width:=8;
          pen.Color:=clRed;
          MoveTo(aRect.left,aRect.bottom-1);
          LineTo(aRect.right,aRect.Bottom-1);
          MoveTo(aRect.left,aRect.top-1);
          LineTo(aRect.right,aRect.Top);

         font.Style:=[fsBold];
        end;

   //заголовок
   If aRow=0 then
      begin
           Brush.Color:=clSilver;
           FillRect(aRect);
           Font.Color := clBlack;
           font.Style:=[];
           font.Size:=10;
           DrawCellsAlign(form9.StringGrid1,2,2,Cells[aCol, aRow],aRect);
           exit;
        end;

   font.Size:=11;
   //место
   If aCol=1 then DrawCellsAlign(form9.StringGrid1,2,2,Cells[aCol, aRow],aRect);
   //номер билета
   If (aCol=2) then
      begin
       If form9.StringGrid1.Cells[6,aRow]='1' then
          begin
           font.Size:=13;
          DrawCellsAlign(form9.StringGrid1,1,2,Cells[aCol, aRow],aRect);
          end;
       If form9.StringGrid1.Cells[6,aRow]='2' then
          begin
          font.Size:=12;
          DrawCellsAlign(form9.StringGrid1,2,2,Cells[aCol, aRow],aRect);
          end;
      end;
   If aCol>2 then  DrawCellsAlign(form9.StringGrid1,1,2,Cells[aCol, aRow],aRect);

end;
end;


procedure TForm9.FormShow(Sender: TObject);
begin
   //Выравниваем форму
 Form9.Left:=form1.Left+(form1.Width div 2)-(Form9.Width div 2);
 Form9.Top:=form1.Top+(form1.Height div 2)-(Form9.Height div 2);

 fl_transact:=true;
 Form9.set_form;
  //If fl_unused then
 Form9.Label36.Caption:='Отметка Вычеркнутых билетов';
  flchange:=false;

end;


end.

