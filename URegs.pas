unit URegs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEmbedForm, StdCtrls, ExtCtrls;

type
  TFRegs = class(TEmbedForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LA: TLabel;
    LB: TLabel;
    LC: TLabel;
    LD: TLabel;
    LE: TLabel;
    LL: TLabel;
    LH: TLabel;
    LCY: TLabel;
    LZ: TLabel;
    LS: TLabel;
    LP: TLabel;
    LAC: TLabel;
    LSP: TLabel;
    LPC: TLabel;
    Bevel2: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
