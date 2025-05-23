void main()
{
    object oEscalera = GetNearestObjectByTag("escaleravariable2");
    object oPJ = GetLastUsedBy();
        if((GetLocalString(oEscalera, "Niveldeagua") == "2"))
        {



object oTrampilla = GetObjectByTag("trampillacimitarra");
location lLugar = GetLocation(GetWaypointByTag("WP_desagabajo"));


if(GetLocalInt(oTrampilla, "TRAMPILLA_CIMITARRA") == 1)
   {
    FloatingTextStringOnCreature("La trampilla de piedra está abierta y te introduces en ella", oPJ);
    DelayCommand(1.4, AssignCommand(oPJ, ActionJumpToLocation(lLugar)));
   effect eSaltar = EffectAppear(1);
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT,eSaltar,oPJ));

   }

else if((GetAbilityScore(oPJ, ABILITY_STRENGTH) > 20))
   {
    SetLocalInt(oTrampilla, "TRAMPILLA_CIMITARRA", 1);

    FloatingTextStringOnCreature("Tiras con todas tus fuerzas de la pesada trampilla y consigues levantarla", oPJ);
    PlayAnimation(ANIMATION_PLACEABLE_OPEN);
    DelayCommand(20.0, AssignCommand(oTrampilla, SpeakString("¡La tapa de la trampilla se baja un poco debido a su peso!")));
    DelayCommand(40.0, AssignCommand(oTrampilla, SpeakString("¡La trampilla está a punto de cerrarse!")));
    DelayCommand(60.0, AssignCommand(oTrampilla, SpeakString("¡La tapa de piedra ha cedido por el peso y la trampilla se ha cerrado!")));
    DelayCommand(60.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
    DelayCommand(60.0, DeleteLocalInt(oTrampilla, "TRAMPILLA_CIMITARRA"));
   }
else
   {
    PlaySound("as_dr_locked2");

    FloatingTextStringOnCreature("Intentas levantar la trampilla de piedra, pero no tienes suficiente fuerza", oPJ);
    }
    }

else
{
    FloatingTextStringOnCreature("La sala esta llena de agua sucia y no podras abrir la trampilla mientras lo este",oPJ);
}
}
