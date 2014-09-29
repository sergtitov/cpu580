{$H+}
unit routings;

interface



//  осуществляет препроцессорную обработку текста проги
procedure PreProcess(prog : AnsiString; var res : AnsiString);

//  выполняет команду
function DoCommand(com : AnsiString) : boolean;

//  проверяет синтаксис команды
function IsValidCommand(com : AnsiString) : boolean;

//  конвертит строку с числом в строку с десятичным числом
procedure ToDecBase(num : AnsiString; var res : AnsiString);

//  соответствует ли текст маске
function MaskIdent(text, mask : AnsiString) : boolean;


implementation

Uses SysUtils, StrUtils, tc;


{ routings }

procedure DeleteDoubles(prog : AnsiString; var res : AnsiString);
{
    1. Табы заменяем на пробелы
    2. Два пробела подряд заменяем на один
    3. Два конца строки подряд заменяем на один
}
var
  i : integer;
begin
  res := '';

  i := 0;
  repeat
     inc(i);

{1}  if prog[i] = #9 then prog[i] := #32;

{2}  if i > 1 then
        if (prog[i] = #32) and (prog[i - 1] = #32) then continue;

{3}  if     (prog[i] = #13) and (prog[i + 1] = #10)
        and (prog[i - 2] = #13) and (prog[i - 1] = #10) then
     begin
        inc(i);
        continue;
     end;

     res := res + prog[i];
  until i = Length(prog);
end;

procedure DeleteComments(prog : AnsiString; var res : AnsiString);
var
  i : integer;
  comment : boolean;
begin
  res := '';

  i := 0;
  repeat
     inc(i);

     if prog[i] = '{' then
     begin
        comment := true;
        continue;
     end;

     if prog[i] = '}' then
     begin
        comment := false;
        continue;
     end;

     if comment then continue;

     res := res + prog[i];
  until i = Length(prog);
end;


function Bin2Dec(s : string) : integer;
var
   i : integer;
begin
   //  тестируем на верные цифры
   i := 1;
   while (i <= length(s)) do
   begin
      if not (s[i] in ['0', '1']) then
         raise EInvalidCharacter.Create;
      inc(i);
   end;
   result := Numb2Dec(s, 2);
end;


function Hex2Dec(s : string) : integer;
var
   i : integer;
begin
   //  тестируем на верные цифры
   i := 1;
   while (i <= length(s)) do
   begin
      if not(s[i] in ['0'..'9', 'A', 'B', 'C', 'D', 'E', 'F']) then
         raise EInvalidCharacter.Create;
      inc(i);
   end;
   result := Numb2Dec(s, 16);
end;


function Oct2Dec(s : string) : integer;
var
   i : integer;
begin
   //  тестируем на верные цифры
   i := 1;
   while (i <= length(s)) do
   begin
      if not(s[i] in ['0'..'7']) then
         raise EInvalidCharacter.Create;
      inc(i);
   end;
   result := Numb2Dec(s, 8);
end;

function Dec2Dec(s : string) : integer;
var
   i : integer;
begin
   //  тестируем на верные цифры
   i := 1;
   while (i <= length(s)) do
   begin
      if not(s[i] in ['0'..'9']) then
         raise EInvalidCharacter.Create;
      inc(i);
   end;
   Val(s, result, i);
end;


procedure ToDecBase(num : AnsiString; var res : AnsiString);
{
  Поддерживаются двоичные               Bx123
                 десятичные             Dx123 или 123 - по умолчанию
                 шестнадцатеричные      Hx123
                 восьмеричные           Ox123
}

//   надо бы конечно сделать проверку :-(        сделал!

var
   number : integer;
   code : integer;
begin
    res := '';
    number := 0;
    if ((num[2] = 'x') or (num[2] = 'X')) then
       case num[1] of
          'B','b' : number :=  Bin2Dec(Copy(num, 3, length(num) - 2));
          'D','d' : number :=  Dec2Dec(Copy(num, 3, length(num) - 2));
          'H','h' : number :=  Hex2Dec(Copy(num, 3, length(num) - 2));
          'O','o' : number :=  Oct2Dec(Copy(num, 3, length(num) - 2));
       else
          raise EInvalidBase.Create
       end
    else
    begin
        ToDecBase(DEFAULT_BASE + 'x' + num, res);
    end;
    res := IntToStr(number);
end;


procedure NumbersToDecBase(prog : AnsiString; var res : AnsiString);
var
  in_number : boolean;
  i, line : integer;
  number, r : string;
begin
  line := 1;
  in_number := false;
  i := 1;
  res := '';
  number := '';
  while (i <= Length(prog)) do
  begin
     if (prog[i] = #10) then inc(line);

     if i > 1 then
        if (prog[i - 1] in [' ', ',']) then  in_number := true;

     if in_number then
       number := number + prog[i]
     else
       res := res + prog[i];

     if (prog[i] in [#13, ' ']) then
     begin
       in_number := false;

       try
         ToDecBase(number, r);
       except
         on e : EInvalidBase do
              raise EInvalidCommand.Create(e.Message, line);
         on e : EInvalidCharacter do
              raise EInvalidCommand.Create(e.Message, line);
       end;

       res := res + r;
       number := '';
     end;
  end;
end;


procedure PreProcess(prog : AnsiString; var res : AnsiString);
var
  res1 : AnsiString;
  res2 : AnsiString;
begin
   DeleteComments(prog, res1);
   DeleteDoubles(res1, res2);
   NumbersToDecBase(res2, res);
   res := AnsiUpperCase(res);
end;



function DoCommand(com : AnsiString) : boolean;
begin
  result := false;
  if not IsValidCommand(com) then exit;

  result := true;
end;


function MaskIdent(text, mask : AnsiString) : boolean;
{
    В маске допустимы следующие символы:
      R - РОН
      M - в память с адресом HL
      B - байт
      W - слово
   (считается, что все числа переведены в десятичную систему)
}
var
  m, t : integer;
  number : string;
  num, code : integer;
begin
   result := false;
   m := 2;
   t := 2;
   if mask[1] <> text[1] then exit;
   while (m <= Length(mask)) and (mask[m] <> #13) do
   begin
      if (mask[m] in ['R', 'M', 'B', 'W']) and (mask[m - 1] in [' ', ',']) then
      begin
         {#13, ' ', ','}
         case mask[m] of
            'R' :  if not (text[t] in ['A', 'B', 'C', 'D', 'E', 'H', 'L']) then exit;
            'M' :  if (text[t] <> 'M') then exit;
            'B', 'W' : begin
                          number := '';
                          num := 0;
                          while not(text[t] in [#13, ' ', ',']) do
                          begin
                             number := number + text[t];
                             inc(t);
                          end;
                          val(number, num, code);
                          if (code <> 0) or (num < 0) then exit;
                          if (mask[m] = 'B') and (num > 255) then exit;
                          if (mask[m] = 'W') and (num > 65535) then exit;
                       end;
         end;
      end
      else
         if mask[m] <> text[t] then
         begin
            exit;
         end
         else
           inc(t);
      inc(m);
   end;
   result := true;
end;

function IsValidCommand(com : AnsiString) : boolean;
begin
end;

end.
