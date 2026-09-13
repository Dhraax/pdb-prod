/// ----------------------------------------------------------------------------
/// @system  SPELLS
/// @file    inc_effect_ids.nss
/// @author  Dhraax
/// @brief   Effect identities shared by more than one file, and their sources.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------
///
/// An effect identity normally belongs to the file that writes it, declared
/// there and nowhere else. This file is the single exception: an identity
/// referenced by more than one file needs one declaration they share, because
/// copies of a string literal in several files drift apart.
///
/// Nothing goes in here because it is an identity. It goes in here because it
/// has a second file. An identity with one file stays in that file.
///
/// ## An identity has one key per kind of source
///
/// The engine already identifies a spell: it stamps the spells.2da row on every
/// effect a spell script applies, and RemoveEffectsFromSpell finds it. What the
/// engine cannot identify is a source that is not a spell - a potion drunk from
/// an item activation records row -1 - and that is what a tag is for.
///
/// So a group has **two kinds of key**, and the rule is that every source
/// removes every key it does not own:
///
///     the spell   removes the potion's tag   (it already removes its own row)
///     the potion  removes the spell's row    (it already removes its own tag)
///
/// A stock spell script is therefore not rewritten to carry a tag it does not
/// need. It gains one removal and nothing else. The alternative - making every
/// spell apply through the library so it can carry a tag - would edit dozens of
/// BioWare scripts to reproduce an identity the engine already provides.
///
/// The exception is a group where **no** source has a usable row, and there is
/// one: SPEED. Three of its five sources apply from an item activation, so the
/// tag is the only key and every source carries it.
///
/// ## The group format is read by a script
///
/// scripts/check_effect_identity.py parses the blocks below. A group is:
///
///     /// @identity NAME
///     /// @sources file.nss, other.nss
///     const string ...
///
/// and the rule it enforces is that **every file in @sources removes every
/// constant in the group before it applies anything of its own**. That is what
/// makes an identity work in both directions instead of one.
///
/// The source list is maintained by hand and the checker cannot invent it: a new
/// source that is never added here is not checked. What the checker does catch
/// is the same source drifting out of step with the group afterwards, which is
/// how every one-sided guard in this module came to be.

/// ## Two systems are deliberately absent from every group below
///
/// If you are looking for them and cannot find them, this is why.
///
/// **The shifter, mmf_s3_skills.nss.** It grants rows 1540, 1541 and 1542 - mage
/// armour, elemental shield and acid sheath - which are the same benefits as
/// three of the identities below. It is not a source of any of them. The shifter
/// is its own system and is left alone; if it is ever brought in, the change is
/// to its parameters and never to how it behaves.
///
/// **sw_inc_vfx.nss, under src/nui.** A third effect-by-tag library with its own
/// callers. Not merged, not converted, not a source of anything.

// -----------------------------------------------------------------------------
//                              Shared Identities
// -----------------------------------------------------------------------------

/// @identity SPEED
/// @sources nw_s0_haste.nss, nw_s0_mashaste.nss, pb_potion_inc.nss, pb_mod_activate.nss
///
/// One creature carries one of these, never two. Haste, mass haste, the Volatil
/// potion, the Agitada potion and Sidra de Pera all grant the same movement.
///
/// It cannot be done by spells.2da row: three of the five sources apply from an
/// item activation, where the engine records no row at all. That is F4, and it
/// is why this is a tag.
///
/// The polymorph system's MMF_MOV_SPEED is deliberately **not** here. It is the
/// locomotion of an assumed form - a satyr is fast because it is a satyr - and
/// one of its values is a *decrease*, for the ent. Folding it in would make
/// haste cure an ent's slowness.
const string FX_ID_SPEED        = "SPELL_ACELERAR";
const string FX_ID_SPEED_VFX    = "SPELL_ACELERARVISUAL";
const string FX_ID_SPEED_CIDER  = "POCION_SIDRAPERA";

/// @identity SHIELD_ACID
/// @rows SPELL_MESTILS_ACID_SHEATH
/// @sources x2_s0_acidshth.nss, pb_potion_inc.nss
///
/// Mestil's Acid Sheath and the Corrosiva potion are one acid damage shield.
/// The potion's literal is kept because nw_i0_spells.nss reads it under the
/// pseudo-spell 20001, which is how dispel scripts strip a potion shield.
const string FX_ID_SHIELD_ACID  = "POCION_CORROSIVA";

/// @identity SHIELD_FIRE
/// @rows SPELL_ELEMENTAL_SHIELD
/// @sources nw_s0_fireshld.nss, pb_potion_inc.nss
///
/// Elemental Shield and the Calorifica potion. Its literal is read by
/// nw_i0_spells.nss under the pseudo-spell 20002, for the same reason.
const string FX_ID_SHIELD_FIRE  = "POCION_CALORIFICA";

/// @identity SHIELD_MAGIC
/// @rows SPELL_DEATH_ARMOR
/// @sources x2_s0_dtharm.nss, pb_potion_inc.nss
///
/// Death Armor and the Oscura potion. The potion had no identity at all: it
/// removed SPELL_DEATH_ARMOR and the spell stacked straight over it.
const string FX_ID_SHIELD_MAGIC = "POCION_OSCURA";

/// @identity SHIELD_SONIC
/// @rows SPELL_WOUNDING_WHISPERS
/// @sources x0_s0_woundwhis.nss, pb_potion_inc.nss
///
/// Wounding Whispers and the Aullante potion. The potion declined to apply when
/// the spell was running, which covered one order of events and left the other
/// open.
const string FX_ID_SHIELD_SONIC = "POCION_AULLANTE";

/// @identity IRONGUTS
/// @rows SPELL_IRONGUTS
/// @sources x2_s0_ironguts.nss, pb_potion_inc.nss
///
/// Ironguts and the Ferrea potion are one poison-save bonus.
/// The potion removed the spell and the spell had never heard of the potion.
const string FX_ID_IRONGUTS         = "POCION_FERREA";

/// @identity ENDURE_ELEMENTS
/// @rows SPELL_ENDURE_ELEMENTS
/// @sources nw_s0_endele.nss, pb_potion_inc.nss
///
/// Endure Elements and the Aislamiento potion are one damage resistance.
/// The potion removed the spell and the spell had never heard of the potion.
const string FX_ID_ENDURE_ELEM      = "POCION_AISLAMIENTO";

/// @identity STONE_BONES
/// @rows SPELL_STONE_BONES
/// @sources x2_s0_stnbones.nss, pb_potion_inc.nss
///
/// Stone Bones and the Blanquecina potion are one natural AC bonus, both for undead.
/// The potion removed the spell and the spell had never heard of the potion.
const string FX_ID_STONE_BONES      = "POCION_BLANQUECINA";

/// @identity MONSTROUS_REGEN
/// @rows SPELL_MONSTROUS_REGENERATION
/// @sources x2_s0_monregen.nss, pb_potion_inc.nss
///
/// Monstrous Regeneration and the Reparadora potion are one regeneration.
/// The potion removed the spell and the spell had never heard of the potion.
const string FX_ID_MONSTROUS_REGEN  = "POCION_REPARADORA";

/// @identity SHIELD
/// @rows 417
/// @sources x0_s0_shield.nss, pb_potion_inc.nss
///
/// The Shield spell, row 417, and the Barrera potion are one deflection bonus with magic missile immunity.
/// The potion removed the spell and the spell had never heard of the potion.
const string FX_ID_SHIELD_SPELL     = "POCION_BARRERA";

/// @identity MAGE_ARMOR
/// @rows SPELL_MAGE_ARMOR
/// @sources nw_s0_magearm.nss, pb_potion_inc.nss
///
/// Mage Armor and the Desvio potion are one armour bonus.
/// The potion removed the spell and the spell had never heard of the potion.
const string FX_ID_MAGE_ARMOR       = "POCION_DESVIO";

/// @identity STONESKIN
/// @rows SPELL_STONESKIN
/// @sources nw_s0_stoneskn.nss, pb_potion_inc.nss
///
/// Stoneskin and the Polvorienta potion are one damage reduction.
/// The potion removed the spell and the spell had never heard of the potion.
const string FX_ID_STONESKIN        = "POCION_POLVORIENTA";

/// @identity PROT_ELEMENTS
/// @rows SPELL_PROTECTION_FROM_ELEMENTS
/// @sources nw_s0_proele.nss, pb_potion_inc.nss
///
/// Protection from Elements and the Disipadora potion are one damage resistance.
/// The potion removed the spell and the spell had never heard of the potion.
const string FX_ID_PROT_ELEMENTS    = "POCION_DISIPADORA";
