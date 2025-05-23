#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  string sNomvreConv1 = ObtenerStringPersistente(OBJECT_SELF, "CONV1NOMBRE");
  string sNomvreConv2 = ObtenerStringPersistente(OBJECT_SELF, "CONV2NOMBRE");
  string sNomvreConv3 = ObtenerStringPersistente(OBJECT_SELF, "CONV3NOMBRE");
  string sNomvreConv4 = ObtenerStringPersistente(OBJECT_SELF, "CONV4NOMBRE");
  string sNomvreConv5 = ObtenerStringPersistente(OBJECT_SELF, "CONV5NOMBRE");
  string sNomvreConv6 = ObtenerStringPersistente(OBJECT_SELF, "CONV6NOMBRE");
  string sNomvreConv7 = ObtenerStringPersistente(OBJECT_SELF, "CONV7NOMBRE");
  string sNomvreConv8 = ObtenerStringPersistente(OBJECT_SELF, "CONV8NOMBRE");
  string sNomvreConv9 = ObtenerStringPersistente(OBJECT_SELF, "CONV9NOMBRE");
  string sUmbral = ObtenerStringPersistente(OBJECT_SELF, "CONV15NOMBRE");

  if(sNomvreConv1 == "") sNomvreConv1 = "Tejón terrible";
  if(sNomvreConv2 == "") sNomvreConv2 = "Jabalí terrible";
  if(sNomvreConv3 == "") sNomvreConv3 = "Lobo terrible";
  if(sNomvreConv4 == "") sNomvreConv4 = "Araña terrible";
  if(sNomvreConv5 == "") sNomvreConv5 = "Oso terrible";
  if(sNomvreConv6 == "") sNomvreConv6 = "Tigre terrible";
  if(sNomvreConv7 == "") sNomvreConv7 = "Elemental enorme aleatorio";
  if(sNomvreConv8 == "") sNomvreConv8 = "Elemental mayor aleatorio";
  if(sNomvreConv9 == "") sNomvreConv9 = "Elemental anciano aleatorio";
  if(sUmbral == "") sUmbral = "Aleatorio";

  SetCustomToken(3801, sNomvreConv1);
  SetCustomToken(3802, sNomvreConv2);
  SetCustomToken(3803, sNomvreConv3);
  SetCustomToken(3804, sNomvreConv4);
  SetCustomToken(3805, sNomvreConv5);
  SetCustomToken(3806, sNomvreConv6);
  SetCustomToken(3807, sNomvreConv7);
  SetCustomToken(3808, sNomvreConv8);
  SetCustomToken(3809, sNomvreConv9);
  SetCustomToken(3815, sUmbral);

  return TRUE;
}
