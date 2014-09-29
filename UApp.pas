unit UApp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, Menus, ImgList, ComCtrls, ToolWin, MenuBar, ExtCtrls, StdCtrls,
  StdActns, Buttons,
  UMain, tc;

const
  MainCaption = 'CPU 580';

type
  TProject = class;

  TFApp = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    ActionList1: TActionList;
    ANew: TAction;
    AOpen: TAction;
    ASave: TAction;
    AClose: TAction;
    ASaveAs: TAction;
    AExit: TAction;
    ImageList1: TImageList;
    AAbout: TAction;
    AHelp: TAction;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    ControlBar1: TControlBar;
    MenuBar1: TMenuBar;
    StandardToolbar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Panel1: TPanel;
    ProjectsToolBar: TToolBar;
    Status: TStatusBar;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    Gh1: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    Panel2: TPanel;
    ProjectsBox: TComboBox;
    ACloseAll: TAction;
    N21: TMenuItem;
    CloseButton: TSpeedButton;
    OpenD: TOpenDialog;
    SaveD: TSaveDialog;
    ASyntaxCheck: TAction;
    ABreak: TAction;
    N22: TMenuItem;
    AHelpToolbar: TAction;
    N23: TMenuItem;
    N24: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    PopupMenu1: TPopupMenu;
    N28: TMenuItem;
    N30: TMenuItem;
    AProjects: TAction;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    AAddBreakPoint: TAction;
    ATraceInto: TAction;
    ATraceOver: TAction;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    ARunToCursor: TAction;
    N40: TMenuItem;
    AFont: TAction;
    N41: TMenuItem;
    FontD: TFontDialog;
    HelpToolBar: TToolBar;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    DebugToolbar: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ADebug: TAction;
    AStandard: TAction;
    N25: TMenuItem;
    N29: TMenuItem;

    procedure AExitExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AAboutExecute(Sender: TObject);
    procedure ANewExecute(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ProjectsBoxChange(Sender: TObject);
    procedure ACloseExecute(Sender: TObject);
    procedure ACloseAllExecute(Sender: TObject);
    procedure ProjectsBoxKeyPress(Sender: TObject; var Key: Char);
    procedure AOpenExecute(Sender: TObject);
    procedure ASaveExecute(Sender: TObject);
    procedure ASaveAsExecute(Sender: TObject);
    procedure AHelpToolbarExecute(Sender: TObject);
    procedure AProjectsExecute(Sender: TObject);
    procedure AFontExecute(Sender: TObject);
    procedure AStandardExecute(Sender: TObject);
    procedure ADebugExecute(Sender: TObject);
  private
    FActiveProject : integer;
//  procedure Close;
  public
    Projects      : array of TProject;

    procedure PShowHint(Sender : TObject);
    procedure SetActiveProject(index : integer);
    procedure New;
    procedure CloseProject;
    procedure Load(filename : string);
    procedure Save;
    procedure SaveAs;
    function  GetCurProject : TProject;

    property ActiveProject : integer read FActiveProject write SetActiveProject;
    property CurProject : TProject read GetCurProject;

    constructor Create(AOwner : TComponent);
    destructor Destroy;
  end;

  TProject = class
     public
       FileName : string;
       Editor : TFEditor;

       function GetName : string;
       property Name : string read GetName;

       constructor Create;
  end;


var
  FApp: TFApp;

implementation

uses UAbout;

{$R *.DFM}

procedure TFApp.AExitExecute(Sender: TObject);
begin
   close;
end;

procedure TFApp.FormResize(Sender: TObject);
begin
  MenuBar1.Width := ControlBar1.Width - CloseButton.Width - 70;
  MenuBar1.Width := ControlBar1.Width - CloseButton.Width - 26;
end;

procedure TFApp.AAboutExecute(Sender: TObject);
begin
   FAbout.ShowModal;
end;

procedure TFApp.ANewExecute(Sender: TObject);
begin
  New;
end;

procedure TFApp.CloseButtonClick(Sender: TObject);
begin
   ACloseExecute(self);
end;

procedure TFApp.FormCreate(Sender: TObject);
begin
   Caption := MainCaption;
   Application.OnHint := PShowHint;
end;

{ TProject }

constructor TProject.Create;
begin
   FileName := 'Untitled' + IntToStr(length(fapp.Projects)) + '.asm';
   Editor := TFEditor.CreateEmbedded(fApp, fApp);
end;

function TProject.GetName: string;
begin
   result := ExtractFileName(FileName);
end;

constructor TFApp.Create;
begin
    inherited Create(AOwner);
    ActiveProject := -1;
end;

destructor TFApp.Destroy;
begin
   Projects := nil;
   inherited;
end;

procedure TFApp.SetActiveProject(index: integer);
begin
   if (index < 0) or
      (index > high(Projects)) or
      (index = FActiveProject)   then exit;
   if FActiveProject > -1 then
     Projects[FActiveProject].Editor.Hide;
   FActiveProject := index;
   Projects[FActiveProject].Editor.Show;
end;

procedure TFApp.CloseProject;
var
  i : integer;
  form : TFEditor;
begin
   if length(Projects) < 1 then exit;
   form := Projects[FActiveProject].Editor;
   Projects[FActiveProject].Free;
   if (FActiveProject = 0) and (Length(Projects) = 1) then
   begin
      SetLength(Projects, 0);
      form.hide;
      FActiveProject := -1;
      ProjectsBox.Items.Clear;
      ProjectsBox.text :=  'Нет проектов';
      AClose.Enabled := false;
      ACloseAll.Enabled := false;
      CloseButton.Enabled := false;
      ASave.Enabled := false;
      ASaveAs.Enabled := false;
      AFont.Enabled := false;
      exit;
   end;

   ProjectsBox.Items.Delete(ActiveProject);
   for i := FActiveProject to high(Projects) - 1 do
     Projects[i] := Projects[i + 1];
   SetLength(Projects, length(Projects) - 1);

   if FActiveProject > high(Projects) then Dec(FActiveProject);
   form.hide;
   Projects[ActiveProject].Editor.show;
   ProjectsBox.ItemIndex := ActiveProject;
end;

procedure TFApp.New;
begin
    SetLength(Projects, length(Projects) + 1);
    Projects[high(Projects)] := TProject.Create;
    Projects[high(Projects)].Editor := TFEditor.CreateEmbedded(self, self);
    Projects[high(Projects)].Editor.show;
    Projects[high(Projects)].Editor.Activate;
    ActiveProject := high(Projects);
    ProjectsBox.Items.Add(Projects[ActiveProject].Name);
    ProjectsBox.ItemIndex := ActiveProject;
    AClose.Enabled := true;
    ACloseAll.Enabled := true;
    ASave.Enabled := true;
    ASaveAs.Enabled := true;
    CloseButton.Enabled := true;
    AFont.Enabled := true;
end;

procedure TFApp.Save;
begin
   with CurProject do
     if fileexists(FileName) then   Editor.Save(FileName)
     else SaveAs;
end;

procedure TFApp.Load(filename: string);
begin
   New;
   CurProject.Editor.Load(filename);
   CurProject.FileName := filename;
   ProjectsBox.Items[ActiveProject] := CurProject.Name;
   ProjectsBox.ItemIndex := ActiveProject;
   CurProject.Editor.Activate;
end;

procedure TFApp.ProjectsBoxChange(Sender: TObject);
begin
   ActiveProject := ProjectsBox.ItemIndex;
end;

procedure TFApp.ACloseExecute(Sender: TObject);
begin
   CloseProject;
end;

procedure TFApp.ACloseAllExecute(Sender: TObject);
begin
    while(length(Projects) > 0) do CloseProject;
end;

procedure TFApp.ProjectsBoxKeyPress(Sender: TObject; var Key: Char);
begin
  key := #27;
end;

procedure TFApp.AOpenExecute(Sender: TObject);
begin
   if OpenD.Execute then
     Load(OpenD.FileName);
end;

function TFApp.GetCurProject: TProject;
begin
   if ActiveProject > -1 then
     result := Projects[ActiveProject]
   else
     result := nil;
end;


procedure TFApp.ASaveExecute(Sender: TObject);
begin
   Save;
end;

procedure TFApp.ASaveAsExecute(Sender: TObject);
begin
   SaveAs;
end;

procedure TFApp.SaveAs;
begin
   if SaveD.Execute then
     CurProject.Editor.Save(SaveD.filename);
   CurProject.FileName := SaveD.filename;
   ProjectsBox.Items[ActiveProject] := CurProject.Name;
   ProjectsBox.ItemIndex := ActiveProject;
end;

procedure TFApp.PShowHint;
begin
   Status.Panels[0].Text := Application.Hint;
end;


procedure TFApp.AHelpToolbarExecute(Sender: TObject);
begin
   AHelpToolbar.Checked := not AHelpToolbar.Checked;
   HelpToolBar.Visible := AHelpToolbar.Checked;
end;

procedure TFApp.AProjectsExecute(Sender: TObject);
begin
   AProjects.Checked := not   AProjects.Checked;
   ProjectsToolBar.Visible := AProjects.Checked;
end;

procedure TFApp.AFontExecute(Sender: TObject);
begin
   FontD.Font := Projects[ActiveProject].Editor.RText.Font;
   if FontD.Execute then
   begin
       CurProject.Editor.RText.Font := FontD.Font;
   end;
end;

procedure TFApp.AStandardExecute(Sender: TObject);
begin
   AStandard.Checked := not AStandard.Checked;
   StandardToolBar.Visible := AStandard.Checked;
end;

procedure TFApp.ADebugExecute(Sender: TObject);
begin
   ADebug.Checked := not ADebug.Checked;
   DebugToolBar.Visible := ADebug.Checked;
end;

end.
