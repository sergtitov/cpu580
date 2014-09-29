unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls,
  URegs, tc;

type
  TFEditor = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    Splitter2: TSplitter;
    Panel5: TPanel;
    Splitter3: TSplitter;
    Panel6: TPanel;
    Panel3: TPanel;
    RText: TRichEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel7: TPanel;
    Panel8: TPanel;
    procedure FormCreate(Sender: TObject);
  public
     CPU : TCPU;
     FRegs : TFRegs;
     procedure Activate;
     function GetProgText : string;
     procedure Load(filename : string);
     procedure Save(filename : string);

     property ProgText : string read GetProgText;

     constructor CreateEmbedded(AOwner : TComponent; Frame : TWinControl);
     destructor Destroy;
  end;

var
  FEditor: TFEditor;

implementation

uses routings, UEmbedForm;

{$R *.DFM}

procedure TFEditor.Activate;
begin
   Update;
   RText.SetFocus;
end;

constructor TFEditor.CreateEmbedded(AOwner: TComponent; Frame: TWinControl);
begin
   inherited Create(AOwner);
   Parent := Frame;
   Visible := false;
   Left := 0;
   Top := 0;
   CPU := TCPU.Create;
end;

destructor TFEditor.Destroy;
begin
   CPU.Free;
   inherited;
end;

procedure TFEditor.FormCreate(Sender: TObject);
begin
   FRegs := TFRegs.CreateEmbedded(self, Panel6);
   FRegs.Visible := true;
end;


function TFEditor.GetProgText: string;
begin
   result := RText.Lines.Text;
end;

procedure TFEditor.Load(filename: string);
begin
   RText.Lines.LoadFromFile(filename);
end;

procedure TFEditor.Save(filename: string);
begin
   RText.Lines.SaveToFile(filename);
end;

end.
