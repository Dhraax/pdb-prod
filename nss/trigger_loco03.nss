void main()
{
  object oLoco = GetNearestObjectByTag("loco03");

  if(GetIsPC(GetEnteringObject()) == FALSE) return;

  int iNum = d6(1);
  if(iNum == 1)
  {
      DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Ahi esta.. me mira.. me mira todo el rato.. me mira... ahi esta...")));
  }
if(iNum == 2)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("No quiero espejos, no quiero verte... no... no...")));
    }
if(iNum == 3)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡Hasta de debajo de los dientes y en el sarpullido de la almoada! ¡Me mira! ¿Es que no la ves?")));
    }
if(iNum == 4)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡Para! No sigas mirándome, por favor te lo ruego. ")));
    }
if(iNum == 5)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡Estás muerta! ¡Descansa en paz y déjame! ¡¡DEJA DE MIRARME!!")));
    }
if(iNum == 6)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("Me sigues mirando... no... no...")));
    }
}
