void main()
{
  object oLoco = GetNearestObjectByTag("loco01");

  if(GetIsPC(GetEnteringObject()) == FALSE) return;

  int iNum = d6(1);

if(iNum == 1)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡¡No estoy loco!! ¡¡No lo estoy!!")));
    }
if(iNum == 2)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡¡Sacadme de aquí!!")));
    }
if(iNum == 3)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡Yo no soy un desviacionista! ¡Ni siquiera se lo que es!")));
    }
if(iNum == 4)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡Que alguien me saque de aquí!")));
    }
if(iNum == 5)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡Esos hombres eran ladrones! ¡Mi espada! ¡Devolvédmela!")));
    }
if(iNum == 6)
    {
DelayCommand(1.0,AssignCommand(oLoco,SpeakString("¡Tyr! ¡Bendíceme y sácame de aquí! ¡Otórgame el poder para matar a estos encapuchados!")));
    }

}
