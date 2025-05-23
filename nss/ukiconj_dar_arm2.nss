#include "mti_libreria"

void main()
{
SetCutsceneMode(GetPCSpeaker(),TRUE);

FadeToBlack(GetPCSpeaker(),FADE_SPEED_MEDIUM);
GuardarIntPersistente(GetPCSpeaker(),"ENTRENAMIENTOGU2",5);
GiveXPToCreature(GetPCSpeaker(),200);
DelayCommand(4.0,FadeFromBlack(GetPCSpeaker(),FADE_SPEED_MEDIUM));
DelayCommand(4.5,SetCutsceneMode(GetPCSpeaker(),FALSE));
}
