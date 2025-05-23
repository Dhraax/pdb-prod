//::///////////////////////////////////////////////
//:: COMPETENCIAS CON ESCUDOS
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Regula las competencias con escudos
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 18 de Mayo de 2011
//:://////////////////////////////////////////////

void AplicarCompetenciaEscudos(object oPC, object oObjeto)
{
  int iDoteCompetencia, iTipoCaso, iAtaque;
  int iObjetoBase = GetBaseItemType(oObjeto);

  switch(iObjetoBase)
  {
      case BASE_ITEM_SMALLSHIELD: iDoteCompetencia = 32; iTipoCaso = 1; break;    // Escudo pequenyo
      case BASE_ITEM_LARGESHIELD: iDoteCompetencia = 32; iTipoCaso = 1; break;    // Escudo grande
      case BASE_ITEM_TOWERSHIELD: iDoteCompetencia = 1305; iTipoCaso = 2; break;  // Escudo paves
      case 341: iDoteCompetencia = 32; iTipoCaso = 1; break;   // Escudo pequenyo 2
      case 345: iDoteCompetencia = 32; iTipoCaso = 1; break;   // Escudo grande 2
      case 346: iDoteCompetencia = 1305; iTipoCaso = 2; break; // Escudo paves 2
      case 352: iDoteCompetencia = 32; iTipoCaso = 1; break;   // Rodela
      default:  iDoteCompetencia = FALSE; break;
  }

  // Si nos equipamos un objeto que no requiere competencia, no pasa nada
  if(iDoteCompetencia == FALSE) return;

  switch(iTipoCaso)
  {
      // RODELAS, ESCUDOS PEQUENYOS Y ESCUDOS GRANDES
      case 1:
      {
          if(GetHasFeat(iDoteCompetencia, oPC) == FALSE)
          {
              if(iObjetoBase == BASE_ITEM_LARGESHIELD || iObjetoBase == 345) iAtaque = 2; // Escudos Grandes
              else iAtaque = 1;                                        // Rodelas y escudos pequenyos

              if(GetLocalInt(oPC, "BONOS_ESCUDO") == 0){
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(iAtaque)), oPC);
              FloatingTextStringOnCreature("<cþ<<>* No eres competente con "+GetName(oObjeto)+" *</c>",oPC, FALSE);
              DelayCommand(0.2, SendMessageToPC(oPC, "<cþþþ>"+GetName(oObjeto)+" te aplica un penalizador de <cþ>-"+IntToString(iAtaque)+"</c> al Ataque.</c>"));
              SetLocalInt(oPC, "BONOS_ESCUDO", 1);
              }
          }
      }break;

      // ESCUDOS PAVESES
      case 2:
      {
          if(GetHasFeat(iDoteCompetencia, oPC) == FALSE) iAtaque = 12;
          else iAtaque = 2;

          if(GetLocalInt(oPC, "BONOS_ESCUDO") == 0){
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(1)), oPC);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(iAtaque)), oPC);
                SetLocalInt(oPC, "BONOS_ESCUDO", 1);
                }

          if(GetLocalInt(oPC, "PB_EFECTOS_EVENTO_EQUIPAR"))
          {
              if(iAtaque == 12) FloatingTextStringOnCreature("<cþ<<>* No eres competente con "+GetName(oObjeto)+" *</c>",oPC, FALSE);
              DelayCommand(0.2, SendMessageToPC(oPC, "<cþ>"+GetName(oObjeto)+" te aplica un bonificador y penalizador de <c ó >+4</c> a la CA base y <cþ>-"+IntToString(iAtaque)+"</c> al Ataque.</c>"));
              DeleteLocalInt(oPC, "PB_EFECTOS_EVENTO_EQUIPAR");
          }
      }break;
  }
}

void main()
{
  object oEscudo = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

  if(!GetIsObjectValid(oEscudo) || GetLocalInt(OBJECT_SELF, "Poder_activo") == 1)  return;

  AplicarCompetenciaEscudos(OBJECT_SELF, oEscudo);
}
