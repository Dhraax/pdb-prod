void main()
{
  object oPC = GetLastUsedBy();
  string luna_roja = GetLockKeyTag(OBJECT_SELF);
  object oDestino = GetWaypointByTag("entrada_lunaroja");

  if(GetLocked(OBJECT_SELF) == TRUE)
  {
      if(GetItemPossessedBy(oPC, luna_roja) == OBJECT_INVALID)
      {
          FloatingTextStringOnCreature("*Algo en ti te dice que mejor no entrar aqui.*", oPC);
          return;
      }

      SendMessageToPC(oPC, "<c´þd>*Un fuerte ahullido sale del interior reconociendote como su aliado*</c>");
  }

  // Teleport
  PlayAnimation(ANIMATION_PLACEABLE_OPEN);
  DelayCommand(1.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
  DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(0.3, AssignCommand(oPC, JumpToObject(oDestino)));
}
