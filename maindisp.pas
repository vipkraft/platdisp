unit maindisp;

{$mode objfpc}{$H+}
//{$codepage utf8}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics,
  LazUTF8, //LazFileUtils,
  Grids,  StdCtrls,
  ComCtrls,
  //DB,
  Dialogs, ExtCtrls,
  Spin,
  strutils,
  MouseAndKeyInput,
  ZConnection, ZDataset,
  dateutils,
  DateTimePicker,
  IniFiles, IniPropStorage,
  //BGRABitmap, BGRABitmapTypes,
  //types,
  //Buttons,
  //types,
  //unix,
  //lclintf,
  //LMessages,
  //LCLType,
  platproc,menu,zakaz_main,sostav_main,message_idle,bron_main,doobil,
  htmlproc,
  vedom_view,
  remote,version_info,unused,Auth,ffind;

type

  { TForm1 }

  TForm1 = class(TForm)
    Active_app: TTimer;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    IdleTimer1: TIdleTimer;
    IdleTimer2: TIdleTimer;
    IdleTimer3: TIdleTimer;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    IniPropStorage1: TIniPropStorage;
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
    Label2:  TLabel;
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
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel4: TPanel;
    pBox: TPaintBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ProgressBar1: TProgressBar;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    SpinDate1: TDateTimePicker;
    SpinEdit1: TSpinEdit;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Timer1: TTimer;
    Timer3: TTimer;
    ZConnection1: TZConnection;
    ZConnection2: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    ZReadOnlyQuery2: TZReadOnlyQuery;
    ZReadOnlyQuery3: TZReadOnlyQuery;
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure IdleTimer1StartTimer(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure IdleTimer2StartTimer(Sender: TObject);
    procedure IdleTimer2Timer(Sender: TObject);
    procedure IdleTimer3Timer(Sender: TObject);
    procedure pBoxPaint(Sender: TObject);
    procedure SpinDate1Change(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Active_appTimer(Sender: TObject);
    procedure get_list_shedule; //отрисовка грида расписаний
    // Пересчет динамичеких параметров для рейсов в массиве
    //Procedure Rascet_mas(priznak:byte);
        //0: при бездействии (обновляет при необходимости)
        //1: при смене даты (все обнолять при смене даты)
   // Очищаем блоки из full_mas по флагу 1-av_trip 2-av_trip_add ;
   procedure clear_mas(flag_clear:byte);
   procedure Timer3Timer(Sender: TObject);
   //выполнить операцию после разбора из меню
   procedure trip_data();
   // Запускаем\Останавливаем таймер простоя
   procedure start_stop_idle(sec_timeout:integer);
   procedure platform_get(); //вывести панель с номером платформы
   // Сортируем массив full_mas
   // sposob = 1 - по времени
   function sort_full_mas(sposob:byte):integer;
   //фильтруем рейсы по контекстному поиску
   procedure qsearch(mode:byte);
   //Закрытыие ведомости для данного рейса
   function Vedom_Close(ZCon:TZConnection;ZQ1:TZReadOnlyQuery;nx:integer):boolean;
   //запрос ведомостей на данный рейс
   procedure Vedom_get(ind:integer;mode:byte);
          //mode=0 - сразу печать
          //mode=1 - выбор ведомостей на печать
   //заполнить массив билетов данного рейса
   procedure Vedom_print(nx:integer; x:integer); //Вывод ведомости на экран
   procedure Fillticket(x:integer);
   procedure Clear_labels(); //сбросить все лейбы
   procedure Disp_refresh(mode:byte; clear:byte);// ОБНОВИТЬ ЭКРАН ДИСПЕТЧЕРА
   //mode=0 - запрос измененных данных без установки на рейс по текущему времен
   //mode=1 - запрос измененных данных и стать на рейс по текущему времен
   //mode=2 - запрос всех данных и стать на рейс по текущему времени
   function  stand_trip():integer; //стать на прежнее время рейса или рядом с ним
   procedure getfreeseats(mode:integer);   // РАСЧЕТ СВОБОДНЫХ МЕСТ НА РЕЙСАХ
   procedure paintmess(Grid:TStringgrid; textinfo:string; vColor:TColor);//отрисовка информационных сообщений
   procedure get_time_index;//определить элемент массива по текущему времени
   procedure setlabels;//прописать доп инфу по рейсам
   //Вычисляем номер ведомости
   function Get_num_vedom(nx:integer):string;
   //************************************** ЗАПРОС ПОСЛЕДНИХ ДИСПЕТЧЕРСКИХ ОПЕРАЦИЙ по ОДНОМУ РАСПИСАНИЮ  ****************
   function get_disp_oper(ZQuer:TZReadOnlyQuery;arn:integer):boolean;
   procedure alarm_draw;//нарисовать предупредждения на канве
   procedure anim_string; // Анимация строки
   procedure Alarm_get;//загрузить информацию и предупреждения
   procedure alarm_show(num:integer);
   //**********************************    Пересчет динамичеких параметров для рейсов в массиве  ************************************
  procedure Shedule_Calc(clear:byte);
  //clear - 1-очищать массив, 0-нет
  //прочитать глобальные переменные
  procedure ReadSettings();
  //запрос таблицы с текущим днем
  function Get_current_day():boolean;
  function virt_server():boolean;//определяем виртуальный или реальный сервер
  function Get_agents():boolean;//показать рейсы с билетами агентов

  private
    { private declarations }
    formActivated: boolean;
  public
    { public declarations }
   procedure MyExceptionHandler(Sender : TObject; E : Exception); //ОБРАБОТЧИК ИСКЛЮЧЕНИЙ  *********

  end;


   //найти элемент массива
   function arr_get():integer;
   //стать на строку грида по текущему времени
   procedure set_row_time;

const
//  timeout_bron= 19; //интервал ожидания бездействия при вводе брони
//  timeout_zakaz=22; //интервал ожидания бездействия при вводе заказного рейса
//  timeout_menu=13;
//  timeout_schema=55;
//  timeout_udal=42;
//  timeout_ats= 65;
//  timeout_trip=32;
//  timeout_sostav=75;
//  timeout_vedom=49;
//  timeout_signal=9; //предудпреждение перед закрытием
  triprows=9;  //покатит только нечетное число строчек, иначе будет не соответствовать
  maxtransact=540; //кол-во минут максимального выполнения транзакции
  inettick=5;
  late_pretens=108;//опоздание претензионное (id меню диспетчера)
  wrong_avto=3;//незаявленное ТС



var

  timeout_bron:integer=17;//интервал ожидания бездействия при вводе брони
  timeout_zakaz:integer=22;//интервал ожидания бездействия при вводе заказного рейса
  timeout_menu:integer=8;
  timeout_schema:integer=38;
  timeout_udal:integer=28;
  timeout_ats:integer=25;
  timeout_trip:integer=15;
  timeout_sostav:integer=52;
  timeout_vedom:integer=12;
  timeout_signal:integer=9;//предудпреждение перед закрытием

  Form1: TForm1;
  flagProfile, flag_access, flag1 :byte;
  id_user, id_arm, iduser_active :integer;
  name_user_active, defpath, user_ip, server_name, otkuda_name:string;
  WORK_DATE:TDatetime;       //Текущая рабочая дата
  timeout_global:integer=0;  //счетчик таймер бездействия (перед окном закрытия форм операций)
  timeout_local:integer=0;
  //********************* опции диспетчера *******************************
  printer_type: byte=0; //тип принтера: 1-локальный, 2-сетевой
  printer_vid : byte=0; //вид принтера: 1-лазерный, 2-матричный
  printer_dev : string; //порт принтера: usb или LPT
  days_before: integer=0; //кол-во дней назад, доступных для операций
  vicherknut: byte=0; //разрешение восстанавливать вычеркнутые
  unused_critical_time:integer=60;//время (минуты) когда можно вычеркнуть билет
  un_critical_time: Tdatetime;//время (чч:мм) когда можно восстановить вычеркнутый билет
  //*******************
  //fl_unused:boolean=false; //флаг открытия формы для вычеркнутых
  bron_edit: boolean=false; //флаг открытия формы бронирования для изменения
  operation:byte=0; //номер операции после разбора в меню
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


  Info:string='';
  vedName :string='';
  flclose:boolean=true; //закрывать формы
  masindex:integer=-1;
  trows:integer=triprows div 2;
  alltrips:integer;
  sale_server:string='0';
  ti1 : TDateTime;
  remote_ind:integer;//индекс рейса удаленки
  tickets_blocked:integer;//заблокированные билеты
  max_operation:string=''; // max для av_disp_oper
  MySettings:TFormatSettings;
  fl_transact:boolean=false;//флаг подтверждения блокировки рейса
  zakaz_shed,zakaz_time:string;//расписание и время создаваемого заказного рейса

  //-------------------------------------------------------------------------------------------------------
  full_mas:array of array of string; // массив всех текущий online состояний всех рейсов
  full_mas_size:integer=47; // Размерность массива
  //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  FULL_MAS - описание ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            // [n,0]  - Тип данных в массиве
                           //1: из av_trip (регулярный)
                           //2: из av_trip_add (заказной)
                           //3: из av_ticket_local (удаленный рейс регулярный)
                           //4: из av_ticket_local (удаленный рейс заказной)
                           //5: из av_ticket виртуального сервера
            // [n,1]  - id_shedule
            // [n,2]  - plat         //платформа
            // [n,3]  - ot_id_point
            // [n,4]  - ot_order
            // [n,5]  - ot_name
            // [n,6]  - do_id_point
            // [n,7]  - do_order
            // [n,8]  - do_name
            // [n,9]  - form         //признак формирующего
            // [n,10] - t_o
            // [n,11] - t_s
            // [n,12] - t_p
            // [n,13] - zakaz        //признак заказного
            // [n,14] - date_tarif
            // [n,15] - id_route
            // [n,16] - napr        //1:отправление, 2:прибытие
            // [n,17] - wihod       //1:выход в рейс в текущий workdate
            // [n,18] - id_kontr
            // [n,19] - name_kontr
            // [n,20] - id_ats
            // [n,21] - name_ats
            // [n,22] - edet  //прозведение флагов выход по сезонности,лицензия,договор,атс,перевозчик
            // [n,23] - dates
            // [n,24] - datepo
            // [n,25] - all_mest
            // [n,26] - activen //признак активности расписания по датам действия и флагу активности
            // [n,27] - type_ats
            // [n,28] - trip_flag   //состояние рейса
            // [n,29] - doobil
            // [n,30] - oper_date   //дата операции
            // [n,31] - oper_time   //время операции
            // [n,32] - oper_user   //пользователь совершивший операцию
            // [n,33] - oper_remark //описание операции
            // [n,34] - kol_swob //кол-во свободных мест
             //[n,35] putevka
             //[n,36] driver1
             //[n,37] driver2'.asString;
             //[n,38] driver3'.asString;
             //[n,39] driver4'.asString;
            // [n,40] - dateactive //дата начала работы расписания
            // [n,41] - dog_flag //флаг наличия договора
            // [n,42] - lic_flag //флаг наличия лицензии
            // [n,43] - kontr_flag //флаг наличия перевозчика
            // [n,44] - ats_flag //флаг наличия автобуса
            // [n,45] - id_server //сервер продажи для удаленного рейса

   vedom_mas: array of array of string; //массив реквизитов выбранной ведомости
   vedom_size: integer=44; // Размерность массива
   //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  VEDOM_MAS - описание ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            // [n,0]  - vedomtype  //1- основная  //2- дообилечивания  //3- основная заказная //4- дообилечивания заказная
            // [n,1]  - id_shedule
            // [n,2]  - date_trip
            // [n,3]  - ot_id_point
            // [n,4]  - ot_order
            // [n,5]  - ot_name
            // [n,6]  - do_id_point
            // [n,7]  - do_order
            // [n,8]  - do_name
            // [n,9]  - vedom
            // [n,10] - t_o
            // [n,11] - t_o_fact
            // [n,12] - createdate
            // [n,13] - putevka
            // [n,14] - driver1
            // [n,15] - driver2
            // [n,16] - driver3
            // [n,17] - driver4
            // [n,18] - kontr_id
            // [n,19] - kontr_name
            // [n,20] - ats_id
            // [n,21] - ats_name
            // [n,22] - ats_seats
            // [n,23] - ats_reg
            // [n,24] - ats_type
            // [n,25] - doobil
            // [n,26] - id_user   //
            // [n,27] - name   //пользователь совершивший операцию
            // [n,28] - tickets_count
            // [n,29] - tickets_sum
            // [n,30] - bagag_count
            // [n,31] - bagag_sum
            // [n,32] - strah_sum
            // [n,33] - wars_count
            // [n,34] - wars_sum_cash
            // [n,35] - wars_sum_credit
            // [n,36] - lgot_count
            // [n,37] - lgot_sum_cash
            // [n,38] - lgot_sum_credit
            // [n,39] - uslugi_count
            // [n,40] - uslugi_sum_cash
            // [n,41] - uslugi_sum_credit
            // [n,42] - zakaz
            // [n,43] - isfio

  tick_mas:array of array of string; //массив билетов рейса
  tick_size: integer=30; //размерность массива билетов
   // tick_mas[m,0] - mesto
   // tick_mas[m,1] - ticket_num
   // tick_mas[m,2] - createdate date
   // tick_mas[m,3] - createdate time
   // tick_mas[m,4] - type_ticket -Тип Билет/Багаж
   // tick_mas[m,5] - type_full_half  - Тип Полный Детский
   // tick_mas[m,6] - type_norm_lgot_war - Тип Обычный Льготный Воинский
   // tick_mas[m,7] - id_do - Пункт назначения
   // tick_mas[m,8] - lgot_sum
   // tick_mas[m,9] - sum_credit
   // tick_mas[m,10] - sum_cash
   // tick_mas[m,11] - fio
   // tick_mas[m,12] - doc_type
   // tick_mas[m,13] - doc_rec
   // tick_mas[m,14] - bagag_count
   // tick_mas[m,15] - bagag_sum
   // tick_mas[m,16] - тип билета аббревиатура
   // tick_mas[m,17] - страх сбор наличный
   // tick_mas[m,18] - страх сбор безналичный
   // tick_mas[m,19] - бронирование
   // tick_mas[m,20] - наименование пункта откуда
   //tick_mas[length(tick_mas)-1,21] := ZReadOnlyQuery1.FieldByName('timein').AsString;
   //    tick_mas[length(tick_mas)-1,22] := ZReadOnlyQuery1.FieldByName('dayin').AsString;
   //    tick_mas[length(tick_mas)-1,23] := ZReadOnlyQuery1.FieldByName('tel').AsString;
   //    tick_mas[length(tick_mas)-1,24] := ZReadOnlyQuery1.FieldByName('id_user').AsString;
   //    tick_mas[length(tick_mas)-1,25] := ZReadOnlyQuery1.FieldByName('agent').AsString;
   //    tick_mas[length(tick_mas)-1,26] := ZReadOnlyQuery1.FieldByName('email').AsString;
   //    tick_mas[length(tick_mas)-1,27] := ZReadOnlyQuery1.FieldByName('citiz').AsString;
   //    tick_mas[length(tick_mas)-1,28] := ZReadOnlyQuery1.FieldByName('gender').AsString;
   //    tick_mas[length(tick_mas)-1,29] := ZReadOnlyQuery1.FieldByName('birthday').AsString;

  //tick_cur:array of array of string; //массив билетов ведомости
  //tick_cur_size:integer=10;
   // tick_cur[m,0] - mesto
   // tick_cur[m,1] - ticket_num
   // tick_cur[m,2] - Тип билета
   // tick_cur[m,3] - стоимость билета
   // tick_cur[m,4] - Пункт назначения
   // tick_cur[m,5] - Багаж: количество
   // tick_cur[m,6] - Багаж: сумма
   // tick_cur[m,7] - fio
   // tick_cur[m,8] - doc_type
   // tick_cur[m,9] - doc_rec

   mas_uslugi: TStringlist;
   menu_mas: array of array of string;//массив меню диспетчера
    //menu_mas[length(menu_mas)-1,0]-- id_menu_pub
    //menu_mas[length(menu_mas)-1,1]- permition
    //menu_mas[length(menu_mas)-1,2]- name
   fl_lock:boolean;
   perenos_biletov:integer;
   vedomcount:integer;
   rep_dir:string;
   webtick1,webtick2,webtick3,webtick4:string;
   specbron:boolean=false;//av_shadow_bron - спец бронирование
   max_transaction_time:integer;
   doobil_time:Tdatetime;
   doobil_min:integer;


//=======================================================
//============  СОСТОЯНИЯ РЕЙСА  trip_flag [28]=======================
//0 - НЕОПРЕДЕЛЕНО (ОТКРЫТ)
//1 - ДООБИЛЕЧИВАНИЕ (ОТКРЫТ) повторно
//2 - ОТМЕЧЕН КАК ПРИБЫВШИЙ
//3 - ОТМЕЧЕН КАК ОПАЗДЫВАЮЩИЙ (ОТКРЫТ)
//4 - ОТПРАВЛЕН (Закрыт)
//5 - СРЫВ ПО ВИНЕ АТП (ЗАКРЫТ)
//6 - ЗАКРЫТ ПРИНУДИТЕЛЬНО
//7 - ЗАКРЫТ ПРИОСТАНОВЛЕН
//====================================================

implementation

{$R *.lfm}

const
 timeout_main = 35; //интервал обновления экрана при бездействии
 lateminutes = 10;


var
 md5_av_trip:string='';     // md5 для av_trip
 md5_av_trip_add:string=''; // md5 для av_trip_add
 md5_av_trip_atps:string='';
 md5_av_dog_lic:string='';
 md5_operation:string='';
 md5_tick_local:string=''; // md5 для av_ticket_local
 timeout_main_tik:integer=0;//счетчик таймера обновления экрана
 filtr:byte=0; //тип сортировки
 filtr_mas:array of integer; // массив рейсов по фильтру
 dispcnt,shcnt:integer;
 reqtime:string;
 cur_time:string='';
 cur_shedule:string='';
 tfresh: Tdatetime;
 mainsrv: boolean=false;//флаг нахождения локального сервера в контекстом поиске
 kol_otpr,kol_prib,kol_prib_remaining,kol_otpr_remaining,kol_unactive:integer;
 findex:integer=0;//индекс отфильтрованного массива
 slide:integer;
 textalarm:string;
 alarm_mas:array of string; //Строки сообщений
 //cant:TBGRABitmap; //Графическое представление строки текста
 //cant2:TBGRABitmap; //Графическое представление строки текста
 ncnt:integer;
 //t1:TTime;
 str:string;
 active_check,fle:boolean;
 ished:string;
 search_city:string;
 date_trip:string;
 company_inn, company_name:string;
 LPTonly:boolean=false;


{ TForm1 }


function TForm1.virt_server():boolean;//определяем виртуальный или реальный сервер
var
 n:integer;
begin
 result:=false;
  for n:=0 to length(mas_otkuda)-1 do
      begin
        if trim(mas_otkuda[n,0])=sale_server then
         begin
          If mas_otkuda[n,9]='0' then
           begin
             result:=true;
             break;
            end;
        end;
      end;
end;

//запрос таблицы с текущим днем
function TForm1.Get_current_day():boolean;
var
 m:integer;
begin
  result:=false;
   If (trim(ished)='') then ished:='0'
 else
    If length(full_mas)>0 then ished:=full_mas[masindex,1];

  form1.Label44.caption:='0';
  //возвращаем параметры локального сервера
  sale_server:=ConnectINI[14];
  otkuda_name:=server_name;

  //подключаемся к локальному серверу
  If not(Connect2(form1.Zconnection2, 2)) then
   begin
    showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m01-');
    result:=false;
    exit;
   end;
//инфо панель
   form1.Panel4.Width:=form1.Width;
   form1.Panel4.Left:=0;
   form1.Panel4.Visible:=true;
   application.ProcessMessages;
   active_check:=true; //флаг выполнения обновления
   // Запрос к av_trip
        form1.ZReadOnlyQuery2.SQL.Clear;
        //form1.ZReadOnlyQuery2.SQL.Add('select * from av_trip order by t_o,t_p;');
        //t1:=time();
        //--функция возвращает список регулярных и заказных рейсов с выясненным календарным планом, наличием договора и лицензии
        form1.ZReadOnlyQuery2.SQL.Add('SELECT cur_date FROM av_disp_current_day LIMIT 1 OFFSET 0;');
        //showmessage(form1.ZReadOnlyQuery2.sql.Text);
          try
            form1.ZReadOnlyQuery2.open;
          except
            //showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
            form1.ZReadOnlyQuery2.Close;
            form1.Zconnection2.disconnect;
            form1.Panel4.Visible:=false;
            active_check:=false; //флаг выполнения обновления
            result:=false;
            exit;
          end;
           //showmessage(timetostr(time-t1));
          If form1.ZReadOnlyQuery2.RecordCount=0 then
              begin
                form1.ZReadOnlyQuery2.Close;
                form1.Zconnection2.disconnect;
                form1.Panel4.Visible:=false;
                active_check:=false; //флаг выполнения обновления
                result:=false;
                exit;
              end;
    //showmessage(datetostr(form1.ZReadOnlyQuery2.FieldByName('cur_date').asDatetime)+#13+datetostr(date()));
    If (form1.ZReadOnlyQuery2.FieldByName('cur_date').asDateTime<>work_date) then
      begin
         form1.ZReadOnlyQuery2.Close;
         form1.Zconnection2.disconnect;
         form1.Panel4.Visible:=false;
         active_check:=false; //флаг выполнения обновления
         result:=false;
         exit;
        end;

     // Запрос к av_trip
        form1.ZReadOnlyQuery2.SQL.Clear;
        //form1.ZReadOnlyQuery2.SQL.Add('select * from av_trip order by t_o,t_p;');
        //t1:=time();//$
        //--функция возвращает список регулярных и заказных рейсов с выясненным календарным планом, наличием договора и лицензии
           //======== ФИЛЬТР/СОРТИРОВКА  ========
            //1: ВСЕ НА ТЕКУЩУЮ ДАТУ И ВРЕМЯ (СЕГОДНЯ)
            //2: РЕЙСЫ ТЕКУЩЕГО РАСПИСАНИЯ
            //3: РЕЙСЫ ОТПРАВЛЕНИЯ АКТИВНЫЕ
            //4: РЕЙСЫ ПРИБЫТИЯ АКТИВНЫЕ
            //5: РЕЙСЫ НЕАКТИВНЫЕ
            //6: РЕЙСЫ ЗАКАЗНЫЕ
            //7: РЕЙСЫ Удаленной продажи
            //8: поиск рейса по промежуточному пункту

        form1.ZReadOnlyQuery2.SQL.Add('SELECT * FROM av_disp_current_day ');
        If filtr>0 then form1.ZReadOnlyQuery2.SQL.Add(' WHERE ');

        If filtr=1 then
          form1.ZReadOnlyQuery2.SQL.Add(' edet>0 and zakaz<3 ');
        If filtr=2 then
          form1.ZReadOnlyQuery2.SQL.Add(' id_shedule='+ished);
        If filtr=3 then
          form1.ZReadOnlyQuery2.SQL.Add(' edet>0 AND zakaz<3 AND napr=1 ');
        If filtr=4 then
          form1.ZReadOnlyQuery2.SQL.Add(' edet>0 AND zakaz<3 AND napr=2 ');
        If filtr=5 then
          form1.ZReadOnlyQuery2.SQL.Add(' edet=0 ');
        If filtr=6 then
          form1.ZReadOnlyQuery2.SQL.Add(' zakaz=2 OR zakaz=4 OR zakaz=6 ');
        If filtr=7 then
          form1.ZReadOnlyQuery2.SQL.Add(' zakaz>2 ');

       If filtr=8 then
          begin
             work_date:=date();
         form1.ZReadOnlyQuery2.SQL.Add(' zakaz<3 AND id_shedule in ');
         form1.ZReadOnlyQuery2.SQL.Add(' (select b.id_shedule ');
         form1.ZReadOnlyQuery2.SQL.Add(' from av_shedule_sostav b ');
         form1.ZReadOnlyQuery2.SQL.Add(' where b.id_point IN ');
         form1.ZReadOnlyQuery2.SQL.Add('(SELECT a.id from av_spr_point a where a.del=0 and upper(trim(a.name)) LIKE '+Quotedstr(search_city)+')');
         form1.ZReadOnlyQuery2.SQL.Add(' and b.del=0) ');
         //form1.ZReadOnlyQuery2.SQL.Add(' OFFSET 0 ');
          end;
        form1.ZReadOnlyQuery2.SQL.Add(' ORDER BY sort_time,id_shedule,ot_order;');
       //If filtr=8 then
       //showmessage(form1.ZReadOnlyQuery2.sql.Text);//$
          try
            form1.ZReadOnlyQuery2.open;
          except
            form1.Panel4.Visible:=false;
            active_check:=false; //флаг выполнения обновления
            result:=false;
            showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
            form1.ZReadOnlyQuery2.Close;
            form1.Zconnection2.disconnect;
            exit;
          end;

    //очищаем массив рейсов
      SetLength(Full_mas,0,0);

  If form1.ZReadOnlyQuery2.RecordCount>0 then
    begin
      result:=true;
  //label44.caption:=label44.caption+'+'+(formatdatetime('ss.zzz',time-t1));//!
 //t1:=time; //!
        // Очищаем массив РЕГУЛЯРНЫХ рейсов в массиве из av_trip
        //form1.clear_mas(1);

        //если общее число рейсов изменилось
           //всего рейсов
             alltrips:=form1.ZReadOnlyQuery2.RecordCount-1;
             kol_otpr:=0;
             kol_prib:=0;
             kol_otpr:=0;
             kol_prib:=0;
             kol_unactive:=0;

        //^^^^^^<<<<< ВНИМАНИЕ ! ПОСЛЕДНЯЯ СТРОКА - КОНТРОЛЬНЫЕ ЗНАЧЕНИЯ ! >>>>>>>>>>>>>>^^^^^^^^^^^^^^^
        // ДОБАВЛЯЕМ В МАССИВ РЕГУЛЯРНЫЕ РЕЙСЫ
        //ZReadOnlyQuery2.First;

        for m:=0 to form1.ZReadOnlyQuery2.RecordCount-1 do
          begin
            If trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString)='' then continue;

            //если нет такого рейса в массиве, добавляем
            SetLength(Full_mas,length(Full_mas)+1,full_mas_size);
            //- Тип рейса в массиве
            //1: из av_trip (регулярный)
            //2: из av_trip_add (заказной)
            //3: из av_ticket_local (удаленный рейс регулярный)
            //4: из av_ticket_local (удаленный рейс заказной)
            //5: из av_ticket виртуального сервера
             full_mas[length(Full_mas)-1,0]:= form1.ZReadOnlyQuery2.FieldByName('zakaz').asString;
             full_mas[length(Full_mas)-1,1]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString);
             full_mas[length(Full_mas)-1,2]:= trim(form1.ZReadOnlyQuery2.FieldByName('plat').asString);
             full_mas[length(Full_mas)-1,3]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_id_point').asString);
             full_mas[length(Full_mas)-1,4]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_order').asString);
             full_mas[length(Full_mas)-1,5]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_name').asString);
             full_mas[length(Full_mas)-1,6]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_id_point').asString);
             full_mas[length(Full_mas)-1,7]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_order').asString);
             full_mas[length(Full_mas)-1,8]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_name').asString);
             full_mas[length(Full_mas)-1,9]:= trim(form1.ZReadOnlyQuery2.FieldByName('form').asString);
            full_mas[length(Full_mas)-1,10]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_o').asString);
            full_mas[length(Full_mas)-1,11]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_s').asString);//время стоянки если регулярный рейс или дата выхода если удаленный
            full_mas[length(Full_mas)-1,12]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_p').asString);
            //full_mas[length(Full_mas)-1,13]:= form1.ZReadOnlyQuery2.FieldByName('id_user').asString);
            full_mas[length(Full_mas)-1,14]:= trim(form1.ZReadOnlyQuery2.FieldByName('date_tarif').asString);
            full_mas[length(Full_mas)-1,15]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_route').asString);
            full_mas[length(Full_mas)-1,16]:= trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString);
   //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString));
            full_mas[length(Full_mas)-1,17]:= form1.ZReadOnlyQuery2.FieldByName('wihod').asString;  //1:выход в рейс в текущий workdate
            full_mas[length(Full_mas)-1,18]:= form1.ZReadOnlyQuery2.FieldByName('id_kontr').asString; //id перевозчика
            full_mas[length(Full_mas)-1,19]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_kontr').asString); //наименование перевозчика
            full_mas[length(Full_mas)-1,20]:= form1.ZReadOnlyQuery2.FieldByName('id_ats').asString; //№ автобуса
            full_mas[length(Full_mas)-1,21]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_ats').asString); //наименование Автобуса
            full_mas[length(Full_mas)-1,22]:= trim(form1.ZReadOnlyQuery2.FieldByName('edet').asString); //прозведение флагов выход по сезонности,лицензия,договор,атс,перевозчик
            full_mas[length(Full_mas)-1,23]:= trim(form1.ZReadOnlyQuery2.FieldByName('dates').asString);
            full_mas[length(Full_mas)-1,24]:= trim(form1.ZReadOnlyQuery2.FieldByName('datepo').asString);
            full_mas[length(Full_mas)-1,25]:= form1.ZReadOnlyQuery2.FieldByName('all_mest').asString;  //мест всего
            full_mas[length(Full_mas)-1,26]:= form1.ZReadOnlyQuery2.FieldByName('activen').asString; //признак активности расписания по датам действия и флагу активности
            full_mas[length(Full_mas)-1,27]:= form1.ZReadOnlyQuery2.FieldByName('type_ats').asString;  //тип АТС
            full_mas[length(Full_mas)-1,28]:= trim(form1.ZReadOnlyQuery2.FieldByName('trip_flag').asString);  //состояние рейса
            full_mas[length(Full_mas)-1,29]:= '0';  //дообилечивания количество ведомостей
           If length(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)>0 then
            begin
             If length(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)>10 then
              begin
               full_mas[length(Full_mas)-1,30]:= FormatDateTime('dd-mm-yyyy',form1.ZReadOnlyQuery2.FieldByName('tdate').AsDateTime);   //дата операции
               full_mas[length(Full_mas)-1,31]:= FormatDateTime('hh:nn:ss',form1.ZReadOnlyQuery2.FieldByName('tdate').AsDateTime);   //время операции
              end
             else
             begin
               try
              full_mas[length(Full_mas)-1,30]:=FormatDateTime('dd-mm-yyyy',strtodate(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString,mySettings));   //дата операции
               except
               on exception: EConvertError do
               begin
               showmessagealt('ОШИБКА КОНВЕРТАЦИИ ДАТЫ!!!'+#13+'дата операции: '+form1.ZReadOnlyQuery2.FieldByName('tdate').AsString+#13+'--c01');
               end;
             end;
            end;
            end;
            full_mas[length(Full_mas)-1,32]:= trim(form1.ZReadOnlyQuery2.FieldByName('name').asString); //пользователь совершивший операцию
            full_mas[length(Full_mas)-1,33]:= trim(form1.ZReadOnlyQuery2.FieldByName('remark').asString);  //описание операции
            full_mas[length(Full_mas)-1,34]:= form1.ZReadOnlyQuery2.FieldByName('free_seats').asString;  //[n,34] - kol_swob //кол-во свободных мест
            full_mas[length(Full_mas)-1,35]:= trim(form1.ZReadOnlyQuery2.FieldByName('putevka').asString); //[n,35] putevka
            full_mas[length(Full_mas)-1,36]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString);  //[n,36] driver1
            full_mas[length(Full_mas)-1,37]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver2').asString);  //[n,37] driver2').asString);
            full_mas[length(Full_mas)-1,38]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver3').asString);  //[n,38] driver3').asString);
            full_mas[length(Full_mas)-1,39]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver4').asString);  //[n,39] driver4').asString);
            full_mas[length(Full_mas)-1,40]:= form1.ZReadOnlyQuery2.FieldByName('dateactive').asString;// [n,40] - dateactive //дата начала работы расписания
            full_mas[length(Full_mas)-1,41]:= form1.ZReadOnlyQuery2.FieldByName('dog_flag').asString;// [n,41] - dog_flag //флаг наличия договора
            full_mas[length(Full_mas)-1,42]:= form1.ZReadOnlyQuery2.FieldByName('lic_flag').asString;// [n,42] - lic_flag //флаг наличия лицензии
            full_mas[length(Full_mas)-1,43]:= form1.ZReadOnlyQuery2.FieldByName('kontr_flag').asString;// [n,43] - kontr_flag //флаг наличия перевозчика
            full_mas[length(Full_mas)-1,44]:= form1.ZReadOnlyQuery2.FieldByName('ats_flag').asString;// [n,44] - ats_flag //флаг наличия автобуса
            full_mas[length(Full_mas)-1,45]:= form1.ZReadOnlyQuery2.FieldByName('server_id').asString;//сервер продажи удаленного сервера
            full_mas[length(Full_mas)-1,46]:='0';
            If form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asInteger>0 then
            full_mas[length(Full_mas)-1,46]:= form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString;//порядок пункта сервера в расписании
       //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString));
            //----- Подсчет кол-ва активных отправлений или прибытий
            If full_mas[length(Full_mas)-1,22]<>'0' then
               begin
                   if full_mas[length(Full_mas)-1,16]='2' then
                      begin
                      kol_prib:=kol_prib+1;
                      end;
                   if full_mas[length(Full_mas)-1,16]='1' then
                      begin
                      kol_otpr:=kol_otpr+1;
                      end;
               end
            else
              begin
                //если рейс неактивен по причине договора, лицензии, атп или атс
                  If (full_mas[length(Full_mas)-1,17]='1') and (full_mas[length(Full_mas)-1,26]='1') then
                     kol_unactive:=kol_unactive+1;
               end;
            form1.ZReadOnlyQuery2.Next;
          end;
        end;

  form1.ZReadOnlyQuery2.Close;
  form1.ZConnection2.Disconnect;

  //если фильтр на удаленку, то подключаемся к базе с виртуалкой
  If filtr=7 then
  begin
  sale_server:='0';
  otkuda_name:='';
  ished:='0';
  // Переопределяем подключение на новый любой виртуальный сервер
  for m:=0 to length(mas_otkuda)-1 do
       begin
         if mas_otkuda[m,9]='0' then
          begin
           sale_Server:=mas_otkuda[m,0];
           otkuda_name:=mas_otkuda[m,1];
              break;
             end;
         end;
  If sale_server<>'0' then
   begin
        //подключаемся к УДАЛЕННОМУ серверу
  If (Connect2(form1.Zconnection2, 3)) then
   begin
//инфо панель
   form1.Panel4.Width:=form1.Width;
   form1.Panel4.Left:=0;
   form1.Panel4.Visible:=true;
   application.ProcessMessages;
   active_check:=true; //флаг выполнения обновления

   form1.ZReadOnlyQuery2.SQL.Clear;
        form1.ZReadOnlyQuery2.SQL.Add('select shedule_disp_inet_ticket('+quotedstr('virtual_list')+','+quotedstr(datetostr(work_date))+','+ConnectINI[14]);
        form1.ZReadOnlyQuery2.SQL.Add(','+ished+'); ');
         //form1.ZReadOnlyQuery2.SQL.Add(',115,'+Quotedstr(search_city)+'); ');
        form1.ZReadOnlyQuery2.sql.add('FETCH ALL IN virtual_list;');
        //showmessage(form1.ZReadOnlyQuery2.sql.Text);//$
          try
            form1.ZReadOnlyQuery2.open;
          except
            form1.Panel4.Visible:=false;
            active_check:=false; //флаг выполнения обновления
            result:=false;
             //возвращаем параметры локального сервера
            sale_server:=ConnectINI[14];
            otkuda_name:=server_name;
            //showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);//$
            //form1.ZReadOnlyQuery2.Close;
            //form1.Zconnection2.disconnect;
          end;

    If form1.ZReadOnlyQuery2.RecordCount>0 then
       begin

        for m:=0 to form1.ZReadOnlyQuery2.RecordCount-1 do
          begin
            If trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString)='' then continue;

            SetLength(Full_mas,length(Full_mas)+1,full_mas_size);
            //- Тип рейса в массиве
            //1: из av_trip (регулярный)
            //2: из av_trip_add (заказной)
            //3: из av_ticket_local (удаленный рейс регулярный)
            //4: из av_ticket_local (удаленный рейс заказной)
            //5: из av_ticket виртуального сервера
             full_mas[length(Full_mas)-1,0]:= form1.ZReadOnlyQuery2.FieldByName('zakaz').asString;
             full_mas[length(Full_mas)-1,1]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString);
             full_mas[length(Full_mas)-1,2]:= trim(form1.ZReadOnlyQuery2.FieldByName('plat').asString);
             full_mas[length(Full_mas)-1,3]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_id_point').asString);
             full_mas[length(Full_mas)-1,4]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_order').asString);
             full_mas[length(Full_mas)-1,5]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_name').asString);
             full_mas[length(Full_mas)-1,6]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_id_point').asString);
             full_mas[length(Full_mas)-1,7]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_order').asString);
             full_mas[length(Full_mas)-1,8]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_name').asString);
             full_mas[length(Full_mas)-1,9]:= trim(form1.ZReadOnlyQuery2.FieldByName('form').asString);
            full_mas[length(Full_mas)-1,10]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_o').asString);
            full_mas[length(Full_mas)-1,11]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_s').asString);//время стоянки если регулярный рейс или дата выхода если удаленный
            full_mas[length(Full_mas)-1,12]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_p').asString);
            //full_mas[length(Full_mas)-1,13]:= form1.ZReadOnlyQuery2.FieldByName('id_user').asString);
            full_mas[length(Full_mas)-1,14]:= trim(form1.ZReadOnlyQuery2.FieldByName('date_tarif').asString);
            full_mas[length(Full_mas)-1,15]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_route').asString);
            full_mas[length(Full_mas)-1,16]:= trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString);
   //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString));
            full_mas[length(Full_mas)-1,17]:= form1.ZReadOnlyQuery2.FieldByName('wihod').asString;  //1:выход в рейс в текущий workdate
            full_mas[length(Full_mas)-1,18]:= form1.ZReadOnlyQuery2.FieldByName('id_kontr').asString; //id перевозчика
            full_mas[length(Full_mas)-1,19]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_kontr').asString); //наименование перевозчика
            full_mas[length(Full_mas)-1,20]:= form1.ZReadOnlyQuery2.FieldByName('id_ats').asString; //№ автобуса
            full_mas[length(Full_mas)-1,21]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_ats').asString); //наименование Автобуса
            full_mas[length(Full_mas)-1,22]:= trim(form1.ZReadOnlyQuery2.FieldByName('edet').asString); //прозведение флагов выход по сезонности,лицензия,договор,атс,перевозчик
            full_mas[length(Full_mas)-1,23]:= trim(form1.ZReadOnlyQuery2.FieldByName('dates').asString);
            full_mas[length(Full_mas)-1,24]:= trim(form1.ZReadOnlyQuery2.FieldByName('datepo').asString);
            full_mas[length(Full_mas)-1,25]:= form1.ZReadOnlyQuery2.FieldByName('all_mest').asString;  //мест всего
            full_mas[length(Full_mas)-1,26]:= form1.ZReadOnlyQuery2.FieldByName('activen').asString; //признак активности расписания по датам действия и флагу активности
            full_mas[length(Full_mas)-1,27]:= form1.ZReadOnlyQuery2.FieldByName('type_ats').asString;  //тип АТС
            full_mas[length(Full_mas)-1,28]:= trim(form1.ZReadOnlyQuery2.FieldByName('trip_flag').asString);  //состояние рейса
            full_mas[length(Full_mas)-1,29]:= '0';  //дообилечивания количество ведомостей
           If length(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)>0 then
            begin
             If length(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)>10 then
              begin
               full_mas[length(Full_mas)-1,30]:= FormatDateTime('dd-mm-yyyy',form1.ZReadOnlyQuery2.FieldByName('tdate').AsDateTime);   //дата операции
               full_mas[length(Full_mas)-1,31]:= FormatDateTime('hh:nn:ss',form1.ZReadOnlyQuery2.FieldByName('tdate').AsDateTime);   //время операции
              end
             else
             begin
              try
              full_mas[length(Full_mas)-1,30]:=FormatDateTime('dd-mm-yyyy',strtodate(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString,mySettings));   //дата операции
              except
               on exception: EConvertError do
               begin
               showmessagealt('ОШИБКА КОНВЕРТАЦИИ ДАТЫ!!!'+#13+'дата операции: '+form1.ZReadOnlyQuery2.FieldByName('tdate').AsString+#13+'--c02');
               end;
             end;
            end;
            end;
            full_mas[length(Full_mas)-1,32]:= trim(form1.ZReadOnlyQuery2.FieldByName('name').asString); //пользователь совершивший операцию
            full_mas[length(Full_mas)-1,33]:= trim(form1.ZReadOnlyQuery2.FieldByName('remark').asString);  //описание операции
            full_mas[length(Full_mas)-1,34]:= form1.ZReadOnlyQuery2.FieldByName('free_seats').asString;  //[n,34] - kol_swob //кол-во свободных мест
            full_mas[length(Full_mas)-1,35]:= trim(form1.ZReadOnlyQuery2.FieldByName('putevka').asString); //[n,35] putevka
            full_mas[length(Full_mas)-1,36]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString);  //[n,36] driver1
            full_mas[length(Full_mas)-1,37]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver2').asString);  //[n,37] driver2').asString);
            full_mas[length(Full_mas)-1,38]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver3').asString);  //[n,38] driver3').asString);
            full_mas[length(Full_mas)-1,39]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver4').asString);  //[n,39] driver4').asString);
            full_mas[length(Full_mas)-1,40]:= form1.ZReadOnlyQuery2.FieldByName('dateactive').asString;// [n,40] - dateactive //дата начала работы расписания
            full_mas[length(Full_mas)-1,41]:= form1.ZReadOnlyQuery2.FieldByName('dog_flag').asString;// [n,41] - dog_flag //флаг наличия договора
            full_mas[length(Full_mas)-1,42]:= form1.ZReadOnlyQuery2.FieldByName('lic_flag').asString;// [n,42] - lic_flag //флаг наличия лицензии
            full_mas[length(Full_mas)-1,43]:= form1.ZReadOnlyQuery2.FieldByName('kontr_flag').asString;// [n,43] - kontr_flag //флаг наличия перевозчика
            full_mas[length(Full_mas)-1,44]:= form1.ZReadOnlyQuery2.FieldByName('ats_flag').asString;// [n,44] - ats_flag //флаг наличия автобуса
            full_mas[length(Full_mas)-1,45]:= form1.ZReadOnlyQuery2.FieldByName('server_id').asString;//сервер продажи удаленного сервера
            full_mas[length(Full_mas)-1,46]:='0';
            If form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asInteger>0 then
            full_mas[length(Full_mas)-1,46]:= form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString;//порядок пункта сервера в расписании
       //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString));
            //----- Подсчет кол-ва активных отправлений или прибытий
            If full_mas[length(Full_mas)-1,22]<>'0' then
               begin
                   if full_mas[length(Full_mas)-1,16]='2' then
                      begin
                      kol_prib:=kol_prib+1;
                      end;
                   if full_mas[length(Full_mas)-1,16]='1' then
                      begin
                      kol_otpr:=kol_otpr+1;
                      end;
               end
            else
              begin
                //если рейс неактивен по причине договора, лицензии, атп или атс
                  If (full_mas[length(Full_mas)-1,17]='1') and (full_mas[length(Full_mas)-1,26]='1') then
                     kol_unactive:=kol_unactive+1;
               end;
            form1.ZReadOnlyQuery2.Next;
          end;
      end;
  form1.ZReadOnlyQuery2.Close;
  form1.ZConnection2.Disconnect;
    end;
  end;
  end;
  //возвращаем параметры локального сервера
     sale_server:=ConnectINI[14];
     otkuda_name:=server_name;

  // Обновляем Label количества прибытий и отправлений
   form1.Label26.Caption:='/'+inttostr(kol_otpr);
   form1.Label27.Caption:='/'+inttostr(kol_prib);
   form1.Label49.Caption:='';
   form1.Label50.Caption:='';
   If kol_unactive>0 then
    begin
       form1.Label51.Visible:=true;
       form1.Label52.Visible:=true;
       form1.Label52.Caption:=inttostr(kol_unactive);
    end;
     form1.Panel4.Visible:=false;
     active_check:=false; //флаг выполнения обновления
    result:=true;
    form1.Label44.caption:='1';
end;


//запрос таблицы с билетами агентов
function TForm1.Get_agents():boolean;
var
 m:integer;
begin
  result:=false;
 //  If (trim(ished)='') then ished:='0'
 //else
 //   If length(full_mas)>0 then ished:=full_mas[masindex,1];

  form1.Label44.caption:='0';
  //возвращаем параметры локального сервера
  sale_server:=ConnectINI[14];
  otkuda_name:=server_name;

  //подключаемся к локальному серверу
  If not(Connect2(form1.Zconnection2, 2)) then
   begin
    showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m02-');
    result:=false;
    exit;
   end;
//инфо панель
   form1.Panel4.Width:=form1.Width;
   form1.Panel4.Left:=0;
   form1.Panel4.Visible:=true;
   application.ProcessMessages;
   active_check:=true; //флаг выполнения обновления
   // Запрос к av_trip
        form1.ZReadOnlyQuery2.SQL.Clear;
        //form1.ZReadOnlyQuery2.SQL.Add('select * from av_trip order by t_o,t_p;');
        //t1:=time();
        //--функция возвращает список регулярных и заказных рейсов с выясненным календарным планом, наличием договора и лицензии
        form1.ZReadOnlyQuery2.SQL.Add('SELECT distinct on (id_shedule,trip_date) * FROM av_ticket_agent where not brak and type_oper=1 and trip_date='+quotedstr(datetostr(work_date))+';');
        //showmessage(form1.ZReadOnlyQuery2.sql.Text);
          try
            form1.ZReadOnlyQuery2.open;
          except
            //showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
            form1.ZReadOnlyQuery2.Close;
            form1.Zconnection2.disconnect;
            form1.Panel4.Visible:=false;
            active_check:=false; //флаг выполнения обновления
            result:=false;
            exit;
          end;
           //showmessage(timetostr(time-t1));
          If form1.ZReadOnlyQuery2.RecordCount=0 then
              begin
                form1.ZReadOnlyQuery2.Close;
                form1.Zconnection2.disconnect;
                form1.Panel4.Visible:=false;
                active_check:=false; //флаг выполнения обновления
                result:=false;
                exit;
              end;

    //очищаем массив рейсов
      SetLength(Full_mas,0,0);

  If form1.ZReadOnlyQuery2.RecordCount>0 then
    begin
      result:=true;
  //label44.caption:=label44.caption+'+'+(formatdatetime('ss.zzz',time-t1));//!
 //t1:=time; //!
        // Очищаем массив РЕГУЛЯРНЫХ рейсов в массиве из av_trip
        //form1.clear_mas(1);

        //если общее число рейсов изменилось
           //всего рейсов
             alltrips:=form1.ZReadOnlyQuery2.RecordCount-1;
             kol_otpr:=0;
             kol_prib:=0;
             kol_otpr:=0;
             kol_prib:=0;
             kol_unactive:=0;

        //^^^^^^<<<<< ВНИМАНИЕ ! ПОСЛЕДНЯЯ СТРОКА - КОНТРОЛЬНЫЕ ЗНАЧЕНИЯ ! >>>>>>>>>>>>>>^^^^^^^^^^^^^^^
        // ДОБАВЛЯЕМ В МАССИВ РЕГУЛЯРНЫЕ РЕЙСЫ
        //ZReadOnlyQuery2.First;

        for m:=0 to form1.ZReadOnlyQuery2.RecordCount-1 do
          begin
            //If trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString)='' then continue;
            //если нет такого рейса в массиве, добавляем
            SetLength(Full_mas,length(Full_mas)+1,full_mas_size);
            //- Тип рейса в массиве
            //1: из av_trip (регулярный)
            //2: из av_trip_add (заказной)
            //3: из av_ticket_local (удаленный рейс регулярный)
            //4: из av_ticket_local (удаленный рейс заказной)
            //5: из av_ticket виртуального сервера
             full_mas[length(Full_mas)-1,0]:= '0';
             full_mas[length(Full_mas)-1,1]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString);
             //full_mas[length(Full_mas)-1,2]:= trim(form1.ZReadOnlyQuery2.FieldByName('plat').asString);
             full_mas[length(Full_mas)-1,3]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_trip_ot').asString);//'ot_id_point').asString);
             full_mas[length(Full_mas)-1,4]:= '1';//trim(form1.ZReadOnlyQuery2.FieldByName('ot_order').asString);
             full_mas[length(Full_mas)-1,5]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_trip_ot').asString);//ot_name
             full_mas[length(Full_mas)-1,6]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_trip_do').asString);//do_id_point').asString);
             full_mas[length(Full_mas)-1,7]:= '2';//trim(form1.ZReadOnlyQuery2.FieldByName('do_order').asString);
             full_mas[length(Full_mas)-1,8]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_do').asString);//do_name
             full_mas[length(Full_mas)-1,9]:= '0';//trim(form1.ZReadOnlyQuery2.FieldByName('form').asString);
            full_mas[length(Full_mas)-1,10]:= trim(form1.ZReadOnlyQuery2.FieldByName('trip_time').asString);
            //full_mas[length(Full_mas)-1,11]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_s').asString);//время стоянки если регулярный рейс или дата выхода если удаленный
            //full_mas[length(Full_mas)-1,12]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_p').asString);
            //full_mas[length(Full_mas)-1,13]:= form1.ZReadOnlyQuery2.FieldByName('id_user').asString);
            //full_mas[length(Full_mas)-1,14]:= trim(form1.ZReadOnlyQuery2.FieldByName('date_tarif').asString);
            //full_mas[length(Full_mas)-1,15]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_route').asString);
            full_mas[length(Full_mas)-1,16]:= '1'; //trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString);
   //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString));
            full_mas[length(Full_mas)-1,17]:= '1'; //form1.ZReadOnlyQuery2.FieldByName('wihod').asString;  //1:выход в рейс в текущий workdate
            full_mas[length(Full_mas)-1,18]:= form1.ZReadOnlyQuery2.FieldByName('id_kontr').asString; //id перевозчика
            full_mas[length(Full_mas)-1,19]:= full_mas[length(Full_mas)-1,18];//trim(form1.ZReadOnlyQuery2.FieldByName('name_kontr').asString); //наименование перевозчика
            full_mas[length(Full_mas)-1,20]:= form1.ZReadOnlyQuery2.FieldByName('id_ats').asString; //№ автобуса
            full_mas[length(Full_mas)-1,21]:= form1.ZReadOnlyQuery2.FieldByName('id_ats').asString;//('name_ats').asString); //наименование Автобуса
            full_mas[length(Full_mas)-1,22]:= '1'; //trim(form1.ZReadOnlyQuery2.FieldByName('edet').asString); //прозведение флагов выход по сезонности,лицензия,договор,атс,перевозчик
            //full_mas[length(Full_mas)-1,23]:= trim(form1.ZReadOnlyQuery2.FieldByName('dates').asString);
            //full_mas[length(Full_mas)-1,24]:= trim(form1.ZReadOnlyQuery2.FieldByName('datepo').asString);
            //full_mas[length(Full_mas)-1,25]:= form1.ZReadOnlyQuery2.FieldByName('all_mest').asString;  //мест всего
            full_mas[length(Full_mas)-1,26]:= '1'; //form1.ZReadOnlyQuery2.FieldByName('activen').asString; //признак активности расписания по датам действия и флагу активности
            full_mas[length(Full_mas)-1,27]:= '2'; //form1.ZReadOnlyQuery2.FieldByName('type_ats').asString;  //тип АТС
            full_mas[length(Full_mas)-1,28]:= '0'; //trim(form1.ZReadOnlyQuery2.FieldByName('trip_flag').asString);  //состояние рейса
            full_mas[length(Full_mas)-1,29]:= '0';  //дообилечивания количество ведомостей
           //If length(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)>0 then
           // begin
           //  If length(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)>10 then
           //   begin
           //    full_mas[length(Full_mas)-1,30]:= FormatDateTime('dd-mm-yyyy',form1.ZReadOnlyQuery2.FieldByName('tdate').AsDateTime);   //дата операции
           //    full_mas[length(Full_mas)-1,31]:= FormatDateTime('hh:nn:ss',form1.ZReadOnlyQuery2.FieldByName('tdate').AsDateTime);   //время операции
           //   end
           //  else
           //  begin
           //   full_mas[length(Full_mas)-1,30]:=FormatDateTime('dd-mm-yyyy',strtodate(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString));   //дата операции
           //  end;
           // end;
           // full_mas[length(Full_mas)-1,32]:= trim(form1.ZReadOnlyQuery2.FieldByName('name').asString); //пользователь совершивший операцию
           // full_mas[length(Full_mas)-1,33]:= trim(form1.ZReadOnlyQuery2.FieldByName('remark').asString);  //описание операции
           // full_mas[length(Full_mas)-1,34]:= form1.ZReadOnlyQuery2.FieldByName('free_seats').asString;  //[n,34] - kol_swob //кол-во свободных мест
           // full_mas[length(Full_mas)-1,35]:= trim(form1.ZReadOnlyQuery2.FieldByName('putevka').asString); //[n,35] putevka
           // full_mas[length(Full_mas)-1,36]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString);  //[n,36] driver1
           // full_mas[length(Full_mas)-1,37]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver2').asString);  //[n,37] driver2').asString);
           // full_mas[length(Full_mas)-1,38]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver3').asString);  //[n,38] driver3').asString);
           // full_mas[length(Full_mas)-1,39]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver4').asString);  //[n,39] driver4').asString);
           // full_mas[length(Full_mas)-1,40]:= form1.ZReadOnlyQuery2.FieldByName('dateactive').asString;// [n,40] - dateactive //дата начала работы расписания
            full_mas[length(Full_mas)-1,41]:= '1';//form1.ZReadOnlyQuery2.FieldByName('dog_flag').asString;// [n,41] - dog_flag //флаг наличия договора
            full_mas[length(Full_mas)-1,42]:= '1';//form1.ZReadOnlyQuery2.FieldByName('lic_flag').asString;// [n,42] - lic_flag //флаг наличия лицензии
            full_mas[length(Full_mas)-1,43]:= '1';//form1.ZReadOnlyQuery2.FieldByName('kontr_flag').asString;// [n,43] - kontr_flag //флаг наличия перевозчика
            full_mas[length(Full_mas)-1,44]:= '1';//form1.ZReadOnlyQuery2.FieldByName('ats_flag').asString;// [n,44] - ats_flag //флаг наличия автобуса
            //full_mas[length(Full_mas)-1,45]:= form1.ZReadOnlyQuery2.FieldByName('server_id').asString;//сервер продажи удаленного сервера
           // full_mas[length(Full_mas)-1,46]:='0';
           // If form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asInteger>0 then
           // full_mas[length(Full_mas)-1,46]:= form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString;//порядок пункта сервера в расписании
       //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString));
            //----- Подсчет кол-ва активных отправлений или прибытий

            form1.ZReadOnlyQuery2.Next;
          end;
        end;

  form1.ZReadOnlyQuery2.Close;
  form1.ZConnection2.Disconnect;

  //возвращаем параметры локального сервера
     sale_server:=ConnectINI[14];
     otkuda_name:=server_name;

     form1.Panel4.Visible:=false;
     active_check:=false; //флаг выполнения обновления

    form1.Label44.caption:='1';
end;



//**********************************    Пересчет динамичеких параметров для рейсов в массиве  ************************************
procedure TForm1.Shedule_Calc(clear:byte);
 // clear=0 - просто обновление
 // clear=1 - очищать массив
var
   flag:byte=0;
   flag_av_trip:boolean=false;
   flag_av_trip_add:boolean=true;
   fle:boolean;
   n,m,tn,tm,kol_wed:integer;
   arSezon : array of array of String;
   myYear,myMonth,myDay,myHour,myMin,mySec,myMilli:Word;
   //flerror: boolean;
   tmpmax,tmp:string;
begin
 //flerror:=false;
 tmpmax:='';
 If masindex<0 then masindex:=0;

 If (trim(ished)='') then ished:='0'
 else
    If length(full_mas)>0 then ished:=full_mas[masindex,1];

 If utf8length(ished)>8 then ished:='0';

 If clear>0 then
    begin
    //обнуляем контрольные значения
      //обновление контрольных значений
   md5_av_trip:='';
   md5_av_dog_lic:='';
   md5_operation:=''; //md5 на av_disp_oper
   md5_av_trip_add:=''; //md5 на av_trip_add
   md5_av_trip_atps:='';
     max_operation:='01-01-1980 00:00:00';// max createdate для disp_oper
    end;
   //очищаем массив
 If (clear=1) and (filtr<>7) then
    begin
       SetLength(Full_mas,0,0);
     end;
 //showmessage(full_mas[masindex,1]);//$
   //возвращаем параметры локального сервера
  sale_server:=ConnectINI[14];
  otkuda_name:=server_name;
  // --------------------Соединяемся с локальным сервером----------------------
  If not(Connect2(form1.Zconnection2, 2)) then
   begin
    showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m03-');
    exit;
   end;
//инфо панель
   form1.Panel4.Width:=form1.Width;
   form1.Panel4.Left:=0;
   form1.Panel4.Visible:=true;
   application.ProcessMessages;
   active_check:=true; //флаг выполнения обновления
//sleep(2000);//&
 //t1:=time;
 //label44.Visible:=false;
 //label44.caption:=(formatdatetime('ss.zzz',time-t1));//!
 //t1:=time; //!
        // Запрос к av_trip
   form1.ZReadOnlyQuery2.SQL.Clear;
        //form1.ZReadOnlyQuery2.SQL.Add('select * from av_trip order by t_o,t_p;');
        //t1:=time();
        //--функция возвращает список регулярных и заказных рейсов с выясненным календарным планом, наличием договора и лицензии
   form1.ZReadOnlyQuery2.SQL.Add('select shedule_disp('+quotedstr('shedule_list')+','+quotedstr(datetostr(work_date))+','+ConnectINI[14]);
        //form1.ZReadOnlyQuery2.SQL.Add(ConnectINI[14]+','+inttostr(7)+','+ished+',');
        //form1.ZReadOnlyQuery2.SQL.Add(Quotedstr(md5_av_trip)+','+QuotedStr(md5_av_trip_atps)+','+Quotedstr(md5_av_dog_lic)+',');
        //form1.ZReadOnlyQuery2.SQL.Add(Quotedstr(md5_operation)+','+Quotedstr(md5_av_trip_add)+','+Quotedstr(search_city)); //Quotedstr(md5_tick_local));
        //form1.ZReadOnlyQuery2.SQL.Add(','+Quotedstr(search_city+'%'));
        //If clear=2 then
           //form1.ZReadOnlyQuery2.SQL.Add(',-1')
           //else
   form1.ZReadOnlyQuery2.SQL.Add(','+inttostr(filtr));
   form1.ZReadOnlyQuery2.SQL.Add(','+ished+','+Quotedstr(search_city)+'); ');
         //form1.ZReadOnlyQuery2.SQL.Add(',115,'+Quotedstr(search_city)+'); ');
   form1.ZReadOnlyQuery2.sql.add('FETCH ALL IN shedule_list;');
        //If fle then
     //showmessage(form1.ZReadOnlyQuery2.sql.Text);//$
   try
    form1.ZReadOnlyQuery2.open;
   except
            //showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
    showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
    form1.ZReadOnlyQuery2.Close;
    form1.Zconnection2.disconnect;
    form1.Panel4.Visible:=false;
    active_check:=false; //флаг выполнения обновления
    exit;
   end;
           //showmessage(timetostr(time-t1));//$
    fle:=false;
   If form1.ZReadOnlyQuery2.RecordCount>0 then
     begin
        fle:=true;
          //очищаем массив
          //If clear=1 then
          //    begin
          //    SetLength(Full_mas,0,0);
          //    end;
  //label44.caption:=label44.caption+'+'+(formatdatetime('ss.zzz',time-t1));//!
 //t1:=time; //!
        // Очищаем массив РЕГУЛЯРНЫХ рейсов в массиве из av_trip
        //form1.clear_mas(1);

        //если общее число рейсов изменилось
        If (filtr=1) then
           begin
           //всего рейсов
             alltrips:=form1.ZReadOnlyQuery2.RecordCount-2;
             kol_otpr:=0;
             kol_prib:=0;
           end;
          If (filtr=3) then
           begin
             kol_otpr:=0;
           end;
            If (filtr=4) then
           begin
             kol_prib:=0;
           end;
            If filtr=5 then  kol_unactive:=0;

        //^^^^^^<<<<< ВНИМАНИЕ ! ПОСЛЕДНЯЯ СТРОКА - КОНТРОЛЬНЫЕ ЗНАЧЕНИЯ ! >>>>>>>>>>>>>>^^^^^^^^^^^^^^^
        // ДОБАВЛЯЕМ В МАССИВ РЕГУЛЯРНЫЕ РЕЙСЫ
        //ZReadOnlyQuery2.First;
       form1.ZReadOnlyQuery2.First;

        for m:=0 to form1.ZReadOnlyQuery2.RecordCount-1 do
          begin
            If trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString)='' then continue;
            //If form1.ZReadOnlyQuery2.FieldByName('id_shedule').asInteger=115 then
             //begin
               //sleep(1);
             //end;
            flag:=0;
         //пробегаем текущий массив
         for n:=0 to length(full_mas)-1 do
           begin
            //находим рейс измененного расписания
           //  If (full_mas[n,1]='243') and (form1.ZReadOnlyQuery2.FieldByName('id_shedule').Asinteger=243) then
           //   begin
           //      showmessage(   form1.ZReadOnlyQuery2.FieldByName('free_seats').AsString +#13+
           //      full_mas[n,1]+'='+form1.ZReadOnlyQuery2.FieldByName('id_shedule').AsString +#13+
           //full_mas[n,0]+'='+form1.ZReadOnlyQuery2.FieldByName('zakaz').asString +#13+
           //full_mas[n,3]+'='+form1.ZReadOnlyQuery2.FieldByName('ot_id_point').asString +#13+
           //full_mas[n,16]+'='+form1.ZReadOnlyQuery2.FieldByName('napr').asString +#13+
           //full_mas[n,10]+'='+form1.ZReadOnlyQuery2.FieldByName('t_o').asString +#13+
           //full_mas[n,11]+'='+form1.ZReadOnlyQuery2.FieldByName('t_s').asString +#13+
           //full_mas[n,12]+'='+form1.ZReadOnlyQuery2.FieldByName('t_p').asString +#13+
           //full_mas[n,46]+'='+form1.ZReadOnlyQuery2.FieldByName('order_otkuda').AsString
           //      );
           //    end;
              //If full_mas[n,1]='115' then showmessage(form1.ZReadOnlyQuery2.FieldByName('wihod').asString+#13+form1.ZReadOnlyQuery2.FieldByName('edet').asString);

          IF (full_mas[n,1]=form1.ZReadOnlyQuery2.FieldByName('id_shedule').AsString) AND
            (full_mas[n,0]=form1.ZReadOnlyQuery2.FieldByName('zakaz').asString) and
            (full_mas[n,3]=form1.ZReadOnlyQuery2.FieldByName('ot_id_point').asString) AND
           (full_mas[n,16]=form1.ZReadOnlyQuery2.FieldByName('napr').asString) AND
           (full_mas[n,10]=form1.ZReadOnlyQuery2.FieldByName('t_o').asString) AND
           (full_mas[n,11]=form1.ZReadOnlyQuery2.FieldByName('t_s').asString) AND
           (full_mas[n,12]=form1.ZReadOnlyQuery2.FieldByName('t_p').asString)  then
           If (full_mas[n,46]='0') or (full_mas[n,46]=form1.ZReadOnlyQuery2.FieldByName('order_otkuda').AsString) THEN
                    begin

                      //showmessage(full_mas[n,46]+' | '+form1.ZReadOnlyQuery2.FieldByName('order_otkuda').AsString);//$
                    full_mas[n,2]:= form1.ZReadOnlyQuery2.FieldByName('plat').asString;
                    full_mas[n,4]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_order').asString);
                    full_mas[n,5]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_name').asString);
                    full_mas[n,6]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_id_point').asString);
                    full_mas[n,7]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_order').asString);
                    full_mas[n,8]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_name').asString);
                    full_mas[n,9]:= form1.ZReadOnlyQuery2.FieldByName('form').asString;
                    //full_mas[n,10]=trim(form1.ZReadOnlyQuery2.FieldByName('t_o').asString);
                    //full_mas[n,11]=trim(form1.ZReadOnlyQuery2.FieldByName('t_s').asString);//время стоянки если регулярный рейс или дата выхода если удаленный
                    //full_mas[n,12]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_p').asString);
                    //full_mas[n,13]:= form1.ZReadOnlyQuery2.FieldByName('id_user').asString;
                    If trim(form1.ZReadOnlyQuery2.FieldByName('date_tarif').AsString)<>'' then
                    full_mas[n,14]:= trim(form1.ZReadOnlyQuery2.FieldByName('date_tarif').asString);
                    full_mas[n,15]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_route').asString);
                    full_mas[n,16]:= trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString);
                    full_mas[n,17]:= form1.ZReadOnlyQuery2.FieldByName('wihod').asString;  //1:выход в рейс в текущий workdate
                    If not(form1.ZReadOnlyQuery2.FieldByName('id_kontr').asInteger=0) then
                      begin
                    full_mas[n,18]:= form1.ZReadOnlyQuery2.FieldByName('id_kontr').asString; //id перевозчика
                    full_mas[n,19]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_kontr').asString); //наименование перевозчика
                    full_mas[n,20]:= form1.ZReadOnlyQuery2.FieldByName('id_ats').asString; //№ автобуса
                    full_mas[n,21]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_ats').asString); //наименование Автобуса
                    full_mas[n,22]:= trim(form1.ZReadOnlyQuery2.FieldByName('edet').asString); //прозведение флагов выход по сезонности,лицензия,договор,атс,перевозчик
                    full_mas[n,23]:= trim(form1.ZReadOnlyQuery2.FieldByName('dates').asString);
                    full_mas[n,24]:= trim(form1.ZReadOnlyQuery2.FieldByName('datepo').asString);
                    full_mas[n,25]:= trim(form1.ZReadOnlyQuery2.FieldByName('all_mest').asString);
                    full_mas[n,26]:= form1.ZReadOnlyQuery2.FieldByName('activen').asString; //признак активности расписания по датам действия и флагу активности
                    full_mas[n,27]:= trim(form1.ZReadOnlyQuery2.FieldByName('type_ats').asString);
                    full_mas[n,28]:= trim(form1.ZReadOnlyQuery2.FieldByName('trip_flag').asString);
                    full_mas[n,29]:= '0';//trim(form1.ZReadOnlyQuery2.FieldByName('extra_vedom').asString);
                    If trim(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)<>'' then
                      begin
                       full_mas[n,30]:= formatDatetime('dd-mm-yyyy',form1.ZReadOnlyQuery2.FieldByName('tdate').asDateTime);  //дата операции
                       full_mas[n,31]:= formatDatetime('hh:nn:ss',form1.ZReadOnlyQuery2.FieldByName('tdate').asDateTime);  //время операции
                      end;
                    end;
                     If trim(form1.ZReadOnlyQuery2.FieldByName('name').asString)<>'' then
                        full_mas[n,32]:= trim(form1.ZReadOnlyQuery2.FieldByName('name').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('remark').asString)<>'' then
                        full_mas[n,33]:= trim(form1.ZReadOnlyQuery2.FieldByName('remark').asString);
                     IF trim(form1.ZReadOnlyQuery2.FieldByName('free_seats').asString)<>'' then
                        full_mas[n,34]:= form1.ZReadOnlyQuery2.FieldByName('free_seats').asString;  //[n,34] - kol_swob //кол-во свободных мест

                     If trim(form1.ZReadOnlyQuery2.FieldByName('putevka').asString)<>'' then
                        full_mas[n,35]:= trim(form1.ZReadOnlyQuery2.FieldByName('putevka').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString)<>'' then
                        full_mas[n,36]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('driver2').asString)<>'' then
                        full_mas[n,37]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver2').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('driver3').asString)<>'' then
                        full_mas[n,38]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver3').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('driver4').asString)<>'' then
                        full_mas[n,39]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver4').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('dateactive').AsString)<>'' then
                       full_mas[n,40]:= form1.ZReadOnlyQuery2.FieldByName('dateactive').asString;// [n,40] - dateactive //дата начала работы расписания

                     If not(form1.ZReadOnlyQuery2.FieldByName('id_kontr').asInteger=0) then
                      begin
                    full_mas[n,41]:= form1.ZReadOnlyQuery2.FieldByName('dog_flag').asString;// [n,41] - dog_flag //флаг наличия договора
                    full_mas[n,42]:= form1.ZReadOnlyQuery2.FieldByName('lic_flag').asString;// [n,42] - lic_flag //флаг наличия лицензии
                    full_mas[n,43]:= form1.ZReadOnlyQuery2.FieldByName('kontr_flag').asString;// [n,43] - kontr_flag //флаг наличия перевозчика
                    full_mas[n,44]:= form1.ZReadOnlyQuery2.FieldByName('ats_flag').asString;// [n,44] - ats_flag //флаг наличия автобуса
                    full_mas[n,45]:= form1.ZReadOnlyQuery2.FieldByName('server_id').asString;//сервер продажи удаленного сервера
                    full_mas[n,46]:= '0';
                    If form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asInteger>0 then
                    full_mas[n,46]:=form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString;//порядок пункта сервера в расписании
                      end;
                     flag:=1;
                     break;
                    end;
           end;

         If flag=0 then
            begin
             //If clear=0 then
                 //showmessage(full_mas[n,46]+' <>| '+form1.ZReadOnlyQuery2.FieldByName('order_otkuda').AsString);//$
            //если нет такого рейса в массиве, добавляем
            SetLength(Full_mas,length(Full_mas)+1,full_mas_size);
            //- Тип рейса в массиве
            //1: из av_trip (регулярный)
            //2: из av_trip_add (заказной)
            //3: из av_ticket_local (удаленный рейс регулярный)
            //4: из av_ticket_local (удаленный рейс заказной)
            full_mas[length(Full_mas)-1,0]:= form1.ZReadOnlyQuery2.FieldByName('zakaz').asString;
            full_mas[length(Full_mas)-1,1]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString);
            full_mas[length(Full_mas)-1,2]:= trim(form1.ZReadOnlyQuery2.FieldByName('plat').asString);
            full_mas[length(Full_mas)-1,3]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_id_point').asString);
            full_mas[length(Full_mas)-1,4]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_order').asString);
            full_mas[length(Full_mas)-1,5]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_name').asString);
            full_mas[length(Full_mas)-1,6]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_id_point').asString);
            full_mas[length(Full_mas)-1,7]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_order').asString);
            full_mas[length(Full_mas)-1,8]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_name').asString);
            full_mas[length(Full_mas)-1,9]:= trim(form1.ZReadOnlyQuery2.FieldByName('form').asString);
            full_mas[length(Full_mas)-1,10]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_o').asString);
            full_mas[length(Full_mas)-1,11]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_s').asString);//время стоянки если регулярный рейс или дата выхода если удаленный
            full_mas[length(Full_mas)-1,12]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_p').asString);
            //full_mas[length(Full_mas)-1,13]:= form1.ZReadOnlyQuery2.FieldByName('id_user').asString;
            full_mas[length(Full_mas)-1,14]:= trim(form1.ZReadOnlyQuery2.FieldByName('date_tarif').asString);
            full_mas[length(Full_mas)-1,15]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_route').asString);
            full_mas[length(Full_mas)-1,16]:= trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString);
   //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString));
            full_mas[length(Full_mas)-1,17]:= form1.ZReadOnlyQuery2.FieldByName('wihod').asString;  //1:выход в рейс в текущий workdate
            full_mas[length(Full_mas)-1,18]:= form1.ZReadOnlyQuery2.FieldByName('id_kontr').asString; //id перевозчика
            full_mas[length(Full_mas)-1,19]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_kontr').asString); //наименование перевозчика
            full_mas[length(Full_mas)-1,20]:= form1.ZReadOnlyQuery2.FieldByName('id_ats').asString; //№ автобуса
            full_mas[length(Full_mas)-1,21]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_ats').asString); //наименование Автобуса
            full_mas[length(Full_mas)-1,22]:= trim(form1.ZReadOnlyQuery2.FieldByName('edet').asString); //прозведение флагов выход по сезонности,лицензия,договор,атс,перевозчик
            full_mas[length(Full_mas)-1,23]:= trim(form1.ZReadOnlyQuery2.FieldByName('dates').asString);
            full_mas[length(Full_mas)-1,24]:= trim(form1.ZReadOnlyQuery2.FieldByName('datepo').asString);
            full_mas[length(Full_mas)-1,25]:= form1.ZReadOnlyQuery2.FieldByName('all_mest').asString;  //мест всего
            full_mas[length(Full_mas)-1,26]:= form1.ZReadOnlyQuery2.FieldByName('activen').asString; //признак активности расписания по датам действия и флагу активности
            full_mas[length(Full_mas)-1,27]:= form1.ZReadOnlyQuery2.FieldByName('type_ats').asString;  //тип АТС
            full_mas[length(Full_mas)-1,28]:= trim(form1.ZReadOnlyQuery2.FieldByName('trip_flag').asString);  //состояние рейса
            full_mas[length(Full_mas)-1,29]:= '0';  //дообилечивания количество ведомостей
            If trim(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)<>'' then
               begin
            full_mas[length(Full_mas)-1,30]:= formatDatetime('dd-mm-yyyy',form1.ZReadOnlyQuery2.FieldByName('tdate').asDateTime);  //дата операции
            full_mas[length(Full_mas)-1,31]:= formatDatetime('hh:nn:ss',form1.ZReadOnlyQuery2.FieldByName('tdate').asDateTime);  //время операции
               end;
            full_mas[length(Full_mas)-1,32]:= trim(form1.ZReadOnlyQuery2.FieldByName('name').asString); //пользователь совершивший операцию
            full_mas[length(Full_mas)-1,33]:= trim(form1.ZReadOnlyQuery2.FieldByName('remark').asString);  //описание операции
            full_mas[length(Full_mas)-1,34]:= form1.ZReadOnlyQuery2.FieldByName('free_seats').asString;  //[n,34] - kol_swob //кол-во свободных мест
            full_mas[length(Full_mas)-1,35]:= trim(form1.ZReadOnlyQuery2.FieldByName('putevka').asString); //[n,35] putevka
            full_mas[length(Full_mas)-1,36]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString);  //[n,36] driver1
            full_mas[length(Full_mas)-1,37]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver2').asString);  //[n,37] driver2').asString);
            full_mas[length(Full_mas)-1,38]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver3').asString);  //[n,38] driver3').asString);
            full_mas[length(Full_mas)-1,39]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver4').asString);  //[n,39] driver4').asString);
            full_mas[length(Full_mas)-1,40]:= form1.ZReadOnlyQuery2.FieldByName('dateactive').asString;// [n,40] - dateactive //дата начала работы расписания
            full_mas[length(Full_mas)-1,41]:= form1.ZReadOnlyQuery2.FieldByName('dog_flag').asString;// [n,41] - dog_flag //флаг наличия договора
            full_mas[length(Full_mas)-1,42]:= form1.ZReadOnlyQuery2.FieldByName('lic_flag').asString;// [n,42] - lic_flag //флаг наличия лицензии
            full_mas[length(Full_mas)-1,43]:= form1.ZReadOnlyQuery2.FieldByName('kontr_flag').asString;// [n,43] - kontr_flag //флаг наличия перевозчика
            full_mas[length(Full_mas)-1,44]:= form1.ZReadOnlyQuery2.FieldByName('ats_flag').asString;// [n,44] - ats_flag //флаг наличия автобуса
            full_mas[length(Full_mas)-1,45]:= form1.ZReadOnlyQuery2.FieldByName('server_id').asString;//сервер продажи удаленного сервера
            full_mas[length(Full_mas)-1,46]:='0';
            If form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asInteger>0 then
            full_mas[length(Full_mas)-1,46]:= form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString;//порядок пункта сервера в расписании
       //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString));
           end;
            //----- Подсчет кол-ва активных отправлений или прибытий
            If full_mas[length(Full_mas)-1,22]<>'0' then
               begin
                   if full_mas[length(Full_mas)-1,16]='2' then
                      begin
                      kol_prib:=kol_prib+1;
                      end;
                   if full_mas[length(Full_mas)-1,16]='1' then
                      begin
                      kol_otpr:=kol_otpr+1;
                      end;
               end
            else
              begin
                //если рейс неактивен по причине договора, лицензии, атп или атс
                  If (full_mas[length(Full_mas)-1,17]='1') and (full_mas[length(Full_mas)-1,26]='1') then
                     kol_unactive:=kol_unactive+1;
                end;
            form1.ZReadOnlyQuery2.Next;
          end;

       //form1.ZReadOnlyQuery2.Last;
       //запоминаем новые значения md5
       //If filtr=1 then
       //   begin
       //If trim(form1.ZReadOnlyQuery2.FieldByName('name_ats').asString)<>'' then
       //md5_operation:=  form1.ZReadOnlyQuery2.FieldByName('name_ats').asString;
       //If trim(form1.ZReadOnlyQuery2.FieldByName('ot_name').asString)<>'' then
       //md5_av_trip:=    form1.ZReadOnlyQuery2.FieldByName('ot_name').AsString;     // md5 для av_trip
       //If trim(form1.ZReadOnlyQuery2.FieldByName('tdate').asString)<>'' then
       //md5_av_trip_add:=form1.ZReadOnlyQuery2.FieldByName('putevka').AsString; // md5 для av_trip_add
       //If trim(form1.ZReadOnlyQuery2.FieldByName('do_name').asString)<>'' then
       //md5_av_trip_atps:=form1.ZReadOnlyQuery2.FieldByName('do_name').AsString;
       //If trim(form1.ZReadOnlyQuery2.FieldByName('name_kontr').asString)<>'' then
       //md5_av_dog_lic:= form1.ZReadOnlyQuery2.FieldByName('name_kontr').AsString;
       //If trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString)<>'' then
       //md5_tick_local:= form1.ZReadOnlyQuery2.FieldByName('driver1').AsString;
          //end;
     end;

  form1.ZReadOnlyQuery2.Close;
  form1.ZConnection2.Disconnect;

   //если фильтр на удаленку, то подключаемся к базе с виртуалкой
  If filtr=7 then
  begin
          //очищаем массив
          If (clear=1) and not fle then
              begin
              SetLength(Full_mas,0,0);
              end;
  sale_server:='0';
  otkuda_name:='';
   ished:='0';
  // Переопределяем подключение на новый любой виртуальный сервер
  for m:=0 to length(mas_otkuda)-1 do
       begin
         if mas_otkuda[m,9]='0' then
          begin
          sale_Server:=mas_otkuda[m,0];
           otkuda_name:=mas_otkuda[m,1];
           break;
          end;
       end;
  If sale_server<>'0' then
   begin
        //подключаемся к УДАЛЕННОМУ серверу
  If (Connect2(form1.Zconnection2, 3)) then
   begin

//инфо панель
   form1.Panel4.Width:=form1.Width;
   form1.Panel4.Left:=0;
   form1.Panel4.Visible:=true;
   application.ProcessMessages;
   active_check:=true; //флаг выполнения обновления

   form1.ZReadOnlyQuery2.SQL.Clear;
        form1.ZReadOnlyQuery2.SQL.Add('select shedule_disp_inet_ticket('+quotedstr('virtual_list')+','+quotedstr(datetostr(work_date))+','+ConnectINI[14]);
        form1.ZReadOnlyQuery2.SQL.Add(','+ished+'); ');
         //form1.ZReadOnlyQuery2.SQL.Add(',115,'+Quotedstr(search_city)+'); ');
        form1.ZReadOnlyQuery2.sql.add('FETCH ALL IN virtual_list;');
        //showmessage(form1.ZReadOnlyQuery2.sql.Text);//$
          try
            form1.ZReadOnlyQuery2.open;
          except
            form1.Panel4.Visible:=false;
            active_check:=false; //флаг выполнения обновления
             //возвращаем параметры локального сервера
           sale_server:=ConnectINI[14];
            otkuda_name:=server_name;
            showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
            //form1.ZReadOnlyQuery2.Close;
            //form1.Zconnection2.disconnect;
          end;

  If form1.ZReadOnlyQuery2.RecordCount>0 then
       begin
        for m:=0 to form1.ZReadOnlyQuery2.RecordCount-1 do
          begin
            If trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString)='' then continue;
            //If form1.ZReadOnlyQuery2.FieldByName('id_shedule').asInteger=115 then
             //begin
               //sleep(1);
             //end;
            flag:=0;
         //пробегаем текущий массив
         for n:=0 to length(full_mas)-1 do
           begin
            //находим рейс измененного расписания
           //  If (full_mas[n,1]='243') and (form1.ZReadOnlyQuery2.FieldByName('id_shedule').Asinteger=243) then
           //   begin
           //showmessage(form1.ZReadOnlyQuery2.FieldByName('free_seats').AsString +#13+
           //      full_mas[n,1]+'='+form1.ZReadOnlyQuery2.FieldByName('id_shedule').AsString +#13+
           //full_mas[n,0]+'='+form1.ZReadOnlyQuery2.FieldByName('zakaz').asString +#13+
           //full_mas[n,3]+'='+form1.ZReadOnlyQuery2.FieldByName('ot_id_point').asString +#13+
           //full_mas[n,16]+'='+form1.ZReadOnlyQuery2.FieldByName('napr').asString +#13+
           //full_mas[n,10]+'='+form1.ZReadOnlyQuery2.FieldByName('t_o').asString +#13+
           //full_mas[n,11]+'='+form1.ZReadOnlyQuery2.FieldByName('t_s').asString +#13+
           //full_mas[n,12]+'='+form1.ZReadOnlyQuery2.FieldByName('t_p').asString +#13+
           //full_mas[n,46]+'='+form1.ZReadOnlyQuery2.FieldByName('order_otkuda').AsString
           //      );
           //    end;


          IF (full_mas[n,1]=form1.ZReadOnlyQuery2.FieldByName('id_shedule').AsString) AND
            (full_mas[n,0]=form1.ZReadOnlyQuery2.FieldByName('zakaz').asString) and
            (full_mas[n,3]=form1.ZReadOnlyQuery2.FieldByName('ot_id_point').asString) AND
           (full_mas[n,16]=form1.ZReadOnlyQuery2.FieldByName('napr').asString) AND
           (full_mas[n,10]=form1.ZReadOnlyQuery2.FieldByName('t_o').asString)
           //AND (full_mas[n,11]=form1.ZReadOnlyQuery2.FieldByName('t_s').asString)
           //AND (full_mas[n,12]=form1.ZReadOnlyQuery2.FieldByName('t_p').asString)
            then
           If (full_mas[n,46]='0') or (full_mas[n,46]=form1.ZReadOnlyQuery2.FieldByName('order_otkuda').AsString) THEN
                    begin

                      //showmessage(full_mas[n,46]+' | '+form1.ZReadOnlyQuery2.FieldByName('order_otkuda').AsString);//$
                    full_mas[n,2]:= form1.ZReadOnlyQuery2.FieldByName('plat').asString;
                    full_mas[n,4]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_order').asString);
                    full_mas[n,5]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_name').asString);
                    full_mas[n,6]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_id_point').asString);
                    full_mas[n,7]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_order').asString);
                    full_mas[n,8]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_name').asString);
                    full_mas[n,9]:= form1.ZReadOnlyQuery2.FieldByName('form').asString;
                    //full_mas[n,10]=trim(form1.ZReadOnlyQuery2.FieldByName('t_o').asString);
                    //full_mas[n,11]=trim(form1.ZReadOnlyQuery2.FieldByName('t_s').asString);//время стоянки если регулярный рейс или дата выхода если удаленный
                    //full_mas[n,12]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_p').asString);
                    //full_mas[n,13]:= form1.ZReadOnlyQuery2.FieldByName('id_user').asString;
                    If trim(form1.ZReadOnlyQuery2.FieldByName('date_tarif').AsString)<>'' then
                    full_mas[n,14]:= trim(form1.ZReadOnlyQuery2.FieldByName('date_tarif').asString);
                    full_mas[n,15]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_route').asString);
                    full_mas[n,16]:= trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString);
                    full_mas[n,17]:= form1.ZReadOnlyQuery2.FieldByName('wihod').asString;  //1:выход в рейс в текущий workdate
                    If not(form1.ZReadOnlyQuery2.FieldByName('id_kontr').asInteger=0) then
                      begin
                    full_mas[n,18]:= form1.ZReadOnlyQuery2.FieldByName('id_kontr').asString; //id перевозчика
                    full_mas[n,19]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_kontr').asString); //наименование перевозчика
                    full_mas[n,20]:= form1.ZReadOnlyQuery2.FieldByName('id_ats').asString; //№ автобуса
                    full_mas[n,21]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_ats').asString); //наименование Автобуса
                    full_mas[n,22]:= trim(form1.ZReadOnlyQuery2.FieldByName('edet').asString); //прозведение флагов выход по сезонности,лицензия,договор,атс,перевозчик
                    full_mas[n,23]:= trim(form1.ZReadOnlyQuery2.FieldByName('dates').asString);
                    full_mas[n,24]:= trim(form1.ZReadOnlyQuery2.FieldByName('datepo').asString);
                    full_mas[n,25]:= trim(form1.ZReadOnlyQuery2.FieldByName('all_mest').asString);
                    full_mas[n,26]:= form1.ZReadOnlyQuery2.FieldByName('activen').asString; //признак активности расписания по датам действия и флагу активности
                    full_mas[n,27]:= trim(form1.ZReadOnlyQuery2.FieldByName('type_ats').asString);
                    full_mas[n,28]:= trim(form1.ZReadOnlyQuery2.FieldByName('trip_flag').asString);
                    full_mas[n,29]:= '0';//trim(form1.ZReadOnlyQuery2.FieldByName('extra_vedom').asString);
                    If trim(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)<>'' then
                      begin
                       full_mas[n,30]:= formatDatetime('dd-mm-yyyy',form1.ZReadOnlyQuery2.FieldByName('tdate').asDateTime);  //дата операции
                       full_mas[n,31]:= formatDatetime('hh:nn:ss',form1.ZReadOnlyQuery2.FieldByName('tdate').asDateTime);  //время операции
                      end;
                    end;
                     If trim(form1.ZReadOnlyQuery2.FieldByName('name').asString)<>'' then
                        full_mas[n,32]:= trim(form1.ZReadOnlyQuery2.FieldByName('name').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('remark').asString)<>'' then
                        full_mas[n,33]:= trim(form1.ZReadOnlyQuery2.FieldByName('remark').asString);
                     IF trim(form1.ZReadOnlyQuery2.FieldByName('free_seats').asString)<>'' then
                        full_mas[n,34]:= form1.ZReadOnlyQuery2.FieldByName('free_seats').asString;  //[n,34] - kol_swob //кол-во свободных мест

                     If trim(form1.ZReadOnlyQuery2.FieldByName('putevka').asString)<>'' then
                        full_mas[n,35]:= trim(form1.ZReadOnlyQuery2.FieldByName('putevka').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString)<>'' then
                        full_mas[n,36]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('driver2').asString)<>'' then
                        full_mas[n,37]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver2').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('driver3').asString)<>'' then
                        full_mas[n,38]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver3').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('driver4').asString)<>'' then
                        full_mas[n,39]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver4').asString);
                     If trim(form1.ZReadOnlyQuery2.FieldByName('dateactive').AsString)<>'' then
                       full_mas[n,40]:= form1.ZReadOnlyQuery2.FieldByName('dateactive').asString;// [n,40] - dateactive //дата начала работы расписания

                     If not(form1.ZReadOnlyQuery2.FieldByName('id_kontr').asInteger=0) then
                      begin
                    full_mas[n,41]:= form1.ZReadOnlyQuery2.FieldByName('dog_flag').asString;// [n,41] - dog_flag //флаг наличия договора
                    full_mas[n,42]:= form1.ZReadOnlyQuery2.FieldByName('lic_flag').asString;// [n,42] - lic_flag //флаг наличия лицензии
                    full_mas[n,43]:= form1.ZReadOnlyQuery2.FieldByName('kontr_flag').asString;// [n,43] - kontr_flag //флаг наличия перевозчика
                    full_mas[n,44]:= form1.ZReadOnlyQuery2.FieldByName('ats_flag').asString;// [n,44] - ats_flag //флаг наличия автобуса
                    full_mas[n,45]:= form1.ZReadOnlyQuery2.FieldByName('server_id').asString;//сервер продажи удаленного сервера
                    full_mas[n,46]:= '0';
                    If form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asInteger>0 then
                    full_mas[n,46]:=form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString;//порядок пункта сервера в расписании
                      end;
                     flag:=1;
                     break;
                    end;
           end;

         If flag=0 then
            begin

             //If clear=0 then
                 //showmessage(full_mas[n,46]+' <>| '+form1.ZReadOnlyQuery2.FieldByName('order_otkuda').AsString);//$
            //если нет такого рейса в массиве, добавляем
            SetLength(Full_mas,length(Full_mas)+1,full_mas_size);
            //- Тип рейса в массиве
            //1: из av_trip (регулярный)
            //2: из av_trip_add (заказной)
            //3: из av_ticket_local (удаленный рейс регулярный)
            //4: из av_ticket_local (удаленный рейс заказной)
            full_mas[length(Full_mas)-1,0]:= form1.ZReadOnlyQuery2.FieldByName('zakaz').asString;
            full_mas[length(Full_mas)-1,1]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_shedule').asString);
            full_mas[length(Full_mas)-1,2]:= trim(form1.ZReadOnlyQuery2.FieldByName('plat').asString);
            full_mas[length(Full_mas)-1,3]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_id_point').asString);
            full_mas[length(Full_mas)-1,4]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_order').asString);
            full_mas[length(Full_mas)-1,5]:= trim(form1.ZReadOnlyQuery2.FieldByName('ot_name').asString);
            full_mas[length(Full_mas)-1,6]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_id_point').asString);
            full_mas[length(Full_mas)-1,7]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_order').asString);
            full_mas[length(Full_mas)-1,8]:= trim(form1.ZReadOnlyQuery2.FieldByName('do_name').asString);
            full_mas[length(Full_mas)-1,9]:= trim(form1.ZReadOnlyQuery2.FieldByName('form').asString);
            full_mas[length(Full_mas)-1,10]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_o').asString);
            full_mas[length(Full_mas)-1,11]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_s').asString);//время стоянки если регулярный рейс или дата выхода если удаленный
            full_mas[length(Full_mas)-1,12]:= trim(form1.ZReadOnlyQuery2.FieldByName('t_p').asString);
            //full_mas[length(Full_mas)-1,13]:= form1.ZReadOnlyQuery2.FieldByName('id_user').asString;
            full_mas[length(Full_mas)-1,14]:= trim(form1.ZReadOnlyQuery2.FieldByName('date_tarif').asString);
            full_mas[length(Full_mas)-1,15]:= trim(form1.ZReadOnlyQuery2.FieldByName('id_route').asString);
            full_mas[length(Full_mas)-1,16]:= trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString);
   //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('napr').asString));
            full_mas[length(Full_mas)-1,17]:= form1.ZReadOnlyQuery2.FieldByName('wihod').asString;  //1:выход в рейс в текущий workdate
            full_mas[length(Full_mas)-1,18]:= form1.ZReadOnlyQuery2.FieldByName('id_kontr').asString; //id перевозчика
            full_mas[length(Full_mas)-1,19]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_kontr').asString); //наименование перевозчика
            full_mas[length(Full_mas)-1,20]:= form1.ZReadOnlyQuery2.FieldByName('id_ats').asString; //№ автобуса
            full_mas[length(Full_mas)-1,21]:= trim(form1.ZReadOnlyQuery2.FieldByName('name_ats').asString); //наименование Автобуса
            full_mas[length(Full_mas)-1,22]:= trim(form1.ZReadOnlyQuery2.FieldByName('edet').asString); //прозведение флагов выход по сезонности,лицензия,договор,атс,перевозчик
            full_mas[length(Full_mas)-1,23]:= trim(form1.ZReadOnlyQuery2.FieldByName('dates').asString);
            full_mas[length(Full_mas)-1,24]:= trim(form1.ZReadOnlyQuery2.FieldByName('datepo').asString);
            full_mas[length(Full_mas)-1,25]:= form1.ZReadOnlyQuery2.FieldByName('all_mest').asString;  //мест всего
            full_mas[length(Full_mas)-1,26]:= form1.ZReadOnlyQuery2.FieldByName('activen').asString; //признак активности расписания по датам действия и флагу активности
            full_mas[length(Full_mas)-1,27]:= form1.ZReadOnlyQuery2.FieldByName('type_ats').asString;  //тип АТС
            full_mas[length(Full_mas)-1,28]:= trim(form1.ZReadOnlyQuery2.FieldByName('trip_flag').asString);  //состояние рейса
            full_mas[length(Full_mas)-1,29]:= '0';  //дообилечивания количество ведомостей
            If trim(form1.ZReadOnlyQuery2.FieldByName('tdate').AsString)<>'' then
               begin
            full_mas[length(Full_mas)-1,30]:= formatDatetime('dd-mm-yyyy',form1.ZReadOnlyQuery2.FieldByName('tdate').asDateTime);  //дата операции
            full_mas[length(Full_mas)-1,31]:= formatDatetime('hh:nn:ss',form1.ZReadOnlyQuery2.FieldByName('tdate').asDateTime);  //время операции
               end;
            full_mas[length(Full_mas)-1,32]:= trim(form1.ZReadOnlyQuery2.FieldByName('name').asString); //пользователь совершивший операцию
            full_mas[length(Full_mas)-1,33]:= trim(form1.ZReadOnlyQuery2.FieldByName('remark').asString);  //описание операции
            full_mas[length(Full_mas)-1,34]:= form1.ZReadOnlyQuery2.FieldByName('free_seats').asString;  //[n,34] - kol_swob //кол-во свободных мест
            full_mas[length(Full_mas)-1,35]:= trim(form1.ZReadOnlyQuery2.FieldByName('putevka').asString); //[n,35] putevka
            full_mas[length(Full_mas)-1,36]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver1').asString);  //[n,36] driver1
            full_mas[length(Full_mas)-1,37]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver2').asString);  //[n,37] driver2').asString);
            full_mas[length(Full_mas)-1,38]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver3').asString);  //[n,38] driver3').asString);
            full_mas[length(Full_mas)-1,39]:= trim(form1.ZReadOnlyQuery2.FieldByName('driver4').asString);  //[n,39] driver4').asString);
            full_mas[length(Full_mas)-1,40]:= form1.ZReadOnlyQuery2.FieldByName('dateactive').asString;// [n,40] - dateactive //дата начала работы расписания
            full_mas[length(Full_mas)-1,41]:= form1.ZReadOnlyQuery2.FieldByName('dog_flag').asString;// [n,41] - dog_flag //флаг наличия договора
            full_mas[length(Full_mas)-1,42]:= form1.ZReadOnlyQuery2.FieldByName('lic_flag').asString;// [n,42] - lic_flag //флаг наличия лицензии
            full_mas[length(Full_mas)-1,43]:= form1.ZReadOnlyQuery2.FieldByName('kontr_flag').asString;// [n,43] - kontr_flag //флаг наличия перевозчика
            full_mas[length(Full_mas)-1,44]:= form1.ZReadOnlyQuery2.FieldByName('ats_flag').asString;// [n,44] - ats_flag //флаг наличия автобуса
            full_mas[length(Full_mas)-1,45]:= form1.ZReadOnlyQuery2.FieldByName('server_id').asString;//сервер продажи удаленного сервера
            full_mas[length(Full_mas)-1,46]:='0';
            If form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asInteger>0 then
            full_mas[length(Full_mas)-1,46]:= form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString;//порядок пункта сервера в расписании
       //showmessagealt(trim(form1.ZReadOnlyQuery2.FieldByName('order_otkuda').asString));
           end;
            //----- Подсчет кол-ва активных отправлений или прибытий
            If full_mas[length(Full_mas)-1,22]<>'0' then
               begin
                   if full_mas[length(Full_mas)-1,16]='2' then
                      begin
                      kol_prib:=kol_prib+1;
                      end;
                   if full_mas[length(Full_mas)-1,16]='1' then
                      begin
                      kol_otpr:=kol_otpr+1;
                      end;
               end
            else
              begin
                //если рейс неактивен по причине договора, лицензии, атп или атс
                  If (full_mas[length(Full_mas)-1,17]='1') and (full_mas[length(Full_mas)-1,26]='1') then
                     kol_unactive:=kol_unactive+1;
                end;
            form1.ZReadOnlyQuery2.Next;
          end;
    end;
  form1.ZReadOnlyQuery2.Close;
  form1.ZConnection2.Disconnect;
   end;

  end;
  end;
  //возвращаем параметры локального сервера
     sale_server:=ConnectINI[14];
     otkuda_name:=server_name;

  // Обновляем Label количества прибытий и отправлений
    form1.Label26.Caption:='/'+inttostr(kol_otpr);
   form1.Label27.Caption:='/'+inttostr(kol_prib);
   form1.Label49.Caption:='';
   form1.Label50.Caption:='';
    If kol_unactive>0 then
    begin
       form1.Label51.Visible:=true;
       form1.Label52.Visible:=true;
       form1.Label52.Caption:=inttostr(kol_unactive);
    end;
     form1.Panel4.Visible:=false;
     active_check:=false; //флаг выполнения обновления
end;


//************************ прописать доп инфу по рейсам ******************************
procedure TFOrm1.setlabels;
begin
If (masindex<0) or (masindex>(length(full_mas)-1)) then masindex:=0;
 If length(full_mas)=0 then exit;
 //находим элемент массива
 //mindex:=-1;
 //mindex := arr_get();
 //If mindex=-1 then exit;
timeout_main_tik :=0; //сбрасываем таймер обновления
with form1 do
begin
IF trim(full_mas[masindex,21])='' then
 label38.Caption:='' //наименование АТС
 else
 label38.Caption:=full_mas[masindex,21]; //наименование АТС

//путевка
 IF trim(full_mas[masindex,35])='' then
 label41.Caption:=''
else
 label41.Caption:=full_mas[masindex,35];

 //водитель
IF trim(full_mas[masindex,36])='' then
 label36.Caption:=''
else
 label36.Caption:=full_mas[masindex,36];
 //водитель
IF trim(full_mas[masindex,37])='' then
 label39.Caption:=''
else
 label39.Caption:=' '+full_mas[masindex,37];
 //водитель
IF trim(full_mas[masindex,38])='' then
 label37.Caption:=''
else
 label37.Caption:=full_mas[masindex,38];
 //водитель
IF trim(full_mas[masindex,39])='' then
 label43.Caption:=''
else
 label43.Caption:=' '+full_mas[masindex,39];

If (filtr=8) and (trim(search_city)<>'') then
  label40.Caption:='рейсы через '+search_city;
If (filtr=9) then
  label40.Caption:='рейсы Агентов';
 end;
end;


procedure TForm1.get_time_index();
var
  tmp1,tmp2:string;
  tnow,tmas,n:integer;
  flup:boolean=false;
begin

  If length(full_mas)=0 then exit;
  //текущее время
  tmp1:=FormatDateTIme('hhnn',now());
   try
    tnow:= strtoint(tmp1);
  except
    on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tmp1+#13+'--c03');
     exit;
    end;
  end;
  If (length(filtr_mas)=0) then
   begin
  masindex:=0;
  //время рейса, на котором стою
  for n:=0 to length(full_mas)-1 do
  begin
    If full_mas[n,16]='1' then
       tmp2:=full_mas[n,10] else tmp2:=full_mas[n,12];
     tmp2:=copy(tmp2,1,2)+copy(tmp2,4,2);
  try
    tmas:= strtoint(tmp2);
  except
  on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tmp2+#13+'--c04');
     continue;
    end;
  end;
  If (tnow+5)>tmas then continue
  else masindex:=n;
  If masindex>-1 then break;
  end;
  end;
  //If filtr>2 then
  // begin
  //   findex:=0;
  ////время рейса, на котором стою
  //for n:=0 to length(filtr_mas)-1 do
  //begin
  //  If filtr_mas[n,16]='1' then
  //     tmp2:=filtr_mas[n,10] else tmp2:=filtr_mas[n,12];
  //   tmp2:=copy(tmp2,1,2)+copy(tmp2,4,2);
  //try
  //  tmas := strtoint(tmp2);
  //except
  //  on exception: EConvertError do continue;
  //end;
  //If (tnow+5)>tmas then continue else findex:=n;
  //If findex>-1 then break;
  //end;
  // end;
  //showmessage('index '+inttostr(masindex));
end;


//*******************************     отрисовка информационных сообщений  ***************************
procedure TForm1.paintmess(Grid:TStringgrid; textinfo:string; vColor:TColor);
var
  nup,ndown,nvisota:integer;
begin
  with Grid do
  begin
   //Canvas.AntialiasingMode:=amOff;
   //Canvas.Font.Quality:=fqDraft;
  nup:=20;
  ndown:=80;
   canvas.Clear;
   Canvas.Font.Color:=vColor;
   canvas.Font.Style:=[fsBold];
   canvas.Brush.Color:=clSilver;
   canvas.FillRect(Left,top+nup,left+width,top+ndown);
   nvisota:=(ndown-nup) div 2+10;
   //If nshirina>nvisota then Canvas.Font.Height:=-nvisota else;
   Canvas.Font.Height:=-nvisota;
   If Grid.Width<(canvas.TextWidth(textinfo)+20) then Canvas.Font.Height:=-trunc(nvisota * 0.75);
   //Canvas.textout(Left+(Width div 2)-(Canvas.TextWidth(textinfo) div 2),top+ndown-nup-Font.Height div 2,s+'|'+inttostr(nvisota)); //
   Canvas.textout(Left+15,top+nup+10,textinfo); //
   //sleep(50);
   Application.ProcessMessages;//перерисовка объектов
  end;
 end;


//*****************************//стать на прежнее время рейса или рядом с ним   ******************************
function TForm1.stand_trip():integer;
var
  j :integer=0;
  searchtime,searchshed,triptime,tripshed : integer;
begin
  Result := -1;
  If filtr=0 then exit;
  //если рейс не определен, то становимся на ближайший по времени рейс
  If trim(cur_time)='' then cur_time:=timetostr(time());
  If trim(cur_shedule)='' then cur_shedule:='0';
   //showmessage(cur_time);
  try
  //searchtime := strtoint(utf8copy(cur_time,1,2)+utf8copy(cur_time,4,2));
  searchtime := strtoint(copy(cur_time,1,2)+copy(cur_time,4,2));
  except
    on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+cur_time+#13+'--c05');
     exit;
    end;
  end;
  try
  searchshed := strtoint(cur_shedule);
  except
    on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+cur_shedule+#13+'--c06');
     exit;
    end;
  end;

  with Form1.Stringgrid1 do
  begin
  //ищем точное соответствие
  for j:=1 to Rowcount-1 do
    begin
       try
        //triptime := strtoint(utf8copy(trim(Cells[2,j]),1,2)+utf8copy(trim(Cells[2,j]),4,2));
        triptime := strtoint(copy(trim(Cells[2,j]),1,2)+copy(trim(Cells[2,j]),4,2));
       except
         on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+Cells[2,j]+#13+'--c07');
     break;
    end;

       end;
       try
        tripshed := strtoint(Cells[1,j]);
       except
         on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+Cells[1,j]+#13+'--c08');
     break;
    end;
       end;
       If (searchtime=triptime) AND (searchshed=tripshed) then
          begin
            Result := j;
            break;
          end;
    end;
  //если не нашли ищем приблизельное соответствие
  If Result=-1 then
     begin
  for j:=1 to Rowcount-1 do
    begin
       try
        //triptime := strtoint(utf8copy(trim(Cells[2,j]),1,2)+utf8copy(trim(Cells[2,j]),4,2));
        triptime := strtoint(copy(trim(Cells[2,j]),1,2)+copy(trim(Cells[2,j]),4,2));
       except
         on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+Cells[2,j]+#13+'--c09');
     break;
    end;

       end;
       If (searchtime<triptime) AND ((searchtime+10)>triptime) then
          begin
            Result := j;
            break;
          end;
    end;
  end;
  end;
   //showmessage(inttostr(result));
end;



//******************************************** ОБНОВИТЬ ЭКРАН ДИСПЕТЧЕРА *******************************
//mode=0 - запрос измененных данных без установки на рейс по текущему времен
//mode=1 - запрос измененных данных и стать на рейс по текущему времен
//mode=2 - запрос всех данных и стать на рейс по текущему времени
procedure TForm1.Disp_refresh(mode:byte; clear:byte);
var
  nf:byte;
  n:integer;
begin
  //form1.Label44.caption:=inttostr(masindex)+'|'+inttostr(length(full_mas));//$
  //обновление только для локального сервера
    //возвращаем параметры локального сервера
  sale_server:=ConnectINI[14];
  otkuda_name:=server_name;
   ti1:=time;
  //nf:=0;
   paintmess(form1.StringGrid1,'ОБНОВЛЕНИЕ ДАННЫХ ...',clBlue);
  //заполенение массива рейсов
  //showmessage(inttostr(masindex));
  //if filtr<>1 then nf:=1;//$

  //производить принудительный расчет рейсов или нет
  //If mode=2 then
     //form1.Rascet_mas(1)
  //else form1.Rascet_mas(0);
  //If form1.ZConnection2.Connected then form1.ZConnection2.Disconnect;
  //paintmess(form1.StringGrid1,'ОБНОВЛЕНИЕ ДАННЫХ ...',clBlue);

  //If filtr=1 then nf:=nf+1;//$

 //расчет рейсов
 If filtr<>9 then
 begin
 If not form1.Get_current_day() then
    begin
    If (filtr<8) or (work_date<>date()) then form1.Shedule_Calc(clear);
    end;
 end
 else
 begin
    form1.Get_agents();
 end;

 If (length(full_mas)>0) and (length(full_mas)<=masindex) then
    masindex:=high(full_mas);
 //showmessagealt(formatdatetime('ss.zzz',time-ti1));
 //ti1:=time;
  //если все рейсы то очищаем фильтр-массив
  If clear>0 then
  Setlength(filtr_mas,0);

  //производить поиск рейса по текущему времени
  If (mode>0) then
     begin
      //если все рейсы то очищаем фильтр-массив
       //Setlength(filtr_mas,0);
       //filtr_mas:=nil;
     //если день совпадает с настоящим и не создавался заказной, то ищем рейс по времени
      If (work_date=date()) and (zakaz_shed='') then get_time_index;
     end;

   //стать на созданный заказной рейс
      If (zakaz_shed<>'') then
        begin
        for n:=0 to length(full_mas)-1 do
          begin
            If full_mas[n,1]<>zakaz_shed then continue;

            If ((full_mas[n,16]='1') and (full_mas[n,10]=zakaz_time))
            or ((full_mas[n,16]='2') and (full_mas[n,12]=zakaz_time))
            then
             begin
               masindex:=n;
               break;
             end;
          end;
          zakaz_shed:='';
        end;

   //расчет свободных мест
  //If mode=2 then getfreeseats(-1) else //$
  // getfreeseats(masindex);

  //Alarm_get;//загрузить информацию и предупреждения
 //Отрисовка грида рейсов
 form1.get_list_shedule;
 //form1.Label44.caption:=inttostr(masindex)+'/'+inttostr(length(full_mas));//$
 //showmessagealt(formatdatetime('ss.zzz',time-ti1));
end;



procedure TForm1.Alarm_get;//загрузить информацию и предупреждения
var
  nf:byte;
  n,ntime,shed_time,napr:integer;
  tmp:string;
  d1:TDateTime;
begin
   //обновить лейбы статистики
  kol_otpr:=0;
  kol_prib:=0;
  kol_prib_remaining:=0;
  kol_otpr_remaining:=0;
  kol_unactive:=0;
  //очищаем массив, только если рабочая дата - сегодняшняя
  If work_date=date then
     begin
     setlength(alarm_mas,0);
     try
     ntime:=strtoint(FormatDateTime('hhnn',time));
     except
     on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+FormatDateTime('hhnn',time)+#13+'--c10');
     exit;
    end;
    end;
     end;
  d1:=date;
  tmp:='';
  for n:=low(full_mas) to high(full_mas) do
    begin
        //----- Подсчет кол-ва активных отправлений или прибытий
       If full_mas[n,22]<>'0' then
        begin
          if full_mas[n,16]='2' then
           begin
            //кол-во активный прибытий всего
            kol_prib:=kol_prib+1;
            If (full_mas[n,28]='0') or (full_mas[n,28]='1') or (full_mas[n,28]='3') then
             kol_prib_remaining:=kol_prib_remaining+1;
           end;
          if full_mas[n,16]='1' then
           begin
            //кол-во активных
            kol_otpr:=kol_otpr+1;
            //кол-во оставшихся активных отправлений
            If (full_mas[n,28]='0') or (full_mas[n,28]='1') or (full_mas[n,28]='3') then
             kol_otpr_remaining:=kol_otpr_remaining+1;
          end;
          end
            else
              begin
                //если рейс неактивен по причине договора, лицензии, атп или атс
                  If (full_mas[n,17]='1') and (full_mas[n,26]='1') then
                   begin
                     kol_unactive:=kol_unactive+1;
                     tmp:=tmp+full_mas[n,1]+'1'+' на '+full_mas[n,10]+' ; ';
                   end;
                end;
     //сообщения актуальны только для сегодняшнего дня
      If work_date<>d1 then continue;
      If not((full_mas[n,28]='0') or (full_mas[n,28]='1') or (full_mas[n,28]='3')) then continue;
      try
       napr:=strtoint(full_mas[n,16]);
       If napr=1 then
       begin
       shed_time:=strtoint(copy(full_mas[n,10],1,2)+copy(full_mas[n,10],4,2));
        end
       else shed_time:=strtoint(copy(full_mas[n,12],1,2)+copy(full_mas[n,12],4,2));
      except
        on exception: EConvertError do
      begin
       showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+full_mas[n,10]+'| '+full_mas[n,12]+#13+'--c11');
        continue;
        end;
      end;
      If (napr=1) and (ntime-shed_time<0) and (length(alarm_mas)<20) then
       begin
         setlength(alarm_mas,length(alarm_mas)+1);
         alarm_mas[length(alarm_mas)-1]:='НЕ ОТПРАВЛЕН РЕЙС № '+full_mas[n,1]+' на '+full_mas[n,8]+'!!!';
       end;
    end;
  // Обновляем Label количества прибытий и отправлений
   form1.Label26.Caption:='/'+inttostr(kol_otpr);
   form1.Label27.Caption:='/'+inttostr(kol_prib);
   form1.Label49.Caption:=inttostr(kol_otpr_remaining);
   form1.Label50.Caption:=inttostr(kol_prib_remaining);
   If kol_unactive>0 then
    begin
       form1.Label51.Visible:=true;
       form1.Label52.Visible:=true;
       form1.Label52.Caption:=inttostr(kol_unactive);
       setlength(alarm_mas,length(alarm_mas)+1);
       alarm_mas[length(alarm_mas)-1]:='ВНИМАНИЕ !!! НЕАКТИВНЫЕ РЕЙСЫ №: '+tmp;
    end;

   tmp:='';
   for n:=0 to length(alarm_mas)-1 do
     begin
       tmp:=tmp+alarm_mas[n]+#13;
     end;
   //showmessagealt(tmp);
   form1.pBox.Invalidate;
end;


//************************************* СБРОС ВСЕХ ЛЕЙБОВ ******************************************
procedure TForm1.Clear_labels();
begin
  with form1 do
  begin
  Label40.Caption:='';
          case filtr of
            0: Label40.Caption:='РЕЗУЛЬТАТ ПОИСКА';
            1: Label40.Caption:='ВСЕ НА '+FormatDateTime('dd-mm-yyyy',work_date)+'г.';
            2: Label40.Caption:='РЕЙСЫ РАСПИСАНИЯ';
            3: Label40.Caption:='ОТПРАВЛЕНИЯ АКТИВНЫЕ';
            4: Label40.Caption:='ПРИБЫТИЯ АКТИВНЫЕ';
            5: Label40.Caption:='РЕЙСЫ НЕАКТИВНЫЕ';
            6: Label40.Caption:='РЕЙСЫ ЗАКАЗНЫЕ';
            7: Label40.Caption:='РЕЙСЫ УДАЛЕННОЙ ПРОДАЖИ';
            8: Label40.Caption:='ПОИСК РЕЙСА';
           end;

  If (filtr=1) AND (work_date=date()) then Label40.Caption:='ВСЕ НА СЕГОДНЯ';
  If length(filtr_mas)>0 then Label40.Caption:='РЕЗУЛЬТАТ ПОИСКА';
  Label3.Caption := FormatDateTime('dd-mm-yyyy',work_date);  //рабочая дата
  label38.Caption:=''; //наименование автобуса
  label41.Caption:=''; //путевка
  label36.Caption:=''; //водитель1
  label37.Caption:=''; //водитель3
  label39.Caption:=''; //водитель2
  label43.Caption:=''; //водитель4

  end;
end;


//************************************ ОБРАБОТЧИК ИСКЛЮЧЕНИЙ  **************************************
procedure TForm1.MyExceptionHandler(Sender : TObject; E : Exception);
begin
  showmessage('Ошибка программы 1'+#13+'Сообщение: '+E.Message+#13+'Модуль: '+E.UnitName);
  E.Free;
end;


//Вычисляем номер ведомости
function TForm1.Get_num_vedom(nx:integer):string;
begin
  date_trip:=FormatDateTime('dd-mm-yyyy',work_date);
  //если рейс удаленки
  If (full_mas[nx,0]<>'0') and (full_mas[nx,0]<>'1') and (full_mas[nx,0]<>'2') and (full_mas[nx,0]<>'') then
    date_trip:=full_mas[nx,11];

  try
    strtodate(date_trip,mySettings)
except
   on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+date_trip+#13+'--c12');
     date_trip:=FormatDateTime('dd-mm-yyyy', now());
  end;
    end;
  //номер ведомости: ггггммдд + ччмм + ot_order + do_order + id_shedule + - + id_point_oper
  Result:=Formatdatetime('yyyymmdd', strtodate(date_trip,mySettings))+copy(full_mas[nx,10],1,2)+copy(full_mas[nx,10],4,2)+
          PadL(full_mas[nx,4],'0',2) +PadL(full_mas[nx,7],'0',2)+full_mas[nx,1]+'-'+sale_server;
end;


//**************************************** //Закрытие ведомости для данного рейса  **********************************
function TForm1.Vedom_Close(ZCon:TZConnection; ZQ1:TZReadOnlyQuery; nx:integer):boolean;
begin
  result:=false;
  date_trip:=FormatDateTime('dd-mm-yyyy',work_date);
  //если рейс удаленки
  If (full_mas[nx,0]='3') or (full_mas[nx,0]='4') or (full_mas[nx,0]='5') then
    date_trip:=full_mas[nx,11];
  //если закрытие ведомости - ищем ведомость в базе и помечаем на удаление
  //If mode=12 then
     //begin
     // ZQ1.SQL.Clear;
     // ZQ1.SQL.Add('SELECT vedom FROM av_disp_vedom ');
     // ZQ1.SQL.Add('WHERE del=0 AND date_trip='+Quotedstr(datetostr(work_date))+' AND t_o='+QuotedStr(full_mas[nx,10])+' AND id_shedule='+full_mas[nx,1]);
     // ZQ1.SQL.Add(' AND ot_order='+full_mas[nx,4]+' AND do_order='+full_mas[nx,7]+' AND ot_id_point='+full_mas[nx,3]+' AND do_id_point='+full_mas[nx,6]+';');
     // //showmessage(ZQ1.SQL.text);
     // ZQ1.Open;
     // If ZQ1.RecordCount>0 then
     //    begin
   ZQ1.SQL.Clear;
   ZQ1.SQL.Add('UPDATE av_disp_vedom SET createdate=now(), del=1 ');
   ZQ1.SQL.Add('WHERE del=0 AND date_trip='+Quotedstr(date_trip)+' AND t_o='+QuotedStr(full_mas[nx,10])+' AND id_shedule='+full_mas[nx,1]); //AND doobil='+full_mas[nx,29]+'
   ZQ1.SQL.Add(' AND ot_order='+full_mas[nx,4]+' AND do_order='+full_mas[nx,7]+' AND ot_id_point='+full_mas[nx,3]+' AND do_id_point='+full_mas[nx,6]+';');
   //showmessage(ZQ1.SQL.text); //$
   try
   ZQ1.ExecSQL;
   except
     exit;
   end;
  //end;
   //end
   result:=true;
end;


//--------------------------------------------------------------------------------------------
//------------------------------------ ПОСАДОЧНАЯ ВЕДОМОСТЬ ---------------------------------------
//--------------------------------------------------------------------------------------------
procedure TForm1.Vedom_get(ind:integer;mode:byte);
          //mode=0 - сразу печать
          //mode=1 - выбор ведомостей на печать
var
  n:integer;
  ats_reg,drvtemp:string;
  remote_flag:boolean;
begin
   If ind<0 then
   begin
    showmessage('НЕ ОПРЕДЕЛЕН РЕЙС для вывода посадочной ведомости !');
    exit;
   end;
   If trim(full_mas[ind,16])='2' then
   begin
     showmessage('На рейс ПРИБЫТИЯ печать ведомости невозможна !');
     exit;
   end;

   date_trip:=FormatDateTime('dd-mm-yyyy',work_date);
   remote_flag:=false;
  //если рейс удаленки
  If (full_mas[ind,0]='3') or (full_mas[ind,0]='4') or (full_mas[ind,0]='5') or (full_mas[ind,0]='6') then
  begin
   remote_flag:=true;
   date_trip:=full_mas[ind,11];
  end;

  Setlength(vedom_mas,0,0);


   with Form1 do
   begin
   //Ведомость наша не АГентов
    If filtr<>9 then
  begin
   // Подключаемся к Локальному серверу
   If not(Connect2(form1.Zconnection1, 1)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m04-');
      exit;
     end;
   //showmessage(inttostr(ind)+#13+sale_server);//$
  ZReadOnlyQuery1.SQL.Clear;
  ZReadOnlyQuery1.SQL.Add('SELECT a.vedom,a.date_trip,a.t_o,a.id_shedule,a.ot_order,a.do_order,a.ot_id_point,');
  ZReadOnlyQuery1.SQL.Add('a.do_id_point, a.vedomtype, a.id_point_oper, a.id_user, a.createdate,');
  ZReadOnlyQuery1.SQL.Add('a.t_o_fact, a.doobil, a.ot_name, a.do_name, a.platform, a.putevka, a.driver1,');
  ZReadOnlyQuery1.SQL.Add('a.driver2, a.driver3, a.driver4, a.kontr_id, a.kontr_name, a.ats_id, a.ats_reg,');
  ZReadOnlyQuery1.SQL.Add('a.ats_name, a.ats_seats, a.ats_type ');
  ZReadOnlyQuery1.SQL.Add(',coalesce((SELECT b.name from av_users b WHERE b.del=0 AND b.id=a.id_user ORDER BY b.createdate DESC LIMIT 1 OFFSET 0),''нет'') as name ');
  ZReadOnlyQuery1.SQL.Add('FROM av_disp_vedom a ');
  ZReadOnlyQuery1.SQL.Add(' WHERE a.del=0 AND a.date_trip='+Quotedstr(date_trip)+' AND a.id_shedule='+full_mas[ind,1]);  //+' AND a.id_point_oper='+save_server);
  ZReadOnlyQuery1.SQL.Add(' AND a.t_o='+QuotedStr(full_mas[ind,10])+' AND a.ot_id_point='+full_mas[ind,3]+' AND a.ot_order='+full_mas[ind,4]);
  ZReadOnlyQuery1.SQL.Add(' AND a.do_id_point='+full_mas[ind,6]+' AND a.do_order='+full_mas[ind,7]+' order by a.createdate DESC;');
  //showmessage(ZReadOnlyQuery1.SQL.text);//$
   try
     ZReadOnlyQuery1.open;
   except
     showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
     ZReadOnlyQuery1.Close;
     Zconnection1.disconnect;
     exit;
   end;

  //если уже есть ведомости для этого рейса
  If ZReadOnlyQuery1.RecordCount>0 then
    begin
     //заполняем массив ведомостей
      Setlength(vedom_mas,ZReadOnlyQuery1.RecordCount,vedom_size);
       //vedomtype=1 основная
       //vedomtype=2 дообилечивания
       //vedomtype=3 основная заказная
       //vedomtype=4 дообилечивания заказная
     //showmessage(inttostr(length(vedom_mas)));
     for n:=0 to length(vedom_mas)-1 do
     begin
         Case ZReadOnlyQuery1.FieldByName('vedomtype').AsInteger of
         1: vedom_mas[n,0] :='основная';
         2: vedom_mas[n,0] :='дообилечивания';
         3: vedom_mas[n,0] :='заказная основная';
         4: vedom_mas[n,0] :='заказная дообилечивания';
         5: vedom_mas[n,0] :='удаленной продажи основная';
         6: vedom_mas[n,0] :='удаленной продажи заказная';
         end;
        vedom_mas[n,1] := ZReadOnlyQuery1.FieldByName('id_shedule').AsString;    // [n,1]  - id_shedule
        vedom_mas[n,2] := FormatDateTime('dd/mm/yyyy',ZReadOnlyQuery1.FieldByName('date_trip').AsDatetime);    // [n,2]  - date_trip
        vedom_mas[n,3] := ZReadOnlyQuery1.FieldByName('ot_id_point').AsString;    // [n,3]  - ot_id_point
        vedom_mas[n,4] := ZReadOnlyQuery1.FieldByName('ot_order').AsString;    // [n,4]  - ot_order
        vedom_mas[n,5] := ZReadOnlyQuery1.FieldByName('ot_name').AsString;    // [n,5]  - ot_name
        vedom_mas[n,6] := ZReadOnlyQuery1.FieldByName('do_id_point').AsString;    // [n,6]  - do_id_point
        vedom_mas[n,7] := ZReadOnlyQuery1.FieldByName('do_order').AsString;    // [n,7]  - do_order
        vedom_mas[n,8] := ZReadOnlyQuery1.FieldByName('do_name').AsString;    // [n,8]  - do_name
        vedom_mas[n,9] := ZReadOnlyQuery1.FieldByName('vedom').AsString;    // [n,9]  - vedom
        vedom_mas[n,10] := ZReadOnlyQuery1.FieldByName('t_o').AsString;    // [n,10] - t_o
        vedom_mas[n,11] := FormatDateTime('hh:nn:ss',ZReadOnlyQuery1.FieldByName('createdate').AsDateTime);     // [n,11] - t_o_fact
        vedom_mas[n,12] := FormatDateTime('dd-mm-yyyy',ZReadOnlyQuery1.FieldByName('createdate').AsDateTime);    // [n,12] - createdate
        vedom_mas[n,13] := ZReadOnlyQuery1.FieldByName('putevka').AsString;    // [n,13] - putevka
        //showmessage(Stringreplace(ZReadOnlyQuery1.FieldByName('driver1').AsString,'|','.',[rfReplaceAll, rfIgnoreCase])+#13+
        //ZReadOnlyQuery1.FieldByName('driver1').AsString);//$
        vedom_mas[n,14] := Stringreplace(ZReadOnlyQuery1.FieldByName('driver1').AsString,'|','.',[rfReplaceAll, rfIgnoreCase]); //[n,14] - driver1
        vedom_mas[n,15] := Stringreplace(ZReadOnlyQuery1.FieldByName('driver2').AsString,'|','.',[rfReplaceAll, rfIgnoreCase]); //[n,15] - driver2
 //Документ 1 \ ВОДИТЕЛЬ 3
 drvtemp:=ZReadOnlyQuery1.FieldByName('driver3').AsString;
  If drvtemp<>'' then
begin
 If utf8pos('|',drvtemp)>0 then
 begin
   //документ 1
   vedom_mas[n,16]:=utf8copy(drvtemp,1,utf8pos('|',drvtemp)-1);
   //Если есть водитель 3
 If utf8pos('@',drvtemp)>0 then
 begin
    If utf8pos('&',drvtemp)>0 then
    begin
     //водитель 3 имя
      vedom_mas[n,16]:=vedom_mas[n,16]+Stringreplace(utf8copy(drvtemp,utf8pos('@',drvtemp),utf8pos('&',drvtemp)-utf8pos('@',drvtemp)),'|','.',[rfReplaceAll, rfIgnoreCase]);
      drvtemp:=utf8copy(drvtemp,utf8pos('&',drvtemp)+1,utf8length(drvtemp)-utf8pos('&',drvtemp));
    //водитель 3 док
      vedom_mas[n,16]:=vedom_mas[n,16]+#32+utf8copy(drvtemp,1,utf8pos('|',drvtemp)-1);
    end
    else
    begin
      //водитель 3 имя
     vedom_mas[n,16]:=vedom_mas[n,16]+Stringreplace(utf8copy(drvtemp,1,utf8length(drvtemp)),'|','.',[rfReplaceAll, rfIgnoreCase]);
    end;
 end;
 end
 else
   vedom_mas[n,16] := drvtemp;   // [n,16] - driver3
end;

  //ДОКУМЕНТ 2 \ ВОДИТЕЛЬ 4
  drvtemp:=ZReadOnlyQuery1.FieldByName('driver4').AsString;
    If drvtemp<>'' then
begin
 If utf8pos('|',drvtemp)>0 then
 begin
   vedom_mas[n,17]:=utf8copy(drvtemp,1,utf8pos('|',drvtemp)-1);
 end
 else
   vedom_mas[n,17] := drvtemp;   // [n,17] - driver4
end;

        vedom_mas[n,18] := ZReadOnlyQuery1.FieldByName('kontr_id').AsString;    // [n,18] - kontr_id
        vedom_mas[n,19] := trim(ZReadOnlyQuery1.FieldByName('kontr_name').AsString);    // [n,19] - kontr_name
        vedom_mas[n,20] := ZReadOnlyQuery1.FieldByName('ats_id').AsString;    // [n,20] - ats_id
        vedom_mas[n,21] := trim(ZReadOnlyQuery1.FieldByName('ats_name').AsString);    // [n,21] - ats_name
        vedom_mas[n,22] := ZReadOnlyQuery1.FieldByName('ats_seats').AsString;    // [n,22] - ats_seats
        vedom_mas[n,23] := ZReadOnlyQuery1.FieldByName('ats_reg').AsString;    // [n,23] - ats_reg
        vedom_mas[n,24] := ZReadOnlyQuery1.FieldByName('ats_type').AsString;    // [n,27] - ats_type
        vedom_mas[n,25] := ZReadOnlyQuery1.FieldByName('doobil').AsString;    // [n,29] - doobil
        vedom_mas[n,26] := ZReadOnlyQuery1.FieldByName('id_user').AsString;    // [n,31] - id_user   //
        vedom_mas[n,27] := ZReadOnlyQuery1.FieldByName('name').AsString;    // [n,32] - name   //пользователь совершивший операцию
        If (ZReadOnlyQuery1.FieldByName('vedomtype').AsInteger=1) or (ZReadOnlyQuery1.FieldByName('vedomtype').AsInteger=2) then
        vedom_mas[n,42] := '0'
        else vedom_mas[n,42] := '1';         // заказной
       //If isfio then           //тип данных по водителям: с документами или без
        //vedom_mas[n,43] := '1'
        //else
         //vedom_mas[n,43]:= '0';
        ZReadOnlyQuery1.Next;
     end;
    end;
    ZReadOnlyQuery1.Close;
  Zconnection1.disconnect;
  end;

  //добавляем динамическу ведомость в массив ведомостей
   //+общая ведомость,+список пассажиров
       SetLength(Vedom_mas,length(vedom_mas)+1,vedom_size);
       If filtr=9 then
       begin
         vedom_mas[length(vedom_mas)-1,0] := 'АГЕНТСКАЯ';
        end
       else
       begin
       If remote_flag then
        vedom_mas[length(vedom_mas)-1,0] := 'ОБЩАЯ удаленной продажи'
        else
         vedom_mas[length(vedom_mas)-1,0] := 'ОБЩАЯ';
      end;
        vedom_mas[length(vedom_mas)-1,1] := full_mas[ind,1];    // [n,1]  - id_shedule
        try
        vedom_mas[length(vedom_mas)-1,2] := FormatDateTime('dd/mm/yyyy',strtodate(date_trip,mySettings));//дата рейса
        except
        on exception: EConvertError do
        begin
        showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+date_trip+#13+'--c13');
        vedom_mas[length(vedom_mas)-1,2] := FormatDateTime('dd/mm/yyyy',now());//дата рейса
        end;
        end;
        vedom_mas[length(vedom_mas)-1,3] := full_mas[ind,3];    // [n,3]  - ot_id_point
        vedom_mas[length(vedom_mas)-1,4] := full_mas[ind,4];  // [n,4]  - ot_order
        vedom_mas[length(vedom_mas)-1,5] := full_mas[ind,5];   // [n,5]  - ot_name
        vedom_mas[length(vedom_mas)-1,6] := full_mas[ind,6];   // [n,6]  - do_id_point
        vedom_mas[length(vedom_mas)-1,7] := full_mas[ind,7];   // [n,7]  - do_order
        vedom_mas[length(vedom_mas)-1,8] := full_mas[ind,8];   // [n,8]  - do_name

        //номер общей ведомости для удаленки
       If remote_flag then
        //номер ведомости: ггггммдд + ччмм + ot_order + do_order + id_shedule + - + id_point_oper
       vedom_mas[length(vedom_mas)-1,9]:= copy(date_trip,7,2)+copy(date_trip,4,2)+copy(date_trip,1,2)+copy(full_mas[ind,10],1,2)
       +copy(full_mas[ind,10],4,2)+PadL(full_mas[ind,4],'0',2) +PadL(full_mas[ind,7],'0',2)+full_mas[ind,1]+'-'+full_mas[ind,45]
       else
        vedom_mas[length(vedom_mas)-1,9]:= '';  // [n,9]  - vedom
        vedom_mas[length(vedom_mas)-1,10] := full_mas[ind,10];   // [n,10] - t_o
        vedom_mas[length(vedom_mas)-1,11] := ''; //FormatDateTime('hh:nn:ss', now());  //& 20180508
        vedom_mas[length(vedom_mas)-1,12] := ''; //FormatDateTime('dd-mm-yyyy',now()); //& 20180508
        vedom_mas[length(vedom_mas)-1,13] := full_mas[ind,35];  // [n,13] - putevka
        vedom_mas[length(vedom_mas)-1,14] := Stringreplace(full_mas[ind,36],'|','.',[rfReplaceAll, rfIgnoreCase]);  // [n,14] - driver1
        vedom_mas[length(vedom_mas)-1,15] := Stringreplace(full_mas[ind,37],'|','.',[rfReplaceAll, rfIgnoreCase]);   // [n,15] - driver2
 //ВОДИТЕЛЬ 3
 drvtemp:=full_mas[ind,38];
  If full_mas[ind,38]<>'' then
begin
 If utf8pos('|',full_mas[ind,38])>0 then
 begin
   vedom_mas[length(vedom_mas)-1,16]:=utf8copy(full_mas[ind,38],1,utf8pos('|',full_mas[ind,38])-1);
 If utf8pos('@',full_mas[ind,38])>0 then
 begin
  If utf8pos('&',drvtemp)>0 then
    begin
   //водитель 3 имя
      vedom_mas[length(vedom_mas)-1,16]:=vedom_mas[length(vedom_mas)-1,16]+Stringreplace(utf8copy(drvtemp,utf8pos('@',drvtemp),utf8pos('&',drvtemp)-utf8pos('@',drvtemp)),'|','.',[rfReplaceAll, rfIgnoreCase]);
      drvtemp:=utf8copy(drvtemp,utf8pos('&',drvtemp)+1,utf8length(drvtemp)-utf8pos('&',drvtemp));
    //водитель 3 док
      vedom_mas[length(vedom_mas)-1,16]:=vedom_mas[length(vedom_mas)-1,16]+#32+utf8copy(drvtemp,1,utf8pos('|',drvtemp)-1);
  end
    else
    begin
      //водитель 3 имя
     vedom_mas[length(vedom_mas)-1,16]:=vedom_mas[length(vedom_mas)-1,16]+Stringreplace(utf8copy(drvtemp,1,utf8length(drvtemp)),'|','.',[rfReplaceAll, rfIgnoreCase]);
    end;
    end;
 end
 else
   vedom_mas[length(vedom_mas)-1,16] := full_mas[ind,38];   // [n,16] - driver3
end;
  //ВОДИТЕЛЬ 4
  drvtemp:=full_mas[ind,39];
    If drvtemp<>'' then
begin
 If utf8pos('|',drvtemp)>0 then
 begin
   vedom_mas[length(vedom_mas)-1,17]:=utf8copy(drvtemp,1,utf8pos('|',drvtemp)-1);
 end
 else
   vedom_mas[length(vedom_mas)-1,17] := drvtemp;   // [n,17] - driver4
end;

        vedom_mas[length(vedom_mas)-1,18] := full_mas[ind,18];  // [n,18] - kontr_id
        vedom_mas[length(vedom_mas)-1,19] := full_mas[ind,19];  // [n,19] - kontr_name
        vedom_mas[length(vedom_mas)-1,20] := full_mas[ind,20];   // [n,20] - ats_id
        If utf8pos('ГН:',full_mas[ind,21])>0 then
         vedom_mas[length(vedom_mas)-1,21] := utf8copy(full_mas[ind,21],1,utf8pos('ГН:',full_mas[ind,21])-1)  // [n,21] - ats_name
        else
         vedom_mas[length(vedom_mas)-1,21] := full_mas[ind,21];// [n,21] - ats_name
        vedom_mas[length(vedom_mas)-1,22] := full_mas[ind,25];   // [n,22] - ats_seats
        vedom_mas[length(vedom_mas)-1,23] := '';
        If utf8pos('ГН:',full_mas[ind,21])>0 then
        begin
        ats_reg:= utf8copy(full_mas[ind,21],utf8pos('ГН:',full_mas[ind,21])+3,utf8length(full_mas[ind,21])-utf8pos('ГН:',full_mas[ind,21])-3);
        ats_reg:= stringreplace(ats_reg,#32,'',[rfReplaceAll, rfIgnoreCase]);
        vedom_mas[length(vedom_mas)-1,23] := ats_reg; // [n,23] - ats_reg
        end;
        vedom_mas[length(vedom_mas)-1,24] := full_mas[ind,27];   // [n,27] - ats_type
        vedom_mas[length(vedom_mas)-1,25] := full_mas[ind,29];   // [n,29] - doobil
        vedom_mas[length(vedom_mas)-1,26] := full_mas[ind,32];   // [n,31] - id_user   //
        vedom_mas[length(vedom_mas)-1,27] := full_mas[ind,32];  // [n,32] - name   //пользователь совершивший операцию
 //showmas(vedom_mas);
 //заполнить массив билетов данного рейса
  Fillticket(ind);
 //showmas(tick_mas);
    //Если вызов из окна отправления, то сразу печать
  If  (mode=0) or (filtr=9) then
    begin
    //если удаленка виртуальная, сразу печать списка пассажиров
     If (full_mas[ind,0]='5') or (full_mas[ind,0]='2') then
      begin
          Vedom_print(99, ind);

      end
     else Vedom_print(0, ind); //вывод ведомости
    end;

  If  (mode=1) then
    begin
  //открыть форму списка ведомостей
     Form8:=TForm8.create(self);
     Form8.ShowModal;
     FreeAndNil(Form8);
    end;
   end;
end;


//заполнить массив билетов данного рейса
procedure TForm1.Fillticket(x:integer);
var
  m:integer;
  ttable,t1,ttick:string;
begin
   If x<0 then
   begin
    showmessage('НЕ ОПРЕДЕЛЕН РЕЙС !');
    exit;
   end;
   with Form1 do
   begin
   //showmessage(full_mas[x,45]);
   ttable:='av_ticket';
   date_trip:=FormatDateTime('dd-mm-yyyy',work_date);
      //showmessage(full_mas[x,0]);//$
  //если интернет продажи
  //If (full_mas[x,0]='5') and (full_mas[x,45]<>'0') then //изменения от 06.04.2017
  If (full_mas[x,45]<>'0') and (full_mas[x,45]<>'') then
   begin
    //showmessage(full_mas[x,45]);//$
    sale_server:=full_mas[x,45];
    try
    date_trip:=datetostr(strtodatetime(full_mas[x,11],mySettings));
    except
    on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ ДАТЫ!!!'+#13+'значение: '+full_mas[x,11]+#13+'--c14');
     date_trip := FormatDateTime('dd-mm-yyyy',now());
   end;
    end;
    end;
    //если своя удаленка
  If ((full_mas[x,0]='3') or (full_mas[x,0]='4')) and (full_mas[x,45]='0') then
    begin
     sale_server:=ConnectINI[14]; //изменения от 06.04.2017
     If form1.virt_server() then
         ttable:='av_ticket_local';
      try
    date_trip:=datetostr(strtodatetime(full_mas[x,11],mySettings));
    except
    on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ ДАТЫ!!!'+#13+'значение: '+full_mas[x,11]+#13+'--c15');
     date_trip := FormatDateTime('dd-mm-yyyy',now());
   end;
    end;
    end;

   If form1.ZConnection1.Connected then form1.ZConnection1.Disconnect;
  //showmessage(sale_server);
   // Подключаемся к серверу
   If not(Connect2(form1.Zconnection1, 1)) then
     begin
      //возвращаем параметры локального сервера
     sale_server:=ConnectINI[14];
     otkuda_name:=server_name;
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m05-');
      Close;
      exit;
     end;


   ZReadOnlyQuery1.SQL.Clear;
   //если интернет продажи
 If filtr=9 then
  begin
     ZReadOnlyQuery1.SQL.Add('SELECT fill_vedom_agent('+Quotedstr(ttable)+','+Quotedstr(full_mas[x,1])+','+Quotedstr(date_trip)+','+Quotedstr(full_mas[x,10])+');');
   end
   else
   begin
    //writelog('x,0: '+full_mas[x,0]+#13+'x,45: '+ full_mas[x,45]+#13+'sale_server: '+sale_server+#13+'');//$
   If (full_mas[x,0]='5') and (full_mas[x,45]<>'0') then
    begin
      writelog('x,0: '+full_mas[x,0]+#13+'x,45: '+ full_mas[x,45]+#13+'sale_server: '+sale_server+#13+'');//$
      ZReadOnlyQuery1.SQL.Add('SELECT fill_vedom_inet('+Quotedstr(ttable)+','+full_mas[x,1]+','+Quotedstr(date_trip)+','+full_mas[x,3]+','+full_mas[x,4]+','+full_mas[x,9]+','+Quotedstr(full_mas[x,10])+');')
      end
    else
      ZReadOnlyQuery1.SQL.Add('SELECT fill_vedom('+Quotedstr(ttable)+','+Quotedstr(ttable)+','+full_mas[x,1]+','+Quotedstr(date_trip)+','+Quotedstr(full_mas[x,10])+');');
  end;

  form1.ZReadOnlyQuery1.sql.add('FETCH ALL IN '+ttable+';');

  //showmessage(ZReadOnlyQuery1.SQL.text);//$
   try
     ZReadOnlyQuery1.open;
   except
     showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
     ZReadOnlyQuery1.Close;
     Zconnection1.disconnect;
     exit;
   end;
  Setlength(tick_mas,0,0);
  If ZReadOnlyQuery1.RecordCount>0 then
    begin
     //заполняем массив билетов
    for m:=0 to ZReadOnlyQuery1.RecordCount-1 do
     begin
     ///если нет номер билета, значит билет- пустышка
       If trim(ZReadOnlyQuery1.FieldByName('ticket_num').AsString)='' then continue;
       Setlength(tick_mas,length(tick_mas)+1,tick_size);
       tick_mas[length(tick_mas)-1,0] := ZReadOnlyQuery1.FieldByName('mesto').AsString; //mesto
       tick_mas[length(tick_mas)-1,1] := ZReadOnlyQuery1.FieldByName('ticket_num').AsString; //ticket_num
       tick_mas[length(tick_mas)-1,2] := FormatDateTime('dd-mm-yyyy',ZReadOnlyQuery1.FieldByName('createdate').AsDateTime);    // createdate date
       tick_mas[length(tick_mas)-1,3] := FormatDateTime('hh:nn:ss',ZReadOnlyQuery1.FieldByName('createdate').AsDateTime);    //createdate time
       tick_mas[length(tick_mas)-1,4] := ''; //билеты требуемой ведомости
       tick_mas[length(tick_mas)-1,5] := ZReadOnlyQuery1.FieldByName('type_full_half').AsString; //type_full_half  - Тип Полный Детский
       tick_mas[length(tick_mas)-1,6] := ZReadOnlyQuery1.FieldByName('type_norm_lgot_war').AsString; //type_norm_lgot_war - Тип Обычный Льготный Воинский
       tick_mas[length(tick_mas)-1,7] := ZReadOnlyQuery1.FieldByName('name_kuda').AsString; //name - Пункт назначения
       tick_mas[length(tick_mas)-1,8] := ZReadOnlyQuery1.FieldByName('lgot_sum').AsString; //lgot_sum
       tick_mas[length(tick_mas)-1,9] := ZReadOnlyQuery1.FieldByName('sum_credit').AsString; //sum_credit
       tick_mas[length(tick_mas)-1,10] := ZReadOnlyQuery1.FieldByName('tarif_calculated').AsString; //sum_cash
       tick_mas[length(tick_mas)-1,11] := trim(StringReplace(ZReadOnlyQuery1.FieldByName('fio').AsString,'|',#32,[rfReplaceAll]));
       tick_mas[length(tick_mas)-1,12] := ZReadOnlyQuery1.FieldByName('doctype').AsString;
       tick_mas[length(tick_mas)-1,13] := stringreplace(ZReadOnlyQuery1.FieldByName('doc').AsString,#32,'',[rfReplaceAll, rfIgnoreCase]);
       tick_mas[length(tick_mas)-1,14] := ZReadOnlyQuery1.FieldByName('bags').AsString;
       tick_mas[length(tick_mas)-1,15] := ZReadOnlyQuery1.FieldByName('bags_sum').AsString;
       tick_mas[length(tick_mas)-1,16] := '';//аббревиатура типа билета
       tick_mas[length(tick_mas)-1,17] := ZReadOnlyQuery1.FieldByName('strah_sbor_nal').AsString;
       tick_mas[length(tick_mas)-1,18] := ZReadOnlyQuery1.FieldByName('strah_sbor_credit').AsString;
       tick_mas[length(tick_mas)-1,19] := ZReadOnlyQuery1.FieldByName('kom_sbor').AsString;
       tick_mas[length(tick_mas)-1,20] := ZReadOnlyQuery1.FieldByName('name_otkuda').AsString;
       tick_mas[length(tick_mas)-1,21] := ZReadOnlyQuery1.FieldByName('timein').AsString;
       tick_mas[length(tick_mas)-1,22] := ZReadOnlyQuery1.FieldByName('dayin').AsString;
       tick_mas[length(tick_mas)-1,23] := ZReadOnlyQuery1.FieldByName('tel').AsString;
       tick_mas[length(tick_mas)-1,24] := ZReadOnlyQuery1.FieldByName('id_user').AsString;
       tick_mas[length(tick_mas)-1,25] := ZReadOnlyQuery1.FieldByName('agent').AsString;
       tick_mas[length(tick_mas)-1,26] := ZReadOnlyQuery1.FieldByName('email').AsString;
       tick_mas[length(tick_mas)-1,27] := ZReadOnlyQuery1.FieldByName('citiz').AsString;
       tick_mas[length(tick_mas)-1,28] := ZReadOnlyQuery1.FieldByName('gender').AsString;
       tick_mas[length(tick_mas)-1,29] := FormatDateTime('dd-mm-yyyy',ZReadOnlyQuery1.FieldByName('birthday').AsDateTime);
       //tick_mas[length(tick_mas)-1,21] := '0';//кол-во транзитных мест
        //Тип Полный Детский

       case ZReadOnlyQuery1.FieldByName('type_full_half').AsInteger of
       1: tick_mas[length(tick_mas)-1,16]:= 'П';
       2: tick_mas[length(tick_mas)-1,16]:= 'Д';
       else
         tick_mas[length(tick_mas)-1,16]:='_';
       end;
       case ZReadOnlyQuery1.FieldByName('type_norm_lgot_war').AsInteger of
       2: ttick:= 'Л';   //Если льготный
       3: ttick:= 'В';   //Если воинский
       4: ttick:= 'К';   //Если картой
       5: ttick:='ПА';   //продажа агент
       55: ttick:='ПАБ';   //продажа агент багаж
       6: ttick:='ПИ';   //продажа интернет
       66: ttick:='ПИБ';   //продажа интернет багаж
       else
         ttick:='_';
       end;
       tick_mas[length(tick_mas)-1,16]:=tick_mas[length(tick_mas)-1,16]+ttick;

       ZReadOnlyQuery1.Next;
     end;
     end;


     ZReadOnlyQuery1.Close;
     Zconnection1.disconnect;
     //возвращаем параметры локального сервера
     //sale_server:=ConnectINI[14];
     //otkuda_name:=server_name;
     //showmas(tick_mas);
   end;
  end;



//*********************************************       ПЕЧАТЬ ведомости на экран     ************************************************
//************ The printer language HP PCL  управляющие последовательности
  //EcE #027#069 - сброс на дефолтные настройки
        //************** ПАРАМЕТРЫ СТРАНИЦЫ ********************
        //Ec&l0O #027#038#108#048#079 - портретная ориентация
        //Ec&l1O #027#038#108#049#079 - альбомная ориентация
        //Ec&l#E #027#038#108+'#'+#069 	- отступ сверху (линий)
        //Ec&l#F #027#038#108+'#'+#070 	- Text Length длина текста  (линий)
        //Ec&a#L #027#038#097+'#'+#076 	- отступ слева (символов)
        //Ec&a#M #027#038#097+'#'+#077 	- отступ справа (символов)
        //Ec9    #027#057  - сбросить отступы на строке
        //Ec&l#C - #027#038#108+'n'+#067 - межстрочный интервал (должен быть последней командой)
        //Ec&l26A #027#038#108#050#054#065 - A4
        //Ec&l27A #027#038#108#050#055#065 - A5
        //Ec&l0L #027#038#108#048#076 - отключить пропуск перфорации
        //Ec&l1L #027#038#108#049#076 - пропускать перфорацию

        //line termination
        //CR=CR;LF=LF; FF=FF             Ec&k0G  #027#038#107#048#071
        //CR=CR+LF;LF=LF FF=FF           Ec&k1G  #027#038#107#049#071
        //CR=CR; LF=CR+LF; FF=CR+FF      Ec&k2G  #027#038#107#050#071
        //CR=CR+LF; LF=CR+LF; FF=CR+FF   Ec&k3G  #027#038#107#051#071

        //Ec&l0H #027#038#108#048#072 - конец листа
        //****************** кодировка *******************
        //Ec(3R   PC Cyrillic (UTF8toCP866)
        //Ec(9R   Windows 3.1 Latin/Cyrillic (UTF8toCP1251)
        //************** ПАРАМЕТРЫ ШРИФТА ******************
        //Ec(s#H #027#040#115+'n'+#072 - PITCH символов на дюйм
        //Ec&d0D #027#038#100#048#068 - подчернутый
        //Ec&d@  #027#038#100#064 - отмена подчеркивания
        //Ec&k2S #027#038#107#050#083 - сжатый текст
        //Ec(s0P #027#040#115#048#080 - моноширинный
        //Ec(s1P #027#040#115#049#080 - пропорциональный

        //******** обводка *********
        //Ec(s3B #027#040#115#051#066 - жирная обводка
        //Ec(s0B #027#040#115#048#066 - обычный текст
        //*********** стиль **********************

        //Ec(s0S #027#040#115#048#083 - обычный
        //Ec(s1S #027#040#115#049#083 - курсив
        //Ec(s4S #027#040#115#052#083 - уплотненный Condensed
        //Ec(s5S #027#040#115#053#083 - уплотненный курсив Condensed Italic
        //Ec(s8S #027#040#115#056#083 - Compressed
       //Ec(s24S #027#040#115#050#052#083 -Expanded
       //Ec(s32S #027#040#115#051#050#083 -Outline (обведенный снаружи)
       //Ec(s64S #027#040#115#054#052#083 -Inline (обведенный изнутри)
      //Ec(s128S #027#040#115#049#050#056#083 -Shadowed

// //The printer language ESC/P was originally developed by Epson for use with their early dot-matrix printers.
 //#15 - режим сжатой печати #18 - отключение
 //#77 - размер шрифта 12cpi
 //#80 - размер шрифта 10cpi
 //#48 - междустрочный интервал 1/8 дюйма
 //#49 - междустрочный интервал 7/72 дюйма
 //#50 - междустрочный интервал 1/6 дюйма
 //#51 n - междустрочный интервал n/180 дюйма
 //#12 - выброс листа
 //#27#45#49 - подчеркивание #27#45#48 - отключить
 //#27#69 - жирный #27#70 - отключить
 //#27#79 - отмена пропуска перфорации
 //#27#112#48 - отмена пропорциональной печати Returns to current fixed character pitch
 //#27#112#49 - включение режима пропорциональной печати Selects proportional spacing
 //#27#81 n  - правый отступ
 //#27#108 n - левый отступ

procedure TForm1.Vedom_print(nx:integer; x:integer);
const
  bold=#027#040#115#051#066; //жирный
  norm=#027#040#115#048#066; //нежирный
  under=#027#038#100#048#068;//подчернкутый
  plain=#027#038#100#064;//не подчеркнутый
  maxticksL=46; //маскимальное число напечатанных строчек билетов на листе лазерн
  maxticksM=38; //маскимальное число напечатанных строчек билетов на листе матричн
var
  i,n,m,k,j,bagag_count,wars_count,lgot_count,uslugi_count,tickets_count,cnt,tranzit,creditcard :integer;
  tickets_sum,bagag_sum,strah_sum,wars_sum_cash,wars_sum_credit,lgot_sum_cash,
  lgot_sum_credit,uslugi_sum_cash,uslugi_sum_credit,card_credit: real;
  //stime,sdate:integer;
  flfio,fldoc,fl_next:boolean;
  filetxt:TextFile;
  spass:byte;
  viddoc,vod3,vod4,tmp:string;
  arbron,arbron2:array of array of string;
  timevedom:TDatetime;
begin

   creditcard:=0;

  If nx<0 then
   begin
    showmessage('НЕ ОПРЕДЕЛЕНА посадочная ведомость для вывода !');
    exit;
   end;

  //decimalseparator:='.';
    flfio:=false;
    fldoc:=false;
    spass:=0;

    with form1 do
    begin

    tranzit:=0;
    timevedom:=now();


    If filtr<>9 then
     begin
     // Подключаемся ТОЛЬКО к Локальному серверу
   If not(Connect2(form1.Zconnection1, 2)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m06-');
      Close;
      exit;
     end;

   //--вычисляем оставшуюся бронь на рейсе
   setlength(arbron,0,0);
        ZReadOnlyQuery1.sql.Clear;
        ZReadOnlyQuery1.sql.add('select * from disp_bron(''df'','+quotedstr(date_trip)+','+full_mas[x,1]+','+quotedstr(full_mas[x,10])+','+quotedstr('-3-')+');');
        ZReadOnlyQuery1.sql.add('FETCH ALL IN df;');
        //showmessage(ZReadOnlyQuery1.sql.Text);//$
         try
     ZReadOnlyQuery1.open;
         except
         showmessagealt('ОШИБКА ЗАПРОСА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
         //ZReadOnlyQuery1.Close;
         Zconnection1.disconnect;
         //exit;
         end;
      if ZReadOnlyQuery1.RecordCount>0 then
        begin
         for n:=0 to ZReadOnlyQuery1.RecordCount-1 do
          begin
          setlength(arbron,length(arbron)+1,2);
          arbron[length(arbron)-1,0]:=ZReadOnlyQuery1.FieldByName('rem').asString;
          arbron[length(arbron)-1,1]:=ZReadOnlyQuery1.FieldByName('mesta').asString;
          ZReadOnlyQuery1.Next;
          end;
        end;


     //-//служебка от 07.06.2018 на отображение снятой брони при продаже коротких билетов
    If length(arbron2)>0 then
   begin
   write(filetxt,'ВНИМАНИЕ!!! СНЯТА БРОНЬ с мест: '+#13#10);
      for j:=low(arbron2) to high(arbron2) do
      begin
         write(filetxt,'место № '+arbron2[j,1]+' -- '+arbron2[j,0]+' '+#13#10);
      end;
   end;
   setlength(arbron2,0,0);
        ZReadOnlyQuery1.sql.Clear;
        ZReadOnlyQuery1.sql.add('select * from disp_bron_lost(''bronlost'','+quotedstr(date_trip)+','+full_mas[x,1]+','+quotedstr(full_mas[x,10])+');');
        ZReadOnlyQuery1.sql.add('FETCH ALL IN bronlost;');
        //showmessage(ZReadOnlyQuery1.sql.Text);//$
         try
     ZReadOnlyQuery1.open;
         except
         showmessagealt('ОШИБКА ЗАПРОСА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
         //ZReadOnlyQuery1.Close;
         Zconnection1.disconnect;
         //exit;
         end;
      if ZReadOnlyQuery1.RecordCount>0 then
        begin
         for n:=0 to ZReadOnlyQuery1.RecordCount-1 do
          begin
          setlength(arbron2,length(arbron2)+1,2);
          arbron2[length(arbron2)-1,0]:=ZReadOnlyQuery1.FieldByName('otd').asString;
          arbron2[length(arbron2)-1,1]:=ZReadOnlyQuery1.FieldByName('seat').asString;
          ZReadOnlyQuery1.Next;
          end;
        end;


     //========================= кол-во транзитных мест //
   If trim(full_mas[x,9])='0' then
     begin
        ZReadOnlyQuery1.sql.Clear;
        ZReadOnlyQuery1.sql.add('select * from get_seats_status('+quotedstr(date_trip)+','+sale_server+','+full_mas[x,6]+','+full_mas[x,18]+',');
        ZReadOnlyQuery1.sql.add(full_mas[x,1]+','+quotedstr(full_mas[x,10])+','+full_mas[x,20]+','+full_mas[x,9]);
        ZReadOnlyQuery1.sql.add(','+full_mas[x,46]+','+full_mas[x,7]+',1) as free;');
 //showmessage(ZReadOnlyQuery1.sql.Text);//$
 try
     ZReadOnlyQuery1.open;
 except
     showmessagealt('ОШИБКА ЗАПРОСА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
     //ZReadOnlyQuery1.Close;
     Zconnection1.disconnect;
     //exit;
 end;

 if ZReadOnlyQuery1.RecordCount>0 then
       begin
       m:=1;
       k:=1;
          for n:=1 to utf8Length(ZReadOnlyQuery1.FieldByName('free').asString) do
     begin
      // k - 1 номер места
      // k - 2 статус
      // m - текущее начало вырезки
      if UTF8Copy(ZReadOnlyQuery1.FieldByName('free').asString,n,1)='|' then
         begin
           if k=1 then
              begin
               k:=3;
              end;
           if k=2 then
              begin
               //SetLength(mas_s,Length(mas_s)+1,2);
               //статус места
               If UTF8Copy(ZReadOnlyQuery1.FieldByName('free').asString,m,(n-m))='9' then
                 tranzit:=tranzit+1;
               k:=1;
              end;
           if k=3 then k:=2;
           m:=n+1;
         end;
      end;
      end;
    end;

     //время сервера
     ZReadOnlyQuery1.sql.Clear;
     ZReadOnlyQuery1.sql.add('select now() as tved;');
 //showmessage(ZReadOnlyQuery1.sql.Text);//$
    try
     ZReadOnlyQuery1.open;
    except
     showmessagealt('ОШИБКА ЗАПРОСА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
     //ZReadOnlyQuery1.Close;
     Zconnection1.disconnect;
     //exit;
    end;
    If ZReadOnlyQuery1.RecordCount>0 then
      timevedom:=ZReadOnlyQuery1.FieldByName('tved').AsDateTime;

     ZReadOnlyQuery1.Close;
     Zconnection1.disconnect;
   end;
    end;


    //если выбрана печать СПИСКА ПАССАЖИРОВ
    If nx>=length(vedom_mas) then
     begin
       flfio:=true;
       fldoc:=true;
       spass:=1;
       nx:=length(vedom_mas)-1;
     end;
   //заполнить массив билетов для данной ведомости
  If length(tick_mas)>0 then
    begin
     tickets_count := 0;
     tickets_sum :=0.0;
     bagag_sum:=0.0;
     bagag_count:=0;
     strah_sum :=0.0;
     wars_count :=0;
     wars_sum_cash :=0.0;
     wars_sum_credit :=0.0;
     lgot_count :=0;
     lgot_sum_cash :=0.0;
     lgot_sum_credit :=0.0;
     uslugi_count :=0;
     uslugi_sum_cash :=0.0;
     uslugi_sum_credit :=0.0;
     card_credit:=0.0;

     //showmas(tick_mas);//&-
     //определяем билеты данной ведомости
    for m:=0 to length(tick_mas)-1 do
   begin
        tick_mas[m,4] := ''; //помечаем билет как чек не этой ведомости
       //проверяем принадлежность билетов к ведомостям,
     //только если есть больше одной отбитой ведомости (+одна общая в массиве)
   If length(vedom_mas)>2 then
     begin
         //если есть более поздняя ведомость
       If nx>0 then
         begin
       //Если билет продан после создания этой ведомости
       //преобразовать дату время с vedom_mas
       //sdate:= strtoint(vedom_mas[nx,12]);
       //stime:= strtoint(vedom_mas[nx,11]);
       //showmessage('tdate='+tick_mas[m,2]+' > '+sdate+' | ttime='+tick_mas[m,3]+' > '+stime);

         If (trim(vedom_mas[nx,12])<>'') and (trim(vedom_mas[nx,11])<>'') then
          begin
           //если дата продажи билета после даты создания ведомости то отвал
          try
             If strtodatetime(tick_mas[m,2]+#32+tick_mas[m,3],mySettings)>strtodatetime(vedom_mas[nx,12]+#32+vedom_mas[nx,11],mySettings) then continue;
          except
          on exception: EConvertError do
          begin
          showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tick_mas[m,2]+'| '+tick_mas[m,3]+'| '+tick_mas[nx,11]+'| '+tick_mas[nx,12]+#13+'--c16');
          continue;
          end;
          end;
          end
         else
          begin
           //если дата продажи билета после даты создания ведомости то отвал
          try
             If strtodatetime(tick_mas[m,2]+#32+tick_mas[m,3],mySettings)>timevedom then continue;
          except
          on exception: EConvertError do
          begin
          showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tick_mas[m,2]+'| '+tick_mas[m,3]+#13+'--c17');
          continue;
          end;
          end;
          end;
        //если время продажи билета после времени создания ведомости то отвал
         //If (strtoint(tick_mas[m,2])=(sdate)) AND (strtoint(tick_mas[m,3])>(stime)) then continue;

       end;
       //если есть более ранняя ведомость
       IF (nx<(length(vedom_mas)-2)) then
       begin
       //преобразовать дату время с vedom_mas
       //sdate:= strtoint(vedom_mas[nx+1,12]);
       //-------             year                  month                        day
       //stime:= strtoint(vedom_mas[nx+1,11]);
       //                  hour                       minutes
       //showmessage('tdate='+tick_mas[m,2]+' < '+sdate+' | ttime='+tick_mas[m,3]+' < '+stime);
       try
         //showmessage(tick_mas[m,2]+#32+tick_mas[m,3]+#13+vedom_mas[nx+1,12]+'  '+vedom_mas[nx+1,11]+#13+vedom_mas[nx,12]+'  '+vedom_mas[nx,11]);//$
         If (trim(vedom_mas[nx,12])<>'') and (trim(vedom_mas[nx,11])<>'') then
          begin
           //если дата продажи билета ДО даты создания более ранней ведомости - ОТВАЛ
             If (strtodatetime(tick_mas[m,2]+#32+tick_mas[m,3],mySettings)<strtodatetime(vedom_mas[nx+1,12]+#32+vedom_mas[nx+1,11],mySettings))
             //или дата продажи билета после даты создания выбранной ведомости - ОТВАЛ
             OR (strtodatetime(tick_mas[m,2]+#32+tick_mas[m,3],mySettings)>strtodatetime(vedom_mas[nx,12]+#32+vedom_mas[nx,11],mySettings))
                 then continue;
            end
         else
          begin
          //если дата продажи билета ДО даты создания более ранней ведомости - ОТВАЛ
             If (strtodatetime(tick_mas[m,2]+#32+tick_mas[m,3],mySettings)<strtodatetime(vedom_mas[nx+1,12]+#32+vedom_mas[nx+1,11],mySettings))
           //если дата продажи билета после даты создания ведомости то отвал
             OR (strtodatetime(tick_mas[m,2]+#32+tick_mas[m,3],mySettings)>timevedom) then continue;
          end;
       except
         on exception: EConvertError do
          begin
          showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tick_mas[m,2]+'| '+tick_mas[m,3]+'| '+tick_mas[nx+1,12]+'| '+tick_mas[nx,11]+'| '+tick_mas[nx,12]+#13+'--c18');
          continue;
          end;
       end;
       end;
     end;
       //Если это чек этой ведомости
       tick_mas[m,4]:= '1';
       tickets_count:= tickets_count +1;

       //суммируем багажи
       If tick_mas[m,14]<>'0' then
       begin
       try
       bagag_count:= bagag_count + strtoint(tick_mas[m,14]);
       bagag_sum:= bagag_sum + strtofloat(tick_mas[m,15]);
       except
       on exception: EConvertError do
      begin
       showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tick_mas[m,14]+'| '+tick_mas[m,15]+#13+'--c19');
       continue;
      end;
      end;
       end;
       //Если льготный
        If tick_mas[m,6]= '2' then
             begin
              lgot_count:= lgot_count +1;
              //lgot_sum_cash:= lgot_sum_cash+;
          try
              lgot_sum_credit:=lgot_sum_credit+strtofloat(tick_mas[m,9]);//льготный безналичный
              except
               on exception: EConvertError do
               begin
               showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tick_mas[m,9]+#13+'--c20');
               continue;
               end;
              end;
             end;
           //Если воинский
           If tick_mas[m,6] = '3' then
             begin
              wars_count:= wars_count +1;
              try
              wars_sum_credit:=wars_sum_credit+strtofloat(tick_mas[m,9]);//- стоимость воинского бензаличная
              except
               on exception: EConvertError do
               begin
               showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tick_mas[m,9]+#13+'--c21');
               continue;
               end;
              end;
             end;

           //Если платежными картами
           If tick_mas[m,6] = '4' then
             begin
              creditcard:= creditcard +1;
              try
              card_credit:=card_credit+strtofloat(tick_mas[m,10]);//- стоимость по платежной карте
              except
               on exception: EConvertError do
               begin
               showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tick_mas[m,10]+#13+'--c22');
               continue;
               end;
              end;
             end;

           try
             //showmessage(tick_mas[m,10]+#13+tick_mas[m,18]+#13+tick_mas[m,17]);//$
            tick_mas[m,10]:= floattostrF(strtofloat(tick_mas[m,10]) + strtofloat(tick_mas[m,17]),fffixed,10,2); //сумма билета и страх сбора
            tickets_sum:= tickets_sum + strtofloat(tick_mas[m,10]) + strtofloat(tick_mas[m,18]);// сумма билетов наличная +безналичный страх.сбор
           except
               on exception: EConvertError do
               begin
               showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tick_mas[m,10]+'| '+tick_mas[m,17]+'| '+tick_mas[m,18]+#13+'--c23');
               continue;
               end;
           end;
            try
           strah_sum:= strah_sum + strtofloat(tick_mas[m,17]) + strtofloat(tick_mas[m,18]);//страх сбор
            except
               on exception: EConvertError do
               begin
               showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+tick_mas[m,18]+#13+'--c24');
               continue;
               end;
            end;

           If not flfio and (trim(tick_mas[m,11])<>'') and (trim(tick_mas[m,11])<>'|') then flfio:=true; //ФИО
           If not fldoc and (trim(tick_mas[m,13])<>'') and (trim(tick_mas[m,13])<>'|') then fldoc:=true;//Документ
   end;

     //showmas(tick_mas);
      //считаем итоги
       vedom_mas[nx,28] := inttostr(tickets_count);
       vedom_mas[nx,29] := floattostrF(tickets_sum,fffixed,10,2);
       vedom_mas[nx,30] := inttostr(bagag_count);
       vedom_mas[nx,31] := floattostrF(bagag_sum,fffixed,10,2);
       vedom_mas[nx,32] := floattostrF(strah_sum,fffixed,10,2);
       vedom_mas[nx,33] := inttostr(wars_count);
       vedom_mas[nx,34] := floattostrF(wars_sum_cash,fffixed,10,2);
       vedom_mas[nx,35] := floattostrF(wars_sum_credit,fffixed,10,2);
       vedom_mas[nx,36] := inttostr(lgot_count);
       vedom_mas[nx,37] := floattostrF(lgot_sum_cash,fffixed,10,2);
       vedom_mas[nx,38] := floattostrF(lgot_sum_credit,fffixed,10,2);
       vedom_mas[nx,39] := inttostr(uslugi_count);
       vedom_mas[nx,40] := floattostrF(uslugi_sum_cash,fffixed,10,2);
       vedom_mas[nx,41] := floattostrF(uslugi_sum_credit,fffixed,10,2);
       //tick_mas[m,1] := ZReadOnlyQuery1.FieldByName('ticket_num').AsString; //ticket_num
       //tick_mas[m,2] := FormatDateTime('dd/mm/yyyy',ZReadOnlyQuery1.FieldByName('createdate').AsDateTime);    // createdate date
       //tick_mas[m,3] := FormatDateTime('hhnn',ZReadOnlyQuery1.FieldByName('createdate').AsDateTime);    //createdate time
       //tick_mas[m,8] := ZReadOnlyQuery1.FieldByName('lgot_sum').AsString; //lgot_sum
       //tick_mas[m,9] := ZReadOnlyQuery1.FieldByName('sum_credit').AsString; //sum_credit
       //tick_mas[m,10] := ZReadOnlyQuery1.FieldByName('sum_cash').AsString; //sum_cash
  end;

   vedName:=ExtractFilePath(Application.ExeName)+'disp_log/vedlist'+inttostr(id_user)+'.txt';
   //printer_vid:=1;

  //если опция печати на лазерный принтер (длина строки 117 символов)
  If printer_vid=1 then
    begin
     {$IFDEF LINUX}
      //DeleteFile(vedName);
      AssignFile(filetxt,vedName);
   try
      //{$I-} // отключение контроля ошибок ввода-вывода
      Rewrite(filetxt); // открытие файла с перезаписью
      //{$I+} // включение контроля ошибок ввода-вывода
      //if IOResult<>0 then // если есть ошибка открытия, то
      //  begin
      //   showmessagealt('Ошибка создания файла документа !');
      //   //result:=false;
      //   Exit;
      //  end;


  //******сброс настроек+портретная ориентация+а4 +                    размер (символов на дюйм)+межстрочный интервал
  write(filetxt,#027#069+#027#038#108#048#079+#027#038#108#050#054#065+#027#040#115+'12'+#072+#027#038#108+'5'+#067); //отмена режима сжатой печати
 //write(filetxt,#027#069+#027#038#108#048#079+#027#038#108#050#054#065+#027#040#115+'12'+#072+#027#038#108+'5'+#067);    //отмена режима сжатой печати
  write(filetxt,#32#13#10);//пустая строка
  write(filetxt,under+PadC(vedom_mas[nx,19],#32,30)+plain);//АТП  и печать подчеркнутого текста
  write(filetxt,PadC(company_name+' '+company_inn,#32,45));//реквизиты
  write(filetxt,under+PadC(vedom_mas[nx,2],#32,15)+plain+#13#10);//дата  перевод строки и возврат каретки
 //write(filetxt,StringofChar(#32,45)+under+PadC(vedom_mas[nx,2],#32,15)+plain+#13#10); //дата  перевод строки и возврат каретки
  write(filetxt,StringofChar(#32,10)+#027#040#115+'15'+#072+'перевозчик'+StringofChar(#32,80)+'дата'+#027#040#115+'12'+#072+#13#10);
  write(filetxt,StringofChar(#32,65)+under+PadC(otkuda_name,#32,25)+plain+#13#10); //остановочный пункт отправления
  write(filetxt,StringofChar(#32,70)+#027#040#115+'15'+#072+'станция отправления'+#027#040#115+'12'+#072+#13#10);
  //write(filetxt,#32#13#10);//пустая строка
  If spass=1 then
   begin
      write(filetxt,StringofChar(#32,20)+bold+'СПИСОК ПАССАЖИРОВ'+plain+#13#10);
      write(filetxt,#32#13#10);//пустая строка
   end
  else
   begin
  write(filetxt,StringofChar(#32,20)+'В Е Д О М О С Т Ь  '+bold+under+PadL(vedom_mas[nx,9],#32,23)+norm+plain+#13#10); //№ ведомости
  write(filetxt,StringofChar(#32,22)+'('+vedom_mas[nx,0]+IFTHEN(vedom_mas[nx,25]='0',')',' - '+vedom_mas[nx,25]+')')+#13#10); //тип ведомости //порядковый номер ведомости дообилечивания
  write(filetxt,PadC(IfTHEN(vedom_mas[nx,0]='1','Автобус:','учета продажи билетов на автобус:'),#32,80)+#13#10);
   end;
  write(filetxt,'Марка ');
  write(filetxt,under+PadR(vedom_mas[nx,21],#32,25)+plain); //ats_name
  write(filetxt,' Гос.рег.знак ');
  write(filetxt,under+PadR(vedom_mas[nx,23],#32,10)+plain); //ats_reg
  write(filetxt,' Путевой лист N ');
  write(filetxt,under+PadR(vedom_mas[nx,13],#32,10)+plain+#13#10); //putevka
  write(filetxt,'Наименование рейса '+under+' N ' +vedom_mas[nx,1]+'  '+vedom_mas[nx,5]+' - '+vedom_mas[nx,8]+plain+#13#10);  //наименование рейса
  write(filetxt,'Время отправления '+bold+under+PadC(vedom_mas[nx,10],#32,10)+norm+plain);
  write(filetxt,'Время отправления фактически '+bold+under+PadC(copy(vedom_mas[nx,11],1,2)+':'+copy(vedom_mas[nx,11],4,2),#32,7)+norm+plain+#13#10);
  vod3:='';
  vod4:='';
  //если по водителям есть данные паспорта
  If not(trim(vedom_mas[nx,16])='') then
    begin
     //showmessage(vedom_mas[nx,16]);//$
      If utf8pos('@',vedom_mas[nx,16])>0 then
    begin
   //водитель 3 имя док
     //showmessage(utf8copy(vedom_mas[nx,16],utf8pos('@',vedom_mas[nx,16])+1,utf8length(vedom_mas[nx,16])-utf8pos('@',vedom_mas[nx,16])));
     vod3:=utf8copy(vedom_mas[nx,16],utf8pos('@',vedom_mas[nx,16])+1,utf8length(vedom_mas[nx,16])-utf8pos('@',vedom_mas[nx,16]));
     //showmessage(vod3);//$
     write(filetxt,'Водитель 1 '+under+ vedom_mas[nx,14]+#32+utf8copy(vedom_mas[nx,16],1,utf8pos('@',vedom_mas[nx,16])-1)+plain);
    end
      else
      begin
        write(filetxt,'Водитель 1 '+under+ vedom_mas[nx,14]+#32+vedom_mas[nx,16]+plain);
      end;
    end
  else
  begin
    write(filetxt,'Водитель 1 '+under+ PadR(vedom_mas[nx,14],#32,17)+plain);
  end;

   //если по водителям есть данные паспорта
  If not(trim(vedom_mas[nx,17])='') then
    begin
      If utf8pos('@',vedom_mas[nx,17])>0 then
    begin
   //водитель 3 имя док
     vod4:=utf8copy(vedom_mas[nx,17],utf8pos('@',vedom_mas[nx,17])+1,utf8length(vedom_mas[nx,17])-utf8pos('@',vedom_mas[nx,16]));
     write(filetxt,' Водитель 2 '+under+ vedom_mas[nx,15]+#32+utf8copy(vedom_mas[nx,17],1,utf8pos('@',vedom_mas[nx,17])-1)+plain+#13#10);
    end
      else
      begin
        write(filetxt,' Водитель 2 '+under+ vedom_mas[nx,15]+#32+vedom_mas[nx,17]+plain+#13#10);
    end;

    end
  else
  begin
    write(filetxt,' Водитель 2 '+under+ PadR(vedom_mas[nx,15],#32,17)+plain+#13#10);
  end;

  If (vod3<>'') or (vod4<>'') then
   begin
    If (vod3<>'') then
     write(filetxt,'Водитель 3 '+under+ vod3 +plain);
    If (vod4<>'') then
     write(filetxt,' Водитель 4 '+under+ vod4 +plain);

    write(filetxt,#32#13#10);
   end;


  cnt:=0;
  fl_next:=false;
   //если напечатанных строчек больше maxticks, тогда печатаем на 2-х листах
  //If length(tick_mas)>maxticksL then cnt:=maxticksL;
  //writeln(filetxt,StringofChar(#32,120));//строка пробелов
  // Таблица - Начало 136 знаков
  write(filetxt,#027#038#108+'3'+#067);//уменьшаем межстрочный интервал
  If fldoc OR flfio then
    begin
     write(filetxt,#027#040#115+'15'+#072);//включение режима сжатой печати
  //ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
  If spass=1 then
     begin
      //          | 3 |         24             |  6   |    8   |    9    |    11     |  11       |        22            | 3 |   8    |
  write(filetxt,' ______________________________________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |   |                        |      |        |  Пункт  |           |           |                      |Квитанция   |'+#13#10);
  write(filetxt,' |№  |        Номер           | Вид* |Стоим-ть|  отправ-|   Пункт   |  Документ |      Ф. И. О.        |багажа      |'+#13#10);
  write(filetxt,' |мес|  посадочного талона    |талона|        |  ления  | назначения|           |                      |кол-во/сумма|'+#13#10);
  write(filetxt,' |та_|________________________|______|________|_________|___________|___________|______________________|___|________|'+#13#10);
      //          | 5   |         24             |  6   |   9     |    9    |    11     |        21           |        22            |    7   |    11     |
  //write(filetxt,' ___________________________________________________________________________________________________________________________________________ '+#13#10);
//write(filetxt,' |     |                        |      |         |  Пункт  |           |                     |                      |Квитанция на провоз:|'+#13#10);
//write(filetxt,' |Номер|          Номер         | Вид  |Стоимость|  отправ-|   Пункт   |       Документ      |        Ф. И. О.      |багажа/ручной клади |'+#13#10);
//write(filetxt,' |места|         билета         |билета|         |  ления  | назначения|                     |                      | кол-во |   сумма   |'+#13#10);
//write(filetxt,' |_____|________________________|______|_________|_________|___________|_____________________|______________________|________|___________|'+#13#10);
  //
    end
  else
     begin
      //          | 3 |         24             |  6   |    8   |          21         |  11       |        22            | 3 |   8    |
  write(filetxt,' ______________________________________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |   |                        |      |        |                     |           |                      |Квитанция   |'+#13#10);
  write(filetxt,' |№  |          Номер         | Вид* |Стоим-ть|       Пункт         |  Документ |      Ф. И. О.        |багажа      |'+#13#10);
  write(filetxt,' |мес|         билета         |билета|        |    назначения       |           |                      |кол-во/сумма|'+#13#10);
  write(filetxt,' |та_|________________________|______|________|_____________________|___________|______________________|___|________|'+#13#10);
     end;
    end
  else
  begin
         //          | 3 |         24             |  6   |    8   |          21         |  11       | 3 |   8    |
     write(filetxt,' ______________________________________________________________________________________________ '+#13#10);
     write(filetxt,' |   |                        |      |        |                     |           |Квитанция   |'+#13#10);
     write(filetxt,' |№  |          Номер         | Вид* |Стоим-ть|       Пункт         |  Документ |багажа      |'+#13#10);
     write(filetxt,' |мес|         билета         |билета|        |    назначения       |           |кол-во/сумма|'+#13#10);
     write(filetxt,' |та_|________________________|______|________|_____________________|___________|___|________|'+#13#10);
  end;

  //                        T1705201217290348833-77
  for n:=0 to length(tick_mas)-1 do
  begin
  //если это билет не этой ведомости, то пропускаем
    If tick_mas[n,4]<>'1' then continue;
  cnt:=cnt+1;
   //если напечатанных строчек больше maxticks, тогда печатаем на 2-х листах
  If cnt>maxticksL then
    begin
    fl_next:=true;
    break;
    end;
  write(filetxt,' |'+bold+PadL(tick_mas[n,0],#32,3)+'|');          //1 номер места
  write(filetxt,PadR(tick_mas[n,1],#32,24)+norm+'|');              //2 номер билета
  write(filetxt,PadC(utf8copy(tick_mas[n,16],1,6),#32,6)+'|');     //3 вид билета
  write(filetxt,PadL(tick_mas[n,10],#32,8)+'|');                   //4 стоимость
  //ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
  If (spass=1)  then
    begin
      write(filetxt,PadC(utf8copy(tick_mas[n,20],1,9),#32,9)+'|');  //5 пункт отправления
      write(filetxt,PadC(utf8copy(tick_mas[n,7],1,11),#32,11)+'|'); //6 пункт назначения
  end
  else
  begin
    write(filetxt,PadC(utf8copy(tick_mas[n,7],1,21),#32,21)+'|');    //5 пункт назначения
  end;
 //если есть данные документа или фио
   If fldoc OR flfio  then
     begin
     //write(filetxt,PadC(utf8copy(tick_mas[n,12]+': '+tick_mas[n,13],1,20),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,13],1,11),#32,11)+'|');  //6(7) тип документа, номер

     //если фио длинее ширины столбца, обрезаем до отчества
     If utf8length(tick_mas[n,11])>22 then
      begin
       i:=1;
       tmp:=trim(tick_mas[n,11]);
        //ищем пробел с конца
        for i:=utf8length(tmp) downto 1 do
        begin
         //showmessage(utf8copy(tmp,i,1));
         //нашли пробел
          If utf8copy(tmp,i,1)=#32 then
            begin
             //Если без последнего слова <20 символов, то обрезаем исходник
               IF utf8length(utf8copy(tmp,1,i-1))<20 then
                 tick_mas[n,11]:=utf8copy(tick_mas[n,11],1,22);
               write(filetxt,PadR(utf8copy(tick_mas[n,11],1,22),#32,22)+'|'); //фио
                //else
                 //write(filetxt,PadC(utf8copy(tmp,1,i-1),#32,22)+'|');//фио
             break;
            end;
        end;
       //если не нашли пробел, обрезаем грубо
           If i=1 then
            begin
            write(filetxt,PadR(utf8copy(tick_mas[n,11],1,22),#32,22)+'|');
            i:=22;
            end;
        end
      else
        write(filetxt,PadR(utf8copy(tick_mas[n,11],1,22),#32,22)+'|'); //фио
     end;
  write(filetxt,PadC(tick_mas[n,14],#32,3)+'|');                    //кол-во багажа
  write(filetxt,PadR(tick_mas[n,15],#32,8)+'|'+#13#10);                   //сумма багажа

  //если длина документа или фио больше ширины поля, то переносим на следующую строку
  If (fldoc OR flfio) then
   //If ((utf8length(tick_mas[n,12]+': '+tick_mas[n,13])>20) or (utf8length(tick_mas[n,11])>20)) then
   If ((utf8length(tick_mas[n,13])>11) or (utf8length(tick_mas[n,11])>22)) then
     begin
     cnt:=cnt+1;
     write(filetxt,' |'+StringofChar(#32,3)+'|'); //номер места
     write(filetxt,StringofChar(#32,24)+'|');    //номер билета
     write(filetxt,StringofChar(#32,6)+'|');     //вид билета
     write(filetxt,StringofChar(#32,8)+'|');     //стоимость
     write(filetxt,StringofChar(#32,21)+'|');    //пункт назначения
     //write(filetxt,PadC(utf8copy(tick_mas[n,12]+': '+tick_mas[n,13],21,utf8length(tick_mas[n,12])),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,13],11,utf8length(tick_mas[n,13])),#32,11)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,11],i,utf8length(tick_mas[n,11])),#32,22)+'|');                   //фио
     write(filetxt,StringofChar(#32,3)+'|');        //кол-во багажа
     write(filetxt,StringofChar(#32,8)+'|'+#13#10); //сумма багажа
     end;

  //rem 20210701 печатать телефон, если есть
  IF (tick_mas[n,23]<>'') and (fldoc OR flfio) then
   begin
     cnt:=cnt+1;
     write(filetxt,' |'+StringofChar(#32,3)+'|'); //номер места
     write(filetxt,StringofChar(#32,24)+'|');    //номер билета
     write(filetxt,StringofChar(#32,6)+'|');     //вид билета
     write(filetxt,StringofChar(#32,8)+'|');     //стоимость
     write(filetxt,StringofChar(#32,21)+'|');    //пункт назначения
     //write(filetxt,PadC(utf8copy(tick_mas[n,12]+': '+tick_mas[n,13],21,utf8length(tick_mas[n,12])),#32,21)+'|');//тип документа, номер
     write(filetxt,StringofChar(#32,11)+'|');     //тип документа, номер
     write(filetxt,PadC('тел.'+tick_mas[n,23],#32,22)+'|');  //телефон
     write(filetxt,StringofChar(#32,3)+'|');           //кол-во багажа
     write(filetxt,StringofChar(#32,8)+'|'+#13#10);   //сумма багажа
   end;

   end;

  k:=n;

  If fldoc OR flfio then
 //ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
  If spass=1 then
   //                | 3 |         24             |  6   |    8   |    9    |     11    |     11    |        22            | 3 |   8    |
     write(filetxt,' |___|________________________|______|________|_________|___________|___________|______________________|___|________|'+#13#10)
     else
  //                 | 3 |         24             |  6   |   8    |         21          |     11    |        22            | 3 |   8    |
     write(filetxt,' |___|________________________|______|________|_____________________|___________|______________________|___|________|'+#13#10)
  else
    //               | 3 |         24             |  6   |   8    |         21          | 3 |    8   |
     write(filetxt,' |___|________________________|______|________|_____________________|___|________|'+#13#10);


   //2-й ЛИСТ если напечатанных строчек больше maxticks, тогда печатаем на 2-х листах
  If fl_next then
    begin
      write(filetxt,#027#038#108#048#072+#13#10);//выброс листа
      If fldoc OR flfio then
    begin
     write(filetxt,#027#040#115+'15'+#072);//включение режима сжатой печати
  //2-й ЛИСТ ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
  If spass=1 then
     begin
      //          | 3 |         24             |  6   |   8    |    9    |    11     |  11       |        22            | 3 |   8    |
  write(filetxt,' _____________________________________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |   |                        |      |        |  Пункт  |           |           |                      |Квитанция   |'+#13#10);
  write(filetxt,' |№  |        Номер           | Вид* |Стоим-ть|  отправ-|   Пункт   |  Документ |      Ф. И. О.        |багажа      |'+#13#10);
  write(filetxt,' |мес|  посадочного талона    |талона|        |  ления  | назначения|           |                      |кол-во/сумма|'+#13#10);
  write(filetxt,' |та_|________________________|______|________|_________|___________|___________|______________________|___|________|'+#13#10);
   end
  else
     begin
  //              | 3 |         24             |  6   |   8    |         21          |     11    |        22            | 3 |   8    |
  write(filetxt,' ______________________________________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |   |                        |      |        |                     |           |                      |Квитанция   |'+#13#10);
  write(filetxt,' |№  |          Номер         | Вид* |Стоим-ть|        Пункт        | Документ  |        Ф. И. О.      |багажа      |'+#13#10);
  write(filetxt,' |мес|         билета         |билета|        |     назначения      |           |                      |кол-во/сумма|'+#13#10);
  write(filetxt,' |та_|________________________|______|________|_____________________|___________|______________________|___|________|'+#13#10);
     end;
    end
  else
  begin
         //          | 3 |         24             |  6   |    8   |          21         |  11       | 3 |   8    |
     write(filetxt,' ______________________________________________________________________________________________ '+#13#10);
     write(filetxt,' |   |                        |      |        |                     |           |Квитанция   |'+#13#10);
     write(filetxt,' |№  |          Номер         | Вид* |Стоим-ть|       Пункт         |  Документ |багажа      |'+#13#10);
     write(filetxt,' |мес|         билета         |билета|        |    назначения       |           |кол-во/сумма|'+#13#10);
     write(filetxt,' |та_|________________________|______|________|_____________________|___________|___|________|'+#13#10);
  end;

//   2-й лист
  for n:=k to length(tick_mas)-1 do
  begin
    //если это билет не этой ведомости, то пропускаем
    If tick_mas[n,4]<>'1' then continue;
  write(filetxt,' |'+bold+PadL(tick_mas[n,0],#32,3)+'|'); //номер места
  write(filetxt,PadR(tick_mas[n,1],#32,24)+norm+'|');    //номер билета
  write(filetxt,PadC(utf8copy(tick_mas[n,16],1,6),#32,6)+'|');     //вид билета
  write(filetxt,PadL(tick_mas[n,10],#32,8)+'|');     //стоимость
    //ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
  If spass=1 then
    begin
      write(filetxt,PadC(utf8copy(tick_mas[n,20],1,9),#32,9)+'|');  //пункт отправления
      write(filetxt,PadC(utf8copy(tick_mas[n,7],1,11),#32,11)+'|'); //пункт назначения
    end
  else
  begin
    write(filetxt,PadC(utf8copy(tick_mas[n,7],1,21),#32,21)+'|');    //пункт назначения
  end;
   If fldoc OR flfio then
     begin
     //write(filetxt,PadC(utf8copy(tick_mas[n,12]+': '+tick_mas[n,13],1,20),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,13],1,11),#32,11)+'|');//тип документа, номер

     //2-й лист если фио длинее ширины столбца, обрезаем до отчества
     If utf8length(tick_mas[n,11])>22 then
      begin
       i:=1;
       tmp:=trim(tick_mas[n,11]);
        //ищем пробел с конца
        for i:=utf8length(tmp) downto 1 do
        begin
         //showmessage(utf8copy(tmp,i,1));
         //нашли пробел
          If utf8copy(tmp,i,1)=#32 then
            begin
             //Если без последнего слова <20 символов, то обрезаем исходник
               IF utf8length(utf8copy(tmp,1,i-1))<20 then
                 tick_mas[n,11]:=utf8copy(tick_mas[n,11],1,22);
               write(filetxt,PadR(utf8copy(tick_mas[n,11],1,22),#32,22)+'|'); //фио
                //else
                 //write(filetxt,PadC(utf8copy(tmp,1,i-1),#32,22)+'|');//фио
             break;
            end;
        end;
       //если не нашли пробел, обрезаем грубо
           If i=1 then
            begin
            write(filetxt,PadR(utf8copy(tick_mas[n,11],1,22),#32,22)+'|');
            i:=22;
            end;
        end
      else
        write(filetxt,PadR(utf8copy(tick_mas[n,11],1,22),#32,22)+'|'); //фио
     end;
  write(filetxt,PadC(tick_mas[n,14],#32,4)+'|');                    //кол-во багажа
  write(filetxt,PadC(tick_mas[n,15],#32,8)+'|'+#13#10);             //сумма багажа

  //2-лист если длина документа или фио больше ширины поля, то переносим на следующую строку
 If (k>length(tick_mas) div 2) and (fldoc OR flfio) and ((utf8length(tick_mas[n,13])>11) or (utf8length(tick_mas[n,11])>22)) then
     begin
     write(filetxt,' |'+StringofChar(#32,3)+'|'); //номер места
     write(filetxt,StringofChar(#32,24)+'|');    //номер билета
     write(filetxt,StringofChar(#32,6)+'|');     //вид билета
     write(filetxt,StringofChar(#32,8)+'|');     //стоимость
     write(filetxt,StringofChar(#32,21)+'|');    //пункт назначения
     //write(filetxt,PadC(utf8copy(tick_mas[n,12]+': '+tick_mas[n,13],21,utf8length(tick_mas[n,12])),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,13],11,utf8length(tick_mas[n,13])),#32,11)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,11], i,utf8length(tick_mas[n,11])),#32,22)+'|');  //фио
     write(filetxt,StringofChar(#32,3)+'|');           //кол-во багажа
     write(filetxt,StringofChar(#32,8)+'|'+#13#10);   //сумма багажа
     end;

  //rem 20210701 2-й лист печатать телефон, если есть
  IF (tick_mas[n,23]<>'') and (fldoc OR flfio) then
   begin
     cnt:=cnt+1;
     write(filetxt,' |'+StringofChar(#32,3)+'|'); //номер места
     write(filetxt,StringofChar(#32,24)+'|');    //номер билета
     write(filetxt,StringofChar(#32,6)+'|');     //вид билета
     write(filetxt,StringofChar(#32,8)+'|');     //стоимость
     write(filetxt,StringofChar(#32,21)+'|');    //пункт назначения
     //write(filetxt,PadC(utf8copy(tick_mas[n,12]+': '+tick_mas[n,13],21,utf8length(tick_mas[n,12])),#32,21)+'|');//тип документа, номер
     write(filetxt,StringofChar(#32,11)+'|');     //тип документа, номер
     write(filetxt,PadC('тел.'+tick_mas[n,23],#32,22)+'|');  //телефон
     write(filetxt,StringofChar(#32,3)+'|');           //кол-во багажа
     write(filetxt,StringofChar(#32,8)+'|'+#13#10);   //сумма багажа
   end;
  end;

 If fldoc OR flfio then
   //ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
   If spass=1 then
   //                | 3 |         24             |  6   |    8   |    9    |     11    |    11     |        22            | 3 |  8     |
     write(filetxt,' |___|________________________|______|________|_________|___________|___________|______________________|___|________|'+#13#10)
     else
  //                 | 3 |         24             |  6   |   8    |         21          |    11     |        22            | 3 |  8     |
     write(filetxt,' |___|________________________|______|________|_____________________|___________|______________________|___|________|'+#13#10)
   else
    //               | 3 |         24             |  6   |   8    |         21          | 3 |    8   |
     write(filetxt,' |___|________________________|______|________|_____________________|___|________|'+#13#10);
    end;

  write(filetxt,#027#038#108+'5'+#067);//восстанавливаем межстрочный интервал
  //Таблица - Конец
  //writeln(filetxt,StringofChar(#32,120));//строка пробелов
  write(filetxt,#027#040#115+'18'+#072);//включение режима сжатой печати
  If spass=1 then
    write(filetxt,' *- П -полный, Д -детский, К -карта, ПА -иные лица, ПИ -интернет, Б -багаж'+#13#10)
   else
    write(filetxt,' *- П -полный, Д -детский, Л -льготный, В -воинский, К -карта, ПА -иные лица, ПИ -интернет, Б -багаж'+#13#10);
  write(filetxt,#027#040#115+'12'+#072);////отменить сжатый текст, установить шрифт 12 p/i, межстрочный интервал = n/72
  //служебка от 07.06.2018 на отображение снятой брони при продаже коротких билетов
    If length(arbron2)>0 then
   begin
   write(filetxt,'ВНИМАНИЕ!!! СНЯТА БРОНЬ с мест: '+#13#10);
      for j:=low(arbron2) to high(arbron2) do
      begin
         write(filetxt,'место № '+arbron2[j,1]+' -- '+arbron2[j,0]+' '+#13#10);
      end;
   end;
    setlength(arbron2,0,0);

   If length(arbron)>0 then
   begin
   write(filetxt,'ВНИМАНИЕ !!! '+#13#10);
      for j:=low(arbron) to high(arbron) do
      begin
         write(filetxt,arbron[j,0]+': забронировано - '+arbron[j,1]+' место'+#13#10);
      end;
   end;
   setlength(arbron,0,0);

  write(filetxt,'Количество транзитных пассажиров: '+inttostr(tranzit)+#13#10);
   If spass=1 then
   begin
   write(filetxt,'Количество посадочных талонов: ');
   write(filetxt,bold+ vedom_mas[nx,28]+norm); //кол-во билетов
   write(filetxt,' на сумму: ' +bold+ vedom_mas[nx,29]+norm); //итоговая стоимость билетов наличная
   write(filetxt,' руб.'+#13#10);
   end
   else
   begin
  write(filetxt,'Количество пассажирских билетов: ');
  write(filetxt,bold+ vedom_mas[nx,28]+norm); //кол-во билетов
  write(filetxt,' на сумму: ' +bold+ vedom_mas[nx,29]+norm); //итоговая стоимость билетов наличная
  write(filetxt,' руб., в том числе: '+#13#10);
  //write(filetxt,'страховой сбор на сумму: ' +bold+ vedom_mas[nx,32]+norm); //сумма страхового сбора
  //write(filetxt,' руб.,'+#13#10);
  write(filetxt,'воинские билеты: ' +bold+ vedom_mas[nx,33]+norm); //кол-во воинских
  write(filetxt,' на сумму: ' +bold+ vedom_mas[nx,35]+norm); //сумма воинских
  write(filetxt,' руб.(безналичный расчет)'+#13#10);
  write(filetxt,'льготные билеты: ' +bold+ vedom_mas[nx,36]+norm); //кол-во воинских
  write(filetxt,' на сумму: ' +bold+ vedom_mas[nx,38]+norm); //сумма воинских
  write(filetxt,' руб.(безналичный расчет)'+#13#10);
    end;

  If creditcard>0 then
  begin
    write(filetxt,'по банковским картам: ' +bold+ inttostr(creditcard)+norm); //кол-во по платежным картам
  write(filetxt,' на сумму: ' +bold+ floattostrF(card_credit,fffixed,10,2)+norm); //сумма
  write(filetxt,' руб.(безналичный расчет)'+#13#10);
  end;
  write(filetxt,'Количество квитанций на провоз багажа/ручной клади: ' +bold+ vedom_mas[nx,30]+norm); //багаж кол-во
  write(filetxt,' на сумму: ' +bold+ vedom_mas[nx,31]+norm+' руб.'+#13#10); //багаж сумма
  //write(filetxt,#32#13#10);//пустая строка
      If spass=1 then
          write(filetxt,StringofChar(#32,40)+'Дата и время печати списка пассажиров: '+bold+FormatDateTime('dd-mm-yyyy',now())+'г. '+FormatDateTime('hh:nn',now())+norm+#13#10)
        else
          write(filetxt,StringofChar(#32,40)+'Дата и время печати ведомости: '+bold+FormatDateTime('dd-mm-yyyy',now())+'г. '+FormatDateTime('hh:nn',now())+norm+#13#10);
  write(filetxt,#32#13#10);//пустая строка
  write(filetxt,'  Деж. диспетчер '+PadR(#32#32#32,'_',10)+bold+PadR(vedom_mas[nx,27],#32,15)+norm); //диспетчер имя
  write(filetxt,StringofChar(#32,10)+' Перронный контролер '+PadR(#32,'_',10)+#13#10+#027#038#108#048#072); //для подписи //следующий лист

  closefile(filetxt);
 except
    // Если ошибка - отобразить её
    on E: EInOutError do
      showmessagealt('Ошибка создания файла ведомости !!!'+#13+'Детали: '+E.ClassName+'/'+E.Message);
 end;

   {$ENDIF}

  {$IFDEF WINDOWS}
   //rep_dir:= GetEnvironmentVariable('USERPROFILE')+'\DISPLIST';
    rep_dir:='C:\temp';
    //Проверка на директорию
 if (not DirectoryExists(rep_dir)) then
   begin
   {$IOChecks off}
  MkDir(rep_dir);
  // Создание каталого прошло успешно?
 // error:= IOResult ;
  if IOResult<>0
  then
   begin
    ShowMessageFmt('ОШИБКА ! Создание каталога '+rep_dir+' .',[IOResult]);
     rep_dir:= GetEnvironmentVariable('USERPROFILE')+'\DISPLIST';
    if (not DirectoryExists(rep_dir)) then
     begin
      MkDir(rep_dir);
       if IOResult<>0
       then
        begin
        ShowMessageFmt('ОШИБКА Создания каталога '+rep_dir+' !',[IOResult]);
        Form2.Close;
        exit;
        end;
       end;
   end;
  {$IOChecks on}
 end;
  rep_dir:=IncludeTrailingPathDelimiter(rep_Dir);

     inc(vedomcount);
 if StartHTML(rep_dir+'vedom'+inttostr(id_user)+'_'+inttostr(vedomcount)+'.html')=false then exit;
 StartTableHTML(0,'90%',1);
 StartRowTableHTML('bottom');//новая строка таблицы
 CellsTableHTML(PadC(vedom_mas[nx,19],#32,40),3,3,5,'000000',3,0,''); //АТП
 CellsTableHTML('',1,1,1,'000000',2,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,2],#32,17),3,3,5,'000000',0,0,''); //дата
 //CellsTableHTML('',1,1,1,'000000',0,0,'');
 EndRowTableHTML();
 StartRowTableHTML('top');//новая строка таблицы
 CellsTableHTML('перевозчик',3,1,1,'000000',3,0,'');
 CellsTableHTML('',1,1,1,'000000',2,0,'');
 CellsTableHTML('дата',3,1,1,'000000',0,0,'');
//CellsTableHTML('',1,1,1,'000000',0,0,'');
 EndRowTableHTML();
 StartRowTableHTML('bottom');//новая строка таблицы
 CellsTableHTML(PadC(server_name,#32,20),2,3,5,'000000',6,0,''); //остановочный пункт отправления
 EndRowTableHTML();
 StartRowTableHTML('top');//новая строка таблицы
 CellsTableHTML('',2,1,1,'000000',5,0,'');
 CellsTableHTML('станция отправления',2,2,1,'000000',0,0,'');
 StartRowTableHTML('bottom');//новая строка таблицы
  If spass=1 then
   begin
      CellsTableHTML('СПИСОК ПАССАЖИРОВ ',2,4,2,'000000',3,0,'');
   end
  else
   begin
    CellsTableHTML('ВЕДОМОСТЬ № ',2,4,2,'000000',3,0,'');
    CellsTableHTML(PadR(vedom_mas[nx,9],#32,30),1,4,5,'000000',3,0,''); //№ ведомости
    StartRowTableHTML('top');//новая строка таблицы
 CellsTableHTML('('+vedom_mas[nx,0]+IFTHEN(vedom_mas[nx,25]='0',')',' - '+vedom_mas[nx,25]+')'),2,2,1,'000000',3,0,''); //тип ведомости //порядковый номер ведомости дообилечивания
 CellsTableHTML('',1,1,1,'000000',3,0,'');
 EndRowTableHTML();
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML(IfTHEN(vedom_mas[nx,0]='1','Автобус:','учета продажи билетов на автобус:'),3,3,2,'000000',6,0,'');
 EndRowTableHTML();
 end;
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('',1,1,1,'000000',6,0,'');
 EndRowTableHTML();
  //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(0,'80%',1);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('Марка ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadR(vedom_mas[nx,21],#32,25),1,3,5,'000000',0,0,''); //ats_name
 CellsTableHTML(' Гос.рег.знак ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadR(vedom_mas[nx,23],#32,15),1,3,5,'000000',0,0,''); //ats_reg
 CellsTableHTML(' Путевой лист №',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadR(vedom_mas[nx,13],#32,10),1,3,5,'000000',0,0,''); //putevka
 EndRowTableHTML();
    //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(0,'60%',1);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('Наименование рейса ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadR('№' +vedom_mas[nx,1]+'  '+vedom_mas[nx,5]+' - '+vedom_mas[nx,8],#32,80),1,3,5,'000000',5,0,'');  //наименование рейса
 EndRowTableHTML();
    //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(0,'70%',1);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('Время отправления по расписанию ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,10],#32,10),1,3,5,'000000',0,0,'');
 CellsTableHTML(' Время отправления фактически ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,11],#32,7),1,3,5,'000000',0,0,'');
 EndRowTableHTML();
    //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(0,'90%',1);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('Водитель 1 ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadR(vedom_mas[nx,14],#32,17),1,3,5,'000000',0,0,'');
 CellsTableHTML(' Водитель 2 ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadR(vedom_mas[nx,15],#32,17),1,3,5,'000000',0,0,'');
 //EndRowTableHTML();
 If not(trim(vedom_mas[nx,16])='') then
   begin
 //StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('Водитель 3 ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadR(vedom_mas[nx,16],#32,15),1,3,5,'000000',0,0,'');
 end;
 If not(trim(vedom_mas[nx,17])='')then
   begin
 CellsTableHTML(' Водитель 4 ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadR(vedom_mas[nx,17],#32,15),1,3,5,'000000',0,0,'');
   end;
 EndRowTableHTML();
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('',1,1,1,'000000',6,0,'');
 EndRowTableHTML();
 //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(1,'900',3);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('Номер<br>места',3,3,1,'000000',0,2,'50');
 CellsTableHTML('Номер<br>билета',3,3,1,'000000',0,2,'50');
 CellsTableHTML('Вид <br>билета*',3,3,1,'000000',0,2,'50');
 CellsTableHTML('Стоимость',3,3,1,'000000',0,2,'50');
 CellsTableHTML('Пункт<br>назначения',3,3,1,'000000',0,2,'100');
 If fldoc then  CellsTableHTML('Документ',3,3,1,'000000',0,2,'200');
           //else CellsTableHTML('-',3,2,1,'000000',0,2,'5%');
 If flfio then  CellsTableHTML('Ф.И.О.',3,3,1,'000000',0,2,'200');
            //else CellsTableHTML('    ',3,1,1,'000000',0,2,'5%');
 CellsTableHTML('Квитанция на провоз:<br>багажа/ручной клади',3,2,1,'000000',2,0,'20');
 EndRowTableHTML();
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('кол-во',3,3,1,'000000',0,0,'10');
 CellsTableHTML('сумма',3,3,1,'000000',0,0,'10');
 EndRowTableHTML();
 for n:=0 to length(tick_mas)-1 do
 begin
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML(tick_mas[n,0],3,3,1,'000000',0,0,'');  //место
 CellsTableHTML(tick_mas[n,1],3,3,1,'000000',0,0,'');  //№ билета
 CellsTableHTML(tick_mas[n,16],3,3,1,'000000',0,0,'');  //вид билета
 CellsTableHTML(tick_mas[n,10],3,3,1,'000000',0,0,'');  //стоимость
 CellsTableHTML(tick_mas[n,7],3,3,1,'000000',0,0,'');  //пункт назначения
 If fldoc then CellsTableHTML(tick_mas[n,13],3,3,1,'000000',0,0,'');//тип документа, номер
 If flfio then CellsTableHTML(tick_mas[n,11],3,3,1,'000000',0,0,'');                   //фио
 CellsTableHTML(tick_mas[n,14],3,3,1,'000000',0,0,'');                    //кол-во багажа
 CellsTableHTML(tick_mas[n,15],3,3,1,'000000',0,0,'');                   //сумма багажа
 EndRowTableHTML();
 end;
 //Таблица - Конец
 EndTableHTML();
 SetHTMLString('* Примечание: Вид билета: П-полный, Д - детский, Л - льготный, В - воинский, С - студенческий.',1,1,1,'000000');
 SetHTMLString(' ',3,4,1,'000000');
 SetHTMLString(' ',3,4,1,'000000');
 // Таблица - Начало
 StartTableHTML(0,'80%',1);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('Количество пассажирских билетов: ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,28],#32,5),1,3,5,'000000',0,0,''); //кол-во билетов
 CellsTableHTML(' на сумму: ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,29],#32,12),1,3,5,'000000',0,0,''); //итоговая стоимость билетов наличная
 CellsTableHTML(' руб., в том числе: ',1,3,1,'000000',0,0,'');
 EndRowTableHTML();
 //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(0,'60%',1);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('страховой сбор на сумму: ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,32],#32,10),1,3,5,'000000',0,0,''); //сумма страхового сбора
 CellsTableHTML(' руб.,',1,3,1,'000000',0,0,'');
 EndRowTableHTML();
 //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(0,'70%',1);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('воинские билеты: ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,33],#32,5),1,3,5,'000000',0,0,''); //кол-во воинских
 CellsTableHTML(' на сумму: ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,35],#32,10),1,3,5,'000000',0,0,''); //сумма воинских
 CellsTableHTML(' руб. (безналичный расчет)',1,3,1,'000000',2,0,'');
 EndRowTableHTML();
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('льготные билеты: ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,36],#32,5),1,3,5,'000000',0,0,''); //кол-во воинских
 CellsTableHTML(' на сумму: ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,38],#32,10),1,3,5,'000000',0,0,''); //сумма воинских
 CellsTableHTML(' руб. (безналичный расчет)',1,3,1,'000000',2,0,'');
 EndRowTableHTML();
 //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(0,'80%',1);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('Количество квитанций на провоз багажа/ручной клади: ',1,3,1,'000000',3,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,30],#32,5),1,3,5,'000000',0,0,''); //багаж кол-во
 CellsTableHTML(' на сумму: ',1,3,1,'000000',0,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,31],#32,10),1,3,5,'000000',0,0,''); //багаж сумма
 CellsTableHTML('руб.',1,3,1,'000000',0,0,'');
 EndRowTableHTML();
 //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(0,'',2);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML(' ',1,2,1,'000000',4,0,'');
 CellsTableHTML('Дата и время печати ведомости: '+FormatDateTime('dd.mm.yyyy',Date())+'г. '+FormatDateTime('hh:nn',time()),1,3,3,'000000',0,0,'');
 EndRowTableHTML();
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML(' ',1,2,1,'000000',5,0,'');
 EndRowTableHTML();
 //Таблица - Конец
 EndTableHTML();
 // Таблица - Начало
 StartTableHTML(0,'90',3);
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML('Деж. диспетчер ',1,3,1,'000000',2,0,'');
 CellsTableHTML(stringofchar(#32,15),1,3,5,'000000',0,0,''); //для подписи
 CellsTableHTML(PadR(vedom_mas[nx,27],#32,15),1,3,1,'000000',0,0,''); //диспетчер имя
 CellsTableHTML(' ',1,3,1,'000000',0,0,'');
 CellsTableHTML(' Перонный контролер ',1,3,1,'000000',2,0,'');
 CellsTableHTML(stringOfChar(#32,15),1,3,5,'000000',0,0,''); //для подписи
 EndRowTableHTML();
  //Таблица - Конец
 EndTableHTML();
 EndHTML(); // Конец HTML (fileHTML:десткриптор файла)
 startbrowser(rep_dir+'vedom'+inttostr(id_user)+'_'+inttostr(vedomcount)+'.html');
  {$ENDIF}

  end;


   {$IFDEF LINUX}
  //!!!!!!!!!!!!!         если опция печати на матричный принтер (136 знаков)  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //************ The printer language ESC/P
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 If printer_vid=2 then
  begin
   vedName:=ExtractFilePath(Application.ExeName)+'disp_log/vedlistMatrix'+inttostr(id_user)+'.txt';

   AssignFile(filetxt,vedName);
  try
      //{$I-} // отключение контроля ошибок ввода-вывода
      Rewrite(filetxt); // открытие файла для чтения
      //{$I+} // включение контроля ошибок ввода-вывода
      //if IOResult<>0 then // если есть ошибка открытия, то
      //  begin
      //   showmessagealt('Ошибка создания файла документа !');
      //   //result:=false;
      //   Exit;
      //  end;
//The printer language ESC/P was originally developed by Epson for use with their early dot-matrix printers.
  write(filetxt,#27#18+#27#79+#27#77+#27#50);    //отмена режима сжатой печати отмена пропуска перфорации  12-cpi character printing  Sets the line spacing to 1/6 inch
  write(filetxt,#27#45#49+PadC(vedom_mas[nx,19],#32,30)+#27#45#48); //АТП  и печать подчеркнутого текста
  write(filetxt,PadC(company_name+' '+company_inn,#32,35)); //реквизиты
  write(filetxt,#27#45#49+PadC(vedom_mas[nx,2],#32,15)+#27#45#48#13#10); //дата  перевод строки и возврат каретки
  write(filetxt,StringofChar(#32,10)+#27#15+'перевозчик'+StringofChar(#32,90)+'дата'+#18#13#10);
  write(filetxt,StringofChar(#32,60)+#27#45#49+PadC(otkuda_name,#32,25)+#27#45#48#13#10); //остановочный пункт отправления
  write(filetxt,StringofChar(#32,70)+#27#15+'станция отправления'+#18#13#10);
  write(filetxt,#32#13#10);//пустая строка
   If spass=1 then
    begin
      write(filetxt,StringofChar(#32,25)+'СПИСОК ПАССАЖИРОВ'+#13#10);
      write(filetxt,#32#13#10);//пустая строка
    end
  else
  begin
  write(filetxt,StringofChar(#32,25)+'В Е Д О М О С Т Ь  '+#27#69#27#45#49+PadL(vedom_mas[nx,9],#32,23)+#27#70#27#45#48#13#10); //№ ведомости
  write(filetxt,StringofChar(#32,30)+'('+vedom_mas[nx,0]+IFTHEN(vedom_mas[nx,25]='0',')',' - '+vedom_mas[nx,25]+')')+#13#10); //тип ведомости //порядковый номер ведомости дообилечивания
  write(filetxt,PadC(IfTHEN(vedom_mas[nx,0]='1','Автобус:','учета продажи билетов на автобус:'),#32,80)+#13#10);
  end;
  write(filetxt,'Марка ');
  write(filetxt,#27#45#49+PadR(vedom_mas[nx,21],#32,25)+#27#45#48); //ats_name
  write(filetxt,' Гос.рег.знак ');
  write(filetxt,#27#45#49+PadR(vedom_mas[nx,23],#32,10)+#27#45#48); //ats_reg
  write(filetxt,' Путевой лист N ');
  write(filetxt,#27#45#49+PadR(vedom_mas[nx,13],#32,10)+#27#45#48#13#10); //putevka
  write(filetxt,'Наименование рейса '+#27#69#27#45#49+' N ' +vedom_mas[nx,1]+'  '+vedom_mas[nx,5]+' - '+vedom_mas[nx,8]+#27#70#27#45#48#13#10);  //наименование рейса
  write(filetxt,'Время отправления по расписанию '+#27#69+PadC(vedom_mas[nx,10],#32,10)+#27#70+' Время отправления фактически '
  +#27#69+PadC(copy(vedom_mas[nx,11],1,2)+':'+copy(vedom_mas[nx,11],4,2),#32,7)+#27#70#13#10);

    vod3:='';
  vod4:='';
  //если по водителям есть данные паспорта
  If not(trim(vedom_mas[nx,16])='') then
    begin
      If utf8pos('@',vedom_mas[nx,16])>0 then
    begin
   //водитель 3 имя док
     vod3:=utf8copy(vedom_mas[nx,16],utf8pos('@',vedom_mas[nx,16])+1,utf8length(vedom_mas[nx,16])-utf8pos('@',vedom_mas[nx,16]));
     write(filetxt,'Водитель 1 '+vedom_mas[nx,14]+#32+utf8copy(vedom_mas[nx,16],1,utf8pos('@',vedom_mas[nx,16])-1));
    end
      else
      begin
        write(filetxt,'Водитель 1 '+ vedom_mas[nx,14]+#32+vedom_mas[nx,16] );
    end;

    end
  else
  begin
    write(filetxt,'Водитель 1 '+ PadR(vedom_mas[nx,14],#32,20) );
  end;

   //если по водителям есть данные паспорта
  If not(trim(vedom_mas[nx,17])='') then
    begin
      If utf8pos('@',vedom_mas[nx,17])>0 then
    begin
   //водитель 4 имя док
     vod4:=utf8copy(vedom_mas[nx,17],utf8pos('@',vedom_mas[nx,17])+1,utf8length(vedom_mas[nx,17])-utf8pos('@',vedom_mas[nx,17]));
     write(filetxt,' Водитель 2 '+ vedom_mas[nx,15]+#32+utf8copy(vedom_mas[nx,17],1,utf8pos('@',vedom_mas[nx,17])-1)+#13#10);
    end
      else
      begin
        write(filetxt,' Водитель 2 '+ vedom_mas[nx,15]+#32+vedom_mas[nx,17] +#13#10);
    end;
    end
  else
  begin
    write(filetxt,' Водитель 2 '+ PadR(vedom_mas[nx,15],#32,20) +#13#10);
  end;

  If (vod3<>'') or (vod4<>'') then
   begin
    If (vod3<>'') then
     write(filetxt,'Водитель 3 '+ vod3);
    If (vod4<>'') then
     write(filetxt,' Водитель 4 '+vod4);

     write(filetxt,#32#13#10);
   end;

  //write(filetxt,'Водитель 1 '+ PadR(vedom_mas[nx,14],#32,20)+' Водитель 2 '+PadR(vedom_mas[nx,15],#32,20)+#13#10);
  //If not((trim(vedom_mas[nx,16])='') or (trim(vedom_mas[nx,17])='')) then
  //  begin
  //   write(filetxt,'Водитель 3 '+PadR(vedom_mas[nx,16],#32,20)+' Водитель 4 '+PadR(vedom_mas[nx,17],#32,20)+#13#10);
  //  end;

  //writeln(filetxt,StringofChar(#32,120));//строка пробелов
  //cnt:=length(tick_mas);
  cnt:=0;
  fl_next:=false;
   //если напечатанных строчек больше maxticks, тогда печатаем на 2-х листах
  //If length(tick_mas)>maxticksM then cnt:=maxticksM;
  // Таблица - Начало 136 знаков
  If fldoc OR flfio then
    begin
     write(filetxt,#27#15);//включение режима сжатой печати
 //ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
  If spass=1 then
     begin
 //               | 5   |          24            |  6   |   9     |    10    |     13      |        21           |        22            |   7   |    11     |
  write(filetxt,' ____________________________________________________________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |     |                        |      |         |  Пункт   |             |                     |                      |Квитанция на провоз|'+#13#10);
  write(filetxt,' |Номер|           Номер        | Вид* |Стоимость|  отправ- |    Пункт    |       Документ      |        Ф. И. О.      |багажа/ручной клади|'+#13#10);
  write(filetxt,' |места| посадочного талона     |талона|         |  ления   | назначения  |                     |                      | кол-во|   сумма   |'+#13#10);
  write(filetxt,' |_____|________________________|______|_________|__________|_____________|_____________________|______________________|_______|___________|'+#13#10);
     end
     else
      begin
 //               | 5   |          24            |  6   |   9     |            24          |        21           |        22            |    7  |    11     |
  write(filetxt,' ____________________________________________________________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |     |                        |      |         |                        |                     |                      |Квитанция на провоз|'+#13#10);
  write(filetxt,' |Номер|           Номер        | Вид* |Стоимость|         Пункт          |       Документ      |        Ф. И. О.      |багажа/ручной клади|'+#13#10);
  write(filetxt,' |места|          билета        |билета|         |       назначения       |                     |                      | кол-во|   сумма   |'+#13#10);
  write(filetxt,' |_____|________________________|______|_________|________________________|_____________________|______________________|_______|___________|'+#13#10);
     end;
    end
  else
  begin
 //               | 5   |         24             |  6   |   9     |            21       |   7   |    11     |
  write(filetxt,' ____________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |     |                        |      |         |                     |Квитанция на провоз|'+#13#10);
  write(filetxt,' |Номер|         Номер          | Вид* |Стоимость|        Пункт        |багажа/ручной клади|'+#13#10);
  write(filetxt,' |места|        билета          |билета|         |     назначения      |кол-во |  сумма    |'+#13#10);
  write(filetxt,' |_____|________________________|______|_________|_____________________|_______|___________|'+#13#10);
  end;
  //:м.+--------+-------+       :      назначения          +--------+------+--+" + "-" + ":м.+--------+-------+       :       назначения         +---------------+--+
  //                        T1705201217290348833-77
//
  for n:=0 to length(tick_mas)-1 do
  begin
    //если это билет не этой ведомости, то пропускаем
    If tick_mas[n,4]<>'1' then continue;
    cnt:=cnt+1;
   //если напечатанных строчек больше maxticks, тогда печатаем на 2-х листах
  If cnt>maxticksM then
    begin
    fl_next:=true;
    break;
    end;
  write(filetxt,' |'+PadC(tick_mas[n,0],#32,5)+'|'); //номер места
  write(filetxt,PadR(tick_mas[n,1],#32,24)+'|');    //номер билета
  write(filetxt,PadC(utf8copy(tick_mas[n,16],1,6),#32,6)+'|');     //вид билета
  write(filetxt,PadC(tick_mas[n,10],#32,9)+'|');     //стоимость
  If fldoc OR flfio then
  begin
    If spass=1 then
     begin
       write(filetxt,PadC(utf8copy(tick_mas[n,20],1,10),#32,10)+'|');   //пункт отправления
       write(filetxt,PadC(utf8copy(tick_mas[n,7],1,13),#32,13)+'|');    //пункт назначения
      end
    else
     begin
       write(filetxt,PadC(utf8copy(tick_mas[n,7],1,24),#32,24)+'|');    //пункт назначения
     end;
  end
  else
   begin
   write(filetxt,PadC(utf8copy(tick_mas[n,7],1,21),#32,21)+'|');    //пункт назначения
   end;
   If fldoc OR flfio then
     begin
     If (tick_mas[n,12]='0') and not (trim(tick_mas[n,13])='') then viddoc:='паспорт:' else viddoc:='';
     write(filetxt,PadC(utf8copy(viddoc+tick_mas[n,13],1,20),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,11],1,20),#32,22)+'|');                   //фио
     end;
  write(filetxt,PadC(tick_mas[n,14],#32,7)+'|');                    //кол-во багажа
  write(filetxt,PadC(tick_mas[n,15],#32,11)+'|'+#13#10);                   //сумма багажа

        //если длина документа или фио больше ширины поля, то переносим на следующую строку
 If (fldoc OR flfio) and ((utf8length(tick_mas[n,13])>10) or (utf8length(tick_mas[n,11])>22)) then
     begin
     cnt:=cnt+1;
     write(filetxt,' |'+StringofChar(#32,5)+'|'); //номер места
     write(filetxt,StringofChar(#32,24)+'|');    //номер билета
     write(filetxt,StringofChar(#32,6)+'|');     //вид билета
     write(filetxt,StringofChar(#32,9)+'|');     //стоимость
     write(filetxt,StringofChar(#32,24)+'|');    //пункт назначения
     //write(filetxt,PadC(utf8copy(tick_mas[n,12]+': '+tick_mas[n,13],21,utf8length(tick_mas[n,12])),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,13],21,utf8length(tick_mas[n,13])),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,11],21,utf8length(tick_mas[n,11])),#32,22)+'|');                   //фио
     write(filetxt,StringofChar(#32,7)+'|');           //кол-во багажа
     write(filetxt,StringofChar(#32,11)+'|'+#13#10);   //сумма багажа
     end;
  end;
  k:=n;

  If fldoc OR flfio then
   //ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
     If spass=1 then
     //               | 5   |          24            |  6   |   9     |    10    |     13      |        21           |        22            |    7  |    11     |
      write(filetxt,' |_____|________________________|______|_________|__________|_____________|_____________________|______________________|_______|___________|'+#13#10)

       else
      write(filetxt,' |_____|________________________|______|_________|________________________|_____________________|______________________|_______|___________|'+#13#10)
    //                | 5   |          24            |  6   |   9     |            24          |        21           |          22          |    7  |    11     |
  else
     write(filetxt,' |_____|________________________|______|_________|_____________________|_______|___________|'+#13#10);
   //                | 5   |         24             |  6   |   9     |            21       |   7   |    11     |
  //Таблица - Конец

   //если билетов больше maxticksL печатаем дальше на другом листе
  If fl_next then
    begin
       write(filetxt,#12);//выброс листа
       write(filetxt,#32#13#10);//пустая строка
         // Таблица - Начало 136 знаков
  If fldoc OR flfio then
    begin
     write(filetxt,#27#15);//включение режима сжатой печати
     //ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
  If spass=1 then
     begin
  //              | 5   |          24            |  6   |   9     |    10    |     13      |        21           |        22            |    7   |    11     |
  write(filetxt,' ____________________________________________________________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |     |                        |      |         |  Пункт   |             |                     |                      |Квитанция на провоз:|'+#13#10);
  write(filetxt,' |Номер|        Номер           | Вид* |Стоимость|  отправ- |    Пункт    |       Документ      |        Ф. И. О.      |багажа/ручной клади |'+#13#10);
  write(filetxt,' |места|  посадочного талона    |талона|         |  ления   | назначения  |                     |                      | кол-во |   сумма   |'+#13#10);
  write(filetxt,' |_____|________________________|______|_________|__________|_____________|_____________________|______________________|________|___________|'+#13#10);
    end
    else
     begin
 //               | 5   |          24            |  6   |   9     |            24          |        21           |        22            |    7   |    11     |
  write(filetxt,' ____________________________________________________________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |     |                        |      |         |                        |                     |                      |Квитанция на провоз:|'+#13#10);
  write(filetxt,' |Номер|           Номер        | Вид* |Стоимость|         Пункт          |       Документ      |        Ф. И. О.      |багажа/ручной клади |'+#13#10);
  write(filetxt,' |места|          билета        |билета|         |       назначения       |                     |                      | кол-во |   сумма   |'+#13#10);
  write(filetxt,' |_____|________________________|______|_________|________________________|_____________________|______________________|________|___________|'+#13#10);
    end
    end
  else
  begin
 //               | 5   |         24             |  6   |   9     |            21       |   7   |    11     |
  write(filetxt,' ____________________________________________________________________________________________ '+#13#10);
  write(filetxt,' |     |                        |      |         |                     |Квитанция на провоз|'+#13#10);
  write(filetxt,' |Номер|         Номер          | Вид* |Стоимость|        Пункт        |багажа/ручной клади|'+#13#10);
  write(filetxt,' |места|        билета          |билета|         |     назначения      |кол-во |  сумма    |'+#13#10);
  write(filetxt,' |_____|________________________|______|_________|_____________________|_______|___________|'+#13#10);
  end;
  //:м.+--------+-------+       :      назначения          +--------+------+--+" + "-" + ":м.+--------+-------+       :       назначения         +---------------+--+
  //                        T1705201217290348833-77
//

  for n:=k to length(tick_mas)-1 do
  begin
    //если это билет не этой ведомости, то пропускаем
If tick_mas[n,4]<>'1' then continue;
  cnt:=cnt+1;
  write(filetxt,' |'+PadL(tick_mas[n,0],#32,5)+'|'); //номер места
  write(filetxt,PadR(tick_mas[n,1],#32,24)+'|');    //номер билета
  write(filetxt,PadC(utf8copy(tick_mas[n,16],1,6),#32,6)+'|');     //вид билета
  write(filetxt,PadC(tick_mas[n,10],#32,9)+'|');     //стоимость
 If fldoc OR flfio then
  begin
    If spass=1 then
     begin
       write(filetxt,PadC(utf8copy(tick_mas[n,20],1,10),#32,10)+'|');   //пункт отправления
       write(filetxt,PadC(utf8copy(tick_mas[n,7],1,13),#32,13)+'|');    //пункт назначения
      end
    else
     begin
       write(filetxt,PadC(utf8copy(tick_mas[n,7],1,24),#32,24)+'|');    //пункт назначения
     end;
  end
  else
   begin
   write(filetxt,PadC(utf8copy(tick_mas[n,7],1,21),#32,21)+'|');    //пункт назначения
   end;
   If fldoc OR flfio then
     begin
     If (tick_mas[n,12]='0') or (trim(tick_mas[n,13])='') then viddoc:='паспорт:' else viddoc:='';
     write(filetxt,PadC(utf8copy(viddoc+tick_mas[n,13],1,20),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,11],1,20),#32,22)+'|');                   //фио
     end;
  write(filetxt,PadC(tick_mas[n,14],#32,7)+'|');                    //кол-во багажа
  write(filetxt,PadC(tick_mas[n,15],#32,11)+'|'+#13#10);                   //сумма багажа

 //если уже напечатано половина мест и длина документа или фио больше ширины поля, то переносим на следующую строку
 If (k>length(tick_mas) div 2) and (fldoc OR flfio) and ((utf8length(tick_mas[n,13])>10) or (utf8length(tick_mas[n,11])>22)) then
     begin
       cnt:=cnt+1;
     write(filetxt,' |'+StringofChar(#32,5)+'|'); //номер места
     write(filetxt,StringofChar(#32,24)+'|');    //номер билета
     write(filetxt,StringofChar(#32,6)+'|');     //вид билета
     write(filetxt,StringofChar(#32,9)+'|');     //стоимость
     write(filetxt,StringofChar(#32,24)+'|');    //пункт назначения
     //write(filetxt,PadC(utf8copy(tick_mas[n,12]+': '+tick_mas[n,13],21,utf8length(tick_mas[n,12])),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,13],21,utf8length(tick_mas[n,13])),#32,21)+'|');//тип документа, номер
     write(filetxt,PadC(utf8copy(tick_mas[n,11],21,utf8length(tick_mas[n,11])),#32,22)+'|');//фио
     write(filetxt,StringofChar(#32,7)+'|');           //кол-во багажа
     write(filetxt,StringofChar(#32,11)+'|'+#13#10);   //сумма багажа
     end;
  end;

  If fldoc OR flfio then
        //ЕСЛИ ПЕЧАТЬ СПИСКА ПАССАЖИРОВ
  If spass=1 then
     //               | 5   |          24            |  6   |   9     |    10    |     13      |        21           |        22            |    7   |    11     |
      write(filetxt,' |_____|________________________|______|_________|__________|_____________|_____________________|______________________|________|___________|'+#13#10)
  else
      write(filetxt,' |_____|________________________|______|_________|________________________|_____________________|______________________|________|___________|'+#13#10)
    //                | 5   |          24            |  6   |   9     |            24          |         21          |          22          |    7   |    11     |
  else
     write(filetxt,' |_____|________________________|______|_________|_____________________|_______|___________|'+#13#10);
   //                | 5   |         24             |  6   |   9     |            21       |   7   |    11     |
  //Таблица - Конец

    end;

  //writeln(filetxt,StringofChar(#32,120));//строка пробелов
  write(filetxt,#27#15);//включение режима сжатой печати
   If spass=1 then
     write(filetxt,' *- П -полный, Д -детский, К -карта, ПА -иные лица, ПИ -интернет, Б -багаж'+#13#10)
   else
     write(filetxt,' *- П -полный, Д -детский, Л -льготный, В -воинский, К -карта, ПА -иные лица, ПИ -интернет, Б -багаж'+#13#10);
  write(filetxt,#32#13#10);//пустая строка
  write(filetxt,#18#27#77#27#65#12);////отменить сжатый текст, установить шрифт 12 p/i, межстрочный интервал = n/72
  //служебка от 07.06.2018 на отображение снятой брони при продаже коротких билетов
    If length(arbron2)>0 then
   begin
   write(filetxt,'ВНИМАНИЕ!!! СНЯТА БРОНЬ с мест: '+#13#10);
      for j:=low(arbron2) to high(arbron2) do
      begin
         write(filetxt,'место № '+arbron2[j,1]+' -- '+arbron2[j,0]+' '+#13#10);
      end;
   end;
    setlength(arbron2,0,0);

     If length(arbron)>0 then
   begin
   write(filetxt,'ВНИМАНИЕ !!! '+#13#10);
      for j:=low(arbron) to high(arbron) do
      begin
         write(filetxt,arbron[j,0]+': забронировано - '+arbron[j,1]+' место'+#13#10);
      end;
   end;
     setlength(arbron,0,0);
  write(filetxt,'Количество транзитных пассажиров: '+inttostr(tranzit)+#13#10);
  If spass=1 then
  begin
   write(filetxt,'Количество посадочных талонов: ');
   write(filetxt,#27#69+ vedom_mas[nx,28]+#27#70); //кол-во билетов
   write(filetxt,' на сумму: ' +#27#69+ vedom_mas[nx,29]+#27#70); //итоговая стоимость билетов наличная
   write(filetxt,' руб.'+#13#10);
  end
  else
  begin
  write(filetxt,'Количество пассажирских билетов: ');
  write(filetxt,#27#69+ vedom_mas[nx,28]+#27#70); //кол-во билетов
  write(filetxt,' на сумму: ' +#27#69+ vedom_mas[nx,29]+#27#70); //итоговая стоимость билетов наличная
  write(filetxt,' руб., в том числе: '+#13#10);
  //write(filetxt,'страховой сбор на сумму: ' +#27#69+ vedom_mas[nx,32]+#27#70); //сумма страхового сбора
  //write(filetxt,' руб.,'+#13#10);
  write(filetxt,'воинские билеты: ' +#27#69+ vedom_mas[nx,33]+#27#70); //кол-во воинских
  write(filetxt,' на сумму: ' +#27#69+ vedom_mas[nx,35]+#27#70); //сумма воинских
  write(filetxt,' руб. (безналичный расчет)'+#13#10);
  write(filetxt,'льготные билеты: ' +#27#69+ vedom_mas[nx,36]+#27#70); //кол-во воинских
  write(filetxt,' на сумму: ' +#27#69+ vedom_mas[nx,38]+#27#70); //сумма воинских
  write(filetxt,' руб. (безналичный расчет)'+#13#10);
  end;
    If creditcard>0 then
  begin
    write(filetxt,'по банковским картам: ' +#27#69+ inttostr(creditcard)+#27#70); //кол-во по платежным картам
  write(filetxt,' на сумму: ' +#27#69+ floattostrF(card_credit,fffixed,10,2)+#27#70); //сумма
  write(filetxt,' руб.(безналичный расчет)'+#13#10);
  end;
  write(filetxt,'Количество квитанций на провоз багажа/ручной клади: ' +#27#69+ vedom_mas[nx,30]+#27#70); //багаж кол-во
  write(filetxt,' на сумму: ' +#27#69+ vedom_mas[nx,31]+#27#70+' руб.'+#13#10); //багаж сумма
  write(filetxt,#32#13#10);//пустая строка
    If spass=1 then
    write(filetxt,'                           Дата и время печати списка: '+#27#69+FormatDateTime('dd-mm-yyyy',Date())+'  '+FormatDateTime('hh:nn',time())+#27#70#13#10)
    else
    write(filetxt,'                           Дата и время печати ведомости: '+#27#69+FormatDateTime('dd-mm-yyyy',Date())+'  '+FormatDateTime('hh:nn',time())+#27#70#13#10);
  write(filetxt,#32#13#10);//пустая строка

  write(filetxt,'  Деж. диспетчер '+PadR(#32#32#32,'_',10)+#27#45#49+PadR(vedom_mas[nx,27],#32,15)+#27#45#48); //диспетчер имя
  write(filetxt,StringofChar(#32,10)+' Перронный контролер '+PadR(#32,'_',10)+#12#13#10); //для подписи //следующий лист

   closefile(filetxt);
   except
    // Если ошибка - отобразить её
    on E: EInOutError do
      showmessagealt('Ошибка создания файла ведомости на матричном принтере !'+#13+'Детали: '+E.ClassName+'/'+E.Message);
  end;
 end;

  //открыть ведомость на просмотр и печать
 //start_stop_idle(timeout_schema);


 FormV:=TFormV.create(self);
 FormV.ShowModal;
 FreeAndNil(FormV);
 {$ENDIF}
 Setlength(vedom_mas,0,0);
 vedom_mas := nil;
 Setlength(tick_mas,0,0);
 tick_mas := nil;

end;
//---------------------------------------------------------------------------------------------



//**********************               фильтруем рейсы по контекстному поиску   ************************************
procedure TForm1.qsearch(mode:byte);
// mode = 1 //цифры искать среди расписаний и времени прибытия/отправления
// mode = 2 //буквы искать среди наименования рейсов
var
  n,m,posnext: integer;
  k:byte;
  lg: boolean=false;//нашли рейс
  lg2: boolean=false;
  stmo,tmp2,ssecond,sfirst:string;
  tmas:array of integer; // массив рейсов по фильтру
begin
  If length(full_mas)=0 then exit;
  If not mainsrv then
     Setlength(filtr_mas,0); //сбрасываем массив-результат
  stmo:=trimleft(form1.Edit1.Text);

//цифры
  If mode=1 then
     begin
       If (stmo<>'0') then
         begin
         for n:=low(full_mas) to high(full_mas) do
         begin
           //если нашли среди расписаний
           If (stmo=full_mas[n,1]) then
           begin
             Setlength(filtr_mas,length(filtr_mas)+1);
             filtr_mas[length(filtr_mas)-1]:=n;
             lg:=true;
           end;
         end;
         end;
         //если не нашли, ищем среди времени
         If not lg OR (stmo='0') then
           begin
            If (UTF8length(stmo)>2) then
              begin
              stmo:= StringReplace(stmo,' ',':',[]);//[rfReplaceAll, rfIgnoreCase]);
              If (stmo[3] in ['0'..'9']) then  stmo:=copy(stmo,1,2)+':'+copy(stmo,3,UTF8length(stmo));
              end;

             for n:=low(full_mas) to high(full_mas) do
               begin
                 If (full_mas[n,16]='1') AND (UTF8pos(stmo,full_mas[n,10])>0) then
                   begin
                   Setlength(filtr_mas,length(filtr_mas)+1);
                   filtr_mas[length(filtr_mas)-1]:=n;
                   end;
                 If (full_mas[n,16]='2') AND (UTF8pos(stmo,full_mas[n,12])>0) then
                   begin
                    Setlength(filtr_mas,length(filtr_mas)+1);
                    filtr_mas[length(filtr_mas)-1]:=n;
                   end;
               end;
           end;
     end;
  //буквы
  if mode=2 then
       begin
         stmo:=UPPERALL(stmo);
         tmp2:='';
         //если первые 2 буквы совпадает с наименованием точки продажи, выводить наименование точки продажи
         If (stmo=Utf8copy(server_name,1,2)) and not mainsrv then
           begin
             form1.Edit1.Text:=server_name+#32;
             form1.Edit1.SelLength:=0;
             form1.Edit1.SelStart:=length(form1.Edit1.Text);
             //KeyInput.Press(VK_END);
             mainsrv:=true;//флаг нахождения локального сервера в контекстом поиске
             //exit;
           end;
         lg:= false;

        //Сначала ищем пункты отправления и прибытия по полному совпадению в введенном тексте
         for n:=low(full_mas) to high(full_mas) do
          //if UPPERALL(UTF8Copy(trim(mas_atp[n,1]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
         begin
          //начальный пункт
          sfirst:= trim(stmo);
          //showmessage(UPPERALL(full_mas[n,5])+' | '+UPPERALL(UTF8copy(full_mas[n,5],1,Utf8length(trim(stmo)))));
           IF (UPPERALL(UTF8copy(full_mas[n,5],1,Utf8length(sfirst)))=sfirst)
              OR (UPPERALL(UTF8copy(full_mas[n,8],1,Utf8length(sfirst)))=sfirst)
           then
            begin
             lg:=true;
             Setlength(filtr_mas,length(filtr_mas)+1);
             filtr_mas[length(filtr_mas)-1]:=n;
            end;
           end;
        //конец поиска

        //Если не находим, и есть пробелы, то ищем с конца строки до пробела
        If not lg and (utf8pos(#32,sfirst)>0) and not mainsrv then
         begin
        // обрезаем введенный текст с конца до пробела и снова ищем пункт отправления
         for m:=utf8length(sfirst) downto 2 do
           begin
            ssecond:=utf8copy(sfirst,m,1);
             If ssecond<>#32 then continue;
             //label44.Caption:=sfirst;
             //kol := kol -1 ;
         //If trim(tmp2)<>'' then showmessage(tmp2);

         //начало поиска
        for n:=low(full_mas) to high(full_mas) do
          //if UPPERALL(UTF8Copy(trim(mas_atp[n,1]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
         begin
          //начальный пункт
           IF UPPERALL(UTF8copy(full_mas[n,5],1,m-1))=UTF8copy(sfirst,1,m-1) then
            begin
             lg:=true;
             //добавляем найденный рейс в массив-результат
             Setlength(filtr_mas,length(filtr_mas)+1);
             filtr_mas[length(filtr_mas)-1]:=n;
             posnext:=m;
            end;
           end;
            If lg then break;
        //конец поиска
           end;
         end;

        If mainsrv then
         begin
           sfirst:=trim(utf8copy(sfirst,utf8length(server_name)+1,utf8length(sfirst)-utf8length(server_name)));
           mainsrv:=false;
           If (form1.Edit1.Text=server_name+#32) then exit;
         end;
        lg2:=false;
        //если есть пробелы, то можно поискать пункты прибытия
        If (utf8pos(#32,sfirst)>0) then
        begin
       //если нашли пункт отправления,то ищем пункт прибытия в уже найденных рейсах
        If lg then
         begin
         Setlength(tmas,0);
           ssecond:= trimleft(utf8copy(sfirst,posnext+1,utf8length(sfirst)-posnext));
        If utf8length(ssecond)>0 then
         begin
            for n:=low(filtr_mas) to high(filtr_mas) do
          //if UPPERALL(UTF8Copy(trim(mas_atp[n,1]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
           begin
           //Если нашли конечный пункт, то добавляем во временный массив
            IF (UPPERALL(UTF8copy(full_mas[filtr_mas[n],8],1,Utf8length(ssecond)))=ssecond) then
            begin
             lg2:=true;
             Setlength(tmas,length(tmas)+1);
             tmas[length(tmas)-1]:=filtr_mas[n];
            end;
           end;
            end;
           end
        else
         //если НЕ нашли пункт отправления,то ищем пункты прибытия в во всем массиве по части строки
         begin
           // обрезаем введенный текст с конца до пробела и снова ищем пункт прибытия
         for m:=utf8length(sfirst) downto 3 do
           begin
             If sfirst[m]<>#32 then continue;
         //начало поиска
        for n:=low(full_mas) to high(full_mas) do
          //if UPPERALL(UTF8Copy(trim(mas_atp[n,1]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
         begin
          //пункт прибытия
           IF UPPERALL(UTF8copy(full_mas[n,8],1,m-1))=UTF8copy(sfirst,1,m-1) then
            begin
             lg:=true;
             //добавляем найденный рейс в массив-результат
             Setlength(filtr_mas,length(filtr_mas)+1);
             filtr_mas[length(filtr_mas)-1]:=n;
             posnext:=m;
            end;
          end;
            If lg then break;
        //конец поиска
           end;
         end;

          //Если не находим, то считаем количество пробелов в строке
       // If not lg2 then
       //  begin
       // // обрезаем введенный текст с конца до пробела и снова ищем пункт отправления
       //  while (lg2=false) AND (utf8pos(#32,ssecond)>0) do
       //    begin
       //      ssecond:=trim(UTF8copy(ssecond,1,utf8pos(#32,ssecond)-1));
       //      //label44.Caption:=ssecond;
       //      //kol := kol -1 ;
       //  //If trim(tmp2)<>'' then showmessage(tmp2);
       //IF (trim(ssecond)<>'') then
       // begin
       //  //начало поиска
       // for n:=low(filtr_mas) to high(filtr_mas) do
       //   //if UPPERALL(UTF8Copy(trim(mas_atp[n,1]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
       //  begin
       //   //начальный пункт
       //    IF (UPPERALL(UTF8copy(full_mas[n,5],1,Utf8length(ssecond)))=ssecond) then
       //     begin
       //      lg:=true;
       //      //добавляем найденный рейс в массив-результат
       //      Setlength(tmas,length(tmas)+1);
       //      tmas[length(tmas)-1]:=n;
       //       end;
       //     end;
       //    end;
       // //конец поиска
       //  end;
       //end;

        //переписываем результативный массив
       If lg2 then
         begin
        Setlength(filtr_mas,0);
        for n:=low(tmas) to high(tmas) do
         begin
             Setlength(filtr_mas,length(filtr_mas)+1);
             filtr_mas[length(filtr_mas)-1]:=tmas[n];
           end;
         end;
        end;
        end;

       //  else
       //  //!!!!!!!!!!!!!!!    если не нашли пункт отправления, то ищем пункты прибытия в full_mas  !!!!!!!!!!!!!!!!!!!!!!!
       //  begin
       //  ssecond := trimleft(stmo);
       //    //Сначала ищем полное совпадениее текста с пунктом прибытия  в введенном тексте
       //  for n:=low(full_mas) to high(full_mas) do
       //  begin
       //    IF (UPPERALL(UTF8copy(full_mas[n,8],1,Utf8length(ssecond)))=ssecond) then
       //     begin
       //      lg:=true;
       //       Setlength(filtr_mas,length(filtr_mas)+1);
       //       filtr_mas[length(filtr_mas)-1]:=n;
       //     end;
       //    end;
       // //конец поиска
       //
       // //Если не находим, то считаем количество пробелов в строке
       // If not lg2 then
       //  begin
       // // обрезаем введенный текст с конца до пробела и снова ищем пункт прибытия
       //  while (lg=false) AND (utf8pos(#32,ssecond)>0) do
       //    begin
       //      ssecond:=trim(UTF8copy(ssecond,1,utf8pos(#32,ssecond)-1));
       //      //label44.Caption:=ssecond;
       //      //kol := kol -1 ;
       //  //If trim(tmp2)<>'' then showmessage(tmp2);
       //IF (trim(ssecond)<>'') then
       // begin
       //  //начало поиска
       // for n:=low(full_mas) to high(full_mas) do
       //   //if UPPERALL(UTF8Copy(trim(mas_atp[n,1]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
       //  begin
       //   //начальный пункт
       //    IF (UPPERALL(UTF8copy(full_mas[n,5],1,Utf8length(ssecond)))=ssecond) then
       //     begin
       //      lg:=true;
       //      //добавляем найденный рейс в массив-результат
       //       Setlength(filtr_mas,length(filtr_mas)+1);
       //       filtr_mas[length(filtr_mas)-1]:=n;
       //     end;
       //    end;
       // //конец поиска
       //  end;
       //    end;
       //  end;
       //  end;
       //end;
  Setlength(tmas,0);
  tmas := nil;
end;


//*******************************     стать на строку грида по текущему времени      *******************************
procedure set_row_time;
var
  tmp1,tmp2:string;
  tmn1,tmn2,n:integer;
  flup:boolean=false;
begin
  With form1 do
begin
  If Stringgrid1.RowCount<2 then exit;
  If trim(stringgrid1.Cells[1,stringgrid1.Row])='' then exit;
  //текущее время
  tmp1:=FormatDateTIme('hhnn',now());
  //время рейса, на котором стою
  tmp2:=trim(stringgrid1.Cells[2,stringgrid1.Row]);
  tmp2:=copy(tmp2,1,2)+copy(tmp2,4,2);
  try
    tmn1 := strtoint(tmp1);
  except
    on exception: EConvertError do exit;
  end;
  try
    tmn2 := strtoint(tmp2);
  except
    on exception: EConvertError do exit;
  end;
  If tmn1>tmn2 then flup:=true else flup:=false;
  //если стою на строке с временем, меньше текущего
  If flup then
    begin
      for n:=stringgrid1.Row to stringgrid1.RowCount-1 do
        begin
          tmp2:=trim(stringgrid1.Cells[2,n]);
          tmp2:=copy(tmp2,1,2)+copy(tmp2,4,2);
          try
            tmn2 := strtoint(tmp2);
          except
            on exception: EConvertError do exit;
          end;
          If tmn1<tmn2 then
            begin
              stringgrid1.Row:=n+8;
              stringgrid1.Row:=n;
              break;
            end;
        end;
    end
  else
  //если стою на строке с временем, больше текущего
  begin
      for n:=stringgrid1.Row downto 1 do
        begin
          tmp2:=trim(stringgrid1.Cells[2,n]);
          tmp2:=copy(tmp2,1,2)+copy(tmp2,4,2);
          try
            tmn2 := strtoint(tmp2);
          except
            on exception: EConvertError do exit;
          end;
          If tmn1>tmn2 then
            begin
              stringgrid1.Row:=n+8;
              stringgrid1.Row:=n+1;
              break;
            end;
        end;
    end
end;
end;


//*************************************    Сортируем массив full_mas   *******************************************
//======== ФИЛЬТР/СОРТИРОВКА  ========
            //0: ВСЕ ПОСЛЕ ВЫБОРА ДАТЫ  (результаты поиска)
            //1: ВСЕ АКТИВНЫЕ НА ТЕКУЩУЮ ДАТУ И ВРЕМЯ (СЕГОДНЯ)
            //2: РЕЙСЫ ТЕКУЩЕГО РАСПИСАНИЯ
            //3: РЕЙСЫ ОТПРАВЛЕНИЯ АКТИВНЫЕ
            //4: РЕЙСЫ ПРИБЫТИЯ АКТИВНЫЕ
            //5: РЕЙСЫ НЕАКТИВНЫЕ
            //6: РЕЙСЫ УДАЛЕНКИ
function TForm1.sort_full_mas(sposob:byte):integer;
  var
   n,m,k,lg:integer;
   t1,t2:string;
   tn1,tn2:integer;
   tmp_mas:array of string;
   artmp: array of array of string;
   arhigh:integer=0;
begin
  Result:=0; //отображать все строчки массива
//0:
//1: По времени При добавлении рейсов или ПОСЛЕ ВЫБОРА ДРУГОЙ ДАТЫ
SetLength(filtr_mas,0);

 if sposob=1 then
  begin
   SetLength(tmp_mas,0);
   SetLength(tmp_mas,full_mas_size);
   //showmessage(inttostr(length(full_mas)));
   for n:=0 to length(full_mas)-2 do
     begin

      if n=length(full_mas)-1 then exit;
      //пропускаем неактивные рейсы
      If (full_mas[n,22]='0') then continue;
      if trim(full_mas[n,16])='1' then t1:=trim(full_mas[n,10])
        else t1:=trim(full_mas[n,12]);
      try
      tn1:=strtoint(copy(t1,1,2)+copy(t1,4,2));
      except
       on exception: EConvertError do
      begin
       showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+t1+#13+'--c25');
       continue;
      end;
      end;
       for m:=n to length(full_mas)-1 do
         begin
            //пропускаем неактивные рейсы
         If (full_mas[m,22]='0') then continue;
           // 1 отправ , 2 приб
           if trim(full_mas[m,16])='1' then t2:=trim(full_mas[m,10]) else t2:=trim(full_mas[m,12]);
        try
           tn2:=strtoint(copy(t2,1,2)+copy(t2,4,2));
        except
           on exception: EConvertError do
      begin
       showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+t2+#13+'--c26');
       continue;
      end;
        end;
           // Меняем с большего на меньшее
           if tn1>tn2 then
            begin
              for k:=0 to full_mas_size-1 do
                begin
                  tmp_mas[k]:=trim(full_mas[n,k]);
                  full_mas[n,k]:=full_mas[m,k];
                  full_mas[m,k]:=tmp_mas[k];
                end;
              t1:=t2;
              try
              tn1:=strtoint(copy(t1,1,2)+copy(t1,4,2));
              except
               on exception: EConvertError do
      begin
       showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+t1+#13+'--c27');
       continue;
      end;
        end;
              SetLength(tmp_mas,0);
              SetLength(tmp_mas,full_mas_size);
            end;
         end;
     end;
   SetLength(tmp_mas,0);
   tmp_mas:=nil;
   exit;
  end;

//2: РЕЙСЫ ТЕКУЩЕГО РАСПИСАНИЯ
 if sposob=2 then //предполагается уже отсортированный по способу 4 массив
  begin
   m:=0;
   //находим все рейсы данного расписания
   for n:=low(full_mas) to high(full_mas) do
     begin
       If (full_mas[masindex,1]=full_mas[n,1]) then
       begin
           Setlength(filtr_mas,length(filtr_mas)+1);
           filtr_mas[length(filtr_mas)-1]:=n;
          m:=m+1;
       end;
     end;
   result:=m;
  end;

 //3: РЕЙСЫ ОТПРАВЛЕНИЯ АКТИВНЫЕ
 if sposob=3 then //предполагается уже отсортированный по времени массив
  begin
   m:=0;
    for n:=low(full_mas) to high(full_mas) do
     begin
       //If n=arhigh+1 then break; //дошли до предела
      //если рейс отправления, то помещаем его наверх массива
      if (full_mas[n,16]='1') AND (full_mas[n,22]<>'0') then
        begin
          Setlength(filtr_mas,length(filtr_mas)+1);
          filtr_mas[length(filtr_mas)-1]:=n;
          m:=m+1;
          //showmessage(inttostr(tn1)+'|'+inttostr(n)+'|'+inttostr(g));
        end;
      end;
   result:=m;
  end;

  //4: РЕЙСЫ ПРИБЫТИЯ АКТИВНЫЕ
 if sposob=4 then //предполагается уже отсортированный по способу 2 массив
  begin
   m:=0;
   for n:=low(full_mas) to high(full_mas) do
     begin
       if (full_mas[n,16]='2') AND (full_mas[n,22]<>'0') then
       begin
          Setlength(filtr_mas,length(filtr_mas)+1);
                   filtr_mas[length(filtr_mas)-1]:=n;
          m:=m+1;
       end;
    end;
   result:=m;
  end;

 //5: РЕЙСЫ НЕАКТИВНЫЕ
  if sposob=5 then //предполагается уже отсортированный по способу 3 массив
  begin
   m:=0;
   for n:=low(full_mas) to high(full_mas) do
     begin
        if (full_mas[n,22]='0') then
       begin
       Setlength(filtr_mas,length(filtr_mas)+1);
           filtr_mas[length(filtr_mas)-1]:=n;
          m:=m+1;
       end;
    end;
   result:=m;
  end;

  //6: РЕЙСЫ УДАЛЕНКИ
 if sposob=6 then
  begin
   m:=0;
   //находим все рейсы данного расписания
   for n:=low(full_mas) to high(full_mas) do
     begin
       If (full_mas[n,0]='3') or (full_mas[n,0]='4') or (full_mas[n,0]='5') then
       begin
           Setlength(filtr_mas,length(filtr_mas)+1);
           filtr_mas[length(filtr_mas)-1]:=n;
          m:=m+1;
       end;
     end;
   result:=m;
  end;

end;


//*****************************       вывести панель с номером платформы        *****************
procedure TForm1.platform_get;
var
  plat:integer=0;
  n:integer;
begin
  with Form1 do
begin
  //находим элемент массива
  //n := arr_get();
  If masindex=-1 then exit;
   try
     //plat:=strtoint(form1.StringGrid1.Cells[7,form1.StringGrid1.RowCount-1])
     plat:=strtoint(full_mas[masindex,2]);
   except
     on exception: EConvertError do
      begin
       showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+full_mas[masindex,2]+#13+'--c28');
       exit;
      end;
   end;
   If plat=0 then exit;
   //настройка и отображение панели со спином платформы
   Panel3.Left:=362;
   Panel3.Top :=290;
   Panel3.height:=160;
   Panel3.width :=300;
   Label18.top:=15;
   Label18.left:=40;
   Label18.Caption := 'Введите новое значение:';
   SpinEdit1.Left:=105;
   SpinEdit1.Top :=70;
   SpinEdit1.height:=45;
   SpinEdit1.width :=90;
   Panel3.visible:=true;
   SpinEdit1.visible:=true;
   SpinEdit1.Value:=plat;
   SpinEdit1.Setfocus;
end;
end;

//********************************     найти элемент массива из грида ***********************************
function arr_get():integer;
var
  n:integer;
  priz:byte=0;
begin
Result:=-1;
With Form1 do
begin
 If Stringgrid1.enabled=false then
    begin
    showmessage('СПИСОК РЕЙСОВ НЕ ВИДЕН !');
    EXIT;
    end;
  If Stringgrid1.RowCount<2 then exit;
  If trim(stringgrid1.Cells[1,stringgrid1.Row])='' then exit;
  If length(full_mas)<1 then exit;
 If StringGrid1.Cells[3,StringGrid1.Row]='ОТПР' then priz:=1;
 If StringGrid1.Cells[3,StringGrid1.Row]='ПРИБ' then priz:=2;
  for n:=low(full_mas) to high(full_mas) do
    begin
       If ((priz=1) AND (trim(full_mas[n,16])='1')) OR ((priz=2) AND (trim(full_mas[n,16])='2')) then
         begin
           If (trim(Stringgrid1.Cells[1,Stringgrid1.row])=full_mas[n,1])
           AND (StringGrid1.Cells[4,StringGrid1.Row]=trim(full_mas[n,5])+' - '+trim(full_mas[n,8])) then
           begin
            //----- Время прибытия
            If (priz=2) AND (StringGrid1.Cells[2,StringGrid1.Row]=full_mas[n,12]) then
              begin
                Result:=n;
                break;
              end;
            //----- Время отправления
           If (priz=1) AND (StringGrid1.Cells[2,StringGrid1.Row]=full_mas[n,10]) then
             begin
             Result:=n;
             break;
             end;
           end;
         end;
    end;
end;
end;


procedure TForm1.SpinDate1Change(Sender: TObject);
begin
  form1.Label4.Caption:=
  GetDayName(dayoftheweek(form1.SpinDate1.date));
end;

procedure TForm1.IdleTimer1StartTimer(Sender: TObject);
begin
  timeout_local:=0;
end;

procedure TForm1.IdleTimer1Timer(Sender: TObject);
begin
  timeout_local:=timeout_local+1;
  if timeout_local=timeout_global then
     begin
      flclose:=true;
      FormIdle:=TFormIdle.create(self);
      FormIdle.Height:=160;
      FormIdle.width:=form1.Width;
      FormIdle.Left:=form1.Left;
      FormIdle.top:=form1.top+(form1.Height div 2)-(FormIdle.Height div 2);
      info := 'Окно АВТОМАТИЧЕСКИ ЗАКРОЕТСЯ через  ';
      FormIdle.ShowModal;
      freeandnil(FormIdle);
     end;
end;

procedure TForm1.IdleTimer2StartTimer(Sender: TObject);
begin
   timeout_main_tik:=0;
end;




//**************************               Запускаем\Останавливаем таймер простоя
procedure TForm1.start_stop_idle(sec_timeout:integer);
begin
 if sec_timeout>0 then
    begin
     timeout_local:=0;
     timeout_global:=sec_timeout;
     //запускаем таймер простоя
     form1.IdleTimer1.Enabled:=true;
     form1.IdleTimer1.AutoEnabled:=true;
     //останавливаем таймер обновления экрана
     form1.IdleTimer2.AutoEnabled:=false;
     form1.IdleTimer2.Enabled:=false;
    end
 else
   begin
     form1.IdleTimer1.AutoEnabled:=false;
     form1.IdleTimer1.Enabled:=false;
     form1.IdleTimer2.Enabled:=true;
     form1.IdleTimer2.AutoEnabled:=true;
     timeout_local:=0;
     timeout_global:=0;
   end;
end;


//*******************************    ОКНО ПАРАМЕТРОВ РЕЙСА ****************************************
procedure TForm1.trip_data();
begin
//***** operation ********
  //+1: ОТПРАВИТЬ РЕЙС
  //+2: ОТМЕТИТЬ ПРИБЫТИЕ РЕЙСА
  //3: ОТКРЫТЬ ВЕДОМОСТЬ ДООБИЛЕЧИВАНИЯ
  //4: ОТМЕНИТЬ РЕЙС
  //+5: СМЕНИТЬ АТП
  //+6: ЗАБРОНИРОВАТЬ местА
  //+7: СМЕНИТЬ АТС
  //8: ОТМЕТКА ОПОЗДАНИЯ РЕЙСА
  //+9: ВЫЧЕРКНУТЫЕ БИЛЕТЫ
  //+10: ЗАДАТЬ НОМЕР ПЛАТФОРМЫ
  //+11: СОЗДАТЬ ЗАКАЗНОЙ РЕЙС
  //12: РЕЙС ЗАКРЫТЬ/СНЯТЬ ОТМЕТКУ СОСТОЯНИЯ (СРЫВА,ЗАКРЫТИЯ,ОПОЗДАНИЯ,ПРИБЫТИЯ)
  //

 tickets_blocked:=0;//заблокированные билеты
 zakaz_shed:='';
 zakaz_time:='';

  If (operation=3) OR (operation=4) OR (operation=8) OR (operation=12) then
    begin
     exit;
    end;

 //ОКНО ДАННЫХ РЕЙСА
   If (operation=1) OR (operation=5) OR (operation=7) oR (operation=2) then
    begin
  //остановить таймер обновления экрана
   // If (operation<>1) then getfreeseats(masindex);   // РАСЧЕТ СВОБОДНЫХ МЕСТ НА РЕЙС
  //form1.IdleTimer2.Enabled:=false;

    //ОТКРЫВАЕМ ТРАНЗАКЦИЮ
    formMenu.insert_oper(form1.Zconnection1,form1.ZReadOnlyQuery1,form1.ZReadOnlyQuery3,operation);

    //если операция сброшена (кто-то держит или ошибки в транзакции), то - отвал
   //если транзакция отменена (кто-то держит или нет записей для блокировки), то - отвал
    If operation=0 then exit;
        start_stop_idle(timeout_trip);
        timeout_signal:=timeout_trip;//*
        Form2:=TForm2.create(self);
        Form2.ShowModal;
        FreeAndNil(Form2);
        start_stop_idle(0);

    //если транзакция еще открыта - откатываемся
    If form1.Zconnection1.Connected then
      begin
       form1.ZReadOnlyQuery1.Close;
       form1.ZReadOnlyQuery3.Close;
       If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
       form1.ZConnection1.disconnect;
       end;
           //try
           //  form1.ZReadOnlyQuery3.ExecSql;
           //  form1.Zconnection1.Commit;
           //except
           //  If ZConnection1.InTransaction then Zconnection1.Rollback;
           //  showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL2: '+form1.ZReadOnlyQuery3.SQL.Text);
           //end;
           //end;
    end;


 //ЗАКАЗНОЙ РЕЙС ОКНО ДАННЫХ РЕЙСА
  If (operation=11) then
    begin
  //остановить таймер обновления экрана
  //form1.IdleTimer2.Enabled:=false;
    start_stop_idle(timeout_zakaz);
    timeout_signal:=timeout_zakaz;//*
    Form2:=TForm2.create(self);
    Form2.ShowModal;
    FreeAndNil(Form2);
    start_stop_idle(0);
  //запустить таймер обновления экрана
  //form1.IdleTimer2.Enabled:=true;
    end;

   //Бронирование мест
 If (operation=6) then
   begin
       //bron_edit:=true;
       //открываем транзакцию
      formMenu.insert_oper(form1.Zconnection1,form1.ZReadOnlyQuery1,form1.ZReadOnlyQuery3,operation);
        //If ZConnection1.InTransaction then showmessage('in');//$
    //если транзакция отменена (кто-то держит рейс или билеты на него), то - отвал
    If (operation=0) then exit;
    //открыть окно карты автобуса для бронирования и вычеркнутых
      form1.start_stop_idle(timeout_ats);
      timeout_signal:=timeout_ats;//*
      Form7:=TForm7.create(self);
      Form7.ShowModal;
      FreeAndNil(Form7);
      form1.start_stop_idle(0);
    //если транзакция еще открыта - откатываемся
    If form1.Zconnection1.Connected then
      begin
       form1.ZReadOnlyQuery1.Close;
       form1.ZReadOnlyQuery3.Close;
       If ZConnection1.InTransaction then Zconnection1.Rollback;
       form1.ZConnection1.disconnect;
       end;
    end;

    //вычеркнутые места
 If (operation=9) then
   begin
       //bron_edit:=true;
       //открываем транзакцию
      formMenu.insert_oper(form1.Zconnection1,form1.ZReadOnlyQuery1,form1.ZReadOnlyQuery3,operation);
        //If ZConnection1.InTransaction then showmessage('in');//$
    //если транзакция отменена (кто-то держит рейс или билеты на него), то - отвал
    If (operation=0) then exit;
    //открыть окно карты автобуса для вычеркнутых
      form1.start_stop_idle(timeout_ats);
      timeout_signal:=timeout_ats;//*
      Form9:=TForm9.create(self);
      Form9.ShowModal;
      FreeAndNil(Form9);
      form1.start_stop_idle(0);
    //если транзакция еще открыта - откатываемся
    If form1.Zconnection1.Connected then
      begin
       form1.ZReadOnlyQuery1.Close;
       form1.ZReadOnlyQuery3.Close;
       If ZConnection1.InTransaction then Zconnection1.Rollback;
       form1.ZConnection1.disconnect;
       end;
    end;

  //смена платформы
  If operation=10 then
    begin
    form1.platform_get();
    operation:=0;
    end;
end;


//*************************************************    HOT KEYS  *************************************************
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  n_row,n,rs,tw,cntmas:integer;
begin
 // Обнуляем таймаут
  //global_timeout:=0;
 //showmessage(inttostr(key));
  //если выполняется обновление грида - выход
  if (active_check=true) AND (key<>27) AND not(form1.Edit1.Focused) then
       begin
         //showmessage('1');
         key:=0;
         exit;
       end;
  // F1
   if Key=112 then
     begin
     key:=0;
     showmessagealt('[F1] - Справка'+#13+'[ENTER] - МЕНЮ'+#13+'[F2] - Выбор даты'+#13+'[F3] - Состав и Тариф'+#13+'[F4] - Схема автобуса'+#13
     +'[F5] - Поиск пассажира'+#13
     +'[F6] - Ведомости рейса'+#13+'[F7] - Свободные места'+#13+'[F8] - Объявление опаздывающим'+#13+'[F9] - Рейсы других пунктов продаж'+#13
     +'[F10] - Печать АКТа за ТС'+#13
     +'[F11] - Объявление свободные места'+#13
     +'[F12] - Снятие зависших билетов/рейсов'+sLineBreak
     +'[ПРОБЕЛ] - Фильтр/Сортировка'+#13+'[SHIFT]+[1,2,...] - Верхнее меню'+#13+'[ESC] - Отмена\Выход');
     exit;
     end;

     // ======================    Если на панели ВЫБОРА ДАТЫ   ===================
   if (form1.Panel1.Visible=true) then
      begin
        // ESC
        if (Key=27) then
           begin
            form1.Panel1.Visible:=false;
            form1.Stringgrid1.enabled:=true;
            form1.StringGrid1.setfocus;
            exit;
           end;

        // ENTER в Выборе даты
        if (Key=13) AND (Form1.Panel1.Focused) then
          begin
           form1.Panel1.Visible:=false;
           form1.Stringgrid1.enabled:=true;
           form1.StringGrid1.SetFocus;
           work_date:=(form1.SpinDate1.Date);
           // Первый элемент Stringgrid1
           filtr:=1;
           form1.Disp_refresh(1,1);
          end;

        // Стрелка вверх
        if (Key=38) then
          begin
           form1.SpinDate1.Date:=form1.SpinDate1.Date+1;
           form1.Label4.Caption:=GetDayName(dayoftheweek(form1.SpinDate1.date));
          end;
        // Стрелка вниз
        if (Key=40) then
          begin
           form1.SpinDate1.Date:=form1.SpinDate1.Date-1;
           form1.Label4.Caption:=GetDayName(dayoftheweek(form1.SpinDate1.date));
          end;
        key:=0;
        //exit;
      end;

    // ======================    Если на панели ВЫБОРА фильтра рейсов   ===================
   if (form1.Panel2.Visible=true) then
      begin
        // ESC
        if (Key=27) then
           begin
            key:=0;
            form1.Panel2.Visible:=false;
            form1.Stringgrid1.enabled:=true;
            form1.StringGrid1.setfocus;
            exit;
           end;

        // ENTER в Выборе фильтра
        if ((Key=13) or (Key=32)) AND (Form1.Stringgrid2.Focused) then
          begin
             key:=0;
             //======== ФИЛЬТР/СОРТИРОВКА  ========
            //0: ВСЕ ПОСЛЕ ВЫБОРА ДАТЫ  (результаты поиска)
            //1: ВСЕ АКТИВНЫЕ НА ТЕКУЩУЮ ДАТУ И ВРЕМЯ (СЕГОДНЯ)
            //2: РЕЙСЫ ТЕКУЩЕГО РАСПИСАНИЯ
            //3: РЕЙСЫ ОТПРАВЛЕНИЯ АКТИВНЫЕ
            //4: РЕЙСЫ ПРИБЫТИЯ АКТИВНЫЕ
            //5: РЕЙСЫ НЕАКТИВНЫЕ
            //6: РЕЙСЫ ЗАКАЗНЫЕ
            //7: РЕЙСЫ УДАЛЕНКИ
            //8: ПОИСК населенного пункта
            //9: Билеты АГЕНТОВ

            form1.Panel2.Visible:=false;
            form1.Stringgrid1.enabled:=true;
            form1.StringGrid1.SetFocus;
            //application.ProcessMessages;

            //если тот же фильтр то ничего не делать
            If filtr=form1.StringGrid2.Row+1 then exit;
            filtr:=form1.StringGrid2.Row+1;

           //если пробел после поиска, то открыть все рейсы расписания
            //If filtr=1 then filtr:=2;
            //закругляем фильтр
            If filtr=1 then
            begin
            form1.Disp_refresh(1,1); //обновить экран диспетчера
            end;

            If (filtr>1) and (filtr<8) then form1.Disp_refresh(0,1);
            //поиск населенного пункта в списке
            If filtr=8 then
              begin
                 form1.Edit1.Text:='';
                 form1.Edit1.visible:=true;
                 form1.Edit1.SetFocus;
              end;
            //рейсы с билетами агентов
            If (filtr=9) then form1.Disp_refresh(0,0);
              //end
            //else
            //begin
            // Сортировка всех рейсов
            //Form1.sort_full_mas(filtr);
            //если день совпадает с настоящим, то ищем рейс по времени
            //If (work_date=date()) then get_time_index;//$-
            // Отрисовка грида рейсов
            //form1.get_list_shedule;
            //end;
          end;

        exit;
      end;


   // ======================    Если на панели выбора Платформы   ===================
   if (form1.Panel3.Visible=true) then
      begin
       // Вверх по списку
        if (Key=38) then
      begin
      form1.SpinEdit1.Value:=form1.SpinEdit1.Value+1;
      key:=0;
      end;
        // Вниз по списку
   if (Key=40) then
     begin
       form1.SpinEdit1.Value:=form1.SpinEdit1.Value-1;
      key:=0;
     end;
        // ESC
        if (Key=27) then
           begin
            form1.Panel3.Visible:=false;
            form1.Stringgrid1.enabled:=true;
            form1.StringGrid1.SetFocus;
            key:=0;
           end;
        // ENTER - сменить платформу
       IF (Key=13) then
          begin
           key:=0;
           // смена платформа
           //открываем транзакцию
           formMenu.insert_oper(form1.Zconnection1,form1.ZReadOnlyQuery1,form1.ZReadOnlyQuery3,10);
            //если транзакция отменена (кто-то держит или нет записей для блокировки), то - отвал
           If not form1.Zconnection1.Connected then
              begin
                 showmessagealt('Ошибка соединения с базой (недоступно или уже используется) !!!');
                 exit;
              end;
           //закрываем открытую транзакцию
           try
             //showmessagealt(form1.ZReadOnlyQuery3.SQL.Text);
             form1.ZReadOnlyQuery3.ExecSql;
             form1.Zconnection1.Commit;
           except
             If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
             form1.ZConnection1.disconnect;
             showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL2: '+form1.ZReadOnlyQuery3.SQL.Text);
             exit;
           end;
           form1.ZReadOnlyQuery1.Close;
           form1.ZReadOnlyQuery3.Close;
           form1.Zconnection1.disconnect;
           form1.Panel3.Visible:=false;
           form1.Stringgrid1.enabled:=true;
           //Form1.Stringgrid1.setfocus();
           form1.Disp_refresh(0,0); //обновить экран диспетчера
          end;
       exit;
      end;

   //=============================  Если на основном гриде рейсов ====================
   If (form1.StringGrid1.Focused) then
     begin
     //вверх по рейсам
       If (key=38) then
         begin
           key:=0;
           //если отображаются все рейсы
         If (length(filtr_mas)=0) and (masindex>0) then
         begin
           masindex:=masindex-1;
           get_list_shedule;
         end;
         //если стоит фильтр или после поиска
         If (length(filtr_mas)>0) and (findex>0) then
         begin
           findex:=findex-1;
           get_list_shedule;
         end;
         end;
       //вниз по рейсам
       If (key=40)  then
         begin
         key:=0;
         If (length(filtr_mas)=0) and (masindex<high(full_mas)) then
         begin
         masindex:=masindex+1;
         get_list_shedule;
   //       str:='';
   //for n:=1 to 10 do
   //  begin
   //    //sleep(10);
   //    form1.get_list_shedule;
   //    masindex:=masindex+1;
   //    application.ProcessMessages;
   //    str:=str+FormatDateTime('ss.zzz',now)+#13;
   //  end;
   //showmessagealt(str);
         end;
         If (length(filtr_mas)>0) and (findex<high(filtr_mas)) then
         begin
           findex:=findex+1;
           get_list_shedule;
         end;
         end;
        //вверх по рейсам PgUP
       If (key=33) then
         begin
           key:=0;
           If (length(filtr_mas)=0) and (masindex-triprows>-1) then
         begin
           masindex:=masindex-triprows;
           get_list_shedule;
           end;
           If (length(filtr_mas)>0) and (findex-triprows>-1) then
         begin
           findex:=findex-triprows;
           get_list_shedule;
         end;
         end;
       //вниз по рейсам PgDown
       If (key=34) then
         begin
         key:=0;
         If (length(filtr_mas)=0) and (masindex+triprows<length(full_mas)) then
         begin
         masindex:=masindex+triprows;
         get_list_shedule;
         end;
          If (length(filtr_mas)>0) and (findex+triprows<length(filtr_mas)) then
         begin
           findex:=findex+triprows;
           get_list_shedule;
         end;
         end;
       // ENTER - вызов Меню
       IF (Key=13) then
          begin
           key:=0;
           form1.Stringgrid1.enabled:=false;
           //If (full_mas[masindex,17]='0') then
              //begin
               //showmessagealt('Рейс НЕАКТИВЕН на текущую дату !'+#13+'Все операции с ним ЗАПРЕЩЕНЫ !');
               //form1.Stringgrid1.enabled:=true;
               //key:=0;
               //exit;
              //end;
           //остановить таймер обновления экрана
           //form1.IdleTimer2.Enabled:=false;


           operation:=0;//сбрасываем номер операции
           perenos_biletov:=-1;
           //запустить таймер бездействия
           start_stop_idle(timeout_menu);
           timeout_signal:=timeout_menu;//*
           //вызвать меню, выбрать операцию и разобрать ее
           FormMenu:=TFormMenu.create(self);
           FormMenu.ShowModal;
           FreeAndNil(FormMenu);
           //остановить таймер бездействия
           start_stop_idle(0);

           //выполнить разобранную операцию
           If operation>0 then
              begin
              trip_data();
              end;
           //если был срыв с переносом билетов, то создать заказной рейс
           //  If (perenos_biletov>0) then
              //begin
               //If not(operation=11) then operation:=11;
              //trip_data();
              //end;

           form1.Stringgrid1.enabled:=true;
           form1.StringGrid1.SetFocus;

           If (operation<>11) AND (operation>0) then
              begin
                form1.Disp_refresh(0,0); //обновить экран диспетчера
              end;
           //если создание заказного
           If (operation=11) then form1.Disp_refresh(0,1); //обновить экран диспетчера с обнулением массива
           //запустить таймер обновления экрана
           //form1.IdleTimer2.Enabled:=true;
           operation:=0;
          exit;
          end;

       // space - Пробел - изменяем фильтр/сортировку
       IF (Key=32) and (form1.Panel2.Visible=false) then
          begin
            key:=0;
            form1.Stringgrid1.enabled:=false;
            IF (work_date=date()) then form1.StringGrid2.Cells[0,0]:=' ВСЕ РЕЙСЫ НА СЕГОДНЯ'
            else form1.StringGrid2.Cells[0,0]:=' ВСЕ РЕЙСЫ НА '+FormatDateTime('dd',work_date)+' '+GetMonthName(MonthOfTheYear(work_Date));
            form1.Panel2.Visible:=true;
            form1.StringGrid2.SetFocus;
            form1.StringGrid2.Refresh;
            If filtr=7 then
               form1.StringGrid2.Row:=0
            else
               form1.StringGrid2.Row:=filtr;
            //======== ФИЛЬТР/СОРТИРОВКА  ========
            //1: ВСЕ НА ТЕКУЩУЮ ДАТУ И ВРЕМЯ (СЕГОДНЯ)
            //2: РЕЙСЫ ТЕКУЩЕГО РАСПИСАНИЯ
            //3: РЕЙСЫ ОТПРАВЛЕНИЯ АКТИВНЫЕ
            //4: РЕЙСЫ ПРИБЫТИЯ АКТИВНЫЕ
            //5: РЕЙСЫ НЕАКТИВНЫЕ
            //6: РЕЙСЫ ЗАКАЗНЫЕ
            //7: поиск рейса по промежуточному пункту

            exit;
          end;
     end;

   // =======================Если на форме  ===============================
   If (form1.Panel1.Visible=false) and (form1.Panel2.Visible=false) and (form1.Panel3.Visible=false) then
     begin
    // ESC в форме
       IF (Key=27) and (form1.edit1.visible=false) then
          begin
          key:=0;
         //если был контекстный поиск, то показать все рейсы
          If length(filtr_mas)>0 then
             begin
             setlength(filtr_mas,0);
             form1.get_list_shedule;
             exit;
             end;
            //если стоял фильтр - снимаем
          If (filtr<>1) and (length(filtr_mas)=0) then
             begin
              filtr:=1;
              form1.Disp_refresh(1,1);
              exit;
             end;
          //закрыть приложение
          If (form1.StringGrid1.Focused) and (length(filtr_mas)=0) then
             begin
              If DialogMess('Вы действительно хотите завершить работу с программой ?')=6 then form1.Close;
             exit;
             end;
          end;
       // F2 - вызов панели переключения рабочей даты
       IF (Key=113) then
          begin
           form1.SpinDate1.Date:=work_date;
           form1.Label4.Caption:=GetDayName(dayoftheweek(form1.SpinDate1.date));
           form1.Stringgrid1.enabled:=false;
           form1.Panel1.Visible:=true;
           form1.Panel1.SetFocus;
           key:=0;
           exit;
          end;

       // F3 - вызов панели Состав + Тариф
       IF (Key=114) then
          begin
            key:=0;
            form1.Stringgrid1.enabled:=false;
            paintmess(form1.StringGrid1,'ЗАПРОС СОСТАВА РАСПИСАНИЯ ! ПОДОЖДИТЕ...',clBlue);
            //showmessagealt(full_mas[masindex,1]+'|'+inttostr(form1.StringGrid1.Row));//$
            start_stop_idle(timeout_sostav);
            timeout_signal:=timeout_sostav;//*
            Form4:=TForm4.create(self);
            Form4.ShowModal;
            FreeAndNil(Form4);
            start_stop_idle(0);
            paintmess(form1.StringGrid1,'ЗАПРОС СОСТАВА РАСПИСАНИЯ ! ПОДОЖДИТЕ...',clBlue);
            form1.Stringgrid1.enabled:=true;
            form1.Stringgrid1.SetFocus;
            form1.Disp_refresh(0,0); //обновить экран диспетчера
            exit;
          end;

       // F4 - вызов СХЕМА АТС
       IF (Key=115) then
          begin
            key:=0;
            If form1.StringGrid1.Cells[9,form1.StringGrid1.Row]='0' then
               begin
                 showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'Данный рейс неактивен !');
                exit;
               end;
            form1.Stringgrid1.enabled:=false;
            start_stop_idle(timeout_schema);
            timeout_signal:=timeout_schema;//*
            bron_edit:=false; //режим просмотра
            Form7:=TForm7.create(self);
            Form7.ShowModal;
            FreeAndNil(Form7);
            start_stop_idle(0);
            form1.Stringgrid1.enabled:=true;
            form1.StringGrid1.SetFocus;
            form1.Disp_refresh(0,0); //обновить экран диспетчера
            exit;
          end;

           // F5 - вызов ПОИСК пассажира
       IF (Key=116) then
          begin
            key:=0;

            form1.Stringgrid1.enabled:=false;
            start_stop_idle(timeout_schema);
            timeout_signal:=timeout_schema;//*
            Form11:=TForm11.create(self);
            Form11.ShowModal;
            FreeAndNil(Form11);
            start_stop_idle(0);
            form1.Stringgrid1.enabled:=true;
            form1.StringGrid1.SetFocus;
            form1.Disp_refresh(0,0); //обновить экран диспетчера
            exit;
          end;

        // F6 - вызов Списка ведомостей рейса
       IF (Key=117) then
          begin
            key:=0;
            //находим элемент массива
            //n := arr_get();
           //If form1.StringGrid1.Cells[9,form1.StringGrid1.Row]='0' then
           //    begin
           //      showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'Данный рейс неактивен !');
           //     exit;
           //    end;
       If masindex>-1 then
           begin
           //остановить таймер обновления экрана
           start_stop_idle(timeout_vedom);
           timeout_signal:=timeout_vedom;//*
           form1.Stringgrid1.enabled:=false;
           Vedom_get(masindex,1); //вывод списка ведомостей на печать
           //запустить таймер обновления экрана
           start_stop_idle(0);
           form1.Stringgrid1.enabled:=true;
           form1.StringGrid1.SetFocus;
           //form1.IdleTimer2.Enabled:=true;
           end
            else
              showmessagealt('Не найден элемент массива рейсов !');

            exit;
          end;

      // F7 -// РАСЧЕТ последних операций и СВОБОДНЫХ МЕСТ НА РЕЙСе
      If (key=118) then
        begin
         key:=0;
         If filtr=9 then exit;
          //получить последнее состояние рейса по диспетчерским операциям
         // Подключаемся к серверу
         If not(Connect2(form1.Zconnection2, 1)) then
          begin
             showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m07-');
             exit;
          end;
          try
           form1.get_disp_oper(form1.ZReadOnlyQuery2,masindex);
          finally
            form1.ZReadOnlyQuery2.Close;
            form1.ZConnection2.Disconnect;
          end;
          getfreeseats(masindex);   // РАСЧЕТ СВОБОДНЫХ МЕСТ НА РЕЙСЕ
          //возвращаем параметры локального сервера
          sale_server:=ConnectINI[14];
          otkuda_name:=server_name;
          // Отрисовка грида рейсов
          form1.get_list_shedule;

          exit;
        end;

      // F8 - Сделать объявление опаздывающим пассажирам
       If (key=119) then
        begin
          key:=0;
          If (full_mas[masindex,30]='') and (full_mas[masindex,31]='') then
               begin
                 showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'НЕТ ОПЕРАЦИЙ НЕ РЕЙСЕ !');
                 exit;
               end;
           If form1.StringGrid1.Cells[9,form1.StringGrid1.Row]='0' then
               begin
                 showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'Данный рейс неактивен !');
                 exit;
               end;
         If (full_mas[masindex,16]='2') or (DialogMess('Сделать объявление опаздывающим пассажирам ?')=7) then exit;
          // объявление ОПАЗДЫВАЮЩИМ ПАССАЖИРАМ
           //отрываем транзакцию
           formMenu.insert_oper(form1.Zconnection1,form1.ZReadOnlyQuery1,form1.ZReadOnlyQuery3,100);
             //если транзакция отменена (кто-то держит или нет записей для блокировки), то - отвал
           If not form1.Zconnection1.Connected then
              begin
                 showmessagealt('Ошибка соединения с базой (недоступно или уже используется) !!!');
                 exit;
              end;
           try
             form1.ZReadOnlyQuery3.ExecSql;
             form1.Zconnection1.Commit;
           except
             If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
             form1.ZConnection1.disconnect;
             showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL2: '+form1.ZReadOnlyQuery3.SQL.Text);
             exit;
           end;
           form1.ZReadOnlyQuery1.Close;
           form1.ZReadOnlyQuery3.Close;
           form1.Zconnection1.disconnect;
           exit;
        end;

       // F11 - Сделать объявление о свободных местах
       If (key=122) then
        begin
          key:=0;
          If (full_mas[masindex,34]='') or (full_mas[masindex,34]='0') then
               begin
                 showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'НЕТ информации о СВОБОДНЫХ МЕСТАХ !');
                 exit;
               end;
           If form1.StringGrid1.Cells[9,form1.StringGrid1.Row]='0' then
               begin
                 showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'Данный рейс неактивен !');
                 exit;
               end;
             If (full_mas[masindex,16]='2') then
               begin
                 showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'ВЫБРАН РЕЙС ПРИБЫТИЯ !');
                 exit;
               end;
         If (DialogMess('Сделать объявление о свободных местах?')=7) then exit;
          // объявление ОПАЗДЫВАЮЩИМ ПАССАЖИРАМ
           //отрываем транзакцию
           formMenu.insert_oper(form1.Zconnection1,form1.ZReadOnlyQuery1,form1.ZReadOnlyQuery3,80);
             //если транзакция отменена (кто-то держит или нет записей для блокировки), то - отвал
           If not form1.Zconnection1.Connected then
              begin
                 showmessagealt('Ошибка соединения с базой (недоступно или уже используется) !!!');
                 exit;
              end;
           try
             form1.ZReadOnlyQuery3.ExecSql;
             form1.Zconnection1.Commit;
           except
             If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
             form1.ZConnection1.disconnect;
             showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL2: '+form1.ZReadOnlyQuery3.SQL.Text);
             exit;
           end;
           form1.ZReadOnlyQuery1.Close;
           form1.ZReadOnlyQuery3.Close;
           form1.Zconnection1.disconnect;
           exit;
        end;

       // F9 - Выбор удаленного рейса
       IF (Key=120) then
          begin
            key:=0;
            start_stop_idle(timeout_udal);
            timeout_signal:=timeout_udal;//*
            form1.Stringgrid1.enabled:=false;
            remote_ind:=-1;//индекс удаленного рейса
            operation:=0;//сброс операции
            cntmas:= length(full_mas);
            Form6:=TForm6.create(self);
            Form6.ShowModal;
            FreeAndNil(Form6);
            start_stop_idle(0);
            //если добавился рейс удаленки, то сменить фильтр
            //if cntmas<length(full_mas) then
               //filtr:=7;


           If remote_ind>-1 then
             begin
              masindex:=remote_ind;
             //showmessage(full_mas[high(full_mas),26]);
    //           //showmessage(save_server+#13+         ConnectINI[4]+#13+         ConnectINI[5]+#13+         ConnectINI[6]);  //$
    //открыть окно карты автобуса для бронирования и вычеркнутых
            //alltrips:=length(full_mas);
            //если рейс отправлен, то только вычеркивание
            If full_mas[masindex,28]='4' then operation:=9;
            //если удаленка и текущее время меньше даты в времени отправления рейса, то открыть бронирование, иначе - вычеркивание
            try
            If (operation=0) and (strtodatetime(full_mas[masindex,11]+' '+full_mas[masindex,10],MySettings)>now()) then operation:=6 else operation:=9;
             except
             on exception: EConvertError do
             begin
             showmessagealt('ОШИБКА КОНВЕРТАЦИИ ДАТЫ!!!'+#13+'значение: '+full_mas[masindex,11]+'| '+full_mas[masindex,10]+#13+'--c29');
             end;
             end;
            //открываем транзакцию
             formMenu.insert_oper(form1.Zconnection1,form1.ZReadOnlyQuery1,form1.ZReadOnlyQuery3,operation);
             //если транзакция отменена (кто-то держит рейс или билеты на него), то - отвал
            If (operation=0) then
               begin
               form1.Stringgrid1.enabled:=true;
               remote_ind:=-1;
               exit;
               end;
           If (operation=6) then
               begin
              //открыть окно карты автобуса для бронирования
              start_stop_idle(timeout_udal);
              Form7:=TForm7.create(self);
              Form7.ShowModal;
              FreeAndNil(Form7);
              start_stop_idle(0);
              end;

            //открыть окно карты автобуса для вычеркнутых
             If (operation=9) then
               begin
              start_stop_idle(timeout_udal);
              Form9:=TForm9.create(self);
              Form9.ShowModal;
              FreeAndNil(Form9);
              start_stop_idle(0);
               end;
              //если транзакция еще открыта - откатываемся
              If form1.Zconnection1.Connected then
                begin
                form1.ZReadOnlyQuery1.Close;
                form1.ZReadOnlyQuery3.Close;
                If ZConnection1.InTransaction then Zconnection1.Rollback;
                form1.ZConnection1.disconnect;
                end;
               remote_ind:=-1;
             end;


            form1.Stringgrid1.enabled:=true;
            //form1.Stringgrid1.SetFocus;
         //возвращаем параметры локального сервера
          sale_server:=ConnectINI[14];
          otkuda_name:=server_name;
          //если работали с виртуалкой virt, то обновить
          //If filtr=7 then
           //обновить экран диспетчера
           //form1.Disp_refresh(0,1)
          //else
          // Отрисовка грида рейсов
          form1.get_list_shedule;

            exit;
          end;

           // F10 - Печать акта за незаявленное ТС
       IF (Key=121) then
          begin
            key:=0;
            If (utf8pos('|',full_mas[masindex,33])>0) and (DialogMess('Вывести на печать АКТ'+#13+'за незаявленное транспортное средство ?')=6)  then
            begin
             formV.get_print_akt();
            end;
          end;

         // F12 - Снять зависшие билеты/рейсы
       IF (Key=123) then
          begin
            key:=0;
               // Подключаемся к серверу
            If not(Connect2(form1.Zconnection1, 1)) then
               begin
                //возвращаем параметры локального сервера
               showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m08-');
               exit;
               end;
              IF DialogMess('Подтвердите снятие БЛОКИРОВОК билетов/рейсов')=6
              THEN
              begin
                   form1.ZReadOnlyQuery1.sql.Clear;
                   form1.ZReadOnlyQuery1.sql.add('select find_destroy('+inttostr(max_transaction_time div 2 +60)+',2);');
                   writelog(form1.ZReadOnlyQuery1.sql.Text+#13+'-m21-');
                      //showmessage(form1.ZReadOnlyQuery1.SQL.Text);//$
                   try
                     form1.ZReadOnlyQuery1.open;
                     If form1.ZReadOnlyQuery1.RecordCount>0 then
                     begin
                       if trim(form1.ZReadOnlyQuery1.Fields[0].AsString)<>'' then
                       begin
                           //writelog(form1.ZReadOnlyQuery1.Fields[0].AsString+#13+'-m47-');
                          showmessagealt('-m22-БЛОКИРОВКИ билетов/рейсов УСПЕШНО сняты по следующим кассам:'+#13+form1.ZReadOnlyQuery1.Fields[0].AsString);
                       end
                       else
                         showmessagealt('НЕ ОБНАРУЖЕНО БЛОКИРОВОК билетов/рейсов...-m23-');
                     end;
                    except
                       writelog('Ошибка запроса !'+#13+form1.ZReadOnlyQuery1.sql.Text+#13+'-m24-');
                       form1.ZReadOnlyQuery1.close;
                    end;

                    //Открываем транзакцию
                    try
                      If not form1.Zconnection1.InTransaction then
                      begin
                      form1.Zconnection1.StartTransaction;
                      end
                      else
                      begin
                         If form1.Zconnection1.InTransaction then form1.Zconnection1.Rollback;
                         form1.Zconnection1.disconnect;
                         showmessagealt('Ошибка ! Незавершенная транзакция !'+#13+'Попробуйте снова !');
                         exit;
                      end;

                 form1.ZReadOnlyQuery1.sql.Clear;
                 form1.ZReadOnlyQuery1.sql.add('select find_delete_empty_tickets('''');');
              //showmessagealt('Поиск и удаление пустых билетов'+#13+'Может занять некоторое время, подождите...'+#13+'-m25-');

                     form1.ZReadOnlyQuery1.open;
                     FORM1.Zconnection1.Commit;

                     If form1.ZReadOnlyQuery1.RecordCount>0 then
                        showmessagealt('Удалено '+form1.ZReadOnlyQuery1.Fields[0].AsString+' пустых билетов...'+#13+'-m26-')
                      else
                        showmessagealt('НЕ ОБНАРУЖЕНО БЛОКИРОВОК билетов/рейсов...-m27-');
                    except
                      If ZConnection1.InTransaction then Zconnection1.Rollback;
                       writelog('Данные не записаны ! Не удается завершить транзакцию !!!'+#13+form1.ZReadOnlyQuery1.sql.Text+#13+'-m28-');
                       form1.ZReadOnlyQuery1.close;
                    end;

              end;
                form1.ZReadOnlyQuery1.Close;
                form1.ZConnection1.disconnect;
          end;

          end;



     //1-Основное
    if (Key=49) AND (ssShift in Shift)  then
       begin
         form1.Label14.Font.Color:=clBlue;
         form1.Label15.Font.Color:=clSkyBlue;
         form1.Label16.Font.Color:=clSkyBlue;
         form1.Label17.Font.Color:=clSkyBlue;
         form1.Label19.Font.Color:=clSkyBlue;
         //form1.Image1.Visible:=true;
         //form1.GroupBox3.Visible:=true;
         form1.GroupBox5.Visible:=true;
         form1.GroupBox6.Visible:=true;
         form1.GroupBox2.Visible:=false;
         form1.GroupBox1.Visible:=false;
         //form1.StringGrid3.Visible:=false;
         key:=0;
         exit;
       end;

    //2- инфа ПО адресам
    if (Key=50) AND (ssShift in Shift)  then
       begin
         form1.Label14.Font.Color:=clSkyBlue;
         form1.Label15.Font.Color:=clBlue;
         form1.Label16.Font.Color:=clSkyBlue;
         form1.Label17.Font.Color:=clSkyBlue;
         form1.Label19.Font.Color:=clSkyBlue;
         //form1.Image1.Visible:=false;
         //form1.GroupBox3.Visible:=false;
         form1.GroupBox5.Visible:=false;
         form1.GroupBox6.Visible:=false;
         form1.GroupBox2.Visible:=true;
         form1.GroupBox1.Visible:=true;
         //form1.StringGrid3.Visible:=false;
         key:=0;
         exit;
       end;

    //3-Активные пользователи
    if (Key=51) AND (ssShift in Shift)  then
       begin
         form1.Label14.Font.Color:=clSkyBlue;
         form1.Label15.Font.Color:=clSkyBlue;
         form1.Label16.Font.Color:=clBlue;
         form1.Label17.Font.Color:=clSkyBlue;
         form1.Label19.Font.Color:=clSkyBlue;
         //form1.Image1.Visible:=false;
         //form1.GroupBox3.Visible:=false;
         form1.GroupBox5.Visible:=false;
         form1.GroupBox6.Visible:=false;
         form1.GroupBox2.Visible:=false;
         form1.GroupBox1.Visible:=false;
         //form1.StringGrid3.Visible:=true;
         //grid_active_user(form1.StringGrid3,form1.ZConnection3,form1.ZReadOnlyQuery3);
         key:=0;
         exit;
       end;

    //4-Задачи
    if (Key=52) AND (ssShift in Shift)  then
       begin
         form1.Label14.Font.Color:=clSkyBlue;
         form1.Label15.Font.Color:=clSkyBlue;
         form1.Label16.Font.Color:=clSkyBlue;
         form1.Label17.Font.Color:=clBlue;
         form1.Label19.Font.Color:=clSkyBlue;
         //form1.Image1.Visible:=false;
         //form1.GroupBox3.Visible:=false;
         form1.GroupBox5.Visible:=false;
         form1.GroupBox6.Visible:=false;
         form1.GroupBox2.Visible:=false;
         form1.GroupBox1.Visible:=false;
         //form1.StringGrid3.Visible:=false;
         key:=0;
         exit;
       end;

    //5-О программе
    if (Key=53) AND (ssShift in Shift)  then
       begin
         form1.Label14.Font.Color:=clSkyBlue;
         form1.Label15.Font.Color:=clSkyBlue;
         form1.Label16.Font.Color:=clSkyBlue;
         form1.Label17.Font.Color:=clSkyBlue;
         form1.Label19.Font.Color:=clBlue;
         //form1.Image1.Visible:=true;
         //form1.GroupBox3.Visible:=false;
         form1.GroupBox5.Visible:=false;
         form1.GroupBox6.Visible:=false;
         form1.GroupBox2.Visible:=false;
         form1.GroupBox1.Visible:=false;
         //form1.StringGrid3.Visible:=false;
         key:=0;
         exit;
       end;

   //================================ Контекcтный поиск =======================================
   if (form1.Edit1.Visible=false) and (form1.Panel1.Visible=false) and (form1.Panel2.Visible=false) and (form1.Panel3.Visible=false) then
     begin
       //If (get_type_char(key)>0) or (key=8) or (key=46) or (key=96) then //8-backspace 46-delete 96- numpad 0
      //Если не цифры и не буквы не открывать
      If ((key>46) and (key<106)) or (key>183) then
       begin
         //filtr:=0;
         form1.Edit1.text:='';
         form1.Edit1.Visible:=true;
         //label44.Caption:='0';
         form1.Edit1.SetFocus;
         //exit;
       end;
     end;

   //==================   НА ПАНЕЛИ БЫСТРОГО ПОИСКА  =========================
   If (form1.edit1.visible=true) then
     begin
     // Вверх по списку
     if (Key=38) then
     begin
      key:=0;
      form1.Edit1.Visible:=false;
      form1.StringGrid1.SetFocus;
      mainsrv:=false;//флаг нахождения локального сервера в контекстом поиске
      //exit;
     end;
  // Вниз по списку
   if (Key=40) then
     begin
       key:=0;
       form1.Edit1.Visible:=false;
       mainsrv:=false;//флаг нахождения локального сервера в контекстом поиске
       form1.StringGrid1.SetFocus;
       //exit;
     end;
    // ENTER - остановить контекстный поиск
   if (Key=13) then
     begin
     key:=0;
     //If (filtr<>1) and (length(filtr_mas)=0) then
         //begin
         //filtr:=1;
         //form1.Disp_refresh(1);
         //end;
      form1.Edit1.Visible:=false;
      mainsrv:=false;//флаг нахождения локального сервера в контекстом поиске
      form1.StringGrid1.SetFocus;
      //If form1.StringGrid1.RowCount=1 then form1.Disp_refresh(0)  //обновить экран диспетчера
      //else form1.StringGrid1.Row:=1;
       exit;
     end;
    // Space - пробел
   //if (Key=32) then
     //begin
       //exit;
     //end;
   // ESC поиск
   if (Key=27) then
       begin
         key:=0;
         //If filtr=0 then filtr:=1;
         form1.Disp_refresh(1,0);
         form1.Edit1.Text:='';
         form1.Edit1.Visible:=false;
         mainsrv:=false;//флаг нахождения локального сервера в контекстом поиске
         exit;
       end;
    end;
 end;
 //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::::


//********************************** Очищаем блоки из full_mas по флагу 1-av_trip 2-av_trip_add full_mas[n,0];
procedure Tform1.clear_mas(flag_clear:byte);
  var
    n,m:integer;
    //full_mas_temp:array of array of string;
    arrtmp: array of array of string;
begin
   // Если массив пустой то нечего очищать
   if length(full_mas)=0 then exit;
   SetLength(arrtmp,0,0);
   // В цикле добавляем записи которые нужно сохранить во временный массив
   //for n:=low(full_mas) to high(full_mas) do
   //  begin
   //   if trim(full_mas[n,0])<>inttostr(flag_clear) then
   //    begin
   //      SetLength(arrtmp,length(arrtmp)+1,full_mas_size);
   //         for m:=0 to full_mas_size-1 do
   //           begin
   //             arrtmp[length(arrtmp)-1,m]:=full_mas[n,m];
   //           end;
   //     end;
   //  end;
   //очищаем массив от рейсов с удаленных вокзалов
     for n:=low(full_mas) to high(full_mas)-1 do
     begin
         SetLength(arrtmp,length(arrtmp)+1,full_mas_size);
            for m:=0 to full_mas_size-1 do
              begin
                arrtmp[length(arrtmp)-1,m]:=full_mas[n,m];
              end;
     end;
   SetLength(full_mas,0,0);
   If length(arrtmp)=0 then exit;
    //перезаписываем массив
   for n:=low(arrtmp) to high(arrtmp) do
     begin
       SetLength(full_mas,length(full_mas)+1,full_mas_size);
       for m:=0 to full_mas_size-1 do
         begin
           full_mas[length(full_mas)-1,m]:=arrtmp[n,m];
         end;
     end;
   SetLength(arrtmp,0,0);
   arrtmp:=nil;
end;



//************************************** ЗАПРОС ПОСЛЕДНИХ ДИСПЕТЧЕРСКИХ ОПЕРАЦИЙ по ОДНОМУ РАСПИСАНИЮ  ****************
function TForm1.get_disp_oper(ZQuer:TZReadOnlyQuery;arn:integer):boolean;
var
  tn,tm,n,m:integer;
  remote_trip:boolean;
begin
 If arn<0 then exit;
 result:=false;
 If filtr=9 then exit;

  date_trip:=datetostr(work_date);
  //если рейс удаленки
  If (full_mas[arn,0]='3') or (full_mas[arn,0]='4') or (full_mas[arn,0]='5') then
  begin
    remote_trip:=true;
    date_trip:=full_mas[arn,11];
  end;
 //запрашиваем только новые операции
//Запрос к av_disp_oper
 Zquer.SQL.Clear;
 Zquer.SQL.Add('select a.*');
 ZQuer.SQL.Add(',coalesce((SELECT b.name from av_users b WHERE b.del=0 AND b.id=a.id_user ORDER BY b.createdate DESC LIMIT 1 OFFSET 0),''нет'') as name ');
 ZQuer.SQL.Add(',(SELECT count(*) from av_disp_oper WHERE id_oper=3 AND id_shedule=a.id_shedule AND trip_time=a.trip_time ');
 ZQuer.SQL.Add('AND point_order=a.point_order AND trip_date='+Quotedstr(date_trip)+') as extra_vedom ');
 If remote_trip then
 begin
 If trim(full_mas[arn,18])='' then full_mas[arn,18]:='0';
 If trim(full_mas[arn,20])='' then full_mas[arn,20]:='0';
 ZQuer.SQL.Add(',get_seats_status('+quotedstr(date_trip)+','+sale_server+','+full_mas[arn,6]+','+full_mas[arn,18]+',');
 ZQuer.SQL.Add(full_mas[arn,1]+','+quotedstr(full_mas[arn,10])+','+full_mas[arn,20]+',1');
 ZQuer.SQL.Add(','+full_mas[arn,46]+','+full_mas[arn,7]+',3) as free_mesta');
 end;
 ZQuer.SQL.Add('from av_disp_oper as a ');
 Zquer.SQL.Add('WHERE a.del=0 AND a.trip_date='+Quotedstr(date_trip));
 //если рейс не удаленки, тогда смотрим по временной отметки
 //If (full_mas[arn,0]='1') or (full_mas[arn,0]='2') then Zquer.SQL.Add(' AND a.createdate>='+Quotedstr(max_operation));//' AND id_point_oper='+save_server);
 Zquer.SQL.Add(' AND a.id_shedule='+full_mas[arn,1]);
 If full_mas[arn,16]='1' then
 begin
  ZQuer.SQL.Add(' AND trip_time='+Quotedstr(full_mas[arn,10]));
  ZQuer.SQL.Add(' AND trip_id_point='+full_mas[arn,3]);
  ZQuer.SQL.Add(' AND point_order='+full_mas[arn,4]);
      end;
      //или если рейс прибытия
  If full_mas[arn,16]='2' then
 begin
  ZQuer.SQL.Add(' AND trip_time='+Quotedstr(full_mas[arn,12]));
  ZQuer.SQL.Add(' AND trip_id_point='+full_mas[arn,6]);
  ZQuer.SQL.Add(' AND point_order='+full_mas[arn,7]);
      end;
 ZQuer.SQL.Add(' order by a.trip_time,a.createdate;');
 //showmessage(Zquer.SQL.text);//$
 try
  Zquer.open;
 except
  Zquer.Close;
  result:=false;
  showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+Zquer.SQL.Text);
  exit;
 end;
 If Zquer.RecordCount=0 then
    begin
       result:=true;
       exit;
    end;
  //For m:=1 to Zquer.RecordCount do
  If Zquer.RecordCount>0 then
    begin
      ////ищем по всему массиву
      ////for n:=0 to length(full_mas)-1 do
      //  //begin
      ////находим точный рейс этого расписания
      //  //отправление
      //If ((full_mas[arn,16]=Zquer.FieldByName('trip_type').AsString) AND
      //(Zquer.FieldByName('trip_type').AsInteger=1) AND
      //(full_mas[arn,10]=Zquer.FieldByName('trip_time').AsString) AND
      //(full_mas[arn,3]=Zquer.FieldByName('trip_id_point').AsString) AND
      //(full_mas[arn,4]=Zquer.FieldByName('point_order').AsString)) OR
      ////или если рейс прибытия
      //((full_mas[arn,16]=Zquer.FieldByName('trip_type').AsString) AND
      //(Zquer.FieldByName('trip_type').AsInteger=2) AND
      //(full_mas[arn,12]=Zquer.FieldByName('trip_time').AsString) AND
      //(full_mas[arn,6]=Zquer.FieldByName('trip_id_point').AsString) AND
      //(full_mas[arn,7]=Zquer.FieldByName('point_order').AsString)) then
      //          begin
                                full_mas[arn,2] := trim(Zquer.FieldByName('platform').asString);
                                full_mas[arn,18]:= trim(Zquer.FieldByName('atp_id').asString);
                                full_mas[arn,19]:= trim(Zquer.FieldByName('atp_name').asString);
                                full_mas[arn,20]:= trim(Zquer.FieldByName('avto_id').asString);
                                full_mas[arn,21]:= trim(Zquer.FieldByName('avto_name').asString);
                                full_mas[arn,25]:= trim(Zquer.FieldByName('avto_seats').asString);
                                full_mas[arn,27]:= trim(Zquer.FieldByName('avto_type').asString);
                                full_mas[arn,28]:= trim(Zquer.FieldByName('trip_flag').asString);
                                full_mas[arn,29]:= trim(ZQuer.FieldByName('extra_vedom').asString);
                                full_mas[arn,30]:= FormatDateTime('dd-mm-yyyy',Zquer.FieldByName('createdate').AsDateTime);
                                full_mas[arn,31]:= FormatDateTime('hh:nn:ss',Zquer.FieldByName('createdate').AsDateTime);
                                //If trim(Zquer.FieldByName('name').asString)<>'' then
                                full_mas[arn,32]:= trim(Zquer.FieldByName('name').asString);
                                //If trim(Zquer.FieldByName('remark').asString)<>'' then
                                full_mas[arn,33]:= trim(Zquer.FieldByName('remark').asString);
                                If remote_trip then
                                full_mas[arn,34]:= trim(Zquer.FieldByName('free_mesta').asString);
                                //If trim(Zquer.FieldByName('putevka').asString)<>'' then
                                full_mas[arn,35]:= trim(Zquer.FieldByName('putevka').asString);
                                //If trim(Zquer.FieldByName('driver1').asString)<>'' then
                                full_mas[arn,36]:= trim(Zquer.FieldByName('driver1').asString);
                                //If trim(Zquer.FieldByName('driver2').asString)<>'' then
                                full_mas[arn,37]:= trim(Zquer.FieldByName('driver2').asString);
                                //If trim(Zquer.FieldByName('driver3').asString)<>'' then
                                full_mas[arn,38]:= trim(Zquer.FieldByName('driver3').asString);
                                //If trim(Zquer.FieldByName('driver4').asString)<>'' then
                                full_mas[arn,39]:= trim(Zquer.FieldByName('driver4').asString);
                                //ZQuer.Next;
                                //continue;
                     end;
                        //If (full_mas[arn,1]='54') AND (full_mas[arn,0]='1') then
                          //showmessage(full_mas[arn,1]+full_mas[arn,19]+full_mas[arn,21]);
                   //если рейс закрыт или сорван, то связанные рейсы пропускаем
              //     IF Zquer.FieldByName('trip_flag').AsInteger=5 then continue;
              //     IF Zquer.FieldByName('trip_flag').AsInteger=6 then continue;
              //     //если связанные рейс не регулярный, то связанные рейсы пропускаем
              //     IF ( Zquer.FieldByName('zakaz').AsInteger=2) or
              //      ( Zquer.FieldByName('zakaz').AsInteger=4) then continue;
              //     //если связанный рейс закрыт, пропускаем
              //     If full_mas[arn,28]='5' then continue;
              //     If full_mas[arn,28]='6' then continue;
              //    //если рейс не регулярный, то связанные рейсы пропускаем
              //     If (full_mas[arn,0]<>'1') and (full_mas[arn,0]<>'3') then continue;
              ////корректируем связанные рейсы
              //   tn :=0; //время отправления/прибытия в массиве
              //   tm :=0; //время отправления/прибытия в операции
              //   //если рейс отправления
              //     If (full_mas[arn,16]='1') then
              //       begin
              //         try
              //           tn := strtoint(copy(full_mas[arn,10],1,2)+copy(full_mas[arn,10],4,2));
              //         except
              //           on exception: EConvertError do continue;
              //         end;
              //       end;
              //    //если рейс прибытия
              //     If (full_mas[arn,16]='2') then
              //       begin
              //         try
              //           tn := strtoint(copy(full_mas[arn,12],1,2)+copy(full_mas[arn,12],4,2));
              //         except
              //           on exception: EConvertError do continue;
              //         end;
              //        end;
              //  try
              //     tm := strtoint(copy(Zquer.FieldByName('trip_time').AsString,1,2)+copy(Zquer.FieldByName('trip_time').AsString,4,2));
              //  except
              //     on exception: EConvertError do continue;
              //  end;
              //   //если время отправления/прибытия больше, чем в операции
              //         If (tn>tm) AND (tn>0) AND (tm>0) then
              //           begin
              //             full_mas[arn,2]:= trim(Zquer.FieldByName('platform').asString);
              //             full_mas[arn,18]:= trim(Zquer.FieldByName('atp_id').asString);
              //             full_mas[arn,19]:= trim(Zquer.FieldByName('atp_name').asString);
              //             full_mas[arn,20]:= trim(Zquer.FieldByName('avto_id').asString);
              //             full_mas[arn,21]:= trim(Zquer.FieldByName('avto_name').asString);
              //             full_mas[arn,25]:= trim(Zquer.FieldByName('avto_seats').asString);
              //             full_mas[arn,27]:= trim(Zquer.FieldByName('avto_type').asString);
              //             full_mas[arn,30]:= FormatDateTime('dd-mm-yyyy',Zquer.FieldByName('createdate').AsDateTime);
              //             full_mas[arn,31]:= FormatDateTime('hh:nn:ss',Zquer.FieldByName('createdate').AsDateTime);
              //                  If trim(Zquer.FieldByName('name').asString)<>'' then
              //                  full_mas[arn,32]:= trim(Zquer.FieldByName('name').asString);
              //                  If trim(Zquer.FieldByName('remark').asString)<>'' then
              //                  full_mas[arn,33]:= trim(Zquer.FieldByName('remark').asString);
              //                  If trim(Zquer.FieldByName('putevka').asString)<>'' then
              //                  full_mas[arn,35]:= trim(Zquer.FieldByName('putevka').asString);
              //                  If trim(Zquer.FieldByName('driver1').asString)<>'' then
              //                  full_mas[arn,36]:= trim(Zquer.FieldByName('driver1').asString);
              //                  If trim(Zquer.FieldByName('driver2').asString)<>'' then
              //                  full_mas[arn,37]:= trim(Zquer.FieldByName('driver2').asString);
              //                  If trim(Zquer.FieldByName('driver3').asString)<>'' then
              //                  full_mas[arn,38]:= trim(Zquer.FieldByName('driver3').asString);
              //                  If trim(Zquer.FieldByName('driver4').asString)<>'' then
              //                  full_mas[arn,39]:= trim(Zquer.FieldByName('driver4').asString);
              //           end;
                //end;
             //Zquer.Next;
            //end;
   result:=true;
end;


//********************************** РАСЧЕТ СВОБОДНЫХ МЕСТ НА РЕЙСАХ *******************************************************
procedure TForm1.getfreeseats(mode:integer);
//mode = -1 - рассчет свободных мест на всех рейсах
//mode >0 -рассчет свободных мест текущего рейса
var
   flag:byte=0;
   n,ot,pokuda,tw:integer;
   flerror,fls: boolean;
   strerror:string;
begin
  If mode=-1 then
     begin
      ot:=0;
      pokuda:=length(full_mas)-1;
     end
  else
  begin
    ot:=mode;
    pokuda:=mode;
    end;
   //tfresh:= time();//флаг давности обновления
   //возвращаем параметры локального сервера
  sale_server:=ConnectINI[14];
  otkuda_name:=server_name;
    // -Если опрашивать всех-----Соединяемся с локальным сервером----------------------
 If mode=-1 then
   begin
   paintmess(form1.StringGrid1,'РАСЧЕТ СВОБОДНЫХ МЕСТ ! ПОДОЖДИТЕ...',clBlue);
  If not(Connect2(form1.Zconnection2, 2)) then
   begin
    showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m6-');
    exit;
   end;
   end;
// --------------------------------------------------------------------------
// ----------------------------Расчет СВОБОДНЫХ МЕСТ для  av_ticket ----------
// --------------------------------------------------------------------------

 strerror:='';
 fls:=false;
 for n:=ot to pokuda do
     begin
     //If n>=length(full_mas) then
     //showmessagealt(inttostr(n));
     //если рейс не активен, пропускаем   //если рейс прибытия
     If (full_mas[n,22]='0') or (full_mas[n,16]='2') then
        begin
        full_mas[n,34]:='--';
        continue;
        end;

     //если расчет для всех, то не рассчитывать, если рейс отправлен, или рабочая дата не сегодня
      If (mode<0) and ((full_mas[n,28]='4') or (work_date<>date)) then continue;
       //If (full_mas[n,1]='54') AND (full_mas[n,0]='1') then
                          //showmessage(full_mas[n,1]+full_mas[n,19]+full_mas[n,21]);
      //Проверка значений
      flerror:=false;
      If datetostr(work_date)='' then flerror:=true;
      If full_mas[n,3]='' then flerror:=true; //id_ot
      IF full_mas[n,6]='' then flerror:=true; //id_do
      IF full_mas[n,18]='' then  flerror:=true; //id_kontr
      If full_mas[n,1]='' then flerror:=true;  //id_shedule
      IF full_mas[n,10]='' then flerror:=true;  //t_o
      IF full_mas[n,20]='' then flerror:=true;  //form
      IF full_mas[n,9]='' then flerror:=true;   //id_ats
      If full_mas[n,4]='' then flerror:=true;   //order_ot
      If full_mas[n,7]='' then flerror:=true;   //order_do

    //If full_mas[n,1]='9' then continue;//  !!!!!!!!!!!!!! УДАЛИТЬ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      If flerror then
        begin
        strerror:= strerror + 'время:'+full_mas[n,10]+' рейс:'+full_mas[n,5]+' - '+full_mas[n,8]+#13;
        fls:=true;
        continue;
        end;

      //если удаленка и смотрим все рейсы, то пропускаем
      If (full_mas[n,45]<>'0') and (mode=-1) then continue;
      If (full_mas[n,45]<>'0') then
      begin
       sale_server:=full_mas[n,45];
       date_trip:=full_mas[n,11];
      end;


  If mode>-1 then
   begin
  If not(Connect2(form1.Zconnection2, 1)) then
   begin
    showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m7-');
    exit;
   end;
   end;

      form1.ZReadOnlyQuery2.SQL.Clear;
     If mode>-1 then paintmess(form1.StringGrid1,'РАСЧЕТ СВОБОДНЫХ МЕСТ ! ПОДОЖДИТЕ...',clBlue);
      //getbronsale(dater, idot, iddo, idkontr, idshedule, triptime, idats, form, order_ot, order_do, type_return)
      form1.ZReadOnlyQuery2.sql.add('select * from get_seats_status('+Quotedstr(date_trip)+','+sale_server+','+full_mas[n,6]+','+full_mas[n,18]+','+full_mas[n,1]+',');
      form1.ZReadOnlyQuery2.sql.add(Quotedstr(full_mas[n,10])+','+full_mas[n,20]+','+full_mas[n,9]+','+full_mas[n,46]+','+full_mas[n,7]+',2) as free;');
      //showmessage(form1.ZReadOnlyQuery2.sql.text);//&
      try
      form1.ZReadOnlyQuery2.open;
      except
         //возвращаем параметры локального сервера
  sale_server:=ConnectINI[14];
  otkuda_name:=server_name;
        showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
        form1.ZReadOnlyQuery2.Close;
        form1.Zconnection2.disconnect;

        break;
      end;

  If form1.ZReadOnlyQuery2.RecordCount=0 then
   begin
      continue;
   end;
  //If full_mas[n,1]='13' then showmessage(form1.ZReadOnlyQuery2.FieldByName('free').asstring);
    full_mas[n,34]:= form1.ZReadOnlyQuery2.FieldByName('free').asstring;

   end;

 If fls then showmessagealt('Отсутствуют необходимые данные'+#13+'для расчета свободных мест для:'+#13+strerror);
 //showmessage(full_mas[n,34]);
   //reqtime := timetostr(time-t1);
   //end;
// --------------------------------------------------------------------------
// ----------------------------КОНЕЦ Расчет av_ticket -----------------
// --------------------------------------------------------------------------
  form1.ZReadOnlyQuery2.Close;
  form1.ZConnection2.Disconnect;
    //возвращаем параметры локального сервера
  sale_server:=ConnectINI[14];
  otkuda_name:=server_name;
end;


//*******************************  Заполняем Grid из full_mas или  Отрисовка ГРИДА РЕЙСОВ при быстром поиске *******************************
procedure TForm1.get_list_shedule;
 var
   n,m,nlow,nhigh,idx:integer;
begin
  //сбрасываем таймер самообновления
   timeout_main_tik:=0;

   active_check:=true; //флаг выполнения обновления

with form1 do
begin
   //application.ProcessMessages;
   //form1.StringGrid1.RowCount:=1;
   clear_labels();//очищаем лейбы
   //очищаем грид
  for n:=1 to Stringgrid1.RowCount-1 do
       begin
         for m:=0 to Stringgrid1.ColCount-1 do
          begin
             Stringgrid1.Cells[m,n]:='';
          end;
       end;
  if length(full_mas)=0 then
     begin
       If filtr=1 then showmessagealt('Маршрутная сеть недоступна !'+#13+'Выполните синхронизацию данных системы...');
       If filtr>1 then Stringgrid1.Cells[4,trows]:='НЕ НАЙДЕНО РЕЙСОВ ПО ВЫБРАННЫМ УСЛОВИЯМ !';
        active_check:=false; //флаг выполнения обновления
       exit;
     end;

  Stringgrid1.visible:=false;
  //если вывести все рейсы
    //If filtr=1 then
      //begin
       nlow:=masindex-trows;
       nhigh:=masindex+trows;
      //end
    //else
     //begin
      //showmessage('UPS');//$
   //если массив пуст
      If form1.Edit1.Visible and (length(filtr_mas)=0) and (filtr<>8) then
        begin
         Stringgrid1.visible:=true;
          Stringgrid1.Cells[4,trows]:='НИЧЕГО НЕ НАЙДЕНО !';
           active_check:=false; //флаг выполнения обновления
          exit;
        end;
      //ищем элемент массива в full_mas
      If length(filtr_mas)>0 then
       begin
       nlow:=findex-trows;
       nhigh:=findex+trows;
       masindex:=filtr_mas[findex];
       end;
     //end;
    // Заполняем GRID
    m:=0;
   //for n:=0 to rows-1 do
   for n:=nlow to nhigh do
     begin
     // Добавляем строку GRID
     //form1.StringGrid1.RowCount:=form1.StringGrid1.RowCount+1;
      If m>=Stringgrid1.RowCount then
         begin
         showmessagealt('ОШИБКА ! ЗНАЧЕНИЙ БОЛЬШЕ, ЧЕМ СТРОЧЕК СПИСКА !');
         break;
         end;
       m:=m+1;

      If (length(filtr_mas)>0) and ((n<0) or (n>high(filtr_mas))) then continue;
      If (length(filtr_mas)=0) then idx:=n else idx:=filtr_mas[n];
      If (length(filtr_mas)=0) and ((idx<0) or (idx>high(full_mas))) then continue;

      //if not(filtr=5) AND (full_mas[idx,22]='0') then
         //begin
         //showmessage('2');
         //continue;
         //end;

       //---- Активность рейса
       if (full_mas[idx,22]<>'0') and (full_mas[idx,22]<>'') then
        begin
          form1.StringGrid1.Cells[9,m]:='1';
        end
       else
       begin
         form1.StringGrid1.Cells[9,m]:='0';
       end;
       //----- № расписания
       form1.StringGrid1.Cells[1,m]:=full_mas[idx,1];

       //----- Время отправления\прибытия
       if trim(full_mas[idx,16])='2' then
          begin
            form1.StringGrid1.Cells[2,m]:=full_mas[idx,12];
          end;
       if trim(full_mas[idx,16])='1' then
          begin
            form1.StringGrid1.Cells[2,m]:=full_mas[idx,10];
          end;
       //----- Признак отправления или прибытия
       if full_mas[idx,16]='2' then
          begin
            form1.StringGrid1.Cells[3,m]:='ПРИБ';
          end;
       if full_mas[idx,16]='1' then
          begin
            form1.StringGrid1.Cells[3,m]:='ОТПР';
          end;
       If (trim(full_mas[idx,16])<>'1') AND (trim(full_mas[idx,16])<>'2') then showmessagealt('НЕОПРЕДЕЛЕННЫЙ ТИП РЕЙСА ! '+full_mas[idx,1]);

       //---- Наименование отрезка расписания
       form1.StringGrid1.Cells[4,m]:=trim(full_mas[idx,5])+' - '+trim(full_mas[idx,8]);

       //---- Площадка
       form1.StringGrid1.Cells[7,m]:=trim(full_mas[idx,2]);

       //---- Формирующийся /ТРАНЗИТНЫЙ/ ЗАКАЗНОЙ / удаленный
       //если рейс регулярный, тогда ставим отметку (формирующийся/транзитный)
       If (trim(full_mas[idx,0])='1') then
       form1.StringGrid1.Cells[8,m]:=trim(full_mas[idx,9])
       else
        form1.StringGrid1.Cells[8,m]:=trim(full_mas[idx,0]);

       // АТП
       form1.StringGrid1.Cells[10,m]:='['+trim(full_mas[idx,18])+'] '+trim(full_mas[idx,19]);
        //АТC
       form1.StringGrid1.Cells[11,m]:='['+ifthen(trim(full_mas[idx,27])='1','M2','M3')+'] '+trim(full_mas[idx,21]);

       // Количество мест в автобусе
       form1.StringGrid1.Cells[5,m]:=trim(full_mas[idx,25]);

       // Количество свободных мест в автобусе
       form1.StringGrid1.Cells[6,m]:=trim(full_mas[idx,34]);


       //если перевозчик или атс не определены, меняем флаги
       If (full_mas[idx,18]='0') or (trim(full_mas[idx,18])='') then
        full_mas[idx,43]:='0' else full_mas[idx,43]:='1';
       If (full_mas[idx,20]='0') or (trim(full_mas[idx,20])='') then
        full_mas[idx,44]:='0' else full_mas[idx,44]:='1';
        // Флаги: договор, лицензия, перевозчик, автобус, сезонность, активность ОПП
       form1.StringGrid1.Cells[12,m]:=full_mas[idx,41]+full_mas[idx,42]+full_mas[idx,43]+full_mas[idx,44]+full_mas[idx,17]+full_mas[idx,26];

       // Состояние рейса
        form1.StringGrid1.Cells[0,m]:=trim(full_mas[idx,28]);
       //0 - НЕОПРЕДЕЛЕНО (ОТКРЫТ)
       //1 - ДООБИЛЕЧИВАНИЕ (ОТКРЫТ) повторно
       //2 - ОТМЕЧЕН КАК ПРИБЫВШИЙ
       //3 - ОТМЕЧЕН КАК ОПАЗДЫВАЮЩИЙ (ОТКРЫТ)
       //4 - ОТПРАВЛЕН (Закрыт)
       //5 - СРЫВ ПО ВИНЕ АТП (ЗАКРЫТ)
       //6 - ЗАКРЫТ ПРИНУДИТЕЛЬНО

       // Количество дообилечиваний
       form1.StringGrid1.Cells[13,m]:=trim(full_mas[idx,29]);

       //инфо об операции                      время               дата
       form1.StringGrid1.Cells[14,m]:=trim(full_mas[idx,31])+'/'+trim(full_mas[idx,30]);

       //операция кто совершил
       If trim(full_mas[idx,32])='' then form1.StringGrid1.Cells[15,m]:='' else
        begin
       If trim(full_mas[idx,33])='' then
       form1.StringGrid1.Cells[15,m]:='диспетчер: '+trim(full_mas[idx,32])
       else
       form1.StringGrid1.Cells[15,m]:='диспетчер: '+trim(full_mas[idx,32])+'   Примечание:'+trim(full_mas[idx,33]);
       end;

       //дата отправления удаленки
      If (full_mas[idx,0]<>'0') and (full_mas[idx,0]<>'1') and (full_mas[idx,0]<>'2')  then
       form1.StringGrid1.Cells[16,m]:=trim(full_mas[idx,11]);
     end;
  Stringgrid1.visible:=true;
  //sleep(50);
  //application.ProcessMessages;
  active_check:=false; //флаг выполнения обновления
  setlabels; //прописать доп инфу по лейбам

  If Edit1.Visible=false then form1.StringGrid1.SetFocus;
  //form1.Label44.caption:=inttostr(masindex);//$
  form1.label46.Caption:=' ';
  //If filtr<>1 then
  //всего рейсов
     form1.label46.Caption:=' '+inttostr(length(filtr_mas));
end;
end;


//******************************** ОТРИСОВКА ГРИДА *****************************************
procedure TForm1.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
   n,pred,kolslow,nTop,horiz,vert,margin,shrift:integer;
   s1,s2,sFlag,sfree,first,vv:string;
   fltransit,vihod,late:boolean;
begin
   If (aCol>7) then exit;//не рисовать лишние столбцы
   If not form1.StringGrid1.visible then exit;


  //if form1.Panel5.Visible=true then exit;
  with Sender as TStringGrid, Canvas do
   begin
    //если есть время (прибытия/отправления)
     If (utf8length(Cells[2, aRow])=5) and (aRow>0) then
     //vv:=(Cells[2, aRow]);
     //If (incMinute(now(),-1*lateminutes))>strtodatetime('27-04-2016'+' '+Cells[2, aRow])
     If (incMinute(now(),-1*lateminutes))>strtodatetime(FormatDateTime('dd-mm-yyyy',work_date)+' '+Cells[2, aRow],mySettings)
      //>strtodatetime(datetostr(work_date)+' '+Cells[2, aRow]))
       then late:=true
       else late:=false;
    vihod:=false;
    fltransit:=false;
    margin:=12;
    horiz:=((aRect.Right-aRect.left) div 2);
    vert:=(form1.StringGrid1.RowHeights[aRow]) div 2;

    AntialiasingMode:=amOff;
    Font.Quality:=fqDraft;
    // Заголовок
       if (aRow=0) then
         begin
           Brush.Color:=clWhite;
           FillRect(aRect);
           Font.Color:=clBlack;
           font.Height:=14;
           font.Style:=[];
           s1:=trim(cells[aCol, aRow]);
           s2:='';
           pred:=0;
           kolslow:=0;
           for n:=1 to UTF8Length(s1) do
             begin
               if UTF8copy(s1,n,1)='*' then
                 begin
                  s2:=UTF8copy(s1,pred+1,n-pred-1);
                  TextOut(aRect.left+horiz - (form1.StringGrid1.canvas.TextWidth(s2) div 2), aRect.Top+(form1.StringGrid1.canvas.TextHeight(s2)*kolslow), s2);
                  kolslow:=kolslow+1;
                  s2:='';
                  pred:=n;
                 end;
               if (n=UTF8Length(s1)) and not(UTF8copy(s1,n,1)='*') then
                 begin
                   s2:=UTF8copy(s1,pred+1,n-pred);
                   TextOut(aRect.left+horiz - (form1.StringGrid1.canvas.TextWidth(s2) div 2), aRect.Top+(form1.StringGrid1.canvas.TextHeight(s2)*kolslow), s2);
                 end;
               // Высота заголовка
               //if (form1.StringGrid1.canvas.TextHeight(form1.StringGrid1.cells[aCol, aRow])*kolslow+12+3)>form1.StringGrid1.RowHeights[aRow] then
                 //begin
                   //form1.StringGrid1.RowHeights[aRow]:=(form1.StringGrid1.canvas.TextHeight(form1.StringGrid1.cells[aCol, aRow])*(kolslow+1)+3);
                 //end;
             end;
            //TextOut(aRect.left+horiz - (form1.StringGrid1.canvas.TextWidth(form1.StringGrid1.cells[aCol, aRow]) div 2), aRect.Top+12, Cells[aCol, aRow]);
            exit;
         end;

     //sFlag[1] - флаг договора
     //sFlag[2] - флаг лицензии
     //sFlag[3] - флаг перевозч
     //sFlag[4] - флаг атс
     //sFlag[5] - флаг сезонность
     //sFlag[6] - флаг АКТИВНОСТИ Опп

   sFlag:=trim(form1.stringgrid1.Cells[12,aRow]);//строка флагов
   If (form1.stringgrid1.Cells[9,aRow]='1') then vihod:=true;//активность по всем флагам
   if (form1.stringgrid1.Cells[8,aRow]='0') then fltransit:=true;  //---- Если ТРАНЗИТ

   //if (gdSelected in aState) then
   //      begin
   //        visota := 48;
   //       If vihod then
   //       begin
   //       visota := 85;
   //      If sFlag[1]='0' then visota:=visota+25;
   //      If sFlag[2]='0' then visota:=visota+25;
   //      If trim(Cells[15,aRow])<>'' then  visota:=visota+20;
   //        end;
   //         RowHeights[aRow]:=visota;
   //
   //      end
   //         else  RowHeights[aRow]:=48;
   //
   // If form1.Stringgrid1.focused or form1.Edit1.Focused then form1.Stringgrid1.Invalidate;
   //если рейс удаленки
   If (Cells[8,0]<>'1') and (Cells[8,0]<>'2') and (Cells[8,0]<>'') then
   begin
      Brush.Color:=rgbtocolor(155,250,100)
     end
   else
   begin
    // Фон ячеек для прибытия и отправления
    If not((form1.StringGrid1.Cells[0,Arow]='0') or (form1.StringGrid1.Cells[0,Arow]='1') or (form1.StringGrid1.Cells[0,Arow]='3')) then
        begin
           If trim(form1.StringGrid1.Cells[0,Arow])='' then
             //пустая строка
             Brush.Color:=rgbtocolor(217,250,250)
           else
            //---- Если рейс отработал
              Brush.Color:=rgbtocolor(240,230,200);
         end
          else
         begin
            //---Если отправление
           if (form1.stringgrid1.Cells[3,aRow]='ОТПР') then
              Brush.Color:=rgbtocolor(215,240,250);
           //---Если прибытие
           if (form1.stringgrid1.Cells[3,aRow]='ПРИБ') then
              Brush.Color:=rgbtocolor(236,250,236);
          end;
    end;

           //---Если неактивен - все равно показываем для возврата и закрытия
           if (Cells[1,aRow]<>'') and not vihod then
               begin
                If not vihod then
                   begin
                   Brush.Color:=clSilver
                   end
                else
                 begin
                 Brush.Color:=rgbtocolor(215,240,250);
                 end;
               end;
        FillRect(aRect);    //делаем фон
        font.Style:=[];
        If late and (form1.StringGrid1.Cells[0,Arow]='0')
         then font.Color:=clRed
          else font.Color:=clBlack;


 //// ===============================================================
//ЦЕНТАРЛЬНАЯ ШИРОКАЯ ВЫДЕЛЕННАЯ СТРОКА
//// ===============================================================
     //if (gdSelected in aState) then
 if (aRow=trows+1) then
      begin
         //линии выделения
          pen.Width:=12;
          pen.Color:=clMaroon;
          MoveTo(aRect.left,aRect.bottom-1);
          LineTo(aRect.right,aRect.Bottom-1);
          MoveTo(aRect.left,aRect.top-1);
          LineTo(aRect.right,aRect.Top);

         font.height:=21;
         font.Style:=[fsBold];

 //состояние рейса, дата, время
  if (aCol=0) then
     begin
          //рисуем дату операции
           If (trim(form1.StringGrid1.Cells[14,Arow])<>'/') then// and (datetostr(date)<>copy(form1.StringGrid1.Cells[14,Arow],10,10)) then
              begin
                font.Height:=vert div 3;
                font.Style:=[];
                TextOut(aRect.left+5,  aRect.Bottom-font.Height*3,  copy(form1.StringGrid1.Cells[14,Arow],10,10));
                TextOut(aRect.left+10, aRect.Bottom-font.Height-10, copy(form1.StringGrid1.Cells[14,Arow],1,8));
              end;
     end;

    // № расписания
    if (aCol=1) then
      begin
             //---Если дообилечивание
             if Cells[0,aRow]='1' then
              begin
             //(Cells[3,aRow]='ОТПР') and
            If (Cells[13,aRow]<>'0') and
            (Cells[13,aRow]<>'') then
              begin
               pen.Width:=1;
               pen.Color:=clBlue;
               font.Height:=19;
               font.Color:=clMaroon;
               canvas.Rectangle(aRect.right-textheight(Cells[13,aRow])-4,aRect.top+3,aRect.right-4,aRect.top+25);
               TextOut(aRect.right-textheight(Cells[13,aRow]), aRect.Top+2,inttostr(strtoint(Cells[13,aRow])+1));

              end;
              end;
            //font.Height:=(vert-margin) div 2;
            //font.Style:=[fsBold];
            //font.Color:=clBlack;
      end;

         // Время
    if (aCol=2) then
         begin
           font.Style:=[];
             //---- рейс Удаленки
           if (Cells[8,aRow]<>'0') and (Cells[8,aRow]<>'1') and (Cells[8,aRow]<>'2') and (Cells[8,aRow]<>'') then
              begin
                     pen.Width:=1;
                     font.color:=clFuchsia;
                     font.Height:=13;
                     pen.Color:=clBlack;
                     canvas.Rectangle(aRect.left+1,aRect.top+8,aRect.right-2,aRect.top+25);
                     TextOut(aRect.left+3, aRect.Top+9, 'УДАЛЕНКА');
                     font.Style:=[fsBold];
                     TextOut(aRect.left+4,aRect.bottom-23, Cells[16,aRow]);//дата отправления удаленки
              end;
            //---- ЗАКАЗНОЙ
           if (Cells[8,aRow]='2') then
              begin
                     pen.Width:=1;
                     font.color:=clMaroon;
                     font.Height:=13;
                     pen.Color:=clBlack;
                     canvas.Rectangle(aRect.left+1,aRect.top+8,aRect.right-2,aRect.top+25);
                     TextOut(aRect.left+3, aRect.Top+9, 'ЗАКАЗНОЙ');
              end;
           //регулярный формирующийся или транзитный
          if (Cells[8,aRow]='0') OR (Cells[8,aRow]='1') then
           begin
             //---Если есть дообилечивание
             if Cells[0,aRow]='1' then
              begin
             //(Cells[3,aRow]='ОТПР') and
             If (Cells[13,aRow]<>'0') and (Cells[13,aRow]<>'') then
              begin
               font.color:=clBlue;
               font.Height:=12;
               TextOut(aRect.left+2, aRect.Top+7,'ведомости');
              end;
              end;
             end;
            font.Height:=(vert-margin) div 2 +4;
            font.Style:=[fsBold];
            font.Color:=clBlack;
    end;
        // Свободных мест
    if (aCol=6) then
      begin
         shrift:=25;
         font.Height:=shrift;
            //font.Height:=(vert) div 2;
      end;

         // Наименование отрезка расписания + направление
  if (aCol=4) then
     begin
           ntop:=7; //сдвиг вниз относительно предыдущей строки
           font.Height:=(vert-margin) div 2 +1;
           If Cells[1,aRow]='' then exit;
           If length(sFlag)<>6 then
              begin
              TextOut(aRect.Left + 35, aRect.Top+ntop, 'НЕТ ДАННЫХ РЕЙСА !!!');
              exit;
              end;
           //Наименование рейса
           TextOut(aRect.Left + 35, aRect.Top+ntop, Cells[aCol, aRow]);
           ntop:=ntop+font.Height+4;
           //не ходит по активности ОПП
          If (sFlag[6]='0') then
           begin
            font.Height:=(vert-margin) div 2 -2;
            font.Color:=clMaroon;
            TextOut(aRect.Left + 20, aRect.Top+ntop,'РАСПИСАНИЕ НЕ АКТИВНО !');
            exit;
            end;

          //не ходит сегодня
           If sFlag[5]='0' then
           begin
            font.Height:=(vert-margin) div 2 ;
            font.Color:=clGreen;
            TextOut(aRect.Left + 20, aRect.Top+ntop,'Не работает по календарному плану !');
            //ntop:=ntop+font.Height+3;
            exit;
           end;
                //АТС, ПЕРЕВОЗЧИК, и кто отправил
           // ПЕРЕВОЗЧИК
           font.Height:=(vert-margin) div 2 -1;
           If not fltransit then font.Color:=clNavy else font.Color:=clBlack;
           if sFlag[3]='1' then
           begin
             font.Style:=[];
             TextOut(aRect.Left + 20, aRect.Top+ntop,'перевозчик:'+Cells[10, aRow]);
           end
           else
           begin
             font.Color:=clPurple;
             TextOut(aRect.Left + 20, aRect.Top+ntop,'НЕ ОПРЕДЕЛЕН ПЕРЕВОЗЧИК НА РЕЙС  !');
            end;
           ntop:=ntop+font.Height+3;

           // АТС
           font.Height:=(vert-margin+4) div 2;
           if sFlag[4]='1' then
           begin
            font.Style:=[];
            TextOut(aRect.Left + 10, aRect.Top+ntop,'атс:'+Cells[11, aRow]);
           end
           else
           begin
            font.Color:=clMaroon;
            TextOut(aRect.Left + 20, aRect.Top+ntop,'АВТОБУС НЕ ОПРЕДЕЛЕН НА РЕЙС  !');
            exit;
            end;
           ntop:=ntop+font.Height+3;

           //отсутствует договор
           If sFlag[1]='0' then
           begin
            font.Height:=(vert) div 3;
            font.Color:=clRed;
            TextOut(aRect.Left + 20, aRect.Top+ntop,'ОТСУТСТВУЕТ ДОГОВОР ПЕРЕВОЗКИ !');
            ntop:=ntop+font.Height+3;
           end;
            //отсутствует лицензия
           If sFlag[2]='0' then
           begin
            font.Height:=(vert) div 3;
            font.Color:=clRed;
            TextOut(aRect.Left + 20, aRect.Top+ntop,'ОТСУТСТВУЕТ ЛИЦЕНЗИЯ НА ПЕРЕВОЗКУ !');
            ntop:=ntop+font.Height+3;
           end;
           // операция кто совершил
           If trim(Cells[15,aRow])<>'' then
           begin
           font.Height:=(vert-margin div 2) div 3;
           font.Style:=[];
           font.Color:=clBlack;
           TextOut(aRect.Right -canvas.TextWidth(Cells[15, aRow])-20,aRect.Top+nTop,Cells[15, aRow]);
           end;
    end;
 end
  //=============== КОНЕЦ - ЦЕНТРАЛЬНОЙ СТРОКИ ============================
      //// ===============================================================
  else
    begin

       font.height:=(vert+margin+2) div 2;
           //********************** не в фокусе ********************************
    //дата или время операции
    if (aCol=0) then
     begin
            //рисуем время операции
            If trim(form1.StringGrid1.Cells[14,Arow])<>'/' then
              begin
                font.height:=(vert+6) div 2;
               //если операция совершена сегодня, то рисуем только время
                If FormatDateTime('dd-mm-yyyy',date)=copy(form1.StringGrid1.Cells[14,Arow],10,10) then
                //If (stringreplace(datetostr(date),'.',#32,[rfReplaceAll]))<>(stringreplace(copy(form1.StringGrid1.Cells[14,Arow],10,10),'-',#32,[rfReplaceAll])) then
                TextOut(aRect.left+10, aRect.Bottom-font.Height-10, copy(form1.StringGrid1.Cells[14,Arow],1,8))
                else
                 TextOut(aRect.left+5, aRect.Bottom-font.Height-10, copy(form1.StringGrid1.Cells[14,Arow],10,10));
              end;
       end;

    // № расписания
    if (aCol=1) then
      begin
      end;
    // Время
    if (aCol=2) then
      begin
          font.Height:=13;
          TextOut(aRect.left+6,aRect.bottom-20, Cells[16,aRow]);//дата отправления удаленки
          font.height:=(vert+margin) div 2;
      end;

    // Свободных мест
    if (aCol=6) then
      begin
        shrift:=(vert+margin) div 2;
        font.Height:=shrift;
      end;

   // Наименование отрезка расписания + направление
     if (aCol=4) then
      begin
        //---- УДАЛЕНКА
           if (Cells[8,aRow]<>'0') and (Cells[8,aRow]<>'1') and (Cells[8,aRow]<>'2') and (Cells[8,aRow]<>'') then
              begin
                     pen.Width:=1;
                     font.color:=clFuchsia;
                     font.Height:=19;
                     pen.Color:=clBlack;
                     canvas.Rectangle(aRect.left+1,aRect.top+1,aRect.left+21,aRect.top+21);
                     TextOut(aRect.left+3, aRect.Top, 'У');
              end;
                  //---- ЗАКАЗНОЙ
           if (Cells[8,aRow]='2') then
              begin
                     pen.Width:=1;
                     font.color:=clMaroon;
                     font.Height:=19;
                     pen.Color:=clBlack;
                     canvas.Rectangle(aRect.left+1,aRect.top+1,aRect.left+21,aRect.top+21);
                     TextOut(aRect.left+3, aRect.Top, 'З');
              end;
           //---Если дообилечивание
           if (Cells[0,aRow]='1') and (Cells[13,aRow]='0') then
              begin
               pen.Width:=1;
               pen.Color:=clBlue;
               font.Height:=19;
               font.color:=clMaroon;
               canvas.Rectangle(aRect.left+1,aRect.top+22,aRect.left+21,aRect.top+44);
               TextOut(aRect.left+4, aRect.Top+22, 'Д');
              end;
             //---Если были ведомости дообилечивания
           if (Cells[13,aRow]<>'0') and (Cells[13,aRow]<>'') then
              begin
               pen.Width:=1;
               pen.Color:=clBlue;
               font.Height:=19;
               font.color:=clMaroon;
                canvas.Rectangle(aRect.left+1,aRect.top+22,aRect.left+textheight(Cells[13,aRow])-2,aRect.top+44);
                TextOut(aRect.left+4, aRect.Top+22,inttostr(strtoint(Cells[13,aRow])+1));
              end;
           font.height:=(vert+margin) div 2;
           font.Style:=[];
          font.Color:=clBlack;
           // Наименование рейса
           TextOut(aRect.Left + 35, aRect.Top+((aRect.bottom-aRect.top) div 2)-font.Height div 2, Cells[aCol, aRow]);
     end;

            pen.Width:=2;
            pen.Color:=clTeal;
            //MoveTo(aRect.left,aRect.bottom-1);
            //LineTo(aRect.right,aRect.Bottom-1);
          end;
//// ===============================================================
  //=============== КОНЕЦ - ВСЕ КРОМЕ ЦЕНТРАЛЬНОЙ СТРОКИ ============================
  //// ===============================================================
       // № расписания
          if (aCol=1) then
          begin
            TextOut(aRect.left+horiz-(form1.StringGrid1.canvas.TextWidth(cells[aCol,aRow]) div 2),aRect.Top +(aRect.bottom-aRect.top) div 2 -font.Height div 2, cells[aCol,aRow]);
            //font.height:=12;
            //TextOut(aRect.left+2,aRect.bottom -15, sFlag);
           end;

         // Время
        if (aCol=2) then
          begin
            TextOut(aRect.left+horiz-(form1.StringGrid1.canvas.TextWidth(cells[aCol,aRow]) div 2),aRect.Top +(aRect.bottom-aRect.top) div 2 -font.Height div 2, cells[aCol,aRow]);
          end;

        // Значки отправление прибытие
         if (aCol=3) then
         begin
           //---Если отправление
           if (trim(form1.stringgrid1.Cells[aCol,aRow])='ОТПР') then
              begin
                canvas.Pen.Color:=clGreen;
                canvas.Pen.Width:=3;
                canvas.Line(arect.Left+12,arect.Top+30,arect.Left+22,arect.Top+20);
                canvas.Line(arect.Left+22,arect.Top+20,arect.Left+32,arect.Top+30);
                canvas.Line(arect.Left+12,arect.Top+30,arect.Left+32,arect.Top+30);
              end;
           //---Если прибытие
          if (trim(form1.stringgrid1.Cells[aCol,aRow])='ПРИБ') then
              begin
                canvas.Pen.Color:=clBlue;
                canvas.Pen.Width:=2;
                canvas.Line(arect.Left+12,arect.Top+10,arect.Left+32,arect.Top+10);
                canvas.Line(arect.Left+32,arect.Top+10,arect.Left+22,arect.Top+20);
                canvas.Line(arect.Left+22,arect.Top+20,arect.Left+12,arect.Top+10);
              end;
          end;

          // Всего мест
         if (aCol=5) then
           begin
             TextOut(aRect.left+horiz -(form1.StringGrid1.canvas.TextWidth(cells[aCol,aRow]) div 2), aRect.Top+((aRect.bottom-aRect.top) div 2)-font.Height div 2, cells[aCol,aRow]);
            end;

             // Свободных мест
        if (aCol=6) then
           begin
             sfree:=cells[aCol,aRow];//свободно мест
             first:='';//продано до 1 пункта
             //If (time-tfresh)>2 then font.Color:=clBlack else
             font.Color:=clTeal;

            If (pos('/',cells[aCol,aRow])>0)
           //and (cells[1,aRow]='283')
            then
             begin
                sfree:=copy(cells[aCol,aRow],1,pos('/',cells[aCol,aRow])-1);
                first:=copy(cells[aCol,aRow],pos('/',cells[aCol,aRow]),10);
              end;

             TextOut(aRect.left+horiz -(form1.StringGrid1.canvas.TextWidth(sfree)), aRect.Top+((aRect.bottom-aRect.top) div 2)-font.Height , sfree);
             If first<>'' then
             begin
               font.Color:=clBlack;
               font.Height:=shrift-2;
             // TextOut(aRect.right-form1.StringGrid1.canvas.TextWidth(sfree)-10,aRect.bottom-font.Height*2+7 ,first);
                TextOut(aRect.left+horiz, aRect.bottom-font.Height*2+7 ,first);
             end;
        end;


          // Площадка
        if (aCol=7) then
          begin
            TextOut(aRect.left+horiz -(form1.StringGrid1.canvas.TextWidth(cells[aCol,aRow]) div 2), aRect.Top+((aRect.bottom-aRect.top) div 2)-font.Height div 2, cells[aCol,aRow]);
           end;

        // Направление
         //if (aRow>0) and (aCol=3) then
         //  begin
         //    font.Size:=12;
         //    TextOut(aRect.Left + 5, aRect.Top+3, Cells[aCol, aRow]);
         //   end;

       //---- Формирующийся
          //if (trim(form1.stringgrid1.Cells[8,aRow])='1') and (aCol=4) and not(aCol=8)  and not(aCol=7) then
          //    begin
          //           pen.Width:=1;
          //           font.color:=clGreen;
          //           font.Size:=14;
          //           pen.Color:=clGreen;
          //           canvas.Rectangle(aRect.left+1,aRect.top+1,aRect.left+21,aRect.top+21);
          //           TextOut(aRect.left+3, aRect.Top, 'Ф');
          //    end;
          //*************************** ТИП РЕЙСА *******************************************************
          If (aCol=4) then
          begin
           //TextOut(aRect.Right-30, aRect.top+5, inttostr(dispcnt));
           //TextOut(aRect.Right-40, aRect.bottom-25, inttostr(masindex));
          //---- Транзитный
          If fltransit then
               begin
                        pen.Width:=1;
                        font.color:=clBlue;
                        font.Height:=19;
                        pen.Color:=clBlue;
                        canvas.Rectangle(aRect.left+1,aRect.top+1,aRect.left+21,aRect.top+21);
                        TextOut(aRect.left+5, aRect.Top, 'Т');
               end;
             end;

       //------------- Состояние рейса
      if (aCol=0) then
       //0 - НЕОПРЕДЕЛЕНО (ОТКРЫТ)
       //1 - ДООБИЛЕЧИВАНИЕ (ОТКРЫТ) повторно
       //2 - ОТМЕЧЕН КАК ПРИБЫВШИЙ
       //3 - ОТМЕЧЕН КАК ОПАЗДЫВАЮЩИЙ (ОТКРЫТ)
       //4 - ОТПРАВЛЕН (Закрыт)
       //5 - СРЫВ ПО ВИНЕ АТП (ЗАКРЫТ)
       //6 - ЗАКРЫТ ПРИНУДИТЕЛЬНО
          begin
            font.Height:=16;
            font.Style:=[];

            // 0 НЕОПРЕДЕЛЕНО (ОТКРЫТ)
            // 1 - ДООБИЛЕЧИВАНИЕ (ОТКРЫТ) повторно
            if (form1.StringGrid1.Cells[aCol,Arow]='1') then
                begin
                  font.color:=clMaroon;
                  font.Height:=12;
                  font.Style:=[fsBold];
                  TextOut(aRect.left+5, aRect.Top+3, 'ДООБИЛЕ-');
                  TextOut(aRect.left+25, aRect.Top+14,'ЧИВАНИЕ');
                  //TextOut(aRect.left+5, aRect.Top+12, 'ДОО');
                  //font.color:=clBlue;
                  //TextOut(aRect.left+5+textwidth('ДОО')+1, aRect.Top+12, 'БИЛЕЧ');
                  //font.color:=clRed;
                  //TextOut(aRect.left+5+textwidth('ДОО')+1+textwidth('БИЛЕЧ')+1, aRect.Top+12, 'ИВАНИЕ');
                end;

            //2 - ОТМЕЧЕН КАК ПРИБЫВШИЙ
            if (form1.StringGrid1.Cells[aCol,Arow]='2') then
                begin
                  font.color:=clBlack;
                  TextOut(aRect.left+5, aRect.Top+5, 'ПРИБЫЛ');
                end;

            //3 - ОТМЕЧЕН КАК ОПАЗДЫВАЮЩИЙ (ОТКРЫТ)
            if (form1.StringGrid1.Cells[aCol,Arow]='3') then
                begin
                  font.color:=clMAroon;
                  TextOut(aRect.left+5, aRect.Top+5, 'ОПАЗД');
                end;

            //4 - ОТПРАВЛЕН (Закрыт)
            if (form1.StringGrid1.Cells[aCol,Arow]='4') then
                begin
                  font.color:=clBlack;
                  TextOut(aRect.left+3, aRect.Top+5, 'ОТПРАВЛЕН');
                end;

            //5 - СРЫВ ПО ВИНЕ АТП (ЗАКРЫТ)
            if (form1.StringGrid1.Cells[aCol,Arow]='5') then
                begin
                  font.color:=clMaroon;
                  TextOut(aRect.left+5, aRect.Top+5, 'СРЫВ');
                end;

            //6 - ЗАКРЫТ ПРИНУДИТЕЛЬНО
            if (form1.StringGrid1.Cells[aCol,Arow]='6') or (form1.StringGrid1.Cells[aCol,Arow]='7') then
                begin
                  font.color:=clRed;
                  TextOut(aRect.left+5, aRect.Top+5, 'ЗАКРЫТ');
                end;
           If length(sFlag)=6 then
           begin
                //---Если рейс АКТИВЕН,но нет активного договора или лицензии рисуем флажок
           if ((sFlag[1]='0') or (sFlag[2]='0')) and (sFlag[5]='1')  then
               begin
                // Рисуем ФЛАЖОК
                canvas.Pen.Width:=3;
                canvas.Pen.Color:=clBlack;
                // Флагшток
                canvas.Line(arect.Left+4,arect.Top+40,arect.Left+4,arect.Top+10);
                canvas.Pen.Width:=5;
                // Флаг
                canvas.Pen.Color:=clRed;
                canvas.Line(arect.Left+8,arect.Top+11,arect.Left+35,arect.Top+18);
                canvas.Line(arect.Left+35,arect.Top+18,arect.Left+8,arect.Top+25);
                canvas.Line(arect.Left+8,arect.Top+25,arect.Left+8,arect.Top+11);
               end;
           end;
          end;
   end;
end;


procedure TForm1.StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
var
   mindex:integer;
begin
  with form1 do
begin
  //If Stringgrid1.RowCount<2 then exit;
  //If trim(stringgrid1.Cells[1,stringgrid1.Row])='' then exit;
 //setlabels;//прописать доп информацию
 end;
end;


//*******************************************  КОНТЕКСТНЫЙ ПОИСК ****************************
procedure TForm1.Edit1Change(Sender: TObject);
begin
 //запускаем таймер ожидания поиска
  If  form1.IdleTimer3.Enabled=false then
     form1.IdleTimer3.Enabled:=true;
  If  form1.IdleTimer3.AutoEnabled=false then
     form1.IdleTimer3.AutoEnabled:=true;
  //If not_search_flag=true then exit;
end;



//*******************************************  КОНТЕКСТНЫЙ ПОИСК ****************************
procedure TForm1.IdleTimer3Timer(Sender: TObject);
begin
   with form1 do
begin
 form1.IdleTimer3.AutoEnabled:=false;
 form1.IdleTimer3.Enabled:=false;

  if UTF8Length(trimleft(Edit1.Text))>0 then
    begin
     If filtr<>8 then
       begin
      if (trimleft(Edit1.Text)[1] in ['0'..'9']) then
         qsearch(1)
       else qsearch(2);
      Label40.Caption:='РЕЗУЛЬТАТ ПОИСКА';
      findex:=0;
      If length(filtr_mas)>0 then
        begin
         //filtr:=0;
         findex:=low(filtr_mas);
         end;
       end;
     //поиск рейсов по промежуточному населенному пункту
      If filtr=8 then
        begin
          search_city:=UpperAll(trim(Edit1.Text))+'%';
          form1.Disp_refresh(0,1);
        end;
    end
  else
     begin
      //filtr:=1;
      Edit1.Visible:=false;
      mainsrv:=false;
     end;
    get_list_shedule;

    //not_search_flag:=false;
end;
end;


//***********************************************   Обновляем информацию об активном пользователе
procedure TForm1.Active_appTimer(Sender: TObject);
begin
//   //if active_user_sql(form1.ZConnection2,form1.ZReadOnlyQuery2)=1 then
//   //   begin
//   //    form1.Active_app.Enabled:=false;
//   //    showmessagealt('Соединение с основным сервером потеряно !'+#13+'Проверьте соединение и/или'+#13+' обратитесь к администратору.');
//   //    //halt;
//   //   end;
end;


// Анимация строки
procedure tform1.anim_string;
 var
   n:integer;
begin
 //showmessage(inttostr((cant.Width))+' - '+inttostr((form1.pBox.Width)));
 //cant2:=TBGRABitmap.Create(form1.pBox.Width,form1.pBox.Height,BGRAWhite);
 //n:=cant.Width;
 //n:=form1.pBox.Width;
 //for n:=0 to (cant.Width-form1.pBox.Width) do
 //   begin
 //     sleep(10);
 //     cant2.PutImage(0-n,0,cant,dmSet);
 //     //form1.Label1.Caption:=inttostr(n);
 //     //cant2.FillEllipseAntialias(50,50,20,20,BGRAWhite);
 //     form1.pBox.Repaint;
 //     application.ProcessMessages;
 //     //cant.Draw(form1.pBox.canvas,0-n,0,true);
 //   end;
 //cant2.free;
end;

procedure TForm1.alarm_show(num:integer);
var
  t_p:integer=0;
   n:integer;
   x:array of integer;
   //rrr:TSize;
   //sd:TBGRAPixel;
begin
  //SetLength(x,0);
  //if not(cant=nil) then cant.Free;
  // Подсчитываем необходимое количество пикселей для строки
  //cant:=TBGRABitmap.Create(form1.pBox.Width,form1.pBox.Height,BGRAWhite);
  //cant.FontHeight:=13;//form1.pBox.Height div 2 ;
  //cant.canvas.Font.Style:=[fsBold];
  //cant.canvas.Font.Height:=form1.Height-20;
  //cant.canvas.Font.Style:=[fsBold];
  //t_p:=form1.pBox.Height*2;
  //SetLength(x,length(x)+1);
  //x[length(x)-1]:=form1.pBox.Height;
  //cant.TextOut(10,form1.pBox.Height+10,alarm_mas[num],ColortoBGRA(clRed),taLeftJustify);
    //cant.TextOut(10,3,'ПРИВЕТ ЛУНАТИКАМ !',ColortoBGRA(clRed),taLeftJustify);
  //for n:=0 to length(alarm_mas)-1 do
  //  begin
  //   rrr:=cant.TextSize(alarm_mas[n]);
  //   t_p:=t_p+rrr.cx;
  //   SetLength(x,length(x)+1);
  //   x[length(x)-1]:=x[length(x)-2]+rrr.cx+50;
  //  end;
  //cant:=TBGRABitmap.Create(t_p,form1.pBox.Height,BGRAWhite);
  //cant.FontHeight:=14;//form1.pBox.Height div 2 ;
  //cant.canvas.Font.Style:=[fsBold];
  //for n:=0 to length(alarm_mas)-1 do
  //  begin
  //    cant.TextOut(x[n],3,alarm_mas[n],ColortoBGRA(clRed),taLeftJustify);
  //  end;
   //showmessage(inttostr((cant.Width))+' - '+inttostr((form1.pBox.Width)));
   //application.ProcessMessages;
 //cant2:=TBGRABitmap.Create(form1.pBox.Width,form1.pBox.Height,BGRAWhite);
 //n:=cant.Height;
 //n:=form1.pBox.Height;
 //n:=(cant.Height-form1.pBox.Height);
 //cant2.FillRect(1,1,5,5,BGRABlack, dmSet);
   //cant2.PutImage(0,0,cant,dmSet);
 //for n:=0 to (cant.Height-form1.pBox.Height) do
    //begin
      //cant2.PutImage(0,0,cant,dmSet);
      //form1.Label1.Caption:=inttostr(n);
      //cant2.FillEllipseAntialias(50,50,20,20,BGRAWhite);
      //form1.pBox.Repaint;
      //application.ProcessMessages;
      //cant.Draw(form1.pBox.canvas,0-n,0,true);
    //end;
   //cant2.free;
end;

//****************************   нарисовать предупреждения на канве  ********************************
procedure Tform1.alarm_draw;
 var
   t_p:integer=0;
   n:integer;
   x:array of integer;
   //rrr:TSize;
   //sd:TBGRAPixel;
   sdf:TFontstyles;
begin

  //if length(alarm_mas)=0 then exit;
  //SetLength(x,0);
  //if not(cant=nil) then cant.Free;
  //// Подсчитываем необходимое количество пикселей для строки
  //cant:=TBGRABitmap.Create(form1.pBox.Width,form1.pBox.Height,BGRAWhite);
  //cant.FontHeight:=14;//form1.pBox.Height div 2 ;
  //cant.canvas.Font.Style:=[fsBold,fsItalic];
  ////cant.canvas.Font.Height:=form1.Height-20;
  ////cant.canvas.Font.Style:=[fsBold];
  //t_p:=form1.pBox.Width*2;
  //SetLength(x,length(x)+1);
  //x[length(x)-1]:=form1.pBox.Width;
  //for n:=0 to length(alarm_mas)-1 do
  //  begin
  //   rrr:=cant.TextSize(alarm_mas[n]);
  //   t_p:=t_p+rrr.cx;
  //   SetLength(x,length(x)+1);
  //   x[length(x)-1]:=x[length(x)-2]+rrr.cx+20;
  //  end;
  //cant.free;
  //
  //cant:=TBGRABitmap.Create(t_p,form1.pBox.Height,BGRAWhite);
  //cant.FontHeight:=14;//form1.pBox.Height div 2 ;
  //cant.canvas.Font.Style:=[fsBold,fsItalic];
  //for n:=0 to length(alarm_mas)-1 do
  //  begin
  //    cant.TextOut(x[n],3,alarm_mas[n],ColortoBGRA(clBlue),taLeftJustify);
  //  end;
end;


//*************************************************** ОТОБРАЖАТЬ ДАТУ И ВРЕМЯ *************************************
procedure TForm1.Timer1Timer(Sender: TObject);
var
    myYear, myMonth, myDay : Word;
    ntime:integer;
     HeapStat: TFPCHeapStatus;
begin
  // Часы + Дата
  DecodeDate(Date, myYear, myMonth, myDay);
  form1.label1.caption:=TimeToStr(Time);
  form1.label2.caption:=GetDayName(DayOftheWeek(Date))+'  '+IntToStr(myDay)+' '+GetMonthName(MonthOfTheYear(Date));
  ntime:=strtoint(formatdatetime('ss',time));
  If ntime mod 5 <>0 then exit;
  if length(alarm_mas)=0 then exit;
  ncnt:=ncnt+1;
  If ncnt<=high(alarm_mas) then ncnt:=low(alarm_mas);

  if form1.Label44.Visible=true then
  begin
  HeapStat:=GetFPCHeapStatus;
  //form1.Label44.Caption:='ПАМЯТЬ ВСЕГО : '+ inttostr(HeapStat.CurrHeapSize)+' СВОБОДНО: '+inttostr(HeapStat.CurrHeapFree)+' ЗАНЯТО: '+inttostr(HeapStat.CurrHeapUsed);
  end;
  // with Form1.pBox do
  //begin
  // Canvas.Clear;
  // canvas.Brush.Color:=clWhite;
  //Dec(slide,1);
  //Canvas.Font.Color:=clRed;
  //Canvas.Font.Style:=[fsBold];
  //Canvas.Font.Size := height div 2;
  //Canvas.TextOut(slide,trunc(height*0.1),textalarm);
  //if slide <= (0-canvas.TextWidth(textalarm)) then slide := Width;
  //end;

  //form1.alarm_show(ncnt);
  //form1.StringGrid1.SetFocus;
  //form1.alarm_draw;
  //application.ProcessMessages;
  //form1.StringGrid1.SetFocus;
  //form1.anim_string;
  //application.ProcessMessages;
  //form1.StringGrid1.SetFocus;
end;


procedure TForm1.pBoxPaint(Sender: TObject);
begin
  //if not(cant2=nil) then cant2.Draw(form1.pBox.canvas,0,0,true);
end;


//*************************** ОБНОВЛЕНИЕ ДАННЫХ ЭКРАНА ПРИ БЕЗДЕЙСТВИИ ************************
procedure TForm1.IdleTimer2Timer(Sender: TObject);
var
   tw,th:integer;
begin
 // При бездействии запускаем перерисовку StringGrid
 timeout_main_tik:=timeout_main_tik+1;
 //label45.Caption:=inttostr(timeout_main-timeout_main_tik);//$
 //label45.Caption:=inttostr(length(full_mas));
 if timeout_main_tik=timeout_main then
  begin
  //Если грид рейсов не в фокусе, не делать обновление экрана
   If not form1.StringGrid1.Focused then
      begin
       timeout_main_tik:=0;
       exit;
      end;
   //tek_row:=form1.StringGrid1.Row;
    //If filtr=0 then
      //begin
      //filtr:=1;
      //form1.Disp_refresh(1);
      //exit;
      //end;
    form1.Disp_refresh(0,0);
  end;
end;



//*************************************** ОБНОВЛЕНИЕ ДАННЫХ ЕДИНОЖДЫ ПРИ ВХОДЕ В ПРОГРАММУ **************************
procedure TForm1.Timer3Timer(Sender: TObject);
  var
   tw,th,n:integer;
   doneflag:boolean;
begin
   //paintmess(form1.StringGrid1,'ИДЕТ РАСЧЕТ РЕЙСОВ ! ПОДОЖДИТЕ...',clRed);
  form1.Timer3.Enabled:=false;
   //tek_row:=form1.StringGrid1.Row;
   //t1 := time;
   //form1.StringGrid1.Canvas.AntialiasingMode:=amOff;
   //form1.StringGrid1.Canvas.Font.Quality:=fqDraft;
   //form1.StringGrid1.Canvas.Font.Color:=clRed;
   //form1.StringGrid1.canvas.Font.Style:=[fsBold];
   //form1.StringGrid1.canvas.Brush.Color:=clBlue;
   //form1.StringGrid1.canvas.FillRect(form1.StringGrid1.Left,form1.StringGrid1.top,form1.StringGrid1.left+form1.StringGrid1.width,form1.StringGrid1.top+30);
   //form1.StringGrid1.canvas.Brush.Color:=clBlue;
   //form1.StringGrid1.Canvas.Font.Size:=26;
   //tw:=form1.StringGrid1.Canvas.TextWidth('ИДЕТ РАСЧЕТ РЕЙСОВ ! ПОДОЖДИТЕ... ');
   //tw:=form1.StringGrid1.Canvas.TextWidth('П О Д О Ж Д И Т Е !!!');
   //th:=form1.StringGrid1.Canvas.TextHeight('П О Д О Ж Д И Т Е !!!');
   //form1.StringGrid1.Canvas.textout(form1.StringGrid1.Left+(form1.StringGrid1.Width div 2)-(form1.StringGrid1.Canvas.TextWidth('ИДЕТ РАСЧЕТ РЕЙСОВ ! ПОДОЖДИТЕ... ') div 2),form1.StringGrid1.top+100,'ИДЕТ РАСЧЕТ РЕЙСОВ ! ПОДОЖДИТЕ... ');

   //application.ProcessMessages;
   //form1.Refresh;
   paintmess(form1.StringGrid1,'ИДЕТ РАСЧЕТ РЕЙСОВ ! ПОДОЖДИТЕ...',clRed);
   //заполенение массива рейсов
   //form1.Rascet_mas(0);
   filtr:=1; //тип фильтра
   //обновление контрольных значений
   md5_av_trip:='';
   md5_av_dog_lic:='';
   md5_operation:=''; //md5 на av_disp_oper
   md5_av_trip_add:=''; //md5 на av_trip_add
   md5_av_trip_atps:='';

   //возвращаем параметры локального сервера
  sale_server:=ConnectINI[14];
  otkuda_name:=server_name;

     paintmess(form1.StringGrid1,'ЗАГРУЗКА СПИСКА СЕРВЕРОВ ! ПОДОЖДИТЕ...',clGreen);
   //берем настройки локальных серверов для подключения                          3
   try
   List_Servers(form1.ZConnection2,form1.ZReadOnlyQuery2,strtoint(sale_server),id_user);
    except
     on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+sale_server+#13+'--c30');
     exit;
    end;
    end;
   active_check:=false; //флаг выполнения обновления


  // --------------------Соединяемся с локальным сервером----------------------
  If not(Connect2(form1.Zconnection2, 2)) then
   begin
    showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m9-');
    exit;
   end;
   active_check:=true; //флаг выполнения обновления

   doneflag:=false;
   //Открываем транзакцию
try
   If not form1.Zconnection2.InTransaction then
     begin
      form1.Zconnection2.StartTransaction;
     end
   else
     begin
       If form1.Zconnection2.InTransaction then form1.Zconnection2.Rollback;
       form1.Zconnection2.disconnect;
       showmessagealt('Ошибка ! Незавершенная транзакция !'+#13+'Попробуйте снова !');
       exit;
     end;
  form1.ZReadOnlyQuery2.SQL.Clear;
    //t1:=time();//$
    //--функция создает таблицу с рассчитанными значениями для рейсов текущего дня

  //form1.ZReadOnlyQuery2.SQL.Add('DROP TABLE IF EXISTS av_disp_current_day;');
  form1.ZReadOnlyQuery2.SQL.Add('select shed_disp_create_table(date(now()),'+sale_server+');');
  //showmessage(form1.ZReadOnlyQuery2.sql.Text);//$
    //try
       form1.ZReadOnlyQuery2.open;
         //except
            //showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
            //showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);//$
            //form1.ZReadOnlyQuery2.Close;
            //form1.Zconnection2.disconnect;
            //active_check:=false; //флаг выполнения обновления
            //exit;
          //end;

   If form1.ZReadOnlyQuery2.RecordCount>0 then
       If form1.ZReadOnlyQuery2.Fields.Fields[0].AsInteger>0 then
        doneflag:=true;

     FORM1.Zconnection2.Commit;
   except
     If ZConnection2.InTransaction then Zconnection2.Rollback;
     active_check:=false; //флаг выполнения обновления
     //showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+'Запрос SQL2: '+ZReadOnlyQuery2.SQL.Text);
   end;
  form1.ZReadOnlyQuery2.Close;
  form1.ZConnection2.Disconnect;
   If doneflag then
    begin
    If not form1.Get_current_day() then form1.Shedule_Calc(1);
    end
   else
   begin
     form1.Shedule_Calc(1);
   end;

   If form1.ZConnection2.Connected then form1.ZConnection2.Disconnect;
   //Сортировка всех рейсов по времени
   //filtr:=1; //тип фильтра
   //Form1.sort_full_mas(filtr);
   //определение элемента массива по текущему времени
   form1.get_time_index;

   //form1.getfreeseats(-1);//$*  пересчет свободных мест
    //t1:=now;
   // Отрисовка грида рейсов
   //form1.StringGrid1.Enabled:=true;
   form1.get_list_shedule;

   //str:='';
   //for n:=1 to 10 do
   //  begin
   //    //sleep(10);
   //    form1.get_list_shedule;
   //    masindex:=masindex+1;
   //    form1.StringGrid1.Refresh;
   //    //application.ProcessMessages;
   //    str:=str+FormatDateTime('ss.zzz',now)+#13;
   //  end;
   //showmessagealt(str);

   //Alarm_get;//загрузить информацию и предупреждения

   //запустить таймер обновления экрана
   form1.IdleTimer2.AutoEnabled:=true;
   form1.IdleTimer2.Enabled:=true;

   //showmessagealt('всего: '+timetostr(time()-t1)+' сек.');
   //form1.Label44.visible:=true;
   //form1.Label44.Caption:='загрузка: '+formatdatetime('ss',time()-t1)+'сек';
   //showmas(mas_otkuda);
end;


procedure TForm1.ReadSettings();
var
  //Ini: TIniFile;
  i: Integer;
  path: string;
begin
  path:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'settings.ini';
  //сначала значения по умолчанию
      company_name := 'ОАО <АВТОВОКЗАЛ>';
      company_inn := '(ИНН 2634026147)';
      LPTonly:=false;
      webtick1:='Билет сформирован посредством автоматизированной системы';
      webtick2:='"ПЛАТФОРМА-АВ" (ОАО "АВТОВОКЗАЛ", ИНН 2634026147)';
      webtick3:='Билет заказан через Интернет (ООО "Стававто", ИНН 263465234)';
      webtick4:='телефон службы поддержки, +7(8652)23-47-20;';
      max_transaction_time:= maxtransact;
      unused_critical_time:=0;
      doobil_min:=120;
  if not FileExists(path) then
    begin
     with form1.IniPropStorage1 do
     begin
        inifilename:=path;
        IniSection:='global'; //указываем секцию
        WriteString('inn', company_inn);
        WriteString('company', company_name);
     If LPTonly then WriteString('printer_interface', 'LPT')
       else WriteString('printer_interface', 'usb');
      WriteString('webticket1',webtick1);
      WriteString('webticket2',webtick2);
      WriteString('webticket3',webtick3);
      WriteString('webticket4',webtick4);
      WriteInteger('max_transaction_time', maxtransact);
      WriteInteger('unused_min_limit', unused_critical_time);
      WriteInteger('doobil_min',doobil_min);
    end;
    end
  else
   begin
     with form1.IniPropStorage1 do
     begin
       inifilename:=path;
       IniSection:='global'; //указываем секцию
       company_inn := ReadString('inn', company_inn);
       company_name := ReadString('company', company_name);
       If ReadString('printer_interface', 'usb')='LPT' then
          LPTonly:=true else LPTonly:=false;
       webtick1:=ReadString('webticket1',webtick1);
       webtick2:=ReadString('webticket2',webtick2);
       webtick3:=ReadString('webticket3',webtick3);
       webtick4:=ReadString('webticket4',webtick4);
       max_transaction_time:=ReadInteger('max_transaction_time', maxtransact);
       unused_critical_time:=ReadInteger('unused_min_limit', unused_critical_time);
       doobil_min:=ReadInteger('doobil_min',doobil_min);
     end;
  //Ini := TIniFile.Create(path);
  //try
  //  company_inn := Ini.ReadString('global','inn', company_inn);
  //  company_name := Ini.ReadString('global','company', company_name);
  //  If Ini.ReadString('global','printer_interface', 'usb')='LPT' then
  //    LPTonly:=true else LPTonly:=false;
  //
  //  webtick1:=Ini.ReadString('global','webticket1',webtick1);
  //  webtick2:=Ini.ReadString('global','webticket2',webtick2);
  //  webtick3:=Ini.ReadString('global','webticket3',webtick3);
  //  webtick4:=Ini.ReadString('global','webticket4',webtick4);
  //  max_transaction_time:=Ini.ReadInteger('global','max_transaction_time', maxtransact);
  //  unused_critical_time:=Ini.ReadInteger('global','unused_min_limit', unused_critical_time);
  //  doobil_min:=Ini. ReadInteger('global','doobil_min',doobil_min);
  //finally
  //  Ini.Free;
  //end;
  end;

    // Определяем ограничение на вычеркнутые билеты
    try
  if unused_critical_time>0 then
    un_critical_time:=strtotime(inttostr(unused_critical_time div 60 mod 24)+':'+inttostr(unused_critical_time mod 60));
   except
     on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+inttostr(unused_critical_time)+#13+'--c31');
     exit;
    end;
    end;
  //ограничение на дообилечивание
  try
     if doobil_min>0 then
      doobil_time:=strtotime(inttostr(doobil_min div 60 mod 24)+':'+inttostr(doobil_min mod 60));
      except
     on exception: EConvertError do
    begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'значение: '+inttostr(doobil_min)+#13+'--c32');
     exit;
    end;
    end;
end;


procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //If DialogMess('Вы действительно хотите завершить работу с программой ?')=6 then halt
  //else  CloseAction:= caNone;
end;

//******************************* УНИЧТОЖЕНИЕ ФОРМЫ - ЗАПИСЬ В ЖУРНАЛ ВХОДА-ВЫХОДА **************************************************
procedure TForm1.FormDestroy(Sender: TObject);
begin
   form1.Timer1.Enabled:=false;
   freeandnil(form1.Timer1);
    form1.Timer3.Enabled:=false;
   freeandnil(form1.Timer3);
   form1.Active_app.Enabled:=false;
   freeandnil(form1.Active_app);
   form1.IdleTimer1.Enabled:=false;
   freeandnil(form1.IdleTimer1);
   form1.IdleTimer2.Enabled:=false;
   freeandnil(form1.IdleTimer2);
   form1.IdleTimer3.Enabled:=false;
   freeandnil(form1.IdleTimer3);
  //ЗАПИСЬ В ЖУРНАЛ ВХОДА-ВЫХОДА
   //out_user_sql(form1.ZConnection2,form1.ZReadOnlyQuery2);
end;

//********************************                   АКТИВАЦИЯ ФОРМЫ        ******************************
procedure TForm1.FormActivate(Sender: TObject);
var
  lfile: textfile;
  nopt: integer=0;
  n:integer=0;
begin
  if not FormActivated then begin
    FormActivated := True;
    //Выбираем профиль загрузки реального или эмулируемого сервера
     ////////////////////////////
   with Form1 do
   begin
   // Подключаемся к Локальному серверу
   If not(Connect2(form1.Zconnection1, 2)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-m8-');
      //closeAll();
      halt;
      exit;
     end;
  //определяем наименование пункта локального сервера
   ZReadOnlyQuery1.sql.Clear;
   ZReadOnlyQuery1.SQL.add('select UPPER(name) as name from av_spr_point WHERE id='+ConnectIni[14]+' ORDER BY createdate DESC LIMIT 1;');
   try
      ZReadOnlyQuery1.open;
     except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
       ZReadOnlyQuery1.Close;
       Zconnection1.disconnect;
       halt;
       exit;
     end;
     If ZReadOnlyQuery1.RecordCount>0 then
     begin
       server_name:=trim(ZReadOnlyQuery1.FieldByName('name').AsString);
     end;

   //загружаем меню диспетчера
    ZReadOnlyQuery1.sql.Clear;
    ZReadOnlyQuery1.SQL.add('SELECT b.id_public,b.pub_name as name,b.tab_pub ');
    ZReadOnlyQuery1.SQL.add(',coalesce((SELECT a.permition FROM av_users_menu_perm a WHERE a.id_menu_pub=b.id_public AND a.id_arm=b.id_arm ');
    ZReadOnlyQuery1.SQL.add(' AND a.id_menu_loc=0 AND a.del=0 ');
    ZReadOnlyQuery1.SQL.add(' AND a.id='+inttostr(id_user)+' ORDER BY a.createdate DESC LIMIT 1),0) as permition ');
    ZReadOnlyQuery1.SQL.add('FROM av_arm_menu b ');
    ZReadOnlyQuery1.SQL.add('WHERE b.id_local=0 AND b.id_arm='+inttostr(id_arm)+' and b.del=0 order by b.tab_pub;');
    //showmessage(ZReadOnlyQuery1.SQL.Text);//$
    try
        ZReadOnlyQuery1.open;
    except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
       Zconnection1.disconnect;
       halt;
       exit;
    end;
    if ZReadOnlyQuery1.RecordCount<1 then
       begin
         showmessagealt('Нет доступного меню для выбранного пользователя !');
         ZConnection1.Disconnect;
         halt;
         exit;
       end;
   setlength(menu_mas,0,3);
    //заполняем грид меню
    for n:=1 to ZReadOnlyQuery1.RecordCount do
      begin
       setlength(menu_mas,length(menu_mas)+1,3);
       menu_mas[length(menu_mas)-1,0]:= ZReadOnlyQuery1.FieldByName('id_public').AsString;
       menu_mas[length(menu_mas)-1,1]:= ZReadOnlyQuery1.FieldByName('permition').AsString;
       menu_mas[length(menu_mas)-1,2]:= ZReadOnlyQuery1.FieldByName('name').AsString;
        ZReadOnlyQuery1.Next;
      end;

   //загружаем опции арма
   ZReadOnlyQuery1.sql.Clear;
   ZReadOnlyQuery1.sql.add('select * from get_options('+quotedstr('opt')+','+inttostr(id_user)+','+inttostr(id_arm)+');');
   ZReadOnlyQuery1.sql.add('FETCH ALL IN opt;');
   //ZReadOnlyQuery1.SQL.add('select option_id,opt_value from av_users_arm_options WHERE del=0 AND id_arm='+inttostr(id_arm)+' AND id='+inttostr(id_user)+' ORDER BY option_id;');
  //showmessage(ZReadOnlyQuery1.SQL.text);//$
   try
      ZReadOnlyQuery1.open;
       If ZReadOnlyQuery1.RecordCount>0 then
        begin
          for n:=1 to ZReadOnlyQuery1.RecordCount do
           begin
            nopt := ZReadOnlyQuery1.FieldByName('id').AsInteger;
       Case nopt of
       5: printer_type:=ZReadOnlyQuery1.FieldByName('opt_value').AsInteger;
       6: printer_vid:=ZReadOnlyQuery1.FieldByName('opt_value').AsInteger;
       14: days_before:=ZReadOnlyQuery1.FieldByName('opt_value').AsInteger;
       26: vicherknut:=ZReadOnlyQuery1.FieldByName('opt_value').AsInteger;
          end;
            ZReadOnlyQuery1.Next;
           end;
        end;
   //showmessagealt(inttostr(printer_vid));
     except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
       ZReadOnlyQuery1.Close;
       Zconnection1.disconnect;
       //halt;
       //exit;
     end;
 //ПРОВЕРКА ЗАГРУЖЕННЫХ ОПЦИЙ
  iF printer_vid=0 then
     begin
       showmessagealt('НЕ ОПРЕДЕЛЕН ВИД ПРИНТЕРА ДЛЯ ПЕЧАТИ !'+#13+'ПЕЧАТЬ БУДЕТ ПРОИСХОДИТЬ НАПРЯМУЮ !');
       printer_vid:=2;
     end;
     //printer_vid:=2;//&

     // Определяем Имя пользователя
   ZReadOnlyQuery1.sql.Clear;
   ZReadOnlyQuery1.SQL.add('select dolg,name,fullname from av_users where del=0 AND id='+inttostr(id_user)+' ORDER BY createdate DESC LIMIT 1;');
   //showmessage(ZReadOnlyQuery1.SQL.text);
   try
      ZReadOnlyQuery1.open;
      If ZReadOnlyQuery1.RecordCount>0 then
     begin
       name_user_active := upperall(trim(ZReadOnlyQuery1.FieldByName('fullname').asString));
       form1.label11.caption:=name_user_active;
       form1.label10.caption:=inttostr(id_user);
       form1.label30.caption:=upperall(trim(ZReadOnlyQuery1.FieldByName('name').asString));
       form1.label31.caption:=upperall(trim(ZReadOnlyQuery1.FieldByName('dolg').asString));
       form1.label12.caption:=upperall(trim(ZReadOnlyQuery1.FieldByName('dolg').asString));
     end;
   except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
       ZReadOnlyQuery1.Close;
       Zconnection1.disconnect;
       //halt;
       //exit;
   end;

  // Определяем IP-adress
   ZReadOnlyQuery1.sql.Clear;
   ZReadOnlyQuery1.SQL.add('select inet_client_addr();');
   //showmessage(ZReadOnlyQuery1.SQL.text);
   try
      ZReadOnlyQuery1.open;
      If ZReadOnlyQuery1.RecordCount>0 then
     begin
       user_ip:=ZReadOnlyQuery1.Fields[0].AsString;
     end;
   except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
       ZReadOnlyQuery1.Close;
       Zconnection1.disconnect;
       //halt;
       //exit;
   end;

   form1.Label34.Caption:=user_ip;
   form1.Label20.Caption:=user_ip;

   //Определяем фото
   //ZReadOnlyQuery1.SQL.Clear;
   //ZReadOnlyQuery1.SQL.text:=('SELECT foto from av_users where del=0 AND id='+inttostr(id_user)+' ORDER BY createdate DESC LIMIT 1;');
   //   try
   //     ZReadOnlyQuery1.open;
   //   except
   //      showmessagealt('Ошибка чтения фото из базы SQL - ОШИБКА');
   //      ZReadOnlyQuery1.Close;
   //      halt;
   //      exit;
   //   end;
   // If ZReadOnlyQuery1.RecordCount>0 then
   //   begin
   //   if ZReadOnlyQuery1.FieldByName('foto').IsBlob then
   //      begin
   //        BlobStream := ZReadOnlyQuery1.CreateBlobStream(ZReadOnlyQuery1.FieldByName('foto'), bmRead);
   //    If BlobStream.Size>10 then
   //       begin
   //        try
   //          FileStream:= TFileStream.Create('foto.jpg', fmCreate);
   //            try
   //             FileStream.CopyFrom(BlobStream, BlobStream.Size);
   //            finally
   //             FileStream.Free;
   //            end;
   //        finally
   //         BlobStream.Free;
   //        end;
   //       form1.image4.Picture.LoadFromFile('foto.jpg');
   //      end;
   //   end;
   //   end;
   ZReadOnlyQuery1.Close;
   Zconnection1.disconnect;
   form1.Panel4.Visible:=false;
   //application.ProcessMessages;
   {
  if user_ip<>'0.0.0.0' then
  begin
    //--------- Создаем файл с номером версии
  try
  AssignFile(lfile,ExtractFilePath(Application.ExeName)+'disp_log/'+user_ip+'.ip');
  {$I-} // отключение контроля ошибок ввода-вывода
  Rewrite(lfile); // открытие файла для чтения
  {$I+} // включение контроля ошибок ввода-вывода
   writeln(lfile,user_ip);
 finally
  CloseFile(lfile);
  end;
  end;
    }
end;
end;
end;


//********************************                   ВОЗНИКНОВЕНИЕ ФОРМЫ        ******************************
procedure TForm1.FormShow(Sender: TObject);
var
  BlobStream: TStream;
  FileStream: TStream;
  nopt: integer=0;
  n:integer=0;
begin
  //t1 := time();
    paintmess(form1.StringGrid1,'ИДЕТ НАЧАЛЬНАЯ ИНИЦИАЛИЗАЦИЯ ! ПОДОЖДИТЕ...',clNavy);
   form1.Panel4.Width:=form1.Width;
   form1.Panel4.Left:=0;
   form1.Panel4.top:=300;
   form1.Panel4.Visible:=true;
   application.ProcessMessages;


   //showmessage(formatdatetime('hh:nn',un_critical_time));//&

   //Проверяем статус выбранного сервера
   if flagProfile=1 then
      begin
       form1.Label6.caption:=ConnectINI[1];
       form1.Label7.caption:=ConnectINI[2];
       form1.Label8.caption:=ConnectINI[3];

      end;
   if flagProfile=2 then
      begin
       form1.Label6.caption:=ConnectINI[4];
       form1.Label7.caption:=ConnectINI[5];
       form1.Label8.caption:=ConnectINI[6];
       //MConnect(form1.Zconnection1,ConnectINI[6],ConnectINI[4]);
      end;
   if flagProfile=3 then
      begin
       form1.Label5.Visible:=true;
       form1.Label6.caption:=ConnectINI[8];
       form1.Label7.caption:=ConnectINI[9];
       form1.Label8.caption:=ConnectINI[10];
       end;
    if flagProfile=4 then
      begin
       form1.Label5.Visible:=true;
       form1.Label6.caption:=ConnectINI[11];
       form1.Label7.caption:=ConnectINI[12];
       form1.Label8.caption:=ConnectINI[13];
       end;

 // Входим в проГрамму
 if flag1=0 then
  begin
   //flag1 := 1;
   // if in_user_sql('Диспетчер','platDisp',inttostr(id_user),name_user_active,user_ip,form1.ZConnection2,form1.ZReadOnlyQuery2)=1 then
   //    begin
   //     showmessagealt('Пользователь: '+upperall(trim(name_user_active))+' уже вошел в систему.'+#13+'Повторный вход невозможен !');
   //     halt;
   //    end
   // else
   //  begin
   //    form1.Active_app.Enabled:=true;
   //  end;
  end;

   //form1.Label44.visible:=true;//$
   //включить таймер однократной загрузки данных
   form1.Timer3.Enabled:=true;

end;



 // *********************************************   СОЗДАНИЕ формы *************************************************************
procedure TForm1.FormCreate(Sender: TObject);
  Var
   MajorNum : String;
   MinorNum : String;
   RevisionNum : String;
   BuildNum : String;
   Info: TVersionInfo;
   lfile: textfile;
   fprint:TextFile;
begin
   fle:=false;
   specbron:=false;//av_shadow_bron - спец бронирование
  //взять номер версии
  // initialize a bunch of stuff for this app when the form is first opened
 // [0] = Major version, [1] = Minor ver, [2] = Revision, [3] = Build Number
 // The above values can be found in the menu: Project > Project Options > Version Info
   Info := TVersionInfo.Create;
   Info.Load(HINSTANCE);
   // grab just the Build Number
   MajorNum := IntToStr(Info.FixedInfo.FileVersion[0]);
   MinorNum := IntToStr(Info.FixedInfo.FileVersion[1]);
   RevisionNum := IntToStr(Info.FixedInfo.FileVersion[2]);
   BuildNum := IntToStr(Info.FixedInfo.FileVersion[3]);
   Info.Free;
  Label48.Caption := 'Версия:'+MajorNum+'.'+MinorNum+'.'+RevisionNum+'.'+BuildNum;//версия программы

   // --------Проверяем что уже есть каталог LOG если нет то создаем
  If Not DirectoryExists(ExtractFilePath(Application.ExeName)+'disp_log') then
    begin
     CreateDir(ExtractFilePath(Application.ExeName)+'disp_log');
    end;

  //--------- Создаем файл с номером версии
  try

  AssignFile(lfile,ExtractFilePath(Application.ExeName)+'disp_log/version');

  {$I-} // отключение контроля ошибок ввода-вывода
  Rewrite(lfile); // открытие файла для чтения
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
   begin
     showmessagealt('Ошибка открытия файла version !!!');
     Exit;
   end;
  // id_user+datetime
   writeln(lfile,MajorNum+'.'+MinorNum+'.'+RevisionNum+'.'+BuildNum);
   //writeln(lfile,'Console output codepage: ', GetTextCodePage(Output));
   //writeln(lfile,'System codepage: ', DefaultSystemCodePage);
   //writeln(log_file,user_ip+'; ['+(inttostr(id_user))+'] '+name_user_active+'; '+FormatDateTime('dd/mm/yyyy hh:mm:ss', now()));
   //writeln(log_file,'=================================== СОСТОЯНИЕ ПЕРЕМЕННЫХ ======================================');
  // If screen.FormCount>1 then
      //If screen.ActiveForm.ControlCount>1 then
      //   writeln(log_file,'form: '+screen.ActiveForm.Name+' | '+'control: '+screen.ActiveControl.Name+' | ')
      //   else
      //     writeln(log_file,'form: '+screen.ActiveForm.Name+' | ');

   //writeln(log_file,'form: '+screen.ActiveForm.Name+' | '+'control: '+screen.ActiveControl.Name+' | ');
 finally
  CloseFile(lfile);
  end;

   Form1.Canvas.AutoRedraw:=false;
  //заполнить параметры константы локальных настроек даты
   //GetLocaleFormatSettings(GetUserDefaultLCID, MySettings);
   //глобальные установки
    decimalseparator:='.';
    DateSeparator := '-';
    TimeSeparator := ':';
    ShortDateFormat := 'dd-mm-yy';
    LongDateFormat  := 'dd-mm-yyyy';
    ShortTimeFormat := 'hh:mm:ss';
    LongTimeFormat  := 'hh:mm:ss';
  MySettings.decimalseparator:='.';
  MySettings.DateSeparator := '-';
  MySettings.TimeSeparator := ':';
  MySettings.ShortDateFormat := 'dd-mm-yyyy';
  MySettings.ShortTimeFormat := 'hh:nn:ss';
  MySettings.LongDateFormat  := 'dd-mm-yyyy';
  MySettings.LongTimeFormat  := 'hh:mm:ss';


   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;


  flag_access:=1;
  flagProfile:=2; //профиль по умолчанию локальный реальный
  remote_ind:=-1;

  //обнуляем контрольные значения
    md5_av_trip:='';
    md5_av_trip_atps:='';
    md5_av_dog_lic:='';
    max_operation:='01-01-1980 00:00:00';// max createdate для disp_oper

     //form1.Button3.Click;


   server_name:='';

    //определяем порт usb или LPT
   printer_dev:='/dev/lp0';

   If not LPTonly and FileExists('/dev/usb/lp0') then
   begin
    //try
      AssignFile(fprint,'/dev/usb/lp0');
      {$I-} // отключение контроля ошибок ввода-вывода
      Rewrite(fprint);
      {$I+} // включение контроля ошибок ввода-вывода
     if IOResult=0 then
        printer_dev:='/dev/usb/lp0';
    // //showmessage('Локальный принтер не подключен !!!'+#13+'Проверьте физическое подключение принтера ...');
    // //exit;
    ////end;
    ////finally
      CloseFile(fprint);
    end;


  //Определяем начальные установки соединения с сервером
   defpath:=ExtractFilePath(Application.ExeName);
  if  ReadIniLocal(form1.IniPropStorage1,defpath+'local.ini')=false then
     begin
       showmessagealt('Не найден файл настроек по заданному пути!'+#13+'Дальнейшая загрузка программы невозможна !'+#13+'Обратитесь к Администратору !');
       halt;
       exit;
     end;
  try
   sale_server:= connectini[14];
   strtoint(sale_server);
  except
  on exception: EConvertError do
  begin
     showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'НЕВЕРНОЕ ЗНАЧЕНИЕ ПУНКТА ПРОДАЖИ !');
     halt;
     exit;
  end;
  end;

  //прочитать глобальные переменные из файла
  form1.ReadSettings();

  id_user:=99;//*
  id_arm:=3; //*
  user_ip:='0.0.0.0';

   //принимаем начальные параметры
  If trim(ParamStr(1))<>'' then
  begin
  try
  id_user:=strtoint(copy(trim(ParamStr(1)),1,pos('+',ParamStr(1))-1));
  //id_arm:=strtoint(copy(ParamStr(1),pos('+',ParamStr(1))+1,pos('_',ParamStr(1))-1-pos('+',ParamStr(1))));
  //flagProfile:=flagProfile+strtoint(copy(trim(ParamStr(1)),pos('_',ParamStr(1))+1,1));
  except
       on exception: EConvertError do
  begin
       showmessagealt('ОШИБКА КОНВЕРТАЦИИ !!!'+#13+'НЕВЕРНОЕ ЗНАЧЕНИЕ ПАРАМЕТРА ПРИЛОЖЕНИЯ !');
       halt;
       exit;
  end;
  end;
  end
  else
  begin
    {$IFDEF WINDOWS}
     id_user:=0;
     //открыть форму регистрации
     FormAuth:=TFormAuth.create(self);
     FormAuth.ShowModal;
     FreeAndNil(FormAuth);
    {$ENDIF}
   end;

  If id_user=0 then
  begin
    halt;
    exit;
  end;

  //& кол-во прошедших дней
   If ((id_user=1) or (id_user=2)) and (days_before<60) then days_before:=60;


   flag1:=0; //флаг входа в программу
   alltrips:=0;//кол-во рейсов
   // Текущая ДАТА
   WORK_DATE:=Date();
   //WORK_DATE:=strtodate('08-05-2015');//#
   form1.label46.Caption:='';

   form1.DoubleBuffered:=true;
   form1.StringGrid1.DoubleBuffered:=true;
   form1.StringGrid1.DefaultRowHeight:=(form1.StringGrid1.Height-134) div (triprows-1);

    Mouse.CursorPos:= Point(screen.Width,screen.Height);
   form1.StringGrid1.RowCount:=triprows+1;
   form1.StringGrid1.RowHeights[0]:=34;
   form1.StringGrid1.RowHeights[trows+1]:=100;
   form1.StringGrid1.Row:=trows+1;
   setlength(alarm_mas,0);
   ncnt:=0;
   fl_lock:=false;//флаг подтверждения блокировки рейса
end;

end.

