// Auto Frenesi Berserker //


void main()
{
    if(!GetHasFeatEffect(1443)) // Solo si no estamos en frenesi
    {
     int willSaveDC = 1 + GetTotalDamageDealt()/2;
     int save = WillSave(OBJECT_SELF, willSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF);
     if(save == 0)
     {
          ClearAllActions();
          FloatingTextStringOnCreature("<cþ<<>* ¡Has entrado en Frenesi por el daño recibido! *</c>", OBJECT_SELF, FALSE);
          ActionCastSpellAtObject(1329, OBJECT_SELF, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
          DecrementRemainingFeatUses(OBJECT_SELF, 1443);

     }
    }
}
