unit wibor_ats;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,  LazFileUtils, Forms, Controls, Graphics,
  Dialogs, Grids, StdCtrls,LazUTF8,StrUtils;

type

  { TForm5 }

  TForm5 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label43: TLabel;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure fill_array;

    // Цифра или буква ?
    //function get_type_char(keyU:integer):byte;
    // Рисуем Grid по фильтру поиска
    procedure fill_grid(filter_type,filter_word:string);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form5: TForm5;
  wibor_id_ats:string='';
  wibor_name_ats:string='';

implementation

uses
  maindisp,platproc,menu,zakaz_main;

var
  //search_str:string='';
  mas_ats:array of array of string;

{$R *.lfm}
 // Рисуем Grid по фильтру поиска
procedure Tform5.fill_grid(filter_type,filter_word:string);
 var
   n:integer;
begin
 form5.StringGrid1.RowCount:=1;
 for n:=0 to length(mas_ats)-1 do
   begin
    //-----------Применяем фильтры ---------------------------
    // 1. Если filter_type = 0
    if filter_type='0' then
       begin
        form5.StringGrid1.RowCount:=form5.StringGrid1.RowCount+1;
        form5.StringGrid1.Cells[0,form5.StringGrid1.RowCount-1]:=mas_ats[n,0];
        form5.StringGrid1.Cells[1,form5.StringGrid1.RowCount-1]:=mas_ats[n,1];
       end;

    // 2. Если filter_type = 1 - код атс
    if filter_type='1' then
       begin
        if UPPERALL(UTF8Copy(trim(mas_ats[n,0]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
         begin
          form5.StringGrid1.RowCount:=form5.StringGrid1.RowCount+1;
          form5.StringGrid1.Cells[0,form5.StringGrid1.RowCount-1]:=mas_ats[n,0];
          form5.StringGrid1.Cells[1,form5.StringGrid1.RowCount-1]:=mas_ats[n,1];
         end;
       end;
    // 3. Если filter_type = 2 - наименование атс
    if filter_type='2' then
       begin
        if UPPERALL(UTF8Copy(trim(mas_ats[n,1]),1,UTF8Length(trim(filter_word))))=UpperAll(trim(filter_word)) then
         begin
          form5.StringGrid1.RowCount:=form5.StringGrid1.RowCount+1;
          form5.StringGrid1.Cells[0,form5.StringGrid1.RowCount-1]:=mas_ats[n,0];
          form5.StringGrid1.Cells[1,form5.StringGrid1.RowCount-1]:=mas_ats[n,1];
         end;
       end;
   end;
end;


// Цифра или буква ?
//function Tform5.get_type_char(keyU:integer):byte;
//// 1-цифра
//// 2-буква
//begin
//  if (chr(keyU) in ['0'..'9']) then Result:=1;
//  if (chr(keyU) in ['A'..'Z','a'..'z',#186,#188,#190,#219,#222]) then Result:=2;
//end;


procedure Tform5.fill_array;
 var
   n:integer;
begin
   // Заправшиваем всех АТС из массива
  setlength(mas_ats,0,0);
  for n:=0 to length(tmp_ats)-1 do
    begin
      if trim(tmp_ats[n,0])=trim(tmp_atp[tek_mas_atp,0]) then
       begin
        setlength(mas_ats,length(mas_ats)+1,2);
        mas_ats[length(mas_ats)-1,0]:=tmp_ats[n,1];
        mas_ats[length(mas_ats)-1,1]:= '['+IFTHEN(trim(tmp_ats[n,5])='1','M2','M3')+'] '+
                                                  trim(tmp_ats[n,2])+
                                                  ' ГН:'+
                                                  trim(tmp_ats[n,3])+
                                                  ' мест:'+
                                                  trim(tmp_ats[n,4]);
       end;
    end;
  form5.fill_grid('0','');
end;

procedure Tform5.Edit1Change(Sender: TObject);
begin
  if UTF8Length(trim(form5.Edit1.Text))>0 then
       begin
           if (trim(form5.Edit1.Text)[1] in ['0'..'9']) then
             form5.fill_grid('1',trim(form5.Edit1.Text))
           else form5.fill_grid('2',trim(form5.Edit1.Text));
       end
  else
  //if UTF8Length(trim(form5.Edit1.Text))=0 then
     begin
      form5.fill_grid('0','');
      form5.Edit1.Visible:=false;
     end;
end;

procedure TForm5.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState  );
begin
  // Вверх по списку АТС
   //if (Key=38) and (form5.edit1.enabled=true) then
  if (Key=38) and (form5.edit1.visible=true) then
     begin
      form5.Edit1.Visible:=false;
      form5.StringGrid1.SetFocus;
      exit;
     end;
  // Вниз по списку АТС
   if (Key=40) and (form5.edit1.visible=true) then
   //if (Key=40) and (form5.edit1.enabled=true) then
     begin
       form5.Edit1.Visible:=false;
       form5.StringGrid1.SetFocus;
       exit;
     end;

     // ENTER - остановить контекстный поиск
   if (Key=13) AND (form5.Edit1.Focused) then
     begin
        key:=0;
       form5.Edit1.Visible:=false;
       form5.StringGrid1.SetFocus;
     end;

    // Контекcтный поиск
   if form5.Edit1.Visible=false then
     begin
       If (get_type_char(key)>0) or (key=8) or (key=46) or (key=96) then //8-backspace 46-delete 96- numpad 0
       begin
         form5.Edit1.text:='';
         form5.Edit1.Visible:=true;
         form5.Edit1.SetFocus;
       end;
     end;

   // ESC поиск
   if (Key=27) and (form5.Edit1.Visible=true) then
       begin
         key:=0;
         //form5.Edit1.Text:='';
         form5.Edit1.Visible:=false;
         form5.StringGrid1.SetFocus;
       end;

   // ESC форма
   if (Key=27) and (form5.Edit1.Visible=false) then
       begin
         wibor_id_ats:='';
         wibor_name_ats:='';
         key:=0;
         form5.Close;
         exit;
       end;

   // ENTER выбор значения
   if (Key=13) AND (form5.StringGrid1.Focused) then
       begin
         wibor_id_ats:=form5.StringGrid1.Cells[0,form5.StringGrid1.Row];
         wibor_name_ats:=form5.StringGrid1.Cells[1,form5.StringGrid1.Row];
         SetLength(mas_ats,0,0);
         form5.Close;
         key:=0;
         exit;
       end;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;


procedure TForm5.FormPaint(Sender: TObject);
begin
   form5.Canvas.Brush.Color:=clSilver;
   form5.Canvas.Pen.Color:=clBlack;
   form5.Canvas.Pen.Width:=2;
   form5.Canvas.Rectangle(2,2,form5.Width-2,form5.Height-2);
end;


procedure TForm5.FormShow(Sender: TObject);
begin
    //Выравниваем форму
 form5.Left:=form1.Left+(form1.Width div 2)-(form5.Width div 2);
 form5.Top:=form1.Top+(form1.Height div 2)-(form5.Height div 2);
 form5.fill_array;
 form5.StringGrid1.SetFocus;
end;

end.

