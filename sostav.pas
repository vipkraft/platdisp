unit sostav;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,platproc,dialogs,Graphics,strutils,grids,LCLProc;

// Инициализация панели+grid
procedure set_object;
// Загружаем данные по рейсу относительно выбранного рейса и расписания
function get_data():byte;
// Заполняем grid данными
procedure draw_grid();


implementation


uses maindisp,menu;

var
  mas_sostav:array of array of string;
      //mas_sostav[n,0] := id_point
      //mas_sostav[n,1] := name_locality
      //mas_sostav[n,2] := km
      //mas_sostav[n,3] := t_p
      //mas_sostav[n,4] := t_s
      //mas_sostav[n,5] := t_o
      //mas_sostav[n,6] := t_d
      //mas_sostav[n,7] := form
      //mas_sostav[n,8] := hard
      //mas_sostav[n,9]:= soft
      //mas_sostav[n,10]:= bagazh
  mas_sostav_size:integer=11;


// Заполняем grid данными
procedure draw_grid();
 var
   n:integer;
begin
   form1.StringGrid2.RowCount:=1;
   form1.StringGrid2.ColCount:=11;
   // Заголовки
   form1.StringGrid2.Cells[0,0]  :='№*ост.п';
   form1.StringGrid2.Cells[1,0]  :='Наименование*ост.пункта';
   form1.StringGrid2.Cells[2,0]  :='Время*в пути*(чч:мм)';
   form1.StringGrid2.Cells[3,0]  :='Расстояние*(км.)';
   form1.StringGrid2.Cells[4,0]  :='Время*прибытия*(чч:мм)';
   form1.StringGrid2.Cells[5,0]  :='Стоянка*(чч:мм)';
   form1.StringGrid2.Cells[6,0]  :='Время*отправления*(чч:мм)';
   form1.StringGrid2.Cells[7,0]  :='Тариф(руб.)*Ж-М2/M3';
   form1.StringGrid2.Cells[8,0]  :='Тариф(руб.)*M-М2/M3';
   form1.StringGrid2.Cells[9,0]  :='Тариф(руб.)*багаж';
   for n:=0 to length(mas_sostav)-1 do
     begin
       form1.StringGrid2.RowCount:=form1.StringGrid2.RowCount+1;
       form1.StringGrid2.Cells[0, form1.StringGrid2.RowCount-1] :=mas_sostav[n,0];
       form1.StringGrid2.Cells[1, form1.StringGrid2.RowCount-1] :=mas_sostav[n,1];
       form1.StringGrid2.Cells[2, form1.StringGrid2.RowCount-1] :=mas_sostav[n,6];
       form1.StringGrid2.Cells[3, form1.StringGrid2.RowCount-1] :=mas_sostav[n,2];
       form1.StringGrid2.Cells[4, form1.StringGrid2.RowCount-1] :=mas_sostav[n,3];
       form1.StringGrid2.Cells[5, form1.StringGrid2.RowCount-1] :=mas_sostav[n,4];
       form1.StringGrid2.Cells[6, form1.StringGrid2.RowCount-1] :=mas_sostav[n,5];
       if not(trim(mas_sostav[n,8])='0.00') then form1.StringGrid2.Cells[7, form1.StringGrid2.RowCount-1] :=mas_sostav[n,8]+' р.';
       if not(trim(mas_sostav[n,9])='0.00') then form1.StringGrid2.Cells[8, form1.StringGrid2.RowCount-1] :=mas_sostav[n,9]+' р.';

       form1.StringGrid2.Cells[9,form1.StringGrid2.RowCount-1]:=mas_sostav[n,10];
       form1.StringGrid2.Cells[10,form1.StringGrid2.RowCount-1]:=mas_sostav[n,7];

     end;
        // Размер колонок GRID
  form1.StringGrid2.ColWidths[0] := 70;
  form1.StringGrid2.ColWidths[1] := 260;
  form1.StringGrid2.ColWidths[2] := 60;
  form1.StringGrid2.ColWidths[3] := 80;
  form1.StringGrid2.ColWidths[4] := 70;
  form1.StringGrid2.ColWidths[5] := 60;
  form1.StringGrid2.ColWidths[6] := 95;
  form1.StringGrid2.ColWidths[7] := 100;
  form1.StringGrid2.ColWidths[8] := 100;
  form1.StringGrid2.ColWidths[9] := 80;
  form1.StringGrid2.ColWidths[10] := 0;

  form1.StringGrid2.DefaultRowHeight:=30;
  //form1.StringGrid2.AutoSizeColumns;

end;

// Загружаем данные по рейсу относительно выбранного рейса и расписания
function get_data():byte;
 var
   n:integer;
   tek_full_mas:integer=0;
   flag_atp:string='0';
   summa_h,summa_s:real;
   flag_i:byte=0;
begin
   Result:=0;
   // -------------------- Соединяемся с локальным сервером ----------------------
   If not(Connect2(form1.Zconnection2, flagEMU)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...');
     form1.Panel4.Visible:=false;
     Result:=1;
     exit;
    end;

  // ------------------------- Находим рейс в массиве ----------------------------
  if arr_get()=-1 then
   begin
     showmessagealt('Нет данных о текущем рейсе !'+#13+'Проверьте параметры маршрутной сети...');
     form1.ZConnection2.Disconnect;
     form1.Panel4.Visible:=false;
     Result:=1;
     exit;
   end;
   tek_full_mas:=arr_get();

  // Забираем состав из av_shedule_sostav и тарифы из av_shedule_tarif
  form1.ZQuery2.Close;
  form1.ZQuery2.SQL.Clear;
  form1.ZQuery2.SQL.Add('    select b.id_point, ');
  form1.ZQuery2.SQL.Add('       b.name as name_locality,');
  form1.ZQuery2.SQL.Add('       b.km,                      ');
  form1.ZQuery2.SQL.Add('       b.t_p,                        ');
  form1.ZQuery2.SQL.Add('       b.t_s,                           ');
  form1.ZQuery2.SQL.Add('       b.t_o,                              ');
  form1.ZQuery2.SQL.Add('       b.t_d,                                 ');
  form1.ZQuery2.SQL.Add('       c.hardm2,                           ');
  form1.ZQuery2.SQL.Add('       c.hardm3,                        ');
  form1.ZQuery2.SQL.Add('       c.softm2,                     ');
  form1.ZQuery2.SQL.Add('       c.softm3,                        ');
  form1.ZQuery2.SQL.Add('       c.bagazh,                           ');
  form1.ZQuery2.SQL.Add('       c.id_kontr,                           ');
  form1.ZQuery2.SQL.Add('       b.backout,                             ');
  form1.ZQuery2.SQL.Add('       b.form,                                   ');
  form1.ZQuery2.SQL.Add('       b.point_order,                            ');
  form1.ZQuery2.SQL.Add('       e.napr                                       ');
  form1.ZQuery2.SQL.Add(' from  av_shedule_sostav b,av_shedule_tarif c,av_trip e ');
  form1.ZQuery2.SQL.Add('where  b.del=0 and                                         ');
  form1.ZQuery2.SQL.Add('       c.del=0 and                                            ');
  form1.ZQuery2.SQL.Add('       b.point_order=c.point_order and                           ');
  form1.ZQuery2.SQL.Add('       b.id_shedule=c.id_shedule and                                ');
  form1.ZQuery2.SQL.Add('       e.id_shedule=b.id_shedule and                                   ');
  form1.ZQuery2.SQL.Add('       e.napr='+trim(full_mas[tek_full_mas,16])+' and                                   ');
  form1.ZQuery2.SQL.Add('       b.id_shedule='+trim(full_mas[tek_full_mas,1])+' and ');
  form1.ZQuery2.SQL.Add('       e.id_shedule=b.id_shedule and ');
  form1.ZQuery2.SQL.Add('       (c.id_kontr='+IFTHEN(trim(full_mas[tek_full_mas,18])='','0',trim(full_mas[tek_full_mas,18]))+' or ');
  form1.ZQuery2.SQL.Add('       c.id_kontr=0 ) and ');
  form1.ZQuery2.SQL.Add('       (not e.ot_order<'+trim(full_mas[tek_full_mas,4])+' and not e.do_order>'+trim(full_mas[tek_full_mas,7])+') and ');
  form1.ZQuery2.SQL.Add('       (b.point_order between '+trim(full_mas[tek_full_mas,4])+' and '+trim(full_mas[tek_full_mas,7])+') ');
  form1.ZQuery2.SQL.Add('       order by e.napr,e.id_shedule,b.point_order;                 ');
  try
      form1.ZQuery2.open;
    except
         showmessagealt('Нет данных по расписанию !!!'+#13+'Сообщите об этом АДМИНИСТРАТОРУ !!!');
         form1.ZQuery2.Close;
         form1.Zconnection2.disconnect;
         form1.Panel4.Visible:=false;
         Result:=1;
         exit;
    end;
  If form1.Zquery2.RecordCount=0 then
    begin
  //    showmessage(form1.ZQuery2.SQL.Text);
      showmessagealt('Нет данных по расписанию !!!'+#13+'Сообщите об этом АДМИНИСТРАТОРУ !!!');
      form1.ZQuery2.Close;
      form1.Zconnection2.disconnect;
      form1.Panel4.Visible:=false;
      Result:=1;
      exit;
    end;

  // Проверяем что имеется тариф по какому либо АТП иначе берем 0-один для всех
  for n:=0 to form1.ZQuery2.RecordCount-1 do
    begin
      if trim(form1.ZQuery2.FieldByName('id_kontr').asString)=trim(full_mas[tek_full_mas,18]) then
         begin
           flag_atp:=trim(form1.ZQuery2.FieldByName('id_kontr').asString);
           break;
         end;
      form1.ZQuery2.Next;
    end;

  // Загружаем данные в массив
  SetLength(mas_sostav,0,0);

  form1.ZQuery2.First;
  summa_h:=0;
  summa_s:=0;
  for n:=0 to form1.ZQuery2.RecordCount-1 do
   begin
    if  trim(form1.ZQuery2.FieldByName('id_kontr').asString)=flag_atp then
     begin
      //showmessage(trim(form1.ZQuery2.FieldByName('id_point').asString)+'='+trim(connectini[14]));

      // Расчет сумм
      if flag_i=1 then
       begin
        summa_h:=summa_h+strtofloat(IFTHEN(trim(full_mas[tek_full_mas,27])='1',form1.ZQuery2.FieldByName('hardm2').asString,form1.ZQuery2.FieldByName('hardm3').asString));
        summa_s:=summa_s+strtofloat(IFTHEN(trim(full_mas[tek_full_mas,27])='1',form1.ZQuery2.FieldByName('softm2').asString,form1.ZQuery2.FieldByName('softm3').asString));
       end;

      SetLength(mas_sostav,length(mas_sostav)+1,mas_sostav_size);
      mas_sostav[length(mas_sostav)-1,0] :=form1.ZQuery2.FieldByName('point_order').asString+' ['+trim(form1.ZQuery2.FieldByName('id_point').asString)+']';
      mas_sostav[length(mas_sostav)-1,1] :=form1.ZQuery2.FieldByName('name_locality').asString;
      mas_sostav[length(mas_sostav)-1,2] :=form1.ZQuery2.FieldByName('km').asString;
      mas_sostav[length(mas_sostav)-1,3] :=form1.ZQuery2.FieldByName('t_p').asString;
      mas_sostav[length(mas_sostav)-1,4] :=form1.ZQuery2.FieldByName('t_s').asString;
      mas_sostav[length(mas_sostav)-1,5] :=form1.ZQuery2.FieldByName('t_o').asString;
      mas_sostav[length(mas_sostav)-1,6] :=form1.ZQuery2.FieldByName('t_d').asString;
      mas_sostav[length(mas_sostav)-1,7] :=form1.ZQuery2.FieldByName('form').asString;
      mas_sostav[length(mas_sostav)-1,8] :=FloatToStrf(summa_h,ffFixed,15,2);
      mas_sostav[length(mas_sostav)-1,9] :=FloatToStrf(summa_s,ffFixed,15,2);

      //mas_sostav[length(mas_sostav)-1,8] :=FormatNum(IFTHEN(trim(full_mas[tek_full_mas,27])='1',form1.ZQuery2.FieldByName('hardm2').asString,form1.ZQuery2.FieldByName('hardm3').asString),2);
      //mas_sostav[length(mas_sostav)-1,9] :=FormatNum(IFTHEN(trim(full_mas[tek_full_mas,27])='1',form1.ZQuery2.FieldByName('softm2').asString,form1.ZQuery2.FieldByName('softm3').asString),2);
      mas_sostav[length(mas_sostav)-1,10]:=floattostrf(strtofloat(form1.ZQuery2.FieldByName('bagazh').asString),ffFixed,15,2);

      if trim(form1.ZQuery2.FieldByName('id_point').asString)=trim(connectini[14]) then
        begin
         flag_i:=1;
        end;

     if trim(form1.ZQuery2.FieldByName('form').asString)='1' then
       begin
         summa_h:=0;
         summa_s:=0;
       end;

     end;
      form1.ZQuery2.Next;
      //form1
    end;
  form1.ZQuery2.Close;
  form1.ZConnection2.Disconnect;
  Result:=0;
end;

// Инициализация панели+grid
procedure set_object;
begin
  // Размер панели
  form1.Panel4.Width:=1000;
  form1.Panel4.Height:=500;
  // Рамка панели
  form1.Panel4.Left:=(form1.width div 2)-(form1.Panel4.Width div 2);
  form1.Panel4.Top:=(form1.Height div 2)-(form1.Panel4.Height div 2);
// Позиционирование GRID
  form1.StringGrid2.Width:=form1.Panel4.Width-20;
  form1.StringGrid2.Height:=form1.Panel4.Height-20;
  form1.StringGrid2.Left:=10;
  form1.StringGrid2.top:=10;

// Выводим ПАНЕЛЬ на экран
  if get_data()=1 then
     begin
       form1.Panel4.Visible:=false;
       exit;
     end;
// Выводим информацию на GRID
   draw_grid();

  form1.Panel4.Visible:=true;
  form1.StringGrid2.Visible:=true;
  form1.Panel4.Refresh;
  form1.StringGrid2.Refresh;
  form1.StringGrid2.SetFocus;
end;







end.

