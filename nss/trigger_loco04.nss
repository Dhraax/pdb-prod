void main()
{
  object oLoco = GetNearestObjectByTag("loco04");

  if(GetIsPC(GetEnteringObject()) == FALSE) return;

int iNum = d6(1);

if(iNum == 1)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Brinlinding...dililin..tintintin..jinjinclin...")));
    }
if(iNum == 2)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Chinnnn... ¡¡Chiiiin!")));
    }
if(iNum == 3)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡Cataclin chinnn dililínnn!")));
    }
if(iNum == 4)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Dililín tintintín ¡¡Chiiiiin!!")));
    }
if(iNum == 5)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Ringuilintirilinimínnn...")));
    }
if(iNum == 6)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡Tiiiiiiin jinjinclinnn!")));
    }

}
