void main()
{
object oPlayer = GetExitingObject();
object oArea = OBJECT_SELF;

//Zona de Arena
SetLocalInt(GetExitingObject(),"arena", FALSE);
//SendMessageToPC(GetExitingObject(),"Ahora no estas en el modo Arena. Las reglas normales de la Muerte se aplican de nuevo.");

//sistema estatico de generacion de criaturas, los pnjs se destruyen al no haber jugadores en el area
int iPCsEnArea = 0;
object oPCArea = GetFirstObjectInArea(oArea);
while(GetIsObjectValid(oPCArea))
    {
    if(GetIsPC(oPCArea)) iPCsEnArea = 1;
    oPCArea = GetNextObjectInArea(oArea);
    }
if(iPCsEnArea == 0)
    {
    oPCArea = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oPCArea))
        {
        if(GetLocalInt(oPCArea, "SEGC_CriaturaSistema") == 1) DestroyObject(oPCArea);
        oPCArea = GetNextObjectInArea(oArea);
        }
    SetLocalInt(oArea,"SEGC_HECHO",0);
    }
}
