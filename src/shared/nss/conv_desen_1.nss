#include "nwnx_player"
#include "mti_libreria"

void main()
{
    int iModo = StringToInt(GetScriptParam("Modo"));

    //Abrimos la lista de desencadenantes cercanos.
    if(iModo == 1)
    {
        location lTarget = GetLocalLocation(OBJECT_SELF, "DM_DESEN_LTARGET");
        int iOffset = GetLocalInt(OBJECT_SELF, "DM_DESEN_CONTEO");
        int iLoop = 0;
        object oTarget = OBJECT_SELF;

        while( (iLoop < 10) & (GetIsObjectValid(oTarget) ))
        {
            oTarget = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lTarget, iLoop+iOffset+1);
            if( GetIsObjectValid(oTarget) )
            {
                SetLocalObject(OBJECT_SELF, "DM_DESEN_UBICADO" + IntToString(iLoop), oTarget);
                NWNX_Player_SetCustomToken(OBJECT_SELF, 11010 + iLoop, GetName(oTarget));
            }
            iLoop++;
        }

        SetLocalInt(OBJECT_SELF, "DM_DESEN_CONTEO", iLoop+iOffset);
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lTarget, iLoop+iOffset+1);
        SetLocalObject(OBJECT_SELF, "DM_DESEN_MAS", oTarget);
    }

    //Reseteamos el contador.
    if(iModo == 2)
    {
        SetLocalInt(OBJECT_SELF, "DM_DESEN_CONTEO", 0);
    }

    //Elegimos el desencadenante.
    if(iModo == 3)
    {
        string sSeleccion = GetScriptParam("Seleccion");
        object oTarget = GetLocalObject(OBJECT_SELF, "DM_DESEN_UBICADO"+sSeleccion);
        SetLocalObject(OBJECT_SELF, "DM_DESEN_TARGET", oTarget);
        SetLocalLocation(OBJECT_SELF, "DM_DESEN_LORIGINAL", GetLocation(oTarget));
    }

    //Listamos los 10 anteriores.
    if(iModo == 4)
    {
        int iOffset = GetLocalInt(OBJECT_SELF, "DM_DESEN_CONTEO");
        int iNewOffset = 0;

        if( (iOffset % 10) == 0)
        {
            iNewOffset = iOffset - 20;
        }
        else
        {
            iNewOffset = iOffset - (iOffset % 10) - 10;
        }

        SetLocalInt(OBJECT_SELF, "DM_DESEN_CONTEO", iNewOffset);
    }

    //Listamos los 10 próximos.
    if(iModo == 5)
    {
        int iLoop = 0;

        while( iLoop < 10 )
        {
            DeleteLocalObject(OBJECT_SELF, "DM_DESEN_UBICADO" + IntToString(iLoop));
            iLoop++;
        }
    }

    //Destruimos el desencadenante.
    if(iModo == 6)
    {
        object oTarget = GetLocalObject(OBJECT_SELF, "DM_DESEN_TARGET");
        DestroyObject(oTarget);
    }

    //Setear variable.
    if(iModo == 7)
    {
        object oTarget = GetLocalObject(OBJECT_SELF, "DM_DESEN_TARGET");
        string sNombre = GetLocalString(OBJECT_SELF, "DM_DESEN_STRING");
        int iValor = StringToInt(GetLocalString(OBJECT_SELF, "DM_DESEN_VALOR"));
        SetLocalInt(oTarget, sNombre, iValor);
        SendMessageToPC(OBJECT_SELF,ColorTexto("Seteada la variable "+sNombre+" con el valor "+IntToString(iValor)+".",TXT_COLOR_VERDE));
    }

    //Setear string.
    if(iModo == 8)
    {
        object oTarget = GetLocalObject(OBJECT_SELF, "DM_DESEN_TARGET");
        string sNombre = GetLocalString(OBJECT_SELF, "DM_DESEN_STRING");
        string sValor = GetLocalString(OBJECT_SELF, "DM_DESEN_VALOR");
        SetLocalString(oTarget, sNombre, sValor);
        SendMessageToPC(OBJECT_SELF,ColorTexto("Seteada la variable "+sNombre+" con el valor "+sValor+".",TXT_COLOR_VERDE));
    }

    //Saltar a desencadenante.
    if(iModo == 9)
    {
        object oTarget = GetLocalObject(OBJECT_SELF, "DM_DESEN_TARGET");
        location lLocalizacion = GetLocation(oTarget);
        DelayCommand(0.5, AssignCommand(OBJECT_SELF, ClearAllActions()));
        DelayCommand(1.0, AssignCommand(OBJECT_SELF, ActionJumpToLocation(lLocalizacion)));
    }
}

