unit zakaz;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,platproc,dialogs,Graphics,strutils,grids,LCLProc,forms;

// Инициализация панели+объекты панели
procedure set_object_zakaz(index_a:integer);


implementation

uses maindisp,menu;

// Инициализация панели+grid
procedure set_object_zakaz(index_a:integer);
begin

 // ---- Размеры панели
 form1.Panel5.Width:=610;
 form1.Panel5.Height:=696;
 form1.Panel5.Left:=(form1.Width div 2)-(form1.Panel5.Width div 2);
 form1.Panel5.top:=(form1.Height div 2)-(form1.Panel5.Height div 2);



 // Верхняя строка заголовка
 form1.Label36.Caption:='Создание ЗАКАЗНОГО РЕЙСА на '+datetostr(work_date);
 // Нижняя строка заголовка
 form1.Label37.Caption:='['+trim(full_mas[index_a,1])+'] '+trim(full_mas[index_a,5])+' - '+trim(full_mas[index_a,8]);
 // Новое время отправления
 form1.DateTimePicker1.Time:=strtotime(full_mas[index_a,10])+60;
 // Наименование перевозчика
 form1.edit1.Text:='['+trim(full_mas[index_a,18])+'] '+trim(full_mas[index_a,19]);

 // Показываем панель с элементами
 form1.Panel5.Visible:=true;

end;





end.

