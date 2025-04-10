//AL ENTRAR EN UN DESENCADENANTE, UN UBICADO TE DIRA LA HORA Y LA FECHA
void main()
{
object oPC = GetEnteringObject();
object oNarbonel = GetNearestObjectByTag("Narbondel");
string sHora = IntToString(GetTimeHour());
string sDia = IntToString(GetCalendarDay());
string sAnyo = IntToString(GetCalendarYear() + 50);  // +50 por tramas, reconstruccion ust natha

if(GetLocalInt(oPC, "NARBONDELUST") == 1) return;

SetLocalInt(oPC, "NARBONDELUST", 1);
DelayCommand(20.0, DeleteLocalInt(oPC, "NARBONDELUST"));

if(GetCalendarMonth() == 1)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Mazho del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Mazho del "+sAnyo+"."));}

else if(GetCalendarMonth() == 2)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Alturiak del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Alturiak del "+sAnyo+"."));}

else if(GetCalendarMonth() == 3)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Khes del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Khes del "+sAnyo+"."));}

else if(GetCalendarMonth() == 4)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Tarshak del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Tarshak del "+sAnyo+"."));}

else if(GetCalendarMonth() == 5)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Mirtul del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Mirtul del "+sAnyo+"."));}

else if(GetCalendarMonth() == 6)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Kyzhorn del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Kyzhorn del "+sAnyo+"."));}

else if(GetCalendarMonth() == 7)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Flamarul del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Flamarul del "+sAnyo+"."));}

else if(GetCalendarMonth() == 8)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Elcasias del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Elcasias del "+sAnyo+"."));}

else if(GetCalendarMonth() == 9)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Eleint del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Eleint del "+sAnyo+"."));}

else if(GetCalendarMonth() == 10)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Marpenot del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Marpenot del "+sAnyo+"."));}

else if(GetCalendarMonth() == 11)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Uktar del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Uktar del "+sAnyo+"."));}

else if(GetCalendarMonth() == 12)
   {if(GetTimeHour()==1) AssignCommand(oNarbonel, SpeakString("Es la "+sHora+" de la madrugada del "+sDia+" de Noctal del "+sAnyo+"."));
    else AssignCommand(oNarbonel, SpeakString("Son las "+sHora+" horas del "+sDia+" de Noctal del "+sAnyo+"."));}
}
