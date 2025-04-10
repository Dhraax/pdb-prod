void main()
{
object oLigadura = OBJECT_SELF;
object oMaster = GetMaster(oLigadura);
effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);

 if(GetResRef(oLigadura) == "animarmuerto" || GetResRef(oLigadura) == "animarmuerto2" || GetResRef(oLigadura) == "animarmuerto3")
    {
      int nDG = GetLocalInt(oMaster, "UNDEADDG");
      int nNiveles = GetLocalInt(oLigadura, "NOMUERTO");

        //Restamos el valor del bicho muerto al control de Undeads.
        SetLocalInt(oMaster, "UNDEADDG", nDG - nNiveles);
        //Lo destruimos
        DelayCommand(1.0, RemoveHenchman(oMaster, OBJECT_SELF));
        DelayCommand(1.0, SetIsDestroyable(TRUE,FALSE,FALSE));
        DelayCommand(2.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLigadura));
        DelayCommand(3.0, DestroyObject(OBJECT_SELF));
        return;
    }

ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLigadura);
DestroyObject(oLigadura, 0.5);
}
