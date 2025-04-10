// ARTESANIA URDIMBRICA, VENDER ESENCIAS

void main()
{
  object oPC = GetPCSpeaker();
  int iContador4po, iContador8po, iContador12po, iContador16po, iContador20po, iContador24po, iContador28po, iContador32po;

  // Contador de esencias
  object oEsencia = GetFirstItemInInventory(oPC);
  string sTag, sTag2, sTag3;
  while(GetIsObjectValid(oEsencia) == TRUE)
  {
      sTag = GetTag(oEsencia);
      sTag2 = GetStringLeft(sTag, 13);
      sTag3 = GetStringLeft(sTag, 14);

      if(sTag == "pb_artesa_poten1" || sTag2 == "pb_artesa_gem" || sTag2 == "pb_artesa_hab"  || sTag == "pb_artesa_peso" || sTag == "pb_artesa_cm")
      {
          iContador4po = iContador4po + 1;
          DestroyObject(oEsencia);
      }
      else if(sTag2 == "pb_artesa_lim" || sTag3 == "pb_artesa_sal2" || sTag3 == "pb_artesa_clas")
      {
          iContador8po = iContador8po + 1;
          DestroyObject(oEsencia);
      }
      else if(sTag == "pb_artesa_poten2" || sTag3 == "pb_artesa_sal1" || sTag3 == "pb_artesa_dano" || sTag == "pb_artesa_rv")
      {
          iContador12po = iContador12po + 1;
          DestroyObject(oEsencia);
      }
      else if(sTag == "pb_artesa_vo" || sTag == "pb_artesa_at" || sTag == "pb_artesa_rc")
      {
          iContador16po = iContador16po + 1;
          DestroyObject(oEsencia);
      }
      else if(sTag == "pb_artesa_poten3" || sTag == "pb_artesa_ca" || sTag2 == "pb_artesa_car" || sTag == "pb_artesa_rd")
      {
          iContador20po = iContador20po + 1;
          DestroyObject(oEsencia);
      }
      else if(sTag == "pb_artesa_sal200" || sTag2 == "pb_artesa_efe" || sTag == "pb_artesa_mej")
      {
          iContador24po = iContador24po + 1;
          DestroyObject(oEsencia);
      }
      else if(sTag == "pb_artesa_poten4" || sTag == "pb_artesa_reg" || sTag3 == "pb_artesa_polv")
      {
          iContador28po = iContador28po + 1;
          DestroyObject(oEsencia);
      }
      else if(sTag == "pb_artesa_inconj")
      {
          iContador32po = iContador32po + 1;
          DestroyObject(oEsencia);
      }

      oEsencia = GetNextItemInInventory(oPC);
  }

  int iOro = (iContador4po * 4) + (iContador8po * 8) + (iContador12po * 12) + (iContador16po * 16) +
             (iContador20po * 20) + (iContador24po * 24) + (iContador28po * 28) + (iContador32po * 32);

  if(iOro == 0) ActionSpeakString("¡No tienes esencias para mi! No me hagas perder el tiempo.");
  else
  {
      ActionSpeakString("Aquí tienes tu oro, un placer hacer tratos contigo.");
      GiveGoldToCreature(oPC, iOro);
  }
}
