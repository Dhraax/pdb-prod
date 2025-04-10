void main()
{
  object oPC = GetLastUsedBy();
  string sEtiquetaLlave = GetLockKeyTag(OBJECT_SELF);
  object oDestino = GetWaypointByTag("WP_" + GetTag(OBJECT_SELF));
  effect eBeam1 = EffectBeam(VFX_BEAM_EVIL,OBJECT_SELF,BODY_NODE_CHEST,FALSE);

  if(GetLocked(OBJECT_SELF) == TRUE)
  {
      if(GetItemPossessedBy(oPC, sEtiquetaLlave) == OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "<c  ó>*Necesitas algo para activar el mecanismo*</c>");
          return;
      }

      SendMessageToPC(oPC, "<c  ó>*Cruzas sin problemas*</c>");
  }


  ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
  DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oPC,7.0));
  DelayCommand(9.0, AssignCommand(oPC, JumpToObject(oDestino)));
  DelayCommand(9.0, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));




  }
