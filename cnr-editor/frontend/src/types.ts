export type Role = 'admin' | 'technical' | 'dungeon_master' | 'editor' | 'collaborator'
export type Permission =
  | 'view_recipes'
  | 'edit_recipes'
  | 'view_users'
  | 'edit_users'
  | 'view_accounts'
  | 'edit_accounts'
  | 'activate_cd_keys'
  | 'view_characters'
  | 'view_character_identity'
  | 'edit_character_identity'
  | 'view_character_timestamps'
  | 'view_character_abilities'
  | 'view_character_classes'
  | 'view_character_level_unlocks'
  | 'edit_character_level_unlocks'
  | 'view_character_profile'
  | 'edit_character_profile'
  | 'view_character_tradeskills'
  | 'edit_character_tradeskills'

export interface User {
  user_id: number
  username: string
  email: string | null
  role: Role
  permissions: Permission[]
  editable_profession_ids: number[]
  active: boolean
  mfa_enabled: boolean
  created_at: string
  updated_at: string
}

export type AuditDomain = 'recipe' | 'account' | 'character' | 'user' | 'dm_access'

export interface AuditEntry {
  revision_key: string
  domain: AuditDomain
  target_id: number | string
  target_label: string
  action: string
  changed_at: string
  actor_user_id: number | null
  actor_username: string | null
  before: Record<string, unknown>
  after: Record<string, unknown>
  note: string | null
}

export interface AuditPage {
  items: AuditEntry[]
  total: number
  offset: number
  limit: number
}

export interface Session {
  user: User
  writes_enabled: boolean
}

export interface DmCdKeyWhitelistEntry {
  cd_key: string
  display_name: string | null
  added_at: string
  globally_banned: boolean
}

export interface MfaChallenge {
  mfa_required: true
}

export interface MfaSetup {
  secret: string
  provisioning_uri: string
  qr_svg_data_uri: string
}

export interface MfaConfirmation {
  recovery_codes: string[]
}

export interface RecipeListItem {
  recipe_id: number
  public_id: number
  display_name: string
  profession_id: number
  profession_name: string
  station_name: string
  category_name: string
  material_name: string | null
  tier: number
  dc: number
  xp_award: number
  gold_value: number
  enabled: boolean
  component_count: number
  property_count: number
  updated_at: string
}

export interface RecipePage {
  items: RecipeListItem[]
  total: number
  offset: number
  limit: number
}

export interface ComponentRow {
  component_tag: string
  display_name: string | null
  qty: number
  retain_on_fail: number
  sort_order: number
}

export interface PropertyRow {
  recipe_property_id: number
  property_type: string
  subtype: number
  value1: number
  value2: number
  sort_order: number
  display_text: string
}

export interface RecipeDetail {
  recipe_id: number
  public_id: number
  category_id: number
  material_id: number | null
  tier: number
  display_name: string
  description: string | null
  base_resref: string
  output_tag: string | null
  output_qty: number
  output_kind: 'product' | 'material'
  dc: number
  xp_award: number
  gold_value: number
  enabled: boolean
  legacy_code: string | null
  created_at: string
  updated_at: string
  components: ComponentRow[]
  properties: PropertyRow[]
}

// Arcane enchanting. The trade has no recipes: cnr_recipe is empty for
// profession 6. What it sells is a property, bought by the step, on an item
// the group admits. The concurrency token is a fingerprint rather than a
// timestamp because the arcane tables are generated and carry no updated_at.

export interface ArcaneListItem {
  arcane_id: number
  display_name: string
  section: string
  group_id: number
  group_name: string
  any_base: boolean
  tier: number
  min_level: number
  dc: number
  property_type: string
  subtype: number
  essence_name: string
  crystal_name: string
  supported: boolean
  step_count: number
  base_item_count: number
  fingerprint: string
}

export interface ArcanePage {
  items: ArcaneListItem[]
  total: number
  offset: number
  limit: number
}

export interface ArcaneStepRow {
  essences: number
  subtype: number | null
  value1: number
  value2: number
  xp: number
  display_value: string
}

export interface ArcaneBaseItem {
  base_item: number
  crystal_cost: number
}

export interface ArcaneGroup {
  group_id: number
  code: string
  display_name: string
  any_base: boolean
  bases: ArcaneBaseItem[]
}

export interface ArcaneDetail {
  arcane_id: number
  section: string
  display_name: string
  group_id: number
  tier: number
  essence_resref: string
  essence_name: string
  crystal_resref: string
  crystal_name: string
  ubicacion: string
  property_type: string
  subtype: number
  min_level: number
  dc: number
  supported: boolean
  note: string | null
  group: ArcaneGroup
  steps: ArcaneStepRow[]
  fingerprint: string
}

export interface ArcaneReferences {
  groups: ArcaneGroup[]
  sections: string[]
  property_types: string[]
}

export interface ReferenceItem {
  id: number
  display_name: string
  parent_id?: number | null
  profession_id?: number | null
  station_id?: number | null
  tier?: number | null
  enabled?: boolean | null
}

export interface References {
  professions: ReferenceItem[]
  stations: ReferenceItem[]
  categories: ReferenceItem[]
  materials: ReferenceItem[]
}

export type PropertyBinding = 'subtype' | 'value1' | 'value2'

export interface PropertyOption {
  label: string
  values: Partial<Record<PropertyBinding, number>>
}

export interface PropertyControl {
  key: string
  label: string
  kind: 'select' | 'number'
  bindings: PropertyBinding[]
  options: PropertyOption[]
  minimum: number | null
  maximum: number | null
}

export interface PropertyDefinition {
  property_type: string
  label: string
  description: string
  defaults: Record<PropertyBinding, number>
  fixed: Partial<Record<PropertyBinding, number>>
  controls: PropertyControl[]
}

export interface PropertyDefinitions {
  version: number
  items: PropertyDefinition[]
}

export type AccountStatus = 'active' | 'blocked'
export type CharacterStatus = 'active' | 'blocked' | 'deleted'

export interface CharacterClassRow {
  class_slot: number
  class_id: number
  class_level: number
  code: string
  display_name: string
}

export interface ClassDefinition {
  class_id: number
  code: string
  display_name: string
}

export interface TradeskillRow {
  skill_name: string
  display_name: string
  skill_level: number
  skill_xp: number
  updated_at: string | null
}

export interface TradeskillDefinition {
  skill_name: string
  display_name: string
  level_thresholds: number[]
}

export interface CharacterDetail {
  character_id: number
  account_id: number
  character_uuid: string | null
  observed_name: string | null
  display_name: string
  display_name_override: string | null
  status: CharacterStatus | null
  race_id: number | null
  subrace: string | null
  gender_id: number | null
  portrait_resref: string | null
  deity: string | null
  strength_score: number | null
  dexterity_score: number | null
  constitution_score: number | null
  intelligence_score: number | null
  wisdom_score: number | null
  charisma_score: number | null
  admin_notes: string | null
  deleted_at: string | null
  created_at: string | null
  last_login_at: string | null
  updated_at: string | null
  rebuilds_available: number | null
  rebuilds_completed: number | null
  total_level: number
  classes: CharacterClassRow[]
  tradeskills: TradeskillRow[]
  level_unlocks: number[]
  applied_level_unlocks: number[]
}

export interface AccountListItem {
  account_id: number
  cd_key_hint: string
  cd_key: string | null
  observed_name: string | null
  display_name: string
  status: AccountStatus
  character_count: number
  first_seen: string
  last_seen: string
}

export interface AccountPage {
  items: AccountListItem[]
  total: number
  offset: number
  limit: number
}

export interface AccountDetail {
  account_id: number
  cd_key_hint: string
  cd_key: string | null
  observed_name: string | null
  display_name: string
  display_name_override: string | null
  status: AccountStatus
  admin_notes: string | null
  first_seen: string
  last_seen: string
  updated_at: string | null
  cd_key_reset: {
    status: 'none' | 'awaiting_candidate' | 'awaiting_confirmation' | 'confirmed' | 'expired'
    candidate_hint: string | null
    requested_at: string | null
    expires_at: string | null
    candidate_captured_at: string | null
    confirmed_at: string | null
  }
  characters: CharacterDetail[]
}

export interface AccountAccessCdKey {
  cd_key: string
  is_primary: boolean
  first_seen_at: string
  last_seen_at: string
  attempt_count: number
  verified_count: number
  last_player_name: string | null
  banned: boolean
  ban_reason: string | null
  banned_at: string | null
  unbanned_at: string | null
}

export interface AccountAccessIp {
  ip_address: string
  first_seen_at: string
  last_seen_at: string
  attempt_count: number
  verified_count: number
}

export interface AccountAccessHistory {
  cd_keys: AccountAccessCdKey[]
  ip_addresses: AccountAccessIp[]
}
