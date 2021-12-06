unit ffind;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,  LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, DateTimePicker, ZConnection, ZDataset, platproc;

type

  { TForm11 }

  TForm11 = class(TForm)
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    ZConnection1: TZConnection;
    ZQuery1: TZReadOnlyQuery;
    DateTimePicker1: TDateTimePicker;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Findman();//процедура поиска
    procedure Panel1Click(Sender: TObject);
    //procedure UpdateGrid();
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form11: TForm11;

implementation

{$R *.lfm}

{ TForm11 }


//поиск
procedure TForm11.Findman();
var
  n,voin_lgot:integer;
  tc,chek_num,cdate,ctime,idshedule,passport,familia,imya,otchestvo,fio:string;
  mydate1,mydate2,birth:TDatetime;
  tmp:array of array of string;
begin
  mydate1:=strtodate('02-04-1985');
  mydate2:=strtodate('02-04-1985');

  familia:='';
  imya:='';
  otchestvo:='';
  fio:='';
  tc:='1';
    chek_num:='-1';
    cdate:='-1';
    ctime:='-1';
    idshedule:='-1';

  //  if  CheckBox7.Checked  then
  //        begin
  //          If  DateTimePicker2.Date> DateTimePicker3.Date then
  //                begin
  //                  showmessagealt('Выбран неверный период для отчета !');
  //                  exit;
  //                end;
  //          mydate1:=DateTimePicker1.Date;
  //          mydate2:=DateTimePicker3.Date;
  //
  //        end;
  //
  // voin_lgot:=0;
  //// // Ищем билеты по номеру и типу билета
  //if not( CheckBox1.Checked) and not( CheckBox2.Checked) and not( CheckBox3.Checked) and not( CheckBox7.Checked) then
  // begin
  //   showmessage('Выберите хотя бы один из реквизитов билета !');
  //  exit;
  // end;
  //If (trim( Edit2.text)<>'') AND not( CheckBox4.Checked) AND not( CheckBox5.Checked) then
  //      begin
  //        showmessagealt('Не выбран тип билета !');
  //        exit;
  //      end;
  //
  //If  CheckBox4.Checked then voin_lgot:=1;//если воинский
  //
  //If  CheckBox5.Checked then voin_lgot:=voin_lgot+2; //если льготный
  //
  // if  RadioButton1.Checked then tc:='1' else tc:='2';
  // if  CheckBox1.Checked then
  //     begin
  //       if trim( Edit1.text)='' then chek_num:='-1' else chek_num:=trim( Edit1.Text);
  //     end
  // else
  //     begin
  //      chek_num:='-1';
  //     end;
  //
  //   if  CheckBox2.Checked then
  //     begin
  //      cdate:=datetostr( DateTimePicker1.Date);
  //      ctime:=FormatDateTime('hh:nn', DateTimePicker1.DateTime);
  //     end
  //   else
  //     begin
  //      cdate:='-1';
  //      ctime:='-1';
  //     end;


   //if  CheckBox3.Checked then
   //    begin
   //      if  SpinEdit1.Value=0 then idshedule:='-1' else idshedule:=inttostr( SpinEdit1.Value);
   //    end
   //else
   //    begin
   //     idshedule:='-1';
   //    end;


   passport:='';
   passport:=Upperall(trim(Edit4.text));
    familia:=upperall(trim(Edit1.text));
       imya:=Upperall(trim(Edit2.text));
  otchestvo:=Upperall(trim(Edit3.text));
 //IF familia='' then
 //     begin
 //       showmessagealt('Необходимо заполнить поле Фамилия !');
 //       exit;
 //     end;
   birth:= DateTimePicker1.Date;


    Panel1.Visible:=true;
   application.ProcessMessages;
   // Подключаемся к серверу
    If not(Connect2(Form11.Zconnection1, 1)) then
    begin
     showmessagealt('Соединение с сервером базы данных отсутствует !'+#13+'Проверьте сетевое соединение и опции файла настроек системы...'+#13+'-k19-');
     Form11.close;
     exit;
    end;

     ZQuery1.sql.Clear;
     ZQuery1.SQL.add('SELECT * FROM find_ticket_num('+quotedstr('find_check')+','+quotedstr(chek_num)+','+tc+','+idshedule+',');
     ZQuery1.SQL.add(quotedstr(cdate)+','+quotedstr(ctime)+','+inttostr(voin_lgot)+','+quotedstr(passport)+','+quotedstr(datetostr(mydate1))+','+quotedstr(datetostr(mydate2))+',');
     ZQuery1.SQL.add(quotedstr(familia)+','+quotedstr(imya)+','+quotedstr(otchestvo)+','+quotedstr(datetostr(birth))+');');
     ZQuery1.SQL.add('FETCH ALL in find_check;');
    //showmessage( ZQuery1.SQL.Text);//$
    try
        ZQuery1.open;
    except
       showmessagealt('Выполнение команды SQL - ОШИБКА !'+#13+'Команда: '+ ZQuery1.SQL.Text);
        ZQuery1.Close;
        Zconnection1.disconnect;
    end;

     Panel1.Visible:=false;
   if   ZQuery1.RecordCount=0 then
         begin
            StringGrid1.RowCount:=1;
            ZQuery1.Close;
            Zconnection1.disconnect;
           exit;
         end;

  // Заполняем GRID и массив
   StringGrid1.RowCount:=1;
  setlength(tmp,0,0);
  for n:=0 to  ZQuery1.RecordCount-1 do
     begin
        StringGrid1.RowCount:= StringGrid1.RowCount+1;
        StringGrid1.Cells[0, StringGrid1.RowCount-1]:= ZQuery1.FieldByName('fio').asString;
        StringGrid1.Cells[1, StringGrid1.RowCount-1]:= ZQuery1.FieldByName('doc').asString;
        StringGrid1.Cells[2, StringGrid1.RowCount-1]:= ZQuery1.FieldByName('birthday').asString;
        StringGrid1.Cells[3, StringGrid1.RowCount-1]:='['+ ZQuery1.FieldByName('id_shedule').asString+'] '+ ZQuery1.FieldByName('name_shedule').asString;
        //StringGrid1.Cells[2, StringGrid1.RowCount-1]:='['+ ZQuery1.FieldByName('id_point_oper').asString+'] '+ ZQuery1.FieldByName('name_oper').asString;
        //StringGrid1.Cells[3, StringGrid1.RowCount-1]:='['+ ZQuery1.FieldByName('id_user').asString+'] '+ ZQuery1.FieldByName('name_user').asString;
        StringGrid1.Cells[4, StringGrid1.RowCount-1]:= ZQuery1.FieldByName('trip_date').asString;
        StringGrid1.Cells[5, StringGrid1.RowCount-1]:= ZQuery1.FieldByName('trip_time').asString;
        StringGrid1.Cells[6, StringGrid1.RowCount-1]:= ZQuery1.FieldByName('mesto').asString;
        //StringGrid1.Cells[8, StringGrid1.RowCount-1]:= ZQuery1.FieldByName('type_table').asString;
        //StringGrid1.Cells[9, StringGrid1.RowCount-1]:= ZQuery1.FieldByName('type_oper').asString;

       setlength(tmp,length(tmp)+1,46);
       tmp[length(tmp)-1,0]:= ZQuery1.FieldByName('type_table').asString;
       tmp[length(tmp)-1,1]:=formatdatetime('dd.mm.yy hh:nn', ZQuery1.FieldByName('createdate').asDateTime);
       tmp[length(tmp)-1,2]:= ZQuery1.FieldByName('id_point_oper').asString;
       tmp[length(tmp)-1,3]:= ZQuery1.FieldByName('name_oper').asString;
       tmp[length(tmp)-1,4]:= ZQuery1.FieldByName('id_user').asString;
       tmp[length(tmp)-1,5]:= ZQuery1.FieldByName('name_user').asString;
       tmp[length(tmp)-1,6]:= ZQuery1.FieldByName('chek_num').asString;
       tmp[length(tmp)-1,7]:= ZQuery1.FieldByName('trip_date').asString;
       tmp[length(tmp)-1,8]:= ZQuery1.FieldByName('trip_time').asString;
       tmp[length(tmp)-1,9]:= ZQuery1.FieldByName('id_shedule').asString;
       tmp[length(tmp)-1,10]:= ZQuery1.FieldByName('name_shedule').asString;
       tmp[length(tmp)-1,11]:= ZQuery1.FieldByName('id_ot').asString;
       tmp[length(tmp)-1,12]:= ZQuery1.FieldByName('name_ot').asString;
       tmp[length(tmp)-1,13]:= ZQuery1.FieldByName('id_do').asString;
       tmp[length(tmp)-1,14]:= ZQuery1.FieldByName('name_do').asString;
       tmp[length(tmp)-1,15]:= ZQuery1.FieldByName('sum_cash').asString;
       tmp[length(tmp)-1,16]:= ZQuery1.FieldByName('sum_credit').asString;
       tmp[length(tmp)-1,17]:= ZQuery1.FieldByName('type_oper').asString;
       tmp[length(tmp)-1,18]:= ZQuery1.FieldByName('refund_percent').asString;
       tmp[length(tmp)-1,19]:= ZQuery1.FieldByName('refund_sum').asString;
       tmp[length(tmp)-1,20]:= ZQuery1.FieldByName('refund_id_point').asString;
       tmp[length(tmp)-1,21]:= ZQuery1.FieldByName('name_refund').asString;
       tmp[length(tmp)-1,22]:= ZQuery1.FieldByName('refund_id_user').asString;
       tmp[length(tmp)-1,23]:= ZQuery1.FieldByName('name_refund_user').asString;
       tmp[length(tmp)-1,24]:= ZQuery1.FieldByName('refund_createdate').asString;
       tmp[length(tmp)-1,25]:= ZQuery1.FieldByName('unused').asString;
       tmp[length(tmp)-1,26]:= ZQuery1.FieldByName('unused_id_user').asString;
       tmp[length(tmp)-1,27]:= ZQuery1.FieldByName('name_unused_user').asString;
       tmp[length(tmp)-1,28]:= ZQuery1.FieldByName('unused_createdate').asString;
       tmp[length(tmp)-1,29]:= ZQuery1.FieldByName('mesto').asString;
       tmp[length(tmp)-1,30]:= ZQuery1.FieldByName('tarif_calculated').asString;
       tmp[length(tmp)-1,31]:= ZQuery1.FieldByName('type_norm_lgot_war').asString;
       tmp[length(tmp)-1,32]:= ZQuery1.FieldByName('tarif_calculated').asString;
       tmp[length(tmp)-1,33]:= ZQuery1.FieldByName('type_full_half').asString;
       tmp[length(tmp)-1,34]:= ZQuery1.FieldByName('lgot_id').asString;
       tmp[length(tmp)-1,35]:= ZQuery1.FieldByName('name_lgot').asString;
       tmp[length(tmp)-1,36]:= ZQuery1.FieldByName('lgot_percent').asString;
       tmp[length(tmp)-1,37]:= ZQuery1.FieldByName('lgot_sum').asString;
       tmp[length(tmp)-1,38]:= ZQuery1.FieldByName('fio').asString;
       tmp[length(tmp)-1,39]:=FormatDateTime('dd.mm.yyyy', ZQuery1.FieldByName('birthday').asDateTime);
       tmp[length(tmp)-1,40]:= ZQuery1.FieldByName('birthplace').asString;
       tmp[length(tmp)-1,41]:= ZQuery1.FieldByName('tel').asString;
       tmp[length(tmp)-1,42]:= ZQuery1.FieldByName('doctype').asString;
       tmp[length(tmp)-1,43]:= ZQuery1.FieldByName('doc').asString;
       tmp[length(tmp)-1,44]:= ZQuery1.FieldByName('uslugi_text').asString;
       tmp[length(tmp)-1,45]:= ZQuery1.FieldByName('type_war_purpose').asString;

        ZQuery1.Next;
     end;

   ZQuery1.Close;
   Zconnection1.disconnect;
   StringGrid1.Row:=1;
   StringGrid1.SetFocus;

  //update_passenger();

end;

procedure TForm11.Panel1Click(Sender: TObject);
begin

end;

procedure TForm11.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
    // ESC
    if Key=27 then form11.Close;
    //F5 - ПОИСК
        // ENTER>TAB
   if (Key=13) and (form11.DateTimePicker1.focused=false) and (form11.stringgrid1.focused=false) then
       begin
        //If form2.Edit8.Visible=true then form2.Edit8.Visible:=false;
        //If isfio and (form2.Edit2.Focused or form2.Edit3.Focused or form2.Edit4.Focused) then
        //  begin
        //    If form2.Edit3.Focused and form2.Edit5.Visible then form2.Edit5.SetFocus;
        //    If form2.Edit4.Focused and form2.Edit3.Visible then form2.Edit3.SetFocus;
        //    If form2.Edit2.Focused and form2.Edit4.Visible then form2.Edit4.SetFocus;
        //  end
        //else
        //begin
          form11.SelectNext(ActiveControl,true,true);
          //end;
         Key:=0;
       end;
   if (Key=116) then
       begin
        key:=0;
         Form11.findman();
         exit;
       end;
    if (Key=112) or (Key=115) or (Key=116) or (Key=119) or (Key=27) or (Key=13) then Key:=0;
end;

end.

