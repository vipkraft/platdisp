unit doobil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,  LazFileUtils, Forms, Controls, Graphics,
  Dialogs,
  StdCtrls, Grids, htmlproc, web_ticket;

type

  { TForm8 }

  TForm8 = class(TForm)
    Label1: TLabel;
    Label36: TLabel;
    Label43: TLabel;
    StringGrid1: TStringGrid;
    ZConnection1: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpdateGr(); //обновить грид ведомостей для данного рейса
    //procedure TekStatus(n: integer);//добавить в массив ведомостей текущее состояние рейса
    function CheckWebTick():boolean;//проверить наличие интернет билетов
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form8: TForm8;

implementation
 uses
  platproc,maindisp,menu;

 var
   x:integer=-1;
   web:boolean=false;

{$R *.lfm}

{ TForm8 }

//добавить в массив ведомостей текущее состояние рейса
 //procedure TForm8.TekStatus(n: integer);
 //begin
 //  If n<0 then
 //      begin
 //         showmessagealt('Не определен элемент массива ведомостей данного рейса !');
 //         exit;
 //      end;
 //
 //
 //end;

 function TForm8.CheckWebTick():boolean;//проверить наличие интернет билетов
 var
  n:integer;
  bilettype:integer;
 begin
      result:=false;
      for n:=0 to length(tick_mas)-1 do
         begin
         bilettype:=0;
         try
            bilettype:=strtoint(tick_mas[n,6]);
         except
            on exception: EConvertError do
            showmessagealt('Ошибка преобразования в целое !');
         end;
          //showmessage(tick_mas[n,6]);
           If bilettype>=inettick then
           begin
           result:=true;
           break;
           end;
         end;
 end;


//**************************************** //обновить грид ведомостей для данного рейса  **********************************
procedure TForm8.UpdateGr();
var
  n:integer=0;
  soper : string='';
begin
  with Form8 do
  begin
  Stringgrid1.RowCount:=0;

  for n:=0 to length(vedom_mas)-1 do
     begin
      Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
      Stringgrid1.Cells[0,Stringgrid1.RowCount-1] := inttostr(n+1);
      Stringgrid1.Cells[1,Stringgrid1.RowCount-1] := copy(vedom_mas[n,11],1,2)+':'+copy(vedom_mas[n,11],4,2);  //время фактическое
      Stringgrid1.Cells[2,Stringgrid1.RowCount-1] := vedom_mas[n,0];   //тип ведомости
      Stringgrid1.Cells[3,Stringgrid1.RowCount-1] := vedom_mas[n,8];   //куда пункт
     end;
  //предПоследняя строка - Динамическа Общая ведомость
   //Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
   Stringgrid1.Cells[0,Stringgrid1.RowCount-1] := '-';
   Stringgrid1.Cells[1,Stringgrid1.RowCount-1] := '<--';
   Stringgrid1.Cells[2,Stringgrid1.RowCount-1] := 'Показать общую ведомость...';
   Stringgrid1.Cells[3,Stringgrid1.RowCount-1] := '-->';

  //предПоследняя строка - Динамическа Общая ведомость
   Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
   Stringgrid1.Cells[0,Stringgrid1.RowCount-1] := '-';
   Stringgrid1.Cells[1,Stringgrid1.RowCount-1] := '<--';
   Stringgrid1.Cells[2,Stringgrid1.RowCount-1] := 'Список пассажиров';
   Stringgrid1.Cells[3,Stringgrid1.RowCount-1] := '-->';


   //If web then
   //begin
    Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
   Stringgrid1.Cells[0,Stringgrid1.RowCount-1] := '|';
   Stringgrid1.Cells[1,Stringgrid1.RowCount-1] := '<--';
   Stringgrid1.Cells[2,Stringgrid1.RowCount-1] := 'Электронный билет';
   Stringgrid1.Cells[3,Stringgrid1.RowCount-1] := '-->';
   //end;
   //ZReadOnlyQuery1.Close;
   //Zconnection1.disconnect;
   Stringgrid1.ColWidths[0] := 25;
   Stringgrid1.ColWidths[1] := 50;
   Stringgrid1.ColWidths[2] := 250;
   Stringgrid1.ColWidths[3] := 160;

  end;
 end;


//*************************************    HOT KEYS    ***************************************************************
procedure TForm8.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    // ESC
   if (Key=27) then
       begin
         Form8.Close;
         key:=0;
       end;

   // Enter - Выбор ведомостей
   if (Key=13) and (Form8.StringGrid1.Focused=true) then
       begin
         //Если динамическая ведомость
        //If (trim(Stringgrid1.Cells[0,Stringgrid1.row])='-')
        //печать интернет билетов
       If Stringgrid1.Cells[0,Stringgrid1.Row] = '|' then
           begin
           key:=0;
           //открыть форму списка интернет-билетов
           FormWT:=TFormWT.create(self);
           FormWT.ShowModal;
           FreeAndNil(FormWT);

             exit;
           end;

        Form8.Close;
        If (trim(Stringgrid1.Cells[0,Stringgrid1.row])<>'') then // AND (trim(Stringgrid1.Cells[0,Stringgrid1.row])<>'-') then
            begin
            //заполнить массив билетов данного рейса
            //form1.Fillticket(x);
            Form1.Vedom_print(Stringgrid1.Row, masindex);
            end;
        key:=0;
       end;
   //
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;


procedure TForm8.FormPaint(Sender: TObject);
begin
  with Form8 do
  begin
   Canvas.Brush.Color:=clSilver;
   Canvas.Pen.Color:=clBlack;
   Canvas.Pen.Width:=2;
   Canvas.Rectangle(2,2,Width-2,Height-2);
  end;
end;


procedure TForm8.FormShow(Sender: TObject);
begin
  with Form8 do
begin
     //Выравниваем форму
 Left:=form1.Left+(form1.Width div 2)-(Width div 2);
 Top:=form1.Top+(form1.Height div 2)-(Height div 2);
  //находим элемент массива
  //x :=-1;
  //x := arr_get();
  //If x=-1 then Form8.Close;
 web:=CheckWebTick();

  If (length(vedom_mas)<1) and not web then
      begin
         Form8.close;
         exit;
      end;
 UpdateGr();     //обновить грид ведомостей
 //TekStatus(x); //текущий статус рейса
  //Заголовок № рейса
 Label1.Caption:= vedom_mas[0,1] +'/'+ vedom_mas[0,4];
 StringGrid1.SetFocus;
end;
end;



end.

