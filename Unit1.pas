unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, ComCtrls, StdCtrls, ExtCtrls, Buttons,Math,ShellApi, Menus,
  TabNotBk, CheckLst,IniFiles,FileCtrl;

type
  TForm1 = class(TForm)
    XPManifest1: TXPManifest;
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    N7: TMenuItem;
    N3: TMenuItem;
    TabbedNotebook1: TTabbedNotebook;
    ListView1: TListView;
    CheckListBox1: TCheckListBox;
    Label1: TLabel;
    ListView2: TListView;
    Label2: TLabel;
    ListView3: TListView;
    N8: TMenuItem;
    N10: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image2: TImage;
    Bevel1: TBevel;
    N1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Label7: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Image1: TImage;
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
  procedure Find(Dir:string);
  procedure FindFiles;
  procedure DeleteFileSelected;
  function ExlPath(Path:string):boolean;
  function InExt(FileName:string):boolean;
  procedure GetDrives;
  procedure ShowText(f,s:real);
  procedure DeleteAll;
  procedure CheckAll(Checked:boolean);
  function FileMaskEquate(F, M: string): boolean;
  procedure EnabledButtons(Enabled:boolean);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);

    procedure AddExl(Path,Description:string; EChecked:boolean; List:TListview);
    procedure AddExt(Extension,Description:string; EChecked:boolean; List:TListview);
    procedure LoadNastr;
    procedure SaveNastr;
    procedure SpeedButton8Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    function GetQuanFolders(Path:string):integer;
    procedure FindFolders(Dir:String; var Folders:integer);
  private
    { Private declarations }
  public
    { Public declarations }
 end;

var
  Form1: TForm1;
  LastIndex:integer;
  files,size:extended;
  Exts:array of string;
  Stop:boolean;
implementation

uses Unit2;


{$R *.dfm}
//{$R Data.RES}
//--------------------------------------------------
function TForm1.ExlPath(Path:string):boolean;
var
i:integer;
begin
 for i:=0 to Listview3.Items.Count-1 do begin
  if (Listview3.Items[i].Checked=true) and (Pos(Listview3.Items[i].Caption,Path)>0) then begin
   Result:=true;
   exit;
  end;
 end;
Result:=false;
end;

procedure TForm1.DeleteFileSelected;
begin
if (Form1.ListView1.Selected<>nil) and (Form1.ListView1.Selected.Caption<>'') then begin
 DeleteFile(Form1.ListView1.Selected.Caption);
 Form1.ListView1.Selected.Delete;
end;
end;

function TForm1.InExt(FileName:string):boolean;
var
i:integer;
begin
For i:=0 to Listview2.Items.Count-1 do begin
if ListView2.Items[i].Checked=true then begin
 if FileMaskEquate(FileName,Listview2.Items[i].Caption)=true then begin
   Result:=true;
   exit;
  end;
 end;
end;
Result:=false;
end;

function TForm1.FileMaskEquate(F, M: string): boolean;
var
  Fl, Ml: byte; // length of file name and mask
  Fp, Mp: byte; // pointers
begin
  F := UpperCase(F);
  M := UpperCase(M);
  result := true;
  Fl := length(F);
  Ml := length(M);
  Fp := 1;
  Mp := 1;
  while Mp <= Ml do
  begin // wildcard
    case M[Mp] of //
      '?':
        begin // if one any char
          inc(Mp); // next char of mask
          inc(Fp); // next char of file name
        end; //
      '*':
        begin // if any chars
          if Mp = Ml then
            exit; // if last char in mask then exit
          if M[Mp + 1] = F[Fp] then
          begin // if next char in mask equate char in
            Inc(Mp); // file name then next char in mask and
          end
          else
          begin // else
            if Fp = Fl then
            begin // if last char in file name then
              result := false; // function return false
              exit; //
            end; // else, if not previous, then
            inc(Fp); // next char in file name
          end; //
        end; //
    else
      begin // other char in mask
        if M[Mp] <> F[Fp] then
        begin // if char in mask not equate char in
          result := false; // file name then function return
          exit; // false
        end; // else
        if (Mp=Ml) and (Fp<>Fl) then begin
        Result:=false;
        exit;
       end;
        inc(Fp); // next char of mask
        inc(Mp); // next char of file name
      end //
    end;
  end;
end;




procedure TForm1.GetDrives;
var
Drive:char;
DT:Cardinal;
begin
CheckListBox1.Clear;
for Drive:='A' to 'Z' do begin
DT:=GetDriveType(PAnsiChar(Drive+':\'));
  if (DT=DRIVE_FIXED) or (DT=DRIVE_REMOVABLE) then begin
   CheckListBox1.Items.Add(Drive+':\');
   CheckListBox1.Checked[CheckListBox1.Count-1]:=true;
  end;
 end;
LastIndex:=CheckListbox1.Count-1;
end;

procedure TForm1.ShowText(f,s:real);
begin
Form1.StatusBar1.Panels[1].Text:='Найдено файлов: '+floattostr(f);
Form1.StatusBar1.Panels[2].Text:='Общий размер: '+floattostr(RoundTo(s/1048576,-2))+ ' Мб';
end;


procedure TForm1.Find(Dir:String);
Var
  DirInfo:TSearchRec;
  FindRes:Integer;
  ListItem: TListItem;
  ShInfo: TSHFileInfo;
begin
  FindRes:=FindFirst(Dir+'*.*',faAnyFile,DirInfo);
  While FindRes=0 do begin
  if Stop=true then FindClose(DirInfo);
  application.ProcessMessages;
    if ((DirInfo.Attr and faDirectory)=faDirectory) and ((DirInfo.Name='.')or(DirInfo.Name='..')) then begin
      FindRes:=FindNext(DirInfo);
      Continue;
     end;

    if ((DirInfo.Attr and faDirectory)=faDirectory) then begin
     Find(Dir+DirInfo.Name+'\');
     Form1.StatusBar1.Panels[0].Text:='Поиск: '+MinimizeName(Dir,Statusbar1.Canvas,Statusbar1.Panels[0].Width-30);
     Progressbar1.Position:=Progressbar1.Position+1;
     FindRes:=FindNext(DirInfo);
     Continue;
    end;

  if (ExlPath(Dir+DirInfo.Name)=false) and (InExt(DirInfo.Name)=true) then begin
   ListItem:=Listview1.Items.Add;
   SHGetFileInfo(PChar(Dir+DirInfo.Name), 0, ShInfo, SizeOf(ShInfo),SHGFI_TYPENAME or SHGFI_SYSICONINDEX);
    with Listitem do begin
     ImageIndex:=ShInfo.iIcon;
     Caption :=dir+dirinfo.Name;
     SubItems.Add(floattostr(RoundTo(Dirinfo.size/1024,-2))+' Кб');
     SubItems.Add((ShInfo.szTypeName));
     SubItems.Add(DateTimeToStr(FileDateToDateTime(DirInfo.Time)));
     Checked:=true;
    end;
    files:=files+1;
    size:=size+Dirinfo.size;
    ShowText(files,size);
  end;
    FindRes:=FindNext(DirInfo);
  end;
  FindClose(DirInfo);
 Form1.Statusbar1.Panels[0].Text:='';
end;


procedure TForm1.FindFiles;
var
i:integer;
begin
files:=0; size:=0; stop:=false;
ShowText(0,0);
Form1.ListView1.Clear;
for i:=0 to CheckListBox1.Count-1 do begin
 if CheckListBox1.Checked[i]=true then begin
 Progressbar1.Max:=GetQuanFolders(CheckListBox1.items[i]);
 Find(CheckListBox1.items[i]);
 Progressbar1.Position:=0;
 end;
 Application.ProcessMessages;
end;
end;

procedure TForm1.EnabledButtons(Enabled:boolean);
var
i:integer;
begin
if Enabled=false then Form1.ListView1.PopupMenu:=nil else Form1.ListView1.PopupMenu:=Form1.PopupMenu1;
for i:=3 to 8 do TSpeedButton(FindComponent('SpeedButton'+inttostr(i))).Enabled:=Enabled;
 ListView2.Enabled:=Enabled;
 ListView3.Enabled:=Enabled;
 CheckListBox1.Enabled:=Enabled;
end;

procedure TForm1.DeleteAll;
begin
while Form1.ListView1.Items.Count>0 do begin
 if Form1.ListView1.Items[0].Checked=true then begin
  StatusBar1.Panels[0].Text:='Удаление: '+Form1.ListView1.Items[0].Caption;
  if DeleteFile(Form1.ListView1.Items[0].Caption)=false then StatusBar1.Panels[0].Text:='Не могу удалить '+Form1.ListView1.Items[0].Caption;
 end else StatusBar1.Panels[0].Text:='Файл '+ListView1.Items[0].Caption+' удален не будет';
 Form1.ListView1.Items[0].Delete;
 application.ProcessMessages;
end;
StatusBar1.Panels[0].Text:='';
ShowText(0,0);
end;

procedure TForm1.CheckAll(Checked:boolean);
var
i,c:integer;
begin
case TabbedNotebook1.PageIndex of
 0: c:=Checklistbox1.Count-1;
 1: c:=ListView2.Items.Count-1;
 2: c:=ListView3.Items.Count-1;
 3: c:=ListView1.Items.Count-1;
end;
for i:=0 to c do begin
 case TabbedNotebook1.PageIndex of
  0: Checklistbox1.Checked[i]:=Checked;
  1: ListView2.Items[i].Checked:=Checked;
  2: ListView3.Items[i].Checked:=Checked;
  3: ListView1.Items[i].Checked:=Checked;
 end;
end;
end;

procedure TForm1.N1Click(Sender: TObject);
var
folder,str:string;
i:integer;
flag:boolean;
begin
if Listview1.Selected<>nil then begin
folder:=ExtractFilePath(Listview1.Selected.Caption);
if not InputQuery('Описание объекта','Введите описание:',Str) then str:='';
AddExl(folder,Str,true,listview3);
repeat
flag:=false;
for i:=0 to ListView1.Items.Count-1 do begin
 if folder=ExtractFilePath(Listview1.Items[i].Caption) then begin
  Listview1.Items[i].Delete;
  flag:=true;
  break;
 end;
end;
until flag=false;
end;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
DeleteAll;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
CheckAll(true);
end;

procedure TForm1.N6Click(Sender: TObject);
begin
CheckAll(false);
end;



procedure TForm1.FormResize(Sender: TObject);
begin
with Listview1 do begin
 Column[0].Width:=(Listview1.Width*50 div 100);
 Column[1].Width:=(Listview1.Width*18 div 100);
 Column[2].Width:=(Listview1.Width*18 div 100);
 Column[3].Width:=(Listview1.Width*25 div 100);
end;
StatusBar1.Panels[0].Width:=(StatusBar1.Width*54 div 100);
StatusBar1.Panels[1].Width:=(StatusBar1.Width*25 div 100);
end;

procedure TForm1.SpeedButton4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
  Name:string;
begin
if Shift=[ssLeft] then begin
 Name:='B'+inttostr((Sender as TImage).Tag)+'2';
 (Sender as TImage).Picture.Bitmap.LoadFromResourceName(Hinstance,Name);
end;
end;

procedure TForm1.SpeedButton4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Name:='B'+inttostr((Sender as TImage).Tag)+'1';
(Sender as TImage).Picture.Bitmap.LoadFromResourceName(Hinstance,Name);
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
//--
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
CheckAll(false);
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
CheckAll(true);
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
DeleteFileSelected;
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
 DeleteAll;
end;

procedure TForm1.Image7Click(Sender: TObject);
begin
Stop:=true;
SpeedButton6.Visible:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
SysImageList: uint;
SFI: TSHFileInfo;
begin
GetDrives;
LoadNastr;
 ListView1.LargeImages:=TImageList.Create(self);
 ListView1.SmallImages:=TImageList.Create(self);
SysImageList := SHGetFileInfo('', 0, SFI,
SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX or SHGFI_LARGEICON);
if SysImageList <> 0 then begin
 ListView1.Largeimages.Handle := SysImageList;
 ListView1.Largeimages.ShareImages := TRUE;
end;
SysImageList := SHGetFileInfo('', 0, SFI, SizeOf(TSHFileInfo),
SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
if SysImageList <> 0 then begin
 ListView1.Smallimages.Handle := SysImageList;
 ListView1.Smallimages.ShareImages := TRUE;
end;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
if (ListView1.Selected<>nil) and (Listview1.Items.Count>0) then
ShellExecute(Application.MainForm.Handle, nil,nil, '',PChar(ExtractFilePath(listview1.Selected.Caption)), SW_SHOW);
end;


procedure TForm1.SpeedButton8Click(Sender: TObject);
var
filter,desc,e:string;
begin
 case Speedbutton8.Tag of
 1: begin
    if Listview2.Selected<>nil then begin
    filter:=Listview2.Selected.Caption;
    Desc:=Listview2.Selected.SubItems.Strings[1];
    if not InputQuery('Редактирование фильтра','Исправьте название фильтр:',Filter) then exit else begin
    InputQuery('Редактирование фильтра','Исправьте описание фильтра:',Desc);
    Listview2.Selected.Caption:=filter;
    Listview2.Selected.SubItems.Strings[0]:=ExtractFileExt(filter);
    Listview2.Selected.SubItems.Strings[1]:=Desc;
    end;
    end;
    end;
 2: begin
    if Listview3.Selected<>nil then begin
    e:=Listview3.Selected.Caption;
    Desc:=Listview3.Selected.SubItems.Strings[0];
    if not InputQuery('Редактирование исключения','Исправьте название исключения:',e) then exit else begin
    InputQuery('Редактирование исключения','Исправьте описание исключения:',Desc);
    Listview3.Selected.Caption:=e;
    Listview3.Selected.SubItems.Strings[0]:=desc;
    end;
    end;
 end;
end;
end;

procedure TForm1.SaveNastr;
var
i:integer;
Ini:TIniFile;
begin
DeleteFile(ExtractFilePath(ParamStr(0))+'Config.ini');
Ini:=TiniFile.Create(ExtractFilePath(ParamStr(0))+'Config.ini');
With Ini do begin
 WriteInteger('Filters','Count',Listview2.items.count);
for i:=0 to Listview2.items.count-1 do begin
 WriteString('Filters','F'+Inttostr(i),Listview2.items[i].caption);
 WriteString('Filters','D'+Inttostr(i),Listview2.items[i].SubItems.Strings[1]);
end;
 WriteInteger('Exclusion','Count',Listview3.items.count);
for i:=0 to Listview3.items.count-1 do begin
 WriteString('Exclusion','E'+inttostr(i),Listview3.items[i].caption);
 Application.ProcessMessages;
 WriteString('Exclusion','D'+Inttostr(i),Listview3.items[i].SubItems.Strings[0]);
end;
 WriteInteger('Path','Count',(CheckListBox1.count-1)-LastIndex);
for i:=LastIndex+1 to CheckListBox1.count-1 do begin
 WriteString('Path','P'+inttostr(i-LastIndex-1),CheckListBox1.Items[i]);
end;
end;
Ini.Free;
end;

procedure TForm1.LoadNastr;
var
Ini:TIniFile;
Str:string;
count,i:integer;
begin
Ini:=TiniFile.Create(ExtractFilePath(ParamStr(0))+'Config.ini');
Count:=Ini.ReadInteger('Filters','Count',0);
 for i:=1 to Count do AddExt(Ini.readString('Filters','F'+inttostr(i-1),''),Ini.readString('Filters','D'+inttostr(i-1),''),true,Listview2);
Count:=Ini.ReadInteger('Exclusion','Count',0);
 for i:=1 to Count do AddExl(Ini.readstring('Exclusion','E'+inttostr(i-1),''),Ini.readstring('Exclusion','D'+inttostr(i-1),''),true,listview3);
Count:=Ini.ReadInteger('Path','Count',0);
 for i:=1 to Count do begin
  CheckListbox1.Items.Add(Ini.readstring('Path','P'+inttostr(i-1),''));
  CheckListbox1.Checked[CheckListbox1.Count-1]:=true;
 end;
Ini.Free;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
SaveNastr;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
SpeedButton1.Visible:=false;
SpeedButton2.Visible:=true;
 EnabledButtons(false);
 FindFiles;
SpeedButton1.Visible:=true;
SpeedButton2.Visible:=false;
EnabledButtons(true);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
Stop:=true;
SpeedButton2.Visible:=true;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
CheckAll(false);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
CheckAll(true);
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
case Speedbutton5.Tag of
 0: if CheckListBox1.ItemIndex>-1 then checklistbox1.DeleteSelected;
 1: if ListView2.Selected<>nil then Listview2.Selected.Delete;
 2: if ListView3.Selected<>nil then Listview3.DeleteSelected;
 3: DeleteFileSelected;
end;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
case Speedbutton6.Tag of
 0: CheckListbox1.Clear;
 1: Listview2.Clear;
 2: Listview3.Clear;
 3: DeleteAll;
end;
end;

procedure TForm1.N8Click(Sender: TObject);
var
filename,str:string;
i:integer;
flag:boolean;
begin
if Listview1.Selected<>nil then begin
filename:=ExtractFileName(Listview1.Selected.Caption);
if not InputQuery('Описание объекта','Введите описание:',Str) then str:='';
AddExl(filename,Str,true,listview3);
repeat
flag:=false;
for i:=0 to ListView1.Items.Count-1 do begin
 if filename=ExtractFileName(Listview1.Items[i].Caption) then begin
  Listview1.Items[i].Delete;
  flag:=true;
  break;
 end;
end;
until flag=false;
end;
end;


procedure TForm1.AddExt(Extension,Description:string; EChecked:boolean; List:TListview);
var
ListItem: TListItem;
begin
ListItem:=List.Items.Add;
 with Listitem do begin
  Caption:=Extension;
  SubItems.Add(ExtractFileExt(Caption));
  SubItems.Add(Description);
  Checked:=EChecked;
 end;
end;

procedure TForm1.AddExl(Path,Description:string; EChecked:boolean; List:TListview);
var
ListItem: TListItem;
begin
ListItem:=List.Items.Add;
 with Listitem do begin
  Caption:=Path;
  SubItems.Add(Description);
  Checked:=EChecked;
 end;
end;


procedure TForm1.N10Click(Sender: TObject);
begin
Listview1.Clear;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
var
f,d:string;
ListItem: TListItem;
begin
case Speedbutton7.Tag of
 0: begin
     form2.Tag:=1;
     form2.Show;
    end;
 1: begin
     f:='';
     if not InputQuery('Добавить фильтр','Введите фильтр:',f) then exit;
     if Trim(f)<>'' then begin
     if not InputQuery('Описание фильтра','Введите описание:',d) then d:='';
     AddExt(f,d,true,ListView2);
     end;
    end;
 2: begin
     form2.Tag:=0;
     Form2.show;
    end;
end;
end;

procedure TForm1.N4Click(Sender: TObject);
var
str:string;
begin
if Listview1.Selected<>nil then begin
str:='';
if (ListView1.Selected<>nil) and (Listview1.Items.Count>0) then begin
 if not InputQuery('Описание объекта','Введите описание:',Str) then str:='';
 AddExl(Listview1.Selected.Caption,Str,true,listview3);
 Listview1.DeleteSelected;
end;
end;
end;

procedure TForm1.TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
if (NewTab=4) then EnabledButtons(false) else  EnabledButtons(true);
Speedbutton7.Tag:=NewTab;
Speedbutton8.Tag:=NewTab;
Speedbutton5.Tag:=NewTab;
Speedbutton6.Tag:=NewTab;
 if (NewTab=0) or (NewTab=3) or (NewTab=4) then SpeedButton8.Enabled:=false else SpeedButton8.Enabled:=true;
 if (NewTab=3) or (NewTab=4) then SpeedButton7.Enabled:=false else SpeedButton7.Enabled:=true;
end;

procedure TForm1.FindFolders(Dir:String; var Folders:integer);
Var
  DirInfo:TSearchRec;
  FindRes:Integer;
begin
  FindRes:=FindFirst(Dir+'*.*',faAnyFile,DirInfo);
   While FindRes=0 do begin
    if ((DirInfo.Attr and faDirectory)=faDirectory) and ((DirInfo.Name='.')or(DirInfo.Name='..')) then begin
     FindRes:=FindNext(DirInfo);
     Continue;
    end;
    if ((DirInfo.Attr and faDirectory)=faDirectory) then begin
     FindFolders(Dir+DirInfo.Name+'\',Folders);
     FindRes:=FindNext(DirInfo);
     Folders:=Folders+1;
     Continue;
    end;
    FindRes:=FindNext(DirInfo);
   end;
 FindClose(DirInfo);
end;

function TForm1.GetQuanFolders(Path:string):integer;
var
f:integer;
begin
FindFolders(Path,f);
Result:=f;
end;





end.

