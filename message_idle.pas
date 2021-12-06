unit message_idle;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,  LazFileUtils, Forms, Controls, Graphics, ExtCtrls;

type

  { TFormIdle }

  TFormIdle = class(TForm)
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormIdle: TFormIdle;


implementation
uses
  maindisp,platproc;
var
  tiktik:integer=0;

  {$R *.lfm}

{ TFormIdle }


procedure TFormIdle.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   formIdle.Timer1.Enabled:=false;
   CloseAction:=CaFree;
end;

procedure TFormIdle.FormCreate(Sender: TObject);
begin
   // Обработчик исключений
  Application.OnException:=@form1.MyExceptionHandler;
end;

procedure TFormIdle.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState  );
begin
  //If (key=13) or (key=27) then
  //begin
    key:=0;
    FormIdle.Close;
  //end;
end;

procedure TFormIdle.FormShow(Sender: TObject);
begin
  tiktik:=0;
end;


procedure TFormIdle.Timer1Timer(Sender: TObject);
 var
   i,tw,th:integer;
   fname:string;
begin
   //showmessage(inttostr(timeout_signal));
  //info := 'ПОДОЖДИТЕ ! Подключение к серверу... ';
  tiktik:=tiktik+1;
  FormIdle.Canvas.Font.size:=20;
  FormIdle.Canvas.Font.style:=[fsBold];
  FormIdle.Canvas.Brush.Color:=clBlack;
  FormIdle.canvas.FillRect(0,0,FormIdle.Width,FormIdle.Height);
  tw:=FormIdle.Canvas.TextWidth(info+inttostr(timeout_signal-tiktik)+' сек.');
  th:=FormIdle.Canvas.TextHeight(info+inttostr(timeout_signal-tiktik)+' сек.');
  FormIdle.Canvas.Font.Color:=clMaroon;
  FormIdle.Canvas.TextOut((FormIdle.Width div 2)-(tw div 2)-2,(FormIdle.Height div 2)-(th div 2)-2,info+inttostr(timeout_signal-tiktik)+' сек.');
  FormIdle.Canvas.Font.Color:=clRed;
  FormIdle.Canvas.TextOut((FormIdle.Width div 2)-(tw div 2),(FormIdle.Height div 2)-(th div 2),info+inttostr(timeout_signal-tiktik)+' сек.');
  //FormIdle.Repaint;
  //application.ProcessMessages;
  //если нужно закрывать формы и истек таймер, закрываем все открытые формы, кроме главной
  if (tiktik=timeout_signal) AND flclose then
     begin
          for i:=0 to screen.FormCount-1 do
               begin
                fname:=uppercase(trim(screen.Forms[i].Name));
                if (fname<>'FORM1') and (fname<>'FORMMAIN') then
                   begin
                     screen.Forms[i].Close;
                   end;
               end;
          timeout_local:=0;
          timeout_global:=0;
          form1.IdleTimer1.AutoEnabled:=false;
          form1.IdleTimer1.Enabled:=false;
          flclose:=false;
       //FormIdle.Close;
     end;
end;

end.

