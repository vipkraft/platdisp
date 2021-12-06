unit htmlproc;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils,  LazFileUtils, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
 {$IFDEF UNIX}
  unix,
  {$ENDIF}
 platproc,strutils;

// Начало HTML (fileHTML:десткриптор файла,filename:имя файла)
function StartHTML(filename:string):boolean;
// Конец HTML (fileHTML:десткриптор файла)
procedure EndHTML();
// Создание строки HTML (строка,выравнивание:1-влево,2-вправо,3-центр,размер шрифта,стиль шрифта: нормальный,большой,наклонный,большой наклонный,цвет шрифта:FF0000)
procedure SetHTMLString(stroka:string;alignstroka:byte;sizefont:byte;stylefont:byte;fontcolor:string);
// Начало таблицы
procedure StartTableHTML(border:byte;width:string; al:byte);
// Конец таблицы
procedure EndTableHTML();
// Начало строки таблицы
procedure StartRowTableHTML(valign:string);
// Конец строки таблицы
procedure EndRowTableHTML();
// Ячейка таблицы
procedure CellsTableHTML(stroka:string;alignstroka:byte;sizefont:byte;stylefont:byte;fontcolor:string;colspan:byte;rowspan:byte; width:string);
//Вывод отчета
procedure startbrowser(FileHtmlName:string);
// Пустая строка
procedure EmptyLine();
// Пустая строка
procedure Split();

var
  fileHTML:TextFile;

implementation


//************************************* ЗАПУСК PLATHTML ДЛЯ ПЕЧАТИ ОТЧЕТА ********************************************************************************
procedure startbrowser(FileHtmlName:string); //Пример вывода HTML отчета
begin
    {$IFDEF Win32}
 //showmessage(FileHTMLname);
     ExecuteProcess(GetEnvironmentVariable('COMSPEC'), ['/c', 'explorer.exe '+' '+'"'+(trim(FileHTMLname))+'"']);
    // ExecuteProcess(GetEnvironmentVariable('COMSPEC'),
    // ['/c',''+GetEnvironmentVariable('ProgramFiles')+'\Internet Explorer\iexplore.exe'+'“',trim(FileHTMLname)]);
    //ExecuteProcess(GetEnvironmentVariable('ProgramFiles')+'\Internet Explorer\iexplore.exe', ['-k']);
    //ALLUSERSPROFILE,APPDATA,BDS,CLIENTNAME,CommonProgramFiles,COMPUTERNAME,ComSpec,Cor_Debugging_Control_424242,DBCONFIG,DBROOT,DBWORK HOMEDRIVE,HOMEPATH,INCLUDE,LIB,LOGONSERVER,NUMBER_OF_PROCESSORS,OS_ROOTDIR,OS_TMPDIR,OS,Path,PATHEXT,PROCESSOR_ARCHITECTURE, PROCESSOR_IDENTIFIER,PROCESSOR_LEVEL,PROCESSOR_REVISION,ProgramFiles,SESSIONNAME,SystemDrive,SystemRoot,TEMP,TMP,USERDOMAIN USERNAME,USERPROFILE,windir
 {$ENDIF}
 {$IFDEF UNIX}
 if not(FileExistsUTF8(ExtractFilePath(Application.ExeName)+'plathtml')) then
               begin
                showmessagealt('Отсутствует приложение '+ExtractFilePath(Application.ExeName)+'plathtml'+' !');
                exit;
               end;
                // Запускаем внешнее приложение
  fpsystem(ExtractFilePath(Application.ExeName)+'plathtml'+' '+trim(FileHTMLname)+' &');
  {$ENDIF}
end;


// Начало таблицы
procedure StartTableHTML(border:byte;width:string; al:byte);
var
  align:string;
begin
  //writeln(fileHTML,'<table style="text-align: left; width: 100%;" border="1" border color="#000000" cellpadding="1" cellspacing="1"><tbody>');
//  writeln(fileHTML,'<table align="left" valign="middle" height="20" width="90%" height="90%" border="1" bordercolor="#000000" cellpadding="4" cellspacing="0"><tbody>');
  If trim(width)='' then width:='100%';
  //Если рисовать рамку, то выравнивать по центру, если нет, то выравнивать по левому краю
  case al of
    1: align:='left';
    2: align:='right';
    3: align:='center';
    end;
   writeln(fileHTML,'<table width="'+width+'" align="'+align+'" valign="middle" border="'+inttostr(border)+'" bordercolor=#000000 cellpadding="3" cellspacing="0"><tbody>');

{  <table style="font-size : 16px; font-family : Arial;">
<tr>
<td> тест тест тест</td>
</tr>
</table>}
end;

// Конец таблицы
procedure EndTableHTML();
begin
   writeln(fileHTML,'</tbody></table>');
end;

// Пустая строка
procedure Split();
begin
   writeln(fileHTML,'<hr noshade size=1>');
end;

// Пустая строка
procedure EmptyLine();
begin
   writeln(fileHTML,'<p>&nbsp;</p>');
end;

// Начало строки таблицы
procedure StartRowTableHTML(valign:string);
begin
   writeln(fileHTML,'<tr valign='+Quotedstr(valign)+'>');

end;

// Конец строки таблицы
procedure EndRowTableHTML();
begin
   writeln(fileHTML,'</tr>');
end;

// Ячейка таблицы
procedure CellsTableHTML(stroka:string;alignstroka:byte;sizefont:byte;stylefont:byte;fontcolor:string;colspan:byte;rowspan:byte; width:string);
 var
   texthtml:string;
begin
  stroka:=StringReplace(stroka, ' ','&nbsp;', [rfReplaceAll]);
  //stroka:=UTF8Encode(AnsiReplaceText(UTF8Decode(trim(stroka)),' ', '&nbsp;'));
  //stroka:=stroka+' &nbsp';
  //stroka := UTF8toANSI(stroka);
  // Цвет шрифта
  texthtml:='<td ';

  // Выравнивание текста
  // Влево
  if alignstroka=1 then texthtml:=texthtml+'align= "left"';
  // Вправо
  if alignstroka=2 then texthtml:=texthtml+'align= "right"';
  // Центр
  if alignstroka=3 then texthtml:=texthtml+'align= "center"';
  // По ширине
  if alignstroka=4 then texthtml:=texthtml+'align= "justify"';
//  texthtml:=texthtml+' valign="middle" STYLE="border:2px;padding:5px">';
 // texthtml:=texthtml+' valign="middle" border="1" bordercolor="#000000" padding="1">';

// объединение колонок
  If colspan>1 then texthtml:=texthtml+' colspan='+inttostr(colspan);

// объединение строк
  If rowspan>1 then texthtml:=texthtml+' rowspan='+inttostr(rowspan);

  //ширина ячейки
  If (trim(width)<>'') and (trim(width)<>'-1') then
    texthtml:=texthtml+' width="'+width+'"';

  texthtml:=texthtml+'>';

  texthtml:=texthtml+'<font color=#'+trim(fontcolor)+'>';

  // Размер шрифта
  texthtml:=texthtml+'<font size="'+inttostr(sizefont)+'">';


  // Стиль шрифта + Строка текста
 // Нормальный
 if stylefont=1 then texthtml:=texthtml+trim(stroka);
 // Большой
 if stylefont=2 then texthtml:=texthtml+'<strong>'+trim(stroka)+'</strong>';
 // Наклонный
 if stylefont=3 then texthtml:=texthtml+'<em>'+trim(stroka)+'</em>';
 // Большой+Наклонный
 if stylefont=4 then texthtml:=texthtml+'<strong><em>'+trim(stroka)+'</em></strong>';
 // Подчеркнутый
 if stylefont=5 then texthtml:=texthtml+'<u>'+trim(stroka)+'</u>';

 writeln(fileHTML,texthtml+'</font></td>');
end;


// Начало HTML (filename:десткриптор файла)
function StartHTML(filename:string):boolean;
begin
  DeleteFile(filename);
  AssignFile(fileHTML,filename);
  {$I-} // отключение контроля ошибок ввода-вывода
  Rewrite(fileHTML); // открытие файла для чтения
  if IOResult<>0 then // если есть ошибка открытия, то
  begin
    showmessagealt('Ошибка создания файла документа !');
    result:=false;
    Exit;
  end;
   {$I+} // включение контроля ошибок ввода-вывода
 writeln(fileHTML,'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">');
 writeln(fileHTML,'<html><head><meta content="text/html; charset=UTF-8" http-equiv="content-type"><title>'+trim(filename)+'</title></head>');
 writeln(fileHTML,'<body>');

 result:=true;
end;

// Конец HTML (filename:десткриптор файла)
procedure EndHTML();
begin
  writeln(fileHTML,'</body>');
  writeln(fileHTML,'</html>');
  closefile(fileHTML);
end;

// Создание строки HTML (строка,выравнивание:1-влево,2-вправо,3-центр,4-по ширине,размер шрифта:1-7,стиль шрифта: нормальный,большой,наклонный,наклонный большой,цвет шрифта:FF0000)
procedure SetHTMLString(stroka:string;alignstroka:byte;sizefont:byte;stylefont:byte;fontcolor:string);
 var
   texthtml,stroka2:string;
begin
  // Перевод строки
  if trim(stroka)='' then
    begin
      writeln(fileHTML,'<br>');
      exit;
    end;
 //stroka:= StringReplace(stroka,' ', '&nbsp;',[rfReplaceAll, rfIgnoreCase]);
 stroka:=StringReplace(stroka, ' ','&nbsp;', [rfReplaceAll]);
 //stroka:=UTF8Encode(AnsiReplaceText(UTF8Decode(trim(stroka)),' ', '&nbsp;'));
  // // Влево
  //if alignstroka=1 then texthtml:='<left>';
  //// Вправо
  //if alignstroka=2 then texthtml:='<right>';
  //// Центр
  //if alignstroka=3 then texthtml:='<center>';
  //// По ширине
  //if alignstroka=4 then texthtml:='<justify';
     // Влево
     case alignstroka of
       1: texthtml:='<p align="left">';
       2: texthtml:='<p align="right">';
       3: texthtml:='<p align="center">';
       4: texthtml:='<p align="justify">';
     end;

  // Цвет шрифта
  texthtml:=texthtml+'<font color=#'+trim(fontcolor)+'>';
 { texthtml:=texthtml+'color: '+trim(fontcolor)+'; ';}

 // Размер шрифта
 texthtml:=texthtml+'<font size="'+inttostr(sizefont)+'">';
 //texthtml:=texthtml+'font-size: '+inttostr(sizefont)+'pt'+'">';

  // Стиль шрифта + Строка текста
 // Нормальный
 if stylefont=1 then texthtml:=texthtml+trim(stroka);
 // Большой
 if stylefont=2 then texthtml:=texthtml+'<strong>'+trim(stroka)+'</strong>';
 // Наклонный
 if stylefont=3 then texthtml:=texthtml+'<em>'+trim(stroka)+'</em>';
 // Большой+Наклонный
 if stylefont=4 then texthtml:=texthtml+'<strong><em>'+trim(stroka)+'</em></strong>';

 // Закрываем параграф
 texthtml:=trim(texthtml)+'</font></font>';

 texthtml:= texthtml+'</p>';
 //// Влево
 //if alignstroka=1 then texthtml:=texthtml+'</left>';
 //// Вправо
 //if alignstroka=2 then texthtml:=texthtml+'</right>';
 //// Центр
 //if alignstroka=3 then texthtml:=texthtml+'</center>';
 //// По ширине
 //if alignstroka=4 then texthtml:=texthtml+'</justify';

  // Пишем строку
  writeln(fileHTML,trim(texthtml));

end;
end.

