unit UEmbedForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TEmbedForm = class(TForm)
  public
     constructor CreateEmbedded(AOwner : TComponent; Frame : TWinControl);
  end;

implementation

{$R *.DFM}

{ TEmbedForm }

constructor TEmbedForm.CreateEmbedded(AOwner: TComponent; Frame: TWinControl);
begin
   inherited Create(AOwner);
   Parent := Frame;
   Visible := false;
   Left := 0;
   Top := 0;
end;

end.
