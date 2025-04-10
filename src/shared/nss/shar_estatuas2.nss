void main()
{
  object oPC = GetLastUsedBy();

  object oEstatua1 = GetNearestObjectByTag("shar01");
  object oEstatua2 = GetNearestObjectByTag("shar02");
  object oEstatua3 = GetNearestObjectByTag("shar03");
  object oEstatua4 = GetNearestObjectByTag("shar04");

  int i1 = GetLocalInt(oEstatua1, "ESTATUA");
  int i2 = GetLocalInt(oEstatua2, "ESTATUA");
  int i3 = GetLocalInt(oEstatua3, "ESTATUA");
  int i4 = GetLocalInt(oEstatua4, "ESTATUA");

  if(i1 == 1 && i2 ==1 && i3 == 1 && i4 == 1)
  {
      effect eOscuridad = EffectAreaOfEffect(AOE_PER_DARKNESS);
      effect eOcultacion = EffectConcealment(60, MISS_CHANCE_TYPE_NORMAL);
      effect eUltra = EffectUltravision();

      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eOscuridad, GetLocation(OBJECT_SELF), 10.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOcultacion, oPC, 900.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUltra, oPC, 900.0);
      AssignCommand(oPC, SpeakString("¡Shar, Mi plena existencia se debe a ti!"));
  }
}
