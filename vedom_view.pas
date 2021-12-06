unit vedom_view;

{$mode objfpc}{$H+}
//{$codepage utf8}

interface

uses
  Classes, SysUtils,  LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons,
  LazUTF8,
  //cwstring,
  lconvencoding,
  //{$IFDEF WINDOWS}
   Printers;
  //{$ENDIF}

type

  { TFormV }

  TFormV = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label43: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure load_ved;//ОТКРЫТЬ ФАЙЛ ВЕДОМОСТИ В MEMO
    procedure print_raw; //вывод на принтер
    procedure load_ved2;//ОТКРЫТЬ ФАЙЛ ВЕДОМОСТИ
    procedure print_raw2; //вывод на принтер из файла
    procedure print_raw3; //вывод на принтер из файла
    procedure get_print_akt();//печать акта за незаявленное ТС
    procedure print_raw_win; //печать с окном выбора принтеров
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormV: TFormV;

implementation

uses
  maindisp,platproc;
{$R *.lfm}

{ TFormV }

procedure TFormV.print_raw_win;
 var
  Written: Integer;
  tfile: textfile;
  n,len:integer;
  s,tmp,filev:string;
begin
 with FormV do
  begin
   Panel2.Visible:=false;
   Panel1.visible := true;
   If (printer_vid=1) then Label1.Caption:='ТИП: ЛАЗЕРНЫЙ';
   If (printer_vid=2) then Label1.Caption:='ТИП: МАТРИЧНЫЙ';
   //sleep(10);

  // Загружаем файл
  filev := vedName;
  AssignFile(tfile,filev);
  {$I-} // отключение контроля ошибок ввода-вывода
  Reset(tfile); // открытие файла для чтения
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
    begin
      showmessagealt('ОШИБКА ОТКРЫТИЯ ФАЙЛА ВЕДОМОСТИ !');
      FormV.Close;
      Exit;
    end;


  While not EOF(tfile) do
    begin
      s:='';
      readln(tfile,s);
      s:= s+#13#10;
       //while utf8pos(#27,s)>0 do
       // begin
       //   //showmessage(inttostr(ord(s[n])));
       //  s :=utf8copy(s,1,utf8pos(#27,s)-1)+utf8copy(s,utf8pos(#27,s)+2,utf8length(s));
       // end;
      Printer.Write(s[1], Length(s), Written);
    end;
   // --------- Закрываем текстовый файл
   CloseFile(tfile);


  //While not EOF(tfile) do
  //  begin
  //    s:='';
  //    readln(tfile,s);
  //   //печать на лазерный принтер
  //   If (printer_type=1) and (printer_vid=1) then
  //    Writeln(buf_lpt, UTF8ToCP866(s)+#13#10);
  //   //печать на матричный принтер
  //   If (printer_type=1) and (printer_vid=2) then
  //    Writeln(buf_lpt, UTF8ToCP866(s));
  //
  // end;
  //CloseFile(buf_lpt);
   Panel1.visible := false;
   end;

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&  ПЕЧАТЬ АКТА   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
procedure TFormV.get_print_akt();
const
  bold=#027#040#115#051#066; //жирный
  norm=#027#040#115#048#066; //нежирный
  under=#027#038#100#048#068;//подчернкутый
  plain=#027#038#100#064;//не подчеркнутый
 // #027#040#115+'15'+#072 включение режима сжатой печати
 // #027#040#115+'12'+#072 выключение режима сжатой печати
 var
   buf_LPT:TextFile;
   prn,filev: String;
   ravto,rnomer:string;
begin
   ravto:=utf8copy(full_mas[masindex,33],1,utf8pos('|',full_mas[masindex,33])-1); //марка
   rnomer:=utf8copy(full_mas[masindex,33],utf8pos('|',full_mas[masindex,33])+1,utf8length(full_mas[masindex,33])-utf8pos('|',full_mas[masindex,33])); //номер

   prn := '/dev/lp0';
   AssignFile(buf_lpt,prn);
// Загружаем файл
   {$I-} // отключение контроля ошибок ввода-вывода
 Rewrite(buf_lpt);
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then
    begin
     showmessage('Локальный принтер не подключен !!!'+#13+'Проверьте физическое подключение принтера ...');
     exit;
    end;

     //если опция печати на лазерный принтер
  If printer_vid=1 then
    begin
//CR=CR;LF=LF; FF=FF             Ec&k0G  #027#038#107#048#071
//CR=CR+LF;LF=LF FF=FF           Ec&k1G #027#038#107#049#071
//CR=CR; LF=CR+LF; FF=CR+FF      Ec&k2G  #027#038#107#050#071
//CR=CR+LF; LF=CR+LF; FF=CR+FF   Ec&k3G #027#038#107#051#071

  //******сброс настроек+портретная ориентация+а4 +                    +межстрочный интервал
  write(buf_lpt,#027#069+#027#038#108#048#079+#027#038#108#050#054#065+#027#038#108+'7'+#067); //отмена режима сжатой печати
 //write(buf_lpt,#027#069+#027#038#108#048#079+#027#038#108#050#054#065+#027#040#115+'10'+#072+#027#038#108+'5'+#067);    //отмена режима сжатой печати
  write(buf_lpt,StringofChar(#32,25)+#027#040#115+'8'+#072+bold+UTF8ToCP866('Акт за обслуживание маршрута')+#13#10);
  write(buf_lpt,StringofChar(#32,15)+UTF8ToCP866('незаявленным транспортным средством')+norm+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+under+PadC(UTF8ToCP866(server_name),#32,30)+plain);//сервер продажи и печать подчеркнутого текста
  write(buf_lpt,StringofChar(#32,15));//
  write(buf_lpt,under+PadC(UTF8ToCP866(FormatDateTime('dd.mm.yyyy hh:nn',now())),#32,18)+plain+#13#10);//дата  перевод строки и возврат каретки;   //дата
  write(buf_lpt,StringofChar(#32,10)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование линейного сооружения)')+StringofChar(#32,25)+UTF8ToCP866('(дата,время)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автотранспортное предприятие')+StringofChar(#32,3)+under+PadC(UTF8ToCP866(full_mas[masindex,19]),#32,30)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование АТП, ИП)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автобус для работы на маршруте')+StringofChar(#32,1));
  write(buf_lpt,under+PadC(UTF8ToCP866('№'+full_mas[masindex,15]+#32+full_mas[masindex,5]+' - '+full_mas[masindex,8]),#32,34)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование маршрута)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Марка автобуса')+StringofChar(#32,8)+under+PadC(UTF8ToCP866(ravto),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование марки транспортного средства)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Гос.регистрац. номер')+StringofChar(#32,2)+under+PadC(UTF8ToCP866(rnomer),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(серия и номер транспортного средства)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Путевой лист')+StringofChar(#32,10)+under+PadC(UTF8ToCP866(full_mas[masindex,35]),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(реквизиты путевого листа, дата, номер)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Ведомость')+StringofChar(#32,13)+under+PadC(UTF8ToCP866(form1.Get_num_vedom(masindex)+'  от '+FormatDateTime('dd.mm.yyyy',work_date)),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(реквизиты ведомости, номер, дата)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Время отправления')+StringofChar(#32,5)+under+PadC(UTF8ToCP866(full_mas[masindex,10]),#32,40)+plain+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,10)+#027#040#115+'9'+#072+bold+UTF8ToCP866('За обслуживание маршрута незаявленным транспортным средством')+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,7)+bold+UTF8ToCP866('взыскивается '+under+PadC('500',#32,20)+plain+' руб.')+norm+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Начальник АВ')+StringofChar(#32,1)+under+StringofChar(#32,50)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072+#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Диспетчер')+StringofChar(#32,4)+under+PadL(UTF8ToCP866(name_user_active),#32,50)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072+#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Водитель')+StringofChar(#32,5)+under+PadL(UTF8ToCP866(full_mas[masindex,36]),#32,50)+plain+#13#10);
  //write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072+#13#10);

  write(buf_lpt,#13#10);//пустая строка
  write(buf_lpt,#13#10);//пустая строка
  write(buf_lpt,#13#10);//пустая строка

  write(buf_lpt,StringofChar(#32,25)+#027#040#115+'8'+#072+bold+UTF8ToCP866('Акт за обслуживание маршрута')+#13#10);
  write(buf_lpt,StringofChar(#32,15)+UTF8ToCP866('незаявленным транспортным средством')+norm+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+under+PadC(UTF8ToCP866(server_name),#32,30)+plain);//сервер продажи и печать подчеркнутого текста
  write(buf_lpt,StringofChar(#32,15));//
  write(buf_lpt,under+PadC(UTF8ToCP866(FormatDateTime('dd.mm.yyyy hh:nn',now())),#32,18)+plain+#13#10);//дата  перевод строки и возврат каретки;   //дата
  write(buf_lpt,StringofChar(#32,10)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование линейного сооружения)')+StringofChar(#32,25)+UTF8ToCP866('(дата,время)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автотранспортное предприятие')+StringofChar(#32,3)+under+PadC(UTF8ToCP866(full_mas[masindex,19]),#32,30)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование АТП, ИП)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автобус для работы на маршруте')+StringofChar(#32,1));
  write(buf_lpt,under+PadC(UTF8ToCP866('№'+full_mas[masindex,15]+#32+full_mas[masindex,5]+' - '+full_mas[masindex,8]),#32,34)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование маршрута)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Марка автобуса')+StringofChar(#32,8)+under+PadC(UTF8ToCP866(ravto),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование марки транспортного средства)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Гос.регистрац. номер')+StringofChar(#32,2)+under+PadC(UTF8ToCP866(rnomer),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(серия и номер транспортного средства)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Путевой лист')+StringofChar(#32,10)+under+PadC(UTF8ToCP866(full_mas[masindex,35]),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(реквизиты путевого листа, дата, номер)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Ведомость')+StringofChar(#32,13)+under+PadC(UTF8ToCP866(form1.Get_num_vedom(masindex)+'  от '+FormatDateTime('dd.mm.yyyy',work_date)),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(реквизиты ведомости, номер, дата)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Время отправления')+StringofChar(#32,5)+under+PadC(UTF8ToCP866(full_mas[masindex,10]),#32,40)+plain+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,10)+#027#040#115+'9'+#072+bold+UTF8ToCP866('За обслуживание маршрута незаявленным транспортным средством')+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,7)+bold+UTF8ToCP866('взыскивается '+under+PadC('500',#32,20)+plain+' руб.')+norm+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Начальник АВ')+StringofChar(#32,1)+under+StringofChar(#32,50)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072+#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Диспетчер')+StringofChar(#32,4)+under+PadL(UTF8ToCP866(name_user_active),#32,50)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072+#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Водитель')+StringofChar(#32,5)+under+PadL(UTF8ToCP866(full_mas[masindex,36]),#32,50)+plain+#13#10);
  //write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072);

  write(buf_lpt,#027#038#108#048#072);//выброс листа
 end;

    //если опция печати на матричный принтер
  If printer_vid=2 then
    begin
   //  #18               отменить сжатый текст
  //  #27#77    установить шрифт 12 p/i
  //  #27#80    установить шрифт 10 p/i
  //  #27#65#12 , межстрочный интервал = n/72

 //The printer language ESC/P was originally developed by Epson for use with their early dot-matrix printers.
  write(buf_lpt,#27#18#27#77#27#48); //отмена режима сжатой печати
  write(buf_lpt,#13#10);//пустая строка
  write(buf_lpt,#13#10);//пустая строка
  write(buf_lpt,StringofChar(#32,30)+#27#80+#27#69+UTF8ToCP866('Акт за обслуживание маршрута')+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,21)+UTF8ToCP866('незаявленным транспортным средством')+#27#70+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+#27#77+#27#45#49+PadC(UTF8ToCP866(server_name),#32,30)+#27#45#48);//сервер продажи и печать подчеркнутого текста
  write(buf_lpt,StringofChar(#32,20));//
  write(buf_lpt,#27#45#49+PadC(UTF8ToCP866(FormatDateTime('dd.mm.yyyy hh:nn',now())),#32,20)+#27#45#48+#13#10);//дата  перевод строки и возврат каретки;   //дата
  write(buf_lpt,StringofChar(#32,16)+#15+UTF8ToCP866('(наименование линейного сооружения)')+StringofChar(#32,54)+UTF8ToCP866('(дата,время)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автотранспортное предприятие')+StringofChar(#32,3)+#27#45#49+PadC(UTF8ToCP866(full_mas[masindex,19]),#32,42)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#15+UTF8ToCP866('(наименование АТП, ИП)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автобус для работы на маршруте')+StringofChar(#32,1));
  write(buf_lpt,#27#45#49+PadC(UTF8ToCP866('№'+full_mas[masindex,15]+#32+full_mas[masindex,5]+' - '+full_mas[masindex,8]),#32,36)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#15+UTF8ToCP866('(наименование маршрута)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Марка автобуса')+StringofChar(#32,8)+#27#45#49+PadC(UTF8ToCP866(ravto),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(наименование марки транспортного средства)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Гос.регистрац. номер')+StringofChar(#32,2)+#27#45#49+PadC(UTF8ToCP866(rnomer),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(серия и номер транспортного средства)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Путевой лист')+StringofChar(#32,10)+#27#45#49+PadC(UTF8ToCP866(full_mas[masindex,35]),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(реквизиты путевого листа, дата, номер)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Ведомость')+StringofChar(#32,13)+#27#45#49+PadC(UTF8ToCP866(form1.Get_num_vedom(masindex) +'  от '+FormatDateTime('dd.mm.yyyy',work_date)),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(реквизиты ведомости, номер, дата)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Время отправления')+StringofChar(#32,5)+#27#45#49+PadC(UTF8ToCP866(full_mas[masindex,10]),#32,40)+#27#45#48+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,10)+#27#80+#27#69+UTF8ToCP866('За обслуживание маршрута незаявленным транспортным средством')+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,6)+UTF8ToCP866('взыскивается '+#27#45#49+PadC('500',#32,20)+#27#45#48+' руб.')+#27#70+#13#10#13#10);
  write(buf_lpt,#27#77+StringofChar(#32,8)+UTF8ToCP866('Начальник АВ')+StringofChar(#32,1)+#27#45#49+StringofChar(#32,62)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Диспетчер')+StringofChar(#32,2)+#27#45#49+PadL(UTF8ToCP866(name_user_active),#32,65)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Водитель')+StringofChar(#32,3)+#27#45#49+PadL(UTF8ToCP866(full_mas[masindex,36]),#32,65)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10#13#10);

  write(buf_lpt,#13#10);//пустая строка
  write(buf_lpt,#13#10);//пустая строка
  write(buf_lpt,#13#10);//пустая строка
  write(buf_lpt,#13#10);//пустая строка

  write(buf_lpt,StringofChar(#32,30)+#27#80+#27#69+UTF8ToCP866('Акт за обслуживание маршрута')+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,21)+UTF8ToCP866('незаявленным транспортным средством')+#27#70+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+#27#77+#27#45#49+PadC(UTF8ToCP866(server_name),#32,30)+#27#45#48);//сервер продажи и печать подчеркнутого текста
  write(buf_lpt,StringofChar(#32,20));//
  write(buf_lpt,#27#45#49+PadC(UTF8ToCP866(FormatDateTime('dd.mm.yyyy hh:nn',now())),#32,20)+#27#45#48+#13#10);//дата  перевод строки и возврат каретки;   //дата
  write(buf_lpt,StringofChar(#32,16)+#15+UTF8ToCP866('(наименование линейного сооружения)')+StringofChar(#32,54)+UTF8ToCP866('(дата,время)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автотранспортное предприятие')+StringofChar(#32,3)+#27#45#49+PadC(UTF8ToCP866(full_mas[masindex,19]),#32,42)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#15+UTF8ToCP866('(наименование АТП, ИП)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автобус для работы на маршруте')+StringofChar(#32,1));
  write(buf_lpt,#27#45#49+PadC(UTF8ToCP866('№'+full_mas[masindex,15]+#32+full_mas[masindex,5]+' - '+full_mas[masindex,8]),#32,36)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#15+UTF8ToCP866('(наименование маршрута)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Марка автобуса')+StringofChar(#32,8)+#27#45#49+PadC(UTF8ToCP866(ravto),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(наименование марки транспортного средства)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Гос.регистрац. номер')+StringofChar(#32,2)+#27#45#49+PadC(UTF8ToCP866(rnomer),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(серия и номер транспортного средства)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Путевой лист')+StringofChar(#32,10)+#27#45#49+PadC(UTF8ToCP866(full_mas[masindex,35]),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(реквизиты путевого листа, дата, номер)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Ведомость')+StringofChar(#32,13)+#27#45#49+PadC(UTF8ToCP866(form1.Get_num_vedom(masindex) +'  от '+FormatDateTime('dd.mm.yyyy',work_date)),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(реквизиты ведомости, номер, дата)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Время отправления')+StringofChar(#32,5)+#27#45#49+PadC(UTF8ToCP866(full_mas[masindex,10]),#32,40)+#27#45#48+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,10)+#27#80+#27#69+UTF8ToCP866('За обслуживание маршрута незаявленным транспортным средством')+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,6)+UTF8ToCP866('взыскивается '+#27#45#49+PadC('500',#32,20)+#27#45#48+' руб.')+#27#70+#13#10#13#10);
  write(buf_lpt,#27#77+StringofChar(#32,8)+UTF8ToCP866('Начальник АВ')+StringofChar(#32,1)+#27#45#49+StringofChar(#32,62)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Диспетчер')+StringofChar(#32,2)+#27#45#49+PadL(UTF8ToCP866(name_user_active),#32,65)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Водитель')+StringofChar(#32,3)+#27#45#49+PadL(UTF8ToCP866(full_mas[masindex,36]),#32,65)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10#13#10);

  write(buf_lpt,#12#13#10);//выброс листа
   end;

  CloseFile(buf_lpt);
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&  ПЕЧАТЬ из файла   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
procedure TFormV.print_raw2;
 var
   buf_LPT:TextFile;
   prn, filev: String;
   s: string;
   n:integer;
   tfile: textfile;
begin
   //prn := '/dev/usb/lp0';
   //prn := '/dev/lp0';
    //prn := '/dev/printers/0';
   //prn := ExtractFilePath(Application.ExeName)+'disp_log/v888';
   //AssignFile(buf_lpt,prn);
   AssignFile(buf_lpt,printer_dev);
// Загружаем файл
   {$I-} // отключение контроля ошибок ввода-вывода
 Rewrite(buf_lpt);
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then
    begin
     showmessage('Локальный принтер не подключен !!!'+#13+'Проверьте физическое подключение принтера ...');
     exit;
    end;
   // Загружаем файл
  filev := vedName;
  //filev := ExtractFilePath(Application.ExeName)+'disp_log/webtick';
  //filev := ExtractFilePath(Application.ExeName)+'disp_log/webt1.txt';
  AssignFile(tfile,filev);
  {$I-} // отключение контроля ошибок ввода-вывода
  Reset(tfile); // открытие файла для чтения
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
    begin
      showmessagealt('ОШИБКА ОТКРЫТИЯ ФАЙЛА ВЕДОМОСТИ !');
      FormV.Close;
      Exit;
    end;
 with FormV do
   begin

   Panel1.visible := true;
   If (printer_vid=1) then Label1.Caption:='ТИП: ЛАЗЕРНЫЙ';
   If (printer_vid=2) then Label1.Caption:='ТИП: МАТРИЧНЫЙ';
  While not EOF(tfile) do
    begin
      try
      s:='';
      readln(tfile,s);
      //setcodepage(s, 1251,false);
     //Write(buf_lpt, UTF8ToCP866(form1.Memo1.Lines.Strings[n])+ #13#10);
     //печать на лазерный принтер
     If (printer_type=1) and (printer_vid=1) then
      //Writeln(buf_lpt,s);
       Writeln(buf_lpt, UTF8ToCP866(s)+#13#10);
     //печать на матричный принтер
     If (printer_type=1) and (printer_vid=2) then
       Writeln(buf_lpt, UTF8ToCP866(s));
      except
        break;
        formV.Close;
      end;
   end;
  CloseFile(buf_lpt);
   Panel1.visible := false;
   end;

end;


//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&  ПЕЧАТЬ из файла   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
procedure TFormV.print_raw;
 var
   buf_LPT,tfile:TextFile;
   prn,filev: String;
   s:string;
   n:integer;
begin
   AssignFile(buf_lpt,printer_dev);
// Загружаем файл
   {$I-} // отключение контроля ошибок ввода-вывода
 Rewrite(buf_lpt);
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then
    begin
     showmessage('Локальный принтер не подключен !!!'+#13+'Проверьте физическое подключение принтера ...');
     exit;
    end;
    // Загружаем файл
  //filev := vedName;
  //filev := ExtractFilePath(Application.ExeName)+'disp_log/webtick';
  filev := ExtractFilePath(Application.ExeName)+'disp_log/v3';
  AssignFile(tfile,filev);
  {$I-} // отключение контроля ошибок ввода-вывода
  Reset(tfile); // открытие файла для чтения
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
    begin
      showmessagealt('ОШИБКА ОТКРЫТИЯ ФАЙЛА ВЕДОМОСТИ !');
      FormV.Close;
      Exit;
    end;
 with FormV do
   begin

  While not EOF(tfile) do
    begin
      try
      s:='';
      readln(tfile,s);
      //s:=setcodepage(s,cp866,false);
       //Write(buf_lpt, UTF8ToCP866(form1.Memo1.Lines.Strings[n])+ #13#10);
     //печать на лазерный принтер
     If (printer_type=1) and (printer_vid=1) then
      Writeln(buf_lpt,s);
      except
        break;
        formV.Close;
      end;
   end;
  CloseFile(buf_lpt);
end;

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&  ПЕЧАТЬ из файла   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
procedure TFormV.print_raw3;
 var
   buf_LPT:TextFile;
   prn, filev: String;
   s: String;
   n:integer;
   tfile: textfile;
begin

   //prn := '/dev/usb/lp0';
   //prn := '/dev/lp0';
    //prn := '/dev/printers/0';
   prn := ExtractFilePath(Application.ExeName)+'disp_log/vDos';
   AssignFile(buf_lpt,prn);
   //AssignFile(buf_lpt,printer_dev);
// Загружаем файл
   {$I-} // отключение контроля ошибок ввода-вывода
 Rewrite(buf_lpt);
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then
    begin
     showmessage('Локальный принтер не подключен !!!'+#13+'Проверьте физическое подключение принтера ...');
     exit;
    end;
   // Загружаем файл
  filev := vedName;
  //filev := ExtractFilePath(Application.ExeName)+'disp_log/webtick';
  AssignFile(tfile,filev);
  {$I-} // отключение контроля ошибок ввода-вывода
  Reset(tfile); // открытие файла для чтения
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
    begin
      showmessagealt('ОШИБКА ОТКРЫТИЯ ФАЙЛА ВЕДОМОСТИ !');
      FormV.Close;
      Exit;
    end;
  While not EOF(tfile) do
    begin
      try
      s:='';
      readln(tfile,s);
      s:=utf8toCP866(s);
      //setcodepage(s, 866,false);
       //Write(buf_lpt, UTF8ToCP866(form1.Memo1.Lines.Strings[n])+ #13#10);
     //печать на лазерный принтер
     If (printer_type=1) and (printer_vid=1) then
      Writeln(buf_lpt,s);
      except
        break;
        formV.Close;
      end;
   end;
  CloseFile(buf_lpt);
end;


//***************************************** ОТКРЫТЬ ФАЙЛ ВЕДОМОСТИ В MEMO *********************************** *
procedure TFormV.load_ved2;
 var
  tfile: textfile;
  n,len:integer;
  s,tmp,filev:string;
begin
  // Загружаем файл
  filev := vedName;
  AssignFile(tfile,filev);
  {$I-} // отключение контроля ошибок ввода-вывода
  Reset(tfile); // открытие файла для чтения
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
    begin
      showmessagealt('ОШИБКА ОТКРЫТИЯ ФАЙЛА ВЕДОМОСТИ !');
      FormV.Close;
      Exit;
    end;
with FormV do
  begin
  Memo1.Clear;
  While not EOF(tfile) do
    begin
      s:='';
      readln(tfile,s);
       while utf8pos(#27,s)>0 do
        begin
          //showmessage(inttostr(ord(s[n])));
          s:=utf8copy(s,1,utf8pos(#27,s)-1)+utf8copy(s,utf8pos(#27,s)+2,utf8length(s));
        end;
      Memo1.Lines.Add(s);
      //kol_txt_strok:=kol_txt_strok+1;
    end;
   // --------- Закрываем текстовый файл
   CloseFile(tfile);
   // Рисуем текущее количество строк и № текущей строки
   //form1.Label2.Caption:='Текущая строка: 1/'+inttostr(kol_txt_strok);
   //form1.Memo1.SetFocus;
  end;
end;


//***************************************** ОТКРЫТЬ ФАЙЛ ВЕДОМОСТИ В MEMO *********************************** *
procedure TFormV.load_ved;
 var
  tfile: textfile;
  n:integer;
  s,filev:string;
begin
  // Загружаем файл
  filev := vedName;
  AssignFile(tfile,filev);
  {$I-} // отключение контроля ошибок ввода-вывода
  Reset(tfile); // открытие файла для чтения
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
    begin
      showmessagealt('ОШИБКА ОТКРЫТИЯ ФАЙЛА ВЕДОМОСТИ !');
      FormV.Close;
      Exit;
    end;
with FormV do
  begin
  Memo1.Clear;
  While not EOF(tfile) do
    begin
      s:='';
      readln(tfile,s);
      Memo1.Lines.Add(s);
      //kol_txt_strok:=kol_txt_strok+1;
    end;
   // --------- Закрываем текстовый файл
   CloseFile(tfile);
   // Рисуем текущее количество строк и № текущей строки
   //form1.Label2.Caption:='Текущая строка: 1/'+inttostr(kol_txt_strok);
   //form1.Memo1.SetFocus;
  end;
end;

//******************************** ГОРЯЧИЕ КЛАВИШИ ------------------------************
procedure TFormV.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  //showmessage(inttostr(ord(chr(key))));
    //showmessage(inttostr(key));
   // F1
   if Key=112 then
     begin
         key:=0;
     showmessagealt('[F1] - Справка'+#13+'[ENTER]/[ESC] - Закрыть просмотр ведомости'+#13+'[ПРОБЕЛ] - Печать ведомости');

     end;
   // ESC
   if (Key=27)  then
       begin
         key:=0;
         formV.Close;
         exit;
       end;
  If (Key=13) then
   begin
      key:=0;
   //  If ListBox1.Focused then
   //  FormV.BitBtn1.Click
   //else
       //print_raw3();
       //print_raw2();
       //showmessage('ГОТОВО №3');//$
      formV.Close;
      exit;
   end;
  // ПРОБЕЛ - печать ведомости
   if (Key=32) and not FormV.Panel2.Visible then
    begin
          key:=0;
          //showmessage(printer_dev);
           //print_raw();
          //{$IFDEF WINDOWS}
          //formV.Panel2.Visible:=true;
          //formV.ListBox1.SetFocus;
          //formV.ListBox1.ItemIndex:=0;
           //formV.BitBtn1.Click;
          //{$ENDIF}
           //{$IFDEF LINUX}
           print_raw2();
           //showmessage('ГОТОВО №2');//$
           FormV.Close;
           //{$ENDIF}
           //exit;
    end;
   // del
   If (Key=8) or (key=113) then
    begin
       key:=0;
       print_raw();
       showmessage('ГОТОВО №1');//$
       //FormV.Close;
    end;
end;

procedure TFormV.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
   //{$IFDEF WINDOWS}
   Listbox1.Items.Assign(Printer.Printers);
   //{$ENDIF}
end;

procedure TFormV.BitBtn1Click(Sender: TObject);
begin
 With FOrmV do
   begin
   //if Listbox1.ItemIndex<0 then begin
    //Label4.Caption:='НЕ ОПРЕДЕЛЕН ПРИНТЕР для печати !';
    //exit;
  //end;

  // on a freshly retrieved printer list, either method could
  // be used to select a printer: SetPrinter or PrinterIndex
  //Printer.PrinterIndex := Listbox1.ItemIndex;
  //Printer.SetPrinter(ListBox1.Items[Listbox1.ItemIndex]);
   //showmessage(inttostr(Printer.PrinterIndex)+#13+ListBox1.Items[Listbox1.ItemIndex]);
  //взять принтер по умолчанию
  Printer.PrinterIndex := -1;
  //Printer.SetPrinter(ListBox1.Items[Listbox1.ItemIndex]);
  //Printer.Title := Caption;
  //Printer.RawMode := True;
  Printer.BeginDoc;
  print_raw_win;
  Printer.EndDoc;
  end;
end;

procedure TFormV.FormShow(Sender: TObject);
begin
   Centrform(formV);
   //load_ved();
   load_ved2();
end;

end.

