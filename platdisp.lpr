program platDisp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, Maindisp, platproc, zcomponent
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='АСПБ ПЛАТФОРМА АВ - АРМ ДИСПЕТЧЕР';
  //if ParamCount < 1 then
  // begin
  //  showmessagealt('Параметры загрузки приложения указаны неправильно !!!');
  //  halt;
  //end;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

