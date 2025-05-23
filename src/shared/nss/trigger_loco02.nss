void main()
{
  object oLoco = GetNearestObjectByTag("loco02");

  if(GetIsPC(GetEnteringObject()) == FALSE) return;

int iNum = d6(1);

if(iNum == 1)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Te voy a matar, jijiji...")));
    }
if(iNum == 2)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¿Me dejas verte por dentro? No te dolerá, bueno..., un poco.")));
    }
if(iNum == 3)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Acércate y dame tu mano... ¡verás qué divertido!")));
    }
if(iNum == 4)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Soy una niñita, no te haré daño.")));
    }
if(iNum == 5)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Quiero destripar a alguien... Pareces cumplir los requisitos, jiji.")));
    }
if(iNum == 6)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Cuando salga de aquí voy a cambiar el color de las paredes... jijiji.")));
    }

}
