unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, ShellCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    ShellTreeView1: TShellTreeView;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
form2.Close;
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
var
str:string;
begin
if form2.Tag=0 then begin
str:='';
if not InputQuery('Описание папки','Введите описание:',Str) then str:='';
 Form1.AddExl(ShellTreeview1.Path,str,true,Form1.Listview3);
end else begin
if extractfileext(ShellTreeview1.Path)='' then str:=ShellTreeview1.Path+'\' else str:=ExtractFilePath(ShellTreeview1.Path);
 Form1.CheckListBox1.Items.Add(str);
 Form1.CheckListBox1.Checked[Form1.CheckListBox1.Count-1]:=true;
end;
Form2.Close;
end;

end.
