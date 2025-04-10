void main()
{
  object oActivador = GetLastUsedBy();
  object oCaster = GetLocalObject(OBJECT_SELF, "CASTER");
  int iExito = FALSE;

  // Se destruye la puerta a los 80 segundos de usarla
  DestroyObject(OBJECT_SELF, 80.0);

  // Teleport solo si eres del mismo grupo que el creador de la puerta
  object oPC = GetFirstPC();
  while(GetIsObjectValid(oPC) && iExito == FALSE)
  {
      if(oPC == oCaster)
      {
          if(GetFactionLeader(oPC) == GetFactionLeader(oActivador))
          {
              SetLocalLocation(oActivador, "SALIDAMAGOS", GetLocation(oActivador));
              ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN);
              ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION),OBJECT_SELF);
              DelayCommand(0.5,AssignCommand(oActivador, JumpToLocation(GetLocation(GetWaypointByTag("gremiomagos")))));
              DelayCommand(2.0,ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE));
              iExito = TRUE;
          }
      }

      oPC = GetNextPC();
  }

  // Mensaje de fracaso
  if(iExito == FALSE) FloatingTextStringOnCreature("<cþ<<>No te está permitido entrar en esta puerta mágica.</c>", oActivador);
}
