// Inspirar Frenesi - Berseker Frenetico//

void main()
{

    if(GetHasFeatEffect(1443)) // Estamos en frenesi
    {
        // Declare major variables
        object oTarget;
        object oInspirar;
        location oLoc = GetLocation(OBJECT_SELF);
        effect eVis = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);

        //prevenimos spam...
        if(GetLocalInt(OBJECT_SELF, "INSPIRAR_FRENESI"))
                {
                FloatingTextStringOnCreature("Sólo puedes Inspirar Frenesi cada 3 minutos.", OBJECT_SELF, FALSE);
                return;
                }

        //Determine friends in the radius around the character
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(OBJECT_SELF));
        while (GetIsObjectValid(oTarget))
        {
          if(GetIsFriend(oTarget) && oTarget != OBJECT_SELF )
            {
             SetLocalInt(OBJECT_SELF, "INSPIRAR_FRENESI", TRUE);
             DelayCommand(180.0, DeleteLocalInt(OBJECT_SELF, "INSPIRAR_FRENESI"));
             FloatingTextStringOnCreature(GetName(oTarget) + " ha recibido un item para activar frenesi.", OBJECT_SELF, FALSE);
             FloatingTextStringOnCreature(GetName(OBJECT_SELF) + " te ha dado la posibilidad de entrar en frenesi, por favor comprueba la descripción con cuidado antes de utilizarlo.", oTarget, FALSE);
             oInspirar = CreateItemOnObject("inspirarfrenesi", oTarget);
             DelayCommand(40.0, DestroyObject(oInspirar));
            }

         oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(OBJECT_SELF));
        }
    }
    else FloatingTextStringOnCreature("** Debes estar en Frenesi para utilizar esta habilidad. **",OBJECT_SELF ,FALSE);
}
