unit mess;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,  LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls;

type

  { TForm10 }

  TForm10 = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form10: TForm10;
  sdd:integer;

implementation

uses
  platproc;

{$R *.lfm}

{ TForm10 }

procedure TForm10.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 //enter
  If (key=13) and (form10.BitBtn1.Visible=false) then
   begin
     key:=0;
     Form10.Close;
     exit;
   end;

  //esc
 If (key=27) then
    begin
     key:=0;
     spb:=7;
     Form10.Close;
    end;

 // enter - Запись операции в базу
   if (Key=13) and form10.BitBtn1.Visible then
       begin
         key:=0;
         spb:=6;
         Form10.Close;
       end;
end;


procedure TForm10.FormShow(Sender: TObject);
begin
  spb:=0;
end;

end.

