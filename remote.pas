unit remote;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,  LazFileUtils, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Grids, StdCtrls, LazUTF8, EditBtn, ComCtrls, dateutils, LCLType, menu;

type

  { TForm6 }

  TForm6 = class(TForm)
    Bevel2: TBevel;
    ComboBox1: TComboBox;
    DateEdit1: TDateEdit;
    Edit1: TEdit;
    IdleTimer1: TIdleTimer;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Shape2: TShape;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    ZConnection1: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
   procedure fill_grid_otkuda; // Заполняем GRID откуда
   procedure fill_grid_kuda();// Заполняем GRID куда
   procedure Fill_kuda; // Заполняем массив куда
   procedure Fill_grid_date;// Рисуем GRID дат
   procedure FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
   procedure IdleTimer1Timer(Sender: TObject);
    //НОВЫЙ расчет рейсов для локальной системы
   procedure rascet_rejs_local;
   procedure StringGrid3Selection(Sender: TObject; aCol, aRow: Integer);
   procedure fill_grid_rejs;// Заполняем GRID рейсами и выводим его
   procedure StringGrid4DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
   procedure add_fullmas;
   procedure fillcombo;
  private
    { private declarations }
  public
    { public declarations }
    procedure MyExceptionHandler(Sender : TObject; E : Exception); //ОБРАБОТЧИК ИСКЛЮЧЕНИЙ  *********
  end;

var
  Form6: TForm6;

implementation

{$R *.lfm}
uses
  platproc,maindisp;

{ TForm6 }
var
  mas_kuda:array of array of String;
   // ----------- ПЕРЕМЕННЫЕ РЕЙСА ------------ //
  id_otkuda,id_kuda:integer; // id остановочных пунктов откуда и куда
  rdate:TDate; // Дата рейса
  rid:integer;  // Номер выбранного рейса в массиве рейсов
  rejs_mas:array of array of string;
  twhere:string;
  virtuals:boolean;

  //************************************ ОБРАБОТЧИК ИСКЛЮЧЕНИЙ  **************************************
procedure TForm6.MyExceptionHandler(Sender : TObject; E : Exception);
begin
  showmessagealt('Ошибка программы 6'+#13+'Сообщение: '+E.Message+#13+'Модуль: '+E.UnitName);
  E.Free;
end;


//------- заполнение комбо пунктов КУДА
procedure TForm6.fillcombo();
var
  n:integer;
begin
  // -------------------- Соединяемся с локальным сервером ----------------------
   If not(Connect2(form6.Zconnection1, 2)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     form6.close;
    end;
   form6.ZReadOnlyQuery1.sql.Clear;
   form6.ZReadOnlyQuery1.sql.add('SELECT a.id,a.name from av_spr_point a where a.del=0 order by a.name;');
  try
     form6.ZReadOnlyQuery1.open;
  except
      Panel1.Visible:=false;
      form6.ZReadOnlyQuery1.Close;
      form6.Zconnection1.disconnect;
      showmessagealt('Нет данных по СЕРВЕРАМ ПРОДАЖ !!!'+#13+'Сообщите об этом АДМИНИСТРАТОРУ !!!');
      form6.Close;
  end;
  SetLength(mas_kuda,0,0);

  // Заполняем массив КУДА
  for n:=0 to form6.ZReadOnlyQuery1.RecordCount-1 do
    begin
      SetLength(mas_kuda,length(mas_kuda)+1,2);
      mas_kuda[length(mas_kuda)-1,0]:=form6.ZReadOnlyQuery1.FieldByName('id').asString;
      mas_kuda[length(mas_kuda)-1,1]:=form6.ZReadOnlyQuery1.FieldByName('name').asString;
      form6.ZReadOnlyQuery1.Next;
    end;

  form6.ZReadOnlyQuery1.Close;
  form6.Zconnection1.disconnect;

  form6.ComboBox1.Clear;
    for n:=low(mas_kuda) to high(mas_kuda) do
     begin
       form6.ComboBox1.Items.Add(mas_kuda[n,1]);
     end;
end;



// Заполняем GRID рейсами и выводим его
procedure Tform6.fill_grid_rejs;
 var
   n:integer;
   hg:integer;
begin
  // Заполняем GRID
  for n:=0 to length(rejs_mas)-1 do
    begin
      form6.StringGrid4.RowCount:=form6.StringGrid4.RowCount+1;
      form6.StringGrid4.cells[0,form6.StringGrid4.RowCount-1]:=rejs_mas[n,1]; //номер рейса
      form6.StringGrid4.cells[1,form6.StringGrid4.RowCount-1]:=rejs_mas[n,10];//время отправления
      form6.StringGrid4.cells[2,form6.StringGrid4.RowCount-1]:=rejs_mas[n,5]+' - '+rejs_mas[n,8];//наименование
      form6.StringGrid4.cells[3,form6.StringGrid4.RowCount-1]:=rejs_mas[n,34];//мест свободно
      form6.StringGrid4.cells[4,form6.StringGrid4.RowCount-1]:=rejs_mas[n,25];//мест всего
    end;
  // Позиционируем объекты
   form6.Bevel2.Top:=125;
  //form6.StringGrid4.top:=115;
  //form6.StringGrid4.Left:=8;
  hg:=form6.StringGrid4.DefaultRowHeight*form6.StringGrid4.RowCount+5;
  if hg>form6.Height-form6.StringGrid4.top-20 then hg:=form6.Height-form6.StringGrid4.top-20;
  form6.StringGrid4.Height:=hg;
  form6.Bevel2.Height:=hg+5;
  //form6.Label9.Visible:=true;
  //form6.Label10.Visible:=false;
  form6.StringGrid4.Visible:=true;
  form6.StringGrid4.SetFocus;
  // Если используется текущая дата то ставим курсор на рейс
  // время отправления которого > текущего
  if form6.DateEdit1.Date=date() then
     begin
       for n:=0 to length(rejs_mas)-1 do
         begin
           if trim(rejs_mas[n,10])>FormatDateTime('hh:mm', now()) then
              begin
                form6.StringGrid4.Row:=n;
                break;
              end;
         end;
     end;
end;


procedure TForm6.StringGrid4DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
   n,pred,kolslow:integer;
   s1,s2,s3:string;
   activ:boolean;
begin
  with Sender as TStringGrid, Canvas do
   begin
            // mas_rejs [n,0] - номер расписания
            // mas_rejs [n,1] - время отправления
            // mas_rejs [n,2] - наименование
            // mas_rejs [n,3] - мест свободно
            // mas_rejs [n,4] - мест всего
            // mas_rejs [n,5] - id kontr
            // mas_rejs [n,6] - name kontr
            // mas_rejs [n,7] - id ats
            // mas_rejs [n,8] - name ats
            // mas_rejs [n,9] - all_mest
            // mas_rejs[n,10] - type_ats
            // mas_rejs[n,11] - status
         //if (gdSelected in aState) then
         //  begin
         //   form1.StringGrid4.RowHeights[arow]:=80;
         //  end
         //else
         //  begin
         //   form1.StringGrid4.RowHeights[arow]:=54;
         //  end;
         //form1.StringGrid4.Invalidate;
     //активность рейса
     If (aRow>0) and (trim(rejs_mas[aRow-1,22])='1') then activ:=true else activ:=false;

           // Если фокус
         if (gdSelected in aState) then
           begin
            Brush.Color:=clSkyBlue;
            FillRect(aRect);
            pen.Width:=2;
            pen.Color:=clGray;
            MoveTo(aRect.left,aRect.bottom-1);
            LineTo(aRect.right,aRect.Bottom-1);
            MoveTo(aRect.left,aRect.top-1);
            LineTo(aRect.right,aRect.Top);
           end
         else
          begin
            Brush.Color:=clWhite;
            FillRect(aRect);
            pen.Width:=2;
            pen.Color:=clGray;
            MoveTo(aRect.left,aRect.bottom-1);
            LineTo(aRect.right,aRect.Bottom-1);
          end;

      // -------- id_shedule
      if (arow>0) and (aCol=0) then
        begin

         If activ then
           begin
            font.Color:=clBlack;
            font.size:=14;
            font.Style:=[];
            DrawCellsAlign(form6.StringGrid4,2,2,Cells[0, aRow],aRect);
           end
         else
           begin
             font.size:=12;
             font.Style:=[fsBOld];
             font.Color:=clMaroon;
             DrawCellsAlign(form6.StringGrid4,2,1,'НЕАКТИВЕН',aRect);
             font.Style:=[];
             font.Color:=clMedGray;
             DrawCellsAlign(form6.StringGrid4,2,2,Cells[0,aRow],aRect);
             end;
         //0 - НЕОПРЕДЕЛЕНО (ОТКРЫТ)
         //1 - ДООБИЛЕЧИВАНИЕ (ОТКРЫТ) повторно
         //2 - ОТМЕЧЕН КАК ПРИБЫВШИЙ
         //3 - ОТМЕЧЕН КАК ОПАЗДЫВАЮЩИЙ (ОТКРЫТ)
         //4 - ОТПРАВЛЕН (Закрыт)
         //5 - СРЫВ ПО ВИНЕ АТП (ЗАКРЫТ)
         //6 - ЗАКРЫТ ПРИНУДИТЕЛЬНО
         font.size:=10;
         font.Style:=[];
         font.Color:=clBlue;
         case trim(rejs_mas[aRow-1,28]) of
           '0':DrawCellsAlign(form6.StringGrid4,2,3,'ОТКРЫТ',aRect);
           '1':DrawCellsAlign(form6.StringGrid4,2,3,'ДООБИЛ',aRect);
           '2':DrawCellsAlign(form6.StringGrid4,2,3,'ПРИБЫЛ',aRect);
           '3':DrawCellsAlign(form6.StringGrid4,2,3,'ОПАЗД',aRect);
           '4':DrawCellsAlign(form6.StringGrid4,2,3,'ОТПРАВ',aRect);
           '5':DrawCellsAlign(form6.StringGrid4,2,3,'СРЫВ',aRect);
           '6':DrawCellsAlign(form6.StringGrid4,2,3,'ЗАКРЫТ',aRect);
           end;
        end;

      // -------- t_o
      if (arow>0) and (aCol=1) then
        begin
         font.size:=14;
         font.Style:=[];
         DrawCellsAlign(form6.StringGrid4,2,2,Cells[1, aRow],aRect);
         font.size:=10;
         DrawCellsAlign(form6.StringGrid4,1,3,rejs_mas[aRow-1,30]+' '+rejs_mas[aRow-1,31],aRect);
        end;

      // -------- name
      if (arow>0) and (aCol=2) then
        begin
         font.size:=16;
         If activ then
         font.Style:=[fsBold];
         // ----- Наименование рейса -------- //
         DrawCellsAlign(form6.StringGrid4,2,1,Cells[2, aRow],aRect);
         // ----- АТП+АТС -------- //
         font.size:=12;
         font.Style:=[];
         s3:='['+trim(rejs_mas[aRow-1,18])+'] '+trim(rejs_mas[aRow-1,19])+' АТС: '+'['+trim(rejs_mas[aRow-1,20])+']-'+trim(rejs_mas[aRow-1,21]);
         If activ then font.color:=clBlack else font.Color:=clMedGray;
         DrawCellsAlign(form6.StringGrid4,1,3,s3,aRect);
         if trim(rejs_mas[aRow-1,0])='2' then
              begin
                     pen.Width:=1;
                     font.color:=clRed;
                     font.Size:=14;
                     font.Style:=[];
                     pen.Color:=clBlack;
                     canvas.Rectangle(aRect.left+1,aRect.top+1,aRect.left+21,aRect.top+21);
                     TextOut(aRect.left+3, aRect.Top, 'З');
              end;
        end;

      // -------- mest free
      if (arow>0) and (aCol=3) then
        begin
         font.size:=14;
         font.Style:=[];
         DrawCellsAlign(form6.StringGrid4,2,2,Cells[3, aRow],aRect);
        end;

      // -------- mest all
      if (arow>0) and (aCol=4) then
        begin
         font.size:=14;
         font.Style:=[];
         DrawCellsAlign(form6.StringGrid4,2,2,Cells[4, aRow],aRect);
        end;

      // -------- cenatarif
      if (arow>0) and (aCol=5) then
        begin
         font.size:=14;
         font.Style:=[];
         DrawCellsAlign(form6.StringGrid4,2,2,FormatNum(Cells[5, aRow],2),aRect);
        end;

      // -------- bagazh
      if (arow>0) and (aCol=6) then
        begin
         font.size:=14;
         font.Style:=[];
         DrawCellsAlign(form6.StringGrid4,2,2,FormatNum(Cells[6, aRow],2),aRect);
        end;


      // ------- Заголовок
      if arow=0 then
        begin
           Brush.Color:=clSilver;
           FillRect(aRect);
           Font.Color := clBlack;
           font.Size:=12;
           DrawCellsAlign(form6.StringGrid4,2,2,Cells[aCol, aRow],aRect);

        end;
   end;
end;


// НОВЫЙ расчет рейсов для локальной системы
  procedure TForm6.rascet_rejs_local;
  var
    n,myserv:integer;
    flg:boolean;
  begin
    try
     myserv:=strtoint(connectINI[14]);
    except
          on exception: EConvertError do
          begin
            showmessagealt('Ошибка номера локального сервера !');
            exit;
          end;
     end;
     SetLength(rejs_mas,0,0);
       //showmessage(sale_server+#13+         ConnectINI[4]+#13+         ConnectINI[5]+#13+         ConnectINI[6]);//$
  // -------------------- Соединяемся с удаленным сервером ----------------------
   form6.Label19.Caption:='';
   form6.Panel1.Visible:=true;
    application.ProcessMessages;

      //подключаемся к удаленному серверу
     If not(Connect2(form6.Zconnection1, 3)) then
  begin
   showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
   exit;
  end;

   virtuals:=false;
     If form1.virt_server() then
      begin
        virtuals:=true;
        end;

  form6.Label19.Caption:=otkuda_name;
  application.ProcessMessages;
 //application.ProcessMessages;
 //========================= ДАННЫЕ по рейсам=============================//
    flg:=false;
    //если сегодняшнее число и сервер не виртуальный
  If (rdate=date()) and not virtuals then
     begin
       form6.ZReadOnlyQuery1.sql.Clear;
       form6.ZReadOnlyQuery1.sql.add('SELECT b.name,b.edet,b.free_seats,b.id_shedule,b.active,b.dateactive,b.dates,b.datepo,b.date_tarif,b.id_route,b.ot_id_point,b.ot_order, ');
       form6.ZReadOnlyQuery1.sql.add('b.do_id_point,b.do_order,b.t_o,b.t_s,b.t_p,b.ot_name,b.do_name,b.napr,b.order_otkuda,b.form,b.plat,b.zakaz,b.id_kontr,b.name_kontr, ');
       form6.ZReadOnlyQuery1.sql.add('b.id_ats,b.name_ats,b.type_ats,b.all_mest,b.trip_flag,b.id_point_oper,b.tdate,b.id_user,b.id_oper,b.wihod,b.remark,b.putevka, ');
       form6.ZReadOnlyQuery1.sql.add('b.driver1,b.driver2,b.driver3,b.driver4 FROM av_disp_current_day b ');
       form6.ZReadOnlyQuery1.sql.add('WHERE b.napr=1 and b.zakaz<3 and b.id_shedule in (Select n.id_shedule FROM av_shedule_sostav n WHERE n.del=0 and n.id_shedule=b.id_shedule ');
       form6.ZReadOnlyQuery1.sql.add('and n.id_point='+inttostr(id_kuda));
       form6.ZReadOnlyQuery1.sql.add(' and n.point_order>=b.ot_order ');
       form6.ZReadOnlyQuery1.sql.add('and n.point_order<=b.do_order ');
       form6.ZReadOnlyQuery1.sql.add('and n.point_order>b.order_otkuda) ');
       form6.ZReadOnlyQuery1.sql.add('ORDER BY t_o,id_shedule,ot_order;');
       //showmessage(form6.ZReadOnlyQuery1.sql.Text);//&
  try
      form6.ZReadOnlyQuery1.open;
  except
        Panel1.Visible:=false;
      showmessagealt('ОШИБКА ЗАПРОСА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
      form6.ZReadOnlyQuery1.Close;
      form6.Zconnection1.disconnect;
      exit;
  end;

  if form6.ZReadOnlyQuery1.RecordCount>0 then
     begin
        flg:=true;
      end;
   end;
 If not flg then
    begin
  form6.ZReadOnlyQuery1.sql.Clear;
  form6.ZReadOnlyQuery1.sql.add('select * from get_trip_kuda('+quotedstr('rejs')+','+quotedstr(Datetostr(rdate))+','+sale_server+','+inttostr(id_kuda)+');');
  form6.ZReadOnlyQuery1.sql.add('FETCH ALL IN rejs;');
  //showmessage(form6.ZReadOnlyQuery1.sql.Text);//&
  try
      form6.ZReadOnlyQuery1.open;
  except
      form6.Panel1.Visible:=false;
      showmessagealt('ОШИБКА ЗАПРОСА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
      form6.ZReadOnlyQuery1.Close;
      form6.Zconnection1.disconnect;
      exit;
  end;

  //Если нет рейсов
  if form6.ZReadOnlyQuery1.RecordCount=0 then
     begin
      form6.Panel1.Visible:=false;
       showmessagealt('По выбранным условиям рейсы отсутствуют !!!');
       form6.ZReadOnlyQuery1.Close;
       form6.Zconnection1.disconnect;
       exit;
     end;
  end;
 form6.Panel1.Visible:=false;
   // Записываем данные в массив

  // mas_rejs [n,0] - номер расписания
  // mas_rejs [n,1] - время отправления
  // mas_rejs [n,2] - наименование
  // mas_rejs [n,3] - мест свободно
  // mas_rejs [n,4] - мест всего
  // mas_rejs [n,5] - id kontr
  // mas_rejs [n,6] - name kontr
  // mas_rejs [n,7] - id ats
  // mas_rejs [n,8] - name ats
  // mas_rejs [n,9] - all_mest
  // mas_rejs[n,10] - type_ats
  // mas_rejs[n,11] - status
  // mas_rejs[n,12] - level
  // mas_rejs[n,13] - one_one
  // mas_rejs[n,14] - one_two
  // mas_rejs[n,15] - one_three
  // mas_rejs[n,16] - one_four
  // mas_rejs[n,17] - one_five
  // mas_rejs[n,18] - two_one
  // mas_rejs[n,19] - two_two
  // mas_rejs[n,20] - two_three
  // mas_rejs[n,21] - two_four
  // mas_rejs[n,22] - two_five
  // mas_rejs[n,23] - sale (проданные или занятые места)
  // mas_rejs[n,24] - form
  // mas_rejs[n,25] - ot_order - порядковый номер в составе расписания начального пункта рейса
  // mas_rejs[n,26] - do_order - порядковый номер в составе расписания конечного пункта рейса
  // mas_rejs[n,27] - zakaz
  // mas_rejs[n,28] - cenatarif
  // mas_rejs[n,29] - bagazh
  // mas_rejs[n,30] - платформа отправления
  // mas_rejs[n,31] - платформа прибытия
  // mas_rejs[n,32] - дата отправления
  // mas_rejs[n,33] - дата прибытия
  // mas_rejs[n,34] - время прибытия
  // mas_rejs[n,35] - тип маршрута
  // mas_rejs[n,36] - дата тарифа
  // mas_rejs[n,37] - наименование пункта отправления
  // mas_rejs[n,38] - наименование пункта прибытия
  // mas_rejs[n,39] - ot_id_point - id остановочного пункта начала рейса
  // mas_rejs[n,40] - do_id_point - id остановочного пункта конца рейса
  // mas_rejs[n,41] - id_otkuda - id остановочного пункта отправления
  // mas_rejs[n,42] - id_kuda - id остановочного пункта назначения
  // mas_rejs[n,43] - order_otkuda - порядковый номер в составе расписания пункта отправления
  // mas_rejs[n,44] - order_kuda   - порядковый номер в составе расписания пункта прибытия
  // mas_rejs[n,45] - kod_route   - код маршрута
  // mas_rejs[n,46] - comfort   - жесткий\мягкий
          //form6.ZReadOnlyQuery1.Next;//&
          //form6.ZReadOnlyQuery1.Next;//&

  for n:=0 to form6.ZReadOnlyQuery1.RecordCount-1 do      //$
    begin
      //showmessage(form6.ZReadOnlyQuery1.FieldByName('zakaz').asString);
     SetLength(rejs_mas,length(rejs_mas)+1,full_mas_size);
            //- Тип рейса в массиве
            //1: из av_trip (регулярный)
            //2: из av_trip_add (заказной)
            //3: из av_ticket_local (удаленный рейс регулярный)
            //4: из av_ticket_local (удаленный рейс заказной)
            rejs_mas[length(rejs_mas)-1,0]:= inttostr(form6.ZReadOnlyQuery1.FieldByName('zakaz').asInteger+2);
            rejs_mas[length(rejs_mas)-1,1]:= trim(form6.ZReadOnlyQuery1.FieldByName('id_shedule').asString);
            rejs_mas[length(rejs_mas)-1,2]:= trim(form6.ZReadOnlyQuery1.FieldByName('plat').asString);
            rejs_mas[length(rejs_mas)-1,3]:= trim(form6.ZReadOnlyQuery1.FieldByName('ot_id_point').asString);
            rejs_mas[length(rejs_mas)-1,4]:= trim(form6.ZReadOnlyQuery1.FieldByName('ot_order').asString);
            rejs_mas[length(rejs_mas)-1,5]:= trim(form6.ZReadOnlyQuery1.FieldByName('ot_name').asString);
            rejs_mas[length(rejs_mas)-1,6]:= trim(form6.ZReadOnlyQuery1.FieldByName('do_id_point').asString);
            rejs_mas[length(rejs_mas)-1,7]:= trim(form6.ZReadOnlyQuery1.FieldByName('do_order').asString);
            rejs_mas[length(rejs_mas)-1,8]:= trim(form6.ZReadOnlyQuery1.FieldByName('do_name').asString);
            rejs_mas[length(rejs_mas)-1,9]:= trim(form6.ZReadOnlyQuery1.FieldByName('form').asString);
            rejs_mas[length(rejs_mas)-1,10]:= trim(form6.ZReadOnlyQuery1.FieldByName('t_o').asString);
            rejs_mas[length(rejs_mas)-1,11]:= formatDatetime('dd-mm-yy',rdate); //время стоянки если регулярный рейс или дата выхода если удаленный
            rejs_mas[length(rejs_mas)-1,12]:= trim(form6.ZReadOnlyQuery1.FieldByName('t_p').asString);
            rejs_mas[length(rejs_mas)-1,13]:= form6.ZReadOnlyQuery1.FieldByName('zakaz').asString;
            rejs_mas[length(rejs_mas)-1,14]:= trim(form6.ZReadOnlyQuery1.FieldByName('date_tarif').asString);
            rejs_mas[length(rejs_mas)-1,15]:= trim(form6.ZReadOnlyQuery1.FieldByName('id_route').asString);
            rejs_mas[length(rejs_mas)-1,16]:= trim(form6.ZReadOnlyQuery1.FieldByName('napr').asString);
   //showmessagealt(trim(form6.ZReadOnlyQuery1.FieldByName('napr').asString));
            rejs_mas[length(rejs_mas)-1,17]:= form6.ZReadOnlyQuery1.FieldByName('wihod').asString;  //1:выход в рейс в текущий workdate
            rejs_mas[length(rejs_mas)-1,18]:= form6.ZReadOnlyQuery1.FieldByName('id_kontr').asString; //id перевозчика
            rejs_mas[length(rejs_mas)-1,19]:= trim(form6.ZReadOnlyQuery1.FieldByName('name_kontr').asString); //наименование перевозчика
            rejs_mas[length(rejs_mas)-1,20]:= form6.ZReadOnlyQuery1.FieldByName('id_ats').asString; //№ автобуса
            rejs_mas[length(rejs_mas)-1,21]:= trim(form6.ZReadOnlyQuery1.FieldByName('name_ats').asString); //наименование Автобуса
            rejs_mas[length(rejs_mas)-1,22]:= trim(form6.ZReadOnlyQuery1.FieldByName('edet').asString); //прозведение флагов выход по сезонности,лицензия,договор,атс,перевозчик
            rejs_mas[length(rejs_mas)-1,23]:= trim(form6.ZReadOnlyQuery1.FieldByName('dates').asString);
            rejs_mas[length(rejs_mas)-1,24]:= trim(form6.ZReadOnlyQuery1.FieldByName('datepo').asString);
            rejs_mas[length(rejs_mas)-1,25]:= form6.ZReadOnlyQuery1.FieldByName('all_mest').asString;  //мест всего
            If (form6.ZReadOnlyQuery1.FieldByName('dates').AsDateTime<work_date) and (form6.ZReadOnlyQuery1.FieldByName('datepo').AsDateTime>work_date) then
            rejs_mas[length(rejs_mas)-1,26]:='1' //form6.ZReadOnlyQuery1.FieldByName('activen').asString; //признак активности расписания по датам действия и флагу активности
            else rejs_mas[length(rejs_mas)-1,26]:='0';
            rejs_mas[length(rejs_mas)-1,27]:= form6.ZReadOnlyQuery1.FieldByName('type_ats').asString;  //тип АТС
            rejs_mas[length(rejs_mas)-1,28]:= trim(form6.ZReadOnlyQuery1.FieldByName('trip_flag').asString);  //состояние рейса
            rejs_mas[length(rejs_mas)-1,29]:= '0';  //дообилечивания количество ведомостей
            If trim(form6.ZReadOnlyQuery1.FieldByName('tdate').AsString)<>'' then
               begin
            rejs_mas[length(rejs_mas)-1,30]:= formatDatetime('dd-mm-yyyy',form6.ZReadOnlyQuery1.FieldByName('tdate').asDateTime);  //дата операции
            rejs_mas[length(rejs_mas)-1,31]:= formatDatetime('hh:nn:ss',form6.ZReadOnlyQuery1.FieldByName('tdate').asDateTime);  //время операции
               end;
            rejs_mas[length(rejs_mas)-1,32]:= trim(form6.ZReadOnlyQuery1.FieldByName('name').asString); //пользователь совершивший операцию
            rejs_mas[length(rejs_mas)-1,33]:= trim(form6.ZReadOnlyQuery1.FieldByName('remark').asString);  //описание операции
            rejs_mas[length(rejs_mas)-1,34]:= form6.ZReadOnlyQuery1.FieldByName('free_seats').asString;  //[n,34] - kol_swob //кол-во свободных мест
            rejs_mas[length(rejs_mas)-1,35]:= trim(form6.ZReadOnlyQuery1.FieldByName('putevka').asString); //[n,35] putevka
            rejs_mas[length(rejs_mas)-1,36]:= trim(form6.ZReadOnlyQuery1.FieldByName('driver1').asString);  //[n,36] driver1
            rejs_mas[length(rejs_mas)-1,37]:= trim(form6.ZReadOnlyQuery1.FieldByName('driver2').asString);  //[n,37] driver2').asString);
            rejs_mas[length(rejs_mas)-1,38]:= trim(form6.ZReadOnlyQuery1.FieldByName('driver3').asString);  //[n,38] driver3').asString);
            rejs_mas[length(rejs_mas)-1,39]:= trim(form6.ZReadOnlyQuery1.FieldByName('driver4').asString);  //[n,39] driver4').asString);
            //rejs_mas[length(rejs_mas)-1,40]:= form6.ZReadOnlyQuery1.FieldByName('dateactive').asString;// [n,40] - dateactive //дата начала работы расписания
            If Form6.ZReadOnlyQuery1.FieldByName('edet').asINteger>0 then
            rejs_mas[length(rejs_mas)-1,41]:='1' else rejs_mas[length(rejs_mas)-1,41]:='0'; // [n,41] - dog_flag //флаг наличия договора
            If Form6.ZReadOnlyQuery1.FieldByName('edet').asINteger>0 then
            rejs_mas[length(rejs_mas)-1,42]:='1' else rejs_mas[length(rejs_mas)-1,42]:='0'; //// [n,42] - lic_flag //флаг наличия лицензии
              If form6.ZReadOnlyQuery1.FieldByName('id_kontr').asInteger>0 then
            rejs_mas[length(rejs_mas)-1,43]:='1' else rejs_mas[length(rejs_mas)-1,43]:='0'; //  - kontr_flag //флаг наличия перевозчика
            If form6.ZReadOnlyQuery1.FieldByName('id_ats').asInteger>0 then
            rejs_mas[length(rejs_mas)-1,44]:='1' else rejs_mas[length(rejs_mas)-1,44]:='0'; //  [n,44] - ats_flag //флаг наличия автобуса
            rejs_mas[length(rejs_mas)-1,45]:= sale_server;//сервер продажи удаленного сервера
            rejs_mas[length(rejs_mas)-1,46]:= form6.ZReadOnlyQuery1.FieldByName('order_otkuda').asString;//порядок пункта сервера в расписании
     form6.ZReadOnlyQuery1.Next;
    end;
  form6.ZReadOnlyQuery1.Close;
  form6.Zconnection1.disconnect;

  end;

procedure TForm6.StringGrid3Selection(Sender: TObject; aCol, aRow: Integer);
begin
  form6.DateEdit1.Date:=now()+form6.StringGrid3.row;
end;

// Заполняем массив куда
procedure Tform6.Fill_kuda;
var
  n:integer;
begin
   form6.Label19.Caption:='';
   Panel1.Visible:=true;
   application.ProcessMessages;
   // -------------------- Соединяемся с локальным сервером ----------------------
   If not(Connect2(form6.Zconnection1, 2)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     form6.close;
    end;
   form6.Label19.Caption:=otkuda_name;
   application.ProcessMessages;
   form6.ZReadOnlyQuery1.sql.Clear;
   form6.ZReadOnlyQuery1.sql.add('SELECT a.id,upper(a.name) as name from av_spr_point a where a.del=0 and a.name ilike '+quotedstr(trim(form6.Edit1.Text)+'%')+' order by a.name;');
  try
      form6.ZReadOnlyQuery1.open;
  except
      Panel1.Visible:=false;
         form6.ZReadOnlyQuery1.Close;
         form6.Zconnection1.disconnect;
         showmessagealt('Нет данных по СЕРВЕРАМ ПРОДАЖ !!!'+#13+'Сообщите об этом АДМИНИСТРАТОРУ !!!');
         form6.Close;
  end;
 Panel1.Visible:=false;
  SetLength(mas_kuda,0,0);

  if form6.ZReadOnlyQuery1.RecordCount=0 then
     begin
       //showmessagealt('Нет данных по СЕРВЕРАМ ПРОДАЖ                                                                                                       2!!!'+#13+'Сообщите об этом АДМИНИСТРАТОРУ !!!');
       form6.ZReadOnlyQuery1.Close;
       form6.Zconnection1.disconnect;
       //form6.Close;
       exit;
     end;
  // Заполняем массив КУДА
  for n:=0 to form6.ZReadOnlyQuery1.RecordCount-1 do
    begin
      SetLength(mas_kuda,length(mas_kuda)+1,2);
      mas_kuda[length(mas_kuda)-1,0]:=form6.ZReadOnlyQuery1.FieldByName('id').asString;
      mas_kuda[length(mas_kuda)-1,1]:=form6.ZReadOnlyQuery1.FieldByName('name').asString;
      form6.ZReadOnlyQuery1.Next;
    end;
  form6.ZReadOnlyQuery1.Close;
  form6.Zconnection1.disconnect;
end;


// Заполняем GRID куда
procedure Tform6.fill_grid_kuda();
var
  n:integer;
  hg:integer;
  kolm:integer=0;
begin
  with form6 do
  begin
   StringGrid2.RowCount:=0;
   if length(mas_kuda)=0 then exit;
   kolm:=0;
   for n:=0 to length(mas_kuda)-1 do
    begin
      //if UTF8Copy(trim(mas_kuda[n,1]),1,UTF8Length(trim(form6.Edit1.text)))=upperall(trim(form6.Edit1.text)) then
        //begin
          kolm:=kolm+1;
          StringGrid2.RowCount:=StringGrid2.RowCount+1;
          StringGrid2.Cells[0,StringGrid2.RowCount-1]:=mas_kuda[n,1];
          StringGrid2.Cells[1,StringGrid2.RowCount-1]:=mas_kuda[n,0];
        //end;
    end;
   // Высота GRID
   hg:=(StringGrid2.DefaultRowHeight*kolm+5);
   if hg>form6.Height-220 then StringGrid2.Height:=form6.Height-220 else StringGrid2.Height:=hg;
   // Размер Колонок
   StringGrid2.ColWidths[0]:=trunc(width*0.9);
   StringGrid2.ColWidths[1]:=0;
   StringGrid2.Visible:=true;//$
   end;
 end;


// Заполняем GRID откуда
procedure Tform6.fill_grid_otkuda;
var
  n:integer;
  hg:integer;
  blow:boolean;
begin
 with form6.StringGrid1 do
  begin
   RowCount:=0;
   //если я - не ставрополь, то поднять ставрополькие вокзалы вверх
   If (mas_otkuda[0,0]='814') or (mas_otkuda[0,0]='815') or (mas_otkuda[0,0]='816') then blow:=false else blow:=true;

   If blow then
     begin
  //свой сервер пропускаем
   for n:=1 to length(mas_otkuda)-1 do
    begin
     If not((mas_otkuda[n,0]='814') or (mas_otkuda[n,0]='815') or (mas_otkuda[n,0]='816')) then continue;
      RowCount:=RowCount+1;
      Cells[0,RowCount-1]:=mas_otkuda[n,1];
      Cells[1,RowCount-1]:=mas_otkuda[n,0];
    end;
   end;
   //свой сервер пропускаем
   for n:=1 to length(mas_otkuda)-1 do
    begin
      RowCount:=RowCount+1;
      Cells[0,RowCount-1]:=mas_otkuda[n,1];
      Cells[1,RowCount-1]:=mas_otkuda[n,0];
    end;
   // Высота GRID

   hg:=(DefaultRowHeight*n+4);
   if hg>form6.Height-170 then Height:=form6.Height-170 else Height:=hg;
   If hg<100 then hg:=100;
 //  if hg>form6.Height-70 then Height:=form6.Height-70 else Height:=hg;
   // Размер Колонок
   ColWidths[0]:=trunc(width*0.7);
   ColWidths[1]:=trunc(width*0.2);
   Visible:=true;
  end;
 end;

// Рисуем GRID дат
procedure TForm6.Fill_grid_date;
 var
   n,hg,kol_day_predv:integer;
   sd:string;
begin
  kol_day_predv:=40;
  form6.StringGrid3.RowCount:=0;
  for n:=0 to kol_day_predv-1 do
    begin
     sd:=FormatDateTime('dd', (date()+n))+' '+GetMonthName(strtoint(FormatDateTime('mm', (date()+n))))+' '+FormatDateTime('yyyy', (date()+n))+' '+GetDayName(dayoftheweek((date()+n)));
     form6.StringGrid3.RowCount:=form6.StringGrid3.RowCount+1;
     form6.StringGrid3.Cells[0,form6.StringGrid3.RowCount-1]:=sd;
    end;
  // Высота GRID
  hg:=(form6.StringGrid3.DefaultRowHeight*kol_day_predv+2);
  if hg>form6.Height-300 then form6.StringGrid3.Height:=form6.Height-300 else form6.StringGrid3.Height:=hg;
  // Размер Колонок
  form6.StringGrid3.ColWidths[0]:=220;
  //form6.StringGrid3.Visible:=true;
end;

procedure TForm6.FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
 var
  n:integer;
 begin
     // ПЕРЕХОД В СПИСКЕ СЕРВЕРОВ ПО ПЕРВОЙ БУКВЕ
   if (form6.StringGrid1.Visible=true) then
       begin
        for n:=0 to form6.StringGrid1.RowCount-1 do
          begin
            if utf8copy(trim(form6.StringGrid1.Cells[0,n]),1,1)=upperall(UTF8key) then
              begin
               form6.StringGrid1.Row:=n;
               break;
              end;
          end;
       end;
end;

procedure TForm6.IdleTimer1Timer(Sender: TObject);
begin
   form6.IdleTimer1.AutoEnabled:=false;
   form6.IdleTimer1.Enabled:=false;
   id_kuda:=0;
   form6.Fill_kuda;
   If length(mas_kuda)<2 then
   begin
     form6.StringGrid2.RowCount:=0;
     If form6.StringGrid2.Visible then form6.StringGrid2.Visible:=false;
     If length(mas_kuda)=1 then
     begin
       try
         id_kuda:=strtoint(mas_kuda[0,0]);
        except
           showmessagealt('6.03 Ошибка преобразования в целое !');
           exit;
        end;
        form6.Edit1.Text:=mas_kuda[0,1];
        form6.Edit1.SetFocus;
        form6.Edit1.SelStart:=utf8length(form6.Edit1.Text);
     end;
   end
   else
   begin
   form6.Fill_grid_kuda();
   end;
end;

procedure TForm6.FormPaint(Sender: TObject);
begin
  with form6 do
  begin
   Canvas.Brush.Color:=clSilver;
   Canvas.Pen.Color:=clBlack;
   Canvas.Pen.Width:=2;
   Canvas.Rectangle(2,2,Width-2,Height-2);
  end;
end;

procedure TForm6.FormShow(Sender: TObject);
begin
  //Выравниваем форму
 CentrForm(Form6);
 If length(mas_otkuda)=0 then
   begin
    showmessagealt('Нет данных по удаленным пунктам продаж !');
    form6.Close;
    exit;
   end;
 twhere:='';
If length(mas_otkuda)>0 then fill_grid_otkuda;
 //fillcombo(); //заполнить комбо куда ехать
end;

procedure TForm6.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState  );
var
 n,m,nfind:integer;
begin
  //showmessage(inttostr(key));//$
      // F1 - Справка
   if (Key=112) then showmessagealt('F1 - СПРАВКА'+#13
   //+#13+'F2 - ЭТАЖ СМЕНИТЬ'+#13+'F12 - СОХРАНИТЬ ИЗМЕНЕНИЯ'+#13+'ПРОБЕЛ - БРОНЬ СНЯТЬ/УСТАНОВИТЬ'+#13+'DEL - ВЫЧЕРКНУТЬ БИЛЕТ'+#13
   +'ESC - ВЫХОД');

    // Возврат из Рейсов в Дату
  if (key=27) and (form6.StringGrid4.Visible=true) then
     begin
      key:=0;
      If remote_ind>-1 then
         begin
            remote_ind:=-1;
            Form6.close;
            exit;
         end;
     //form6.Label9.Visible:=false;
     form6.Label10.Visible:=false;
     form6.StringGrid4.Visible:=false;
     form6.Bevel2.Visible:=false;
     setlength(rejs_mas,0,0);
     form6.StringGrid4.RowCount:=1;
     form6.Label8.Caption:='';
     form6.StringGrid3.Visible:=true;
     form6.DateEdit1.Visible:=true;
     form6.Label7.Visible:=true;
     form6.Label8.Visible:=false;
     form6.StringGrid3.SetFocus;
     form6.Label21.Caption:='[ENTER]-ВЫБОР ДАТЫ РЕЙСА,'+#13+'[ESC]-ВОЗВРАТ К ВЫБОРУ ПУНКТА ПРИБЫТИЯ';
     form6.Label21.Visible:=true;

     exit;
    end;


     // Возврат из Дата в Куда
  if (key=27) and (form6.StringGrid3.Visible=true) then
     begin
     form6.Label6.Caption:='';
     //form6.StringGrid2.Visible:=true;
     form6.Label4.Visible:=true;
     form6.Label6.Visible:=false;
     form6.Label7.Visible:=false;
     form6.Label8.Visible:=false;
     form6.StringGrid3.Visible:=false;
     form6.DateEdit1.Visible:=false;
     form6.edit1.Visible:=true;
     form6.edit1.SetFocus;
     //form6.ComboBox1.visible:=true;
     //form6.ComboBox1.SetFocus;
     form6.Label21.Caption:='[ENTER]-ВЫБОР ПУНКТА ПРИБЫТИЯ,'+#13+'[ESC]-ВОЗВРАТ К ВЫБОРУ ПУНКТА ОТПРАВЛЕНИЯ';
     form6.Label21.Visible:=true;
     // Устанавливаем сервер продажи
     //Tek_server:=id_otkuda;
     //set_server('local'); //or local
     key:=0;
     exit;
    end;

  // Возврат из Куда в Откуда
  if (key=27) and (form6.Edit1.Focused) then
  //if (key=27) and form6.ComboBox1.Visible then
     begin
       //form6.combobox1.Visible:=false;
       id_kuda:=0;
       form6.Edit1.Text:='';
       form6.Edit1.Visible:=False;
       form6.Label2.Visible:=true;
       form6.Label6.Visible:=false;
       form6.Label4.Visible:=false;
       form6.StringGrid2.Visible:=false;
       form6.Label5.Caption:='';
       form6.Label5.Visible:=false;
       form6.StringGrid1.Visible:=true;
       form6.StringGrid1.SetFocus;
       form6.Label21.Caption:='[ENTER]-ВЫБОР ПУНКТА ОТПРАВЛЕНИЯ,'+#13+'[ESC]-ВОЗВРАТ К ВЫБОРУ ОСНОВНОГО МЕНЮ';
       form6.Label21.Visible:=true;
       key:=0;
       exit;
     end;

   // ENTER - ОТКУДА
  if (key=13) and (form6.StringGrid1.Visible=true) then
   begin
     nfind:=-1;
    try
         id_kuda:=strtoint(mas_otkuda[0,0]);
     except
           showmessagealt('6.01 Ошибка преобразования в целое !');
           exit;
     end;
     //for n:=0 to length(mas_otkuda)-1 do
     //  begin
     //     for m:=0 to length(mas_kuda)-1 do
     //       begin
     //          If mas_otkuda[n,0]=mas_kuda[m,0] then
     //          begin
     //             nfind:=m;
     //             form6.Edit1.text:=mas_kuda[m,1];
     //             break;
     //          end;
     //         If nfind>-1 then break;
     //       end;
     //   end;
     //
     //If nfind>-1 then
     //  Form6.Edit1.text:=nfind;
     //
     //form6.ComboBox1.SelStart:=utf8length(Form6.combobox1.Text);

     form6.Label5.Caption:=trim(form6.StringGrid1.Cells[0,form6.StringGrid1.row]);
     form6.StringGrid1.Visible:=false;
     form6.Label5.Visible:=true;
     form6.Label3.Visible:=true;
     // Сдвигаем элементы
     form6.Label6.Visible:=false;
     form6.Label2.Visible:=false;
     form6.Label4.Visible:=true;

     //form6.combobox1.ItemIndex:=-1;
     id_otkuda:=strtoint(form6.StringGrid1.Cells[1,form6.StringGrid1.row]);
     form6.Label21.Caption:='[ENTER]-ВЫБОР ПУНКТА ПРИБЫТИЯ,'+#13+'[ESC]-ВОЗВРАТ К ВЫБОРУ ПУНКТА ПРОДАЖ';
     form6.Label21.Visible:=true;
     key:=0;

      //Устанавливаем пункт "куда" - себя по умолчанию
     Form6.Edit1.Text:=mas_otkuda[0,1];
     form6.Edit1.Visible:=true;
     form6.Edit1.SetFocus;
     exit;
   end;

   // ENTER - КУДА
  if (key=13)
     and (form6.StringGrid2.Focused or form6.edit1.Focused)
      //and form6.ComboBox1.Focused
      then
   begin
     If (id_kuda=0) and form6.StringGrid2.visible and not(trim(form6.StringGrid2.Cells[0,form6.StringGrid2.row])='') then
     begin
       try
      //If id_kuda=0 then
         //id_kuda:=strtoint(mas_kuda[form6.ComboBox1.ItemIndex,0]);
         id_kuda:=strtoint(form6.StringGrid2.Cells[1,form6.StringGrid2.row]);
         form6.Edit1.Text:=trim(form6.StringGrid2.Cells[0,form6.StringGrid2.row]);
         //form6.Label6.Caption:=mas_kuda[form6.ComboBox1.ItemIndex,1];
     //else
       //begin
          //form6.Label6.Caption:=trim(form6.Edit1.text);
          //form6.Label6.Caption:=utf8copy(form6.ComboBox1.Text,1,utf8pos('|',form6.ComboBox1.Text));
        //end;
     except
           showmessagealt('6.02 Ошибка преобразования в целое !');
           exit;
     end;
     end;

     If id_kuda=0 then exit;
     form6.Label6.Caption:=form6.Edit1.Text;
     form6.StringGrid2.Visible:=false;
     form6.edit1.Visible:=false;
     form6.Label6.Visible:=true;
     form6.Label9.Visible:=true;
     form6.Fill_grid_date;
     form6.DateEdit1.Date:=now();
     form6.Label8.Visible:=false;
     form6.Label4.Visible:=false;
     form6.Label7.Visible:=true;
     form6.StringGrid3.Visible:=true;
     form6.DateEdit1.Visible:=true;
     form6.DateEdit1.SetFocus;
     form6.Label21.Caption:='[ENTER]-ВЫБОР ДАТЫ РЕЙСА,'+#13+'[ESC]-ВОЗВРАТ К ВЫБОРУ ПУНКТА ПРИБЫТИЯ';
     form6.Label21.Visible:=true;
     //form6.ComboBox1.Visible:=false;
     // Устанавливаем сервер продажи
     sale_server:=inttostr(id_otkuda);
     //pogoda(form6.ZConnection3,form6.ZReadOnlyQuery3,trim(form6.StringGrid1.Cells[1,form6.StringGrid1.row]),trim(form6.StringGrid2.Cells[1,form6.StringGrid2.row]));
       //showmessage(sale_server+#13+         ConnectINI[4]+#13+         ConnectINI[5]+#13+         ConnectINI[6]);//$
     key:=0;
     exit;
   end;

    // ENTER - ДАТА
  if (key=13) and (form6.StringGrid3.Visible=true) and ((form6.StringGrid3.Focused) or (form6.DateEdit1.Focused)) then
   begin
     form6.Label8.Caption:=DateToStr(form6.DateEdit1.Date);
     form6.StringGrid3.Visible:=false;
     form6.DateEdit1.Visible:=false;
     form6.Label7.Visible:=false;
     form6.Label8.Visible:=true;
     form6.Label10.Visible:=true;
     rdate:=form6.DateEdit1.Date;
     // Делаем расчет рейсов
     form6.rascet_rejs_local;
     if length(rejs_mas)>0 then
       begin
         // Заполняем GRID и ждем выбора
         form6.fill_grid_rejs;
         form6.Label21.Caption:='[F3]-ПРОСМОТР СОСТАВА РЕЙСА,'+#13+'[ENTER]-ВЫБОР РЕЙСА,'+#13+'[ESC]-ВОЗВРАТ К ВЫБОРУ ДАТЫ РЕЙСА';
         form6.Label21.Visible:=true;
       end
     else
       begin
          form6.Label8.Visible:=false;
          form6.StringGrid3.Visible:=true;
          form6.DateEdit1.Visible:=true;
          form6.DateEdit1.SetFocus;
       end;
       key:=0;
       exit;
   end;


  //ESC - на пунктах КУДА
     if (key=27) and form6.StringGrid3.Focused then
   begin
       form6.Edit1.SetFocus;
       form6.Edit1.SelectAll;
     end;

    // ENTER - РЕЙСЫ
  if (key=13) and (form6.StringGrid4.Visible=true) and (form6.StringGrid4.Focused) then
   begin
     key:=0;
      rid:=form6.StringGrid4.Row-1;
      //showmessage(rejs_mas[rid,23]+#13+rejs_mas[rid,24]+#13+rejs_mas[rid,42]+#13+rejs_mas[rid,43]+#13+rejs_mas[rid,44]+#13+rejs_mas[rid,17]+#13+rejs_mas[rid,26] );
      //если сервер виртуальный, открываем меню
      If virtuals then
       begin
        add_fullmas;//добавить запись к основному массиву
        masindex:=remote_ind;
        operation:=0;//сбрасываем номер операции
           perenos_biletov:=-1;
           //вызвать меню, выбрать операцию и разобрать ее
           FormMenu:=TFormMenu.create(self);
           FormMenu.ShowModal;
           FreeAndNil(FormMenu);

           //выполнить разобранную операцию
           If operation>0 then
              begin
              form1.trip_data();
              end;
           //если был срыв с переносом билетов, то создать заказной рейс
             //If (perenos_biletov>0) then
             // begin
             //  If not(operation=11) then operation:=11;
             // form1.trip_data();
             // end;
           If operation>0 then
            begin
             operation:=0;
             remote_ind:=-1;
             Form6.Close;
            end;
        end
      else
        begin
         //продолжить только если рейс активен и отправлен или открыт
         If ((rejs_mas[rid,28]='0') or (rejs_mas[rid,28]='4')) and (rejs_mas[rid,22]='1') then
         begin
     //showmessagealt('Рейс успешно добавлен в общий список !');
        add_fullmas;//добавить запись к основному массиву
        form6.Close;
         end;
        end;
     //sale_server:='0';

     exit;
   end;

   // Контекстный поиск в EDIT1
   //if ((get_type_char(key)=1) or (get_type_char(key)=2) or (((key=8) or (key=46)))) and (form6.StringGrid2.Visible=true) then
       //begin
         //if form6.Edit1.Visible=false then form6.Edit1.Visible:=true;
         //If not form6.Edit1.Focused then form6.Edit1.SetFocus;
         //exit;
       //end;

     // Вверх Вниз в поиске куда
  //if ((key=38) or (key=40)) and (form6.StringGrid2.Visible=true) then
  //    begin
  //      form6.StringGrid2.SetFocus;
  //      //key:=0;
  //      exit;
  //    end;
     // Вверх Вниз в поиске куда
  //if ((key=38) or (key=40)) and (form6.Edit1.focused=true) then
      //begin
        //form6.StringGrid2.SetFocus;
        //exit;
      //end;

     // Вверх Вниз в дате
  if ((key=38) or (key=40)) and (form6.StringGrid3.Visible=true) and form6.DateEdit1.Focused then
      begin
        form6.StringGrid3.SetFocus;
        form6.StringGrid3.Row:=1;
        //key:=0;
        exit;
      end;

     // Вверх Вниз в КУДА
  if ((key=38) or (key=40)) and (form6.StringGrid2.Visible=true) and form6.Edit1.Focused then
      begin
        form6.StringGrid2.SetFocus;
        form6.StringGrid2.Row:=1;
        //key:=0;
        exit;
      end;
  // на гриде КУДА нажимаем любую кнопку - возврат в EDIT1
  If (form6.StringGrid2.focused) and not((key=38) or (key=40) or (key=13) or (key=27) or (key=0)) then
      begin
        form6.Edit1.SetFocus;
        form6.Edit1.SelStart:=utf8length(form6.Edit1.Text);
      end;

     // Вверх c верхней строчки грида дат
  if (key=38) and (form6.StringGrid3.Focused) and (form6.StringGrid3.row=0) then
      begin
       key:=0;
        form6.DateEdit1.SetFocus;
        exit;
      end;

      // ESC
   if (Key=27) then
       begin
        key:=0;
        remote_ind:=-1;
        form6.Close;
        exit;
       end;
end;

procedure TForm6.add_fullmas;
var
  n,k:integer;
  flfind:boolean;
begin
 flfind:=false;
 for n:=low(full_mas) to high(full_mas) do
   begin
     If (full_mas[n,0]='1') or (full_mas[n,0]='2') then continue;
     IF full_mas[n,1]<>rejs_mas[rid,1] then continue;
     If full_mas[n,11]<>FormatDateTime('dd-mm-yy',rdate) then continue;
     ///находим конкретный рейс

                      //если рейс отправления
                      If  ((full_mas[n,16]='1') AND
                          (full_mas[n,10]=rejs_mas[rid,10]) AND
                          (full_mas[n,3]=rejs_mas[rid,3]) AND
                          (full_mas[n,4]=rejs_mas[rid,4]) and (full_mas[n,45]=sale_server)) OR
                      //или если рейс прибытия
                           ((full_mas[n,16]='2') AND
                           (full_mas[n,12]=rejs_mas[rid,12]) AND
                           (full_mas[n,6]=rejs_mas[rid,6]) AND
                           (full_mas[n,7]=rejs_mas[rid,7]) and (full_mas[n,45]=sale_server)) then
                               begin
                                 full_mas[n,2]:= rejs_mas[rid,2];
                    full_mas[n,4]:= rejs_mas[rid,4];
                    full_mas[n,5]:= rejs_mas[rid,5];
                    full_mas[n,6]:= rejs_mas[rid,6];
                    full_mas[n,7]:= rejs_mas[rid,7];
                    full_mas[n,8]:= rejs_mas[rid,8];
                    full_mas[n,9]:= rejs_mas[rid,9];
                    //full_mas[n,10]=trim(form6.ZReadOnlyQuery1.FieldByName('t_o').asString);
                    //full_mas[n,11]=trim(form6.ZReadOnlyQuery1.FieldByName('t_s').asString);//время стоянки если регулярный рейс или дата выхода если удаленный
                    //full_mas[n,12]:= rejs_mas[rid,2];
                    full_mas[n,13]:= rejs_mas[rid,13];
                    full_mas[n,14]:= rejs_mas[rid,14];
                    full_mas[n,15]:= rejs_mas[rid,15];
                    full_mas[n,16]:= rejs_mas[rid,16];
                    full_mas[n,17]:= rejs_mas[rid,17];
                    full_mas[n,18]:= rejs_mas[rid,18];
                    full_mas[n,19]:= rejs_mas[rid,19];
                    full_mas[n,20]:= rejs_mas[rid,20];
                    full_mas[n,21]:= rejs_mas[rid,21];
                    full_mas[n,22]:= rejs_mas[rid,22];
                    full_mas[n,23]:= rejs_mas[rid,23];
                    full_mas[n,24]:= rejs_mas[rid,24];
                    full_mas[n,25]:= rejs_mas[rid,25];
                    full_mas[n,26]:= rejs_mas[rid,26];
                    full_mas[n,27]:= rejs_mas[rid,27];
                    full_mas[n,28]:= rejs_mas[rid,28];
                    full_mas[n,29]:= rejs_mas[rid,29];
                    full_mas[n,30]:= rejs_mas[rid,30];
                    full_mas[n,31]:= rejs_mas[rid,31];
                    full_mas[n,32]:= rejs_mas[rid,32];
                    full_mas[n,33]:= rejs_mas[rid,33];
                    full_mas[n,34]:= rejs_mas[rid,34];
                    full_mas[n,35]:= rejs_mas[rid,35];
                    full_mas[n,36]:= rejs_mas[rid,36];
                    full_mas[n,37]:= rejs_mas[rid,37];
                    full_mas[n,38]:= rejs_mas[rid,38];
                    full_mas[n,39]:= rejs_mas[rid,39];
                    full_mas[n,40]:= rejs_mas[rid,40];
                    full_mas[n,41]:= rejs_mas[rid,41];
                    full_mas[n,42]:= rejs_mas[rid,42];
                    full_mas[n,43]:= rejs_mas[rid,43];
                    full_mas[n,44]:= rejs_mas[rid,44];
                    full_mas[n,45]:= rejs_mas[rid,45];
                    full_mas[n,46]:= rejs_mas[rid,46];
                                 flfind:=true;
                                 remote_ind:=n;
                                 break;
                               end;
   end;
 If flfind then exit;
    //добавляем строчку к основному массиву
       SetLength(Full_mas,length(Full_mas)+1,full_mas_size);
          for k:=0 to full_mas_size-1 do
           begin
            //если сервер виртуальный
            If (k=0) and virtuals then
            begin
              full_mas[length(Full_mas)-1,0]:='5';
              continue;
             end;
            //If k=26 then showmessage(full_mas[rid,26] );
              full_mas[length(Full_mas)-1,k]:=rejs_mas[rid,k];
           end;
            remote_ind:=high(full_mas);
end;


procedure TForm6.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  //If utf8length(form6.Edit1.Text)=1 then form6.Edit1.SelStart:=1;
     //DELETE   up down esc enter
  If (key<41) then
   begin
     //stopseek:=true;
     exit;
   end;
  //If utf8length(TEdit(Sender).Text)=1 then TEdit(Sender).SelStart:=1;

  //If ((key>32) and (key<48)) or ((key>57) and (key<63)) or ((key>90) and (key<97)) then exit;
  //запускаем таймер ожидания поиска
   If  form6.IdleTimer1.Enabled=false then
      form6.IdleTimer1.Enabled:=true;
   If  form6.IdleTimer1.AutoEnabled=false then
      form6.IdleTimer1.AutoEnabled:=true;
end;

procedure TForm6.Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If utf8length(TEdit(Sender).Text)=1 then TEdit(Sender).SelStart:=1;
end;

procedure TForm6.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  setlength(rejs_mas,0,0);
  rejs_mas:=nil;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
  id_kuda:=0;
end;

end.

