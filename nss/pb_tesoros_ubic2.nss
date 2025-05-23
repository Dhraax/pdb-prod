

//Inclusion de librerias..
#include "pb_tesoro_gold"
#include "pb_tesoro_scroll"
#include "pb_tesoro_potion"
#include "pb_tesoro_ccweap"
#include "pb_tesoro_diweap"
#include "pb_tesoro_munici"
#include "pb_tesoro_magos"
#include "pb_tesoro_escudo"
#include "pb_tesoro_miscel"
#include "pb_tesoro_armor"

void EliminarCofre(object oCofre)
{
    object oRemoveItem = GetFirstItemInInventory(oCofre);
  while(GetIsObjectValid(oRemoveItem))
  {
      DestroyObject(oRemoveItem);

      oRemoveItem = GetNextItemInInventory(oCofre);
  }

DestroyObject(oCofre, 5.0);
}


void main()
{
    //Tablas de tesoro para los jefes en funcion de sus dados de golpe
   int nDG;

  switch(GetLocalInt(OBJECT_SELF, "TIPOTESORO"))
  {
      case 1: nDG = 12; break;
      case 2: nDG = 16; break;
      case 3: nDG = 20; break;
      case 4: nDG = 30; break;
      case 5: nDG = 40; break;
  }

  // Anti spam
  if(GetLocalInt(OBJECT_SELF, "TESOROGENERADO") == TRUE) return;
  SetLocalInt(OBJECT_SELF, "TESOROGENERADO", TRUE);

  //Borramos el cofre tras 5 minutos
  DelayCommand(300.0, EliminarCofre(OBJECT_SELF));

  // Eliminar anteriores objetos del ubicado
  object oRemoveItem = GetFirstItemInInventory(OBJECT_SELF);
  while(GetIsObjectValid(oRemoveItem))
  {
      DestroyObject(oRemoveItem);

      oRemoveItem = GetNextItemInInventory(OBJECT_SELF);
  }

    //Otorgamos oro y gemas por nivel

    DelayCommand(2.0, addGold(OBJECT_SELF, nDG));
    DelayCommand(2.0,addGem(OBJECT_SELF, nDG));
    //Otorgamos pergas y pociones por nivel.
    DelayCommand(2.0,addScroll(OBJECT_SELF, nDG));
    DelayCommand(2.0,addPotion(OBJECT_SELF, nDG));

    //Otorgamos objetos.
    DelayCommand(2.0,crearArmaCC(OBJECT_SELF, nDG));
    DelayCommand(2.0,crearArmadura(OBJECT_SELF, nDG));
    DelayCommand(2.0,crearMiscelaneo(OBJECT_SELF, nDG));
    if(d100() <= 35) DelayCommand(2.0,crearArmaDI(OBJECT_SELF, nDG));
    if(d100() <= 35) DelayCommand(2.0,crearArmaCC(OBJECT_SELF, nDG));
    if(d100() <= 35) DelayCommand(2.0,crearCetrosVaras(OBJECT_SELF, nDG));
    if(d100() <= 35) DelayCommand(2.0,crearMunicion(OBJECT_SELF, nDG));
    if(d100() <= 45) DelayCommand(2.0,crearEscudo(OBJECT_SELF, nDG));

    if(nDG >= 20) {
        if(d100() <= 15) DelayCommand(2.0,crearBastonMago(OBJECT_SELF, nDG));
    }
    if(nDG >= 30 && nDG < 40) {
        DelayCommand(2.0,crearMiscelaneo(OBJECT_SELF, 25));
    }
    if(nDG >= 40) {
        DelayCommand(2.0,crearMiscelaneo(OBJECT_SELF, 35));
        DelayCommand(2.0,crearMiscelaneo(OBJECT_SELF, nDG));
    }
}



