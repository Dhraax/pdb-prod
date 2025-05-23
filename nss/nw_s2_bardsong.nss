//::///////////////////////////////////////////////
//:: MUSICA DE BARDO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Desactivada, en su lugar se usan las imspiraciones y canciones
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 5 de Abril de 2011
//:://////////////////////////////////////////////

void main()
{
  FloatingTextStringOnCreature("<cþ<<>Usa las distintas dotes de canciones para cantar, esta dote sólo muestra el número total de cantos disponibles.</c>", OBJECT_SELF, FALSE);
  IncrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
