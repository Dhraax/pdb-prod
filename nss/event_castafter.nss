/// ----------------------------------------------------------------------------
/// @system NWNX_ON_CAST_SPELL_AFTER
/// @file event_castafter.nss
/// @author Dhraax
/// @brief Executes post-cast logic: cleans up effects on magic-immune creatures.
/// ----------------------------------------------------------------------------

void main()
{
    // -------------------------------------------------------------------------
    // Remove spell effects from creatures with IMMUNE_MAGIC if the caster is a PC.
    // -------------------------------------------------------------------------
    DelayCommand(1.0, ExecuteScript("inmune_cleanup", OBJECT_SELF));
}
