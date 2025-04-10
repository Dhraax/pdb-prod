void CreateItemOnObjectVoid(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1)
{
     CreateItemOnObject(sItemTemplate, oTarget, nStackSize);
}

void DesmontarTienda(object oPC)
{
     effect eImmobilizado = EffectCutsceneImmobilize();
     float fDuracion = 12.0;
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmobilizado, oPC, fDuracion);
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, fDuracion-1.0));
     FloatingTextStringOnCreature("*Desmontando la tienda de campaña*", oPC);
     DelayCommand(2.0, FloatingTextStringOnCreature("*Desmontar esta tienda te llevará 2 asaltos*", oPC));
     DelayCommand(fDuracion, FloatingTextStringOnCreature("*Tienda desmontada*", oPC));
     DestroyObject(OBJECT_SELF, fDuracion);
     CreateItemOnObject("tienda_aventurer", oPC);
}

void main()
{
     object oPC = GetPCSpeaker();
     DesmontarTienda(oPC);
     DelayCommand(11.0, CreateItemOnObjectVoid("tienda_camp", oPC));
}
