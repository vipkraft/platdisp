unit wibor_atp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,  LazFileUtils, Forms, Controls, Graphics,
  Dialogs, Grids, StdCtrls,LazUTF8;

type

  { TForm3 }

  TForm3 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label43: TLabel;
    StringGrid1: TStringGrid;
    ZConnection1: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;

    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    // Рисуем Grid по фильтру поиска
    procedure fill_grid(filter_type,filter_word:string);
    // заполняем массив атп
    procedure fill_array;


  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;
  wibor_id_atp:string='';
  wibor_name_atp:string='';

implementation

uses
  maindisp,platproc,menu,zakaz_main;
var
  //search_str:string='';
  mas_atp:array of array of string;

{$R *.lfm}


// Рисуем Grid по фильтру поиска
procedure TForm3.fill_grid(filter_type,filter_word:string);
 var
   n,dogovor:integer;
   find:boolean;
begin
   If length(mas_atp)=0 then
     begin
      showmessagealt('Нет данных по ПЕРЕВОЗЧИКАМ для выбранного расписания !!!'+#13+'Обратитесь в отдел Пассажирских перевозок...');
      form3.Close;
     end;
 form3.StringGrid1.RowCount:=1;
 for n:=0 to length(mas_atp)-1 do
   begin
    find:=false;
    //-----------Применяем фильтры ---------------------------
    // 1. Если filter_type = 0
    if filter_type='0' then
       begin
        find:=true;
        form3.StringGrid1.RowCount:=form3.StringGrid1.RowCount+1;
        form3.StringGrid1.Cells[0,form3.StringGrid1.RowCount-1]:=mas_atp[n,0];
        form3.StringGrid1.Cells[1,form3.StringGrid1.RowCount-1]:=mas_atp[n,1];
       end;
    // 2. Если filter_type = 1 - код атп
    if filter_type='1' then
       begin
        if UPPERALL(UTF8Copy(trim(mas_atp[n,0]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
         begin
          find:=true;
          form3.StringGrid1.RowCount:=form3.StringGrid1.RowCount+1;
          form3.StringGrid1.Cells[0,form3.StringGrid1.RowCount-1]:=mas_atp[n,0];
          form3.StringGrid1.Cells[1,form3.StringGrid1.RowCount-1]:=mas_atp[n,1];
         end;
       end;
    // 3. Если filter_type = 2 - наименование атп
    if filter_type='2' then
       begin
        if UPPERALL(UTF8Copy(trim(mas_atp[n,1]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
         begin
          find:=true;
          form3.StringGrid1.RowCount:=form3.StringGrid1.RowCount+1;
          form3.StringGrid1.Cells[0,form3.StringGrid1.RowCount-1]:=mas_atp[n,0];
          form3.StringGrid1.Cells[1,form3.StringGrid1.RowCount-1]:=mas_atp[n,1];
         end;
       end;
    If find then
     begin
    try
     dogovor:=strtoint(mas_atp[n,2]);
    except
     continue;
    end;
     If dogovor<0 then form3.StringGrid1.Cells[1,form3.StringGrid1.RowCount-1]:=form3.StringGrid1.Cells[1,form3.StringGrid1.RowCount-1]+'   <!> ДОГОВОР ПРОСРОЧЕН <!>';
     end;
   end;
  //form3.StringGrid1.SetFocus;
end;


//**********    ЗАПОЛНЯЕМ МАССИВ АТП  ************************************************
procedure TForm3.fill_array;
var
   n:integer;
begin
 //если рейс не заказной и не удаленки, то просто отображаем всех перевозчиков
    If (zkaz=false) and (udalenka_real=false) then
   begin
      If length(tmp_atp)=0 then exit;
       SetLength(mas_atp,0,0);
  for n:=0 to length(tmp_atp)-1 do
    begin
      setlength(mas_atp,length(mas_atp)+1,3);
      mas_atp[length(mas_atp)-1,0]:=tmp_atp[n,0];
      mas_atp[length(mas_atp)-1,1]:=tmp_atp[n,1];
      mas_atp[length(mas_atp)-1,2]:='1';
    end;
  form3.fill_grid('0','');
  exit;
   end;

    // -------------------- Соединяемся с локальным сервером ----------------------
   If not(Connect2(form3.Zconnection1, 2)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     form3.close;
     exit;
    end;
   // Заправшиваем всех перевозчиков в локальной маршрутной сети
   form3.ZReadOnlyQuery1.sql.Clear;

   //form3.ZReadOnlyQuery1.sql.add('SELECT distinct on (h.id_kontr) ');
   //form3.ZReadOnlyQuery1.sql.add('h.id_kontr,b.datazak as dates,b.datapog as datepo ');
   //form3.ZReadOnlyQuery1.sql.add(',(select g.name FROM av_spr_kontragent g WHere g.del=0 AND g.id=h.id_kontr ORDER BY g.createdate DESC LIMIT 1 OFFSET 0) as name_kontr ');
   //form3.ZReadOnlyQuery1.sql.add('FROM av_spr_kontr_ats h ');
   //form3.ZReadOnlyQuery1.sql.add('JOIN av_spr_kontr_dog b ON b.del=0 AND h.id_kontr=b.id_kontr and ');
   //form3.ZReadOnlyQuery1.sql.add('b.datazak<='+quotedstr(trim(datetostr(work_date)))+' and b.datapog>='+quotedstr(trim(datetostr(work_date)))+' AND (cast(case WHEN trim(a.viddog)='''' then ''0'' ELSE coalesce(a.viddog,''0'') END AS integer)=2) ');
   //form3.ZReadOnlyQuery1.sql.add('WHERE h.del=0 order by h.id_kontr; ');

   form3.ZReadOnlyQuery1.sql.add('SELECT s.* FROM ( ');
   form3.ZReadOnlyQuery1.sql.add('SELECT v.*            ');
   form3.ZReadOnlyQuery1.sql.add(' ,date_mi(v.dataz,current_date) as diff ');
   form3.ZReadOnlyQuery1.sql.add('FROM ( ');
   form3.ZReadOnlyQuery1.sql.add('SELECT m.id,m.name,m.polname,m.vidkontr,m.kod1c,m.inn,m.tel,m.adrur,m.document,m.del ');
   form3.ZReadOnlyQuery1.sql.add(',(SELECT max(datapog) FROM av_spr_kontr_dog ');
   form3.ZReadOnlyQuery1.sql.add('WHERE del=0 AND id_kontr=m.id ');
   form3.ZReadOnlyQuery1.sql.add('AND (cast(case WHEN trim(viddog)='''' then ''0'' ELSE coalesce(viddog,''0'') END AS integer)=2) AND datapog is not null ');
   form3.ZReadOnlyQuery1.sql.add(') as dataz ');
   form3.ZReadOnlyQuery1.sql.add('FROM av_spr_kontragent m ');
   form3.ZReadOnlyQuery1.sql.add('WHERE m.del=0 ');
   form3.ZReadOnlyQuery1.sql.add(') v ) s ');
   form3.ZReadOnlyQuery1.sql.add('where dataz is not null ');
   form3.ZReadOnlyQuery1.sql.add('AND diff>-367 ');
   form3.ZReadOnlyQuery1.sql.add('ORDER BY name ASC; ');

   //showmessage(form3.ZReadOnlyQuery1.SQL.Text);//$
  try
      form3.ZReadOnlyQuery1.open;
  except
    showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ZReadOnlyQuery1.SQL.Text);
         form3.ZReadOnlyQuery1.Close;
         form3.Zconnection1.disconnect;
         form3.Close;
         exit;
    end;
  IF form3.ZReadOnlyQuery1.RecordCount=0 then
    begin
      showmessagealt('Нет данных по ПЕРЕВОЗЧИКАМ для выбранного расписания !!!'+#13+'Обратитесь в отдел Пассажирских перевозок...');
      form3.ZReadOnlyQuery1.Close;
      form3.Zconnection1.disconnect;
      form3.Close;
      exit;
    end;
  SetLength(mas_atp,0,0);
  for n:=0 to form3.ZReadOnlyQuery1.RecordCount-1 do
    begin
      setlength(mas_atp,length(mas_atp)+1,3);
      mas_atp[length(mas_atp)-1,0]:=form3.ZReadOnlyQuery1.FieldByName('id').asString;
      mas_atp[length(mas_atp)-1,1]:=form3.ZReadOnlyQuery1.FieldByName('name').asString;
      mas_atp[length(mas_atp)-1,2]:=form3.ZReadOnlyQuery1.FieldByName('diff').asString;
      form3.ZReadOnlyQuery1.Next;
    end;

  form3.ZReadOnlyQuery1.Close;
  form3.Zconnection1.disconnect;
  form3.fill_grid('0','');
end;


procedure TForm3.Edit1Change(Sender: TObject);
begin
  if UTF8Length(trim(form3.Edit1.Text))>0 then
       begin
           if (trim(form3.Edit1.Text)[1] in ['0'..'9']) then
             form3.fill_grid('1',trim(form3.Edit1.Text))
           else form3.fill_grid('2',trim(form3.Edit1.Text));
       end
  else
  //if UTF8Length(trim(form3.Edit1.Text))=0 then
     begin
       //showmessage(form3.Edit1.Text);
      form3.fill_grid('0','');
      form3.Edit1.Visible:=false;
     end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;


//****************************************** HOT KEYS *******************************************************
procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 // Вверх по списку АТП
   //if (Key=38) and (form3.edit1.enabled=true) then
   if (Key=38) and (form3.edit1.visible=true) then
     begin
      form3.Edit1.Visible:=false;
      form3.StringGrid1.SetFocus;
      exit;
     end;
  // Вниз по списку АТП
   if (Key=40) and (form3.edit1.visible=true) then
   //if (Key=40) and (form3.edit1.enabled=true) then
     begin
       form3.Edit1.Visible:=false;
       form3.StringGrid1.SetFocus;
       exit;
     end;

    // Контекcтный поиск
   if form3.Edit1.Visible=false then
     begin
       If (get_type_char(key)>0) or (key=8) or (key=46) or (key=96) then //8-backspace 46-delete 96- numpad 0
       begin
         form3.Edit1.text:='';
         form3.Edit1.Visible:=true;
         form3.Edit1.SetFocus;
       end;
     end;

    // ENTER - остановить контекстный поиск
   if (Key=13) AND (form3.Edit1.Focused) then
     begin
       key:=0;
       form3.Edit1.Visible:=false;
       form3.StringGrid1.SetFocus;
     end;

   // ESC поиск
   if (Key=27) and (form3.Edit1.Visible=true) then
       begin
         key:=0;
         form3.Edit1.Visible:=false;
         form3.Edit1.Text:='';
         form3.StringGrid1.SetFocus;
       end;

   // ESC форма
   if (Key=27) and (form3.Edit1.Visible=false) then
       begin
         wibor_id_atp:='';
         wibor_name_atp:='';
         key:=0;
         form3.Close;
         exit;
       end;

   // ENTER выбор значения
   if (Key=13) AND (form3.StringGrid1.Focused) then
       begin
         If pos('<!>',form3.StringGrid1.Cells[1,form3.StringGrid1.Row])>0 then
           begin
             showmessage('НЕЛЬЗЯ выбрать перевозчика с истекшим договором !'+#13+'Обратитесь в отдел перевозок...');
             exit;
           end;
         wibor_id_atp:=form3.StringGrid1.Cells[0,form3.StringGrid1.Row];
         wibor_name_atp:=form3.StringGrid1.Cells[1,form3.StringGrid1.Row];
         SetLength(mas_atp,0,0);
         key:=0;
         form3.Close;
         exit;
       end;
end;


procedure TForm3.FormPaint(Sender: TObject);
begin
   form3.Canvas.Brush.Color:=clSilver;
   form3.Canvas.Pen.Color:=clBlack;
   form3.Canvas.Pen.Width:=2;
   form3.Canvas.Rectangle(2,2,form3.Width-2,form3.Height-2);
end;


procedure TForm3.FormShow(Sender: TObject);
begin
  //Выравниваем форму
 form3.Left:=form1.Left+(form1.Width div 2)-(form3.Width div 2);
 form3.Top:=form1.Top+(form1.Height div 2)-(form3.Height div 2);
 form3.fill_array;
end;



end.

