unit vedom_html;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, platproc, strutils;

procedure MakeVedom(nx:integer);

implementation

uses
  maindisp,htmlproc;


procedure MakeVedom(nx:integer);
begin
 (*
vedName := 'vedlist.html';
 // Начало HTML
 if StartHTML(ExtractFilePath(Application.ExeName)+vedName)=false then exit;
 // Таблица - Начало
 StartTableHTML(0,'90%',1);
 StartRowTableHTML('bottom');//новая строка таблицы
 CellsTableHTML(PadC(vedom_mas[nx,19],#32,40),3,3,5,'000000',3,0,''); //АТП
 CellsTableHTML('',1,1,1,'000000',2,0,'');
 CellsTableHTML(PadC(vedom_mas[nx,12],#32,17),3,3,5,'000000',0,0,''); //дата
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
 CellsTableHTML('ВЕДОМОСТЬ № ',2,4,2,'000000',3,0,'');
 CellsTableHTML(PadR(vedom_mas[nx,9],#32,30),1,4,5,'000000',3,0,''); //№ ведомости
 StartRowTableHTML('top');//новая строка таблицы
 CellsTableHTML('('+vedom_mas[nx,0]+IFTHEN(vedom_mas[nx,25]='0',')',' - '+vedom_mas[nx,25]+')'),2,2,1,'000000',3,0,''); //тип ведомости //порядковый номер ведомости дообилечивания
 CellsTableHTML('',1,1,1,'000000',3,0,'');
 EndRowTableHTML();
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML(IfTHEN(vedom_mas[nx,0]='1','Автобус:','учета продажи билетов на автобус:'),3,3,2,'000000',6,0,'');
 EndRowTableHTML();
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
 for n:=0 to length(tick_cur)-1 do
 begin
 StartRowTableHTML('middle');//новая строка таблицы
 CellsTableHTML(tick_cur[n,0],3,3,1,'000000',0,0,'');  //место
 CellsTableHTML(tick_cur[n,1],3,3,1,'000000',0,0,'');  //№ билета
 CellsTableHTML(tick_cur[n,2],3,3,1,'000000',0,0,'');  //вид билета
 CellsTableHTML(tick_cur[n,3],3,3,1,'000000',0,0,'');  //стоимость
 CellsTableHTML(tick_cur[n,4],3,3,1,'000000',0,0,'');  //пункт назначения
 If fldoc then CellsTableHTML(tick_cur[n,8]+'<br>'+tick_cur[n,9],3,3,1,'000000',0,0,'');//тип документа, номер
 If flfio then CellsTableHTML(tick_cur[n,7],3,3,1,'000000',0,0,'');                   //фио
 CellsTableHTML(tick_cur[n,5],3,3,1,'000000',0,0,'');                    //кол-во багажа
 CellsTableHTML(tick_cur[n,6],3,3,1,'000000',0,0,'');                   //сумма багажа
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
 startbrowser(ExtractFilePath(Application.ExeName)+'vedlist.html');
  *)
  end;
end.

