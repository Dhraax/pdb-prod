void main()
{
object oEntrante = GetEnteringObject();
if(GetLocalInt(oEntrante, "MALARCUERDA") ==

0)
{
  AssignCommand(oEntrante,

ActionSpeakString("Viendo la suerte que han corrido esos dos lo mejor es no precipitarse, la trampa ha de activarse pisando el suelo"));
  SetLocalInt(oEntrante, "MALARCUERDA", 1);
  DelayCommand(200.0,

DeleteLocalInt(oEntrante, "MALARCUERDA"));
}
}
