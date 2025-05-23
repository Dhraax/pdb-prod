// RELIKIAS MINSORRAN, ONCLOSE

void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int bUseAppearAnimation = FALSE)
{
  CreateObject(nObjectType, sTemplate, lLoc, bUseAppearAnimation);
}

void main()
{
  if(GetLocalInt(GetModule(), "FX_apa_cofre") == 1) return;

  object oAltar_Shatar = GetObjectByTag("shatar_relikia");
  object oAltar_Edive = GetObjectByTag("edive_relikia");
  object oAltar_Ideepton = GetObjectByTag("ideepton_relikia");
  location lEfectos= GetLocation(GetWaypointByTag("efectos_relikias"));
  effect eEfecto1 = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
  effect eEfecto2 = EffectVisualEffect(VFX_IMP_DISPEL);
  effect eBeam_1 = EffectVisualEffect(VFX_FNF_PWSTUN);

  if(GetItemPossessedBy(oAltar_Shatar,   "ReliquiadeShatar")   != OBJECT_INVALID &&
     GetItemPossessedBy(oAltar_Edive,    "ReliquiadeEdive")    != OBJECT_INVALID &&
     GetItemPossessedBy(oAltar_Ideepton, "ReliquiadeIdeepton") != OBJECT_INVALID)
  {
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBeam_1, oAltar_Shatar));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBeam_1, oAltar_Edive));
      DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBeam_1, oAltar_Ideepton));
      DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEfecto1, lEfectos));
      DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEfecto2, lEfectos));
      DelayCommand(6.0, CreateObjectVoid(OBJECT_TYPE_PLACEABLE, "cofre_misnor", lEfectos));

      DestroyObject(GetItemPossessedBy(oAltar_Shatar, "ReliquiadeShatar"));
      DestroyObject(GetItemPossessedBy(oAltar_Edive, "ReliquiadeEdive"));
      DestroyObject(GetItemPossessedBy(oAltar_Ideepton, "ReliquiadeIdeepton"));

      SetLocalInt(GetModule(), "FX_apa_cofre", 1);
      GiveXPToCreature(GetLastClosedBy(), 1000);
  }
}
