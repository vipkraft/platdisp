unit web_ticket;

{$mode objfpc}{$H+}
//{$codepage cp866}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls,
  Dialogs,
  ZConnection, ZDataset,  LazFileUtils,
  Grids,
  lazUtf8,
  lconvencoding,
  htmlproc;

type

  { TFormWT }

  TFormWT = class(TForm)
    Label1: TLabel;
    Label36: TLabel;
    Label43: TLabel;
    StringGrid1: TStringGrid;
    ZConnection1: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure UpdateGrid(); //обновить грид ведомостей для данного рейса
    //печать билетов
    procedure Linuxprint(i: integer);
    procedure Winprint(i: integer);
    //procedure TekStatus(n: integer);//добавить в массив ведомостей текущее состояние рейса
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormWT: TFormWT;

implementation
 uses
  platproc,maindisp,menu;

 const
   arrSize=25;

 var
   x:integer=-1;
   arrWeb: array of array of string;
   sdate,stime,splatform,trip_ot,trip_do,trip_num : string;

{$R *.lfm}

{ TFormWT }




//добавить в массив ведомостей текущее состояние рейса
 //procedure TFormWT.TekStatus(n: integer);
 //begin
 //  If n<0 then
 //      begin
 //         showmessagealt('Не определен элемент массива ведомостей данного рейса !');
 //         exit;
 //      end;
 //
 //
 //end;

  //печать билетов
 procedure TFormWT.Winprint(i: integer);
 //*********************************************       ПЕЧАТЬ ведомости в браузер   ************************************************
var
  n:integer;
   buf_LPT:TextFile;
   prin: String;
  fname:string;
begin

  decimalseparator:='.';

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
        FormWT.Close;
        exit;
        end;
       end;
   end;
  {$IOChecks on}
 end;
  rep_dir:=IncludeTrailingPathDelimiter(rep_Dir);

 if StartHTML(rep_dir+'inettick'+inttostr(id_user)+'.html')=false then exit;



  for n:=0 to length(arrWeb)-1 do
  begin
    If (i>-1) and (i<>n) then continue;


     If n>0 then
      begin
       EmptyLine();
       Split();
       EmptyLine();
       end;

  StartTableHTML(0,'100%',1);
 StartRowTableHTML('bottom');//новая строка таблицы
 CellsTableHTML('ЭЛЕКТРОННЫЙ БИЛЕТ НА ПРОЕЗД В АВТОБУС',3,3,2,'000000',3,0,'');
 EndRowTableHTML();
 StartRowTableHTML('bottom');//новая строка таблицы
 CellsTableHTML('№-серия: '+arrWeb[n,0],1,3,1,'000000',3,0,'');
 EndRowTableHTML();
  If arrWeb[n,24]='5' then
    begin
       StartRowTableHTML('bottom');//новая строка таблицы
       CellsTableHTML('Выдан: '+arrWeb[n,17],1,3,1,'000000',3,0,'');
       EndRowTableHTML();
       StartRowTableHTML('bottom');//новая строка таблицы
       CellsTableHTML('ИНН: '+arrWeb[n,19]+'  ОГРНИП: '+arrWeb[n,20],1,3,1,'000000',3,0,'');
       EndRowTableHTML();
    end;
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML(' Ф.И.О. пассажира: '+arrWeb[n,7] ,1,3,1,'000000',3,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('ИНФОРМАЦИЯ О ПАССАЖИРЕ' ,3,3,2,'000000',3,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('Документ: '+   arrWeb[n,8] ,1,3,1,'000000',1,0,'');
    CellsTableHTML('Серия,Номер: '+arrWeb[n,9] ,1,3,1,'000000',1,0,'');
    CellsTableHTML('Телефон: '+   arrWeb[n,15] ,1,3,1,'000000',1,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('Пол: '+arrWeb[n,22]        ,1,3,1,'000000',1,0,'');
    CellsTableHTML('Гражданство: '+arrWeb[n,21]+'   Дата рожд.:'+arrWeb[n,10],1,3,1,'000000',1,0,'');
    CellsTableHTML('E-mail:'+arrWeb[n,16]      ,1,3,1,'000000',1,0,'');
    EndRowTableHTML();
  //Таблица - Конец
  EndTableHTML();
  StartTableHTML(1,'100%',1);
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('ОТПРАВЛЕНИЕ',3,3,2,'000000',5,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('место'                   ,1,3,1,'000000',1,0,'');
    CellsTableHTML('Дата и время отправления',1,3,1,'000000',2,0,'');
    CellsTableHTML('Пункт посадки'           ,1,3,1,'000000',2,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML(arrWeb[n,1]    ,1,3,1,'000000',1,0,'');
    CellsTableHTML(sdate+' '+stime,1,3,1,'000000',2,0,'');
    CellsTableHTML(arrWeb[n,11]   ,1,3,1,'000000',2,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('ПРИБЫТИЕ',3,3,2,'000000',5,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('Дата и время прибытия',1,3,1,'000000',2,0,'');
    CellsTableHTML('Пункт высадки'        ,1,3,1,'000000',3,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML(arrWeb[n,13]+'  '+arrWeb[n,14],1,3,1,'000000',2,0,'');
    CellsTableHTML(arrWeb[n,12]                  ,1,3,1,'000000',3,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('Рейс: '+trip_ot+' - ' +trip_do,3,3,1,'000000',4,0,'');
    CellsTableHTML('Маршрут: '+trip_num           ,3,3,1,'000000',1,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('СТОИМОСТЬ БИЛЕТА',3,3,2,'000000',5,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('Тарифная стоимость'       ,1,3,1,'000000',1,0,'');
    CellsTableHTML('Сбор предварительной<br>продажи',1,3,1,'000000',1,0,'');
    CellsTableHTML('Мест<br>багажа'           ,1,3,1,'000000',1,0,'');
    CellsTableHTML('Цена<br>багажа'           ,1,3,1,'000000',1,0,'');
    CellsTableHTML('ИТОГО'                    ,1,3,1,'000000',1,0,'');
    EndRowTableHTML();
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML(arrWeb[n,2]       ,1,3,1,'000000',1,0,'');
    CellsTableHTML(arrWeb[n,3]       ,1,3,1,'000000',1,0,'');
    CellsTableHTML(arrWeb[n,4]       ,1,3,1,'000000',1,0,'');
    CellsTableHTML(arrWeb[n,5]       ,1,3,1,'000000',1,0,'');
    CellsTableHTML(arrWeb[n,6]       ,1,3,1,'000000',1,0,'');
    EndRowTableHTML();
     //Таблица - Конец
  EndTableHTML();
  StartTableHTML(0,'100%',1);
    StartRowTableHTML('bottom');//новая строка таблицы
    CellsTableHTML('Дата и время формирования (продажи) билета:',2,3,1,'000000',0,0,'');
    CellsTableHTML(arrWeb[n,23]       ,1,3,1,'000000',1,0,'');
    EndRowTableHTML();
     If arrWeb[n,24]='6' then
    begin
      StartRowTableHTML('bottom');//новая строка таблицы
      CellsTableHTML('<sub>'+webtick1+'</sub>',1,3,2,'000000',0,0,'');
      EndRowTableHTML();
      StartRowTableHTML('bottom');//новая строка таблицы
      CellsTableHTML('<sub>'+webtick2+'</sub>',1,3,2,'000000',0,0,'');
      EndRowTableHTML();
      StartRowTableHTML('bottom');//новая строка таблицы
      CellsTableHTML('<sub>'+webtick3+'</sub>',1,3,2,'000000',0,0,'');
      EndRowTableHTML();
      StartRowTableHTML('bottom');//новая строка таблицы
      CellsTableHTML('<sub>'+webtick4+'</sub>',1,3,2,'000000',0,0,'');
      EndRowTableHTML();
     end
  else
  begin
     StartRowTableHTML('bottom');//новая строка таблицы
      CellsTableHTML('<sub>'+'Уважаемый клиент! Электронный билет может быть возвращен только в месте его продажи.'+'</sub>',1,3,2,'000000',0,0,'');
      EndRowTableHTML();
      StartRowTableHTML('bottom');//новая строка таблицы
      CellsTableHTML('<sub>'+'Сумма возврата рассчитывается от тарифной стоимости билета.'+'</sub>',1,3,2,'000000',0,0,'');
      EndRowTableHTML();
      StartRowTableHTML('bottom');//новая строка таблицы
      CellsTableHTML('<sub>'+'ЭЛЕКТРОННЫЙ БИЛЕТ СОЗДАН ПОСРЕДСТВОМ АВТОМАТИЗИРОВАННОЙ СИСТЕМЫ <ПЛАТФОРМА АВ>'+'</sub>',1,3,2,'000000',0,0,'');
      EndRowTableHTML();
 end;
 //CellsTableHTML('',1,1,1,'000000',0,0,'');
    //Таблица - Конец
 EndTableHTML();

  end;


  EndHTML(); // Конец HTML (fileHTML:десткриптор файла)
  startbrowser(rep_dir+'inettick'+inttostr(id_user)+'.html');

end;



 //печать билетов
 procedure TFormWT.Linuxprint(i: integer);
  //{$codepage cp866}
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
        //Ec(3R   PC Cyrillic (UTF8ToSys)
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


 //#18#80 - размер шрифта 10cpi
 //#18#77 - размер шрифта 12cpi мельче
 //#103 - размер шрифта 15cpi еще мельче
 //#15#80 - размер шрифта 17cpi очень мельче
 //#15#77 - размер шрифта 20cpi самый мелкий
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

const
  bold=#027#040#115#051#066; //жирный
  norm=#027#040#115#048#066; //нежирный
  under=#027#038#100#048#068;//подчернкутый
  plain=#027#038#100#064;//не подчеркнутый
  maxticksL=46; //маскимальное число напечатанных строчек билетов на листе лазерн
  maxticksM=38; //маскимальное число напечатанных строчек билетов на листе матричн
var
  n:integer;
  //,m,k  ,bagag_count,wars_count,lgot_count,uslugi_count,tickets_count,cnt,tranzit,creditcard :integer;
 // tickets_sum,bagag_sum,strah_sum,wars_sum_cash,wars_sum_credit,lgot_sum_cash,
 // lgot_sum_credit,uslugi_sum_cash,uslugi_sum_credit,card_credit: real;
//  stime,sdate:integer;
//  flfio,fldoc,fl_next:boolean;
//  filetxt:TextFile;
//  spass:byte;
  //viddoc:string;
   buf_LPT:TextFile;
   prin: String;
  fname:string;
  tmp: String;
begin
   //prin := '/dev/lp0';
   AssignFile(buf_lpt,printer_dev);
   //prin := ExtractFilePath(Application.ExeName)+'disp_log/webt.txt';
   //AssignFile(buf_lpt,prin);
// Загружаем файл
   //{$I-} // отключение контроля ошибок ввода-вывода
 Rewrite(buf_lpt);
  //{$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then
    begin
     showmessagealt('Локальный принтер не подключен !!!'+#13+'Проверьте физическое подключение принтера ...');
     exit;
    end;

  decimalseparator:='.';
    //flfio:=false;
    //fldoc:=false;
    //spass:=0;

  for n:=0 to length(arrWeb)-1 do
  begin
    If (i>-1) and (i<>n) then continue;

   //fname:='inett'+inttostr(id_user)+'.txt';
   //printer_vid:=1;
  //если опция печати на лазерный принтер
  If printer_vid=1 then
    begin
      //DeleteFile(vedName);
      //AssignFile(filetxt,vedName);
      //{$I-} // отключение контроля ошибок ввода-вывода
      //Rewrite(buf_lpt); // открытие файла для чтения
      //{$I+} // включение контроля ошибок ввода-вывода
      //if IOResult<>0 then // если есть ошибка открытия, то
      //  begin
      //   showmessagealt('Ошибка создания файла документа !');
      //   //result:=false;
      //   Exit;
      //  end;

  //******сброс настроек+портретная ориентация+а4 +                    размер (символов на дюйм)+межстрочный интервал
  writeln(buf_lpt,#027#069+#027#038#108#048#079+#027#038#108#050#054#065+#027#040#115+'12'+#072+#027#038#108+'4'+#067); //отмена режима сжатой печати
 //writeln(buf_lpt,#027#069+#027#038#108#048#079+#027#038#108#050#054#065+#027#040#115+'12'+#072+#027#038#108+'5'+#067);    //отмена режима сжатой печати
  //tmp := PadC('ЭЛЕКТРОННЫЙ БИЛЕТ НА ПРОЕЗД В АВТОБУС',#32,85);
  //setcodepage(tmp, 866, false);
  writeln(buf_lpt,UTF8ToCP866(PadC('ЭЛЕКТРОННЫЙ БИЛЕТ НА ПРОЕЗД В АВТОБУС',#32,85))+#13#10);
  writeln(buf_lpt,UTF8ToCP866(PadC('№-серия: '+bold+arrWeb[n,0]+norm,#32,90))+#13#10);
  If arrWeb[n,24]='5' then
    begin
  writeln(buf_lpt,UTF8ToCP866(PadC('Выдан: '+arrWeb[n,17],#32,90))+#13#10);
  writeln(buf_lpt,UTF8ToCP866(PadC('ИНН: '+arrWeb[n,19]+'  ОГРНИП: '+arrWeb[n,20],#32,90))+#13#10);
    end;
  writeln(buf_lpt,UTF8ToCP866(' Ф.И.О. пассажира: '+bold+arrWeb[n,7]+norm)+#13#10);
  writeln(buf_lpt,UTF8ToCP866(PadC('ИНФОРМАЦИЯ О ПАССАЖИРЕ',#32,90))+#13#10);
  writeln(buf_lpt,UTF8ToCP866(' Документ: '+bold+arrWeb[n,8]+norm+'  Серия,Номер: '+bold+arrWeb[n,9]+norm+'  Телефон: '+bold+arrWeb[n,15]+norm)+#13#10);
  writeln(buf_lpt,UTF8ToCP866(' Пол: '+bold+arrWeb[n,22]+norm+'    Гражданство: '+bold+arrWeb[n,21]+norm+' Дата рожд.:'+bold+arrWeb[n,10]+norm+'  E-mail: '+bold+arrWeb[n,16]+norm)+#13#10);
  writeln(buf_lpt,UTF8ToCP866(PadC('ОТПРАВЛЕНИЕ',#32,90))+#13#10);
  writeln(buf_lpt,StringofChar('_',64)+#13#10);
  writeln(buf_lpt,UTF8ToCP866('|  место  |'+'|  Дата и время отправления  |'+'|    Пункт посадки    |')+#13#10);
  writeln(buf_lpt,'|_________|'+'|____________________________|'+'|_____________________|'+#13#10);
  writeln(buf_lpt,UTF8ToCP866('|'+under+bold+PadC(arrWeb[n,1],#32,9)+norm+plain+'||'+under+bold+PadC(sdate+' '+stime,#32,28)+norm+plain+'||'+under+bold+PadC(arrWeb[n,11],#32,21)+norm+plain+'|')+#13#10); //отправление
  writeln(buf_lpt,#32#13#10);//пустая строка
  writeln(buf_lpt,UTF8ToCP866(PadC('ПРИБЫТИЕ',#32,90))+#13#10);
  writeln(buf_lpt,StringofChar('_',64)+#13#10);
  writeln(buf_lpt,UTF8ToCP866('|          Дата и время прибытия       |'+'|     Пункт высадки    |')+#13#10);
  writeln(buf_lpt,'|______________________________________|'+'|______________________|'+#13#10);
  writeln(buf_lpt,UTF8ToCP866('|'+under+bold+PadC(arrWeb[n,13]+'  '+arrWeb[n,14],#32,38)+norm+plain+'||'+under+bold+PadC(arrWeb[n,12],#32,22)+norm+plain+'|')+#13#10); //прибытие
  writeln(buf_lpt,#32#13#10);//пустая строка
  writeln(buf_lpt,UTF8ToCP866('Рейс: '+bold+trip_ot+' - ' +trip_do+norm+'  Маршрут: '+bold+trip_num+norm)+#13#10);  //наименование рейса
  writeln(buf_lpt,#32#13#10);//пустая строка
  writeln(buf_lpt,UTF8ToCP866(PadC('СТОИМОСТЬ БИЛЕТА',#32,90))+#13#10);
  writeln(buf_lpt,StringofChar('_',88)+#13#10);
  writeln(buf_lpt,UTF8ToCP866('|Тарифная стоимость|'+'|Сбор предварительной продажи|'+'|Мест багажа|'+'|Цена багажа|'+'|  ИТОГО  |')+#13#10);
  writeln(buf_lpt,            '|__________________|'+'|____________________________|'+'|___________|'+'|___________|'+'|_________|'+#13#10);
  //showmessage(('|'+under+PadC(arrWeb[n,2],#32,18)+plain+'||'+under+PadC(arrWeb[n,28],#32,21)+plain+'||'+under+PadC(arrWeb[n,11],#32,21)+plain+'||'+
                    //under+PadC(arrWeb[n,5],#32,11)+plain+'||'+under+PadC(arrWeb[n,6],#32,9)+plain+'||'));
  writeln(buf_lpt,UTF8ToCP866('|'+under+bold+PadC(arrWeb[n,2],#32,18)+norm+plain+'||'+under+bold+PadC(arrWeb[n,3],#32,28)+norm+plain+'||'+under+bold+PadC(arrWeb[n,4],#32,11)+norm+plain+'||'+
                    under+bold+PadC(arrWeb[n,5],#32,11)+norm+plain+'||'+under+bold+PadC(arrWeb[n,6],#32,9)+norm+plain+'|')+#13#10); //прибытие
  writeln(buf_lpt,UTF8ToCP866('Дата и время формирования (продажи) билета: ')+arrWeb[n,23]+#13#10);
   //если напечатанных строчек больше maxticks, тогда печатаем на 2-х листах
  //If length(tick_mas)>maxticksL then cnt:=maxticksL;
  //writeln(filetxt,StringofChar(#32,120));//строка пробелов
  // Таблица - Начало 136 знаков
  //writeln(buf_lpt,#027#038#108+'3'+#067);//уменьшаем межстрочный интервал
  //writeln(buf_lpt,#027#040#115+'18'+#072);//включение режима сжатой печати
   //если напечатанных строчек больше maxticks, тогда печатаем на 2-х листах
  writeln(buf_lpt,#027#040#115+'18'+#072+#027#038#108+'3'+#067);//включение режима сжатой печати //уменьшаем межстрочный интервал
  If arrWeb[n,24]='6' then
    begin
     writeln(buf_lpt,UTF8ToCP866(Padc(webtick1,#32,120))+#13#10);
     writeln(buf_lpt,UTF8ToCP866(Padc(webtick2,#32,120))+#13#10);
     writeln(buf_lpt,UTF8ToCP866(Padc(webtick3,#32,120))+#13#10);
     writeln(buf_lpt,UTF8ToCP866(Padc(webtick4,#32,120))+#13#10);
     end
  else
  begin
  writeln(buf_lpt,UTF8ToCP866(Padc('Уважаемый клиент! Электронный билет может быть возвращен только в месте его продажи.',#32,120))+#13#10);
  writeln(buf_lpt,UTF8ToCP866(Padc('Сумма возврата рассчитывается от тарифной стоимости билета.',#32,120))+#13#10);
  writeln(buf_lpt,UTF8ToCP866(Padc('ЭЛЕКТРОННЫЙ БИЛЕТ СОЗДАН ПОСРЕДСТВОМ АВТОМАТИЗИРОВАННОЙ СИСТЕМЫ <ПЛАТФОРМА АВ>',#32,120))+#13#10);
  //writeln(buf_lpt,(Padc('НА САЙТЕ WWW.AVTOVOKZAL26.RU',#32,120))+#13#10);
 end;
  writeln(buf_lpt,#32#13#10);//пустая строка
  writeln(buf_lpt,#027#040#115+'12'+#072+#027#038#108+'4'+#067);////отменить сжатый текст межстрочный интервал

  If (((n+1) mod 2)=0) or (i>-1) then
  writeln(buf_lpt,#027#038#108#048#072); //следующий лист

  end;


  //!!!!!!!!!!!!!         если опция печати на матричный принтер (136 знаков)  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //************ The printer language ESC/P
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 If printer_vid=2 then
  begin
    //showmessagealt(arrWeb[n,2]+#13+arrWeb[n,3]+#13+arrWeb[n,4]+#13+arrWeb[n,5]+#13+arrWeb[n,6]);

//The printer language ESC/P was originally developed by Epson for use with their early dot-matrix printers.
  write(buf_lpt,#18#27#80+#27#79+#27#51#60);    //отмена режима сжатой печати отмена пропуска перфорации  12-cpi character printing  Sets the line spacing to 1/6 inch
  write(buf_lpt,UTF8ToCP866(PadC('ЭЛЕКТРОННЫЙ БИЛЕТ НА ПРОЕЗД В АВТОБУС',#32,80))+#13#10);
  write(buf_lpt,UTF8ToCP866(PadC('№-серия: '+#27#69+arrWeb[n,0]+#27#70,#32,80))+#13#10);
  If arrWeb[n,24]='5' then
    begin
  write(buf_lpt,UTF8ToCP866(PadC('Выдан: '+arrWeb[n,17],#32,80))+#13#10);
  write(buf_lpt,UTF8ToCP866(PadC('ИНН: '+arrWeb[n,19]+'  ОГРНИП: '+arrWeb[n,20],#32,80))+#13#10);
    end;
  write(buf_lpt,UTF8ToCP866(' Ф.И.О. пассажира: '+#27#69+arrWeb[n,7]+#27#70)+#13#10);
  write(buf_lpt,UTF8ToCP866(PadC('ИНФОРМАЦИЯ О ПАССАЖИРЕ',#32,80))+#13#10);
  write(buf_lpt,#18#27#77);
  write(buf_lpt,#27#51#40);
  write(buf_lpt,UTF8ToCP866('Документ:'+#27#69+arrWeb[n,8]+#27#70+' Серия,Номер:'+#27#69+arrWeb[n,9]+#27#70+'  Телефон:'+#27#69+arrWeb[n,15]+#27#70+#13#10));
  write(buf_lpt,UTF8ToCP866('Пол: '+#27#69+arrWeb[n,22]+#27#70+'  Гражданство:'+#27#69+arrWeb[n,21]+#27#70+' Дата рожд.:'+#27#69+arrWeb[n,10]+#27#70+'  E-mail:'+#27#69+arrWeb[n,16]+#27#70+#13#10));
  write(buf_lpt,#32#13#10);//пустая строка
  //write(buf_lpt,#27#48);//1/6 line
  write(buf_lpt,UTF8ToCP866(#27#45#49+PadC('ОТПРАВЛЕНИЕ',#32,84)+#27#45#48)+#13#10);
  //write(buf_lpt,             '__________________________________________________________________________________________'+#13#10);
  write(buf_lpt,#27#45#49+UTF8ToCP866('|    место    |'+'|   Дата и время отправления   |'+'|            Пункт посадки           ')+#27#45#48+'|'+#13#10);
  //write(buf_lpt,            '|_____________|'+'|________________________________|'+'|____________________________|'+#13#10);
  write(buf_lpt,UTF8ToCP866('|'+#27#45#49+#27#69+PadC(arrWeb[n,1],#32,13)+#27#70+#27#45#48+'||'+#27#45#49+#27#69+PadC(sdate+' '+stime,#32,30)+#27#70+#27#45#48+'||'+#27#45#49+#27#69+PadC(arrWeb[n,11],#32,36)+#27#70+#27#45#48+'|'+#13#10)); //отправление
  write(buf_lpt,#32#13#10);//пустая строка
  write(buf_lpt,UTF8ToCP866(#27#45#49+PadC('ПРИБЫТИЕ',#32,81)+#27#45#48)+#13#10);
  //write(buf_lpt,'__________________________________________________________________'+#13#10);
  write(buf_lpt,#27#45#49+UTF8ToCP866('|              Дата и время прибытия           |'+'|          Пункт высадки         ')+#27#45#48+'|'+#13#10);
  //write(buf_lpt,'|______________________________________|'+'|_____________________|'+#13#10);
  write(buf_lpt,UTF8ToCP866('|'+#27#45#49+#27#69+PadC(arrWeb[n,13]+'  '+arrWeb[n,14],#32,46)+#27#70+#27#45#48+'||'+#27#45#49+#27#69+PadC(arrWeb[n,12],#32,32)+#27#70+#27#45#48+'|'+#13#10)); //прибытие
  write(buf_lpt,#27#48);//уменьшаем межстрочный интервал
  write(buf_lpt,#32#13#10);//пустая строка
  write(buf_lpt,#27#80);
  write(buf_lpt,UTF8ToCP866('Рейс: '+#27#69+trip_ot+' - ' +trip_do+#27#70+'  Маршрут: '+#27#69+trip_num+#27#70+#13#10));  //наименование рейса
  write(buf_lpt,#27#77);
  write(buf_lpt,#32#13#10);//пустая строка
  write(buf_lpt,#27#50);//1/6
  write(buf_lpt,UTF8ToCP866(#27#45#49+PadC('СТОИМОСТЬ БИЛЕТА',#32,90)+#27#45#48)+#13#10);
  write(buf_lpt,#27#103);//уменьшаем размер шрифта

  //write(buf_lpt,'__________________________________________________________________'+#13#10);
  write(buf_lpt,#27#45#49+UTF8ToCP866('|Тарифная стоимость|'+'|Сбор предварительной продажи|'+'|Мест багажа|'+'|Цена багажа|'+'|    ИТОГО    ')+#27#45#48+'|'+#13#10);
  //write(buf_lpt,'|__________________|'+'|____________________________|'+'|___________|'+'|___________|'+'|_________|'+#13#10);
  write(buf_lpt,UTF8ToCP866('|'+#27#45#49+PadC(arrWeb[n,2],#32,18)+#27#45#48+'||'+#27#45#49+PadC(arrWeb[n,3],#32,28)+#27#45#48+'||'+#27#45#49+PadC(arrWeb[n,4],#32,11)+#27#45#48+'||'+
                    #27#45#49+PadC(arrWeb[n,5],#32,11)+#27#45#48+'||'+#27#45#49+PadC(arrWeb[n,6],#32,13)+#27#45#48+'|'+#13#10)); //прибытие
  write(buf_lpt,#27#48);//уменьшаем межстрочный интервал
  write(buf_lpt,UTF8ToCP866('Дата и время формирования (продажи) билета: '+arrWeb[n,23])+#13#10);
  write(buf_lpt,#15#27#80);//включение режима сжатой печати
   //если напечатанных строчек больше maxticks, тогда печатаем на 2-х листах
  //write(buf_lpt,#32#13#10);//пустая строка
  If arrWeb[n,24]='6' then
    begin
     write(buf_lpt,UTF8ToCP866(Padc(webtick1,#32,120))+#13#10);
     write(buf_lpt,UTF8ToCP866(Padc(webtick2,#32,120))+#13#10);
     write(buf_lpt,UTF8ToCP866(Padc(webtick3,#32,120))+#13#10);
     write(buf_lpt,UTF8ToCP866(Padc(webtick4,#32,120))+#13#10);
     end
  else
  begin
  write(buf_lpt,UTF8ToCP866(Padc('Уважаемый клиент! Электронный билет может быть возвращен только в месте его продажи.',#32,120))+#13#10);
  write(buf_lpt,UTF8ToCP866(Padc('Сумма возврата рассчитывается от тарифной стоимости билета.',#32,120))+#13#10);
  write(buf_lpt,UTF8ToCP866(Padc('ЭЛЕКТРОННЫЙ БИЛЕТ СОЗДАН ПОСРЕДСТВОМ АВТОМАТИЗИРОВАННОЙ СИСТЕМЫ <ПЛАТФОРМА АВ>',#32,120))+#13#10);
  //write(buf_lpt,UTF8ToCP866(Padc('НА САЙТЕ WWW.AVTOVOKZAL26.RU',#32,120))+#13#10);
  end;
  write(buf_lpt,#27#50);//1/6
  write(buf_lpt,#18#27#77);//выключение режима сжатой печати
  write(buf_lpt,#32#13#10);//пустая строка
  write(buf_lpt,#32#13#10);//пустая строка
  write(buf_lpt,#32#13#10);//пустая строка
  write(buf_lpt,#32#13#10);//пустая строка
  If (((n+1) mod 2)=0) or (i>-1) then
   write(buf_lpt,#12#13#10);//следующий лист
 end;
  end;

  closefile(buf_lpt);
   //{$codepage utf8}
end;
//---------------------------------------------------------------------------------------------



//**************************************** //обновить грид ведомостей для данного рейса  **********************************
procedure TFormWT.UpdateGrid();
var
  n:integer=0;
  bilettype,doctype:integer;
  soper,kontr_name,kontr_inn,kontr_ogrn: string;
begin
   sdate   :=datetostr(work_date);//дата
   stime    :=full_mas[masindex,10];//время
   splatform:=full_mas[masindex,2];//платформа
   trip_ot:=full_mas[masindex,5];
   trip_do:=full_mas[masindex,8];//рейс
   trip_num:=full_mas[masindex,15];//номер маршрута
   Setlength(arrWeb,0,0);
  with FormWT do
  begin
  Stringgrid1.RowCount:=0;


  for n:=0 to length(tick_mas)-1 do
     begin
       try
            bilettype:=strtoint(tick_mas[n,6]);
           except
              on exception: EConvertError do
              showmessagealt('Ошибка преобразования в целое !');
           end;
      //If bilettype<5 then continue;//$
      Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
      Stringgrid1.Cells[0,Stringgrid1.RowCount-1] := inttostr(n);
      //showmessage(tick_mas[n,0]);
      Stringgrid1.Cells[1,Stringgrid1.RowCount-1] := tick_mas[n,0];  //номер места

      setlength(arrweb,length(arrweb)+1,arrsize);
      arrweb[length(arrweb)-1,0]:=tick_mas[n,1];//номер билета
      arrweb[length(arrweb)-1,1]:=tick_mas[n,0];//место
      arrweb[length(arrweb)-1,2]:=tick_mas[n,10];//тарифная стоимость
      arrweb[length(arrweb)-1,3]:=tick_mas[n,19];//ком сбор
      arrweb[length(arrweb)-1,4]:=tick_mas[n,14];//кол-во багажей
      arrweb[length(arrweb)-1,5]:=tick_mas[n,15];//сумма багажей
      //arrweb[length(arrweb)-1,6]:=floattostrF(strtofloat(tick_mas[n,9])+strtofloat(tick_mas[n,10])+strtofloat(tick_mas[n,17])+strtofloat(tick_mas[n,18])+strtofloat(tick_mas[n,19]),fffixed,10,2);
      arrweb[length(arrweb)-1,6]:=floattostrF(strtofloat(tick_mas[n,10])+strtofloat(tick_mas[n,19])+strtofloat(tick_mas[n,15]),fffixed,10,2);//итого
      arrweb[length(arrweb)-1,7]:=tick_mas[n,11];//фио
      If tick_mas[n,12]<>'' then
      begin
       try
          doctype:=strtoint(tick_mas[n,12]);
       except
         on exception: EConvertError do
           showmessagealt('Ошибка преобразования типа документа !');
       end;
      case doctype of
       0,1:arrweb[length(arrweb)-1,8]:='ПАСПОРТ ГРАЖДАНИНА РОССИИ';//док
       2:arrweb[length(arrweb)-1,8]:='ЗАГРАН. ПАСПОРТ';//док
       3:arrweb[length(arrweb)-1,8]:='паспорт ИНОСТРАННОГО ГРАЖДАНИНА';//док
       4:arrweb[length(arrweb)-1,8]:='Свидетельство о рождении';//док
       5:arrweb[length(arrweb)-1,8]:='Удостов-е военнослужащего';//док
       6:arrweb[length(arrweb)-1,8]:='Удостов-е лица без гражданства';//док
       7:arrweb[length(arrweb)-1,8]:='Временное Удостов-е';//док
       8:arrweb[length(arrweb)-1,8]:='ВОЕННЫЙ БИЛЕТ';//док
       9:arrweb[length(arrweb)-1,8]:='Вид на жит-во';//док
      end;

      end;
      arrweb[length(arrweb)-1,9]:=tick_mas[n,13];//серия
      arrweb[length(arrweb)-1,10]:=tick_mas[n,29];//дата рождения
      arrweb[length(arrweb)-1,11]:=tick_mas[n,20];//откуда
      arrweb[length(arrweb)-1,12]:=tick_mas[n,7];//куда
      arrweb[length(arrweb)-1,13]:=tick_mas[n,22];//дата прибытия
      arrweb[length(arrweb)-1,14]:=tick_mas[n,21];//время прибытия
      arrweb[length(arrweb)-1,15]:=tick_mas[n,23];//тел
      arrweb[length(arrweb)-1,16]:=tick_mas[n,26];//email
      arrweb[length(arrweb)-1,17]:=tick_mas[n,25];//агент
      arrweb[length(arrweb)-1,18]:=tick_mas[n,24];//id_user
      arrweb[length(arrweb)-1,21]:=tick_mas[n,27];//гражданство
      arrweb[length(arrweb)-1,22]:=tick_mas[n,28];//пол
      arrweb[length(arrweb)-1,23]:=tick_mas[n,2]+' '+tick_mas[n,3];//createdate
      arrweb[length(arrweb)-1,24]:=tick_mas[n,6]; //тип билета

     //---------------- выясняем перевозчика, кто продал
     // если продал агент
     If (tick_mas[n,6]='5') or (tick_mas[n,6]='55') then begin
        // --------------------Соединяемся с центральным сервером----------------------
        flagprofile:=1;
  If not(Connect2(formWT.Zconnection1, 2)) then
   begin
      flagprofile:=2;
    showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k2-');
    exit;
   end;
  formWT.ZReadOnlyQuery1.SQL.Clear;
  formWT.ZReadOnlyQuery1.SQL.Add('select * from ( ');
  formWT.ZReadOnlyQuery1.SQL.Add('select a.name,a.inn, ');
  formWT.ZReadOnlyQuery1.SQL.Add('(select case when trim(ogrn)='''' then ogrnip else ogrn end ');
  formWT.ZReadOnlyQuery1.SQL.Add('from av_spr_kontr_fio b where b.id_kontr=a.id order by del asc,createdate desc limit 1) as ogrn ');
  formWT.ZReadOnlyQuery1.SQL.Add('from av_spr_kontragent a ');
  formWT.ZReadOnlyQuery1.SQL.Add(' where id in (select id_kontr from av_web_users_kontr where id_web= ');
  formWT.ZReadOnlyQuery1.SQL.Add('(select id from av_web_users where kod='+tick_mas[n,24]+' order by del asc, createdate desc limit 1) ');
  formWT.ZReadOnlyQuery1.SQL.Add(' ) order by a.del asc, a.createdate desc ');
  formWT.ZReadOnlyQuery1.SQL.Add(' ) z order by char_length(ogrn) desc limit 1');
   //showmessage(ZReadOnlyQuery1.SQL.Text);//$
   try
     formWT.ZReadOnlyQuery1.open;
   except
       //showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery2.SQL.Text);
      flagprofile:=2;
      showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
      formWT.ZReadOnlyQuery1.Close;
      formWT.Zconnection1.disconnect;
      exit;
   end;
    If formWT.ZReadOnlyQuery1.RecordCount>0 then
     begin
       kontr_name:=formWT.ZReadOnlyQuery1.FieldByName('name').AsString;
       kontr_inn:=formWT.ZReadOnlyQuery1.FieldByName('inn').AsString;
       kontr_ogrn:=formWT.ZReadOnlyQuery1.FieldByName('ogrn').AsString;
     end;
    formWT.ZReadOnlyQuery1.Close;
  formWT.Zconnection1.disconnect;

   arrweb[length(arrweb)-1,19]:=kontr_inn;
   arrweb[length(arrweb)-1,20]:=kontr_ogrn;

    end;
  end;
   flagprofile:=2;
    If Stringgrid1.RowCount>0 then
  begin
   //ZReadOnlyQuery1.Close;
   //Zconnection1.disconnect;
   Stringgrid1.ColWidths[0] := 0;
   Stringgrid1.ColWidths[1] := 40;
   Stringgrid1.ColWidths[2] := Stringgrid1.Width-Stringgrid1.ColWidths[1]-Stringgrid1.ColWidths[0]-30;


  StringGrid1.Row:=0;
  StringGrid1.Col:=1;
  StringGrid1.SetFocus;
   end;
  end;
 end;


//*************************************    HOT KEYS    ***************************************************************
procedure TFormWT.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    // ESC
   if (Key=27) then
       begin
         FormWT.Close;
         key:=0;
       end;

   // Enter - печать конкретного билета
   if (Key=13) and (FormWT.StringGrid1.Focused=true) then
       begin
         key:=0;
             {$IFDEF LINUX}
            Linuxprint(Stringgrid1.Row);
              {$ENDIF}
            {$IFDEF WINDOWS}
            Winprint(Stringgrid1.Row);
              {$ENDIF}
       end;

   // Space - печать всех билетов
   if (Key=32) and (FormWT.StringGrid1.Focused=true) then
       begin
            key:=0;
             {$IFDEF LINUX}
            Linuxprint(-1);
             {$ENDIF}
            {$IFDEF WINDOWS}
              Winprint(-1);
            {$ENDIF}
       end;
   //
end;

procedure TFormWT.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;

procedure TFormWT.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  setlength(arrWeb,0,0);
  arrweb:=nil;
end;


procedure TFormWT.FormPaint(Sender: TObject);
begin
  with FormWT do
  begin
   Canvas.Brush.Color:=clSilver;
   Canvas.Pen.Color:=clBlack;
   Canvas.Pen.Width:=2;
   Canvas.Rectangle(2,2,Width-2,Height-2);
  end;
end;


procedure TFormWT.FormShow(Sender: TObject);
begin
  with FormWT do
begin
     //Выравниваем форму
 Left:=form1.Left+(form1.Width div 2)-(Width div 2);
 Top:=form1.Top+(form1.Height div 2)-(Height div 2);
  //находим элемент массива
  //x :=-1;
  //x := arr_get();
  //If x=-1 then FormWT.Close;

 UpdateGrid();     //обновить грид ведомостей
 //TekStatus(x); //текущий статус рейса
  //Заголовок № рейса
 Label1.Caption:= full_mas[masindex,1];

end;
end;


procedure TFormWT.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
   nRow:integer;
begin
   If not formWT.StringGrid1.visible then exit;
  //if form1.Panel5.Visible=true then exit;
  with Sender as TStringGrid, Canvas do
   begin
      AntialiasingMode:=amOff;
      Font.Quality:=fqDraft;
      Brush.Color:=clWhite;
      FillRect(aRect);    //делаем фон
      font.Style:=[];

// ВЫДЕЛЕННАЯ СТРОКА
     if (gdSelected in aState) then
      begin
         //линии выделения
          pen.Width:=12;
          pen.Color:=clMaroon;
          MoveTo(aRect.left,aRect.bottom-1);
          LineTo(aRect.right,aRect.Bottom-1);
          MoveTo(aRect.left,aRect.top-1);
          LineTo(aRect.right,aRect.Top);

         font.height:=16;
         font.Style:=[fsBold];
         font.Color:=clNavy;
      end
  else
    begin
       font.height:=16;
       font.Style:=[];
       font.Color:=clBlack;
     end;


     If (aCol=1) then
     begin
        font.height:=11;
        TextOut(aRect.left + 3,aRect.Top+StringGrid1.DefaultRowHeight div 2 -20  ,'место');
        font.height:=16;
        TextOut(aRect.left + 9,aRect.Top+StringGrid1.DefaultRowHeight div 2 ,Cells[aCol,aRow]);
     end;

    If (aCol=2) then
     begin
        TextOut(aRect.Left + 5, aRect.Top+10,'Билет номер:  '+arrWeb[aRow,0]);
        If (arrweb[aRow,18]='99999') then TextOut(aRect.Left + 5, aRect.Top+40,'Продан в ИНТЕРНЕТ ')
        else
          TextOut(aRect.Left + 5, aRect.Top+40,'Продан: ['+arrweb[aRow,18]+'] '+arrweb[aRow,17]);
        TextOut(aRect.Left + 5, aRect.Top+70,'Куда:  '+arrWeb[aRow,12]);
        TextOut(aRect.Left + 5, aRect.Top+100,'ф.и.о.:  '+arrWeb[aRow,7]);
        TextOut(aRect.Left + 5, aRect.Top+130,'документ: '+arrWeb[aRow,8]+'  номер: '+arrWeb[aRow,9]);
        TextOut(aRect.Left + 5, aRect.Top+160,'дата рожд.:'+arrWeb[aRow,10]+'   тел: '+arrWeb[aRow,15]+
                                              '   почта:  '+arrWeb[aRow,16]);
        TextOut(aRect.Left + 5, aRect.Top+190,'ТАРИФ: '+arrWeb[aRow,2]+
                                               '   бронь:'+arrWeb[aRow,3]+
                                               '  БАГАЖ кол-во:'+arrWeb[aRow,4]+
                                               ' сумма:'+arrWeb[aRow,5]+
                                               '   ИТОГО: '+arrWeb[aRow,6]);
     end;

   end;
end;



end.

