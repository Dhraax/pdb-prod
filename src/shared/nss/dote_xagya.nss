//::///////////////////////////////////////////////
//:: DOTE REPUTACION
//:: Copyright www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
  Atrae ayudantes al xagya de las sombras.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 22/08/2012
//:://////////////////////////////////////////////


void main()
{

  object oPC = OBJECT_SELF;
  object oMod = GetModule();
  int iDoteReputacion;

  // Que dote de reputacion tenemos?
  if(GetHasFeat(1386, oPC)) iDoteReputacion = 1;
  if(GetHasFeat(1387, oPC)) iDoteReputacion = 2;


  // Antisaturamiento, solo una vez cada 15 minutos
  if(GetLocalInt(oMod, "XAGYA" + GetName(oPC, TRUE)) == 1)
  {
      SendMessageToPC(oPC, "<cþ<<>No puedes reclamar a tus aliados tan frecuentemente.</c>");
      return;
  }

  SetLocalInt(oMod, "XAGYA" + GetName(oPC, TRUE), 1);
  DelayCommand(900.0, DeleteLocalInt(oMod, "XAGYA" + GetName(oPC, TRUE)));


  // Mensaje
  FloatingTextStringOnCreature("<c´þd>* Llamas a tus aliados Xag-ya *</c>", oPC, FALSE);


  //Creamos las criaturas y las unimos al jugador
  if(iDoteReputacion == 1)
  {
         effect oxagya1 = EffectSummonCreature("conj_xagya", VFX_FNF_STRIKE_HOLY);
         ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, oxagya1, GetLocation(oPC), 1800.0);
  }
  else if(iDoteReputacion == 2)
  {
        effect oxagya2 = EffectSummonCreature("conj_xagya2", VFX_FNF_STRIKE_HOLY);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, oxagya2, GetLocation(oPC), 1800.0);
  }

}



