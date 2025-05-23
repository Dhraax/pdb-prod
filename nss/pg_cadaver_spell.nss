#include "lib_disguise"
void PenalizacionXP(object oCadaver, int iProcentage)
{
  int iTotalExp = GetXP(oCadaver);
  int iPenalizacion = (iProcentage * iTotalExp) / 100;
  int iNuevaExp = iTotalExp - iPenalizacion;

  if(iNuevaExp > 1000) SetXP(oCadaver, iNuevaExp);
  else SetXP(oCadaver, 1000);
}

void main()
{
  object oPC = GetLastSpellCaster();
  object oCadaver = GetLocalObject(OBJECT_SELF, "CAD_JUGADOR");
  object oAreaCadaver = GetArea(oCadaver);
  string sAreaCadaver = GetTag(oAreaCadaver);
  int iConjuro = GetLastSpell();
  int iAnimacionesPlanoFuga = GetLocalInt(oCadaver, "ANIMACIONES_PLANO_FUGA");

  // Revivir a los muertos y Resurrecion
  if(iConjuro == SPELL_RAISE_DEAD || iConjuro == SPELL_RESURRECTION)
  {
      // Mensajes de error
      if(sAreaCadaver != "plano_fuga" || oAreaCadaver == OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "<cþ>El jugador al que intentas resucitar no se encuentra en el Plano de la Fuga (está desconectado del servidor o cargando área). No puedes resucitarlo.</c>");
          return;
      }

      if(iAnimacionesPlanoFuga == TRUE)
      {
          SendMessageToPC(oPC, "<cþ>El jugador al que intentas resucitar se encuentra reproduciendo la secuencia cinematográfica de entrada al Plano de la Fuga (la cual dura 50 segundos). Por favor, intenta resucitarlo unos segundos más tarde.</c>");
          return;
      }

      // Funciones principales
      SetLocalInt(OBJECT_SELF, "NOSATURAR", 1);
      FloatingTextStringOnCreature("<c þ >¡Resucitas el cadáver! Su alma pronto se unirá a su cuerpo y se levantará en este mismo lugar.</c>", oPC);
      SendMessageToPC(oCadaver, "<c þ >¡"+PB_Disguise_GetNameOverride(oPC)+" ha resucitado tu cuerpo! Prepárate para volver al Mundo Material.</c>");
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), OBJECT_SELF);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oCadaver);
      DelayCommand(0.4, AssignCommand(oCadaver, ClearAllActions()));
      DelayCommand(0.5, AssignCommand(oCadaver, JumpToObject(oPC)));

      // Penalizacion de xp al ser resucitado
      if(iConjuro == SPELL_RAISE_DEAD)
      {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oCadaver) - 1), oCadaver);
          FloatingTextStringOnCreature("<cî>Pierdes un 3% de tu XP por la resurrección.</c>", oCadaver, FALSE);
          PenalizacionXP(oCadaver, 3);
      }
      else if(iConjuro == SPELL_RESURRECTION)
      {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oCadaver)), oCadaver);
          FloatingTextStringOnCreature("<cî>Pierdes un 2% de tu XP por la resurrección.</c>", oCadaver, FALSE);
          PenalizacionXP(oCadaver, 2);
      }

      DestroyObject(OBJECT_SELF, 2.0);
  }

  // Cualquier otro conjuro
  else
  {
      SendMessageToPC(oPC, "<cþ>Si lanzaras [Revivir a los muertos] o [Resurrección] sobre este cadáver podrías resucitarlo.</c>");
  }
}
