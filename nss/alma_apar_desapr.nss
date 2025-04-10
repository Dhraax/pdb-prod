void main()
{
  object oFantasma = GetNearestObjectByTag("Almaenpena_psk");
  object oPuntoRuta = GetNearestObjectByTag("WP_Almaenpena_psk_01");
  object oMod = GetModule();
  location oLugar = GetLocation(oPuntoRuta);
  effect eDesaparecer = EffectDisappear();

  if(GetIsDay() == TRUE)
  {
      if(GetLocalInt(oMod, "FANTASMANOCHE") == TRUE)
      {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oFantasma);
          DeleteLocalInt(oMod, "FANTASMANOCHE");
      }
  }

  else
  {
      if(GetLocalInt(oMod, "FANTASMANOCHE") == FALSE)
      {
          SetLocalInt(oMod, "FANTASMANOCHE", TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "almaenpena_psk", oLugar, TRUE);
      }
  }
}
