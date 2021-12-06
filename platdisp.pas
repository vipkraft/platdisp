program platdisp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent,
  lazmouseandkeyinput, printer4lazarus, datetimectrls,
  maindisp, platproc, zakaz_main, wibor_atp, sostav_main, wibor_ats,
  message_idle, menu, doobil,
  //htmlproc,
  vedom_view, vedom_html, rserver, remote,
  version_info, Unused, mess, web_ticket, Auth; //, unit1;
  //, ffind


{$R *.res}

begin
  Application.Title:='АСПБ ПЛАТФОРМА АВ АРМ ДИСПЕТЧЕР';
  //if ParamCount < 1 then
  // begin
  //  showmessagealt('Параметры загрузки приложения указаны неправильно !!!');
  //  halt;
  //end;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  //Application.CreateForm(TFormMenu, FormMenu);
  //Application.CreateForm(TForm6, Form6);
  //Application.CreateForm(TForm3, Form3);
  //Application.CreateForm(TForm4, Form4);
  //Application.CreateForm(TForm5, Form5);
  //Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

