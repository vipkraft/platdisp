unit menu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  // LazFileUtils,
  Forms,
  //Controls,
  Graphics, Dialogs, platproc, ZConnection, ZDataset, Grids, bron_main,
  zakaz_main, Controls, StdCtrls, dateutils;

type
 { TFormMenu }
   TFormMenu = class(TForm)
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    ZConnection1: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    ZReadOnlyQuery2: TZReadOnlyQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function menu_load():boolean; //вызов и загрузка меню диспетчера
    function razbor(num:byte):byte; //выполнение пункта меню диспетчера
    procedure insert_oper(ZCon:TZConnection;ZQ1,ZQ2:TZReadOnlyQuery;lg:byte); //запись операции
    procedure StringGrid3DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
    function menu_canceled():boolean; // Загрузка меню СРЫВА РЕЙСА
    function razbor_canceled():boolean;//запись вида срыва рейса
    procedure StringGrid3Selection(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid4DrawCell(Sender: TObject; aCol, aRow: Integer;  aRect: TRect; aState: TGridDrawState);
    function Sriv_insert:boolean;//запрос на запись срыва рейсов
    procedure insert_remote_oper(ZCon:TZConnection;ZQ1:TZReadOnlyQuery;lg:byte; usr:string; stamp:string);//Локальная Запись операции ДИСПЕТЧЕРА удаленного рейса
    function check_status_correct(oper:integer; tflag:integer):boolean;//проверка корректности операция/статус рейса
    procedure showtels();//показать телефоны пассажиров
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormMenu: TFormMenu;



implementation

uses
  maindisp;



var
  n,arn,menu_id,menu_perm,vid:integer;
  arrive:boolean = false;
  departure:boolean= false;
  unactive,flag_sriv,flag_late,flsearch_sriv,udalenka:boolean;
  up_time,up_point,up_order: string;
  status,rem,st1: string;
  active_oper:boolean;
  tick_cnt,serv_real_virt:integer;
  tripdate,napr,regtime:string;


{$R *.lfm}

//===================================================
//============  СОСТАВ МЕНЮ   =======================

//1. ОТПРАВЛЕНИЕ РЕЙСА
//2. ПРИБЫТИЕ РЕЙСА
//3. ДООБИЛЕЧИВАНИЕ
//4. ОТМЕНА РЕЙСА
//5. АТП СМЕНИТЬ
//6. БРОНИРОВАНИЕ
//7. АВТОБУС СМЕНИТЬ
//8. ОПОЗДАНИЕ РЕЙСА ОТМЕТИТЬ
//9. ВЫЧЕРКНУТЫЕ БИЛЕТЫ
//Г. ТЕЛЕФОНЫ ПАССАЖИРОВ
//А. ЗАДАТЬ НОМЕР ПЛАТФОРМЫ
//Б. ЗАКАЗНОЙ РЕЙС СОЗДАТЬ
//В. РЕЙС ОТКРЫТЬ/ЗАКРЫТЬ

//========================================================
//==================     КОДЫ ОПЕРАЦИЙ:   ================

  //1: ОТПРАВИТЬ РЕЙС
  //2: ОТМЕТИТЬ ПРИБЫТИЕ РЕЙСА
  //3: ОТКРЫТЬ ВЕДОМОСТЬ ДООБИЛЕЧИВАНИЯ
  //4: ОТМЕНИТЬ РЕЙС
  //5: СМЕНИТЬ АТП
  //6: ЗАБРОНИРОВАТЬ местА
  //7: СМЕНИТЬ АТС
  //8: ОТМЕТКА ОПОЗДАНИЯ РЕЙСА
  //9: ВЫЧЕРКНУТЫЕ БИЛЕТЫ
  //10: ЗАДАТЬ НОМЕР ПЛАТФОРМЫ
  //11: СОЗДАТЬ ЗАКАЗНОЙ РЕЙС
  //12: РЕЙС ЗАКРЫТЬ/СНЯТЬ ОТМЕТКУ СОСТОЯНИЯ (СРЫВА,ЗАКРЫТИЯ,ОПОЗДАНИЯ,ПРИБЫТИЯ)
  //13: Рейс закрыть временно ПРИОСТАНОВИТь
  //80: ОБЪЯВЛЕНИЕ СВОБОДНЫЕ МЕСТА
  //99: СОХРАНИТЬ РЕКВИЗИТЫ РЕЙСА
  //100: ОБЪЯВЛЕНИЕ ДЛЯ ОПАЗДЫВАЮЩИХ

//=====================================================

//===================================================
//============  СОСТОЯНИЯ РЕЙСА   =======================

//0 - НЕОПРЕДЕЛЕНО (ОТКРЫТ)
//1 - ДООБИЛЕЧИВАНИЕ (ОТКРЫТ) повторно
//2 - ОТМЕЧЕН КАК ПРИБЫВШИЙ
//3 - ОТМЕЧЕН КАК ОПАЗДЫВАЮЩИЙ (ОТКРЫТ)
//4 - ОТПРАВЛЕН (Закрыт)
//5 - СРЫВ ПО ВИНЕ АТП (ЗАКРЫТ)
//6 - ЗАКРЫТ ПРИНУДИТЕЛЬНО
//7 - ЗАКРЫТ Временно ПРИОСТАНОВЛЕН

//====================================================
procedure TFormMenu.Showtels();
var
  n,hght:integer;
begin
 with FormMenu do
   begin
   // Подключаемся к Локальному серверу
   If not(Connect2(Zconnection1, 2)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k01-');
      //closeAll();
      halt;
      exit;
     end;
  //определяем наименование пункта локального сервера
   ZReadOnlyQuery1.sql.Clear;
   ZReadOnlyQuery1.SQL.add('select fio,translate(tel,''!@#$%^&*()_+-=,. '','''') tel from av_ticket where type_ticket=1 and translate(tel,''!@#$%^&*()_+-=,. '','''')<>'''' ');
   ZReadOnlyQuery1.sql.add(' AND trip_date='+Quotedstr(tripdate)+' AND id_shedule='+full_mas[masindex,1]);
   ZReadOnlyQuery1.sql.add(' AND trip_time='+QuotedStr(up_time)+' AND id_trip_ot='+up_point);
   //ZReadOnlyQuery1.sql.add(' AND trip_date=''08-06-2017'' AND id_shedule=1136');
   //ZReadOnlyQuery1.SQL.add(' AND order_trip_ot='+up_order+' AND id_trip_do='+full_mas[masindex,6]);
   //ZReadOnlyQuery1.SQL.add(' AND order_trip_do='+full_mas[masindex,7]+' LIMIT 1;');
   ZReadOnlyQuery1.SQL.add(' order by mesto;');
   //showmessage(ZReadOnlyQuery1.SQL.Text);//$
   try
      ZReadOnlyQuery1.open;
     except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text+#13+'-k02-');
       ZReadOnlyQuery1.Close;
       Zconnection1.disconnect;
       exit;
     end;
    if ZReadOnlyQuery1.RecordCount<1 then
       begin
         showmessage('Номеров телефонов пассажиров'+#13+'для данного рейса НЕ НАЙДЕНО');
         ZReadOnlyQuery1.Close;
         ZConnection1.Disconnect;
         exit;
       end;

   Stringgrid3.RowCount:=0;

    //заполняем грид меню
    for n:=1 to ZReadOnlyQuery1.RecordCount do
      begin
       Stringgrid3.RowCount:= Stringgrid3.RowCount +1;
        Stringgrid3.Cells[2,Stringgrid3.RowCount-1]:='0';
        Stringgrid3.Cells[1,Stringgrid3.RowCount-1]:=padr(trim(ZReadOnlyQuery1.FieldByName('tel').AsString),#32,12)
        +'|'+trim(ZReadOnlyQuery1.FieldByName('fio').AsString);
        //Stringgrid3.Cells[0,Stringgrid3.RowCount-1]:='0';
        ZReadOnlyQuery1.Next;
      end;
  ZReadOnlyQuery1.Close;
   Zconnection1.disconnect;
    //настройка и отображения панели и грида меню
   Stringgrid3.Left:=2;
   Stringgrid3.Top :=2;
   hght:=Stringgrid3.DefaultRowHeight*Stringgrid3.RowCount+4;
   If hght>600 then
    begin
      formmenu.Height:=610;
      Stringgrid3.height:=600;
      stringgrid3.ScrollBars:=ssAutoVertical;
    end;
   //else
    //begin
      //formmenu.Height:=Stringgrid3.DefaultRowHeight*Stringgrid3.RowCount+10;
      //Stringgrid3.height:=Stringgrid3.DefaultRowHeight*Stringgrid3.RowCount+4;
    //end;
    formmenu.Width:=504;
   Stringgrid3.width:=500;
   Stringgrid3.ColWidths[0]:=3;
   Stringgrid3.ColWidths[1]:=492;
   Stringgrid3.ColWidths[2]:=3;
   napr:='down';
    Stringgrid3.Row:=0;
   Stringgrid3.SetFocus;
   end;
 end;



function TFormMenu.check_status_correct(oper:integer; tflag:integer):boolean;//проверка корректности операция/статус рейса
begin
 result:=true;
 //If (oper=1) and not(tflag=4) then result:=false;
 If (oper=3) and not(tflag=0) then result:=false;
 If (oper=4) and not(tflag=5) then result:=false;
 If (oper=5) and (tflag>3) then result:=false;
 If (oper=6) and (tflag>3) then result:=false;
 If (oper=7) and (tflag>3) then result:=false;
 If (oper=8) and not((tflag=0) or (tflag=3)) then result:=false;
 If (oper=9) and (tflag<4) then result:=false;
end;


//************     ЛОКАЛЬНАЯ  Запись операции ДИСПЕТЧЕРА удаленного рейса для печати отображения корректной инфы по ним после рассчета хранимки рейсов *****
procedure TFormMenu.insert_remote_oper(ZCon:TZConnection;ZQ1:TZReadOnlyQuery;lg:byte; usr:string; stamp:string);
//==================     КОДЫ ОПЕРАЦИЙ:   ================
  //1: ОТПРАВИТЬ РЕЙС
  //2: ОТМЕТИТЬ ПРИБЫТИЕ РЕЙСА
  //3: ОТКРЫТЬ ВЕДОМОСТЬ ДООБИЛЕЧИВАНИЯ
  //4: ОТМЕНИТЬ РЕЙС
  //5: СМЕНИТЬ АТП
  //6: ЗАБРОНИРОВАТЬ местА
  //7: СМЕНИТЬ АТС
  //8: ОТМЕТКА ОПОЗДАНИЯ РЕЙСА
  //9: ВЫЧЕРКНУТЫЕ БИЛЕТЫ
  //10: ЗАДАТЬ НОМЕР ПЛАТФОРМЫ
  //11: СОЗДАТЬ ЗАКАЗНОЙ РЕЙС
  //12: РЕЙС ЗАКРЫТЬ/СНЯТЬ ОТМЕТКУ СОСТОЯНИЯ (СРЫВА,ЗАКРЫТИЯ,ОПОЗДАНИЯ,ПРИБЫТИЯ)
  //99: Просто сохранить данные рейса (НЕ ОТПРАВЛЯТЬ И НЕ ОТМЕЧАТЬ ПРИБЫТИЕ)
  //100: ОБЪЯВЛЕНИЕ ДЛЯ ОПАЗДЫВАЮЩИХ
var
   sfree:string;
begin
  If trim(usr)='' then usr:='0';
   If trim(stamp)='' then stamp:=formatDatetime('dd-mm-yyyy hh:nn:ss',now());  //дата операции
    status:='-1';

   //находим элемент массива
  arn:=-1;
  arn:= masindex;
  If arn=-1 then exit;

  If full_mas[arn,16]='1' then
    begin
      arrive:=false;
      departure:=true;
      up_time := full_mas[arn,10];
      up_point:= full_mas[arn,3];
      up_order:= full_mas[arn,4];
    end
  else
  begin
    arrive:=true;
    departure:=false;
    up_time := full_mas[arn,12];
    up_point:= full_mas[arn,6];
    up_order:= full_mas[arn,7];
  end;

  If Zcon.Connected then
    begin
    If ZCon.InTransaction then Zcon.Rollback;
    Zcon.disconnect;
    end;

  tripdate:=full_mas[arn,11];

 // Подключаемся к локальному серверу
   If not(Connect2(Zcon, 2)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k03-');
      exit;
     end;
   ZQ1.sql.Clear;
    //проверяем, есть ли проданные билеты на рейс удаленки
    ZQ1.SQL.add('SELECT 1 FROM av_ticket_local WHERE trip_date='+Quotedstr(tripdate)+' AND id_shedule=');
    ZQ1.SQL.add(full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND id_trip_ot='+up_point);
    ZQ1.SQL.add(' AND order_trip_ot='+up_order+' AND id_trip_do='+full_mas[arn,6]);
    ZQ1.SQL.add(' AND order_trip_do='+full_mas[arn,7]+' limit 1;');
   try
        ZQ1.open;
    except
       If ZCon.InTransaction then Zcon.Rollback;
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZQ1.SQL.Text+#13+'-k04-');
        ZQ1.close;
       Zcon.disconnect;
       exit;
    end;

  //ЕСЛИ НЕТ ПРОДАННЫХ билетов, тогда НИЧЕГО НЕ ДЕЛАТЬ (ВЫХОД)
   If ZQ1.RecordCount=0 then
     begin
       ZQ1.close;
       Zcon.disconnect;
       exit;
     end;

  fl_lock:=false;
//Проверяем записЬ рейса на блокировку
    ZQ1.sql.Clear;
    ZQ1.sql.add('select * from trip_in_lock('+quotedstr(tripdate)+','+full_mas[arn,1]+',');
    ZQ1.sql.add(full_mas[arn,16]+','+quotedstr(full_mas[arn,10])+','+sale_server+','+full_mas[arn,4]+') as lock;');
    //ZQ1.SQL.add('SELECT * FROM av_disp_oper WHERE del=0 ');//AND id_point_oper='+save_server);
    //ZQ1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[arn,16]);
    //ZQ1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point);
    //ZQ1.SQL.add(' AND point_order='+up_order+' FOR UPDATE NOWAIT;');
    //showmessage(ZQ1.SQL.Text);//$
    try
        ZQ1.open;
    except
       If ZCon.InTransaction then Zcon.Rollback;
         showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZQ1.SQL.Text+#13+'-k05-');
          ZQ1.close;
       Zcon.disconnect;
       exit;
    end;

    If ZQ1.Recordcount=1 then
     begin
         //если рейс в блокировке
       If ZQ1.FieldByName('lock').asInteger=2 then
         begin
             If ZCon.InTransaction then Zcon.Rollback;
             ZCon.disconnect;
             showmessagealt('Операция временно недоступна !'+#13+'С данным рейсом уже работают !'+#13+'-k06-');
             exit;
         end;
       //если есть записи рейса но нет блокировки
       If ZQ1.FieldByName('lock').asInteger=1 then
         begin
           fl_lock:=true;
           //showmessagealt('--!!!--');//$
         end;
     end;

  //если записей по этому рейсу с del=0 больше одного - ОШИБКА
   //If (ZQ1.RecordCount>1) then
   //  begin
   //    If DialogMess('Ошибка целостности данных !'+#13+'Выполнить очистку данных ?')=6 then
   //     begin
   //       ZQ1.sql.Clear;
   //       ZQ1.SQL.add('Update av_disp_oper SET del=2,createdate=now() WHERE del=0 ');//AND id_point_oper='+save_server);
   //       ZQ1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[arn,16]);
   //       ZQ1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point);
   //       ZQ1.SQL.add(' AND point_order='+up_order+' AND createdate<(SELECT max(createdate) FROM av_disp_oper WHERE trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[arn,16]);
   //       ZQ1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point+')');
   //       //'+QuotedStr(FormatDateTime('dd-mm-yyyy hh:nn:ss',strtoDateTime(max_operation)-strToDatetime('00:00:02')))+';');
   //       //showmessage(ZQ1.SQL.Text);
   // try
   //   ZQ1.open;
   // except
   //    If ZCon.InTransaction then Zcon.Rollback;
   //    Zcon.disconnect;
   //    operation:=0;
   //    showmessagealt('ОШИБКА очистки данных !');
   //    exit;
   // end;
   //       Zcon.Disconnect;
   //       operation:=0;
   //       showmessageALT('Очистка данных выполнена успешно !'+#13+'Повторите операцию ...');
   //       EXIT;
   //     end
   //    else
   //     begin
   //       ZQ1.Close;
   //       If ZCon.InTransaction then Zcon.Rollback;
   //       Zcon.Disconnect;
   //       operation:=0;
   //       exit;
   //     end;
   //  end;
     //если статус рейса не изменился, тогда присваиваем его значению массива
   If status='-1' then status:=full_mas[arn,28];
   If pos('/',full_mas[arn,34])>0 then
    sfree:=copy(full_mas[arn,34],1,pos('/',full_mas[arn,34])-1)
     else
   sfree:=full_mas[arn,34];

   //проверка корректности статуса рейса после выполняемой операции
 //If not check_status_correct(lg,strtoint(status)) then
 //  begin
 //    showmessagealt('Ошибка данных ! 0.111'+#13+' Некорректное состояние рейса !'
 //    +#13+'операция:'+inttostr(lg)+'  статус:'+status);
 //    exit;
 //  end;

//Открываем транзакцию
try
   If not Zcon.InTransaction then
     begin
      Zcon.StartTransaction;
     end
   else
     begin
       If ZCon.InTransaction then Zcon.Rollback;
       ZCon.disconnect;
       operation:=0;
      showmessagealt('Ошибка ! Незавершенная транзакция !'+#13+'Попробуйте снова !'+#13+'-k07-');
      exit;
     end;

  //запись операции
  ZQ1.sql.Clear;

   //если операций с рейсом еще не было (нечего блокировать) добавляем операцию
        //<!> ЗАПИСЫВАЕМ КОЛ-ВО СВОБОДНЫХ МЕСТ В ЯЧЕЙКЕ ВИДА СРЫВА <!>
  If (fl_lock=false) then
    begin
     ZQ1.SQL.add('INSERT INTO av_disp_oper(id_user,createdate,del,id_point_oper,id_shedule,trip_type,trip_id_point,point_order,');
     ZQ1.SQL.add('trip_date,trip_time,id_oper,platform,zakaz,trip_flag,');
     ZQ1.SQL.add('atp_id,atp_name,avto_id,avto_name,avto_seats,avto_type,');
     ZQ1.SQL.add('putevka,driver1,driver2,driver3,driver4,vid_sriva,remark) VALUES (');
     ZQ1.SQL.add(usr+','+QuotedStr(stamp)+',0,'+ConnectINI[14]+','+full_mas[arn,1]+','+full_mas[arn,16]+','+up_point+','+up_order+',');
     ZQ1.SQL.add(Quotedstr(tripdate)+','+QuotedStr(up_time)+','+inttostr(lg)+','+full_mas[arn,2]+','+full_mas[arn,0]+','+status+',');
     ZQ1.SQL.add(full_mas[arn,18]+','+QuotedStr(full_mas[arn,19])+','+full_mas[arn,20]+','+QuotedStr(full_mas[arn,21])+','+full_mas[arn,25]+','+full_mas[arn,27]+',');
     ZQ1.SQL.add(QuotedStr(full_mas[arn,35])+','+QuotedStr(full_mas[arn,36])+','+QuotedStr(full_mas[arn,37])+','+QuotedStr(full_mas[arn,38])+','+QuotedStr(full_mas[arn,39])+',');
     ZQ1.SQL.add(sfree+','+QuotedStr(full_mas[arn,35])+');');
     //<!> ЗАПИСЫВАЕМ КОЛ-ВО СВОБОДНЫХ МЕСТ В ЯЧЕЙКЕ ВИДА СРЫВА <!>
    end
  else
   begin
     ZQ1.SQL.add('UPDATE av_disp_oper set id_user='+usr+',createdate='+QuotedStr(stamp));
     ZQ1.SQL.add(',id_oper='+inttostr(lg)+',platform='+full_mas[arn,2]+',zakaz='+full_mas[arn,0]+',trip_flag='+status);
     ZQ1.SQL.add(',atp_id='+full_mas[arn,18]+',atp_name='+QuotedStr(full_mas[arn,19])+',avto_id='+full_mas[arn,20]+',avto_name='+QuotedStr(full_mas[arn,21]));
     ZQ1.SQL.add(',avto_seats='+full_mas[arn,25]+',avto_type='+full_mas[arn,27]);
     ZQ1.SQL.add(',putevka='+QuotedStr(full_mas[arn,35])+',driver1='+QuotedStr(full_mas[arn,36])+',driver2='+QuotedStr(full_mas[arn,37])+',driver3='+QuotedStr(full_mas[arn,38])+',driver4='+QuotedStr(full_mas[arn,39]));
     ZQ1.SQL.add(',vid_sriva='+sfree+',remark='+QuotedStr(full_mas[arn,35]));
     ZQ1.SQL.add(' WHERE trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[arn,16]);
     ZQ1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point+' AND point_order='+up_order+';');
    end;
    //showmessage(ZQ1.SQL.Text);//$
    ZQ1.ExecSql;

    Zcon.Commit;
except
     If ZCon.InTransaction then Zcon.Rollback;
     ZCon.disconnect;
     operation:=0;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'
     //+#13+'Запрос SQL1: '+ZQ1.SQL.Text
     +#13+'Запрос SQL1: '+ZQ1.SQL.Text+#13+'-k08-');
     exit;
end;
  //If (lg<>4) and (lg<>1) and (lg<>5) and (lg<>7) then ZQ1.Close;
  ZQ1.Close;
  //ZReadOnlyQuery2 оставляем открытым, чтобы в дальнейшем дописать и выполнить COMMIT
  Zcon.disconnect;
end;




function TFormMenu.Sriv_insert:boolean;//запрос на запись срыва рейсов
var
  timeShed,timeRow,timeDisp,shed_order,m:integer;
  pnt,tmp:string;
  fl_oper:boolean;
begin
 result:=false;
  with formMenu do
  begin
    If not Zconnection1.Connected then
    begin
      showmessagealt('НЕТ соединения с базой данных !'+#13+'Попробуйте еще раз !'+#13+'-k09-');
      exit;
    end;
  flag_sriv:=false;//сбрасываем флаг меню срыва
  flsearch_sriv:=false;
  try
  //поиск рейсов одного расписания с выбранным рейсом
    for n:=0 to length(full_mas)-1 do
      begin
      ZReadOnlyQuery2.sql.Clear;
      If (full_mas[n,16]='1') then
             begin
      try
             timeSHed:=strtoint(copy(full_mas[n,10],1,2)+copy(full_mas[n,10],4,2));
             timeRow:=strtoint(copy(up_time,1,2)+copy(up_time,4,2));
             shed_order:=strtoint(full_mas[n,4]);
             pnt:=full_mas[n,3];
           except
              on exception: EConvertError do
              begin
              showmessagealt('ОШИБКА ! НЕВОЗМОЖНО ВЫПОЛНИТЬ ОПЕРАЦИЮ'+#13+'ДЛЯ РЕЙСА №'+full_mas[n,1]+' время:'+full_mas[n,10]+#13+'-k10-');
              continue;
              end;
           end;
             end;
       If (full_mas[n,16]='2') then
             begin
       try
             timeSHed:=strtoint(copy(full_mas[n,12],1,2)+copy(full_mas[n,12],4,2));
             timeRow:=strtoint(copy(up_time,1,2)+copy(up_time,4,2));
             shed_order:=strtoint(full_mas[n,7]);
             pnt:=full_mas[n,6];
           except
              on exception: EConvertError do
              begin
              showmessagealt('ОШИБКА ! НЕВОЗМОЖНО ВЫПОЛНИТЬ ОПЕРАЦИЮ'+#13+'ДЛЯ РЕЙСА №'+full_mas[n,1]+' время:'+full_mas[n,12]+#13+'-k11-');
              continue;
              end;
           end;
             end;
     //если рейс из одного расписания
   If (full_mas[n,1]=full_mas[arn,1]) AND (timeShed>=timeRow) AND (shed_order>=strtoint(up_order))
      then
   begin
     fl_oper:=false;//флаг наличия операции над этим рейсом
   //если уже есть диспетчерские операции над этим рейсом
  If ZReadOnlyQuery1.RecordCount>0 then
  begin
    //ищем этот рейс среди операций
 for m:=1 to ZReadOnlyQuery1.RecordCount do
     begin
           try
             tmp:=ZReadOnlyQuery1.FieldByName('trip_time').AsString;
             timeDisp:=strtoint(copy(tmp,1,2)+copy(tmp,4,2));
           except
              on exception: EConvertError do
              begin
              showmessagealt('ОШИБКА ! НЕВОЗМОЖНО ВЫПОЛНИТЬ ОПЕРАЦИЮ'+#13+'для рейса №'+ZReadOnlyQuery1.FieldByName('id_shedule').AsString+' время:'+ZReadOnlyQuery1.FieldByName('trip_time').AsString+#13+'-k12-');
              ZReadOnlyQuery1.Next;
              continue;
              end;
           end;
    //если это тот рейс
   If (ZReadOnlyQuery1.FieldByName('id_shedule').AsString=full_mas[n,1])
            AND (ZReadOnlyQuery1.FieldByName('trip_type').AsString=full_mas[n,16])
            AND (timeDisp=timeShed)
            AND (ZReadOnlyQuery1.FieldByName('point_order').AsInteger=shed_order)
            AND (ZReadOnlyQuery1.FieldByName('trip_id_point').AsString=pnt)
       then
        begin
          fl_oper:=true;
       //если ОТМЕТКА СРЫВА Проставлена - откат
         If (ZReadOnlyQuery1.FieldByName('trip_flag').AsInteger=5) or (ZReadOnlyQuery1.FieldByName('trip_flag').AsInteger=6) then
          begin
             showmessagealt('Отметка СРЫВа уже УСТАНОВЛЕНА !'+#13+'для рейса № '+ZReadOnlyQuery1.FieldByName('id_shedule').AsString+'  время: '+ZReadOnlyQuery1.FieldByName('trip_time').AsString+#13+'-k13-');
             break;
           end;
           //помечаем на удаление записи предыдущих операций над этим рейсом
   ZReadOnlyQuery2.SQL.add('Update av_disp_oper SET del=1 WHERE del=0 ');//AND id_point_oper='+save_server);
   ZReadOnlyQuery2.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+ZReadOnlyQuery1.FieldByName('trip_type').AsString);
   ZReadOnlyQuery2.SQL.add(' AND id_shedule='+full_mas[n,1]+' AND trip_time='+QuotedStr(ZReadOnlyQuery1.FieldByName('trip_time').AsString));
   ZReadOnlyQuery2.SQL.add(' AND point_order='+ZReadOnlyQuery1.FieldByName('point_order').AsString+';');
   //showmessage(ZQ1.SQL.Text);//$

   ZReadOnlyQuery2.SQL.add('INSERT INTO av_disp_oper(id_user,createdate,del,id_point_oper,id_shedule,trip_type,trip_id_point,point_order,');
   ZReadOnlyQuery2.SQL.add('trip_date,trip_time,id_oper,platform,zakaz,trip_flag,');
   ZReadOnlyQuery2.SQL.add('atp_id,atp_name,avto_id,avto_name,avto_seats,avto_type,putevka,driver1,driver2,driver3,driver4,remark,vid_sriva) VALUES (');
   ZReadOnlyQuery2.SQL.add(inttostr(id_user)+',now(),0,'+sale_server+','+ZReadOnlyQuery1.FieldByName('id_shedule').AsString+','+ZReadOnlyQuery1.FieldByName('trip_type').AsString+',');
   ZReadOnlyQuery2.SQL.add(ZReadOnlyQuery1.FieldByName('trip_id_point').AsString+','+ZReadOnlyQuery1.FieldByName('point_order').AsString+',');
   ZReadOnlyQuery2.SQL.add(QuotedStr(ZReadOnlyQuery1.FieldByName('trip_date').AsString)+','+QuotedStr(ZReadOnlyQuery1.FieldByName('trip_time').AsString)+',');
   ZReadOnlyQuery2.SQL.add('4,'+ZReadOnlyQuery1.FieldByName('platform').AsString+','+ZReadOnlyQuery1.FieldByName('zakaz').AsString+',5,');
   ZReadOnlyQuery2.SQL.add(ZReadOnlyQuery1.FieldByName('atp_id').AsString+','+QuotedStr(ZReadOnlyQuery1.FieldByName('atp_name').AsString)+',');
   ZReadOnlyQuery2.SQL.add(ZReadOnlyQuery1.FieldByName('avto_id').AsString+','+QuotedStr(ZReadOnlyQuery1.FieldByName('avto_name').AsString)+',');
   ZReadOnlyQuery2.SQL.add(ZReadOnlyQuery1.FieldByName('avto_seats').AsString+','+ZReadOnlyQuery1.FieldByName('avto_type').AsString+',');
   ZReadOnlyQuery2.SQL.add(QuotedStr(ZReadOnlyQuery1.FieldByName('putevka').AsString)+',');
   ZReadOnlyQuery2.SQL.add(QuotedStr(ZReadOnlyQuery1.FieldByName('driver1').AsString)+','+QuotedStr(ZReadOnlyQuery1.FieldByName('driver2').AsString)+',');
   ZReadOnlyQuery2.SQL.add(QuotedStr(ZReadOnlyQuery1.FieldByName('driver3').AsString)+','+QuotedStr(ZReadOnlyQuery1.FieldByName('driver4').AsString)+','+QuotedStr(rem)+','+inttostr(vid)+');');

     //удалить все ведомости этого рейса
    If not form1.Vedom_Close(formMenu.ZConnection1, formMenu.ZReadOnlyQuery1, n) then
      begin
      showmessagealt('Ошибка закрытия посадочной ведомости на данный рейс !'+#13+'-k14-');
      break;
     end;

   //showmessage('D '+ZReadOnlyQuery2.SQL.Text);//$
    If DialogMess('Отметить СРЫВ на рейс:'+#13+'№ '+full_mas[n,1]+' ВРЕМЯ: '+ZReadOnlyQuery1.FieldByName('trip_time').AsString)=6  then
    begin
     ZReadOnlyQuery2.ExecSQL;
    end;
   //ZReadOnlyQuery2.ExecSQL;
   break;
   end;
    ZReadOnlyQuery1.Next;
  end;
  end;
  //если уже разобрались с текущим рейсом, переходим к следующему
  If fl_oper then continue;

  tmp:=PadL(inttostr(timeshed),'0',4);
  insert(':',tmp,3);

  //если над этим рейсом не было еще операций диспетчера
  //помечаем на удаление записи предыдущих операций над этим рейсом
   //ZReadOnlyQuery2.SQL.add('Update av_disp_oper SET del=1 WHERE del=0 AND id_point_oper='+save_server);
   //ZReadOnlyQuery2.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[n,16]);
   //ZReadOnlyQuery2.SQL.add(' AND id_shedule='+full_mas[n,1]+' AND trip_time='+QuotedStr(tmp)+' AND trip_id_point='+full_mas[n,3]);
   //ZReadOnlyQuery2.SQL.add(' AND point_order='+inttostr(shed_order)+';');

    ZReadOnlyQuery2.SQL.add('INSERT INTO av_disp_oper(id_user,createdate,del,id_point_oper,id_shedule,trip_type,trip_id_point,point_order,');
    ZReadOnlyQuery2.SQL.add('trip_date,trip_time,id_oper,platform,zakaz,trip_flag,');
    ZReadOnlyQuery2.SQL.add('atp_id,atp_name,avto_id,avto_name,avto_seats,avto_type,remark,vid_sriva) VALUES (');
    ZReadOnlyQuery2.SQL.add(inttostr(id_user)+',now(),0,'+sale_server+','+full_mas[n,1]+','+full_mas[n,16]+','+pnt+','+inttostr(shed_order)+',');
    ZReadOnlyQuery2.SQL.add(Quotedstr(tripdate)+','+QuotedStr(tmp)+',4,'+full_mas[n,2]+','+full_mas[n,0]+',5,');
    ZReadOnlyQuery2.SQL.add(full_mas[n,18]+','+QuotedStr(full_mas[n,19])+','+full_mas[n,20]+','+QuotedStr(full_mas[n,21])+',');
    ZReadOnlyQuery2.SQL.add(full_mas[n,25]+','+full_mas[n,27]+','+QuotedStr(rem)+','+inttostr(vid)+');');
    //showmessage(ZReadOnlyQuery2.SQL.Text);//$
   If DialogMess('Отметить СРЫВ на рейс:'+#13+'№ '+full_mas[n,1]+' ВРЕМЯ: '+tmp)=6
     then ZReadOnlyQuery2.ExecSQL;
     end;
    end;
     Zconnection1.Commit;
   except
     If ZConnection1.InTransaction then Zconnection1.Rollback;
     ZConnection1.disconnect;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL2: '+ZReadOnlyQuery2.SQL.Text+#13+'-k15-');
   end;
    ZReadOnlyQuery1.Close;
    ZReadOnlyQuery2.Close;
    Zconnection1.disconnect;
 end;
end;



//**********************         Запись операции ДИСПЕТЧЕРА **************      **************************************
procedure TFormMenu.insert_oper(ZCon:TZConnection;ZQ1,ZQ2:TZReadOnlyQuery;lg:byte);
//==================     КОДЫ ОПЕРАЦИЙ:   ================
  //1: ОТПРАВИТЬ РЕЙС
  //2: ОТМЕТИТЬ ПРИБЫТИЕ РЕЙСА
  //3: ОТКРЫТЬ ВЕДОМОСТЬ ДООБИЛЕЧИВАНИЯ
  //4: ОТМЕНИТЬ РЕЙС
  //5: СМЕНИТЬ АТП
  //6: ЗАБРОНИРОВАТЬ местА
  //7: СМЕНИТЬ АТС
  //8: ОТМЕТКА ОПОЗДАНИЯ РЕЙСА
  //9: ВЫЧЕРКНУТЫЕ БИЛЕТЫ
  //10: ЗАДАТЬ НОМЕР ПЛАТФОРМЫ
  //11: СОЗДАТЬ ЗАКАЗНОЙ РЕЙС
  //12: РЕЙС ЗАКРЫТЬ/СНЯТЬ ОТМЕТКУ СОСТОЯНИЯ (СРЫВА,ЗАКРЫТИЯ,ОПОЗДАНИЯ,ПРИБЫТИЯ)
  //13: РЕЙС ЗАКРЫТЬ ПРИОСТАНОВИТь
  //80: ОБЪЯВЛЕНИЕ о СВОБОДНЫХ МЕСТАХ
  //99: Просто сохранить данные рейса (НЕ ОТПРАВЛЯТЬ И НЕ ОТМЕЧАТЬ ПРИБЫТИЕ)
  //100: ОБЪЯВЛЕНИЕ ДЛЯ ОПАЗДЫВАЮЩИХ
var
  n,m:integer;
  pids:array of array of string;
  agg:string;
  fl_unlock:boolean=false;
  tripstate:string;
begin
    //заблокированные билеты
    tickets_blocked:=0;
    tick_cnt:=0;
    status:='-1';

 //сменить номер платофрмы
 If lg=10 then
    begin
 If FOrm1.SpinEdit1.text='0' then exit;
 If FOrm1.Panel3.Visible=false then exit;
    end;
   //находим элемент массива
  arn:=-1;
  arn:= masindex;
  If arn=-1 then exit;

  If full_mas[arn,16]='1' then
    begin
      arrive:=false;
      departure:=true;
      up_time := full_mas[arn,10];
      up_point:= full_mas[arn,3];
      up_order:= full_mas[arn,4];
    end
  else
  begin
    arrive:=true;
    departure:=false;
    up_time := full_mas[arn,12];
    up_point:= full_mas[arn,6];
    up_order:= full_mas[arn,7];
  end;
//статус рейса до операции
  tripstate:= full_mas[arn,28];

  If Zcon.Connected then
    begin
    If ZCon.InTransaction then Zcon.Rollback;
    Zcon.disconnect;
    end;

  tripdate:=datetostr(work_date);
  udalenka:=false;
  serv_real_virt:=0;
   //возвращаем параметры локального сервера
  sale_server:=ConnectINI[14];
  otkuda_name:=server_name;
  //если удаленка
  If (full_mas[arn,0]='3') or (full_mas[arn,0]='4') or (full_mas[arn,0]='5') then
  begin
   udalenka:=true;
   tripdate:=full_mas[arn,11];
   sale_server:=full_mas[arn,45];
   If not form1.virt_server() then serv_real_virt:=1  else serv_real_virt:=2;
  end;

 // Подключаемся к серверу
   If not(Connect2(Zcon, 1)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k16-');
      exit;
     end;
//2021-05-18 - снимаем длинные запросы и зависшие транзакции
    ZQ1.sql.Clear;
    ZQ1.sql.add('select find_destroy('+inttostr(max_transaction_time)+',0);');
     //showmessage(ZQ1.SQL.Text);//$
    try
        ZQ1.open;//*
        If (ZQ1.RecordCount>0) and (trim(ZQ1.Fields[0].AsString)<>'') then
     begin
         writelog(ZQ1.Fields[0].AsString+#13+'-k44-');
       end;

    except
      //If ZCon.InTransaction then Zcon.Rollback;
       //Zcon.disconnect;
       //operation:=0;
        writelog('Ошибка запроса !'+#13+ZQ1.sql.Text+#13+'-k45-');
        ZQ1.close;
       //exit;
    end;


    //Проверяем билеты рейса на блокировку, если операции отправления, срыва, вычеркивания   если операции смены перевозчика и автобуса
    //If (lg=1) or (lg=99) or (lg=4) or (lg=9) or (lg=5) or (lg=7) then //$
    If (lg=1) or (lg=4) or (lg=9) or (lg=5) or (lg=7) then
      begin
       //Проверяем место на блокировку и на факт изменения состояния места
   //(ищем вычеркнутые билеты и багаж, отправляющиеся с данного пунтка по этому рейсу)
    ZQ1.sql.Clear;
    ZQ1.sql.add('select * from seats_in_sale('+quotedstr(tripdate)+','+sale_server+',');
    ZQ1.sql.add(full_mas[arn,1]+','+quotedstr(full_mas[arn,10])+','+full_mas[arn,4]+','+full_mas[arn,25]+') as sale;');
    //  ZQ1.SQL.add('SELECT createdate FROM av_ticket WHERE trip_date='+Quotedstr(tripdate)+' AND id_shedule=');
    //ZQ1.SQL.add(full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND id_trip_ot='+up_point);
    //ZQ1.SQL.add(' AND order_trip_ot='+up_order+' AND id_trip_do='+full_mas[arn,6]);
    //ZQ1.SQL.add(' AND order_trip_do='+full_mas[arn,7]+' FOR UPDATE NOWAIT;');
    //showmessage(ZQ1.SQL.Text);//$
    try
        ZQ1.open;//*
    except
      If ZCon.InTransaction then Zcon.Rollback;
       Zcon.disconnect;
       operation:=0;
       showmessagealt('Операция временно недоступна !'+#13+'На данный рейс ведется продажа !'+#13+'-k17-');
       exit;
    end;
   If ZQ1.RecordCount>0 then
     begin
      //если есть места в блокировки
      If copy(ZQ1.FieldByName('sale').asString,1,1)='1' then
       begin
          //2021-05-18 - снимаем длинные запросы и зависшие транзакции
        ZQ1.sql.Clear;
        ZQ1.sql.add('select find_transactions('+inttostr(max_transaction_time)+',0);');
         //showmessage(ZQ1.SQL.Text);//$
        try
         ZQ1.open;//*

         If ZQ1.RecordCount>0 then
         begin
           if trim(ZQ1.Fields[0].AsString)<>'' then
           begin
            writelog(ZQ1.Fields[0].AsString+#13+'-k46-');
            IF DialogMess('Подтвердите снятие БЛОКИРОВКИ рейсов следующими кассами:'+#13+ ZQ1.Fields[0].AsString)=6
              THEN
              begin
                   ZQ1.sql.clear;
                   ZQ1.sql.add('select find_destroy('+inttostr(max_transaction_time)+',0);');
                      //showmessage(ZQ1.SQL.Text);//$
                   try
                     ZQ1.open;
                     fl_unlock:=true;
                     If ZQ1.RecordCount>0 then
                     begin
                          if trim(ZQ1.Fields[0].AsString)<>'' then
                             writelog(ZQ1.Fields[0].AsString+#13+'-k47-');
                     end;
                    except
                       writelog('Ошибка запроса !'+#13+ZQ1.sql.Text+#13+'-k48-');
                       ZQ1.close;
                    end;
                 showmessagealt('БЛОКИРОВКИ рейсов УСПЕШНО сняты !'+#13+'-k50-');
              end;
            end;
           end;
        except
          //If ZCon.InTransaction then Zcon.Rollback;
          //Zcon.disconnect;
          //operation:=0;
             writelog('Ошибка запроса !'+#13+ZQ1.sql.Text+#13+'-k49-');
             ZQ1.close;
          //exit;
        end;
         // ZQ1.sql.Clear;
         // ZQ1.sql.add(' SELECT a.datname, c.relname, a.client_addr, ');
         // ZQ1.sql.add(' (SELECT (select r.name from av_spr_point r where r.del=0 and r.id=t.point_id  order by createdate desc limit 1) as name ');
         // ZQ1.sql.add('  FROM av_servers t ');
         // ZQ1.sql.add('  where t.del=0 and ');
         // ZQ1.sql.add('  t.active=1 and ');
         // ZQ1.sql.add('(substr((a.client_addr)::text,1,8))=((substr(t.ip2,1,3)::integer)::text||''.''||(substr(t.ip2,5,3)::integer)::text||''.''||(substr(t.ip2,9,3)::integer)::text) and ');
         // ZQ1.sql.add('t.real_virtual=1 and ');
         // ZQ1.sql.add('trim(t.base_name)=trim(a.datname) limit 1 ');
         // ZQ1.sql.add(') as av_name, ');
         // ZQ1.sql.add('l.transactionid, ');
         //ZQ1.sql.add('l.mode, ');
         //ZQ1.sql.add('l.granted, ');
         //ZQ1.sql.add('a.usename, ');
         //ZQ1.sql.add('a.current_query, ');
         //ZQ1.sql.add('a.query_start, ');
         //ZQ1.sql.add('age(now(), a.query_start) AS "age", ');
         //ZQ1.sql.add('a.procpid ');
         //ZQ1.sql.add('FROM  pg_stat_activity a ');
         //ZQ1.sql.add(' JOIN pg_locks    l ON l.pid = a.procpid ');
         //ZQ1.sql.add(' JOIN pg_class    c ON c.oid = l.relation ');
         //ZQ1.sql.add(' where usename<>''postgres'' and relname not like ''%idx%'' and relname not like ''pg_%'' and mode=''RowShareLock'' ');
         //ZQ1.sql.add('ORDER BY a.query_start; ');
        //showmessage(ZQ1.SQL.Text);//$
       //try
       // ZQ1.open;//*
       //except
       // If ZCon.InTransaction then Zcon.Rollback;
       // Zcon.disconnect;
       // operation:=0;
       // showmessagealt('--------123-------'+#13+'Операция временно недоступна !'+#13+'На данный рейс ведется продажа !');
       // exit;
       //end;
       //   //setlength(pids,0,0);
       //  For n:=1 to ZQ1.RecordCount do
       //      begin
       //         agg:='';
       //         agg:=copy(trim(ZQ1.FieldByName('age').asString),4,2);
       //         try
       //           If strtoint(agg)>max_transaction_time then
       //           begin
       //               setlength(pids,length(pids)+1,3);
       //               pids[length(pids)-1,0]:=ZQ1.FieldByName('procpid').asString;
       //               pids[length(pids)-1,1]:=ZQ1.FieldByName('client_addr').asString;
       //               pids[length(pids)-1,2]:=ZQ1.FieldByName('av_name').asString;
       //            end;
       //         except
       //           ZQ1.Next;
       //           continue;
       //         end;
       //        ZQ1.Next;
       //       end;
       //  ZQ1.Close;
       //  fl_unlock:=false;
       //
       //  If length(pids)>0 then
       //   begin
       //     for n:=low(pids) to high(pids) do
       //         begin
       //           ZQ1.sql.Clear;
       //              showmessagealt('На рейс ВЕДЕТСЯ ПРОДАЖА !'+#13+'станцией:  '+pids[n,2]+#13+'по адресу:  '+pids[n,1]+#13+' более '+inttostr(max_transaction_time)+' минут !');
       //              If DialogMess('Снять БЛОКИРОВКУ рейса ?')=6 then
       //               begin
       //               fl_unlock:=true;
       //              ZQ1.sql.add('select pg_terminate_backend('+pids[n,0]+');');
       //               //showmessage(ZQ1.SQL.Text);//$
       //               try
       //                ZQ1.ExecSQL;
       //               except
       //                 ZQ1.close;
       //                 continue;
       //               end;
       //                showmessagealt('БЛОКИРОВКА РЕЙСА УСПЕШНО СНЯТА !'+#13+'Можете продожить операцию...');
       //               end;
       //         end;
       //     setlength(pids,0,0);
            //pids:=nil;
            //end;
    //если сняли блокировки
    If fl_unlock then
    begin
      //Контрольная Проверка мест на блокировку
      ZQ1.sql.Clear;
      ZQ1.sql.add('select * from seats_in_sale('+quotedstr(tripdate)+','+sale_server+',');
      ZQ1.sql.add(full_mas[arn,1]+','+quotedstr(full_mas[arn,10])+','+full_mas[arn,4]+','+full_mas[arn,25]+') as sale;');
       try
        ZQ1.open;//*
       except
        If ZCon.InTransaction then Zcon.Rollback;
       Zcon.disconnect;
       operation:=0;
       showmessagealt('Операция временно недоступна !'+#13+'На данный рейс ведется продажа !'+#13+'-k18-');
       exit;
      end;
       If ZQ1.RecordCount=1 then
      begin
       //если есть места в блокировки
      If copy(ZQ1.FieldByName('sale').asString,1,1)='1' then
       begin
         Zcon.disconnect;
         operation:=0;
         showmessagealt('Операция временно недоступна !'+#13+'На данный рейс ведется продажа !'+#13+'-k18-');
         exit;
        end;
       end;
     end;
     //если еще места продаются
     If not fl_unlock then
       begin
        Zcon.disconnect;
         operation:=0;
         showmessagealt('Операция временно недоступна !'+#13+'На данный рейс ведется продажа !'+#13+'-k19-');
         exit;
       end;
     end;
   end;
   end;
     //Проверяем есть ли билеты при срыве
   // If (lg=4) then
   //   begin
   // ZQ1.sql.Clear;
   // ZQ1.sql.add('select count(*) as kolvo from av_ticket WHERE trip_date='+Quotedstr(tripdate)+' AND id_shedule=');
   // ZQ1.SQL.add(full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND id_trip_ot='+up_point);
   // ZQ1.SQL.add(' AND order_trip_ot='+up_order+' AND id_trip_do='+full_mas[arn,6]);
   // ZQ1.SQL.add(' AND order_trip_do='+full_mas[arn,7]+';');
   // //showmessage(ZQ1.SQL.Text);//$
   // try
   //     ZQ1.open;//*
   // except
   //   If ZCon.InTransaction then Zcon.Rollback;
   //    Zcon.disconnect;
   //    operation:=0;
   //    //showmessagealt('--------012-------'+#13+'Операция временно недоступна !'+#13+'На данный рейс ведется продажа !');
   //    exit;
   // end;
   //If ZQ1.RecordCount=1 then
   //  begin
   //   tick_cnt:=ZQ1.FieldByName('kolvo').asInteger;
   //  end;
   //end;


   regtime:='';
     //Проверяем есть ли ПЕРЕБРОШЕННЫЕ билеты при закрытии
    If ((lg=12) and (strtoint(tripstate)<>5) and (strtoint(tripstate)<>6)) then
      begin
    ZQ1.sql.Clear;
    //ZQ1.sql.add('select substr(ticket_text,position('+Quotedstr('time=')+' in ticket_text)-5,position('+Quotedstr('|user:')+' in ticket_text)-position('+Quotedstr('time=')+' in ticket_text)+5) as regtime ');
    ZQ1.sql.add('SELECT split_part(split_part(ticket_text,''|П'',2),''|user:'',1) as regtime ');
    ZQ1.sql.add(' from av_ticket WHERE trip_date='+Quotedstr(tripdate)+' AND id_shedule='+full_mas[arn,1]);
    ZQ1.SQL.add(' AND trip_time='+QuotedStr(up_time));
    ZQ1.SQL.add(' AND id_trip_ot='+up_point+' AND order_trip_ot='+up_order);
    //ZQ1.SQL.add(' AND id_trip_do='+full_mas[arn,6]+' AND order_trip_do='+full_mas[arn,7]); //remark 20210611
    ZQ1.SQL.add(' AND position('+Quotedstr('|П')+' in ticket_text)>0 limit 1;');
    //showmessage(ZQ1.SQL.Text);//$
    try
        ZQ1.open;//*
    except
      If ZCon.InTransaction then Zcon.Rollback;
       Zcon.disconnect;
       operation:=0;
       //showmessagealt('--------012-------'+#13+'Операция временно недоступна !'+#13+'На данный рейс ведется продажа !');
       exit;
    end;
   If ZQ1.RecordCount>0 then
     begin
      regtime:=ZQ1.FieldByName('regtime').asString;
     end;
   end;


  fl_lock:=false;
  If (lg<>11) then
    begin
//Проверяем записЬ рейса на блокировку
    ZQ1.sql.Clear;
    ZQ1.sql.add('select * from trip_in_lock('+quotedstr(tripdate)+','+full_mas[arn,1]+',');
    ZQ1.sql.add(full_mas[arn,16]+','+quotedstr(full_mas[arn,10])+','+sale_server+','+full_mas[arn,4]+') as lock;');
    //ZQ1.SQL.add('SELECT * FROM av_disp_oper WHERE del=0 ');//AND id_point_oper='+save_server);
    //ZQ1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[arn,16]);
    //ZQ1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point);
    //ZQ1.SQL.add(' AND point_order='+up_order+' FOR UPDATE NOWAIT;');
    //showmessage(ZQ1.SQL.Text);//$
    try
        ZQ1.open;
    except
       If ZCon.InTransaction then Zcon.Rollback;
       Zcon.disconnect;
       operation:=0;
       showmessagealt('Операция временно недоступна !'+#13+'С данным рейсом уже работают !'+#13+'-k20-');
       exit;
    end;

    If ZQ1.Recordcount=1 then
     begin
         //если рейс в блокировке
       If ZQ1.FieldByName('lock').asInteger=2 then
         begin
             If ZCon.InTransaction then Zcon.Rollback;
             ZCon.disconnect;
             operation:=0;
             showmessagealt('Операция временно недоступна !'+#13+'С данным рейсом уже работают !'+#13+'-k21-');
             exit;
         end;
       //если есть записи рейса но нет блокировки
       If ZQ1.FieldByName('lock').asInteger=1 then
         begin
           fl_lock:=true;
           //showmessagealt('--!!!--');//$
         end;
     end;
  end;

  //если операций с рейсом еще не было (нечего блокировать) и еще нет подтверждения операции с формы диспетчером (fl_transact), то отвал
  If (fl_lock=false) and (fl_transact=false) and ((lg=1) or (lg=99) or (lg=2) or (lg=5) or (lg=6) or (lg=7)) then
   begin
   Zcon.Disconnect;
   exit;
   end;


   //запрашиваем последние диспетчерские операции для этого рейса
   //если процедура вызывается не с формы меню операций
   If fl_transact then
    form1.get_disp_oper(ZQ1,arn);

   //повторный запрос состояния рейса из массива
   tripstate:= full_mas[arn,28];

    If tripstate='-1' then
      begin
       ZQ1.Close;
       Zcon.Disconnect;
       operation:=0;
       showmessagealt('ОШИБКА ! Не определен статус рейса !'+#13+'-k22-');
       exit;
      end;
    try
       strtoint(tripstate);
    except
       ZQ1.Close;
       Zcon.Disconnect;
       operation:=0;
       showmessagealt('ОШИБКА преобразования СТАТУСА РЕЙСА !'+#13+'-k23-');
       exit;
    end;


   //ОТПРАВЛЕНИЕ РЕЙСА
     If (lg=1) or (lg=99) then
         begin
           //если РЕЙС ОТРАБОТАЛ - откат
           If strtoint(tripstate)>3 then
           begin
             Zcon.Disconnect;
             operation:=0;
             showmessage('OПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'РЕЙС ЗАКРЫТ !');
             exit;
           end;
         end;
     //ОТМЕТКА О ПРИБЫТИИ РЕЙСА
       If lg=2 then
         begin
           //если ОТМЕТКА уже проставлена - откат
           If strtoint(tripstate)=2 then
           begin
             operation:=0;
             Zcon.Disconnect;
             showmessage('ПРИБЫТИЕ РЕЙСА УЖЕ БЫЛО ОТМЕЧЕНО !');
             exit;
           end;
         end;
     //ДООБИЛЕЧИВАНИЕ
      If lg=3 then
         begin
           //если ОТМЕТКА ОТПРАВКИ НЕ Проставлена - откат
           If (strtoint(tripstate)<>4) then
           begin
              operation:=0;
             Zcon.Disconnect;
             showmessage('OПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'СНАЧАЛА ОТПРАВЬТЕ РЕЙС !');
             exit;
           end
           else
           status:='1';
         end;
      //СРЫВ
      If lg=4 then
      begin
       //если ОТМЕТКА СРЫВА Проставлена - откат
         If (strtoint(tripstate)=5) or (strtoint(tripstate)=6) then
          begin
             operation:=0;
             Zcon.Disconnect;
             showmessage('Отметка СРЫВа уже УСТАНОВЛЕНА !');
             exit;
           end
           else
           status:='5';
       end;

        //сменить номер платофрмы
       If lg=10 then
         begin
           //если платформа не изменилась - откат
           If (full_mas[arn,2])=form1.SpinEdit1.text then
           begin
              //operation:=0;
             Zcon.Disconnect;
             exit;
           end
           else (full_mas[arn,2]):=form1.SpinEdit1.text;
         end;
        //ОТМЕТКА ОПОЗДАНИЯ
      If lg=8 then
         begin
           //если ОТМЕТКА опоздания Проставлена
           If (strtoint(tripstate)=3) then
           status:='0' else status:='3';
           end;

      //ЗАКРЫТЬ РЕЙС/СНЯТЬ ОТМЕТКУ СОСТОЯНИЯ (ОТПРАВЛЕНИЯ,ПРИБЫТИЯ,СРЫВА,ЗАКРЫТИЯ)
       If lg=12 then
         begin
           //если РЕЙС ОТКРЫТ - ЗАКРЫВАЕМ
           If (strtoint(tripstate)=0) or (strtoint(tripstate)=1) or (strtoint(tripstate)=3) then
               status:='6';
           //ЕСЛИ РЕЙС БЫЛ НА ДООБИЛЕЧИВАНИИ, ТО ОН ДОЛЖЕН стать просто отправленым
            If (strtoint(tripstate)=1) then
               status:='4';
            //Если рейс был закрыт - открываем
           If (strtoint(tripstate)=2) or (strtoint(tripstate)=4)
               or (strtoint(tripstate)=5) or (strtoint(tripstate)=6) or (strtoint(tripstate)=7) then
             status:='0';
         end;

        //ЗАКРЫТЬ РЕЙС приостановить продажу
       If lg=13 then
         begin
           //если РЕЙС ОТКРЫТ - ЗАКРЫВАЕМ
           If (strtoint(tripstate)=0) or (strtoint(tripstate)=1) or (strtoint(tripstate)=3) then
               status:='7';
            //Если рейс был закрыт - открываем
           If (strtoint(tripstate)=2) or (strtoint(tripstate)=4)
               or (strtoint(tripstate)=5) or (strtoint(tripstate)=6) or (strtoint(tripstate)=7) then
             status:='0';
         end;

       //если статус рейса не изменился, тогда присваиваем ему значению массива
       If status='-1' then status:=tripstate;

       //проверка корректности статуса рейса после выполняемой операции
      //If not check_status_correct(lg,strtoint(status)) then
      //  begin
      //    showmessagealt('Ошибка данных ! 0.222'+#13+' Некорректное состояние рейса !'
      //    +#13+'операция:'+inttostr(lg)+'  статус:'+status);
      //    exit;
      //  end;

//Открываем транзакцию
try
   If not Zcon.InTransaction then
     begin
      Zcon.StartTransaction;
     end
   else
     begin
       If ZCon.InTransaction then Zcon.Rollback;
       ZCon.disconnect;
      operation:=0;
      showmessagealt('Ошибка ! Незавершенная транзакция !'+#13+'Попробуйте снова !'+#13+'-k24-');
      exit;
     end;

   // If (lg=4) then
   //  begin
   //   //БЛОКИРУЕМ все более поздние рейсы расписания на блокировку если срыв
   //   ZQ1.sql.Clear;
   //   ZQ1.SQL.add('SELECT * FROM av_disp_oper WHERE del=0 ');//AND id_point_oper='+save_server);
   //   ZQ1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+'AND id_shedule='+full_mas[arn,1]+' AND point_order>='+up_order+' ORDER BY point_order FOR UPDATE NOWAIT;');
   //   //showmessage(ZQ1.SQL.Text);//$
   //   end
   //else
   //begin


    If (lg<>11) AND fl_lock then
   begin
     ZQ1.sql.Clear;
   //БЛОКИРУЕМ ЗАПИСЬ РЕЙСА
   ZQ1.SQL.add('SELECT * FROM av_disp_oper WHERE del=0 ');//AND id_point_oper='+save_server);
   ZQ1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[arn,16]);
   ZQ1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point);
   ZQ1.SQL.add(' AND point_order='+up_order+' AND zakaz='+full_mas[arn,0]+' FOR UPDATE;');
   //showmessage(ZQ1.SQL.Text);//$
   ZQ1.open;
   //end;
    //если заблокировано больше одной записи, то отвал
    If ZQ1.RecordCount>1 then
      begin
       If ZCon.InTransaction then Zcon.Rollback;
     ZCon.disconnect;
     operation:=0;
     showmessagealt('Ошибка ! Больше одной записи по рейсу!!!'+#13+'Запрос SQL1: '+ZQ1.SQL.Text+#13+'-k24-');
     exit;
     end;
   end;

    //Блокируем билеты рейса, если операции отправления, срыва, бронирования, вычеркивания
    If (lg=1) or (lg=99) or (lg=4) or (lg=6) or (lg=9) or (lg=5) or (lg=7) then
      begin
    ZQ1.sql.Clear;
    ZQ1.SQL.add('SELECT * FROM av_ticket WHERE trip_date='+Quotedstr(tripdate));
    ZQ1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND id_trip_ot='+up_point);
    ZQ1.SQL.add(' AND order_trip_ot='+up_order+' type_oper=1 and type_ticket=1 FOR UPDATE;');
    //ZQ1.open;
    ////запоминаем что билеты в блокировке
    //tickets_blocked:=1;
    end;

      //Блокируем билеты расписания, если операции смены перевозчика и автобуса
    //If (lg=5) or (lg=7) then
    //  begin
    //ZQ1.sql.Clear;
    //ZQ1.SQL.add('SELECT createdate FROM av_ticket WHERE trip_date='+Quotedstr(tripdate));
    //ZQ1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' FOR UPDATE;');
    //ZQ1.open;
    ////проверяем есть ли вооще билеты на эти рейсы и запоминаем
    //tickets_blocked:=ZQ1.RecordCount;
    //end;


  //запись операции
  ZQ2.sql.Clear;
  ZQ2.SQL.add('INSERT INTO av_disp_oper(id_user,createdate,del,id_point_oper,id_shedule,trip_type,trip_id_point,point_order,');
  ZQ2.SQL.add('trip_date,trip_time,id_oper,platform,zakaz,trip_flag,');
  ZQ2.SQL.add('atp_id,atp_name,avto_id,avto_name,avto_seats,avto_type,');
  ZQ2.SQL.add('putevka,driver1,driver2,driver3,driver4,vid_sriva,remark) VALUES (');
 //СРЫВ
  //ОТМЕНА РЕЙСА (СРЫВ)

  //3: ОТКРЫТЬ ВЕДОМОСТЬ ДООБИЛЕЧИВАНИЯ
  //4: ОТМЕНИТЬ РЕЙС
  //6: ЗАБРОНИРОВАТЬ местА
  //8: ОТМЕТКА ОПОЗДАНИЯ РЕЙСА
  //9: ВЫЧЕРКНУТЫЕ БИЛЕТЫ
  //10: ЗАДАТЬ НОМЕР ПЛАТФОРМЫ
  //12: РЕЙС ЗАКРЫТЬ/СНЯТЬ ОТМЕТКУ СОСТОЯНИЯ (СРЫВА,ЗАКРЫТИЯ,ОПОЗДАНИЯ,ПРИБЫТИЯ)
  //13: Рейс закрыть временно ПРИОСТАНОВИТь
  //100: ОБЪЯВЛЕНИЕ ДЛЯ ОПАЗДЫВАЮЩИХ
   If (lg=3) or (lg=4) or (lg=6) or (lg=8) or (lg=9) or (lg=10) or (lg=100) or (lg=80) or (lg=12) or (lg=13) then
     begin
     ZQ2.SQL.add(inttostr(id_user)+',');
     //при выдаче объявлений сообщений опаздывающим пассажирам, менять время операции +1 минута от последней операции
    If (lg=100) then ZQ2.SQL.add('cast('+QuotedStr(full_mas[arn,30]+#32+timetostr(strtotime(full_mas[arn,31])))+' as timestamp) +'+quotedstr('1 minute'));
    if (lg=80) then ZQ2.SQL.add('now()-interval '+ quotedstr('2 minute'));
    If not((lg=80) or (lg=100)) then ZQ2.SQL.add('now()');
     ZQ2.SQL.add(',0,'+ConnectINI[14]+','+full_mas[arn,1]+','+full_mas[arn,16]+','+up_point+','+up_order+',');
     ZQ2.SQL.add(Quotedstr(tripdate)+','+QuotedStr(up_time)+','+inttostr(lg)+','+full_mas[arn,2]+','+full_mas[arn,0]+','+status+',');
     ZQ2.SQL.add(full_mas[arn,18]+','+QuotedStr(full_mas[arn,19])+','+full_mas[arn,20]+','+QuotedStr(full_mas[arn,21])+','+full_mas[arn,25]+','+full_mas[arn,27]+',');
     ZQ2.SQL.add(QuotedStr(full_mas[arn,35])+','+QuotedStr(full_mas[arn,36])+','+QuotedStr(full_mas[arn,37])+','+QuotedStr(full_mas[arn,38])+','+QuotedStr(full_mas[arn,39])+',');
      IF not((lg=13) or (lg=12) or (lg=4) or (lg=8)) then
     ZQ2.SQL.add('default,'+QuotedStr(full_mas[arn,33])+');');
   //showmessage(ZQ2.SQL.Text);//$
    end;

  //1: ОТПРАВИТЬ РЕЙС
  //2: ОТМЕТИТЬ ПРИБЫТИЕ РЕЙСА
  //5: СМЕНИТЬ АТП
  //7: СМЕНИТЬ АТС
  //99: СОХРАНИТЬ РЕКВИЗИТЫ
   If (lg=1) or (lg=99) or (lg=2) or (lg=5) or (lg=7) then
     begin
      ZQ2.SQL.add(inttostr(id_user)+',now(),0,'+ConnectINI[14]+','+full_mas[arn,1]+','+full_mas[arn,16]+','+up_point+','+up_order+',');
      ZQ2.SQL.add(Quotedstr(tripdate)+','+QuotedStr(up_time)+',');
      If (lg=5) or (lg=7) then ZQ2.SQL.add(inttostr(lg)+','+full_mas[arn,2]+','+full_mas[arn,0]+','+status+',');
     end;
   //showmessage(ZQ2.SQL.Text);//$

//помечаем на удаление записи предыдущих операций над этим рейсом
  If (lg<>1) and (lg<>99) and (lg<>2) and (lg<>5) and (lg<>7) then
   begin
   ZQ1.sql.Clear;
   ZQ1.SQL.add('Update av_disp_oper SET del=1 WHERE del=0 ');//AND id_point_oper='+save_server);
   ZQ1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[arn,16]);
   ZQ1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point);
   ZQ1.SQL.add(' AND point_order='+up_order+';');
   //showmessage(ZQ1.SQL.Text);//$
   ZQ1.ExecSql;
   end;

/////**************|||||||   если не было билетов на этом рейсе
//*****************|||||||  и выполняемая операция не совадает с вышеперечисленными (пустой запрос) - то закрываем транзакцию и соединение

  If (trim(ZQ2.sql.Text)='') and (tickets_blocked=0) then
   begin
   showmessagealt('НЕТ билетов или операций !'+#13+'-k25-');
   If Zcon.Connected then
    begin
    If ZCon.InTransaction then Zcon.Rollback;
    Zcon.disconnect;
    end;
   exit;
   end;

   //Zcon.Commit;
except
     If ZCon.InTransaction then Zcon.Rollback;
     ZCon.disconnect;
     operation:=0;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'
     //+#13+'Запрос SQL1: '+ZQ1.SQL.Text
     +#13+'Запрос SQL2: '+ZQ2.SQL.Text+#13+'-k26-');
     exit;
end;
  //If (lg<>4) and (lg<>1) and (lg<>5) and (lg<>7) then ZQ1.Close;
  //ZQ2.Close;
  //ZReadOnlyQuery2 оставляем открытым, чтобы в дальнейшем дописать и выполнить COMMIT
  //Zcon.disconnect;
end;


procedure TFormMenu.StringGrid3DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  SetRowColorMenu(FormMenu.Stringgrid3,aCol,aRow,aRect);
end;


//*************************  выполнение пункта меню диспетчера  *****************************
function TFormMenu.razbor(num:byte):byte;
var
  oper : integer=0;
  //perm : integer=0;
  finish:boolean=false;
  terminate:boolean=false;
begin
  Result:=0;
  with FOrmMenu do
begin
  form1.paintmess(formmenu.StringGrid3,'ПОДОЖДИТЕ ...',clGreen);
  //если 99, тогда по строчке грида, иначе по номеру
  If num=99 then num:=Stringgrid3.row;
  //проверка строчки меню
   If (trim(Stringgrid3.Cells[1,num])='') or (Stringgrid3.rowcount<1) then exit;
   try
     oper:=strtoint(Stringgrid3.Cells[2,num])
   except
     on exception: EConvertError do exit;
   end;
 //проверка уровня доступа
   If Stringgrid3.Cells[0,num]='1' then
   begin
     showmessagealt('ОПЕРАЦИЯ НЕДОСТУПНА !'+#13+'ОГРАНИЧЕНИЕ ДОСТУПА ТОЛЬКО НА ЧТЕНИЕ !'+#13+'-k27-');
     exit;
   end;
  If Stringgrid3.Cells[0,num]='0' then
   begin
     showmessage('ОПЕРАЦИЯ ЗАПРЕЩЕНА !');
     exit;
   end;
   //try
   //  perm:=strtoint(Stringgrid3.Cells[0,num])
   //except
   //  on exception: EConvertError do exit;
   //end;

  active_oper:=true; //флаг выполнения операции

  //разбираем условия
//=================    ОТПРАВИТЬ РЕЙС =====================
   // id_menu=21 Oper=1
  If oper=21 then Result:=1;

//=================    Отметить прибытие рейса =====================
   // id_menu=22 Oper=2
  If oper=22 then Result:=2;

//=================    Открыть дообилечивание =====================
  // id_menu=23 Oper=3
  If oper=23 then
    begin
    //showmessage(full_mas[masindex,33]);//$
    form1.getfreeseats(masindex);   // РАСЧЕТ СВОБОДНЫХ МЕСТ НА РЕЙС
    If (full_mas[masindex,34]='0') or (full_mas[masindex,34]='') or (full_mas[masindex,34]='--') then
      begin
      showmessage('На данном рейсе НЕТ СВОБОДНЫХ МЕСТ !');
      FormMenu.Close;
      active_oper:=false; //флаг выполнения операции
      exit;
      end;
    Result:=3;
    insert_oper(formMenu.Zconnection1,formMenu.ZReadOnlyQuery1,formMenu.ZReadOnlyQuery2,3);

    //showmessage(formMenu.ZReadOnlyQuery1.SQL.Text);//$
    //showmessage(formMenu.ZReadOnlyQuery2.SQL.Text);//$
    If formMenu.Zconnection1.Connected then
      begin
     If DialogMess('Подтвердите открытие рейса на дообилечивание...')=6 then
       begin
         finish:=true;
       end
       else terminate:=true;
      end
    else
      begin
      terminate:=true;
      end;
    end;

//=================    АТП СМЕНИТЬ =====================
  // id_menu=25 Oper=5
  If oper=25 then Result:=5;

//=================    Бронь =====================
  // id_menu=26 Oper=6
  If oper=26 then Result:=6;
  //Спец Бронь
  If oper=58 then
    begin
    Result:=6;
    specbron:=true;
    end;
//=================   Вычеркнутые билеты =====================
 // id_menu=29 Oper=9
  If oper=29 then Result:=9;

//=================   АВТОБУС СМЕНИТЬ =====================
  // id_menu=27 Oper=7
  If oper=27 then Result:=7;

//=================   опоздание отметить =====================
  // id_menu=28 Oper=8
  If (oper=28) or (flag_late) then
    begin
      If not flag_late then
        begin
    insert_oper(formMenu.Zconnection1,formMenu.ZReadOnlyQuery1,formMenu.ZReadOnlyQuery2,8);
    If formMenu.Zconnection1.Connected then
      begin
    If (status='3') then
     begin
       If (menu_canceled()=false) then
        begin
          Result:=8;
          rem:='ПРЕТЕНЗИОННОЕ ОПОЗДАНИЕ РЕЙСА';
          vid:=late_pretens;
         If DialogMess('Подтвердите ОПОЗДАНИЕ РЕЙСА...')=6 then
         begin
         finish:=true;
         ZReadOnlyQuery2.SQL.Add(inttostr(vid)+','+Quotedstr(rem)+');');
         end
         else terminate:=true;
        end;
     end;
     If (status='0') then
       begin
       If DialogMess('Подтвердите СНЯТИЕ отметки ОПОЗДАНИЯ РЕЙСА')=6 then
         begin
        finish:=true;
        ZReadOnlyQuery2.SQL.Add('0,'''');');
        Result:=8;
        end;
        end;
      end
      else
       begin
        terminate:=true;
       end;
    end
      else
      begin
       If formMenu.Zconnection1.Connected and (status='3') then
      begin
     //если повторный вызов из вариантов опоздания
      finish:=true;
      ZReadOnlyQuery2.SQL.Add(inttostr(vid)+','+Quotedstr(rem)+');');
      Result:=8;
      end
      else
       begin
        terminate:=true;
       end;
      end;
    end;


//================= задать номер платформы ================
  // id_menu=30 Oper=10
  If oper=30 then Result:=10;

  //=================    ОТМЕНИТЬ РЕЙС (СРЫВ)    =====================
  // id_menu=24 Oper=4
  If (oper=24) or flag_sriv then
    begin
      //если вызов не из меню видов срыва
      If not flag_sriv then
        begin
          rem:='';
          vid:=0;
      insert_oper(formMenu.Zconnection1,formMenu.ZReadOnlyQuery1,formMenu.ZReadOnlyQuery2,4); //блокировка рейсов и билетов на них
      //если нет меню вида срыва - указать руками
       If formMenu.Zconnection1.Connected then
          begin
      If (menu_canceled()=false) then
        begin
          vid:=1;
        repeat
            rem:= InputBox('ОТМЕНА РЕЙСА','ВВЕДИТЕ ПРИЧИНУ ОТМЕНЫ РЕЙСА...','');
        until rem<>'';
         If DialogMess('ПОДТВЕРЖДАЕТЕ ОПЕРАЦИЮ СРЫВА РЕЙСА ?')=6 then
         begin
         finish:=true;
         flsearch_sriv:=true;
         ZReadOnlyQuery2.SQL.Add(inttostr(vid)+','+Quotedstr(rem)+');');
         //проверяем есть ли проданные билеты
         If tick_cnt>0 then
          If DialogMess(#13+#13+'ПЕРЕОФОРМИТЬ БИЛЕТЫ РЕЙСА НА ЗАКАЗНОЙ РЕЙС ?')=6 then
             perenos_biletov:=masindex; //есть возможность перекинуть билеты
         end
         else terminate:=true;
        //sriv_insert;
        Result:=4;
        end;
          end
       else
        begin
         terminate:=true;
        end;
        end
      else
      //если повторный вызов из меню видов срыва
        begin
           If DialogMess('ПОДТВЕРЖДАЕТЕ ОПЕРАЦИЮ СРЫВА РЕЙСА ?')=6 then
         begin
         finish:=true;
         flsearch_sriv:=true;
         ZReadOnlyQuery2.SQL.Add(inttostr(vid)+','+Quotedstr(rem)+');');
          //проверяем есть ли проданные билеты
          //showmessage(trim(copy(full_mas[masindex,34],1,pos('/',full_mas[masindex,34])-1))+'\'+trim(full_mas[masindex,25]));//$
         //If not((trim(copy(full_mas[masindex,34],1,pos('/',full_mas[masindex,34])-1))=trim(full_mas[masindex,25]))
         //   or (full_mas[masindex,34]='') or (full_mas[masindex,34]='--')) then
         If tick_cnt>0 then
          If DialogMess('ПЕРЕОФОРМИТЬ БИЛЕТЫ РЕЙСА НА ЗАКАЗНОЙ РЕЙС ?')=6 then
             perenos_biletov:=masindex; //есть возможность перекинуть билеты
         end
         else
         begin
         terminate:=true;
         end;
                //sriv_insert;
           Result:=4;
         end;
    end;

  // Переоформить билеты на другой рейс
  If (oper=777) then
  begin
   // Подключаемся к серверу
   If not(Connect2(Zconnection1, 1)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k28-');
      exit;
     end;

    //Подсчитываем кол-во билетов на рейс
    ZReadOnlyQuery1.sql.Clear;
    ZReadOnlyQuery1.sql.add('select 1 as bil from av_ticket WHERE trip_date='+Quotedstr(tripdate)+' AND id_shedule=');
    ZReadOnlyQuery1.SQL.add(full_mas[masindex,1]+' AND trip_time='+QuotedStr(up_time)+' AND id_trip_ot='+up_point);
    ZReadOnlyQuery1.SQL.add(' AND order_trip_ot='+up_order);
    //ZReadOnlyQuery1.SQL.add(' AND id_trip_do='+full_mas[masindex,6]); //remark 20210611 чтобы видели все билеты
    //ZReadOnlyQuery1.SQL.add(' AND order_trip_do='+full_mas[masindex,7]);//remark 20210611 чтобы видели все билеты
    ZReadOnlyQuery1.SQL.add(' LIMIT 1;');
    //showmessage(ZReadOnlyQuery1.SQL.Text);//$
    tick_cnt:=0;
    try
        ZReadOnlyQuery1.open;//*
    except
      If Zconnection1.InTransaction then Zconnection1.Rollback;
       Zconnection1.disconnect;
       operation:=0;
       //showmessagealt('--------012-------'+#13+'Операция временно недоступна !'+#13+'На данный рейс ведется продажа !');
       exit;
    end;
   If ZReadOnlyQuery1.RecordCount=1 then
     begin
      tick_cnt:=ZReadOnlyQuery1.FieldByName('bil').asInteger;
     end;
   If tick_cnt>0 then
    begin
     If DialogMess(#13+#13+'ПОДТВЕРЖДАЕТЕ ОПЕРАЦИЮ ПЕРЕОФОРМЛЕНИЯ'+#13+'БИЛЕТОВ РЕЙСА НА ЗАКАЗНОЙ РЕЙС ?')=6 then
     begin
      perenos_biletov:=masindex; //есть возможность перекинуть билеты
      Result:=11;
     end;
    end
    else
    begin
       showmessage('НЕТ проданных билетов на данный рейс !');
       Result:=0;
     end;
    ZConnection1.Disconnect;
    active_oper:=false; //флаг выполнения операции
  end;


//=================   ЗАКРЫТЬ РЕЙС/ СНЯТЬ ОТМЕТКУ (ОТПРАВЛЕНИЯ,СРЫВА,ПРИБЫТИЯ,ОПОЗДАНИЯ,ЗАКРЫТИЯ) =====================
   // id_menu=32 Oper=12
  If oper=32 then
     begin
       rem:='';
       Result:=12;
        insert_oper(formMenu.Zconnection1,formMenu.ZReadOnlyQuery1,formMenu.ZReadOnlyQuery2,12);
        If formMenu.Zconnection1.Connected then
          begin
            //status - будущий статус на снятие отметок
          //если рейс нужно открыть или снять с дообилечивания
            If (status='0') or (status='4') then
              begin
              vid:=0;
             If DialogMess('Подтвердите СНЯТИЕ ОТМЕТКИ на рейсе...')=6 then
               finish:=true else terminate:=true;
              ZReadOnlyQuery2.SQL.Add(inttostr(vid)+','+Quotedstr(rem)+');');
              end
            else
            begin
              If DialogMess('ПОДТВЕРЖДАЕТЕ ЗАКРЫТИЕ РЕЙСА ?')=6 then
                begin
                If full_mas[masindex,0]='1' then
                begin
                repeat
                rem:= InputBox('ЗАКРЫТИЕ РЕЙСА','ВВЕДИТЕ ПРИЧИНУ ЗАКРЫТИЯ РЕЙСА...','');
                until rem<>'';
                end;
                vid:=1;
                ZReadOnlyQuery2.SQL.Add(inttostr(vid)+','+Quotedstr(rem)+');');
                 //проверяем есть ли ПЕРЕБРОШЕННЫЕ билеты
                   If (regtime<>'') then
                    If DialogMess(#13+#13+'ЗАКРЫТИЕ РЕЙСА ПРИВЕДЕТ К'+#13+'ПЕРЕНОСУ БИЛЕТОВ НА РЕГУЛЯРНЫЙ РЕЙС !'+#13+'ПОДТВЕРЖДАЕТЕ ЗАКРЫТИЕ РЕЙСА ?')=7 then
                    terminate:=true
                    else
                    begin
                       formMenu.ZReadOnlyQuery2.SQL.add('UPDATE av_ticket SET zakaz=0,'+regtime);
                       //formMenu.ZReadOnlyQuery2.SQL.add(' id_shedule='+full_mas[idx,1]+',id_trip_ot='+full_mas[idx,3]+',id_trip_do='+full_mas[idx,6]+',order_trip_ot='+full_mas[idx,4]+',');
                       //formMenu.ZReadOnlyQuery2.SQL.add(' order_trip_do='+full_mas[idx,7]+',id_kontr='+kontr_id+',id_ats='+ats_id+',');
                       formMenu.ZReadOnlyQuery2.SQL.add(' WHERE trip_date='+Quotedstr(tripdate)+' AND id_shedule='+full_mas[masindex,1]+' AND trip_time='+Quotedstr(Full_mas[masindex,10]));
                       formMenu.ZReadOnlyQuery2.SQL.add(' AND id_trip_ot='+full_mas[masindex,3]+' AND order_trip_ot='+full_mas[masindex,4]);
                       formMenu.ZReadOnlyQuery2.SQL.add(' AND id_trip_do='+full_mas[masindex,6]+' AND order_trip_do='+full_mas[masindex,7]);
                       formMenu.ZReadOnlyQuery2.SQL.add(' AND id_user>0 and tarif>0;');
                       //showmessage(formMenu.ZReadOnlyQuery2.SQL.Text);//$
                    end;
                  finish:=true;

                end
              else terminate:=true;
            end;
             If finish then
              begin
              //удалить все ведомости этого рейса
                  If not form1.Vedom_Close(formMenu.ZConnection1, formMenu.ZReadOnlyQuery1, arn) then
                    begin
                    showmessagealt('Ошибка закрытия посадочной ведомости на данный рейс !'+#13+'-k28-');
                    terminate:= true;
                    end;
               end;
          end
           else
           begin
           terminate:=true;
           end;
        END;


  //=================   ЗАКРЫТЬ РЕЙС ПРИОСТАНОВИТЬ ФОРМ МАЖОР ====изменения от 20200610=================
   // id_menu=61 Oper=13
  If oper=61 then
     begin
       rem:='';
       Result:=13;
        insert_oper(formMenu.Zconnection1,formMenu.ZReadOnlyQuery1,formMenu.ZReadOnlyQuery2,13);
        If formMenu.Zconnection1.Connected then
          begin
            //status - будущий статус на снятие отметок
          //если рейс нужно открыть или снять с дообилечивания
            If (status='0') or (status='4') then
              begin
              vid:=0;
             If DialogMess('Подтвердите СНЯТИЕ ОТМЕТКИ на рейсе...')=6 then
               finish:=true else terminate:=true;
              ZReadOnlyQuery2.SQL.Add(inttostr(vid)+','+Quotedstr(rem)+');');
              end
            else
            begin
              If DialogMess('ПОДТВЕРЖДАЕТЕ ЗАКРЫТИЕ РЕЙСА ?')=6 then
                begin
                rem:='';
                vid:=1;
                ZReadOnlyQuery2.SQL.Add(inttostr(vid)+','+Quotedstr(rem)+');');
                finish:=true;
                end
              else terminate:=true;
            end;
          end
           else
           begin
           terminate:=true;
           end;
    END;


//================= Создать заказной рейс =================
  // id_menu=31 Oper=11
  If oper=31 then Result:=11;
     // Проверяем что не транзит
     //if trim(full_mas[arn,9])='0' then
     // begin
     //  showmessagealt('Для транзитного расписания невозможно создать ЗАКАЗНОЙ РЕЙС !!!');//+#13+'Для создания ЗАКАЗНОГО РЕЙСА выберите расписание'+#13+'с формирующимся текущим остановочным пунктом и'+#13+'признаком [РЕЙС ОТПРАВЛЕНИЯ].');
     //  exit;
     // end;
     //// Проверяем что рейс ОТПРАВЛЕНИЯ
     //if trim(full_mas[arn,16])='2' then
     // begin
     //  showmessagealt('Для РЕЙСА ПРИБЫТИЯ невозможно создать ЗАКАЗНОЙ РЕЙС !!!');//+#13+'Для создания ЗАКАЗНОГО РЕЙСА выберите расписание'+#13+'с формирующимся текущим остановочным пунктом и'+#13+'признаком [РЕЙС ОТПРАВЛЕНИЯ].');
     //  exit;
     // end;
       //form1.start_form_option(1);
      //set_object_zakaz(arn);
//====================================

//вывести список пассажиров с телефонами
If oper=57 then
begin
 active_oper:=false; //флаг выполнения операции
 showtels();
 Result:=0;
 exit;
end;

If finish then
  begin
   try
     //showmessage(ZReadOnlyQuery2.SQL.text);//$
     //showmessage(ZReadOnlyQuery1.SQL.text);//$
     ZReadOnlyQuery2.ExecSql;
     Zconnection1.Commit;
   except
     If ZConnection1.InTransaction then Zconnection1.Rollback;
     ZConnection1.disconnect;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL2: '+ZReadOnlyQuery2.SQL.Text+#13+'-k29-');
     active_oper:=false; //флаг выполнения операции
     exit;
   end;
    ZReadOnlyQuery1.Close;
    ZReadOnlyQuery2.Close;
    Zconnection1.disconnect;
    active_oper:=false; //флаг выполнения операции
    //Result:=true;
   end;

 If terminate then
  begin
    If ZConnection1.Connected then
    begin
    If ZConnection1.InTransaction then Zconnection1.Rollback;
    ZConnection1.disconnect;
    end;
    ZReadOnlyQuery1.Close;
    ZReadOnlyQuery2.Close;
    active_oper:=false; //флаг выполнения операции
  end;

   //если операция по виртуальному серверу, то записать локально
  If udalenka and (terminate or finish) then
   begin
   //получить последнее состояние рейса по диспетчерским операциям
  // Подключаемся к серверу
   If not(Connect2(formmenu.Zconnection1, 1)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k30-');
      exit;
     end;
  try
  form1.get_disp_oper(formmenu.ZReadOnlyQuery1,arn);
  finally
    formmenu.ZReadOnlyQuery1.Close;
    formmenu.ZConnection1.Disconnect;
  end;
   formmenu.insert_remote_oper(ZConnection1, ZReadOnlyQuery1, Result, inttostr(id_user), formatDatetime('dd-mm-yyyy hh:nn:ss',now()));
  //если транзакция еще открыта - откатываемся
    If Zconnection1.Connected then
      begin
       ZReadOnlyQuery1.Close;
       If ZConnection1.InTransaction then Zconnection1.Rollback;
       ZConnection1.disconnect;
       end;
   end;

 end;
end;



//*****************************************           запись вида срыва рейса   *****************************
function TFORMMenu.razbor_canceled():boolean;
begin
 result:=false;
  with FOrmMenu do
begin
  //проверка строчки меню
   If (trim(Stringgrid4.Cells[1,Stringgrid4.row])='') or (Stringgrid4.rowcount<1) then exit;
   try
     vid:=strtoint(Stringgrid4.Cells[2,Stringgrid4.row]);
   except
     on exception: EConvertError do exit;
   end;
 //проверка уровня доступа
   If Stringgrid4.Cells[0,Stringgrid4.Row]='1' then
   begin
     showmessagealt('ОПЕРАЦИЯ НЕДОСТУПНА !'+#13+'ОГРАНИЧЕНИЕ ДОСТУПА ТОЛЬКО НА ЧТЕНИЕ !'+#13+'-k31-');
     exit;
   end;
  //If Stringgrid4.Cells[0,Stringgrid4.Row]='0' then
   //begin
     //showmessagealt('ОПЕРАЦИЯ ЗАПРЕЩЕНА !');
     //exit;
   //end;
  rem:=Stringgrid4.Cells[1,Stringgrid4.Row];

//если выбран пункт ДРУГОЕ вывести поле ввода
  If vid=33 then
    begin
     rem:='';
     vid:=1;
        repeat
            rem:= InputBox('ОТМЕНА РЕЙСА','ВВЕДИТЕ ПРИЧИНУ ОТМЕНЫ РЕЙСА...','');
        until rem<>'';
    end;
  If status='3' then flag_late:=true;
  If status='5' then flag_sriv:=true;
   Result:=true;
end;
end;

procedure TFormMenu.StringGrid3Selection(Sender: TObject; aCol, aRow: Integer);
begin
 //If stringgrid3.Width<360 then
 begin
  If (napr='up')   and (Stringgrid3.Row=0) then exit;
  If (napr='down') and (Stringgrid3.Row=Stringgrid3.RowCount-1) then exit;
  //проскакиваем если не разрешено
  If (napr='up')   and (Stringgrid3.Cells[0,Stringgrid3.Row]='0') then Stringgrid3.Row:=Stringgrid3.Row-1;
  If (napr='down') and (Stringgrid3.Cells[0,Stringgrid3.Row]='0') then Stringgrid3.Row:=Stringgrid3.Row+1;
  end;
end;

procedure TFormMenu.StringGrid4DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  SetRowColorMenu(FormMenu.Stringgrid4,aCol,aRow,aRect);
end;


//*****************************       Загрузка меню СРЫВА РЕЙСА    ******************************
function TFormMenu.menu_canceled():boolean;
begin
  Result:=false;
  With FormMenu do
begin
  If not Zconnection1.Connected then
  begin
  // Подключаемся к серверу
   If not(Connect2(Zconnection1, 1)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k32-');
      exit;
     end;
   end;
  ZReadOnlyQuery1.SQL.Clear;
  ZReadOnlyQuery1.SQL.add('SELECT b.id_local,b.loc_name as name,b.tab_loc ');
  ZReadOnlyQuery1.SQL.add(',coalesce((SELECT a.permition FROM av_users_menu_perm a WHERE a.id_menu_loc=b.id_local AND a.id_arm=b.id_arm ');
  ZReadOnlyQuery1.SQL.add('AND a.id_menu_loc>0 AND a.del=0 AND a.id='+inttostr(id_user));
  ZReadOnlyQuery1.SQL.add(' ORDER BY a.createdate DESC LIMIT 1),0) as permition ');
  ZReadOnlyQuery1.SQL.add('FROM av_arm_menu b ');
  ZReadOnlyQuery1.SQL.add('WHERE b.id_arm='+inttostr(id_arm)+' and b.del=0 and b.id_public='+trim(stringgrid3.Cells[2,Stringgrid3.Row])+' and b.id_local>0 order by b.tab_loc;');
   //showmessage(ZReadOnlyQuery1.SQL.Text);//$
    try
        ZReadOnlyQuery1.open;
    except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text+#13+'-k33-');
       Zconnection1.disconnect;
       exit;
    end;
    if ZReadOnlyQuery1.RecordCount<1 then
       begin
         //showmessagealt('Нет доступного меню для выбранного пользователя !');
        ZReadOnlyQuery1.close;
         exit;
       end;
    stringgrid4.RowCount:=0;
    //заполняем грид меню
    for n:=1 to ZReadOnlyQuery1.RecordCount do
      begin
        stringgrid4.RowCount := stringgrid4.RowCount +1;
        stringgrid4.Cells[2,stringgrid4.RowCount-1]:=ZReadOnlyQuery1.FieldByName('id_local').AsString;
        stringgrid4.Cells[1,stringgrid4.RowCount-1]:=ZReadOnlyQuery1.FieldByName('name').AsString;
        stringgrid4.Cells[0,stringgrid4.RowCount-1]:=ZReadOnlyQuery1.FieldByName('permition').AsString;
        ZReadOnlyQuery1.Next;
     end;

   ZReadOnlyQuery1.Close;
   stringgrid4.Left:=2;
   stringgrid4.Top :=2;
   stringgrid4.height:=460;
   stringgrid4.width :=350;
   stringgrid4.ColWidths[0]:=10;
   stringgrid4.ColWidths[1]:=340;
   stringgrid4.ColWidths[2]:=0;
   Stringgrid4.Visible:=true;
   Stringgrid4.Row:=0;
   Stringgrid4.SetFocus;
   Result:=true;
  end;
end;


//*****************************       Загрузка меню Диспетчера    ******************************
function TFormMenu.menu_load():boolean;
var
 myDay : integer;
 fact_time,plan_time: Tdatetime;
 tripstatus:string;
begin
//находим элемент массива
 arn:=-1;
 arn:=masindex;
 If (arn<0) or (arn>=length(full_mas)) then exit;

//возвращаем параметры локального сервера
 sale_server:=ConnectINI[14];
 tripdate:=datetostr(work_date);
 udalenka:=false;
 serv_real_virt:=0;
 tripstatus:=full_mas[arn,28];

 //проверка на удаленный рейс
  If (full_mas[arn,0]='3') or (full_mas[arn,0]='4') or (full_mas[arn,0]='5') then
  begin
   udalenka:=true;
   sale_server:=full_mas[arn,45];
   tripdate:=full_mas[arn,11];
   If not form1.virt_server() then serv_real_virt:=1  else serv_real_virt:=2;
  end;

  try
  myDay:=dateutils.daysbetween(date(),strtodate(tripdate));
  except
     showmessagealt('ОШИБКА ПРЕОБРАЗОВАНИЯ ВРЕМЕНИ !'+#13+'-k34-');
     exit;
    end;
   //Основное меню

 If trim(full_mas[arn,16])='1' then
    begin
      arrive:=false;
      departure:=true;
      up_time := full_mas[arn,10];
      up_point:= full_mas[arn,3];
      up_order:= full_mas[arn,4];
    end
  else
  begin
    arrive:=true;
    departure:=false;
    up_time := full_mas[arn,12];
    up_point:= full_mas[arn,6];
    up_order:= full_mas[arn,7];
  end;

  plan_time:=now();
  try
    strtotime(up_time,mySettings);
  except
    showmessagealt('ОШИБКА ПРЕОБРАЗОВАНИЯ ВРЕМЕНИ !'+#32+up_time+#13+'-k35-');
  end;
  try
    strtodate(tripdate,mySettings);
  except
    showmessagealt('ОШИБКА ПРЕОБРАЗОВАНИЯ ДАТЫ !'+#32+tripdate+#13+'-k36-');
  end;

  try
  plan_time:=strtodatetime(tripdate+#32+up_time,mySettings);
  except
    showmessagealt('ОШИБКА ПРЕОБРАЗОВАНИЯ ДАТЫ-ВРЕМЕНИ !'+#13+tripdate+#32+up_time+#13+'-k37-');
    //exit;
    end;
  //активность рейса
  If (trim(full_mas[arn,22])='') or (full_mas[arn,22]='0') then unactive:=true else unactive:=false;

With FormMenu do
begin

  //// Подключаемся к серверу
  // If not(Connect2(Zconnection1, 1)) then
  //   begin
  //    showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
  //    Zconnection1.disconnect;
  //    exit;
  //   end;
  //
  //  //Проверяем записЬ рейса не блокировку
  //  ZReadOnlyQuery1.sql.Clear;
  //  ZReadOnlyQuery1.SQL.add('SELECT platform FROM av_disp_oper WHERE del=0 ');//AND id_point_oper='+save_server);
  //  ZReadOnlyQuery1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[arn,16]);
  //  ZReadOnlyQuery1.SQL.add(' AND id_shedule='+full_mas[arn,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point);
  //  ZReadOnlyQuery1.SQL.add(' AND point_order='+up_order+' FOR UPDATE NOWAIT;');
  //  //showmessage(ZReadOnlyQuery1.SQL.Text);
  //  try
  //      ZReadOnlyQuery1.open;
  //  except
  //     showmessagealt('Операция временно недоступна !'+#13+'С данным рейсом уже работают !');
  //     Zconnection1.disconnect;
  //     exit;
  //  end;

    //ZReadOnlyQuery1.sql.Clear;
    //ZReadOnlyQuery1.SQL.add('SELECT distinct(a.id_menu_pub),a.permition,b.pub_name as name,b.tab_pub ');
    //ZReadOnlyQuery1.SQL.add('FROM av_arm_menu b,av_users_menu_perm a ');
    //ZReadOnlyQuery1.SQL.add('WHERE a.id_menu_pub = b.id_public AND a.id_arm = b.id_arm AND a.id_menu_loc=0 AND a.permition>0 ');
    //ZReadOnlyQuery1.SQL.add(' AND b.id_arm='+inttostr(id_arm)+' AND a.id='+inttostr(id_user)+' and b.del=0 AND a.del=0 order by b.tab_pub;');
    ////showmessage(ZReadOnlyQuery1.SQL.Text);//$
    //try
    //    ZReadOnlyQuery1.open;
    //except
    //   showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
    //   Zconnection1.disconnect;
    //   exit;
    //end;
    //if ZReadOnlyQuery1.RecordCount<1 then
    //   begin
    //     showmessagealt('Нет доступного меню для выбранного пользователя !');
    //     ZConnection1.Disconnect;
    //     exit;
    //   end;
   If length(menu_mas)=0 then
   begin
    showmessagealt('Нет доступного меню для выбранного пользователя !'+#13+'-k38-');
    exit;
    end;
    Stringgrid3.RowCount:=0;
    //заполняем грид меню
    for n:=0 to length(menu_mas)-1 do
      begin
        try
        menu_id := strtoint(menu_mas[n,0]);
        menu_perm := strtoint(menu_mas[n,1]);
        except
           showmessagealt('Ошибка преобразования значений меню диспетчера !'+#13+'-k39-');
           break;
        end;
        //проставляем флаги доступа к элементам меню в соответствии с записью массива

      If id_user>0 then
      begin
        // 1. отправление рейса
        If (menu_id=21) then
          begin
         If arrive or unactive then //рейс прибытия или неактивен
          menu_perm := 0;
         If (tripstatus='4') then //если рейс УЖЕ отправлен - недоступно
              menu_perm := 0;
          end;
        // 2. прибытие рейса
        If (menu_id=22) then
          begin
            If departure or unactive then //рейс отправления или неактивен
              menu_perm := 0;
            IF tripstatus='2' then menu_perm:=0;//отметка прибытия уже поставлена
          end;
        // 3. дообилечивание
        If (menu_id=23) then
          begin
            If arrive or unactive then //рейс прибытия или неактивен
              menu_perm:= 0;
            If not(tripstatus='4') then
              menu_perm:= 0;
            //продолжаем проверку, если не виртуальная удаленка
            If (menu_perm>0) and (serv_real_virt<>2) then
              begin
              try
              //проверка на дату рейса
              If (strtodate(tripdate)<>date) then
                menu_perm:= 0;
              //проверка ограничения на время дообилечивания
              If (doobil_min>0) and (menu_perm>0) then
                 If ((strtodate(tripdate)=date) and (time()-strtotime(up_time)>doobil_time)) then
                menu_perm:= 0;
              except
                showmessagealt('ОШИБКА ПРЕОБРАЗОВАНИЯ ВРЕМЕНИ !'+#13+'-k40-');
                continue;
              end;
              end;
          end;
  //если не виртуалка
    If (serv_real_virt<>2) then
       begin
         // 4. СРЫВ
        If (menu_id=24) then
          begin
            If unactive then //рейс неактивен
              menu_perm := 0;
            If (tripstatus='5') then //если СРЫВ УЖЕ ПРОСТАВЛЕН - недоступно
              menu_perm := 0;
            //если реальный сервер удаленки - нельзя !
            //iF serv_real_real=1 then menu_perm:=0;
          end;

       // 5. Смена АТП м АТС
          If (menu_id=25) or (menu_id=27) then
          begin
           ///ЕСЛИ РЕЙС НА ДООБИЛЕЧИВАНИИ, то - недоступно
            If (tripstatus='1') then
              menu_perm:= 0;
          end;

       //6. бронирование
       If (menu_id=26) then
          begin
            If arrive or unactive then //рейс прибытия или неактивен
              menu_perm:= 0;
           //если рейс закрыт - недоступно
            If (tripstatus='4') or (tripstatus='5') or (tripstatus='6') or (tripstatus='7') then
              menu_perm:= 0;
          //если рейс отправлен и это не транзит,то - недоступно  ?
            //If (tripstatus='4') and (full_mas[arn,9]='1') then  ?
              //menu_perm:=0;                                            ?
           //если бронирование и текущее время больше даты и времени отправления рейса, то недоступно
           If udalenka and (plan_time<now()) then
              menu_perm := 0;
           If menu_perm=0 then bron_edit:=false else bron_edit:=true;
          end;
        end;


       //9. Вычеpкнутые билеты
        If (menu_id=29) then
          begin
             //Если рейс прибытия - ЗАПРЕТ
           If arrive then
             begin
              menu_perm:= 0;
             end;
          //если рейс не отработал - ЗАПРЕТ
           If not((tripstatus='4') OR (tripstatus='5') OR (tripstatus='6') OR (tripstatus='7')) then
               begin
                menu_perm:= 0;
               end;
           //fl_unused:=false;
           //showmessage((copy(full_mas[arn,31],1,2)+copy(full_mas[arn,31],4,2)));
           //showmessage(inttostr(strtoint(formatdatetime('hhnn',time()))+1-strtoint(copy(full_mas[arn,31],1,2)+copy(full_mas[arn,31],4,2))));
       // если прошли пред.проверки и не удаленка виртуального сервера
        If (menu_perm>0) and (serv_real_virt<>2) then
          begin
            try
          //если уже прошедшие дни
            If (date()>strtodate(tripdate)) and (myDay>days_before)
                then
             menu_perm:=0;
           except
             showmessagealt('ОШИБКА ПРЕОБРАЗОВАНИЯ ВРЕМЕНИ !'+#13+'-k41-');
             exit;
           end;

           //ЕСЛИ НЕ БЫЛО операций
           If trim(full_mas[arn,31])='' then
             menu_perm:=0;

           If (menu_perm>0) then
             begin
              try
                //fact_time:=strtoint(copy(full_mas[arn,31],1,2)+copy(full_mas[arn,31],4,2));
                fact_time:=strtodatetime(full_mas[arn,30]+' '+full_mas[arn,31],mySettings);
                If plan_time>fact_time then fact_time:=plan_time;
              except
                showmessagealt('ОШИБКА ПРЕОБРАЗОВАНИЯ ВРЕМЕНИ !'+#13+'-k42-');
                continue;
              end;
             end;
         //если удаленка и текущее время меньше даты в времени отправления рейса, то недоступно
           //If udalenka and (strtodatetime(full_mas[arn,11],mySettings)+strtodatetime(up_time)>now()) then
              //menu_perm := 0;
          end;
        end;

        // 10. ЗАКАЗНОЙ РЕЙС
       If (menu_id=31) then
         begin
           //if (trim(full_mas[arn,9])='0') OR arrive then //рейс не формирующийся или прибытия // Проверяем что не транзит
         if arrive then //рейс прибытия
             menu_perm := 0;
         //на уже заказном рейсе нельзя создать заказной
          If (full_mas[arn,0]='2') or (full_mas[arn,0]='4') then menu_perm:=0;
         end;

      //******** ОБЩИЕ УСЛОВИЯ **************************************
       //Если рейс отправлен или закрыт, то недоступны любые операции, кроме снять отметку, дообилечивания, открытия заказного рейса, вычеркнутых билетов,бронирования :)
       If ((tripstatus='4') OR (tripstatus='5') OR (tripstatus='6') OR (tripstatus='7')) and (serv_real_virt<>2) then
       If not(menu_id=32) AND not(menu_id=23) AND not(menu_id=29) AND not(menu_id=31) and not(menu_id=26) then
         begin
             menu_perm:= 0;
         end;
       //если неактивен сегодня и не удаленка виртуального сервера, значит все запрещено, кроме создания заказного, смены АТП и АТС,вычернкутых,закрытия рейса
       If unactive and (serv_real_virt<>2) then
         If not(menu_id=31) and not(menu_id=25) and not(menu_id=27) and not(menu_id=29) and not(menu_id=32)  then menu_perm:=0;

       //если рейс удаленки реального сервера то ничего нельзя,кроме бронирования и вычеркнутых
       If serv_real_virt=1 then
        begin
         //menu_perm:=2;
        If not(menu_id=26) and not(menu_id=29) then menu_perm:=0;
        end;


       //если уже прошедшие дни
       If not udalenka and (date()>work_date) //$and (id_user>1)     //$
           and (myDay>days_before)
           AND not(menu_id=31) AND not(menu_id=29)
           then menu_perm:=0;

       //если номера телефонов пассажиров
       If menu_id=57 then menu_perm:=2;
     end;

        Stringgrid3.RowCount:= Stringgrid3.RowCount +1;
        Stringgrid3.Cells[2,Stringgrid3.RowCount-1]:=inttostr(menu_id);
        Stringgrid3.Cells[1,Stringgrid3.RowCount-1]:=menu_mas[n,2];
        Stringgrid3.Cells[0,Stringgrid3.RowCount-1]:=inttostr(menu_perm);
        form1.label45.caption:=inttostr(myDay);
   end;

    //Проверка возможности переноса билетов
    If departure and (serv_real_virt<>1) then
     begin
      If (tripstatus='5') OR (tripstatus='6') then
       begin
        Stringgrid3.RowCount:=Stringgrid3.RowCount +1;
        Stringgrid3.Cells[2,Stringgrid3.RowCount-1]:='777';
        Stringgrid3.Cells[1,Stringgrid3.RowCount-1]:='Переоформить билеты';
        Stringgrid3.Cells[0,Stringgrid3.RowCount-1]:='2';
       end;
     end;
    //label1.Caption:='33';//*
   //ZReadOnlyQuery1.Close;
   //Zconnection1.disconnect;

  //настройка и отображения панели и грида меню
   Stringgrid3.Left:=2;
   Stringgrid3.Top :=2;
   Stringgrid3.height:=Stringgrid3.DefaultRowHeight*Stringgrid3.RowCount+4;
   Stringgrid3.width:=350;
   Stringgrid3.ColWidths[0]:=10;
   Stringgrid3.ColWidths[1]:=340;
   Stringgrid3.ColWidths[2]:=0;
   napr:='down';
   Stringgrid3.Row:=0;
   Stringgrid3.SetFocus;
   formmenu.Height:=Stringgrid3.DefaultRowHeight*Stringgrid3.RowCount+10;
 end;

 Result:=true;
end;



//**************************************** HOT KEYS ***********************************************
procedure TFormMenu.FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
// F1
   if Key=112 then
     begin
     showmessage('[F1] - Справка'+#13+'[ENTER] - Выбор пункта меню'+#13+'[ESC] - Отмена\Выход');
     key:=0;
     end;

  If (formMEnu.StringGrid3.Focused)
      then //; //флаг выполнения операции  then
    begin
       // Стрелка вверх
        if (Key=38) then
          begin
           //key:=0;
           napr:='up';
          end;
        // Стрелка вниз
        if (Key=40) then
          begin
           //key:=0;
           napr:='down';
          end;

      //showmessage(inttostr(Key));
        // ESC
        if (Key=27) then
          begin
           key:=0;
           formMenu.close;
           exit;
           end;

           If active_oper then
         begin
           If DialogMess('Операция уже была выбрана !'+#13+'Отменить ее повторное выполнение ?')=6  then
           begin
             key:=0;
             formmenu.Close;
             exit;
          end;
         end;

        // ENTER - выбор пунтка меню
       IF (Key=13) then
           operation:=razbor(99);  //разбираем выбранную строчку меню
       //1
       IF (Key=49) or (Key=97) then
         operation:=razbor(0);  //разбираем выбранную строчку меню
       //2
       IF (Key=50) or (Key=98) then
         operation:=razbor(1);  //разбираем выбранную строчку меню
       //3
       IF (Key=51) or (Key=99) then
         operation:=razbor(2);  //разбираем выбранную строчку меню
       //4
       IF (Key=52) or (Key=100) then
         begin
           formMenu.StringGrid3.Row:=3;
           operation:=razbor(3);  //разбираем выбранную строчку меню
         end;
       //5
       IF (Key=53) or (Key=101) then
         operation:=razbor(4);  //разбираем выбранную строчку меню
       //6
       IF (Key=54) or (Key=102)  then
         operation:=razbor(5);  //разбираем выбранную строчку меню
       //7
       IF (Key=55) or (Key=103)  then
         operation:=razbor(6);  //разбираем выбранную строчку меню
       //8
       IF (Key=56) or (Key=104)  then
         operation:=razbor(7);  //разбираем выбранную строчку меню
       //9
       IF (Key=57) or (Key=105)  then
         operation:=razbor(8);  //разбираем выбранную строчку меню
       //а - русская
       IF (Key=70) then
         operation:=razbor(9);  //разбираем выбранную строчку меню
       //б - русская
       IF (Key=188) then
         operation:=razbor(10);  //разбираем выбранную строчку меню
       //в - русская
       IF (Key=68) then
         operation:=razbor(11);  //разбираем выбранную строчку меню

       If (Key=13) OR (Key=27) OR (Key=49) OR (Key=50) OR (Key=51) OR (Key=52) OR (Key=53) OR (Key=54) OR (Key=55)
         OR (Key=56) OR (Key=57) OR (Key=70) OR (Key=188) OR (Key=68)
         OR (Key=97) OR (Key=98) OR (Key=99) OR (Key=100) OR (Key=101)  OR (Key=102) OR (Key=103) OR (Key=104)  OR (Key=105)
         then key:=0;

       If operation>0 then
       begin
        key:=0;
       FormMenu.Close;
       exit;
       end;
      //formMEnu.StringGrid3.Refresh;
    end;

        // ESC
        if (Key=27) AND (formMEnu.StringGrid4.Focused) then
           begin
             key:=0;
             If formmenu.ZConnection1.Connected then
           begin
            If formmenu.ZConnection1.InTransaction then formmenu.Zconnection1.Rollback;
            formmenu.ZConnection1.disconnect;
           end;
            formmenu.ZReadOnlyQuery1.Close;
            formmenu.ZReadOnlyQuery2.Close;
            formmenu.Close;
            //formMenu.StringGrid4.Visible:=false;
            //formMenu.StringGrid3.row:=0;
            //formMenu.StringGrid3.setfocus;
            exit;
            end;
        // ENTER - выбор вида СРЫВА
       IF (Key=13) AND (formMEnu.StringGrid4.Focused) then
          begin
           key:=0;
            If formMenu.razbor_canceled then
            begin
             form1.paintmess(formmenu.StringGrid4,'ПОДОЖДИТЕ ...',clGreen);
             operation:=razbor(99);
             //If flsearch_sriv then sriv_insert;
            end
            else
               begin
                If formmenu.ZConnection1.Connected then
                begin;
                 If ZConnection1.InTransaction then Zconnection1.Rollback;
                 formmenu.ZConnection1.Disconnect;
                 formmenu.ZReadOnlyQuery1.Close;
                 formmenu.ZReadOnlyQuery2.Close;
                 end;
               end;
            formmenu.Close;
            exit;
          end;
end;

procedure TFormMenu.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;

procedure TFormMenu.FormPaint(Sender: TObject);
begin
   FormMenu.Canvas.Brush.Color:=clSilver;
   FormMenu.Canvas.Pen.Color:=clBlack;
   FormMenu.Canvas.Pen.Width:=2;
   FormMenu.Canvas.Rectangle(2,2,FormMenu.Width-2,FormMenu.Height-2);
end;

procedure TFormMenu.FormShow(Sender: TObject);
begin
  //Выравниваем форму
   //Left:=310;
   //Top :=120;
 //FormMenu.height:=464;
 //FormMenu.width :=354;
 FormMenu.Left:=form1.Left+(form1.Width div 2)-(FormMenu.Width div 2);
 FormMenu.Top :=form1.Top+(form1.Height div 2)-(FormMenu.Height div 2);
 formMenu.StringGrid3.Canvas.AntialiasingMode:=amOff;
 formMenu.StringGrid3.Canvas.Font.Quality:=fqDraft;
 formMenu.StringGrid4.Canvas.AntialiasingMode:=amOff;
 formMenu.StringGrid4.Canvas.Font.Quality:=fqDraft;
 //загружаем меню
 If not(FormMenu.menu_load) then
   begin
    FormMEnu.close;
    exit;
   end;
 flag_sriv:=false;
 flag_late:=false;
 flsearch_sriv:=false;
 fl_transact:=false;//флаг подтверждения блокировки рейса
 active_oper:=false;//флаг выполнения операции

 //получить последнее состояние рейса по диспетчерским операциям
  // Подключаемся к серверу
   If not(Connect2(formmenu.Zconnection1, 1)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k43-');
      exit;
     end;
  try
  form1.get_disp_oper(formmenu.ZReadOnlyQuery1,arn);
  finally
    formmenu.ZReadOnlyQuery1.Close;
    formmenu.ZConnection1.Disconnect;
  end;



end;

end.


