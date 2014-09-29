Unit tc;

interface

Uses SysUtils;

const
  MAX_MEM = 65535;
  STACK_TOP = 2100;
  MAX_STACK = 100;
  DEFAULT_BASE : char = 'D';
  PROC_COUNT = 256;

resourcestring
  stack_top_encountered = 'Достигнута вершина стека!';
  stack_overflow        = 'Стек переполнен!';
  not_a_number          = 'Строка не представляет из себя число!';
  invalid_base          = 'Неверный спецификатор системы исчисления';
  invalid_character     = 'Число содержит цифры не соответствующие ' +
                          'его системе исчисления';

type
  EStackTopEncountered = class(Exception)
     constructor Create;
  end;

  EStackOverflow = class(Exception)
     constructor Create;
  end;

  ENotANumber = class(Exception)
     constructor Create;
  end;

  EInvalidBase = class(Exception)
     constructor Create;
  end;

  EInvalidCharacter = class(Exception)
     constructor Create;
  end;

  EInvalidCommand = class(Exception)
     line : integer;
     constructor Create(m : string; l : integer);
  end;

  TRegs = class;
  TMemory = class;
  TStack = class;
  TCPU = class;

  TProcPointer = function (command : string) : boolean;

  ProcRecord = record
      Mask : string;
      Proc : TProcPointer;
  end;

  TCPU = class
      PC   : word;
      Regs : TRegs;
      Memory : TMemory;
      Stack : TStack;

      ProcTable : array[1..PROC_COUNT] of ProcRecord;
      constructor Create;
      destructor Destroy;
  end;

  Flag = 0..1;
  TRegs = class
     public
       A, B, C, D, E, H, L : byte;
       CY, Z, S, P, AC : flag;

       constructor Create;
  end;

  TMemory = class
     public
       mem : array[0..MAX_MEM] of byte;

       constructor Create;
  end;

  TStack = class
    private
       _StackTop : word;
       _SP : word;
       CPU : TCPU;
    public
       property SP : word read _SP;
       property StackTop : word read _StackTop;
       procedure pop(var value : byte);
       procedure push(value : byte);

       constructor Create(processor : TCPU);
  end;

implementation

Uses routings;

{ TRegs }

constructor TRegs.Create;
begin
   A  := 0;
   B  := 0;
   C  := 0;
   D  := 0;
   E  := 0;
   H  := 0;
   L  := 0;
   CY := 0;
   Z  := 0;
   S  := 0;
   P  := 0;
   AC := 0;
end;


{ TMemory }

constructor TMemory.Create;
var
  i : integer;
begin
  for i := Low(mem) to High(mem) do mem[i] := 0;
end;

{ TStack }

constructor TStack.Create;
begin
    _StackTop := STACK_TOP;
    _SP := _StackTop;
    CPU := processor;
end;

procedure TStack.pop(var value: byte);
begin
   if (SP = StackTop) then
     raise EStackTopEncountered.Create;
   value := CPU.Memory.mem[SP];
   inc(_SP);
end;

procedure TStack.push(value: byte);
begin
   if _SP = StackTop - MAX_STACK then
     raise EStackOverflow.Create;
   dec(_SP);
   CPU.Memory.mem[SP] := value;
end;

{ EStackTopEncountered }

constructor EStackTopEncountered.Create;
begin
   Message := stack_top_encountered;
end;

{ EStackOverflow }

constructor EStackOverflow.Create;
begin
   Message := stack_overflow;
end;

{ ENotANumber }

constructor ENotANumber.Create;
begin
   Message := not_a_number;
end;

{ EInvalidBase }

constructor EInvalidBase.Create;
begin
   Message := invalid_base;
end;

{ EInvalidCharacter }

constructor EInvalidCharacter.Create;
begin
   Message := invalid_character;
end;

{ EInvalidCommand }

constructor EInvalidCommand.Create;
begin
   line := l;
   Message := m + ', линия ' + IntToStr(line);
end;

{ TCPU }

constructor TCPU.Create;
begin
    inherited;
    PC := 0;
    Regs := TRegs.Create;
    Memory := TMemory.Create;
    Stack := TStack.Create(self);
end;

destructor TCPU.Destroy;
begin
   Regs.Free;
   Memory.Free;
   Stack.Free;
   inherited;
end;

end.