program cpu580;

uses
  Forms,
  UMain in 'UMain.pas' {FEditor},
  tc in 'tc.pas',
  routings in 'routings.pas',
  StrUtils in 'StrUtils.pas',
  UEmbedForm in 'UEmbedForm.pas' {EmbedForm},
  URegs in 'URegs.pas' {FRegs},
  UApp in 'UApp.pas' {FApp},
  UAbout in 'UAbout.pas' {FAbout};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFApp, FApp);
  Application.CreateForm(TFAbout, FAbout);
  Application.Run;
end.
