import { useEffect, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  Accordion,
  AccordionDetails,
  AccordionSummary,
  Alert,
  Box,
  Button,
  Chip,
  CircularProgress,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  FormControlLabel,
  IconButton,
  MenuItem,
  Paper,
  Stack,
  Switch,
  Tab,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TablePagination,
  TableRow,
  Tabs,
  TextField,
  Tooltip,
  Typography,
} from '@mui/material'
import EditIcon from '@mui/icons-material/Edit'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import { api } from './api'
import type {
  AccountAccessHistory,
  AccountDetail,
  AccountPage,
  AccountStatus,
  CharacterDetail,
  CharacterStatus,
  Permission,
  Role,
  TradeskillDefinition,
  TradeskillRow,
} from './types'


const accountStatusLabels: Record<AccountStatus, string> = {
  active: 'Activa',
  blocked: 'Bloqueada',
}

const characterStatusLabels: Record<CharacterStatus, string> = {
  active: 'Activo',
  blocked: 'Bloqueado',
  deleted: 'Eliminado',
}

const cdKeyResetStatusLabels: Record<AccountDetail['cd_key_reset']['status'], string> = {
  none: 'Sin recaptura',
  awaiting_candidate: 'Esperando candidata',
  awaiting_confirmation: 'Pendiente de confirmación',
  confirmed: 'Confirmada',
  expired: 'Caducada',
}

const levelUnlockOptions = [
  { unlockLevel: 9, currentCap: 8 },
  { unlockLevel: 13, currentCap: 12 },
  { unlockLevel: 17, currentCap: 16 },
  { unlockLevel: 21, currentCap: 20 },
  { unlockLevel: 22, currentCap: 21 },
  { unlockLevel: 24, currentCap: 23 },
  { unlockLevel: 26, currentCap: 25 },
  { unlockLevel: 30, currentCap: 29 },
  { unlockLevel: 35, currentCap: 34 },
]


function optionalText(value: string): string | null {
  return value.trim() || null
}


function tradeskillLevel(skillXp: number, thresholds: number[]): number {
  for (let index = thresholds.length - 1; index >= 0; index -= 1) {
    if (skillXp >= thresholds[index]) return index + 1
  }
  return 1
}


function formatDateTime(value: string | null): string {
  return value ? new Date(value).toLocaleString('es-ES') : 'Todavía no registrado'
}


function abilityModifier(score: number | null): string {
  if (score === null) return '—'
  const modifier = Math.floor((score - 10) / 2)
  return modifier >= 0 ? `+${modifier}` : String(modifier)
}


type AbilityField =
  | 'strength_score'
  | 'dexterity_score'
  | 'constitution_score'
  | 'intelligence_score'
  | 'wisdom_score'
  | 'charisma_score'


const abilityLabels: Array<[AbilityField, string]> = [
  ['strength_score', 'Fuerza'],
  ['dexterity_score', 'Destreza'],
  ['constitution_score', 'Constitución'],
  ['intelligence_score', 'Inteligencia'],
  ['wisdom_score', 'Sabiduría'],
  ['charisma_score', 'Carisma'],
]


function CharacterCard({
  character,
  tradeskillDefinitions,
  permissions,
  isAdmin,
  saving,
  administrativeActionPending,
  onSave,
  onPurge,
}: {
  character: CharacterDetail
  tradeskillDefinitions: TradeskillDefinition[]
  permissions: Permission[]
  isAdmin: boolean
  saving: boolean
  administrativeActionPending: boolean
  onSave: (character: CharacterDetail) => void
  onPurge: (character: CharacterDetail) => void
}) {
  const [draft, setDraft] = useState<CharacterDetail>(structuredClone(character))
  useEffect(() => setDraft(structuredClone(character)), [character])
  const totalLevel = draft.classes.reduce((total, item) => total + item.class_level, 0)
  const canViewIdentity = permissions.includes('view_character_identity')
  const canEditIdentity = permissions.includes('edit_character_identity')
  const canViewTimestamps = permissions.includes('view_character_timestamps')
  const canViewAbilities = permissions.includes('view_character_abilities')
  const canViewClasses = permissions.includes('view_character_classes')
  const canViewUnlocks = permissions.includes('view_character_level_unlocks')
  const canEditUnlocks = permissions.includes('edit_character_level_unlocks')
  const canViewProfile = permissions.includes('view_character_profile')
  const canEditProfile = permissions.includes('edit_character_profile')
  const canViewTradeskills = permissions.includes('view_character_tradeskills')
  const canEditTradeskills = permissions.includes('edit_character_tradeskills')
  const isDeleted = draft.status === 'deleted'
  const canEditCharacter = canEditIdentity
    || canEditUnlocks
    || canEditProfile
    || canEditTradeskills

  const setField = <K extends keyof CharacterDetail>(field: K, value: CharacterDetail[K]) => {
    setDraft((current) => ({ ...current, [field]: value }))
  }
  const updateTradeskill = (index: number, changes: Partial<TradeskillRow>) => {
    setDraft((current) => ({
      ...current,
      tradeskills: current.tradeskills.map((item, itemIndex) => itemIndex === index
        ? { ...item, ...changes }
        : item),
    }))
  }
  return (
    <Paper variant="outlined" className="identity-card character-sheet">
      <Stack spacing={2.5}>
        <Box className="character-hero">
          <Box className="character-avatar" aria-hidden="true">
            {draft.display_name.trim().charAt(0).toLocaleUpperCase('es-ES') || '?'}
          </Box>
          <Box className="character-title">
            <Typography variant="h6">{draft.display_name}</Typography>
            <Box className="character-identifiers">
              <Typography variant="caption" color="text.secondary">
                ID {draft.character_id}
              </Typography>
              {canViewIdentity && <Typography variant="caption" className="character-uuid">
                UUID {draft.character_uuid ?? 'No registrado'}
              </Typography>}
            </Box>
          </Box>
          {canViewIdentity && draft.status && (
            <Chip label={characterStatusLabels[draft.status]} size="small" />
          )}
        </Box>
        {canViewTimestamps && <Box className="timeline-grid sheet-meta-grid">
          <Box className="timeline-item">
            <span className="timeline-label">Fecha de creación</span>
            <Typography variant="body2">{formatDateTime(draft.created_at)}</Typography>
          </Box>
          <Box className="timeline-item">
            <span className="timeline-label">Último acceso</span>
            <Typography variant="body2">{formatDateTime(draft.last_login_at)}</Typography>
          </Box>
        </Box>}
        {canViewIdentity && <Box className="rebuild-counter-grid">
          <Box className="rebuild-counter">
            <span className="timeline-label">Rehechos disponibles</span>
            <Typography className="rebuild-counter-value">
              {draft.rebuilds_available ?? '—'}
            </Typography>
          </Box>
          <Box className="rebuild-counter">
            <span className="timeline-label">Rehechos realizados</span>
            <Typography className="rebuild-counter-value">
              {draft.rebuilds_completed ?? '—'}
            </Typography>
          </Box>
        </Box>}
        {canViewAbilities && <Box className="subsection">
          <Typography variant="subtitle1" className="sheet-section-title">
            Características base
          </Typography>
          <Box className="ability-grid">
            {abilityLabels.map(([field, label]) => (
              <Box className="ability-stat" key={field}>
                <span className="stat-label">{label}</span>
                <span className="stat-value">{draft[field] ?? '—'}</span>
                <span className="stat-modifier">Mod. {abilityModifier(draft[field])}</span>
              </Box>
            ))}
          </Box>
          {abilityLabels.every(([field]) => draft[field] === null) && (
            <Typography variant="caption" color="text.secondary" mt={1} display="block">
              Se registrarán desde el motor en la próxima conexión del personaje.
            </Typography>
          )}
        </Box>}
        {(canViewClasses || canViewUnlocks) && <Box className="character-sheet-columns">
          {canViewClasses && <Box className="technical-section">
            <Box className="technical-section-heading">
              <Box>
                <Typography variant="subtitle1">Clases y niveles</Typography>
                <Typography variant="caption" color="text.secondary">
                  Datos registrados desde el personaje. Solo lectura.
                </Typography>
              </Box>
              <Typography variant="body2" className="technical-total">
                Nivel total <strong>{totalLevel}</strong>
              </Typography>
            </Box>
            <Box className="class-detail-grid">
              {draft.classes.length === 0 ? (
                <Typography variant="body2" color="text.secondary">Sin clases registradas.</Typography>
              ) : draft.classes.map((item) => (
                <Box className="class-detail-row" key={item.class_slot}>
                  <span className="class-slot">{item.class_slot}</span>
                  <Box className="class-name">
                    <Typography variant="body2">{item.display_name}</Typography>
                    <Typography variant="caption" color="text.secondary">
                      ID {item.class_id} · {item.code}
                    </Typography>
                  </Box>
                  <Box className="class-level">
                    <span>Nivel</span>
                    <strong>{item.class_level}</strong>
                  </Box>
                </Box>
              ))}
            </Box>
          </Box>}
          {canViewUnlocks && <Box className="technical-section">
            <Box className="technical-section-heading">
              <Box>
                <Typography variant="subtitle1">Cortes de nivel</Typography>
                <Typography variant="caption" color="text.secondary">
                  Concesiones permanentes aplicadas al volver a conectar.
                </Typography>
              </Box>
            </Box>
            <Box className="level-unlock-grid">
              {levelUnlockOptions.map(({ unlockLevel, currentCap }) => {
                const persisted = character.level_unlocks.includes(unlockLevel)
                const applied = character.applied_level_unlocks?.includes(unlockLevel) ?? false
                const selected = draft.level_unlocks.includes(unlockLevel)
                return (
                  <FormControlLabel
                    key={unlockLevel}
                    className="level-unlock-option"
                    disabled={isDeleted || persisted || !canEditUnlocks}
                    control={(
                      <Switch
                        checked={selected}
                        onChange={(event) => setField(
                          'level_unlocks',
                          event.target.checked
                            ? [...draft.level_unlocks, unlockLevel]
                              .sort((left, right) => left - right)
                            : draft.level_unlocks.filter((value) => value !== unlockLevel),
                        )}
                      />
                    )}
                    label={(
                      <Box className="level-unlock-label">
                        <Typography variant="body2">Nivel {unlockLevel}</Typography>
                        <Typography variant="caption" color="text.secondary">
                          Corte de nivel {currentCap}{applied
                            ? ' · Aplicado'
                            : persisted
                              ? ' · Pendiente de reconexión'
                              : ''}
                        </Typography>
                      </Box>
                    )}
                  />
                )
              })}
            </Box>
            <Typography variant="caption" color="text.secondary" className="level-unlock-note">
              Las concesiones guardadas no pueden retirarse desde el panel. Un
              corte pendiente se confirma cuando el personaje vuelve a conectar.
            </Typography>
          </Box>}
        </Box>}
        {canViewIdentity && <Box className="technical-section">
          <Box className="technical-section-heading">
            <Typography variant="subtitle1">Identidad y estado</Typography>
          </Box>
          <Box className="technical-section-body">
            <Box className="field-grid">
              <TextField
                label="Nombre visible administrativo"
                disabled={isDeleted || !canEditIdentity}
                value={draft.display_name_override ?? ''}
                onChange={(event) => setField('display_name_override', optionalText(event.target.value))}
              />
              <TextField
                select
                label="Estado de gestión"
                disabled={isDeleted || !canEditIdentity}
                value={draft.status ?? ''}
                onChange={(event) => setField('status', event.target.value as CharacterStatus)}
              >
                {Object.entries(characterStatusLabels).map(([value, label]) => (
                  <MenuItem key={value} value={value}>{label}</MenuItem>
                ))}
              </TextField>
              <TextField
                type="number"
                label="Añadir rehechos"
                disabled={isDeleted || !canEditIdentity}
                value={draft.rebuilds_added ?? 0}
                inputProps={{ min: 0, max: 10 }}
                helperText={draft.rebuilds_added
                  ? `Al guardar tendrá ${(character.rebuilds_available ?? 0) + draft.rebuilds_added}. Solo se pueden añadir, nunca quitar.`
                  : 'Solo se pueden añadir, nunca quitar.'}
                onChange={(event) => {
                  const value = Math.trunc(Number(event.target.value))
                  setField(
                    'rebuilds_added',
                    Number.isFinite(value) ? Math.min(10, Math.max(0, value)) : 0,
                  )
                }}
              />
              <TextField
                label="Cuenta propietaria"
                type="number"
                disabled={isDeleted || !canEditIdentity}
                value={draft.account_id}
                helperText="Cambiarla transfiere la relación persistente."
                onChange={(event) => setField('account_id', Number(event.target.value))}
              />
              {isDeleted && (
                <Alert severity="error" className="field-grid-wide">
                  Este personaje es una lápida histórica de solo lectura. Su BIC se elimina al
                  intentar conectarlo, pero sus datos permanecen en la base de datos.
                </Alert>
              )}
              {isDeleted && (
                <Box className="field-grid-wide">
                  <Typography variant="body2">
                    Eliminado: {formatDateTime(draft.deleted_at)}
                  </Typography>
                  <Typography variant="body2">
                    El nombre puede reutilizarse, pero este UUID permanece eliminado.
                  </Typography>
                </Box>
              )}
            </Box>
          </Box>
        </Box>}
        {canViewProfile && <Box className="technical-section">
          <Box className="technical-section-heading">
            <Typography variant="subtitle1">Perfil técnico</Typography>
          </Box>
          <Stack spacing={2} className="technical-section-body">
            <Box className="field-grid">
              <TextField
                label="Raza (ID racialtypes.2da)"
                type="number"
                disabled={isDeleted || !canEditProfile}
                value={draft.race_id ?? ''}
                onChange={(event) => setField('race_id', event.target.value === '' ? null : Number(event.target.value))}
              />
              <TextField
                label="Subraza"
                disabled={isDeleted || !canEditProfile}
                value={draft.subrace ?? ''}
                onChange={(event) => setField('subrace', optionalText(event.target.value))}
              />
              <TextField
                label="Género (ID del motor)"
                type="number"
                disabled={isDeleted || !canEditProfile}
                value={draft.gender_id ?? ''}
                onChange={(event) => setField('gender_id', event.target.value === '' ? null : Number(event.target.value))}
              />
              <TextField
                label="Retrato (resref)"
                disabled={isDeleted || !canEditProfile}
                value={draft.portrait_resref ?? ''}
                onChange={(event) => setField('portrait_resref', optionalText(event.target.value))}
              />
              <TextField
                label="Deidad"
                disabled={isDeleted || !canEditProfile}
                value={draft.deity ?? ''}
                onChange={(event) => setField('deity', optionalText(event.target.value))}
              />
            </Box>
            <TextField
              label="Notas administrativas"
              disabled={isDeleted || !canEditProfile}
              multiline
              minRows={2}
              fullWidth
              value={draft.admin_notes ?? ''}
              onChange={(event) => setField('admin_notes', optionalText(event.target.value))}
            />
          </Stack>
        </Box>}
        {canViewTradeskills && <Box className="technical-section">
          <Box className="technical-section-heading">
            <Box>
              <Typography variant="subtitle1">Oficios</Typography>
              <Typography variant="caption" color="text.secondary">
                El nivel se deriva de la experiencia con la misma curva que utiliza el módulo.
              </Typography>
            </Box>
          </Box>
          <Stack spacing={1.5} className="technical-section-body tradeskill-list">
            {draft.tradeskills.map((item, index) => {
              const definition = tradeskillDefinitions.find(
                (candidate) => candidate.skill_name === item.skill_name,
              )
              const thresholds = definition?.level_thresholds ?? []
              const level = tradeskillLevel(item.skill_xp, thresholds)
              return (
                <Paper key={item.skill_name} variant="outlined" className="tradeskill-row">
                  <Stack direction={{ xs: 'column', md: 'row' }} spacing={2}>
                    <TextField
                      label="Oficio"
                      value={definition?.display_name ?? item.display_name}
                      disabled
                      sx={{ flex: 1 }}
                    />
                    <TextField
                      select
                      label="Nivel"
                      disabled={isDeleted || !canEditTradeskills}
                      value={level}
                      sx={{ width: { xs: '100%', md: 140 } }}
                      onChange={(event) => {
                        const nextLevel = Number(event.target.value)
                        const minimumXp = thresholds[nextLevel - 1]
                        if (minimumXp !== undefined) {
                          updateTradeskill(index, { skill_level: nextLevel, skill_xp: minimumXp })
                        }
                      }}
                    >
                      {thresholds.map((_, levelIndex) => (
                        <MenuItem key={levelIndex + 1} value={levelIndex + 1}>
                          {levelIndex + 1}
                        </MenuItem>
                      ))}
                    </TextField>
                    <TextField
                      label="Experiencia"
                      type="number"
                      disabled={isDeleted || !canEditTradeskills}
                      value={item.skill_xp}
                      slotProps={{ htmlInput: { min: 0, max: 2147483647 } }}
                      onChange={(event) => updateTradeskill(index, {
                        skill_xp: Math.max(0, Number(event.target.value)),
                      })}
                    />
                  </Stack>
                </Paper>
              )
            })}
          </Stack>
        </Box>}
        {canEditCharacter && !isDeleted && (
          <Stack direction="row" justifyContent="flex-end">
            <Button variant="contained" disabled={saving} onClick={() => onSave(draft)}>
              Guardar personaje
            </Button>
          </Stack>
        )}
        {isAdmin && isDeleted && (
          <Stack direction={{ xs: 'column', sm: 'row' }} spacing={1} justifyContent="flex-end">
            <Button
              color="error"
              variant="contained"
              disabled={administrativeActionPending}
              onClick={() => onPurge(character)}
            >
              Eliminar datos definitivamente
            </Button>
          </Stack>
        )}
      </Stack>
    </Paper>
  )
}


function AccountEditor({ accountId, open, permissions, role, onClose }: {
  accountId: number | null
  open: boolean
  permissions: Permission[]
  role: Role
  onClose: () => void
}) {
  const client = useQueryClient()
  const [draft, setDraft] = useState<AccountDetail | null>(null)
  const [selectedCharacterId, setSelectedCharacterId] = useState<number | null>(null)
  const [confirmingCdKeyReset, setConfirmingCdKeyReset] = useState(false)
  const [cdKeyAction, setCdKeyAction] = useState<{ cdKey: string, banned: boolean } | null>(null)
  const [primaryCdKeyAction, setPrimaryCdKeyAction] = useState<string | null>(null)
  const [purgeAction, setPurgeAction] = useState<CharacterDetail | null>(null)
  const [purgeConfirmation, setPurgeConfirmation] = useState('')
  const [banReason, setBanReason] = useState('')
  const canEditAccounts = permissions.includes('edit_accounts')
  const canActivateCdKeys = permissions.includes('activate_cd_keys')
  const canViewCharacters = permissions.includes('view_characters')
  const canViewTradeskills = permissions.includes('view_character_tradeskills')
  const canEditCharacter = permissions.some((permission) => permission.startsWith(
    'edit_character_',
  ))
  const isAdmin = role === 'admin'
  const account = useQuery({
    queryKey: ['identity-account', accountId],
    queryFn: () => api<AccountDetail>(`/admin/identity/accounts/${accountId}`),
    enabled: open && accountId !== null,
  })
  const tradeskillDefinitions = useQuery({
    queryKey: ['identity-tradeskill-definitions'],
    queryFn: () => api<TradeskillDefinition[]>('/admin/identity/tradeskills'),
    enabled: open && canViewCharacters && canViewTradeskills,
  })
  const accessHistory = useQuery({
    queryKey: ['identity-account-access', accountId],
    queryFn: () => api<AccountAccessHistory>(
      `/admin/identity/accounts/${accountId}/access-history`,
    ),
    enabled: open && accountId !== null && isAdmin,
  })
  useEffect(() => {
    const next = open && account.data ? structuredClone(account.data) : null
    setDraft(next)
    setSelectedCharacterId((current) => {
      if (!next) return null
      if (next.characters.some((item) => item.character_id === current)) return current
      return next.characters[0]?.character_id ?? null
    })
  }, [open, account.data])

  const acceptAccountUpdate = (updated: AccountDetail) => {
    setDraft(updated)
    client.setQueryData(['identity-account', updated.account_id], updated)
    client.invalidateQueries({ queryKey: ['identity-accounts'] })
  }

  const saveAccount = useMutation({
    mutationFn: (value: AccountDetail) => api<AccountDetail>(
      `/admin/identity/accounts/${value.account_id}`,
      {
        method: 'PATCH',
        body: JSON.stringify({
          updated_at: value.updated_at,
          display_name_override: value.display_name_override,
          status: value.status,
          admin_notes: value.admin_notes,
        }),
      },
    ),
    onSuccess: acceptAccountUpdate,
  })
  const requestCdKeyReset = useMutation({
    mutationFn: (account: AccountDetail) => api<AccountDetail>(
      `/admin/identity/accounts/${account.account_id}/cd-key-reset`,
      { method: 'POST' },
    ),
    onSuccess: acceptAccountUpdate,
  })
  const cancelCdKeyReset = useMutation({
    mutationFn: (account: AccountDetail) => api<AccountDetail>(
      `/admin/identity/accounts/${account.account_id}/cd-key-reset`,
      { method: 'DELETE' },
    ),
    onSuccess: acceptAccountUpdate,
  })
  const confirmCdKeyReset = useMutation({
    mutationFn: (account: AccountDetail) => api<AccountDetail>(
      `/admin/identity/accounts/${account.account_id}/cd-key-reset/confirm`,
      { method: 'POST' },
    ),
    onSuccess: (updated) => {
      setConfirmingCdKeyReset(false)
      acceptAccountUpdate(updated)
    },
  })
  const saveCharacter = useMutation({
    mutationFn: (value: CharacterDetail) => api<CharacterDetail>(
      `/admin/identity/characters/${value.character_id}`,
      {
        method: 'PATCH',
        body: JSON.stringify({
          updated_at: value.updated_at,
          ...(permissions.includes('edit_character_identity') ? {
            account_id: value.account_id,
            display_name_override: value.display_name_override,
            status: value.status,
            ...(value.rebuilds_added ? { rebuilds_added: value.rebuilds_added } : {}),
          } : {}),
          ...(permissions.includes('edit_character_profile') ? {
            race_id: value.race_id,
            subrace: value.subrace,
            gender_id: value.gender_id,
            portrait_resref: value.portrait_resref,
            deity: value.deity,
            admin_notes: value.admin_notes,
          } : {}),
          ...(permissions.includes('edit_character_level_unlocks') ? {
            level_unlocks: value.level_unlocks,
          } : {}),
          ...(permissions.includes('edit_character_tradeskills') ? {
            tradeskills: value.tradeskills.map(({
              display_name: _, skill_level: __, ...item
            }) => item),
          } : {}),
        }),
      },
    ),
    onSuccess: () => {
      client.invalidateQueries({ queryKey: ['identity-account', accountId] })
      client.invalidateQueries({ queryKey: ['identity-accounts'] })
    },
  })
  const purgeCharacter = useMutation({
    mutationFn: (value: CharacterDetail) => api<AccountDetail>(
      `/admin/identity/characters/${value.character_id}/purge`,
      {
        method: 'POST',
        body: JSON.stringify({
          updated_at: value.updated_at,
          confirmation: purgeConfirmation,
        }),
      },
    ),
    onSuccess: (updated) => {
      acceptAccountUpdate(updated)
      setSelectedCharacterId(updated.characters[0]?.character_id ?? null)
      setPurgeAction(null)
      setPurgeConfirmation('')
      client.invalidateQueries({ queryKey: ['audit'] })
    },
  })
  const updateCdKeyBan = useMutation({
    mutationFn: ({ cdKey, banned, reason }: {
      cdKey: string
      banned: boolean
      reason: string | null
    }) => api<AccountAccessHistory>(
      `/admin/identity/accounts/${accountId}/cd-keys/${encodeURIComponent(cdKey)}/ban`,
      banned
        ? { method: 'DELETE' }
        : { method: 'POST', body: JSON.stringify({ reason }) },
    ),
    onSuccess: (updated) => {
      client.setQueryData(['identity-account-access', accountId], updated)
      client.invalidateQueries({ queryKey: ['identity-accounts'] })
      setCdKeyAction(null)
      setBanReason('')
    },
  })
  const setPrimaryCdKey = useMutation({
    mutationFn: (cdKey: string) => api<AccountDetail>(
      `/admin/identity/accounts/${accountId}/cd-keys/${encodeURIComponent(cdKey)}/primary`,
      { method: 'POST' },
    ),
    onSuccess: (updated) => {
      acceptAccountUpdate(updated)
      client.invalidateQueries({ queryKey: ['identity-account-access', accountId] })
      setPrimaryCdKeyAction(null)
    },
  })
  const cdKeyResetBusy = requestCdKeyReset.isPending
    || cancelCdKeyReset.isPending
    || confirmCdKeyReset.isPending

  return (
    <>
    <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
      <DialogTitle>
        {canEditAccounts ? 'Gestionar' : 'Consultar'} cuenta {draft ? `#${draft.account_id}` : ''}
      </DialogTitle>
      <DialogContent dividers>
        {account.isLoading ? <CircularProgress /> : account.error ? (
          <Alert severity="error">{account.error.message}</Alert>
        ) : !draft ? (
          <Alert severity="warning">No se pudo cargar la cuenta seleccionada.</Alert>
        ) : (
          <Stack spacing={3}>
            {canViewCharacters && <Alert severity="info">
              La ficha muestra únicamente las secciones autorizadas para este perfil. Las clases,
              niveles y características vienen del juego y son de solo lectura.
            </Alert>}
            {!canEditAccounts && !canEditCharacter && (
              <Alert severity="info">
                Este perfil dispone de acceso de consulta; no puede modificar cuentas ni personajes.
              </Alert>
            )}
            {(tradeskillDefinitions.error
              || saveAccount.error
              || saveCharacter.error
              || requestCdKeyReset.error
              || cancelCdKeyReset.error
              || confirmCdKeyReset.error
              || accessHistory.error
              || updateCdKeyBan.error
              || setPrimaryCdKey.error) && (
              <Alert severity="error">
                {(tradeskillDefinitions.error
                  || saveAccount.error
                  || saveCharacter.error
                  || requestCdKeyReset.error
                  || cancelCdKeyReset.error
                  || confirmCdKeyReset.error
                  || accessHistory.error
                  || updateCdKeyBan.error
                  || setPrimaryCdKey.error)?.message}
              </Alert>
            )}
            {saveAccount.isSuccess && <Alert severity="success">Cuenta guardada.</Alert>}
            {saveCharacter.isSuccess && <Alert severity="success">Personaje guardado.</Alert>}
            <Paper variant="outlined" className="identity-card">
              <Stack spacing={2}>
                <Typography variant="h6">Datos de la cuenta</Typography>
                <Box className="field-grid">
                  <TextField label="Nombre observado" value={draft.observed_name ?? ''} disabled />
                  <TextField label="CD key" value={draft.cd_key ?? draft.cd_key_hint} disabled />
                  <TextField
                    label="Nombre visible administrativo"
                    disabled={!canEditAccounts}
                    value={draft.display_name_override ?? ''}
                    onChange={(event) => setDraft({
                      ...draft,
                      display_name_override: optionalText(event.target.value),
                    })}
                  />
                  <TextField
                    select
                    label="Estado de gestión"
                    disabled={!canEditAccounts}
                    value={draft.status}
                    onChange={(event) => setDraft({
                      ...draft,
                      status: event.target.value as AccountStatus,
                    })}
                  >
                    {Object.entries(accountStatusLabels).map(([value, label]) => (
                      <MenuItem key={value} value={value}>{label}</MenuItem>
                    ))}
                  </TextField>
                  <TextField
                    label="Primera conexión"
                    value={new Date(draft.first_seen).toLocaleString('es-ES')}
                    disabled
                  />
                  <TextField
                    label="Última conexión"
                    value={new Date(draft.last_seen).toLocaleString('es-ES')}
                    disabled
                  />
                </Box>
                {canActivateCdKeys && <Box className="technical-section cd-key-reset-section">
                  <Box className="technical-section-heading">
                    <Box>
                      <Typography variant="subtitle1">Recaptura de CD key</Typography>
                      <Typography variant="caption" color="text.secondary">
                        La clave nunca se escribe manualmente desde el panel.
                      </Typography>
                    </Box>
                    <Chip
                      size="small"
                      label={cdKeyResetStatusLabels[draft.cd_key_reset.status]}
                    />
                  </Box>
                  <Stack spacing={1.5} className="cd-key-reset-body">
                    {draft.cd_key_reset.status === 'none' && (
                      <Alert severity="info">
                        Inicia una ventana de 24 horas. El siguiente intento con una clave distinta
                        será expulsado igualmente y quedará registrado como candidata enmascarada.
                      </Alert>
                    )}
                    {draft.cd_key_reset.status === 'awaiting_candidate' && (
                      <Alert severity="warning">
                        Esperando un intento con el personaje registrado y la nueva CD key. El
                        acceso seguirá denegado hasta la confirmación administrativa.
                      </Alert>
                    )}
                    {draft.cd_key_reset.status === 'awaiting_confirmation' && (
                      <Alert severity="warning">
                        Candidata capturada: <code>{draft.cd_key_reset.candidate_hint}</code>.
                        Verifica externamente al jugador antes de confirmar el cambio.
                      </Alert>
                    )}
                    {draft.cd_key_reset.status === 'confirmed' && (
                      <Alert severity="success">
                        Cambio confirmado. Cada personaje sincronizará la clave de su contenedor
                        legado después de que el sistema de identidad valide su próxima conexión.
                      </Alert>
                    )}
                    {draft.cd_key_reset.status === 'expired' && (
                      <Alert severity="error">
                        La ventana caducó sin confirmación. Reiníciala para aceptar otra candidata.
                      </Alert>
                    )}
                    {draft.cd_key_reset.expires_at
                      && !['none', 'confirmed'].includes(draft.cd_key_reset.status) && (
                      <Typography variant="caption" color="text.secondary">
                        Caduca: {formatDateTime(draft.cd_key_reset.expires_at)}
                      </Typography>
                    )}
                    <Stack direction={{ xs: 'column', sm: 'row' }} spacing={1}>
                      {['none', 'confirmed', 'expired'].includes(draft.cd_key_reset.status) && (
                        <Button
                          variant="outlined"
                          disabled={cdKeyResetBusy}
                          onClick={() => requestCdKeyReset.mutate(draft)}
                        >
                          {draft.cd_key_reset.status === 'none'
                            ? 'Iniciar recaptura'
                            : 'Iniciar nueva recaptura'}
                        </Button>
                      )}
                      {['awaiting_candidate', 'awaiting_confirmation', 'expired'].includes(
                        draft.cd_key_reset.status,
                      ) && (
                        <Button
                          color="inherit"
                          disabled={cdKeyResetBusy}
                          onClick={() => cancelCdKeyReset.mutate(draft)}
                        >
                          Cancelar recaptura
                        </Button>
                      )}
                      {draft.cd_key_reset.status === 'awaiting_confirmation' && (
                        <Button
                          color="warning"
                          variant="contained"
                          disabled={cdKeyResetBusy}
                          onClick={() => setConfirmingCdKeyReset(true)}
                        >
                          Confirmar candidata
                        </Button>
                      )}
                    </Stack>
                  </Stack>
                </Box>}
                <TextField
                  label="Notas administrativas"
                  disabled={!canEditAccounts}
                  multiline
                  minRows={2}
                  value={draft.admin_notes ?? ''}
                  onChange={(event) => setDraft({
                    ...draft,
                    admin_notes: optionalText(event.target.value),
                  })}
                />
                {canEditAccounts && (
                  <Stack direction="row" justifyContent="flex-end">
                    <Button
                      variant="contained"
                      disabled={saveAccount.isPending}
                      onClick={() => saveAccount.mutate(draft)}
                    >
                      Guardar cuenta
                    </Button>
                  </Stack>
                )}
              </Stack>
            </Paper>
            {isAdmin && (
              <Accordion variant="outlined">
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                  <Box>
                    <Typography variant="h6">Historial de acceso</Typography>
                    <Typography variant="caption" color="text.secondary">
                      CD keys e IP observadas al presentar nombres protegidos de esta cuenta.
                    </Typography>
                  </Box>
                </AccordionSummary>
                <AccordionDetails>
                  {accessHistory.isLoading ? <CircularProgress size={24} /> : (
                    <Stack spacing={3}>
                      <Box>
                        <Typography variant="subtitle1" gutterBottom>CD keys</Typography>
                        {accessHistory.data?.cd_keys.length === 0 ? (
                          <Alert severity="info">Todavía no hay claves registradas.</Alert>
                        ) : (
                          <TableContainer component={Paper} variant="outlined">
                            <Table size="small">
                              <TableHead><TableRow>
                                <TableCell>CD key</TableCell>
                                <TableCell>Último nombre</TableCell>
                                <TableCell>Estado</TableCell>
                                <TableCell>Intentos</TableCell>
                                <TableCell>Verificados</TableCell>
                                <TableCell>Primera</TableCell>
                                <TableCell>Última</TableCell>
                                <TableCell />
                              </TableRow></TableHead>
                              <TableBody>{accessHistory.data?.cd_keys.map((item) => (
                                <TableRow key={item.cd_key}>
                                  <TableCell><code>{item.cd_key}</code></TableCell>
                                  <TableCell>{item.last_player_name ?? '—'}</TableCell>
                                  <TableCell>
                                    <Stack spacing={0.5} alignItems="flex-start">
                                      {item.is_primary && (
                                        <Chip size="small" color="success" label="Principal" />
                                      )}
                                      <Chip
                                        size="small"
                                        color={item.banned ? 'error' : 'default'}
                                        label={item.banned ? 'Baneada globalmente' : 'No baneada'}
                                      />
                                      {item.ban_reason && (
                                        <Typography variant="caption">{item.ban_reason}</Typography>
                                      )}
                                    </Stack>
                                  </TableCell>
                                  <TableCell>{item.attempt_count}</TableCell>
                                  <TableCell>{item.verified_count}</TableCell>
                                  <TableCell>{formatDateTime(item.first_seen_at)}</TableCell>
                                  <TableCell>{formatDateTime(item.last_seen_at)}</TableCell>
                                  <TableCell>
                                    <Stack spacing={0.5} alignItems="flex-start">
                                      {canActivateCdKeys && !item.is_primary && (
                                        <Button
                                          size="small"
                                          disabled={item.banned || setPrimaryCdKey.isPending}
                                          onClick={() => setPrimaryCdKeyAction(item.cd_key)}
                                        >
                                          Asignar como principal
                                        </Button>
                                      )}
                                      <Button
                                        size="small"
                                        color={item.banned ? 'inherit' : 'error'}
                                        disabled={updateCdKeyBan.isPending}
                                        onClick={() => {
                                          setBanReason(item.ban_reason ?? '')
                                          setCdKeyAction({ cdKey: item.cd_key, banned: item.banned })
                                        }}
                                      >
                                        {item.banned ? 'Desbanear' : 'Banear'}
                                      </Button>
                                    </Stack>
                                  </TableCell>
                                </TableRow>
                              ))}</TableBody>
                            </Table>
                          </TableContainer>
                        )}
                      </Box>
                      <Box>
                        <Typography variant="subtitle1" gutterBottom>Direcciones IP</Typography>
                        <Typography variant="caption" color="text.secondary" display="block" mb={1}>
                          Dirección observada por el proceso del servidor; una red NAT puede mostrar
                          la pasarela en lugar de la IP pública del jugador.
                        </Typography>
                        {accessHistory.data?.ip_addresses.length === 0 ? (
                          <Alert severity="info">Todavía no hay direcciones registradas.</Alert>
                        ) : (
                          <TableContainer component={Paper} variant="outlined">
                            <Table size="small">
                              <TableHead><TableRow>
                                <TableCell>Dirección IP</TableCell>
                                <TableCell>Intentos</TableCell>
                                <TableCell>Primera</TableCell>
                                <TableCell>Última</TableCell>
                              </TableRow></TableHead>
                              <TableBody>{accessHistory.data?.ip_addresses.map((item) => (
                                <TableRow key={item.ip_address}>
                                  <TableCell><code>{item.ip_address}</code></TableCell>
                                  <TableCell>{item.attempt_count}</TableCell>
                                  <TableCell>{formatDateTime(item.first_seen_at)}</TableCell>
                                  <TableCell>{formatDateTime(item.last_seen_at)}</TableCell>
                                </TableRow>
                              ))}</TableBody>
                            </Table>
                          </TableContainer>
                        )}
                      </Box>
                    </Stack>
                  )}
                </AccordionDetails>
              </Accordion>
            )}
            {canViewCharacters && <>
              <Typography variant="h5">Personajes ({draft.characters.length})</Typography>
              {draft.characters.length === 0 ? (
                <Alert severity="info">Esta cuenta todavía no tiene personajes.</Alert>
              ) : (
                <Tabs
                  value={selectedCharacterId}
                  onChange={(_, value: number) => setSelectedCharacterId(value)}
                  variant="scrollable"
                  scrollButtons="auto"
                  aria-label="Seleccionar personaje"
                >
                  {draft.characters.map((character) => (
                    <Tab
                      key={character.character_id}
                      value={character.character_id}
                      label={character.display_name}
                    />
                  ))}
                </Tabs>
              )}
              {draft.characters.filter(
                (character) => character.character_id === selectedCharacterId,
              ).map((character) => (
                <CharacterCard
                  key={character.character_id}
                  character={character}
                  tradeskillDefinitions={tradeskillDefinitions.data ?? []}
                  permissions={permissions}
                  isAdmin={isAdmin}
                  saving={saveCharacter.isPending}
                  administrativeActionPending={purgeCharacter.isPending}
                  onSave={(value) => saveCharacter.mutate(value)}
                  onPurge={setPurgeAction}
                />
              ))}
            </>}
          </Stack>
        )}
      </DialogContent>
      <DialogActions><Button onClick={onClose}>Cerrar</Button></DialogActions>
    </Dialog>
    <Dialog
      open={purgeAction !== null}
      onClose={() => {
        setPurgeAction(null)
        setPurgeConfirmation('')
      }}
      maxWidth="sm"
      fullWidth
    >
      <DialogTitle>Eliminar datos definitivamente</DialogTitle>
      <DialogContent>
        <DialogContentText>
          Esta acción elimina la lápida y todos los datos propios del personaje. El historial
          compartido de IP y CD keys de la cuenta no se elimina. Escribe ELIMINAR para confirmar.
        </DialogContentText>
        <TextField
          autoFocus
          fullWidth
          margin="normal"
          label="Confirmación"
          value={purgeConfirmation}
          onChange={(event) => setPurgeConfirmation(event.target.value)}
        />
        {purgeCharacter.error && (
          <Alert severity="error" sx={{ mt: 2 }}>{purgeCharacter.error.message}</Alert>
        )}
      </DialogContent>
      <DialogActions>
        <Button onClick={() => {
          setPurgeAction(null)
          setPurgeConfirmation('')
        }}>
          Cancelar
        </Button>
        <Button
          color="error"
          variant="contained"
          disabled={purgeConfirmation !== 'ELIMINAR' || !purgeAction || purgeCharacter.isPending}
          onClick={() => purgeAction && purgeCharacter.mutate(purgeAction)}
        >
          Eliminar definitivamente
        </Button>
      </DialogActions>
    </Dialog>
    <Dialog
      open={confirmingCdKeyReset}
      onClose={() => setConfirmingCdKeyReset(false)}
      maxWidth="xs"
      fullWidth
    >
      <DialogTitle>Confirmar cambio de CD key</DialogTitle>
      <DialogContent>
        <DialogContentText>
          Se sustituirá la clave activa de la cuenta #{draft?.account_id} por la candidata
          {draft?.cd_key_reset.candidate_hint
            ? ` ${draft.cd_key_reset.candidate_hint}`
            : ''}. El jugador seguirá necesitando el UUID correcto de uno de sus personajes.
        </DialogContentText>
        {confirmCdKeyReset.error && (
          <Alert severity="error" sx={{ mt: 2 }}>
            {confirmCdKeyReset.error.message}
          </Alert>
        )}
      </DialogContent>
      <DialogActions>
        <Button onClick={() => setConfirmingCdKeyReset(false)}>Volver</Button>
        <Button
          color="warning"
          variant="contained"
          disabled={!draft || confirmCdKeyReset.isPending}
          onClick={() => draft && confirmCdKeyReset.mutate(draft)}
        >
          Confirmar cambio
        </Button>
      </DialogActions>
    </Dialog>
    <Dialog
      open={primaryCdKeyAction !== null}
      onClose={() => setPrimaryCdKeyAction(null)}
      maxWidth="sm"
      fullWidth
    >
      <DialogTitle>Asignar CD key principal</DialogTitle>
      <DialogContent>
        <DialogContentText>
          La clave {primaryCdKeyAction ?? ''} pasará a ser la principal de la cuenta
          #{draft?.account_id}. La clave anterior dejará de validar sus personajes, pero seguirá
          guardada en el historial para poder restaurarla. Confirma antes la identidad del jugador
          por un canal de confianza.
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={() => setPrimaryCdKeyAction(null)}>Cancelar</Button>
        <Button
          color="warning"
          variant="contained"
          disabled={!primaryCdKeyAction || setPrimaryCdKey.isPending}
          onClick={() => primaryCdKeyAction && setPrimaryCdKey.mutate(primaryCdKeyAction)}
        >
          Confirmar asignación
        </Button>
      </DialogActions>
    </Dialog>
    <Dialog
      open={cdKeyAction !== null}
      onClose={() => setCdKeyAction(null)}
      maxWidth="sm"
      fullWidth
    >
      <DialogTitle>
        {cdKeyAction?.banned ? 'Desbanear CD key' : 'Banear CD key globalmente'}
      </DialogTitle>
      <DialogContent>
        <DialogContentText>
          {cdKeyAction?.banned
            ? `La clave ${cdKeyAction.cdKey} podrá volver a iniciar conexiones.`
            : `La clave ${cdKeyAction?.cdKey ?? ''} será rechazada antes de recibir la lista de personajes, use el nombre de cuenta que use.`}
        </DialogContentText>
        {!cdKeyAction?.banned && (
          <TextField
            autoFocus
            fullWidth
            multiline
            minRows={2}
            margin="normal"
            label="Motivo administrativo"
            value={banReason}
            onChange={(event) => setBanReason(event.target.value)}
            slotProps={{ htmlInput: { maxLength: 500 } }}
          />
        )}
      </DialogContent>
      <DialogActions>
        <Button onClick={() => setCdKeyAction(null)}>Cancelar</Button>
        <Button
          color={cdKeyAction?.banned ? 'inherit' : 'error'}
          variant="contained"
          disabled={!cdKeyAction || updateCdKeyBan.isPending}
          onClick={() => cdKeyAction && updateCdKeyBan.mutate({
            cdKey: cdKeyAction.cdKey,
            banned: cdKeyAction.banned,
            reason: optionalText(banReason),
          })}
        >
          {cdKeyAction?.banned ? 'Desbanear' : 'Confirmar baneo'}
        </Button>
      </DialogActions>
    </Dialog>
    </>
  )
}


export function Accounts({ permissions, role }: { permissions: Permission[], role: Role }) {
  const [search, setSearch] = useState('')
  const [selected, setSelected] = useState<number | null>(null)
  const [page, setPage] = useState(0)
  const [rowsPerPage, setRowsPerPage] = useState(50)
  const canEditAccounts = permissions.includes('edit_accounts')
  const canEditCharacterIdentity = permissions.includes('edit_character_identity')
  const canViewCharacters = permissions.includes('view_characters')
  const isAdmin = role === 'admin'
  useEffect(() => setPage(0), [search])
  const accounts = useQuery({
    queryKey: ['identity-accounts', search, page, rowsPerPage],
    queryFn: () => api<AccountPage>(
      `/admin/identity/accounts?limit=${rowsPerPage}&offset=${page * rowsPerPage}`
      + `&search=${encodeURIComponent(search)}`,
    ),
  })

  return (
    <Stack spacing={2}>
      <Box className="section-heading">
        <Box>
          <Typography variant="h4">Cuentas y personajes</Typography>
          <Typography color="text.secondary">{accounts.data?.total ?? 0} cuentas encontradas</Typography>
        </Box>
        <TextField
          size="small"
          label={isAdmin
            ? 'Buscar cuenta, personaje, IP, CD key o ID'
            : canViewCharacters ? 'Buscar cuenta, personaje o ID' : 'Buscar cuenta o ID'}
          value={search}
          onChange={(event) => setSearch(event.target.value)}
        />
      </Box>
      {canEditCharacterIdentity && <Alert severity="warning">
        Una cuenta Bloqueada rechaza su próxima conexión antes de mostrar personajes cuando el
        nombre está protegido. Un personaje Bloqueado se expulsa después de seleccionarlo. Ninguno
        de los dos estados desconecta por sí solo una sesión que ya estaba dentro. El estado
        Eliminado borra definitivamente el personaje en su próxima conexión, después de un aviso.
      </Alert>}
      {accounts.error && <Alert severity="error">{accounts.error.message}</Alert>}
      <TableContainer component={Paper}>
        <Table stickyHeader size="small">
          <TableHead><TableRow>
            <TableCell>Estado</TableCell><TableCell>ID</TableCell><TableCell>Jugador</TableCell>
            <TableCell>CD key</TableCell>
            {canViewCharacters && <TableCell>Personajes</TableCell>}
            <TableCell>Primera conexión</TableCell><TableCell>Última conexión</TableCell><TableCell />
          </TableRow></TableHead>
          <TableBody>{accounts.data?.items.map((row) => <TableRow hover key={row.account_id}>
            <TableCell><Chip size="small" label={accountStatusLabels[row.status]} /></TableCell>
            <TableCell>{row.account_id}</TableCell><TableCell>{row.display_name}</TableCell>
            <TableCell><code>{row.cd_key ?? row.cd_key_hint}</code></TableCell>
            {canViewCharacters && <TableCell>{row.character_count}</TableCell>}
            <TableCell>{new Date(row.first_seen).toLocaleString('es-ES')}</TableCell>
            <TableCell>{new Date(row.last_seen).toLocaleString('es-ES')}</TableCell>
            <TableCell>
              <Tooltip title={canEditAccounts ? 'Gestionar cuenta' : 'Consultar cuenta'}>
                <IconButton onClick={() => setSelected(row.account_id)}><EditIcon /></IconButton>
              </Tooltip>
            </TableCell>
          </TableRow>)}</TableBody>
        </Table>
        <TablePagination
          component="div"
          count={accounts.data?.total ?? 0}
          page={page}
          rowsPerPage={rowsPerPage}
          rowsPerPageOptions={[25, 50, 100, 250]}
          labelRowsPerPage="Cuentas por página"
          labelDisplayedRows={({ from, to, count }) => `${from}–${to} de ${count}`}
          getItemAriaLabel={(type) => ({
            first: 'Ir a la primera página', last: 'Ir a la última página',
            next: 'Ir a la página siguiente', previous: 'Ir a la página anterior',
          })[type]}
          onPageChange={(_, nextPage) => setPage(nextPage)}
          onRowsPerPageChange={(event) => {
            setRowsPerPage(Number(event.target.value))
            setPage(0)
          }}
        />
      </TableContainer>
      <AccountEditor
        accountId={selected}
        open={selected !== null}
        permissions={permissions}
        role={role}
        onClose={() => setSelected(null)}
      />
    </Stack>
  )
}
