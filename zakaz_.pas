unit zakaz_main;

{$mode objfpc}{$H+}

interface

uses
  Classes,  SysUtils,  Forms,
  //Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Grids, DateTimePicker, ZConnection,
  ZDataset, strutils, wibor_atp, wibor_ats, lclproc, Spin, Calendar,
  LConvEncoding, Controls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Bevel1: TBevel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit2: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label6: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    StringGrid1: TStringGrid;
    ZConnection1: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    ZReadOnlyQuery2: TZReadOnlyQuery;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DateTimePicker3: TDateTimePicker;
    DateTimePicker4: TDateTimePicker;

    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox1Enter(Sender: TObject);
    procedure CheckBox1Exit(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit11Change(Sender: TObject);
    procedure Edit13KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit13KeyPress(Sender: TObject; var Key: char);
    procedure Edit18Change(Sender: TObject);
    procedure Edit20Change(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit8Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //инициализация объектов формы
    procedure set_form(oper:byte);
    // Расчет списка атп и атс для текущего рейса
    procedure get_shedule_atp_ats;
    procedure DateTimePicker1Change(Sender: TObject);
   // ЗАГРУЖАЕМ СПИСОК АТС ДЛЯ СОЗДАНИЯ ЗАКАЗНОГО РЕЙСА
    procedure get_ats_zakaz;
    // Сохраняем данные при отправлении, смене АТП и АТС
    procedure Save_critical(oper:byte; mode:byte);
       //mode=1 - запись только реквизитов рейса
       //mode=2 - запись нового состояния рейса и реквизитов
    // Сохраняем данные при прибытии, заказном рейсе и
    procedure save_zakaznoi(oper:byte; mode:byte);
    // ЗАПРОС ДАННЫХ ПО РЕЙСУ ИЗ ДИСПЕТЧЕРСКИХ ОПЕРАЦИЙ РЕЙСА (ПО РЕЙСУ ИЛИ СВЯЗАННЫМ РЕЙСАМ)
    //procedure getdisp_oper(arn:integer);
    //создание ведомости для данного рейса
    function Vedom_Make(ZCon:TZConnection;ZQ1:TZReadOnlyQuery;nx:integer):boolean;
       //mode=1 основная
       //mode=2 дообилечивания
       //mode=3 основная заказная
       //mode=4 дообилечивания заказная

    //заполнение переменных и поля перевозчика
    procedure fill_atp(num:byte);
   //заполнение переменных и поля АТС
    procedure fill_ats(num:byte);
    procedure write_oper();  // записать операции в базу по связанным рейсам ******************
    procedure ats_search(ind:integer);//контекстный поиск атс
    procedure getz_date();
    procedure print_akt();//печать акта за незаявленное ТС
    // проверка, что расписание в перечне по передаче данных
   function checkinfio():boolean;
   function decode_personal(drv:integer;ptext:string):string;//заполнить поля по водителям
   function encode_personal():boolean;//заполнить поля по водителям
   procedure AnyEditEnter(Sender: TObject);
   procedure AnyEditExit(Sender: TObject);
   //procedure AnyEditChange(Sender: TObject);
   function findVoditel(tfio:string; mode:byte):integer;
   procedure openforedit();
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;
  tmp_atp:array of array of string;
  //------- массив перевозчиков расписания -----------
  //tmp_atp[n,0] - id_kontr
  //tmp_atp[n,1] - kontr_name
  //tmp_atp[n,2] - кол-во атс
  tmp_ats:array of array of string;
  //------  массив автобусов перевозчика ----------
        //tmp_ats[length(tmp_ats)-1,0]:=  id_kontr
        //tmp_ats[length(tmp_ats)-1,1]:=  id_ats
        //tmp_ats[length(tmp_ats)-1,2]:=  name
        //tmp_ats[length(tmp_ats)-1,3]:=  gos
        //tmp_ats[length(tmp_ats)-1,4]:=  kol_mest
        //tmp_ats[length(tmp_ats)-1,5]:=  type_ats
        //tmp_ats[length(tmp_ats)-1,6]:=inttostr(n+1); //порядковый номер атс перевозчика

  tek_mas_atp:integer=0;
  tek_mas_ats:integer=0;
  zkaz,udalenka_real,udalenka_virt:boolean;
  tripdate:string;
  isfio:boolean;


implementation

uses
  platproc,maindisp,htmlproc,menu;

const
   minstrsearch=3;

var
  def_time:TTime;
  n:integer;
  k:integer=0;
  idx:integer=-1;
  flchange:boolean=false;
  flset:boolean=false;
  up_time,up_point,up_order,kontr_name,kontr_id,ats_id,ats_name
   ,ats_gos,ats_mest,ats_type,put: string;
  //,dr1,dr2,dr3,dr4: string;
  ticket_canceled,active_check:boolean;   //флаг критичного изменения типа автобуса с M3 на M2
  vid_sriv:integer;//(=3) отметка о незаявленном ТС
  real_avto,real_reg_sign:string;//марка и номер незаявленного ТС
  megamas: array of integer;
  vedom_num:string='';//номер ведомости
  drv1,drv2,drv3,doc1,doc2,doc3:string;
  notfindflag,flseek,checkstate:boolean;
  famildlina:byte;
  ggg:integer;
  tekedit:integer;

{$R *.lfm}
{ TForm2 }

procedure TForm2.openforedit();
begin
 with form2 do
  begin
 //водила 1
  If form2.Edit2.Caption<>'' then
   begin
    //если рейс с передачей данных
   If isfio then
    begin
      If not Combobox1.Enabled then form2.ComboBox1.Enabled:=true;
      If not Edit13.Enabled    then form2.Edit13.Enabled:=true;
      If not DateTimePicker2.Enabled then form2.DateTimePicker2.Enabled:=true;
      If not Combobox2.Enabled then form2.ComboBox2.Enabled:=true;
      If not Combobox7.Enabled then form2.ComboBox7.Enabled:=true;
      //If not Edit14.Enabled then form2.Edit14.Enabled:=true;
    end;
   end;
  If form2.Edit11.Caption<>'' then
   begin
       If Edit12.Enabled=false then form2.Edit12.enabled:=true;
   end;
 If form2.Edit3.Caption<>'' then
      begin
       If not Edit18.enabled then form2.Edit18.Enabled:=true;
       If not GroupBox3.Visible then form2.GroupBox3.Visible:=true;
       If isfio then
        begin
           If not Combobox3.Enabled then form2.ComboBox3.Enabled:=true;
      If not Edit15.Enabled    then form2.Edit15.Enabled:=true;
      If not DateTimePicker3.Enabled then form2.DateTimePicker3.Enabled:=true;
      If not Combobox4.Enabled then form2.ComboBox4.Enabled:=true;
      //If not Edit16.Enabled then form2.Edit16.Enabled:=true;
      If not Combobox8.Enabled then form2.ComboBox8.Enabled:=true;
        end;
      end;
  If form2.Edit18.Caption<>'' then
   begin
       If Edit19.Enabled=false then form2.Edit19.enabled:=true;
       //открыть заполнение водителя №3
       If form2.Edit4.Enabled=false then form2.Edit4.enabled:=true;
   end;
   If form2.Edit4.Caption<>'' then
      begin
       If not Edit20.enabled then form2.Edit20.Enabled:=true;
       If isfio then
        begin
           If not Combobox5.Enabled then form2.ComboBox5.Enabled:=true;
      If not Edit17.Enabled    then form2.Edit17.Enabled:=true;
      If not DateTimePicker4.Enabled then form2.DateTimePicker4.Enabled:=true;
      If not Combobox6.Enabled then form2.ComboBox6.Enabled:=true;
      If not Combobox9.Enabled then form2.ComboBox9.Enabled:=true;
      //If not Edit22.Enabled then form2.Edit22.Enabled:=true;
        end;
      end;
  If form2.Edit20.Caption<>'' then
   begin
       If Edit21.Enabled=false then form2.Edit21.enabled:=true;
   end;
 end;
end;

//найти данные водителя по фамилии
function TForm2.findVoditel(tfio:string; mode:byte):integer;
var
  strn,tdrv,ished:string;
  match:boolean;
begin
  result:=0;
  flseek:=true;
    form2.stringgrid1.RowCount:=0;
    ished:=full_mas[idx,1];
    //If utf8length(tfio)>6 then
     //tdrv:=utf8copy(tfio,1,6)
     //else
     //tdrv:=tfio;
    If utf8pos(#32,trim(tfio))>0 then
     tdrv:=utf8copy(trim(tfio),1,utf8pos(#32,tfio)-1)
     else
      tdrv:=trim(tfio);

    strn:='';
    If mode=1 then
     begin
       //If form2.Edit13.Focused then strn:=trim(form2.Edit2.Text);
       //If form2.Edit15.Focused then strn:=trim(form2.Edit3.Text);
       //If form2.Edit17.Focused then strn:=trim(form2.Edit4.Text);
       If tekedit=13 then strn:=trim(form2.Edit2.Text);
       If tekedit=15 then strn:=trim(form2.Edit3.Text);
       If tekedit=17 then strn:=trim(form2.Edit4.Text);
      end;

     If not(Connect2(form2.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'--k1');
     flseek:=false;
     exit;
    end;

  form2.ZReadOnlyQuery1.SQL.Clear;
  //form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver1,driver3,1 n from av_disp_oper where  ');
  //If isfio then
  //form2.ZReadOnlyQuery1.SQL.Add(' driver3<>'''' and ');
  //form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and current_date-date(createdate)<30 and driver1 like '+Quotedstr(tdrv+'%'));
  // If isfio then
  //form2.ZReadOnlyQuery1.SQL.Add(' order by driver3 desc');
  //form2.ZReadOnlyQuery1.SQL.Add(') union all ');
  //form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver2,driver4,2 n from av_disp_oper where  ');
  //If isfio then
  //form2.ZReadOnlyQuery1.SQL.Add(' driver4<>'''' and ');
  //form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and current_date-date(createdate)<30 and driver2 like '+Quotedstr(tdrv+'%'));
  //   If isfio then
  //form2.ZReadOnlyQuery1.SQL.Add(' order by driver4 desc');
  //form2.ZReadOnlyQuery1.SQL.Add(' ) ');

  match:=true;
  If mode=0 then
   begin
    If isfio then
     begin
    form2.ZReadOnlyQuery1.SQL.Add(' select distinct dd, doc, char_length(doc) from ( ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver1 dd, split_part(driver3,''@'',1) doc from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and createdate>(now() - interval ''30 days'') and driver1 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(') union all ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver2 dd, split_part(driver4,''@'',1) doc from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and current_date-date(createdate)<30 and driver2 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(' ) ) c ');
    form2.ZReadOnlyQuery1.SQL.Add(' order by char_length(doc) desc, dd; ');
     end;

    If not isfio then
    begin
    form2.ZReadOnlyQuery1.SQL.Add(' select distinct dd from ( ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver1 dd from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and current_date-date(createdate)<30 and driver1 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(') union all ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver2 dd from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and current_date-date(createdate)<30 and driver2 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(' ) ) c ');
    form2.ZReadOnlyQuery1.SQL.Add(' order by dd; ');
    end;
   end;

  If mode=1 then
   begin
   form2.ZReadOnlyQuery1.SQL.Add('select distinct doc,char_length(doc) from (  ');
   form2.ZReadOnlyQuery1.SQL.Add('(select distinct split_part(driver3,''@'',1) doc from av_disp_oper where  ');
  If strn<>'' then
  form2.ZReadOnlyQuery1.SQL.Add(' driver1 like '+Quotedstr(strn+'%')+' and ');
   form2.ZReadOnlyQuery1.SQL.Add(' current_date-date(createdate)<30 and driver3 like '+Quotedstr('%'+tdrv+'%'));
   form2.ZReadOnlyQuery1.SQL.Add(') union all ');
   form2.ZReadOnlyQuery1.SQL.Add('(select distinct split_part(driver4,''@'',1) doc from av_disp_oper where  ');
  If strn<>'' then
   form2.ZReadOnlyQuery1.SQL.Add(' driver2 like '+Quotedstr(strn+'%')+' and ');
   form2.ZReadOnlyQuery1.SQL.Add(' current_date-date(createdate)<30 and driver4 like '+Quotedstr('%'+tdrv+'%'));
   form2.ZReadOnlyQuery1.SQL.Add(' ) ) c ');
   form2.ZReadOnlyQuery1.SQL.Add(' order by char_length(doc) desc;');
  end;
  //showmessage(form2.ZReadOnlyQuery1.SQL.Text);//$
  try
      form2.ZReadOnlyQuery1.open;
  except
         showmessagealt('Ошибка запроса !'+#13+'ПОИСК ДАННЫХ ВОДИТЕЛЯ '+#13+'--err1');
         form2.ZReadOnlyQuery1.Close;
         form2.Zconnection1.disconnect;
         flseek:=false;
         exit;
  end;

  //ищем фамилию из более раннего периода
  If (form2.ZReadOnlyQuery1.RecordCount=0) and (mode=0) then
    begin
    If isfio then
     begin
    form2.ZReadOnlyQuery1.SQL.Add(' select distinct dd, doc, char_length(doc) from ( ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver1 dd, split_part(driver3,''@'',1) doc from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and driver1 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(') union all ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver2 dd, split_part(driver4,''@'',1) doc from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and driver2 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(' ) ) c ');
    form2.ZReadOnlyQuery1.SQL.Add(' order by char_length(doc) desc, dd; ');
     end;

    If not isfio then
    begin
    form2.ZReadOnlyQuery1.SQL.Add(' select distinct dd from ( ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver1 dd from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and driver1 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(') union all ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver2 dd from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule='+ished+' and driver2 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(' ) ) c ');
    form2.ZReadOnlyQuery1.SQL.Add(' order by dd; ');
    end;

      //showmessage(form2.ZReadOnlyQuery1.SQL.Text);//$
  try
      form2.ZReadOnlyQuery1.open;
  except
         showmessagealt('Ошибка запроса !!!'+#13+'ПОИСК ДАННЫХ ВОДИТЕЛЯ '+#13+'--err2');
         form2.ZReadOnlyQuery1.Close;
         form2.Zconnection1.disconnect;
         flseek:=false;
         exit;
  end;
   end;

If (form2.ZReadOnlyQuery1.RecordCount=0) and (mode=0) then
    begin
     match:=false;
      form2.ZReadOnlyQuery1.SQL.Clear;
    If isfio then
     begin
    form2.ZReadOnlyQuery1.SQL.Add(' select distinct dd, doc, char_length(doc) from ( ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver1 dd, split_part(driver3,''@'',1) doc from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule<>'+ished+' and createdate>(now() - interval ''30 days'') and driver1 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(') union all ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver2 dd, split_part(driver4,''@'',1) doc from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule<>'+ished+' and current_date-date(createdate)<30 and driver2 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(' ) ) c ');
    form2.ZReadOnlyQuery1.SQL.Add(' order by char_length(doc) desc, dd; ');
     end;

    If not isfio then
    begin
    form2.ZReadOnlyQuery1.SQL.Add(' select distinct dd from ( ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver1 dd from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule<>'+ished+' and current_date-date(createdate)<30 and driver1 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(') union all ');
    form2.ZReadOnlyQuery1.SQL.Add('(select distinct driver2 dd from av_disp_oper where  ');
    form2.ZReadOnlyQuery1.SQL.Add(' id_shedule<>'+ished+' and current_date-date(createdate)<30 and driver2 like '+Quotedstr(tdrv+'%'));
    form2.ZReadOnlyQuery1.SQL.Add(' ) ) c ');
    form2.ZReadOnlyQuery1.SQL.Add(' order by dd; ');
    end;
  //showmessage(form2.ZReadOnlyQuery1.SQL.Text);//$
  try
      form2.ZReadOnlyQuery1.open;
  except
         showmessagealt('Ошибка запроса !!!'+#13+'ПОИСК ДАННЫХ ВОДИТЕЛЯ '+#13+'--err3');
         form2.ZReadOnlyQuery1.Close;
         form2.Zconnection1.disconnect;
         flseek:=false;
         exit;
  end;
  end;

//если не нашли водителя на этом расписании, то ищем по всем
//If form2.ZReadOnlyQuery1.RecordCount=0 then
//    begin
//  form2.ZReadOnlyQuery1.SQL.Clear;
//  form2.ZReadOnlyQuery1.SQL.Add('select distinct driver1,driver3,5 n from av_disp_oper where ');
//  If isfio then
//  form2.ZReadOnlyQuery1.SQL.Add(' driver3<>'''' and ');
//  form2.ZReadOnlyQuery1.SQL.Add(' id_shedule<>'+ished+' and current_date-date(createdate)<30 and driver1 like '+Quotedstr(tdrv+'%'));
//  form2.ZReadOnlyQuery1.SQL.Add(' union all ');
//  form2.ZReadOnlyQuery1.SQL.Add('select distinct driver2,driver4,6 n from av_disp_oper where ');
//  If isfio then
//  form2.ZReadOnlyQuery1.SQL.Add(' driver4<>'''' and ');
//  form2.ZReadOnlyQuery1.SQL.Add(' id_shedule<>'+ished+' and current_date-date(createdate)<30 and driver2 like '+Quotedstr(tdrv+'%'));
//  //showmessage(form2.ZReadOnlyQuery1.SQL.Text);//$
//  try
//      form2.ZReadOnlyQuery1.open;
//  except
//         showmessagealt('Ошибка запроса !!!'+#13+'ПОИСК ДАННЫХ ВОДИТЕЛЯ --f2-3-');
//         form2.ZReadOnlyQuery1.Close;
//         form2.Zconnection1.disconnect;
//         flseek:=false;
//         exit;
//  end;
//  end;


//If form2.ZReadOnlyQuery1.RecordCount=0 then
 //begin
   //flseek:=false;
  //exit;
//end;
k:=0;

for n:=1 to form2.ZReadOnlyQuery1.RecordCount do
  begin
    inc(k);
    //showmessage(form2.ZReadOnlyQuery1.Fields[1].AsString);
    //showmessage(form2.ZReadOnlyQuery1.Fields[2].AsString);
    form2.stringgrid1.RowCount:=form2.stringgrid1.RowCount+1;
    form2.stringgrid1.Cells[0,form2.stringgrid1.RowCount-1]:=form2.ZReadOnlyQuery1.Fields[0].AsString;
    If isfio and (mode=0) then
      form2.stringgrid1.Cells[1,form2.stringgrid1.RowCount-1]:=form2.ZReadOnlyQuery1.Fields[1].AsString;
    form2.ZReadOnlyQuery1.Next;
  end;
  form2.ZReadOnlyQuery1.Close;
  form2.Zconnection1.disconnect;

   //inc(ggg);
   //form2.Label39.Caption:=inttostr(ggg);//$
   famildlina:=utf8length(tfio);
   If famildlina<(minstrsearch+1) then famildlina:=99;
   //form2.Label38.Caption:=inttostr(famildlina);//$
 //famildlina:=100;
//если точное совпадение, заполняем
If k=1 then
  begin
    decode_personal(tekedit,form2.stringgrid1.Cells[0,0]);
    If isfio and (mode=0) then
      begin
        If tekedit=2 then
          begin
           decode_personal(13,form2.stringgrid1.Cells[1,0]);
           If match then
             begin
               form2.ComboBox7.SetFocus;
               //form2.Edit14.SetFocus;
               //form2.Edit14.SelStart:=utf8length(form2.Edit14.text);
             end;
          end;
        If tekedit=3 then
          begin
          decode_personal(15,form2.stringgrid1.Cells[1,0]);
           If match then
             begin
              form2.ComboBox8.SetFocus;
          //form2.Edit16.SetFocus;
          //form2.Edit16.SelStart:=utf8length(form2.Edit16.text);
             end;
          end;
        If tekedit=4 then
          begin
          decode_personal(17,form2.stringgrid1.Cells[1,0]);
           If match then
             begin
               form2.ComboBox9.SetFocus;
          //form2.Edit22.SetFocus;
          //form2.Edit22.SelStart:=utf8length(form2.Edit22.text);
             end;
          end;
      end;

    openforedit();
    result:=1;
  end;
 flseek:=false;
//если варианты
If k>1 then
begin
 result:=2;
 end;
end;

//контекстный поиск
procedure TForm2.Edit2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  nfnd,dolen:integer;
begin
  //form2.Label38.Caption:=inttostr(famildlina);//$
   if not(Sender is TEdit) then exit;
   If (key<41) and (key<>32) then exit;
   IF flseek then exit;
   If notfindflag then exit;
   If TEdit(Sender).SelLength>0 then exit;
   dolen:=utf8length(TEdit(Sender).Text);
   If dolen<1 then exit;
   //If dolen>(famildlina+1) then
    //begin
      //showmessage('1');//&
    //exit;
    //end;
   // form2.Label39.Caption:='';
   // sleep(1);
   // end
   //else
   //form2.Label39.Caption:=form2.Label39.Caption+'+';
    If form2.stringgrid1.Visible then
     begin
       form2.stringgrid1.Visible:=false;
       form2.stringgrid1.RowCount:=0;
       form2.stringgrid1.Height:=1;
     end;

   nfnd:=0;
   If TEdit(Sender).Left<340 then
    begin
     If dolen<minstrsearch then
      begin
       //showmessage('1');//$
       exit;
      end;
    //режим поиска имени водилы
     nfnd:=findVoditel(trim(TEdit(Sender).Text),0);
     If n>1 then begin
    form2.stringgrid1.Width:=560;
    form2.stringgrid1.ColWidths[1]:=form2.stringgrid1.Width div 2 - 10;
    form2.stringgrid1.ColWidths[0]:=form2.stringgrid1.Width - form2.stringgrid1.ColWidths[1] - 5;
     end;
    end
   else
   begin
     //режим поиска документа
    nfnd:=findVoditel(trim(TEdit(Sender).Text),1);
      If n>1 then begin
    form2.stringgrid1.Width:=260;
    form2.stringgrid1.ColWidths[1]:=0;
    form2.stringgrid1.ColWidths[0]:=form2.stringgrid1.Width - 5;
      end;
   end;
   If nfnd=0 then exit;
   If nfnd=1 then
    begin
     TEdit(Sender).SelStart:=dolen;
     TEdit(Sender).SelLength:=utf8length(TEdit(Sender).Text)-dolen;
     exit;
    end;
   //form2.Label38.Caption:=inttostr(famildlina);//$

  //form2.stringgrid1.ColWidths[0]:=form2.stringgrid1.Width-5;
  //form2.stringgrid1.ColWidths[1]:=form2.stringgrid1.Width - form2.stringgrid1.ColWidths[0] -5;
  If (tekedit=2) or (tekedit=13) then
   begin
     form2.stringgrid1.Left:=form2.GroupBox1.Left+TEdit(Sender).Left;
     form2.stringgrid1.Top:=form2.GroupBox1.top+TEdit(Sender).Top+TEdit(Sender).Height+17;
   end;
   If (tekedit=3) or (tekedit=15) then
   begin
     form2.stringgrid1.Left:=form2.GroupBox2.Left+TEdit(Sender).Left;
     form2.stringgrid1.Top:=form2.GroupBox2.Top+TEdit(Sender).Top+TEdit(Sender).Height+17;
   end;
   If (tekedit=4) or (tekedit=17) then
   begin
     form2.stringgrid1.Left:=form2.GroupBox3.Left+TEdit(Sender).Left;
     form2.stringgrid1.Top:=form2.GroupBox3.Top+TEdit(Sender).Top+TEdit(Sender).Height+17;
   end;

  form2.stringgrid1.Height:=form2.stringgrid1.DefaultRowHeight*form2.stringgrid1.RowCount+5;
  If form2.stringgrid1.Height>300 then form2.stringgrid1.Height:=300;
  //If form2.stringgrid1.Items.Count<10 then
   //form2.stringgrid1.DropDownCount:=form2.stringgrid1.Items.Count;

  If not form2.stringgrid1.Visible then
   form2.stringgrid1.Visible:=true;
   form2.stringgrid1.Row:=0;
   form2.stringgrid1.SetFocus;

end;


procedure TForm2.AnyEditEnter(Sender: TObject);
begin
  if Sender is TEdit then
   begin
    TEdit(Sender).Color := clWhite;
    famildlina:=100;
    tekedit:=0;
   If TEdit(Sender).Name ='Edit2' then
    begin
     tekedit:=2;
     If isfio then
      begin
      form2.GroupBox1.Height:=150;
      form2.GroupBox2.Height:=65;
      form2.GroupBox3.Height:=65;
      end;
    end;
   If TEdit(Sender).Name='Edit13' then
    begin
     tekedit:=13;
    end;
    If TEdit(Sender).Name='Edit3' then
    begin
     tekedit:=3;
     If isfio then
      begin
      form2.GroupBox1.Height:=65;
      form2.GroupBox2.Height:=150;
      form2.GroupBox3.Height:=65;
      end;
    end;
    If TEdit(Sender).Name='Edit15' then
    begin
     tekedit:=15;
    end;
      If TEdit(Sender).Name='Edit4' then
    begin
     tekedit:=4;
     If isfio then
      begin
      form2.GroupBox1.Height:=65;
      form2.GroupBox2.Height:=65;
      form2.GroupBox3.Height:=150;
      end;
    end;
       If TEdit(Sender).Name='Edit17' then
    begin
     tekedit:=17;
    end;

    //form2.Label39.Caption:='0';//$
   end;
end;

procedure TForm2.AnyEditExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := clCream;
end;

//собрать данные водителей
function TForm2.encode_personal():boolean;
var
  k:integer;
  str,tmp:string;
begin
  result:=false;
  drv1:='';
  drv2:='';
  drv3:='';
  doc1:='';
  doc2:='';
  doc3:='';
  //водила 1
  If trim(Edit2.Caption)<>'' then
    If utf8pos(#32,Edit2.Caption)>0 then
      begin
        drv1:=utf8copy(Edit2.Caption,1,utf8pos(#32,Edit2.Caption)-1)+'|';
        form2.Edit11.Caption:=form2.Edit11.Caption+utf8copy(Edit2.Caption,utf8pos(#32,Edit2.Caption)+1,1);
      end
    else
        drv1:=Edit2.Caption+'|';
  If trim(Edit11.Caption)<>'' then drv1:=drv1+Edit11.Caption+'|';
  If trim(Edit12.Caption)<>'' then drv1:=drv1+Edit12.Caption;
 //водила 2
  If (trim(Edit3.Caption)<>'') and (trim(Edit2.Caption)<>'') then
    If utf8pos(#32,Edit3.Caption)>0 then
      begin
        drv2:=utf8copy(Edit3.Caption,1,utf8pos(#32,Edit3.Caption)-1)+'|';
        form2.Edit18.Caption:=form2.Edit18.Caption+utf8copy(Edit3.Caption,utf8pos(#32,Edit3.Caption)+1,1);
      end
    else
        drv2:=Edit3.Caption+'|';
  If trim(Edit18.Caption)<>'' then drv2:=drv2+Edit18.Caption+'|';
  If trim(Edit19.Caption)<>'' then drv2:=drv2+Edit19.Caption;

  //водила 3
  If (trim(Edit3.Caption)<>'') and (trim(Edit2.Caption)<>'') and (trim(Edit4.Caption)<>'') then
    If utf8pos(#32,Edit4.Caption)>0 then
      begin
        drv3:=utf8copy(Edit4.Caption,1,utf8pos(#32,Edit4.Caption)-1)+'|';
        form2.Edit20.Caption:=form2.Edit20.Caption+utf8copy(Edit4.Caption,utf8pos(#32,Edit4.Caption)+1,1);
      end
    else
        drv3:=Edit4.Caption+'|';
  If trim(Edit20.Caption)<>'' then drv3:=drv3+Edit20.Caption+'|';
  If trim(Edit21.Caption)<>'' then drv3:=drv3+Edit21.Caption;

//пол
    If form2.ComboBox2.ItemIndex=-1 then
     begin
     form2.ComboBox2.ItemIndex:=0;
     showmessagealt('Ошибка ! Не определен пол водителя №1 !'+#13+'--err3');//$
     end;
    If form2.ComboBox4.ItemIndex=-1 then
     begin
     form2.ComboBox4.ItemIndex:=0;
     showmessagealt('Ошибка ! Не определен пол водителя №2 !'+#13+'--err4');//$
     end;
    If form2.ComboBox6.ItemIndex=-1 then
     begin
      form2.ComboBox6.ItemIndex:=0;
     showmessagealt('Ошибка ! Не определен пол водителя №3 !'+#13+'--err5');//$
     end;
    //доки
    If (form2.ComboBox7.Text<>'') and (form2.ComboBox7.Items.IndexOf(form2.ComboBox7.Text)=-1) then
      form2.ComboBox7.ItemIndex:=0;
    If (form2.ComboBox8.Text<>'') and (form2.ComboBox8.Items.IndexOf(form2.ComboBox8.Text)=-1) then
      form2.ComboBox8.ItemIndex:=0;
    If (form2.ComboBox9.Text<>'') and (form2.ComboBox9.Items.IndexOf(form2.ComboBox9.Text)=-1) then
      form2.ComboBox9.ItemIndex:=0;


     If trim(Edit13.Caption)<>'' then
      doc1:=StringReplace(trim(Edit13.Caption),#32,'',[rfReplaceAll])+'|'+inttostr(form2.ComboBox1.ItemIndex)+'|'+
        formatdatetime('dd-mm-yyyy',form2.DateTimePicker2.Date)+'|'+form2.ComboBox7.Text+'|'+inttostr(form2.ComboBox2.ItemIndex);
     If trim(Edit15.Caption)<>'' then
      doc2:=StringReplace(trim(Edit15.Caption),#32,'',[rfReplaceAll])+'|'+inttostr(form2.ComboBox3.ItemIndex)+'|'+
        formatdatetime('dd-mm-yyyy',form2.DateTimePicker3.Date)+'|'+form2.ComboBox8.Text+'|'+inttostr(form2.ComboBox4.ItemIndex);
     If trim(Edit17.Caption)<>'' then
      doc3:=StringReplace(trim(Edit17.Caption),#32,'',[rfReplaceAll])+'|'+inttostr(form2.ComboBox5.ItemIndex)+'|'+
        formatdatetime('dd-mm-yyyy',form2.DateTimePicker4.Date)+'|'+form2.ComboBox9.Text+'|'+inttostr(form2.ComboBox6.ItemIndex);

  result:=true;
end;


//выяснить данные водителей
function TForm2.decode_personal(drv:integer;ptext:string):string;//заполнить поля по водителям
var
  k:integer;
  str,tmp:string;
begin
  result:='';
  If trim(ptext)='' then exit;
  str:=ptext;
  If utf8pos('|',str)=0 then
   begin
    If drv=2 then  Edit2.Caption:=str;
    If drv=3 then  Edit3.Caption:=str;
    If drv=13 then Edit13.Caption:=str;
    If drv=15 then Edit15.Caption:=str;
    If drv=4 then  Edit4.Caption:=str;
    If drv=17 then Edit17.Caption:=str;
    result:=str;
    exit;
   end;

  k:=0;
  while utf8pos('|',str)>0 do
   begin
     inc(k);
     tmp:=utf8copy(str,1,utf8pos('|',str)-1);
     str:=utf8copy(str,utf8pos('|',str)+1,utf8length(str)-utf8pos('|',str));
     //фамилия / документ
     If k=1 then
     begin
     If drv=2 then Edit2.Caption:=tmp;
     If drv=3 then Edit3.Caption:=tmp;
     If drv=13 then Edit13.Caption:=tmp;
     If drv=15 then Edit15.Caption:=tmp;
     If drv=4 then Edit4.Caption:=tmp;
     If drv=17 then Edit17.Caption:=tmp;
     end;
     // имя / тип документа
     If k=2 then
     begin
     If drv=2 then Edit11.Caption:=tmp;
     If drv=3 then Edit18.Caption:=tmp;
     If drv=4 then Edit20.Caption:=tmp;
     If drv=13 then
     begin
     try
       Combobox1.ItemIndex:=strtoint(tmp);
     except
          on exception: EConvertError do
            showmessagealt('Ошибка конвертации типа документа !'+#13+'--err6');
     end;
     end;
     If drv=15 then
     begin
     try
       Combobox3.ItemIndex:=strtoint(tmp);
     except
          on exception: EConvertError do
            showmessagealt('2.Ошибка конвертации типа документа !'+#13+'--err7');
     end;
     end;
       If drv=17 then
     begin
     try
       Combobox5.ItemIndex:=strtoint(tmp);
     except
          on exception: EConvertError do
            showmessagealt('3.Ошибка конвертации типа документа !'+#13+'--err8');
     end;
     end;
     end;
     // день рождения
     If k=3 then
     begin
        If drv=13 then
     begin
       try
        form2.DateTimePicker2.Date:=strtodate(tmp);
        except
          on exception: EConvertError do
            showmessagealt('4.Ошибка конвертации дня рождения !'+#13+'--err9');
       end;
     end;
        If drv=15 then
     begin
       try
        form2.DateTimePicker3.Date:=strtodate(tmp);
        except
          on exception: EConvertError do
            showmessagealt('5.Ошибка конвертации дня рождения !'+#13+'--err10');
       end;
     end;
       If drv=17 then
     begin
       try
        form2.DateTimePicker3.Date:=strtodate(tmp);
        except
          on exception: EConvertError do
            showmessagealt('6.Ошибка конвертации дня рождения !'+#13+'--err11');
       end;
     end;
     end;
     //гражданство
     If k=4 then
     begin
        If drv=13 then Combobox7.Text:=tmp;//Edit14.Caption:=tmp;
        If drv=15 then Combobox8.Text:=tmp;
        If drv=17 then Combobox9.Text:=tmp;
     end;
     //пол
     If k=5 then
     begin
      If tmp='-1' then
       begin
       showmessagealt('Ошибка! Не определен пол водителя '+inttostr(drv)+#13+'--err12');
       tmp:='0';
       end;
       If drv=13 then
     begin
     try
       Combobox2.ItemIndex:=strtoint(tmp);
     except
          on exception: EConvertError do
            showmessagealt('7.Ошибка конвертации пола !'+#13+'--err13');
     end;
     end;
       If drv=15 then
     begin
     try
       Combobox4.ItemIndex:=strtoint(tmp);
     except
          on exception: EConvertError do
            showmessagealt('8.Ошибка конвертации пола !'+#13+'--err14');
     end;
     end;
       If drv=17 then
     begin
     try
       Combobox6.ItemIndex:=strtoint(tmp);
     except
          on exception: EConvertError do
            showmessagealt('9.Ошибка конвертации пола !'+#13+'--err15');
     end;
     end;
    end;
   end;
 result:='1';
  //Ф.И.О.
     If k=1 then
     begin
     //имя
        If drv=2 then Edit11.Caption:=str;
        If drv=3 then Edit18.Caption:=str;
        If drv=4 then Edit20.Caption:=str;
      //тип документа
       If drv=13 then
     begin
     try
       Combobox1.ItemIndex:=strtoint(str);
     except
          on exception: EConvertError do
            showmessagealt('10.Ошибка конвертации типа документа !'+#13+'--err16');
     end;
     end;
     If drv=15 then
     begin
     try
       Combobox3.ItemIndex:=strtoint(str);
     except
          on exception: EConvertError do
            showmessagealt('11.Ошибка конвертации типа документа !'+#13+'--err17');
     end;
     end;
       If drv=17 then
     begin
      try
       Combobox3.ItemIndex:=strtoint(str);
      except
          on exception: EConvertError do
            showmessagealt('12.Ошибка конвертации типа документа !'+#13+'--err18');
      end;
     end;
     end;

     If k=2 then
     begin
       //отчество
        If drv=2 then Edit12.Caption:=str;
        If drv=3 then Edit19.Caption:=str;
        If drv=4 then Edit21.Caption:=str;
      // день рождения
        If drv=13 then
     begin
       try
        form2.DateTimePicker2.Date:=strtodate(str);
        except
          on exception: EConvertError do
            showmessagealt('13.Ошибка конвертации дня рождения !'+#13+'--err19');
       end;
     end;
       If drv=15 then
     begin
       try
        form2.DateTimePicker3.Date:=strtodate(str);
        except
          on exception: EConvertError do
            showmessagealt('14.Ошибка конвертации дня рождения !'+#13+'--err20');
       end;
     end;
      If drv=17 then
     begin
       try
        form2.DateTimePicker3.Date:=strtodate(str);
        except
          on exception: EConvertError do
            showmessagealt('15.Ошибка конвертации дня рождения !'+#13+'--err21');
       end;
     end;
     end;
     //гражданство
     If k=3 then
     begin
        If drv=13 then Combobox7.Text:=str;//Edit14.Caption:=str;
        If drv=15 then Combobox8.Text:=str;
        If drv=17 then Combobox9.Text:=str;
     end;
     //пол
     If k=4 then
     begin
         If drv=13 then
     begin
     try
       Combobox2.ItemIndex:=strtoint(str);
     except
          on exception: EConvertError do
            showmessagealt('16.Ошибка конвертации пола !'+#13+'--err22');
     end;
     end;
       If drv=15 then
     begin
     try
       Combobox4.ItemIndex:=strtoint(str);
     except
          on exception: EConvertError do
            showmessagealt('17.Ошибка конвертации пола !'+#13+'--err23');
     end;
     end;
        If drv=17 then
     begin
     try
       Combobox6.ItemIndex:=strtoint(str);
     except
          on exception: EConvertError do
            showmessagealt('18.Ошибка конвертации пола !'+#13+'--err24');
     end;
     end;
    end;

end;

// проверка, что расписание в перечне по передаче данных
function TForm2.checkinfio():boolean;
begin
 result:=false;
 //если заказной - не надо
 //if (trim(full_mas[idx,0])='2') or (trim(full_mas[idx,0])='3') or (trim(full_mas[idx,0])='4') or (trim(full_mas[idx,0])='5') then exit;
 //If full_mas[idx,9]='0' then exit;

  If not(Connect2(form2.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'--k2');
     form2.close;
    end;

  form2.ZReadOnlyQuery1.SQL.Clear;
  form2.ZReadOnlyQuery1.SQL.Add('Select 1 from av_shedule_fio where del=0 and id_shedule='+full_mas[idx,1]+';');

  //showmessage(form2.ZReadOnlyQuery1.SQL.Text);//$
  try
      form2.ZReadOnlyQuery1.open;
  except
         showmessagealt('Нет данных по расписанию !!!'+#13+'Сообщите об этом АДМИНИСТРАТОРУ !!!'+#13+'--err23');
         form2.ZReadOnlyQuery1.Close;
         form2.Zconnection1.disconnect;
         form2.Close;
  end;

   If form2.ZReadOnlyQuery1.RecordCount>0 then
    begin
      //form2.Label44.Caption:='документ:';
      //form2.Label45.Caption:='Водитель №2 ф.и.о:';
      //form2.Label46.Caption:='документ:';
      //form2.Edit4.Top:=372;
      //form2.Edit3.Top:=407;
      result:=true;
    end;

  form2.ZReadOnlyQuery1.Close;
  form2.Zconnection1.disconnect;

end;


//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&  ПЕЧАТЬ АКТА   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
procedure TForm2.print_akt();
const
  bold=#027#040#115#051#066; //жирный
  norm=#027#040#115#048#066; //нежирный
  under=#027#038#100#048#068;//подчернкутый
  plain=#027#038#100#064;//не подчеркнутый
 // #027#040#115+'15'+#072 включение режима сжатой печати
 // #027#040#115+'12'+#072 выключение режима сжатой печати
  maxticksL=46; //маскимальное число билетов на листе лазерн
  maxticksM=42; //маскимальное число билетов на листе матричн
 var
   buf_LPT:TextFile;
   prn,filev: String;
begin
   prn := '/dev/lp0';
   AssignFile(buf_lpt,prn);
// Загружаем файл
   {$I-} // отключение контроля ошибок ввода-вывода
 Rewrite(buf_lpt);
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then
    begin
     showmessagealt('Локальный принтер не подключен !!!'+#13+'Проверьте физическое подключение принтера ...'+#13+'--k3');
     exit;
    end;

 with Form2 do
   begin
     If not encode_personal() then
       begin
          showmessagealt('Некорректные данные по водителям !!!'+#13+'--err24');
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
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автотранспортное предприятие')+StringofChar(#32,3)+under+PadC(UTF8ToCP866(kontr_name),#32,30)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование АТП, ИП)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автобус для работы на маршруте')+StringofChar(#32,1));
  write(buf_lpt,under+PadC(UTF8ToCP866('№'+full_mas[idx,15]+#32+full_mas[idx,5]+' - '+full_mas[idx,8]),#32,34)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование маршрута)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Марка автобуса')+StringofChar(#32,8)+under+PadC(UTF8ToCP866(real_avto),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование марки транспортного средства)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Гос.регистрац. номер')+StringofChar(#32,2)+under+PadC(UTF8ToCP866(real_reg_sign),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(серия и номер транспортного средства)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Путевой лист')+StringofChar(#32,10)+under+PadC(UTF8ToCP866(form2.Edit6.text),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(реквизиты путевого листа, дата, номер)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Ведомость')+StringofChar(#32,13)+under+PadC(UTF8ToCP866(vedom_num+'  от '+FormatDateTime('dd.mm.yyyy',work_date)),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(реквизиты ведомости, номер, дата)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Время отправления')+StringofChar(#32,5)+under+PadC(UTF8ToCP866(full_mas[idx,10]),#32,40)+plain+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,10)+#027#040#115+'9'+#072+bold+UTF8ToCP866('За обслуживание маршрута незаявленным транспортным средством')+#13#10);
  write(buf_lpt,StringofChar(#32,7)+bold+UTF8ToCP866('взыскивается '+under+PadC('500',#32,20)+plain+' руб.')+norm+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Начальник АВ')+StringofChar(#32,1)+under+StringofChar(#32,50)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072+#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Диспетчер')+StringofChar(#32,4)+under+PadL(UTF8ToCP866(name_user_active),#32,50)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072+#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Водитель')+StringofChar(#32,5)+under+PadL(UTF8ToCP866(drv1),#32,50)+plain+#13#10);
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
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автотранспортное предприятие')+StringofChar(#32,3)+under+PadC(UTF8ToCP866(kontr_name),#32,30)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование АТП, ИП)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автобус для работы на маршруте')+StringofChar(#32,1));
  write(buf_lpt,under+PadC(UTF8ToCP866('№'+full_mas[idx,15]+#32+full_mas[idx,5]+' - '+full_mas[idx,8]),#32,34)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование маршрута)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Марка автобуса')+StringofChar(#32,8)+under+PadC(UTF8ToCP866(real_avto),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(наименование марки транспортного средства)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Гос.регистрац. номер')+StringofChar(#32,2)+under+PadC(UTF8ToCP866(real_reg_sign),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(серия и номер транспортного средства)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Путевой лист')+StringofChar(#32,10)+under+PadC(UTF8ToCP866(form2.Edit6.text),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(реквизиты путевого листа, дата, номер)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Ведомость')+StringofChar(#32,13)+under+PadC(UTF8ToCP866(vedom_num+'  от '+FormatDateTime('dd.mm.yyyy',work_date)),#32,40)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(реквизиты ведомости, номер, дата)')+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Время отправления')+StringofChar(#32,5)+under+PadC(UTF8ToCP866(full_mas[idx,10]),#32,40)+plain+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,10)+#027#040#115+'9'+#072+bold+UTF8ToCP866('За обслуживание маршрута незаявленным транспортным средством')+#13#10);
  write(buf_lpt,StringofChar(#32,7)+bold+UTF8ToCP866('взыскивается '+under+PadC('500',#32,20)+plain+' руб.')+norm+#027#040#115+'10'+#072+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Начальник АВ')+StringofChar(#32,1)+under+StringofChar(#32,50)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072+#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Диспетчер')+StringofChar(#32,4)+under+PadL(UTF8ToCP866(name_user_active),#32,50)+plain+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072+#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Водитель')+StringofChar(#32,5)+under+PadL(UTF8ToCP866(drv1),#32,50)+plain+#13#10);
  //write(buf_lpt,StringofChar(#32,33)+#027#040#115+'13'+#072+UTF8ToCP866('(подпись, ФИО)')+#027#040#115+'10'+#072);
  write(buf_lpt,#027#038#108#048#072);//выброс листа
   end;

    //если опция печати на матричный принтер
  If printer_vid=2 then
    begin
   //  #18               отменить сжатый текст
  //  #27#77    установить шрифт 12 p/i
  //  #27#80    установить шрифт 10 p/i
  //  #27#65#12 , межстрочный интервал = n/7

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
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автотранспортное предприятие')+StringofChar(#32,3)+#27#45#49+PadC(UTF8ToCP866(kontr_name),#32,42)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#15+UTF8ToCP866('(наименование АТП, ИП)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автобус для работы на маршруте')+StringofChar(#32,1));
  write(buf_lpt,#27#45#49+PadC(UTF8ToCP866('№'+full_mas[idx,15]+#32+full_mas[idx,5]+' - '+full_mas[idx,8]),#32,36)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#15+UTF8ToCP866('(наименование маршрута)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Марка автобуса')+StringofChar(#32,8)+#27#45#49+PadC(UTF8ToCP866(real_avto),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(наименование марки транспортного средства)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Гос.регистрац. номер')+StringofChar(#32,2)+#27#45#49+PadC(UTF8ToCP866(real_reg_sign),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(серия и номер транспортного средства)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Путевой лист')+StringofChar(#32,10)+#27#45#49+PadC(UTF8ToCP866(form2.Edit6.text),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(реквизиты путевого листа, дата, номер)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Ведомость')+StringofChar(#32,13)+#27#45#49+PadC(UTF8ToCP866(form1.Get_num_vedom(idx) +'  от '+FormatDateTime('dd.mm.yyyy',work_date)),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#15+UTF8ToCP866('(реквизиты ведомости, номер, дата)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Время отправления')+StringofChar(#32,5)+#27#45#49+PadC(UTF8ToCP866(full_mas[idx,10]),#32,40)+#27#45#48+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,10)+#27#80+#27#69+UTF8ToCP866('За обслуживание маршрута незаявленным транспортным средством')+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,6)+UTF8ToCP866('взыскивается '+#27#45#49+PadC('500',#32,20)+#27#45#48+' руб.')+#27#70+#13#10#13#10);
  write(buf_lpt,#27#77+StringofChar(#32,8)+UTF8ToCP866('Начальник АВ')+StringofChar(#32,1)+#27#45#49+StringofChar(#32,62)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Диспетчер')+StringofChar(#32,2)+#27#45#49+PadL(UTF8ToCP866(name_user_active),#32,65)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Водитель')+StringofChar(#32,3)+#27#45#49+PadL(UTF8ToCP866(drv1),#32,65)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10#13#10);

  write(buf_lpt,#13#10);//пустая строка

    write(buf_lpt,StringofChar(#32,30)+#27#80+#27#69+UTF8ToCP866('Акт за обслуживание маршрута')+#13#10);
  write(buf_lpt,StringofChar(#32,20)+UTF8ToCP866('незаявленным транспортным средством')+#27#70+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+#27#77+#27#45#49+PadC(UTF8ToCP866(server_name),#32,30)+#27#45#48);//сервер продажи и печать подчеркнутого текста
  write(buf_lpt,StringofChar(#32,20));//
  write(buf_lpt,#27#45#49+PadC(UTF8ToCP866(FormatDateTime('dd.mm.yyyy hh:nn',now())),#32,20)+#27#45#48+#13#10);//дата  перевод строки и возврат каретки;   //дата
  write(buf_lpt,StringofChar(#32,16)+#27#15+UTF8ToCP866('(наименование линейного сооружения)')+StringofChar(#32,54)+UTF8ToCP866('(дата,время)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автотранспортное предприятие')+StringofChar(#32,3)+#27#45#49+PadC(UTF8ToCP866(kontr_name),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#27#15+UTF8ToCP866('(наименование АТП, ИП)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Автобус для работы на маршруте')+StringofChar(#32,1));
  write(buf_lpt,#27#45#49+PadC(UTF8ToCP866('№'+full_mas[idx,15]+#32+full_mas[idx,5]+' - '+full_mas[idx,8]),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,45)+#27#15+UTF8ToCP866('(наименование маршрута)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Марка автобуса')+StringofChar(#32,8)+#27#45#49+PadC(UTF8ToCP866(real_avto),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#27#15+UTF8ToCP866('(наименование марки транспортного средства)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Гос.регистрац. номер')+StringofChar(#32,2)+#27#45#49+PadC(UTF8ToCP866(real_reg_sign),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#27#15+UTF8ToCP866('(серия и номер транспортного средства)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Путевой лист')+StringofChar(#32,10)+#27#45#49+PadC(UTF8ToCP866(form2.Edit6.text),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#27#15+UTF8ToCP866('(реквизиты путевого листа, дата, номер)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Ведомость')+StringofChar(#32,13)+#27#45#49+PadC(UTF8ToCP866(form1.Get_num_vedom(idx) +'  от '+FormatDateTime('dd.mm.yyyy',work_date)),#32,40)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,33)+#27#15+UTF8ToCP866('(реквизиты ведомости, номер, дата)')+#18#13#10#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Время отправления')+StringofChar(#32,5)+#27#45#49+PadC(UTF8ToCP866(full_mas[idx,10]),#32,40)+#27#45#48+#13#10#13#10);
  write(buf_lpt,StringofChar(#32,10)+#27#80+#27#69+UTF8ToCP866('За обслуживание маршрута незаявленным транспортным средством')+#13#10);
  write(buf_lpt,StringofChar(#32,6)+UTF8ToCP866('взыскивается '+#27#45#49+PadC('500',#32,20)+#27#45#48+' руб.')+#27#70+#13#10#13#10);
  write(buf_lpt,#27#77+StringofChar(#32,8)+UTF8ToCP866('Начальник АВ')+StringofChar(#32,1)+#27#45#49+StringofChar(#32,62)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#27#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Диспетчер')+StringofChar(#32,2)+#27#45#49+PadL(UTF8ToCP866(name_user_active),#32,65)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#27#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10);
  write(buf_lpt,StringofChar(#32,8)+UTF8ToCP866('Водитель')+StringofChar(#32,3)+#27#45#49+PadL(UTF8ToCP866(drv1),#32,65)+#27#45#48+#13#10);
  write(buf_lpt,StringofChar(#32,40)+#27#15+UTF8ToCP866('(подпись, ФИО)')+#18#13#10);

  write(buf_lpt,#12#13#10);//выброс листа
   end;

  CloseFile(buf_lpt);
   end;
end;


procedure TForm2.getz_date();
var
  n:integer;
  ztime: string;
  match:boolean;
begin
 If zkaz then
  begin
  k:=k+1;
  ztime:=formatdatetime('hh:nn',form2.DateTimePicker1.Time);
  //showmessage(inttostr(k));
//нельзя создать заказной рейс на сегодня с временем отправления, которое уже прошло сегодня
  if (strtotime(ztime)<=time) and (strtodate(tripdate)=date) and (days_before<5) then
    begin
       //showmessagealt('На сегодня невозможно создать рейс с данным временем !');
       ztime:=formatdatetime('hh:nn',time);
    end;
  //нельзя создать заказной рейс на одно время с таким же номером рейса
  while not(ztime='23:59') do
   begin
     match:=false;
    for n:=low(full_mas) to high(full_mas) do
      begin
        If not (full_mas[idx,2]=full_mas[n,2]) then continue;
        If (zTime=full_mas[n,10]) then
         begin
          match:=true;
          break;
         end;
        If (zTime=full_mas[n,12]) then
         begin
          match:=true;
          break;
         end;
      end;
    If not match then break;
    //showmessagealt('В выбранное время уже существует рейс для этого расписания !');
    zTime:=formatdatetime('hh:nn',strtotime(zTime)+strtotime('00:01'));
   end;

   form2.DateTimePicker1.Time:=strtotime(ztime);
   form2.DateTimePicker1.Refresh;
  end;
end;

//контекстный поиск атс
procedure TForm2.ats_search(ind:integer);
var
  n:integer;
begin
 if UTF8Length(trim(form2.Edit8.Text))=0 then
    begin
       //showmessage(form2.Edit8.Text);
      //form3.fill_grid('0','');
      form2.Edit8.Visible:=false;
      exit;
     end;
    //if (trim(form2.Edit8.Text)[1] in ['0'..'9']) then
             //begin
               // ищем номер атс
              for n:=ind to length(tmp_ats)-1 do
               begin
             if trim(tmp_ats[n,0])=trim(tmp_atp[tek_mas_atp,0]) then
                 begin
                   If utf8pos(trim(form2.Edit8.Text),tmp_ats[n,3])>0 then
                     begin
                   tek_mas_ats:=n;
                   fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
                   form2.Edit7.SelStart:=0;
                   form2.Edit7.SelLength:=utf8length(form2.Edit7.Text);
                   break;
                     end;
                 end;
              end;
             //end
           //else
           //  begin
           //    // ищем имя атс
           //   for n:=ind to length(tmp_ats)-1 do
           //    begin
           //  if trim(tmp_ats[n,0])=trim(tmp_atp[tek_mas_atp,0]) then
           //      begin
           //        If utf8pos(upperall(trim(form2.Edit8.Text)),tmp_ats[n,2])>0 then
           //          begin
           //        tek_mas_ats:=n;
           //        fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
           //        form2.Edit7.SelStart:=0;
           //        form2.Edit7.SelLength:=utf8length(form2.Edit7.Text);
           //        break;
           //          end;
           //      end;
           //   end;
           //  end;
           //

end;


//********** записать операции в базу по связанным рейсам ******************
procedure TForm2.write_oper();
var
  d_time,d_point,d_order:string;
  n,m,tn,tm,nt,tindex:integer;
begin
  setlength(megamas,0);
   //если рейс не регулярный, то выход
   If (full_mas[idx,0]<>'1') and (full_mas[idx,0]<>'3') then exit;
  //ищем по всему массиву
      for n:=low(full_mas) to high(full_mas) do
      begin
         If full_mas[n,1]<>full_mas[idx,1] then continue;
         If n=idx then continue;
          //если связанный рейс закрыт, пропускаем
                   If full_mas[n,28]='2' then continue;
                   If full_mas[n,28]='4' then continue;
                   If full_mas[n,28]='5' then continue;
                   If full_mas[n,28]='6' then continue;
       //если рейс отправления
                      If
                         (full_mas[n,1]=full_mas[idx,1]) AND
                         (full_mas[n,16]=full_mas[idx,16]) AND
                          (full_mas[n,10]=full_mas[idx,10]) AND
                          (full_mas[n,3]=full_mas[idx,3]) AND
                          (full_mas[n,4]=full_mas[idx,4]) AND
                           (full_mas[n,12]=full_mas[idx,12]) AND
                           (full_mas[n,6]=full_mas[idx,6]) AND
                           (full_mas[n,7]=full_mas[idx,7])
                         then
                             begin
                               //добавить рейс в массив
                               setlength(megamas,length(megamas)+1);
                               megamas[length(megamas)-1]:=n;
                               continue;
                             end;
         //showmessage(full_mas[n,1]+full_mas[n,19]+full_mas[n,21]);

                  //если рейс не регулярный, то связанные рейсы пропускаем
                   If (full_mas[n,0]<>'1') and (full_mas[n,0]<>'3') then continue;
              //корректируем связанные рейсы
                 tn :=0; //время отправления/прибытия в массиве
                 tm :=0; //время отправления/прибытия в операции
                 //если рейс отправления
                   If (full_mas[n,16]='1') then
                     begin
                       try
                         tn:= strtoint(copy(full_mas[n,10],1,2)+copy(full_mas[n,10],4,2));
                       except
                         on exception: EConvertError do continue;
                       end;
                     end;
                  //если рейс прибытия
                   If (full_mas[n,16]='2') then
                     begin
                       try
                         tn:= strtoint(copy(full_mas[n,12],1,2)+copy(full_mas[n,12],4,2));
                       except
                         on exception: EConvertError do continue;
                       end;
                      end;
                try
                   tm:= strtoint(copy(up_time,1,2)+copy(up_time,4,2));
                except
                   on exception: EConvertError do continue;
                end;
                 //если время отправления/прибытия больше, чем в операции
               If (tn>tm) AND (tn>0) AND (tm>0) then
                begin
                 //добавить рейс в массив
                 setlength(megamas,length(megamas)+1);
                 megamas[length(megamas)-1]:=n;
                end;
                //end;
      end;


 for nt:=0 to length(megamas)-1 do
 begin
   //!!!!!!!! если хотим добавлять записи для других рейсов по этому расписанию то заремарить следующую строку !!!!!!!!!!!!!!!!!!
  //If nt=1 then exit;
 If full_mas[megamas[nt],16]='1' then
    begin
      d_time := full_mas[megamas[nt],10];
      d_point:= full_mas[megamas[nt],3];
      d_order:= full_mas[megamas[nt],4];
    end
  else
  begin
    d_time := full_mas[megamas[nt],12];
    d_point:= full_mas[megamas[nt],6];
    d_order:= full_mas[megamas[nt],7];
  end;
  idx:= masindex;
  //временно заменяем текущий индекс массива
  masindex:=megamas[nt];
 //открываем транзакцию
  formmenu.insert_oper(form2.ZConnection1,form2.ZReadOnlyQuery1,form2.ZReadOnlyQuery2,1);
  //если операция сброшена (кто-то держит или ошибки в транзакции), то - отвал
  //если транзакция отменена (кто-то держит или нет записей для блокировки), то - отвал
   //showmessage('1'+#13+form2.ZReadOnlyQuery1.SQL.text);//$
   //showmessage('2'+#13+form2.ZReadOnlyQuery2.SQL.text);//$
  //возвращаем прежнее значение индекса
  masindex:=idx;
  If operation=0 then exit;
  If not form2.ZConnection1.Connected then
   begin
     showmessagealt('ОШИБКА ВЫПОЛНЕНИЯ ТРАНЗАКЦИИ !'+#13+'--err25');
    exit;
    end;
     with FORM2 do
      begin
      ZReadOnlyQuery1.sql.Clear;
      ZReadOnlyQuery1.SQL.add('Update av_disp_oper SET del=1 WHERE del=0 ');//AND id_point_oper='+ConnectINI[14]);
      ZReadOnlyQuery1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[megamas[nt],16]);
      ZReadOnlyQuery1.SQL.add(' AND id_shedule='+full_mas[megamas[nt],1]+' AND trip_time='+QuotedStr(d_time)+' AND trip_id_point='+d_point);
      ZReadOnlyQuery1.SQL.add(' AND point_order='+d_order+';');
try
  ZReadOnlyQuery1.ExecSql;
except
   If ZConnection1.InTransaction then Zconnection1.Rollback;
   ZConnection1.disconnect;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !'+#13+'--err26'
     //+#13+'Запрос SQL1: '+ZReadOnlyQuery1.SQL.Text
     +#13+'Запрос SQL2: '+ZReadOnlyQuery2.SQL.Text);
     exit;
end;
   //записать операцию
   //ZReadOnlyQuery2.SQL.clear;
   //ZReadOnlyQuery2.SQL.add('INSERT INTO av_disp_oper(id_user,createdate,del,id_point_oper,id_shedule,trip_type,trip_id_point,point_order,');
   //ZReadOnlyQuery2.SQL.add('trip_date,trip_time,id_oper,platform,zakaz,trip_flag,');
   //ZReadOnlyQuery2.SQL.add('atp_id,atp_name,avto_id,avto_name,avto_seats,avto_type,');
   //ZReadOnlyQuery2.SQL.add('putevka,driver1,driver2,driver3,driver4,vid_sriva,remark) VALUES (');
   //ZReadOnlyQuery2.SQL.add(inttostr(id_user)+',now(),0,'+ConnectINI[14]+','+full_mas[megamas[nt],1]+','+full_mas[megamas[nt],16]+','+d_point+','+d_order+',');
   //ZReadOnlyQuery2.SQL.add(Quotedstr(tripdate)+','+QuotedStr(d_time)+','+'0'+','+full_mas[megamas[nt],2]+','+full_mas[megamas[nt],0]+','+full_mas[megamas[nt],28]+',');
   ZReadOnlyQuery2.SQL.add('0'+','+full_mas[megamas[nt],2]+','+full_mas[megamas[nt],0]+','+full_mas[megamas[nt],28]+',');
   ZReadOnlyQuery2.SQL.Add(kontr_id+','+QuotedStr(kontr_name)+','+ats_id+',');
   ZReadOnlyQuery2.SQL.Add(quotedstr(ats_name+' ГН:'+ats_gos)+','+ats_mest+',');
   ZReadOnlyQuery2.SQL.Add(ats_type+','+QuotedStr(Edit6.text)+',');
   ZReadOnlyQuery2.SQL.Add(QuotedStr(drv1)+','+QuotedStr(drv2)+',');
   If drv3<>'' then
    begin
     ZReadOnlyQuery2.SQL.Add(QuotedStr(doc1+'@'+drv3));
     If doc3<>'' then ZReadOnlyQuery2.SQL.Add(QuotedStr('&'+doc3));
    end
   else ZReadOnlyQuery2.SQL.Add(QuotedStr(doc1));
   ZReadOnlyQuery2.SQL.Add(','+QuotedStr(doc2)+',');
   ZReadOnlyQuery2.SQL.add('0,'+QuotedStr(full_mas[megamas[nt],33])+');');

try
  ZReadOnlyQuery2.ExecSql;
  ZConnection1.Commit;
except
    If ZConnection1.InTransaction then Zconnection1.Rollback;
    ZConnection1.disconnect;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !'+#13+'--err27'
     //+#13+'Запрос SQL1: '+ZReadOnlyQuery1.SQL.Text
     +#13+'Запрос SQL2: '+ZReadOnlyQuery2.SQL.Text);
     exit;
end;
  ZReadOnlyQuery1.Close;
  ZReadOnlyQuery2.Close;
  ZConnection1.disconnect;
end;
 end;
end;


//заполнение переменных и поля перевозчика
procedure TForm2.fill_atp(num:byte);
begin
         kontr_id:= trim(tmp_atp[tek_mas_atp,0]);
         kontr_name:= trim(tmp_atp[tek_mas_atp,1]);
         form2.Edit1.Text:= kontr_name;
         form2.Label4.Caption:=tmp_atp[tek_mas_atp,2];//всего атс перевозчика
         form2.SpinEdit1.Value:=tek_mas_atp+1;//текущий перевозчик
end;

//заполнение переменных и поля АТС
procedure TForm2.fill_ats(num:byte);
begin
  try
  form2.SpinEdit2.Value:=strtoint(tmp_ats[num,6]);
  except
  exit;
  end;
 ats_id:= tmp_ats[num,1];
 ats_name:= trim(tmp_ats[num,2]);
 If utf8pos('ГН:',ats_name)>0 then
 ats_name:=utf8copy(ats_name,1,utf8pos('ГН:',ats_name)-1);
 ats_gos:= utf8copy(ats_name,utf8pos('ГН:',ats_name)+3,utf8length(ats_name)-utf8pos('ГН:',ats_name)-3);
 ats_gos := stringreplace(trim(tmp_ats[num,3]),#32,'',[rfReplaceAll, rfIgnoreCase]);
 ats_mest := (tmp_ats[num,4]);
 ats_type := (tmp_ats[num,5]);
 form2.edit7.Text:='['+IFTHEN(ats_type='1','M2','M3')+'] '+ ats_name+' ГН:'+ ats_gos;
 form2.Label48.Caption:=ats_mest;
end;


//создание ведомости для данного рейса
function TForm2.Vedom_Make(ZCon:TZConnection;ZQ1:TZReadOnlyQuery;nx:integer):boolean;
var
  time_fact,mode:string;
  typev:integer;
begin
  result:=false;
  vedom_num:='';
  //тип ведомости
   //mode=1 основная
   //mode=2 дообилечивания
   //mode=3 основная заказная
   //mode=4 дообилечивания заказная
   //mode=5 удаленка
   //mode=6 удаленка заказная
   mode:='0';
   try
    typev:=strtoint(full_mas[nx,0]);
   except
    typev:=0;
   end;
   //если удаленка
   If typev>2 then typev:=typev+2;
   //если регулярная ведомость
   If typev<3 then
   begin
   //если дообилечивание
   If (full_mas[nx,28]='1') then
    typev:=typev+1;
   end;
   mode:=inttostr(typev);

  //время отправления фактическое
   time_fact := 'lpad(date_part(''hour'',now())::text,2,''0'') || '':'' || lpad(date_part(''minute'',now())::text,2,''0'')';
 ////Вычисляем номер ведомости
  vedom_num:= form1.Get_num_vedom(nx);
  ZQ1.SQL.Clear;
  ZQ1.SQL.Add('INSERT INTO av_disp_vedom(vedom,date_trip,t_o,id_shedule,ot_order,do_order,ot_id_point,');
  ZQ1.SQL.Add('do_id_point,vedomtype,id_point_oper,id_user,createdate,del,');
  ZQ1.SQL.Add('t_o_fact, doobil, ot_name, do_name,');
  ZQ1.SQL.Add('kontr_id, kontr_name, ats_id, ats_name, ats_reg, ats_seats,');
  ZQ1.SQL.Add('ats_type,putevka,driver1,driver2,driver3,driver4) VALUES (');
  ZQ1.SQL.Add(Quotedstr(vedom_num)+','+Quotedstr(tripdate)+','+QuotedStr(full_mas[nx,10])+','+full_mas[nx,1]+','+full_mas[nx,4]+','+full_mas[nx,7]+','+full_mas[nx,3]+',');
  ZQ1.SQL.Add(full_mas[nx,6]+','+mode+','+ConnectINI[14]+','+inttostr(id_user)+',now()+''2 seconds'',0,');
  ZQ1.SQL.Add(time_fact+','+full_mas[nx,29]+','+QuotedStr(full_mas[nx,5])+','+QuotedStr(full_mas[nx,8])+',');
  ZQ1.SQL.Add(kontr_id+','+QuotedStr(kontr_name)+','+ats_id+',');
  ZQ1.SQL.Add(quotedstr(ats_name)+','+quotedstr(ats_gos)+','+ats_mest+',');
  ZQ1.SQL.Add(ats_type+','+QuotedStr(Edit6.text)+','+QuotedStr(drv1)+','+QuotedStr(drv2)+',');
    If drv3<>'' then
    begin
     ZQ1.SQL.Add(QuotedStr(doc1+'@'+drv3));
     If doc3<>'' then ZQ1.SQL.Add(QuotedStr('&'+doc3));
    end
    else
       ZQ1.SQL.Add(QuotedStr(doc1));
   ZQ1.SQL.Add(','+QuotedStr(doc2)+');');
  //ZQ1.SQL.Add();
  //showmessage(ZQ1.SQL.text);//$
   try
     ZQ1.open;
   except
     showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZQ1.SQL.Text);
     exit;
   end;
  ZQ1.Close;
 result:=true;
end;


//**********************         Запись операции       **************************************
// Сохраняем данные
  //mode=1 - запись только реквизитов рейса
  //mode=2 - запись нового состояния рейса и реквизитов
procedure TForm2.Save_critical(oper:byte; mode:byte);
begin
  If (mode=1) And NOT flchange then
     begin
       showmessagealt('Сначала измените данные рейса !'+#13+'--k4');
       exit;
     end;
  //флаг критичного изменения типа автобуса с M3 на M2
   If (ats_type='1') and ticket_canceled then
     If DialogMess('При смене типа АТС с [M3] на [M2]'+#13+'Необходимо объявить пассажирам'+#13+'о сдаче билетов на этот рейс'
        +#13+'Подтверждаете изменения рейса ?')=7 then exit;
  //showmessagealt(inttostr(tickets_blocked));//&%

  //незаявленное ТС
 If form2.checkbox1.Checked then
  begin
    If (trim(Edit9.text)='') or (trim(Edit10.text)='') then
     begin
       showmessagealt('ВНЕСИТЕ ДАННЫЕ ПО'+#13+'НЕЗАЯВЛЕННОМУ ТРАНСПОРТНОМУ СРЕДСТВУ !'+#13+'--k5');
       exit;
     end;
    vid_sriv:=3;
    real_avto:=trim(form2.Edit9.Text);
    real_reg_sign:=StringReplace(form2.Edit10.text,#32,'',[rfReplaceAll,rfIgnoreCase]);
    ats_name:=real_avto;
    ats_gos:=real_reg_sign;
  end;

          If (trim(form2.Edit2.Text)='') and (mode=2) and ((oper=1) or (oper=11)) then
             begin
               showmessagealt('Внесите Ф.И.О. водителя №1 !');
               exit;
             end;
         //если расписание в перечне по передаче данных
          If isfio and (mode=2) and ((oper=1) or (oper=11)) then
         begin
         //документ водителя 1
            If (trim(form2.Edit13.Text)='') then
            begin
                showmessagealt('Внесите данные документа водителя №1 !');
                exit;
            end;
            //паспорт //СССР
            If (form2.ComboBox1.ItemIndex=0) or (form2.ComboBox1.ItemIndex=11) then
             If utf8length(trim(form2.Edit13.Text))<>10 then
              begin
                showmessagealt('НЕКОРРЕКТНЫЕ данные паспорта водителя №1 !');
                exit;
               end;
            //загран //военник
             If (form2.ComboBox1.ItemIndex=2) or (form2.ComboBox1.ItemIndex=8) then
             If utf8length(trim(form2.Edit13.Text))<>9 then
              begin
                showmessagealt('НЕКОРРЕКТНЫЕ данные '+#13+'загран паспорта водителя №1 !');
                exit;
               end;
            If utf8length(trim(form2.Edit13.Text))<6 then
               begin
                showmessagealt('НЕКОРРЕКТНАЯ длина документа водителя №1 !');
                exit;
               end;

            //документ водителя 2
            If (trim(form2.Edit3.Text)<>'') then
            begin
               If (trim(form2.Edit15.Text)='') then
               begin
               showmessagealt('Внесите данные документа водителя №2 !');
               exit;
               end;
                //паспорт //СССР
            If (form2.ComboBox3.ItemIndex=0) or (form2.ComboBox3.ItemIndex=11) then
             If utf8length(trim(form2.Edit15.Text))<>10 then
              begin
                showmessagealt('НЕКОРРЕКТНЫЕ данные паспорта водителя №2 !');
                exit;
               end;
            //загран //военник
             If (form2.ComboBox3.ItemIndex=2) or (form2.ComboBox3.ItemIndex=8) then
             If utf8length(trim(form2.Edit15.Text))<>9 then
              begin
                showmessagealt('НЕКОРРЕКТНЫЕ данные '+#13+'загран паспорта водителя №2 !');
                exit;
               end;
            If utf8length(trim(form2.Edit15.Text))<6 then
               begin
                showmessagealt('НЕКОРРЕКТНАЯ длина документа водителя №2 !');
                exit;
               end;
            end;

           //документ водителя 3
            If (trim(form2.Edit4.Text)<>'') then
            begin
               If (trim(form2.Edit17.Text)='') then
               begin
               showmessagealt('Внесите данные документа водителя №3 !');
               exit;
               end;
                //паспорт //СССР
            If (form2.ComboBox5.ItemIndex=0) or (form2.ComboBox5.ItemIndex=11) then
             If utf8length(trim(form2.Edit17.Text))<>10 then
              begin
                showmessagealt('НЕКОРРЕКТНЫЕ данные паспорта водителя №3 !');
                exit;
               end;
            //загран //военник
             If (form2.ComboBox5.ItemIndex=2) or (form2.ComboBox5.ItemIndex=8) then
             If utf8length(trim(form2.Edit17.Text))<>9 then
              begin
                showmessagealt('НЕКОРРЕКТНЫЕ данные '+#13+'загран паспорта водителя №3 !');
                exit;
               end;
            If utf8length(trim(form2.Edit17.Text))<6 then
               begin
                showmessagealt('НЕКОРРЕКТНАЯ длина документа водителя №3 !');
                exit;
               end;
            end;
         end;

           If not encode_personal() then
            begin
             showmessagealt('Некорректные данные по водителям !!!');
             If not((oper=1) or (oper=11)) then exit;
            end;

  active_check:=true;
  //Если операция не в транзакции, то открываем повторно
  If not form1.ZConnection1.Connected then
     begin
       If mode=1 then
       formmenu.insert_oper(form2.ZConnection1,form2.ZReadOnlyQuery1,form2.ZReadOnlyQuery2,99)
       else
        formmenu.insert_oper(form2.ZConnection1,form2.ZReadOnlyQuery1,form2.ZReadOnlyQuery2,oper);

     //если операция сброшена (кто-то держит или ошибки в транзакции), то - отвал
   //если транзакция отменена (кто-то держит или нет записей для блокировки), то - отвал
    If operation=0 then exit;
  If not form2.ZConnection1.Connected then
   begin
     showmessagealt('ОШИБКА ВЫПОЛНЕНИЯ ТРАНЗАКЦИИ !'+#13+'--err28');
    exit;
    end;
     with FORM2 do
      begin

    //   //Проверяем билеты рейса на блокировку,
    //If (tickets_blocked=0) and (((oper=1) and (mode=2)) or ((oper=5) or (oper=7))) then
    //  begin
    //    ZReadOnlyQuery2.sql.Clear;
    //    ZReadOnlyQuery2.SQL.add('SELECT createdate FROM av_ticket WHERE trip_date='+Quotedstr(tripdate));
    //    ZReadOnlyQuery2.SQL.add(' AND id_shedule='+full_mas[idx,1]+' AND trip_time='+QuotedStr(up_time)+' AND id_trip_ot='+up_point);
    //    ZReadOnlyQuery2.SQL.add(' AND order_trip_ot='+up_order+' FOR UPDATE NOWAIT;');
    ////showmessage(ZQ1.SQL.Text);//$
    //try
    //    ZReadOnlyQuery2.open;
    //except
    //   showmessagealt('--------234-------'+#13+'Операция временно недоступна !'+#13+'На данный рейс ведется продажа !');
    //   ZConnection1.Rollback;
    //   ZConnection1.disconnect;
    //   exit;
    //end;
    //  end;
      //showmessage(FORM2.ZReadOnlyQuery1.SQL.Text);//$
      //showmessage(FORM2.ZReadOnlyQuery3.SQL.Text);//$
      ZReadOnlyQuery1.sql.Clear;
      ZReadOnlyQuery1.SQL.add('Update av_disp_oper SET del=1 WHERE del=0 ');//AND id_point_oper='+ConnectINI[14]);
      ZReadOnlyQuery1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[idx,16]);
      ZReadOnlyQuery1.SQL.add(' AND id_shedule='+full_mas[idx,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point);
      ZReadOnlyQuery1.SQL.add(' AND point_order='+up_order+';');
      //showmessage(FORM2.ZReadOnlyQuery1.SQL.Text);//$
 try
    ZReadOnlyQuery1.ExecSql;
  except
     If ZConnection1.InTransaction then Zconnection1.Rollback;
     ZConnection1.disconnect;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'
     //+#13+'Запрос SQL1: '+ZReadOnlyQuery1.SQL.Text
     +#13+'Запрос SQL2: '+ZReadOnlyQuery2.SQL.Text);
     exit;
  end;


   //отправить рейс
   //ОТМЕТКА О ПРИБЫТИИ РЕЙСА
   If (oper=1) or (oper=2) THEN
    begin
     If (mode=2) then
        begin
           If oper=1 then  ZReadOnlyQuery2.SQL.Add('1,'+full_mas[idx,2]+','+full_mas[idx,0]+',4,'); //отправка
           If oper=2 then  ZReadOnlyQuery2.SQL.Add('2,'+full_mas[idx,2]+','+full_mas[idx,0]+',2,'); //прибытие
        end
      else
       begin
        //If oper=1 then
        ZReadOnlyQuery2.SQL.Add('99,'+full_mas[idx,2]+','+full_mas[idx,0]+','+full_mas[idx,28]+',');//просто сохранить реквизиты
       end;
        ZReadOnlyQuery2.SQL.Add(kontr_id+','+QuotedStr(kontr_name)+','+ats_id+',');
        ZReadOnlyQuery2.SQL.Add(quotedstr(ats_name+' ГН:'+ats_gos)+','+ats_mest+',');
        ZReadOnlyQuery2.SQL.Add(ats_type+','+QuotedStr(Edit6.text)+',');
        ZReadOnlyQuery2.SQL.Add(QuotedStr(drv1)+','+QuotedStr(drv2)+',');
        If drv3<>'' then
         begin
         ZReadOnlyQuery2.SQL.Add(QuotedStr(doc1+'@'+drv3));
         If doc3<>'' then ZReadOnlyQuery2.SQL.Add(QuotedStr('&'+doc3));
         end
        else ZReadOnlyQuery2.SQL.Add(QuotedStr(doc1));
         ZReadOnlyQuery2.SQL.Add(','+QuotedStr(doc2)+',');
       If form2.checkbox1.Checked then
        ZReadOnlyQuery2.SQL.Add(inttostr(vid_sriv)+','+Quotedstr(real_avto+'|'+real_reg_sign)+');')
        else
        ZReadOnlyQuery2.SQL.Add('default,default);');
        //showmessage('1'+#13+form2.ZReadOnlyQuery2.SQL.text);//$
     end;

 // Смена АТП и АТС
 If (oper=5) or (oper=7) then
   begin
   ZReadOnlyQuery2.SQL.Add(kontr_id+','+QuotedStr(kontr_name)+','+ats_id+',');
   ZReadOnlyQuery2.SQL.Add(quotedstr(ats_name+' ГН:'+ats_gos)+','+ats_mest+',');
   ZReadOnlyQuery2.SQL.Add(ats_type+','+QuotedStr(Edit6.text)+',');
   ZReadOnlyQuery2.SQL.Add(QuotedStr(drv1)+','+QuotedStr(drv2)+',');
   If drv3<>'' then
         begin
         ZReadOnlyQuery2.SQL.Add(QuotedStr(doc1+'@'+drv3));
         If doc3<>'' then ZReadOnlyQuery2.SQL.Add(QuotedStr('&'+doc3));
         end
           else ZReadOnlyQuery2.SQL.Add(QuotedStr(doc1));
         ZReadOnlyQuery2.SQL.Add(','+QuotedStr(doc2)+',');
   If form2.checkbox1.Checked then
        ZReadOnlyQuery2.SQL.Add(inttostr(vid_sriv)+','+Quotedstr(real_avto+'|'+real_reg_sign)+');')
        else
   ZReadOnlyQuery2.SQL.Add('default,default);');
   end;

   //выполняем запрос на добавление записи о рейсе
   //showmessage(ZReadOnlyQuery2.SQL.Text);//$
 try
    ZReadOnlyQuery2.ExecSql;
 except
    If ZConnection1.InTransaction then Zconnection1.Rollback;
     ZConnection1.disconnect;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'
     //+#13+'Запрос SQL1: '+ZReadOnlyQuery1.SQL.Text
     +#13+'Запрос SQL2: '+ZReadOnlyQuery2.SQL.Text);
     exit;
 end;

   //создать ведомость на отправление
   If (oper=1) and (mode=2) and not udalenka_virt then
   begin
   //If udalenka then
   //begin
   //  //удалить все ведомости этого рейса
   // If not form1.Vedom_Close(form2.ZConnection1,form2.ZReadOnlyQuery1,idx) then
   //   begin
   //   If ZConnection1.Connected then
   //        begin
   //         If ZConnection1.InTransaction then Zconnection1.Rollback;
   //         ZConnection1.disconnect;
   //        end;
   //   ZReadOnlyQuery1.Close;
   //   ZReadOnlyQuery2.Close;
   //   showmessagealt('Ошибка закрытия посадочной ведомости на данный рейс !');
   //   exit;
   //  end;
   // end;
   //база ведомостей
    If not Vedom_Make(form2.ZConnection1, form2.ZReadOnlyQuery1, idx) then
    begin
      If ZConnection1.Connected then
           begin
            If ZConnection1.InTransaction then Zconnection1.Rollback;
            ZConnection1.disconnect;
           end;
     ZReadOnlyQuery1.Close;
     ZReadOnlyQuery2.Close;
     showmessagealt('Ошибка создания посадочной ведомости на данный рейс !' +#13+'--err29');
     exit;
    end;
   end;
try
   ZConnection1.Commit;
except
      If ZConnection1.Connected then
           begin
            If ZConnection1.InTransaction then Zconnection1.Rollback;
             showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13
          //+'Запрос SQL1: '+ZReadOnlyQuery1.SQL.Text
           +#13+'Запрос SQL2: '+ZReadOnlyQuery2.SQL.Text);
            ZConnection1.disconnect;
           end;
     exit;
end;

   flchange:=false;
  //ПЕЧАТАТЬ ВЕДОМОСТЬ если отправление рейса
 If (oper=1) and (mode=2) then
   begin
   If udalenka_virt then Form1.get_disp_oper(ZReadOnlyQuery1,idx);
    form1.Vedom_get(idx,0);
   end;
  ZReadOnlyQuery1.Close;
  ZReadOnlyQuery2.Close;
  ZConnection1.disconnect;
end;
 end
  else
  //если операция в транзакции
  begin
    //Проверяем билеты рейса на блокировку ПОВТОРНО,
    If (tickets_blocked=0) and (((oper=1) and (mode=2)) or ((oper=5) or (oper=7))) then
    begin
    form1.ZReadOnlyQuery1.sql.Clear;
    form1.ZReadOnlyQuery1.sql.add('select * from seats_in_sale('+quotedstr(tripdate)+','+up_point+',');
    form1.ZReadOnlyQuery1.sql.add(full_mas[idx,1]+','+quotedstr(QuotedStr(up_time))+','+up_order+','+full_mas[idx,25]+') as sale;');
    //form1.ZReadOnlyQuery1.SQL.add('SELECT createdate FROM av_ticket WHERE trip_date='+Quotedstr(tripdate));
    //form1.ZReadOnlyQuery1.SQL.add(' AND id_shedule='+full_mas[idx,1]+' AND trip_time='+QuotedStr(up_time)+' AND id_trip_ot='+up_point);
    //form1.ZReadOnlyQuery1.SQL.add(' AND order_trip_ot='+up_order+' FOR UPDATE NOWAIT;');
    //showmessage(ZQ1.SQL.Text);//$
    try
       form1.ZReadOnlyQuery1.open;//*
    except
       If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
       form1.ZConnection1.disconnect;
       showmessagealt('Операция временно недоступна !'+#13+'На данный рейс ведется продажа !'+#13+'--err30');
       exit;
    end;
    If form1.ZReadOnlyQuery1.Recordcount=1 then
     begin
         //если есть места в блокировки
       If copy(form1.ZReadOnlyQuery1.FieldByName('sale').asString,1,1)='1' then
         begin
             If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
             form1.ZConnection1.disconnect;
             showmessagealt('Операция временно недоступна !'+#13+'На данный рейс ведется продажа !'+#13+'--err31');
             exit;
         end;
     end;
    end;

       //отправить рейс
          //ОТМЕТКА О ПРИБЫТИИ РЕЙСА
        If (oper=1) or (oper=2) THEN
            begin
             If (mode=2) then
        begin
           If oper=1 then  form1.ZReadOnlyQuery3.SQL.Add(inttostr(oper)+','+full_mas[idx,2]+','+full_mas[idx,0]+',4,'); //отправка
           If oper=2 then  form1.ZReadOnlyQuery3.SQL.Add(inttostr(oper)+','+full_mas[idx,2]+','+full_mas[idx,0]+',2,'); //прибытие
        end
      else
       begin
        If oper=1 then  form1.ZReadOnlyQuery3.SQL.Add('99,'+full_mas[idx,2]+','+full_mas[idx,0]+',0,');//просто сохранить реквизиты
       end;

               form1.ZReadOnlyQuery3.SQL.Add(kontr_id+','+QuotedStr(kontr_name)+','+ats_id+',');
               form1.ZReadOnlyQuery3.SQL.Add(quotedstr(ats_name+' ГН:'+ats_gos)+','+ats_mest+',');
               form1.ZReadOnlyQuery3.SQL.Add(ats_type+','+QuotedStr(Edit6.text)+',');
               form1.ZReadOnlyQuery3.SQL.Add(QuotedStr(drv1)+','+QuotedStr(drv2)+',');
               If drv3<>'' then
                begin
                  form1.ZReadOnlyQuery3.SQL.Add(QuotedStr(doc1+'@'+drv3));
                  If doc3<>'' then form1.ZReadOnlyQuery3.SQL.Add(QuotedStr('&'+doc3));
                end
               else form1.ZReadOnlyQuery3.SQL.Add(QuotedStr(doc1));
                 form1.ZReadOnlyQuery3.SQL.Add(','+QuotedStr(doc2)+',');

               If form2.checkbox1.Checked then
                   form1.ZReadOnlyQuery3.SQL.Add(inttostr(vid_sriv)+','+Quotedstr(real_avto+'|'+real_reg_sign)+');')
                else
               form1.ZReadOnlyQuery3.SQL.Add('default,default);');
               //showmessage(form2.form1.ZReadOnlyQuery3.SQL.text);
            end;

        // Смена АТП и АТС
        If (oper=5) or (oper=7) then
          begin
          form1.ZReadOnlyQuery3.SQL.Add(kontr_id+','+QuotedStr(kontr_name)+','+ats_id+',');
          form1.ZReadOnlyQuery3.SQL.Add(quotedstr(ats_name+' ГН:'+ats_gos)+','+ats_mest+',');
          form1.ZReadOnlyQuery3.SQL.Add(ats_type+','+QuotedStr(Edit6.text)+',');
          form1.ZReadOnlyQuery3.SQL.Add(QuotedStr(drv1)+','+QuotedStr(drv2)+',');
           If drv3<>'' then
                begin
                  form1.ZReadOnlyQuery3.SQL.Add(QuotedStr(doc1+'@'+drv3));
                  If doc3<>'' then form1.ZReadOnlyQuery3.SQL.Add(QuotedStr('&'+doc3));
                end
           else form1.ZReadOnlyQuery3.SQL.Add(QuotedStr(doc1));
                 form1.ZReadOnlyQuery3.SQL.Add(','+QuotedStr(doc2)+',');

          If form2.checkbox1.Checked then
              form1.ZReadOnlyQuery3.SQL.Add(inttostr(vid_sriv)+','+Quotedstr(real_avto+'|'+real_reg_sign)+');')
          else
          form1.ZReadOnlyQuery3.SQL.Add('default,default);');
          end;
      //end;
      ////помечаем на удаление записи предыдущих операций над этим рейсом
        form1.ZReadOnlyQuery1.sql.Clear;
        form1.ZReadOnlyQuery1.SQL.add('Update av_disp_oper SET del=1 WHERE del=0 ');//AND id_point_oper='+ConnectINI[14]);
        form1.ZReadOnlyQuery1.SQL.add(' AND trip_date='+Quotedstr(tripdate)+' AND trip_type='+full_mas[idx,16]);
        form1.ZReadOnlyQuery1.SQL.add(' AND id_shedule='+full_mas[idx,1]+' AND trip_time='+QuotedStr(up_time)+' AND trip_id_point='+up_point);
        form1.ZReadOnlyQuery1.SQL.add(' AND point_order='+up_order+';');
   try
      //showmessage(form1.ZReadOnlyQuery1.SQL.Text);//$
     form1.ZReadOnlyQuery1.ExecSql;
      //выполняем запрос на добавление записи о рейсе
     //showmessage(form1.ZReadOnlyQuery3.SQL.text);//$
     form1.ZReadOnlyQuery3.ExecSql;
    except
      If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
      form1.ZConnection1.disconnect;
      showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !'
     //+#13+'Запрос SQL1: '+form1.ZReadOnlyQuery1.SQL.Text
      +#13+'Запрос SQL2: '+form1.ZReadOnlyQuery3.SQL.Text);
      exit;
   end;

   //создать ведомость на отправление
   If (oper=1) and (mode=2) and not udalenka_virt then
   begin
   //If not udalenka then
   //begin
   //  //удалить все ведомости этого рейса
   // If not form1.Vedom_Close(form1.ZConnection1,form1.ZReadOnlyQuery1,idx) then
   //   begin
   //    If ZConnection1.Connected then
   //        begin
   //         If ZConnection1.InTransaction then Zconnection1.Rollback;
   //         ZConnection1.disconnect;
   //        end;
   //   showmessagealt('Ошибка закрытия посадочной ведомости на данный рейс !');
   //   form1.ZReadOnlyQuery1.Close;
   //   form1.ZReadOnlyQuery2.Close;
   //   exit;
   //  end;
   // end;
   //база ведомостей
    If not Vedom_Make(form1.ZConnection1,form1.ZReadOnlyQuery1,idx) then
    begin
      If ZConnection1.Connected then
           begin
            If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
            form1.ZConnection1.disconnect;
           end;
     showmessagealt('Ошибка создания посадочной ведомости на данный рейс !'+#13+'--err32');
     form1.ZReadOnlyQuery1.Close;
     form1.ZReadOnlyQuery3.Close;
     exit;
    end;
    end;
try
  //showmessage(form1.ZReadOnlyQuery1.SQL.Text);//$
  //showmessage(form1.ZReadOnlyQuery3.SQL.Text);//$
   form1.ZConnection1.Commit;
except
     If form1.ZConnection1.InTransaction then form1.Zconnection1.Rollback;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !'
     //+#13+'Запрос SQL1: '+form1.ZReadOnlyQuery1.SQL.Text
     +#13+'Запрос SQL2: '+form1.ZReadOnlyQuery3.SQL.Text);
     form1.ZConnection1.disconnect;
     exit;
end;

  //ПЕЧАТАТЬ ВЕДОМОСТЬ если отправление рейса
 If (oper=1) and (mode=2) then
   begin
   If udalenka_virt then Form1.get_disp_oper(form1.ZReadOnlyQuery1,idx);
   form1.Vedom_get(idx,0);
   end;
 form1.ZReadOnlyQuery1.Close;
 form1.ZReadOnlyQuery3.Close;
 form1.ZConnection1.disconnect;
 //form1.Disp_refresh(0); //обновить экран диспетчера
end;

  //дописать операции по связанным РЕГУЛЯРНЫМ рейсам
  write_oper;

  //если печать АКТА за незаявленное ТС
   If (oper=1) and (mode=2) and not udalenka_virt and form2.checkbox1.Checked then
    begin
    If DialogMess('Вывести на печать АКТ'+#13+'за незаявленное транспортное средство ?')=6 then
    print_akt();
    end;
  //если операция по виртуальному серверу, то записать локально
  If udalenka_virt then
   begin
   formmenu.insert_remote_oper(form2.ZConnection1,form2.ZReadOnlyQuery1,oper,inttostr(id_user),formatDatetime('dd-mm-yyyy hh:nn:ss',now()));
  //если транзакция еще открыта - откатываемся
    If form2.Zconnection1.Connected then
      begin
       form2.ZReadOnlyQuery1.Close;
       If form2.ZConnection1.InTransaction then form2.Zconnection1.Rollback;
       form2.ZConnection1.disconnect;
       end;
   end;
  active_check:=false;
  flchange:=false;
  form2.Close;
end;



//**********************         Запись операции       **************************************
// Сохраняем данные
  //mode=1 - запись только реквизитов рейса
  //mode=2 - запись нового состояния рейса и реквизитов
procedure TForm2.save_zakaznoi(oper:byte; mode:byte);
var
  fl_disp_day:integer;
  add_trip:boolean;
begin
 with FORM2 do
begin
  add_trip:=true;
  If (mode=1) And NOT flchange then
     begin
       showmessagealt('Сначала измените данные рейса !');
       exit;
     end;
     If (trim(form2.Edit2.Text)<>'') then
       begin
           If not encode_personal() then
            begin
             showmessagealt('Некорректные данные по водителям !');
            exit;
            end;
        end;
 //showmessage(timetostr(form2.DateTimePicker1.Time));//$
  // Подключаемся к серверу
   If not(Connect2(ZConnection1, 1)) then
     begin
      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'--k6');
      ZConnection1.disconnect;
      exit;
     end;

     //незаявленное ТС
 If form2.checkbox1.Checked then
  begin
    If (trim(Edit9.text)='') or (trim(Edit10.text)='') then
     begin
       showmessagealt('ВНЕСИТЕ ДАННЫЕ ПО'+#13+'НЕЗАЯВЛЕННОМУ ТРАНСПОРТНОМУ СРЕДСТВУ !'+#13+'--k7');
       exit;
     end;
    real_avto:=trim(form2.Edit9.Text);
    real_reg_sign:=StringReplace(form2.Edit10.text,#32,'',[rfReplaceAll,rfIgnoreCase]);
  end;

   active_check:=true;
   fl_disp_day:=0;
   //ЗАКАЗНОЙ РЕЙС (ЗАПИСЬ РЕЙСА И ОПЕРАЦИИ)
      up_time:= copy(timetostr(DateTimePicker1.Time),1,5);
      zakaz_shed:=full_mas[idx,1];
      zakaz_time:=up_time;
      //ПРОВЕРКА НА ДУБЛИКАТ
      ZReadOnlyQuery1.SQL.Clear;
      ZReadOnlyQuery1.SQL.add('SELECT createdate FROM av_trip_add WHERE ');//id_point_oper='+ConnectINI[14]);
      ZReadOnlyQuery1.SQL.add(' date_trip='+Quotedstr(tripdate)+' AND napr='+full_mas[idx,16]);
      ZReadOnlyQuery1.SQL.add(' AND id_shedule='+full_mas[idx,1]+' AND t_o='+QuotedStr(up_time));
      ZReadOnlyQuery1.SQL.add(' AND ot_id_point='+full_mas[idx,3]+' AND ot_order='+full_mas[idx,4]+';');
      //showmessage(form2.ZReadOnlyQuery1.SQL.text);//$
      try
      ZReadOnlyQuery1.Open;
      except
        showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
        ZReadOnlyQuery1.Close;
        Zconnection1.disconnect;
        exit;
      end;
      If ZReadOnlyQuery1.RecordCount>0 then
        begin
          If perenos_biletov>-1 then
           begin
             add_trip:=false;
           end
          else
          begin
          showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !!!'+#13+'ЗАКАЗНОЙ РЕЙС С ДАННЫМИ ПАРАМЕТРАМИ УЖЕ СУЩЕСТВУЕТ !'+#13+'--k8');
          ZReadOnlyQuery1.Close;
          Zconnection1.disconnect;
          EXIT;
          end;
        end;

       //ПРОВЕРКА на существование временной таблицы текущего дня
      ZReadOnlyQuery1.SQL.Clear;
      ZReadOnlyQuery1.SQL.add('SELECT cur_date FROM av_disp_current_day limit 1 offset 0;');//id_point_oper='+ConnectINI[14]);
      //showmessage(form2.ZReadOnlyQuery1.SQL.text);//$
      try
        ZReadOnlyQuery1.Open;
        If (ZReadOnlyQuery1.RecordCount>0) and (ZReadOnlyQuery1.FieldByName('cur_date').asDateTime=work_date) then
          fl_disp_day:=2;
      except
        fl_disp_day:=1;
        //ZReadOnlyQuery1.Close;
        //Zconnection1.disconnect;
        //exit;
      end;

//Открываем транзакцию
try
   If not ZConnection1.InTransaction then
    begin
      ZConnection1.StartTransaction;
    end
   else
     begin
      showmessagealt('Ошибка ! Незавершенная транзакция !'+#13+'Попробуйте снова !'+#13+'--err34');
      If ZConnection1.InTransaction then Zconnection1.Rollback;
      ZConnection1.disconnect;
      exit;
     end;
     If add_trip then
      begin
     //добавляем во временную таблицу запись о заказном рейсе (далее сработает триггер на обновление операций)
     If fl_disp_day=2 then
      begin
      ZReadOnlyQuery1.SQL.Clear;
      ZReadOnlyQuery1.SQL.add('INSERT INTO av_disp_current_day SELECT ');
      ZReadOnlyQuery1.SQL.add(full_mas[idx,1]+',1,null,'+QuotedStr(full_mas[idx,23])+','+QuotedStr(full_mas[idx,24])+','+QuotedStr(full_mas[idx,14])+','+full_mas[idx,15]+',');
      ZReadOnlyQuery1.SQL.add(full_mas[idx,3]+','+full_mas[idx,4]+','+full_mas[idx,6]+','+full_mas[idx,7]+','+QuotedStr(up_time)+','+QuotedStr(full_mas[idx,11])+','+QuotedStr(full_mas[idx,12])+',');
      ZReadOnlyQuery1.SQL.add(QuotedStr(full_mas[idx,5])+','+QuotedStr(full_mas[idx,8])+','+full_mas[idx,16]+',');
      ZReadOnlyQuery1.SQL.add('(select pp.point_order from av_shedule_sostav pp ');
      ZReadOnlyQuery1.SQL.add(' where pp.del=0 and pp.id_shedule='+full_mas[idx,1]+' and ');
      ZReadOnlyQuery1.SQL.add(' pp.id_point='+sale_server+' and ');
      ZReadOnlyQuery1.SQL.add(' pp.point_order>='+full_mas[idx,4]+' and pp.point_order<='+full_mas[idx,7]+' ORDER BY pp.createdate DESC limit 1 OFFSET 0');
      ZReadOnlyQuery1.SQL.add(' ), ');
      ZReadOnlyQuery1.SQL.add(full_mas[idx,9]+','+full_mas[idx,2]+',2');
      ZReadOnlyQuery1.SQL.add(',0,''''');
      ZReadOnlyQuery1.SQL.add(',0,''''');
      ZReadOnlyQuery1.SQL.add(',0 ,0 ');
      ZReadOnlyQuery1.SQL.add(',0 , ');
      ZReadOnlyQuery1.SQL.add(ConnectINI[14]+', now(),'+inttostr(id_user));
      ZReadOnlyQuery1.SQL.add(',11');
      ZReadOnlyQuery1.SQL.add(','''','''','''' ,'''','''' ');
      ZReadOnlyQuery1.SQL.add(',0 ,'''' , 0 ');
      ZReadOnlyQuery1.SQL.add(',1, 1 , 1, 1, 1 , 1,');
      ZReadOnlyQuery1.SQL.add(QuotedStr(up_time)+', '''' ,1,1, ');
      ZReadOnlyQuery1.SQL.add(' 1 ,'''' ,'+quotedstr(tripdate)+' ;');
     //showmessage(ZReadOnlyQuery1.SQL.Text);//$
      ZReadOnlyQuery1.Open;
      end;

   //СОЗДАНИЕ ЗАКАЗНОГО РЕЙСА (берем только нужные данные по этому рейсу так как будет создан новый)
   ZReadOnlyQuery1.sql.Clear;
   ZReadOnlyQuery1.SQL.add('INSERT INTO av_disp_oper(id_user,createdate,del,id_point_oper,id_shedule,trip_type,trip_id_point,point_order,');
   ZReadOnlyQuery1.SQL.add('trip_date,id_oper,platform,zakaz,trip_flag,');
   ZReadOnlyQuery1.SQL.add('trip_time,atp_id,atp_name,avto_id,avto_name,avto_seats,avto_type,putevka,driver1,driver2,driver3,driver4,remark) VALUES (');
   ZReadOnlyQuery1.SQL.add(inttostr(id_user)+',now(),0,'+ConnectINI[14]+','+full_mas[idx,1]+','+full_mas[idx,16]+','+up_point+','+up_order+',');
   ZReadOnlyQuery1.SQL.add(Quotedstr(tripdate)+','+inttostr(oper)+','+full_mas[idx,2]+',2,0,');
   ZReadOnlyQuery1.SQL.Add(QuotedStr(up_time)+','+kontr_id+','+QuotedStr(kontr_name)+','+ats_id+',');
   ZReadOnlyQuery1.SQL.Add(quotedstr(ats_name+' ГН:'+ats_gos)+','+ats_mest+',');
   ZReadOnlyQuery1.SQL.Add(ats_type+','+QuotedStr(Edit6.text)+',');
   ZReadOnlyQuery1.SQL.Add(QuotedStr(drv1)+','+QuotedStr(drv2)+',');
    If drv3<>'' then
     begin
       ZReadOnlyQuery1.SQL.Add(QuotedStr(doc1+'@'+drv3));
       If doc3<>'' then ZReadOnlyQuery1.SQL.Add(QuotedStr('&'+doc3));
     end
    else  ZReadOnlyQuery1.SQL.Add(QuotedStr(doc2));

   ZReadOnlyQuery1.SQL.Add(','+QuotedStr(doc2));


     //незаявленное ТС
 If form2.checkbox1.Checked then
    ZReadOnlyQuery1.SQL.Add(','+Quotedstr(real_avto+'|'+real_reg_sign)+');')
  else
    ZReadOnlyQuery1.SQL.Add(',default);');
   //выполняем запрос на добавление записи о рейсе
   //showmessage(ZReadOnlyQuery1.SQL.Text);//$
   ZReadOnlyQuery1.Open;

    //ЗАКАЗНОЙ РЕЙС (ЗАПИСЬ РЕЙСА )
      ZReadOnlyQuery1.SQL.Clear;
      ZReadOnlyQuery1.SQL.add('INSERT INTO av_trip_add(id_user,createdate,id_point_oper,date_trip,id_shedule,plat,');
      ZReadOnlyQuery1.SQL.add('ot_id_point,ot_order,ot_name,do_id_point,do_order,do_name,form,t_o,t_s,t_p,zakaz,');
      ZReadOnlyQuery1.SQL.add('date_tarif,id_route,napr,dates,datepo,active) VALUES( ');
      ZReadOnlyQuery1.SQL.add(inttostr(id_user)+',now(),'+ConnectINI[14]+','+Quotedstr(tripdate)+',');
      ZReadOnlyQuery1.SQL.add(full_mas[idx,1]+','+full_mas[idx,2]+','+full_mas[idx,3]+','+full_mas[idx,4]+','+QuotedStr(full_mas[idx,5])+','+full_mas[idx,6]+',');
      ZReadOnlyQuery1.SQL.add(full_mas[idx,7]+','+QuotedStr(full_mas[idx,8])+','+full_mas[idx,9]+','+QuotedStr(up_time)+','+QuotedStr(full_mas[idx,11])+',');
      ZReadOnlyQuery1.SQL.add(QuotedStr(full_mas[idx,12])+',1,'+QuotedStr(full_mas[idx,14])+','+full_mas[idx,15]+','+full_mas[idx,16]+',');
      ZReadOnlyQuery1.SQL.add(QuotedStr(full_mas[idx,23])+','+QuotedStr(full_mas[idx,24])+',1);');//full_mas[idx,22]+');');
      //showmessage(form2.ZReadOnlyQuery1.SQL.text);//$
    ZReadOnlyQuery1.Open;

    end;
  //если нужно перекинуть билеты
  If (perenos_biletov>-1) THEN
   begin
    ZReadOnlyQuery1.SQL.Clear;
      ZReadOnlyQuery1.SQL.add('UPDATE av_ticket SET zakaz=1,trip_time='+QuotedStr(up_time)+',');
      ZReadOnlyQuery1.SQL.add(' id_trip_ot='+full_mas[idx,3]+',id_trip_do='+full_mas[idx,6]+',order_trip_ot='+full_mas[idx,4]);
      ZReadOnlyQuery1.SQL.add(' ,order_trip_do='+full_mas[idx,7]); //+',id_kontr='+kontr_id+',id_ats='+ats_id+',');
      ZReadOnlyQuery1.SQL.add(' ,ticket_text=split_part(ticket_text,''|П'',1)||'+Quotedstr('|П trip_time='+Quotedstr(Full_mas[perenos_biletov,10])));
      ZReadOnlyQuery1.SQL.add(Quotedstr(',id_trip_ot='+full_mas[idx,3]+',id_trip_do='+full_mas[idx,6]+',order_trip_ot='+full_mas[idx,4]+',order_trip_do='+full_mas[idx,7]));
      ZReadOnlyQuery1.SQL.add(Quotedstr(' |user:'+inttostr(id_user)+' stamp:'+formatdatetime('dd.mm.yy hh:nn',now())+' П|'));
      ZReadOnlyQuery1.SQL.add(' ,statement_num='+form1.Get_num_vedom(perenos_biletov));
      ZReadOnlyQuery1.SQL.add(' WHERE trip_date='+Quotedstr(tripdate)+' AND id_shedule='+full_mas[perenos_biletov,1]+' AND trip_time='+Quotedstr(Full_mas[perenos_biletov,10]));
      ZReadOnlyQuery1.SQL.add(' AND id_trip_ot='+full_mas[perenos_biletov,3]+' AND order_trip_ot='+full_mas[perenos_biletov,4]);
      ZReadOnlyQuery1.SQL.add(' AND id_trip_do='+full_mas[perenos_biletov,6]+' AND order_trip_do='+full_mas[perenos_biletov,7]);
      //ZReadOnlyQuery1.SQL.add(' AND id_do in (SELECT id_point FROM av_shedule_sostav WHERE del=0 AND id_shedule='+full_mas[perenos_biletov,1]+')');
      ZReadOnlyQuery1.SQL.add(' AND id_user>0 and tarif>0;');
     //showmessage(ZReadOnlyQuery1.SQL.Text);//$
    try
      ZReadOnlyQuery1.ExecSQL;
    except
       If ZConnection1.InTransaction then Zconnection1.Rollback;
      ZConnection1.disconnect;
      showmessagealt('Данные не записаны !'+#13+'Не удается перебросить билеты !!!'+#13+ZReadOnlyQuery1.SQL.Text);
      exit;
     end;
   end;
   ZConnection1.Commit;
except
     If ZConnection1.InTransaction then Zconnection1.Rollback;
     ZConnection1.disconnect;
     showmessagealt('Данные не записаны !'+#13+'Не удается завершить транзакцию !!!'+#13+ZReadOnlyQuery1.SQL.Text);
     exit;
end;

  ZReadOnlyQuery1.Close;
  ZConnection1.disconnect;
 end;
 If add_trip=false then showmessage('БИЛЕТЫ УСПЕШНО ПЕРЕНЕСЕНЫ НА ЗАКАЗНОЙ РЕЙС !');
 active_check:=false;
 flchange:=false;
 form2.Close;
end;


//************************************** ЗАПРОС ПОСЛЕДНИХ ДИСПЕТЧЕРСКИХ ОПЕРАЦИЙ по РЕЙСу (ТОЛЬКО ПО РЕЙСУ)****************
//procedure TForm2.getdisp_oper(arn:integer);
//var
//  tn,tm:integer;
//begin
//  // Подключаемся к серверу
//   If not(Connect2(Zconnection1, flagProfile)) then
//     begin
//      showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
//      Zconnection1.disconnect;
//      exit;
//     end;
//             //запрашиваем только новые операции
////Запрос к av_disp_oper
// form2.ZReadOnlyQuery1.SQL.Clear;
// form2.ZReadOnlyQuery1.SQL.Add('select * from av_disp_oper WHERE del=0 AND trip_date='+Quotedstr(tripdate)+' AND createdate>'+Quotedstr(max_operation));//' AND id_point_oper='+ConnectINI[14]);
// form2.ZReadOnlyQuery1.SQL.Add(' AND id_shedule='+full_mas[idx,1]+' AND trip_time='+Quotedstr(up_time)+' AND trip_id_point='+up_point+' AND point_order='+up_order+' order by createdate;');
// //showmessage(form2.ZReadOnlyQuery1.SQL.text);//$
// try
//  form2.ZReadOnlyQuery1.open;
// except
//  showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+form2.ZReadOnlyQuery1.SQL.Text);
//  form2.ZReadOnlyQuery1.Close;
//  form2.Zconnection1.disconnect;
//  exit;
// end;
//    If form2.ZReadOnlyQuery1.RecordCount=0 then
//        begin
//           //showmessagealt('Ошибка чтения справочника операций диспетчера !!!');
//          form2.ZReadOnlyQuery1.Close;
//          form2.Zconnection1.disconnect;
//          exit;
//        end;
//  For n:=1 to form2.ZReadOnlyQuery1.RecordCount do
//    begin
//      //находим рейс
//        //отправление
//      //If  ((full_mas[idx,16]=form2.ZReadOnlyQuery1.FieldByName('trip_type').AsString) AND
//      //(form2.ZReadOnlyQuery1.FieldByName('trip_type').AsInteger=1) AND
//      //(full_mas[idx,10]=form2.ZReadOnlyQuery1.FieldByName('trip_time').AsString) AND
//      //(full_mas[idx,3]=form2.ZReadOnlyQuery1.FieldByName('trip_id_point').AsString) AND
//      //(full_mas[idx,4]=form2.ZReadOnlyQuery1.FieldByName('point_order').AsString)) OR
//      ////или если рейс прибытия
//      //((full_mas[idx,16]=form2.ZReadOnlyQuery1.FieldByName('trip_type').AsString) AND
//      //(form2.ZReadOnlyQuery1.FieldByName('trip_type').AsInteger=2) AND
//      //(full_mas[idx,12]=form2.ZReadOnlyQuery1.FieldByName('trip_time').AsString) AND
//      //(full_mas[idx,6]=form2.ZReadOnlyQuery1.FieldByName('trip_id_point').AsString) AND
//      //(full_mas[idx,7]=form2.ZReadOnlyQuery1.FieldByName('point_order').AsString)) then
//      begin
//           kontr_id:= trim(form2.ZReadOnlyQuery1.FieldByName('atp_id').asString);
//           ats_id:= trim(form2.ZReadOnlyQuery1.FieldByName('avto_id').asString);
//           ats_mest:= trim(form2.ZReadOnlyQuery1.FieldByName('avto_seats').asString);
//           ats_type:= trim(form2.ZReadOnlyQuery1.FieldByName('avto_type').asString);
//           ats_name:= trim(form2.ZReadOnlyQuery1.FieldByName('avto_name').asString);
//           ats_gos:='';
//           //showmessagealt(ats_name+#13+ats_gos);//$
//           If trim(form2.ZReadOnlyQuery1.FieldByName('atp_name').asString)<>'' then
//           kontr_name:= trim(form2.ZReadOnlyQuery1.FieldByName('atp_name').asString);
//           If trim(form2.ZReadOnlyQuery1.FieldByName('putevka').asString)<>'' then
//           put:= trim(form2.ZReadOnlyQuery1.FieldByName('putevka').asString);
//           If trim(form2.ZReadOnlyQuery1.FieldByName('driver1').asString)<>'' then
//           dr1:= trim(form2.ZReadOnlyQuery1.FieldByName('driver1').asString);
//           If trim(form2.ZReadOnlyQuery1.FieldByName('driver2').asString)<>'' then
//           dr2:= trim(form2.ZReadOnlyQuery1.FieldByName('driver2').asString);
//           If trim(form2.ZReadOnlyQuery1.FieldByName('driver3').asString)<>'' then
//           dr3:= trim(form2.ZReadOnlyQuery1.FieldByName('driver3').asString);
//           If trim(form2.ZReadOnlyQuery1.FieldByName('driver4').asString)<>'' then
//           dr4:= trim(form2.ZReadOnlyQuery1.FieldByName('driver4').asString);
//      end;
//
//      form2.ZReadOnlyQuery1.Next;
//    end;
//  form2.ZReadOnlyQuery1.close;
//  form2.ZConnection1.Disconnect;
//end;



//**************************************************************** HOT KEYS  **************************************************
procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
 var
   n:integer;
   fl,flno:boolean;
begin
  fl:=false;
  flno:=true;
 //showmessage(inttostr(key));
 //если активна фаза сохранения, то пропускаем
   if (active_check=true) then
     begin
       key:=0;
       exit;
     end;
  // F1
   if Key=112 then
     begin
     showmessagealt('[F1] - Справка'+#13+'[ENTER] - переход по пунктам'+#13+'[ПРОБЕЛ] - внести незаявленное ТС'+#13+'[F3] - Выбор АТП/АТС из справочника'+#13
     +'[F10] - Сохранить данные рейса'+#13+'[F12] - Выполнить операцию'+#13+'[ESC] - Отмена\Выход');
     key:=0;
     end;

   // ESC закрыть форму
   if (Key=27) and (form2.Edit8.Visible=false) and (form2.stringgrid1.Visible=false) then
       begin
         key:=0;
         operation:=0;
         form2.Close;
         exit;
       end;

      // ENTER>TAB
   if (Key=13) and (form2.Edit8.focused=false) and (form2.stringgrid1.focused=false) then
       begin
        //If form2.Edit8.Visible=true then form2.Edit8.Visible:=false;
        //If isfio and (form2.Edit2.Focused or form2.Edit3.Focused or form2.Edit4.Focused) then
        //  begin
        //    If form2.Edit3.Focused and form2.Edit5.Visible then form2.Edit5.SetFocus;
        //    If form2.Edit4.Focused and form2.Edit3.Visible then form2.Edit3.SetFocus;
        //    If form2.Edit2.Focused and form2.Edit4.Visible then form2.Edit4.SetFocus;
        //  end
        //else
        //begin
          form2.SelectNext(ActiveControl,true,true);
          //end;
         Key:=0;
       end;

   // F10 - Запись реквизитов в базу
   if (Key=121) then
       begin
         form2.getz_date();
         key:=0;
         If udalenka_real then
           begin
             showmessagealt('Операция ЗАПРЕЩЕНА ! '+#13+'Для УДАЛЕННОГО подразделения');
             exit;
           end;

          //If DialogMess('Сохранить данные рейса ?')=7 then exit;
         If (operation=11) then save_zakaznoi(operation,1) else Save_critical(operation,1);
         //form2.Close;
           exit;
       end;

   // F12 - Запись операции в базу
   if (Key=123) then
     begin
       form2.getz_date();
         key:=0;
         If udalenka_real then
           begin
             showmessagealt('Операция ЗАПРЕЩЕНА ! '+#13+'Для УДАЛЕННОГО подразделения');
             exit;
           end;
         //If DialogMess('Подтвердите выполнение операции...')=7 then exit;
          If (operation=11) then save_zakaznoi(operation,2) else Save_critical(operation,2);
           //form2.Close;
         exit;
    end;


   // Вверх на АТП
   if (Key=38) and (form2.edit1.Focused=true) then
       begin
         key:=0;
         If length(tmp_atp)<2 then exit;
         //If operation=1 then
         // begin
         //   showmessagealt('ВЫБЕРИТЕ ОПЕРАЦИЮ СМЕНЫ ПЕРЕВОЗЧИКА !');
         //   exit;
         // end;
         tek_mas_atp:=tek_mas_atp-1;
         if tek_mas_atp<0 then
           begin
            tek_mas_atp:=0;
            exit;
           end;
         fill_atp(tek_mas_atp);
         // Меняем атс
         for n:=0 to length(tmp_ats)-1 do
           begin
             if trim(tmp_ats[n,0])=trim(tmp_atp[tek_mas_atp,0]) then
                 begin
                   tek_mas_ats:=n;
                   fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
                   break;
                 end;
           end;
          flchange:=true;
       end;

   // Вниз на АТП
   if (Key=40) and (form2.edit1.Focused=true) then
       begin
         key:=0;
         If length(tmp_atp)<2 then exit;
         //If operation=1 then
         // begin
         //   showmessagealt('ВЫБЕРИТЕ ОПЕРАЦИЮ СМЕНЫ ПЕРЕВОЗЧИКА !');
         //   exit;
         // end;
         tek_mas_atp:=tek_mas_atp+1;
         if tek_mas_atp>length(tmp_atp)-1 then
             begin
               tek_mas_atp:=length(tmp_atp)-1;
               exit;
             end;
         fill_atp(tek_mas_atp);
         // Меняем атс
         for n:=0 to length(tmp_ats)-1 do
           begin
             if trim(tmp_ats[n,0])= trim(tmp_atp[tek_mas_atp,0]) then
                 begin
                   tek_mas_ats:=n;
                   fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
                   break;
                 end;
           end;
         flchange:=true;
       end;
   //передвижение по поиску
   If (form2.edit8.visible=true) and ((Key=38) or (Key=40))  then
    begin
    form2.edit7.SetFocus;
    flchange:=true;
    end;

   // Вверх на АТC
   if (Key=38) and (form2.edit7.Focused=true) then
       begin
         key:=0;
         If length(tmp_ats)<2 then exit;
         //If operation=1 then
          //begin
            //showmessagealt('ВЫБЕРИТЕ ОПЕРАЦИЮ СМЕНЫ АТС !');
            //exit;
          //end;
         tek_mas_ats:=tek_mas_ats-1;
         if tek_mas_ats<0 then
           begin
            tek_mas_ats:=0;
            exit;
           end;
         //если активен контекстный поиск
         If form2.Edit8.Visible then
           begin
             ats_search(tek_mas_ats);
           end
         else
         begin
            // Ищем атс перевозчика на один меньше по порядку
         for n:=tek_mas_ats downto 0 do
           begin
             if (trim(tmp_ats[n,0])=trim(tmp_atp[tek_mas_atp,0])) then
                 begin
                   tek_mas_ats:=n;
                   fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
                   break;
                 end;
           end;
         end;
            flchange:=true;
       end;

// Вниз на АТC
  if (Key=40) and (form2.edit7.Focused=true) then
    begin
      key:=0;
      If length(tmp_ats)<2 then exit;
       //If operation=1 then
          //begin
            //showmessagealt('ВЫБЕРИТЕ ОПЕРАЦИЮ СМЕНЫ АТС !');
            //exit;
          //end;
      tek_mas_ats:=tek_mas_ats+1;
       if tek_mas_ats>length(tmp_ats)-1 then
           begin
             tek_mas_ats:=length(tmp_ats)-1;
             exit;
           end;
          //если активен контекстный поиск
         If form2.Edit8.Visible then
           begin
             ats_search(tek_mas_ats);
           end
         else
         begin
          // Ищем атс перевозчика на один больше по порядку
         for n:=tek_mas_ats to length(tmp_ats)-1 do
           begin
            //showmessagealt(trim(tmp_ats[n,0])+'='+trim(tmp_atp[tek_mas_atp,0])+#13+tmp_ats[n,6]+'='+inttostr(tek_mas_ats+1));
             if (trim(tmp_ats[n,0])=trim(tmp_atp[tek_mas_atp,0])) then
                 begin
                   tek_mas_ats:=n;
                   fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
                   break;
                 end;
           end;
         end;
            flchange:=true;
    end;

   // F3 - Выбор из списка перевозчиков
   if (Key=114) and (operation<>7) and (form2.edit1.Focused=true) then
       begin
          Key:=0;
         Form3:=TForm3.create(self);
         Form3.ShowModal;
         FreeAndNil(Form3);
         if  (trim(wibor_id_atp)='') then exit;
        flchange:=true;
      //  для заказного рейса
         If zkaz then
             begin
               SetLength(tmp_atp,0,0);
               SetLength(tmp_atp,1,3);
               tmp_atp[0,0]:=trim(wibor_id_atp);
               tmp_atp[0,1]:=trim(wibor_name_atp);
               tek_mas_atp:=0;
               fill_atp(tek_mas_atp);
               // ЗАГРУЖАЕМ СПИСОК АТС ДЛЯ СОЗДАНИЯ ЗАКАЗНОГО РЕЙСА
               ats_id:='0';
               form2.get_ats_zakaz;
               form2.Edit7.SetFocus;
             end
         else
         begin
          for n:=0 to length(tmp_atp)-1 do
            begin
             If trim(tmp_atp[n,0])=trim(wibor_id_atp) then
               begin
                 tek_mas_atp:=n;
                 break;
               end;
            end;
         fill_atp(tek_mas_atp);
         // Меняем атс
         for n:=0 to length(tmp_ats)-1 do
           begin
             if trim(tmp_ats[n,0])=trim(tmp_atp[tek_mas_atp,0]) then
                 begin
                   tek_mas_ats:=n;
                   fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
                 end;
           end;
        end;
     end;

   // F3 - Выбор из списка АТС для заказного рейса
   if (Key=114) and (form2.edit7.Focused=true) then// and zkaz then
       begin
         If (trim(form2.Edit1.Text)='') then exit;
         Form5:=TForm5.create(self);
         Form5.ShowModal;
         FreeAndNil(Form5);
         flchange:=true;
         // Если выбрано другое АТС то
         if  not(trim(wibor_id_ats)='') then
             begin
              for n:=0 to length(tmp_ats)-1 do
                begin
                  if (trim(tmp_ats[n,0])=trim(tmp_atp[tek_mas_atp,0]))
                     and (trim(tmp_ats[n,1])=trim(wibor_id_ats)) then
                      begin
                       tek_mas_ats:=n;
                       fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
                      end;
                end;
             end;
         Key:=0;
     end;

      // ESC поиск ТС
   if (Key=27) and (form2.Edit8.Visible=true) then
       begin
         key:=0;
         form2.Edit8.Visible:=false;
         form2.Edit7.SetFocus;
         exit;
       end;
       // ESC поиск водителей
   if (Key=27) and (form2.stringgrid1.Visible=true) then
       begin
         key:=0;
          If famildlina>2 then
          famildlina:=famildlina-2
          else famildlina:=0;
         If tekedit=2 then
           begin
            form2.Edit2.SetFocus;
            form2.Edit2.SelStart:=utf8length(form2.Edit2.Text);
            form2.Edit2.SelLength:=0;
           end;
         If tekedit=13 then
           begin
            form2.Edit13.SetFocus;
            form2.Edit13.SelStart:=utf8length(form2.Edit13.Text);
            form2.Edit13.SelLength:=0;
           end;
         If tekedit=3 then
           begin
            form2.Edit3.SetFocus;
            form2.Edit3.SelStart:=utf8length(form2.Edit3.Text);
            form2.Edit3.SelLength:=0;
           end;
         If tekedit=15 then
           begin
            form2.Edit15.SetFocus;
            form2.Edit15.SelStart:=utf8length(form2.Edit15.Text);
            form2.Edit15.SelLength:=0;
           end;
          If tekedit=4 then
           begin
            form2.Edit4.SetFocus;
            form2.Edit4.SelStart:=utf8length(form2.Edit4.Text);
            form2.Edit4.SelLength:=0;
           end;
         If tekedit=17 then
           begin
            form2.Edit17.SetFocus;
            form2.Edit17.SelStart:=utf8length(form2.Edit17.Text);
            form2.Edit17.SelLength:=0;
           end;

         form2.stringgrid1.Visible:=false;
         form2.stringgrid1.Height:=1;
         //form2.stringgrid1.Top:=625;
         exit;
       end;

      // ENTER поиск АТС
   if (Key=13) and (form2.Edit8.focused=true) then
       begin
         key:=0;
         form2.SelectNext(ActiveControl,true,true);
         form2.Edit8.Visible:=false;
         flchange:=true;
         exit;
       end;

      // ENTER поиск данных водителя
   if (Key=13) and (form2.stringgrid1.focused) then
       begin
          key:=0;
           decode_personal(tekedit,form2.stringgrid1.Cells[0,form2.StringGrid1.Row]);
      If isfio then
      begin
        If tekedit=2 then
          begin
           decode_personal(13,form2.stringgrid1.Cells[1,form2.StringGrid1.Row]);
           form2.Edit13.SetFocus;
           form2.Edit13.SelStart:=utf8length(form2.Edit13.Text);
          end;
        If tekedit=3 then
          begin
          decode_personal(15,form2.stringgrid1.Cells[1,form2.StringGrid1.Row]);
          form2.Edit15.SetFocus;
          form2.Edit15.SelStart:=utf8length(form2.Edit15.Text);
          end;
        If tekedit=4 then
          begin
          decode_personal(17,form2.stringgrid1.Cells[1,form2.StringGrid1.Row]);
          form2.Edit17.SetFocus;
          form2.Edit17.SelStart:=utf8length(form2.Edit17.Text);
          end;
      end;
           openforedit();
           //end;
       If not isfio then
       begin
              If tekedit=2 then
            form2.Edit2.SetFocus;
         If tekedit=13 then
            form2.Edit13.SetFocus;
         If tekedit=3 then
            form2.Edit3.SetFocus;
         If tekedit=15 then
            form2.Edit15.SetFocus;
          If tekedit=4 then
            form2.Edit4.SetFocus;
         If tekedit=17 then
            form2.Edit17.SetFocus;
         form2.SelectNext(ActiveControl,true,true);
         end;

         form2.stringgrid1.Visible:=false;
         exit;
       end;

    // Контекcтный поиск номера автобуса
   if (form2.Edit8.Visible=false) and (form2.stringgrid1.Visible=false) and (form2.Edit7.focused) then
     begin
       If (get_type_char(key)>0) or (key=8) or (key=46) or (key=96) then //8-backspace 46-delete 96- numpad 0
       begin
         form2.Edit8.text:='';
         form2.Edit8.Visible:=true;
         form2.Edit8.SetFocus;
       end;
     end;


    //поиск данных водителя продолжаем вводить текст, несмотря ни что :)
    If ((key=8) or (key>45)) and form2.stringgrid1.Visible and form2.stringgrid1.Focused
       //and (((form2.Edit11.Text='') and (form2.Edit13.Text=''))
         //or ((form2.Edit15.Text='') and (form2.Edit18.Text=''))
         //or (form2.Edit4.Text='') or (form2.Edit5.Text=''))
       then
     begin
          If tekedit=2 then
           begin
            form2.Edit2.SetFocus;
            form2.Edit2.SelStart:=utf8length(form2.Edit2.Text);
            form2.Edit2.SelLength:=0;
           end;
         If tekedit=13 then
           begin
            form2.Edit13.SetFocus;
            form2.Edit13.SelStart:=utf8length(form2.Edit13.Text);
            form2.Edit13.SelLength:=0;
           end;
         If tekedit=3 then
           begin
            form2.Edit3.SetFocus;
            form2.Edit3.SelStart:=utf8length(form2.Edit3.Text);
            form2.Edit3.SelLength:=0;
           end;
         If tekedit=15 then
           begin
            form2.Edit15.SetFocus;
            form2.Edit15.SelStart:=utf8length(form2.Edit15.Text);
            form2.Edit15.SelLength:=0;
           end;
          If tekedit=4 then
           begin
            form2.Edit4.SetFocus;
            form2.Edit4.SelStart:=utf8length(form2.Edit4.Text);
            form2.Edit4.SelLength:=0;
           end;
         If tekedit=17 then
           begin
            form2.Edit17.SetFocus;
            form2.Edit17.SelStart:=utf8length(form2.Edit17.Text);
            form2.Edit17.SelLength:=0;
           end;

         //form2.stringgrid1.Visible:=false;
         //form2.stringgrid1.Height:=30;
         //form2.stringgrid1.RowCount:=0;
         //form2.stringgrid1.Top:=625;
     end;

     //поиск данных водителя
    //If (key>45) and (form2.stringgrid1.Visible=false)
      //and  (((form2.Edit11.Text='') and (form2.Edit13.Text='') and form2.Edit2.focused)
         //or ((form2.Edit15.Text='') and (form2.Edit18.Text='') and form2.Edit3.focused)
         //or ((form2.Edit4.Text='') and form2.Edit4.focused) or ((form2.Edit5.Text='') and form2.Edit5.focused))
     //  then
     //begin
     //
     //end;
    //поиск данных водителя
    //If (key>0) and (form2.stringgrid1.Visible=true)
    //   and (((form2.Edit11.Text='') and (form2.Edit13.Text=''))
    //     or ((form2.Edit15.Text='') and (form2.Edit18.Text=''))
    //     or (form2.Edit4.Text='') or (form2.Edit5.Text='')) then
    // begin
    //  If form2.Edit2.focused and (utf8length(form2.Edit2.Text)<4) then
    //    form2.stringgrid1.Visible:=false;
    //  If form2.Edit3.focused and (utf8length(form2.Edit3.Text)<4) then
    //    form2.stringgrid1.Visible:=false;
    //  If form2.Edit4.focused and (utf8length(form2.Edit4.Text)<4) then
    //    form2.stringgrid1.Visible:=false;
    //  If form2.Edit5.focused and (utf8length(form2.Edit5.Text)<4) then
    //    form2.stringgrid1.Visible:=false;
    // end;
end;

procedure TForm2.CheckBox1Change(Sender: TObject);
begin

 //если незаявленное тс
  If Form2.CheckBox1.Checked=true then
  begin
   flchange:=true;
   form2.Edit9.Visible:=true;
   form2.Edit10.Visible:=true;
   form2.Label50.Visible:=true;
   form2.Label51.Visible:=true;
   form2.Edit7.Visible:=false;
   form2.Label6.Visible:=false;
   form2.Edit9.Clear;
   form2.Edit10.Clear;
   form2.Edit9.SetFocus;
  end;
  If not checkstate then exit;
  If Form2.CheckBox1.Checked=false then
  begin
   form2.Edit9.Visible:=false;
   form2.Edit10.Visible:=false;
   form2.Label50.Visible:=false;
   form2.Label51.Visible:=false;
   form2.Edit7.Visible:=true;
   form2.Label6.Visible:=true;
   form2.Edit9.Clear;
   form2.Edit10.Clear;
   form2.Edit7.SetFocus;
  end;
end;

procedure TForm2.CheckBox1Enter(Sender: TObject);
begin
  form2.Bevel1.Visible:=true;
  checkstate:=true;
end;

procedure TForm2.CheckBox1Exit(Sender: TObject);
begin
  If form2.CheckBox1.Checked=false then form2.Bevel1.Visible:=false;
  checkstate:=false;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
  flchange:=true;
end;

procedure TForm2.Edit11Change(Sender: TObject);
begin
  If trim(form2.Edit11.Caption)='' then
  begin
     form2.Edit12.caption:='';
     form2.Edit12.Enabled:=false;
   end
    else
      If not form2.Edit12.Enabled then form2.Edit12.Enabled:=true;
end;


//ввод серии и номера документа
procedure TForm2.Edit13KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If flchange then exit;
 If ((key>32) and (key<46)) or ((key>57) and (key<63)) or ((key>90) and (key<97)) then exit;//кавычки, точки, запятые, слэши
 flchange:=true;
end;


//серия номер документа водитель 2
procedure TForm2.Edit13KeyPress(Sender: TObject; var Key: char);
begin
 //кавычки, точки, запятые, слэши
  If ((ord(key)>32) and (ord(key)<46)) or ((ord(key)>57) and (ord(key)<63)) or ((ord(key)>90) and (ord(key)<97))
    then key:=#0;
    //If ord(key)>110 then key:=#0;
    //If (ord(key)>41) and (ord(key)<48) then key:=#0;
    //If (ord(key)>57) and (ord(key)<97) then key:=#0;
    //If (ord(key)=92) then key:=#0; //клавиша \
      If key<>#0 then
     begin
       openforedit();
     end;
end;


procedure TForm2.Edit18Change(Sender: TObject);
begin
   If trim(form2.Edit18.Caption)='' then
     begin
     form2.Edit19.caption:='';
     form2.Edit19.Enabled:=false;
   end
    else
      If not form2.Edit19.Enabled then form2.Edit19.Enabled:=true;
end;


procedure TForm2.Edit20Change(Sender: TObject);
begin
   If trim(form2.Edit20.Caption)='' then
     begin
     form2.Edit21.caption:='';
     form2.Edit21.Enabled:=false;
   end
    else
      If not form2.Edit21.Enabled then form2.Edit21.Enabled:=true;
end;


//нажатие клавиши на ФИО водителя
procedure TForm2.Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (get_type_char(key)=1) then flchange:=false;
  If ((key>32) and (key<46)) or ((key>57) and (key<63)) or ((key>90) and (key<97)) then flchange:=false;//кавычки, точки, запятые, слэши

 //DELETE
  If (key=8) or (key=46) then
   begin
   notfindflag:=true;
    If famildlina>2 then
      famildlina:=famildlina-1
     else famildlina:=0;
    //dec(famildlina);
   //form2.Label38.Caption:=inttostr(famildlina);//$
   //If famildlina<minstrsearch then famildlina:=99;
   end
  else  notfindflag:=false;
 If flchange then exit;
 flchange:=true;
  //showmessage(inttostr(key));


  //If flchange then

  //else                          form2.Label38.Caption:='------';
end;

//водитель 1 ФАМИЛИЯ
procedure TForm2.Edit2KeyPress(Sender: TObject; var Key: char);
begin
   If (get_type_char(ord(key))=1) then key:=#0;
   If ((ord(key)>32) and (ord(key)<46)) or ((ord(key)>57) and (ord(key)<63)) or ((ord(key)>90) and (ord(key)<97)) then key:=#0;//кавычки, точки, запятые, слэши
   //showmessage(chr(44)+#13+chr(46)+#13+chr(47)+#13+chr(39)+#13+chr(59)+#13+chr(92));
   //If (ord(key)=44) or (ord(key)=46) or (ord(key)=47) or (ord(key)=39) or (ord(key)=59) or (ord(key)=92)  then key:=#0;//кавычки, точки, запятые, слэши
   //If key<>#0 then
   //  begin
   //  form2.Edit11.enabled:=true;
   //  end;
    If key<>#0 then
     begin
      openforedit();
     end;

end;


procedure TForm2.Edit8Change(Sender: TObject);
begin
  ats_search(0);
end;


procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   //if flChange then
   // begin
   // If DialogMess('Внесенные изменения НЕ будут сохранены !'+#13+'Продолжить выход ?',mtConfirmation, mbYesNo, 0)=7 then
   //  begin
   //   CloseAction := caNone;
   //   exit;
   //  end;
   // end;
   setlength(tmp_atp,0,0);
   setlength(tmp_ats,0,0);
   tmp_atp:=nil;
   tmp_ats:=nil;
   setlength(megamas,0);
   megamas:=nil;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;


procedure TForm2.FormPaint(Sender: TObject);
begin
   //form2.Canvas.Brush.Color:=clSilver;
   form2.Canvas.Pen.Color:=clBlack;
   form2.Canvas.Pen.Width:=2;
   form2.Canvas.Rectangle(2,2,form2.Width-2,form2.Height-2);
end;


// ЗАГРУЖАЕМ СПИСОК АТС ДЛЯ СОЗДАНИЯ ЗАКАЗНОГО РЕЙСА
procedure TForm2.get_ats_zakaz;
var
   n:integer;
   findats:boolean;
begin
  form2.Label2.Caption:='1';//всего перевозчиков

  If not(Connect2(form2.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k17-');
     form2.close;
    end;
 // ------------------------- Определяем список атс для выбранного ПЕРЕВОЗЧИКа ----------------------
If length(tmp_atp)>0 then
 begin
  form2.ZReadOnlyQuery1.SQL.Clear;
  //form2.ZReadOnlyQuery1.SQL.Add('select distinct (f.id_ats),     ');
  //form2.ZReadOnlyQuery1.SQL.Add('f.id_kontr,');
  //form2.ZReadOnlyQuery1.SQL.Add('(select g1.name from av_spr_ats g1 where g1.del=0 and g1.id=f.id_ats) as name, ');
  //form2.ZReadOnlyQuery1.SQL.Add('(select g2.gos from av_spr_ats g2 where g2.del=0 and g2.id=f.id_ats) as gos, ');
  //form2.ZReadOnlyQuery1.SQL.Add('(select (g3.m_down+g3.m_down_two+g3.m_lay+g3.m_lay_two) from av_spr_ats g3 where g3.del=0 and g3.id=f.id_ats ');
  //form2.ZReadOnlyQuery1.SQL.Add(') as kol_mest,                                                          ');
  //form2.ZReadOnlyQuery1.SQL.Add('(select g4.type_ats from av_spr_ats g4 where g4.del=0 and g4.id=f.id_ats   ');
  //form2.ZReadOnlyQuery1.SQL.Add(') as type_ats                                                                 ');
  //form2.ZReadOnlyQuery1.SQL.Add('from av_shedule_ats f ');
  //form2.ZReadOnlyQuery1.SQL.Add('where f.del=0 and        ');
  //form2.ZReadOnlyQuery1.SQL.Add('      f.id_kontr='+trim(tmp_atp[0,0])+';');
  form2.ZReadOnlyQuery1.SQL.Add('Select b.id_kontr,b.id_ats,a.name,a.gos,');
  form2.ZReadOnlyQuery1.SQL.Add('(a.m_down+a.m_down_two+a.m_lay+a.m_lay_two) as kol_mest,a.type_ats ');
  Form2.ZReadOnlyQuery1.SQL.add('FROM av_spr_ats AS a, av_spr_kontr_ats AS b ');
  Form2.ZReadOnlyQuery1.SQL.add('WHERE b.id_ats=a.id and a.del=0 and b.del=0 and b.id_kontr='+trim(tmp_atp[0,0]));
   Form2.ZReadOnlyQuery1.SQL.add(' ORDER BY kol_mest;');
  //form2.ZReadOnlyQuery1.SQL.Add('FROM av_shedule_ats f ');
  //form2.ZReadOnlyQuery1.SQL.Add('LEFT JOIN av_spr_ats g ON g.del=0 AND g.id=f.id_ats ');
  //form2.ZReadOnlyQuery1.SQL.Add('WHERE f.del=0 AND f.id_kontr='+trim(tmp_atp[0,0])+';');
  //showmessage(form2.ZReadOnlyQuery1.SQL.Text);//$
  try
      form2.ZReadOnlyQuery1.open;
  except
         showmessagealt('Нет данных по расписанию !!!'+#13+'Сообщите об этом АДМИНИСТРАТОРУ !!!'+#13+'--k9');
         form2.ZReadOnlyQuery1.Close;
         form2.Zconnection1.disconnect;
         form2.Close;
  end;
 end;
   form2.SpinEdit2.Value:=0;//текущее атс
   form2.Label4.Caption:='0';//всего атс
   findats:=false;
// Заполняем массив по АТС данными
   SetLength(tmp_ats,0,0);
   If form2.ZReadOnlyQuery1.RecordCount>0 then
    begin
     for n:=1 to form2.ZReadOnlyQuery1.RecordCount do
       begin
         SetLength(tmp_ats,length(tmp_ats)+1,7);
         // id_kontr
         tmp_ats[length(tmp_ats)-1,0]:=form2.ZReadOnlyQuery1.FieldByName('id_kontr').asString;
         // id_ats
         tmp_ats[length(tmp_ats)-1,1]:=form2.ZReadOnlyQuery1.FieldByName('id_ats').asString;
         // name_ats
         tmp_ats[length(tmp_ats)-1,2]:=form2.ZReadOnlyQuery1.FieldByName('name').asString;
         // nom_ats
         tmp_ats[length(tmp_ats)-1,3]:=form2.ZReadOnlyQuery1.FieldByName('gos').asString;
         // kol_mest
         tmp_ats[length(tmp_ats)-1,4]:=form2.ZReadOnlyQuery1.FieldByName('kol_mest').asString;
         // type_ats
         tmp_ats[length(tmp_ats)-1,5]:=form2.ZReadOnlyQuery1.FieldByName('type_ats').asString;
         tmp_ats[length(tmp_ats)-1,6]:=inttostr(n); //порядковый номер атс перевозчика
        //ищем текущий атс в массиве
        if (tmp_ats[length(tmp_ats)-1,1]=ats_id)  then
           begin
             findats:=true;
             tek_mas_ats:=length(tmp_ats)-1;
             fill_ats(tek_mas_ats);
           end;
         form2.ZReadOnlyQuery1.Next;
       end;


      If not findats then
         begin
          tek_mas_ats:=0;
          fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
         end;

    end;
  form2.ZReadOnlyQuery1.Close;
  form2.Zconnection1.disconnect;
   tmp_atp[0,2]:=inttostr(n);//всего атс перевозчика
   form2.Label4.Caption:=tmp_atp[0,2];//всего атс
   form2.SpinEdit1.Value:=tek_mas_atp+1;//текущий перевозчик

end;


//**********************   Расчет списка атп и атс для текущего рейса  ********************************
procedure TForm2.get_shedule_atp_ats;
var
   n,m,k:integer;
   findatp,findats:boolean;
   atp_list:string;
begin
  findatp:=false;
  findats:=false;
  atp_list:='';
  // -------------------- Соединяемся с локальным сервером ----------------------
   If not(Connect2(form2.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k10-');
     form2.close;
    end;
  // ------------------------- Определяем контрагентов по договору и лицензии относительно расписания ----------------------
  form2.ZReadOnlyQuery1.SQL.Clear;
  form2.ZReadOnlyQuery1.SQL.Add('select * ');
  form2.ZReadOnlyQuery1.SQL.Add(',(select count(*) from av_shedule_ats where del=0 and id_kontr=a.id_kontr and id_shedule='+full_mas[idx,1]+') as all_ats ');
  form2.ZReadOnlyQuery1.SQL.Add('FROM ');
  form2.ZReadOnlyQuery1.SQL.Add('( ');
  form2.ZReadOnlyQuery1.SQL.Add('select distinct b.id_kontr,k.name_kontr');
  form2.ZReadOnlyQuery1.SQL.Add('from av_trip_dog_lic b,av_trip_atp_ats k ');
  form2.ZReadOnlyQuery1.SQL.Add('where k.id_shedule='+full_mas[idx,1]);
  //form2.ZReadOnlyQuery1.SQL.Add(' (select t.id_kontr from av_shedule_atp t where t.del=0 and t.id_shedule='+trim(full_mas[idx,1]));
  form2.ZReadOnlyQuery1.SQL.Add(' and b.datepo>='+quotedstr(tripdate)+' and b.dates<='+quotedstr(tripdate)+' and k.id_kontr=b.id_kontr ) a;');
  //showmessage(form2.ZReadOnlyQuery1.SQL.Text);//$
  try
      form2.ZReadOnlyQuery1.open;
  except
         showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
         form2.ZReadOnlyQuery1.Close;
         form2.Zconnection1.disconnect;
         form2.Close;
         exit;
  end;
  IF form2.ZReadOnlyQuery1.RecordCount=0 then
    begin
      showmessagealt('Нет данных по ПЕРЕВОЗЧИКАМ для выбранного расписания !!!'+#13+'Обратитесь в отдел Пассажирских перевозок...'+#13+'--k11');
      form2.ZReadOnlyQuery1.Close;
      form2.Zconnection1.disconnect;
      form2.Close;
      exit;
    end;
// Заполняем массив по перевозчикам данными
   form2.SpinEdit1.Value:=0;//текущий перевозчик
   form2.Label2.Caption:='0';//всего перевозчиков
   SetLength(tmp_atp,0,0);
   If form2.ZReadOnlyQuery1.RecordCount>0 then
    begin
     for n:=0 to form2.ZReadOnlyQuery1.RecordCount-1 do
       begin
         SetLength(tmp_atp,length(tmp_atp)+1,3);
         tmp_atp[length(tmp_atp)-1,0]:=trim(form2.ZReadOnlyQuery1.FieldByName('id_kontr').asString);
         atp_list:=atp_list+tmp_atp[length(tmp_atp)-1,0]+',';
         tmp_atp[length(tmp_atp)-1,1]:=trim(form2.ZReadOnlyQuery1.FieldByName('name_kontr').asString);
         tmp_atp[length(tmp_atp)-1,2]:=trim(form2.ZReadOnlyQuery1.FieldByName('all_ats').asString);
         if (tmp_atp[length(tmp_atp)-1,0]=kontr_id) then
           begin
             findatp:=true;
             tek_mas_atp:=length(tmp_atp)-1;
             fill_atp(tek_mas_atp);
           end;
         form2.ZReadOnlyQuery1.Next;
       end;
    If length(atp_list)>0 then atp_list:=copy(atp_list,1,length(atp_list)-1);
      If not findatp then
       begin
          tek_mas_atp:=0;
          fill_atp(tek_mas_atp);
          ats_id:='0';
       end;

   form2.Label2.Caption:=inttostr(n+1);//всего перевозчиков
    end;

 // ------------------------- Определяем список атс для ПЕРЕВОЗЧИКа ----------------------
   findatp:=false;
   form2.SpinEdit2.Value:=0;//текущее атс
   form2.Label4.Caption:='0';//всего атс
// Заполняем массив по АТС данными
   SetLength(tmp_ats,0,0);


If length(tmp_atp)>0 then
 begin
  form2.ZReadOnlyQuery1.SQL.Clear;
  form2.ZReadOnlyQuery1.SQL.Add('Select f.id_kontr,f.id_ats,f.id_shedule,g.name,g.gos,');
  form2.ZReadOnlyQuery1.SQL.Add('(g.m_down+g.m_down_two+g.m_lay+g.m_lay_two) as kol_mest,g.type_ats ');
  form2.ZReadOnlyQuery1.SQL.Add('FROM av_shedule_ats f ');
  form2.ZReadOnlyQuery1.SQL.Add('LEFT JOIN av_spr_ats g ON g.del=0 AND g.id=f.id_ats ');
  form2.ZReadOnlyQuery1.SQL.Add('WHERE f.del=0 AND f.id_shedule='+trim(full_mas[idx,1])+' AND f.id_kontr in ('+atp_list+') ');
  //form2.ZReadOnlyQuery1.SQL.Add('(select distinct b.id_kontr ');
  //form2.ZReadOnlyQuery1.SQL.Add('from av_trip_dog_lic b WHERE b.id_kontr in ');
  //form2.ZReadOnlyQuery1.SQL.Add('(select t.id_kontr from av_shedule_atp t where t.del=0 and t.id_shedule='+trim(full_mas[idx,1]));
  //form2.ZReadOnlyQuery1.SQL.Add(') and      ');
  //form2.ZReadOnlyQuery1.SQL.Add('(b.datepo>='+quotedstr(tripdate)+' and b.dates<='+quotedstr(tripdate)+'))  ');
  Form2.ZReadOnlyQuery1.SQL.add(' ORDER BY kol_mest;');
  //showmessage(form2.ZReadOnlyQuery1.SQL.Text);//$
  try
      form2.ZReadOnlyQuery1.open;
    except
      showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
         form2.ZReadOnlyQuery1.Close;
         form2.Zconnection1.disconnect;
         form2.Close;
         exit;
    end;
 IF form2.ZReadOnlyQuery1.RecordCount=0 then
    begin
      showmessagealt('Нет данных по АТС перевозчика: '+kontr_name+' на расписании !'+#13+'Обратитесь в отдел Пассажирских перевозок...'+#13+'--k13');
      form2.ZReadOnlyQuery1.Close;
      form2.Zconnection1.disconnect;
      form2.Close;
      exit;
    end;

   form2.ZReadOnlyQuery1.First;
     for n:=0 to form2.ZReadOnlyQuery1.RecordCount-1 do
       begin
         SetLength(tmp_ats,length(tmp_ats)+1,7);
         // id_kontr
         tmp_ats[length(tmp_ats)-1,0]:=trim(form2.ZReadOnlyQuery1.FieldByName('id_kontr').asString);
         // id_ats
         tmp_ats[length(tmp_ats)-1,1]:=form2.ZReadOnlyQuery1.FieldByName('id_ats').asString;
         // name_ats
         tmp_ats[length(tmp_ats)-1,2]:=form2.ZReadOnlyQuery1.FieldByName('name').asString;
         // nom_ats
         tmp_ats[length(tmp_ats)-1,3]:=form2.ZReadOnlyQuery1.FieldByName('gos').asString;
         // kol_mest
         tmp_ats[length(tmp_ats)-1,4]:=form2.ZReadOnlyQuery1.FieldByName('kol_mest').asString;
         // type_ats
         tmp_ats[length(tmp_ats)-1,5]:=form2.ZReadOnlyQuery1.FieldByName('type_ats').asString;
         tmp_ats[length(tmp_ats)-1,6]:=inttostr(n+1); //порядковый номер атс у перевозчика
         //ищем текущий атс в массиве
        if (trim(form2.ZReadOnlyQuery1.FieldByName('id_kontr').asString)=kontr_id) and (tmp_ats[length(tmp_ats)-1,1]=ats_id)  then
           begin
             findatp:=true;
             tek_mas_ats:=length(tmp_ats)-1;
             fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
           end;
         form2.ZReadOnlyQuery1.Next;
       end;
            //showmessage(tmp_atp[m,0]+'='+inttostr(k));
     //showmessage(tmp_atp[m,0]+#13+inttostr(k));
     If not findatp then
         begin
          tek_mas_ats:=0;
          fill_ats(tek_mas_ats);//заполнить переменные и поле АТС
         end;
    form2.Label4.Caption:=tmp_atp[tek_mas_atp,2];//всего атс перевозчика
   end;

  form2.ZReadOnlyQuery1.Close;
  form2.Zconnection1.disconnect;
end;


//***************************** ************
procedure TForm2.DateTimePicker1Change(Sender: TObject);
begin
If not flset then
 getz_date();
end;


// Настраиваем форму
procedure TForm2.set_form(oper:byte);
var
  res:string;
begin
  flset:=true;
  zkaz:= false;
  udalenka_real:=false;
  udalenka_virt:=false;
  drv1:='';
  drv2:='';
  drv3:='';
  doc1:='';
  doc2:='';
  doc3:='';
  notfindflag:=true;
  flseek:=false;
 // Определяем рейс в массиве
 idx:=-1;
 idx:= masindex;
  if idx=-1 then
   begin
     showmessagealt('Нет данных о текущем рейсе !'+#13+'Проверьте параметры маршрутной сети...'+#13+'--k15');
     form2.close;
   end;

 //showmessage(full_mas[idx,1]+full_mas[idx,19]+full_mas[idx,21]);
 // строка наименование рейса
 form2.Label37.Caption:='['+full_mas[idx,1]+'] '+trim(full_mas[idx,5])+' - '+trim(full_mas[idx,8]);
 form2.Label48.Caption:='--';
 form2.Edit1.Text:='';

 //form2.edit1.Text:='['+trim(full_mas[idx,18])+'] '+trim(full_mas[idx,19]);

 If full_mas[idx,16]='1' then
    begin
      up_time := full_mas[idx,10];
      up_point:= full_mas[idx,3];
      up_order:= full_mas[idx,4];
    end
  else
  begin
    up_time := full_mas[idx,12];
    up_point:= full_mas[idx,6];
    up_order:= full_mas[idx,7];

    //если прибытие - недоступно незаявленное ТС
    form2.CheckBox1.Visible:=false;
    form2.Label6.Visible:=false;
    form2.Label52.Visible:=false;
  end;

  //id перевозчика
   kontr_id:= full_mas[idx,18];
   kontr_name:= full_mas[idx,19];
   //id ats
   ats_id:=   full_mas[idx,20];
   ats_mest:= full_mas[idx,25];
   ats_type:= full_mas[idx,27];
   ats_name:= full_mas[idx,21];
   //If utf8pos('ГН:',full_mas[idx,21])>0 then
   //ats_name:=utf8copy(full_mas[idx,21],1,utf8pos('ГН:',full_mas[idx,21])-1);
   //ats_gos:= utf8copy(full_mas[idx,21],utf8pos('ГН:',full_mas[idx,21])+3,utf8length(full_mas[idx,21])-utf8pos('ГН:',full_mas[idx,21])-3);
   //ats_gos:= stringreplace(ats_gos,#32,'',[rfReplaceAll, rfIgnoreCase]);
 //If not((ats_type='') or (ats_name='')) then
 //form2.edit7.Text:='['+IFTHEN(ats_type='1','M2','M3')+'] '+ ats_name+' ГН:'+ ats_gos;
 //form2.Label48.Caption:=ats_mest;
   //showmessagealt(ats_name+#13+ats_gos);//$

   put:= full_mas[idx,35];
   //dr1:= full_mas[idx,36];
   //dr2:= full_mas[idx,37];
   //dr3:= full_mas[idx,38];
   //dr4:= full_mas[idx,39];

   //если незаявленное ТС
   If utf8pos('|',full_mas[idx,33])>0 then
    begin
      checkbox1.Checked:=true;
      real_avto:=utf8copy(full_mas[idx,33],1,utf8pos('|',full_mas[idx,33])-1);//марка
      form2.edit9.text:=real_avto;
      real_reg_sign:=utf8copy(full_mas[idx,33],utf8pos('|',full_mas[idx,33])+1,utf8length(full_mas[idx,33])-utf8pos('|',full_mas[idx,33]));//номер
      form2.edit10.text:=real_reg_sign;
    end;

 tripdate:=datetostr(work_date);
  //проверка на удаленный рейс
   //если рейс удаленки
  If (trim(full_mas[idx,0])='3') or (trim(full_mas[idx,0])='4') or (trim(full_mas[idx,0])='5') then
  begin
     If (trim(full_mas[idx,0])='5') then udalenka_virt:=true
     else udalenka_real:=true;
     label49.Caption:=otkuda_name;
     label49.Visible:=true;
     tripdate:=full_mas[idx,11];
  end;
 //если рейс заказной или рейс заказной удаленки
 if (trim(full_mas[idx,0])='2') or (trim(full_mas[idx,0])='4') or (trim(full_mas[idx,0])='5') then
 begin
   zkaz:=true;
   SetLength(tmp_atp,0,0);
   SetLength(tmp_atp,1,3);
   tmp_atp[0,0]:=kontr_id;
   tmp_atp[0,1]:=kontr_name;
   tek_mas_atp:=0;
   fill_atp(tek_mas_atp);
   get_ats_zakaz;
 end;

 //Параметры отправления рейса
If oper=1 then
  begin
 // Верхняя строка заголовка
 form2.Label36.Caption:='Отправление рейса:';

 //время отправления
 form2.DateTimePicker1.Time:=strtotime(full_mas[idx,10]);
 form2.DateTimePicker1.Enabled:=false;
 form2.DateTimePicker1.Refresh;
  end;

//Параметры прибытия рейса
If oper=2 then
 begin
 // Верхняя строка заголовка
 form2.Label36.Caption:='Прибытие рейса:';
 //время прибытия
 form2.DateTimePicker1.Time:=strtotime(full_mas[idx,12]);
 form2.DateTimePicker1.Enabled:=false;
 end;

//Параметры создания ЗАКАЗНОГО рейса
If oper=11 then
begin
  zkaz:=true;
// Верхняя строка заголовка
form2.Label36.Caption:='Создание ЗАКАЗНОГО РЕЙСА на '+tripdate;
// Новое время отправления
If days_before<5 then
def_time:=strtotime(full_mas[idx,10])+strtotime('00:01');
form2.DateTimePicker1.Time:=def_time;
form2.DateTimePicker1.Enabled:=true;
form2.DateTimePicker1.SetFocus;
flset:=false;
exit;
end;


//заполняем форму инфой
//водитель 1
If decode_personal(2,full_mas[idx,36])<>'1' then
form2.Edit2.Text:= full_mas[idx,36];
//водитель 2
If decode_personal(3,full_mas[idx,37])<>'1' then
form2.Edit3.Text:= full_mas[idx,37];
//документ 1, водитель 3
If full_mas[idx,38]<>'' then
begin
 res:='';
 If utf8pos('@',full_mas[idx,38])>0 then
 begin
   res:=decode_personal(13,utf8copy(full_mas[idx,38],1,utf8pos('@',full_mas[idx,38])-1));
    If utf8pos('&',full_mas[idx,38])>0 then
    begin
    //водитель 3 имя
      res:=decode_personal(4,utf8copy(full_mas[idx,38],utf8pos('@',full_mas[idx,38])+1,utf8pos('&',full_mas[idx,38])-utf8pos('@',full_mas[idx,38])-1));
    //водитель 3 док
      res:=decode_personal(17,utf8copy(full_mas[idx,38],utf8pos('&',full_mas[idx,38])+1,utf8length(full_mas[idx,38])-utf8pos('&',full_mas[idx,38])));
      end
    else
    begin
     //водитель 3 имя
      res:=decode_personal(4,utf8copy(full_mas[idx,38],utf8pos('@',full_mas[idx,38])+1,utf8length(full_mas[idx,38])));
    end;
 end
 else
 begin
    res:=decode_personal(13,full_mas[idx,38]);
   end;
 If res<>'1' then
   form2.Edit13.Caption:=full_mas[idx,38];
end;
//документ2, водитель 4
If full_mas[idx,39]<>'' then
begin
res:='';
If utf8pos('@',full_mas[idx,39])>0 then
begin
  res:=decode_personal(15,utf8copy(full_mas[idx,39],1,utf8pos('@',full_mas[idx,39])-1));

   //If utf8pos('&',full_mas[idx,39])>0 then
   //begin
   //водитель 3 имя
     //res:=decode_personal(4,utf8copy(full_mas[idx,39],utf8pos('@',full_mas[idx,39])+1,utf8length(full_mas[idx,39])-utf8pos('&',full_mas[idx,39])-1));
   //водитель 3 док
     //res:=decode_personal(17,utf8copy(full_mas[idx,39],utf8pos('&',full_mas[idx,39])+1,utf8length(full_mas[idx,39])));
     //end
   //else
   //begin
    //водитель 3 имя
     //res:=decode_personal(4,utf8copy(full_mas[idx,39],utf8pos('@',full_mas[idx,39])+1,utf8length(full_mas[idx,39])));
   //end;
end
else
begin
   res:=decode_personal(15,full_mas[idx,39]);
  end;
If res<>'1' then
  form2.Edit15.Caption:=full_mas[idx,39];
end;

isfio:=form2.checkinfio;//передавать данные или нет
If isfio then form2.groupbox1.Height:=155;
 openforedit();

 If (oper<>11) and not zkaz then
  begin
  //забираем доступных перевозчиков и атс если рейс не заказной
    form2.get_shedule_atp_ats;
  end;
 //запросить данные по операциям конкретно над этим рейсом
   //form2.getdisp_oper(idx);

   //флаг критичного изменения типа автобуса с M3 на M2
   ticket_canceled:=false;
   If ats_type='2' then ticket_canceled:=true;

 form2.Edit6.Text:= put;
 //dr1:= ;
   //dr2:= full_mas[idx,37];
   //dr3:= full_mas[idx,38];
   //dr4:= full_mas[idx,39];


 //Смена АТП И АТС
If (oper=5) OR (oper=7) then
 begin
   //время
If trim(full_mas[idx,16])='1' then
 form2.DateTimePicker1.Time:=strtotime(full_mas[idx,10])
 else
    form2.DateTimePicker1.Time:=strtotime(full_mas[idx,12]);
// Верхняя строка заголовка
If oper=5 then
 begin
 form2.Label36.Caption:='Смена перевозчика:';
  form2.Edit1.SetFocus;
 end;
If oper=7 then
  begin
  form2.Label36.Caption:='Смена АТС:';
  form2.Edit1.Enabled:=false;
  form2.Edit7.SetFocus;
  end;
 form2.DateTimePicker1.Enabled:=false;
 form2.GroupBox1.Enabled:=false;
 form2.GroupBox2.Enabled:=false;
end;

 //form2.edit7.Text:='['+trim(full_mas[idx,20])+'] '+'['+IFTHEN(trim(full_mas[idx,27])='1','M2','M3')+']'+trim(full_mas[idx,21]);
 flset:=false;
end;


//*********************************************** ВОЗНИКНОВЕНИЕ ФОРМЫ  ******************************************************
procedure TForm2.FormShow(Sender: TObject);
begin
//Выравниваем форму
 form2.Left:=form1.Left+(form1.Width div 2)-(form2.Width div 2);
 form2.Top:=form1.Top+(form1.Height div 2)-(form2.Height div 2);

 fl_transact:=true;//флаг подтверждения блокировки рейса
 active_check:=false;//флаг выполнения операции диспетчера
 checkstate:=false;//флаг изменения чека на незаявленное тс

 form2.StringGrid1.Visible:=false;
 form2.ComboBox2.ItemIndex:=0;
 form2.ComboBox4.ItemIndex:=0;
 form2.ComboBox6.ItemIndex:=0;
 form2.GroupBox3.visible:=false;
 form2.GroupBox1.Height:=65;
 form2.GroupBox2.Height:=65;
 form2.GroupBox3.Height:=65;
  ggg:=0;//$
  tekedit:=0;
  form2.set_form(operation); //инициализация объектов формы


  //showmas(tmp_atp);
  IF (operation=11) and (perenos_biletov>-1)
     then form2.Label5.Visible:=true;
  If zkaz then exit;
  //если смена АТП
  If operation=5 then
    begin
      If length(tmp_atp)=1 then
        If tmp_atp[0,0]=kontr_id then
          begin
          showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'на данном расписании ЕДИНСТВЕННЫЙ ПЕРЕВОЗЧИК !');
          FORM2.Close;
          exit;
        end;
    end;
  //если смена АТП
  If operation=7 then
    begin
      If length(tmp_ats)=1 then
       If tmp_ats[0,1]=ats_id then
          begin
          showmessagealt('ОПЕРАЦИЯ НЕДОПУСТИМА !'+#13+'у перевозчика ЕДИНСТВЕННОЕ АТС на расписании !');
          FORM2.Close;
          exit;
        end;
    end;
end;


end.

