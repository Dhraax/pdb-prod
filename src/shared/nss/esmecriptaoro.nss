void main()
{
object oEstatua1 = GetNearestObjectByTag("esmestaoro1");
object oEstatua2 = GetNearestObjectByTag("esmestaoro2");
object oEstatua3 = GetNearestObjectByTag("esmestaoro3");
object oUser = GetLastUsedBy();
AssignCommand(oEstatua1,ActionCastSpellAtObject(SPELL_FIREBALL,oUser,TRUE,40,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
AssignCommand(oEstatua2,ActionCastSpellAtObject(SPELL_FIREBALL,oUser,TRUE,40,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
AssignCommand(oEstatua3,ActionCastSpellAtObject(SPELL_FIREBALL,oUser,TRUE,40,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));

AssignCommand(oEstatua1,ActionCastSpellAtObject(SPELL_WALL_OF_FIRE,oUser,TRUE,40,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
AssignCommand(oEstatua2,ActionCastSpellAtObject(SPELL_WALL_OF_FIRE,oUser,TRUE,40,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
AssignCommand(oEstatua3,ActionCastSpellAtObject(SPELL_WALL_OF_FIRE,oUser,TRUE,40,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));

DestroyObject(GetNearestObjectByTag("esmeloro1"));
DestroyObject(GetNearestObjectByTag("esmeloro2"));
DestroyObject(GetNearestObjectByTag("esmeloro3"));
DestroyObject(GetNearestObjectByTag("esmeloro4"));
DestroyObject(GetNearestObjectByTag("esmeloro5"));
DestroyObject(GetNearestObjectByTag("esmeloro6"));
DestroyObject(GetNearestObjectByTag("esmeloro7"));
DestroyObject(GetNearestObjectByTag("esmeloro8"));

DestroyObject(GetNearestObjectByTag("esmeloro11"));

DestroyObject(OBJECT_SELF,4.0);
}
