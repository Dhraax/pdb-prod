import { FormEvent, useEffect, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  Alert,
  AppBar,
  Box,
  Button,
  Chip,
  CircularProgress,
  Container,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  FormControlLabel,
  FormGroup,
  IconButton,
  MenuItem,
  Paper,
  Stack,
  Switch,
  Tab,
  Tabs,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TablePagination,
  TextField,
  Toolbar,
  Tooltip,
  Typography,
} from '@mui/material'
import LogoutIcon from '@mui/icons-material/Logout'
import SecurityIcon from '@mui/icons-material/Security'
import EditIcon from '@mui/icons-material/Edit'
import AddIcon from '@mui/icons-material/Add'
import DeleteIcon from '@mui/icons-material/Delete'
import ArrowDownwardIcon from '@mui/icons-material/ArrowDownward'
import ArrowUpwardIcon from '@mui/icons-material/ArrowUpward'
import { Accounts } from './Accounts'
import { DmAccess } from './DmAccess'
import { api } from './api'
import {
  permissionGroups,
  permissionLabels,
  rolePermissionPresets,
  togglePermission,
} from './permissions'
import type {
  ArcaneDetail,
  ArcanePage,
  ArcaneReferences,
  ArcaneStepRow,
  AuditEntry,
  AuditPage,
  MfaChallenge,
  MfaConfirmation,
  MfaSetup,
  PropertyBinding,
  PropertyDefinition,
  PropertyDefinitions,
  PropertyRow,
  Permission,
  RecipeDetail,
  RecipePage,
  References,
  Role,
  Session,
  User,
} from './types'


const roleLabels: Record<Role, string> = {
  admin: 'Administrador',
  technical: 'Equipo técnico',
  dungeon_master: 'Dungeon Master',
  editor: 'Editor',
  collaborator: 'Colaborador',
}

const auditDomainLabels: Record<AuditEntry['domain'], string> = {
  recipe: 'Receta',
  arcane: 'Propiedad arcana',
  account: 'Cuenta',
  character: 'Personaje',
  user: 'Usuario del sistema',
  dm_access: 'Acceso DM',
}

const auditActionLabels: Record<string, string> = {
  create: 'Creación',
  update: 'Modificación',
  delete: 'Eliminación',
  password_reset: 'Restablecimiento de contraseña',
  mfa_enable: 'Activación del segundo factor',
  mfa_disable: 'Desactivación del segundo factor',
  mfa_reset: 'Restablecimiento administrativo del segundo factor',
  cdkey_request: 'Inicio de recaptura de CD key',
  cdkey_cancel: 'Cancelación de recaptura de CD key',
  cdkey_confirm: 'Confirmación de nueva CD key',
  cdkey_ban: 'Baneo global de CD key',
  cdkey_unban: 'Retirada de baneo de CD key',
  whitelist_add: 'Autorización de acceso DM',
  whitelist_remove: 'Retirada de acceso DM',
  name_unlock: 'Desbloqueo de nombre eliminado',
  char_purge: 'Purga definitiva de personaje',
}

const panelTitle = import.meta.env.VITE_CONTROL_PANEL_TITLE || 'Control Panel'
const panelSubtitle = import.meta.env.VITE_CONTROL_PANEL_SUBTITLE || 'System management'
document.title = panelTitle


function canEditProfession(user: User, professionId: number): boolean {
  return user.permissions.includes('edit_recipes')
    && user.editable_profession_ids.includes(professionId)
}


function selectedOptionIndex(row: PropertyRow, definition: PropertyDefinition, controlKey: string): number {
  const control = definition.controls.find((item) => item.key === controlKey)
  if (!control) return -1
  return control.options.findIndex((option) => Object.entries(option.values).every(
    ([binding, value]) => row[binding as PropertyBinding] === value,
  ))
}


function propertySummary(row: PropertyRow, definition: PropertyDefinition): string {
  const values = definition.controls.map((control) => {
    if (control.kind === 'select') {
      const optionIndex = selectedOptionIndex(row, definition, control.key)
      return optionIndex >= 0 ? control.options[optionIndex].label : 'Valor no reconocido'
    }
    return `${control.label}: ${row[control.bindings[0]]}`
  })
  return values.length ? `${definition.label} · ${values.join(' · ')}` : definition.label
}


function Login({ onLogin }: { onLogin: (session: Session) => void }) {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [mfaPending, setMfaPending] = useState(false)
  const [code, setCode] = useState('')
  const login = useMutation({
    mutationFn: () => api<Session | MfaChallenge>('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ username, password }),
    }),
    onSuccess: (result) => {
      if ('mfa_required' in result) {
        setPassword('')
        setCode('')
        setMfaPending(true)
        return
      }
      onLogin(result)
    },
  })
  const verify = useMutation({
    mutationFn: () => api<Session>('/auth/mfa/verify', {
      method: 'POST',
      body: JSON.stringify({ code }),
    }),
    onSuccess: onLogin,
  })

  return (
    <Box className="login-shell">
      <Paper className="login-card" elevation={12}>
        <Box className="brand-mark" aria-hidden="true"><span /></Box>
        <Typography variant="h2" fontSize={{ xs: 34, sm: 42 }}>{panelTitle}</Typography>
        <Typography color="text.secondary" mt={1} mb={4}>
          {panelSubtitle}
        </Typography>
        <Box component="form" onSubmit={(event: FormEvent) => {
          event.preventDefault()
          if (mfaPending) verify.mutate()
          else login.mutate()
        }}>
          <Stack spacing={2}>
            {(login.error || verify.error) && (
              <Alert severity="error">{(login.error || verify.error)?.message}</Alert>
            )}
            {mfaPending ? <>
              <Typography color="text.secondary">
                Introduce el código de tu aplicación de autenticación o un código de recuperación.
              </Typography>
              <TextField
                label="Código de verificación"
                value={code}
                onChange={(event) => setCode(event.target.value)}
                inputProps={{ autoComplete: 'one-time-code' }}
                autoFocus
              />
              <Button type="submit" variant="contained" size="large" disabled={verify.isPending}>
                {verify.isPending ? 'Verificando…' : 'Verificar'}
              </Button>
              <Button onClick={() => {
                verify.reset()
                login.reset()
                setMfaPending(false)
              }}>
                Volver
              </Button>
            </> : <>
              <TextField label="Usuario" value={username} onChange={(event) => setUsername(event.target.value)} autoFocus />
              <TextField label="Contraseña" type="password" value={password} onChange={(event) => setPassword(event.target.value)} />
              <Button type="submit" variant="contained" size="large" disabled={login.isPending}>
                {login.isPending ? 'Entrando…' : 'Entrar'}
              </Button>
            </>}
          </Stack>
        </Box>
      </Paper>
    </Box>
  )
}


function SecurityDialog({
  open,
  user,
  onClose,
  onEnabled,
  onDisabled,
}: {
  open: boolean
  user: User
  onClose: () => void
  onEnabled: () => void
  onDisabled: () => void
}) {
  const [password, setPassword] = useState('')
  const [code, setCode] = useState('')
  const [setupData, setSetupData] = useState<MfaSetup | null>(null)
  const [recoveryCodes, setRecoveryCodes] = useState<string[] | null>(null)
  const setup = useMutation({
    mutationFn: () => api<MfaSetup>('/auth/mfa/setup', {
      method: 'POST',
      body: JSON.stringify({ password }),
    }),
    onSuccess: (result) => {
      setSetupData(result)
      setPassword('')
      setCode('')
    },
  })
  const confirm = useMutation({
    mutationFn: () => api<MfaConfirmation>('/auth/mfa/confirm', {
      method: 'POST',
      body: JSON.stringify({ code }),
    }),
    onSuccess: (result) => {
      setRecoveryCodes(result.recovery_codes)
      onEnabled()
    },
  })
  const disable = useMutation({
    mutationFn: () => api<void>('/auth/mfa/disable', {
      method: 'POST',
      body: JSON.stringify({ password, code }),
    }),
    onSuccess: onDisabled,
  })

  const resetAndClose = () => {
    setup.reset()
    confirm.reset()
    disable.reset()
    setPassword('')
    setCode('')
    setSetupData(null)
    setRecoveryCodes(null)
    onClose()
  }
  const error = setup.error || confirm.error || disable.error
  const pending = setup.isPending || confirm.isPending || disable.isPending

  return (
    <Dialog
      open={open}
      onClose={() => {
        if (!pending && !recoveryCodes) resetAndClose()
      }}
      maxWidth="sm"
      fullWidth
    >
      <DialogTitle>Seguridad de la cuenta</DialogTitle>
      <DialogContent dividers>
        <Stack spacing={2.5} mt={1}>
          {error && <Alert severity="error">{error.message}</Alert>}
          {recoveryCodes ? <>
            <Alert severity="success">El segundo factor está activado.</Alert>
            <Typography>
              Guarda estos códigos de recuperación en un lugar seguro. Solo se muestran una vez
              y cada uno puede utilizarse una sola vez.
            </Typography>
            <Paper variant="outlined" sx={{ p: 2 }}>
              <Typography component="pre" sx={{ m: 0, columns: { sm: 2 } }}>
                {recoveryCodes.join('\n')}
              </Typography>
            </Paper>
          </> : user.mfa_enabled ? <>
            <Alert severity="success">El segundo factor está activado.</Alert>
            <Typography color="text.secondary">
              Para desactivarlo, confirma tu contraseña y un código actual o de recuperación.
              Se cerrarán todas tus sesiones.
            </Typography>
            <TextField
              label="Contraseña actual"
              type="password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
            />
            <TextField
              label="Código de verificación"
              value={code}
              onChange={(event) => setCode(event.target.value)}
              inputProps={{ autoComplete: 'one-time-code' }}
            />
            <Button
              color="error"
              variant="outlined"
              disabled={pending || !password || code.length < 6}
              onClick={() => disable.mutate()}
            >
              Desactivar segundo factor
            </Button>
          </> : setupData ? <>
            <Typography>
              Escanea el código con tu aplicación de autenticación y escribe el código de seis
              cifras para confirmar la configuración.
            </Typography>
            <Box
              sx={{
                alignSelf: 'center',
                bgcolor: '#fff',
                borderRadius: 1,
                maxWidth: '100%',
                p: 2,
              }}
            >
              <Box
                component="img"
                src={setupData.qr_svg_data_uri}
                alt="Código QR para configurar el segundo factor"
                sx={{ display: 'block', width: 240, maxWidth: '100%' }}
              />
            </Box>
            <TextField
              label="Clave manual"
              value={setupData.secret}
              InputProps={{ readOnly: true }}
            />
            <TextField
              label="Código de seis cifras"
              value={code}
              onChange={(event) => setCode(event.target.value.replace(/\D/g, '').slice(0, 6))}
              inputProps={{ inputMode: 'numeric', autoComplete: 'one-time-code' }}
              autoFocus
            />
            <Button
              variant="contained"
              disabled={pending || code.length !== 6}
              onClick={() => confirm.mutate()}
            >
              Confirmar y activar
            </Button>
          </> : <>
            <Typography color="text.secondary">
              Añade una aplicación de autenticación para pedir un código además de la contraseña
              cada vez que inicies sesión.
            </Typography>
            <TextField
              label="Contraseña actual"
              type="password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              autoFocus
            />
            <Button
              variant="contained"
              disabled={pending || !password}
              onClick={() => setup.mutate()}
            >
              Configurar segundo factor
            </Button>
          </>}
        </Stack>
      </DialogContent>
      <DialogActions>
        <Button disabled={pending} onClick={resetAndClose}>
          {recoveryCodes ? 'He guardado los códigos' : 'Cerrar'}
        </Button>
      </DialogActions>
    </Dialog>
  )
}


function RecipeEditor({ recipeId, open, writesEnabled, canEdit, onClose }: {
  recipeId: number | null
  open: boolean
  writesEnabled: boolean
  canEdit: boolean
  onClose: () => void
}) {
  const client = useQueryClient()
  const [draft, setDraft] = useState<RecipeDetail | null>(null)
  const recipe = useQuery({
    queryKey: ['recipe', recipeId],
    queryFn: () => api<RecipeDetail>(`/recipes/${recipeId}`),
    enabled: open && recipeId !== null,
  })
  const references = useQuery({ queryKey: ['references'], queryFn: () => api<References>('/references') })
  const propertyDefinitions = useQuery({
    queryKey: ['property-definitions'],
    queryFn: () => api<PropertyDefinitions>('/property-definitions'),
  })
  useEffect(() => {
    setDraft(open && recipe.data ? structuredClone(recipe.data) : null)
  }, [open, recipe.data])

  const save = useMutation({
    mutationFn: (value: RecipeDetail) => api<RecipeDetail>(`/recipes/${value.recipe_id}`, {
      method: 'PUT',
      body: JSON.stringify({
        updated_at: value.updated_at,
        public_id: value.public_id,
        category_id: value.category_id,
        material_id: value.material_id,
        tier: value.tier,
        display_name: value.display_name,
        description: value.description,
        base_resref: value.base_resref,
        output_tag: value.output_tag,
        output_qty: value.output_qty,
        output_kind: value.output_kind,
        dc: value.dc,
        xp_award: value.xp_award,
        gold_value: value.gold_value,
        enabled: value.enabled,
        components: value.components,
        properties: value.properties.map(({ recipe_property_id: _, display_text: __, ...row }) => row),
      }),
    }),
    onSuccess: (updated) => {
      setDraft(updated)
      client.invalidateQueries({ queryKey: ['recipes'] })
      client.setQueryData(['recipe', updated.recipe_id], updated)
    },
  })

  const setField = <K extends keyof RecipeDetail>(field: K, value: RecipeDetail[K]) => {
    setDraft((current) => current ? { ...current, [field]: value } : current)
  }
  const setComponent = (index: number, field: string, value: string | number) => {
    setDraft((current) => current ? {
      ...current,
      components: current.components.map((row, rowIndex) => rowIndex === index ? { ...row, [field]: value } : row),
    } : current)
  }
  const setPropertyValues = (
    index: number,
    values: Partial<Record<PropertyBinding, number>>,
  ) => {
    setDraft((current) => current ? {
      ...current,
      properties: current.properties.map((row, rowIndex) => rowIndex === index
        ? { ...row, ...values }
        : row),
    } : current)
  }
  const changePropertyType = (index: number, definition: PropertyDefinition) => {
    setDraft((current) => current ? {
      ...current,
      properties: current.properties.map((row, rowIndex) => rowIndex === index
        ? {
            ...row,
            property_type: definition.property_type,
            ...definition.defaults,
            display_text: definition.label,
          }
        : row),
    } : current)
  }
  const moveProperty = (index: number, direction: -1 | 1) => {
    setDraft((current) => {
      if (!current) return current
      const nextIndex = index + direction
      if (nextIndex < 0 || nextIndex >= current.properties.length) return current
      const properties = [...current.properties]
      ;[properties[index], properties[nextIndex]] = [properties[nextIndex], properties[index]]
      return {
        ...current,
        properties: properties.map((item, sortOrder) => ({ ...item, sort_order: sortOrder })),
      }
    })
  }

  return (
    <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
      <DialogTitle>Editar receta {draft ? `#${draft.public_id}` : ''}</DialogTitle>
      <DialogContent dividers>
        {recipe.isLoading || !draft ? <CircularProgress /> : (
          <Box
            component="fieldset"
            disabled={!canEdit}
            sx={{ border: 0, m: 0, minWidth: 0, p: 0 }}
          >
          <Stack spacing={3}>
            {!writesEnabled && <Alert severity="warning">La escritura está desactivada hasta validar el consumidor dentro del juego.</Alert>}
            {!canEdit && <Alert severity="info">Puedes consultar esta receta, pero no tienes permiso para editar este oficio.</Alert>}
            {save.error && <Alert severity="error">{save.error.message}</Alert>}
            {save.isSuccess && <Alert severity="success">Receta guardada e historial registrado.</Alert>}
            <Box className="field-grid">
              <TextField label="ID público" type="number" value={draft.public_id} onChange={(e) => setField('public_id', Number(e.target.value))} />
              <TextField label="Nombre" value={draft.display_name} onChange={(e) => setField('display_name', e.target.value)} />
              <TextField select label="Categoría" value={draft.category_id} onChange={(e) => setField('category_id', Number(e.target.value))}>
                {references.data?.categories.map((item) => <MenuItem key={item.id} value={item.id}>{item.display_name}</MenuItem>)}
              </TextField>
              <TextField select label="Material" value={draft.material_id ?? ''} onChange={(e) => setField('material_id', e.target.value === '' ? null : Number(e.target.value))}>
                <MenuItem value="">Ninguno</MenuItem>
                {references.data?.materials.map((item) => <MenuItem key={item.id} value={item.id}>{item.display_name} · T{item.tier}</MenuItem>)}
              </TextField>
              <TextField label="Nivel" type="number" value={draft.tier} onChange={(e) => setField('tier', Number(e.target.value))} />
              <TextField label="Clase de dificultad" type="number" value={draft.dc} onChange={(e) => setField('dc', Number(e.target.value))} />
              <TextField label="Referencia del blueprint" value={draft.base_resref} onChange={(e) => setField('base_resref', e.target.value)} />
              <TextField label="Etiqueta de salida" value={draft.output_tag ?? ''} onChange={(e) => setField('output_tag', e.target.value || null)} />
              <TextField label="Cantidad producida" type="number" value={draft.output_qty} onChange={(e) => setField('output_qty', Number(e.target.value))} />
              <TextField label="XP otorgada" type="number" value={draft.xp_award} onChange={(e) => setField('xp_award', Number(e.target.value))} />
              <TextField label="Valor en oro" type="number" value={draft.gold_value} onChange={(e) => setField('gold_value', Number(e.target.value))} />
              <FormControlLabel control={<Switch checked={draft.enabled} onChange={(e) => setField('enabled', e.target.checked)} />} label="Activa" />
            </Box>
            <TextField label="Descripción" multiline minRows={2} value={draft.description ?? ''} onChange={(e) => setField('description', e.target.value || null)} />

            <Stack direction="row" justifyContent="space-between"><Typography variant="h6">Componentes</Typography><Button startIcon={<AddIcon />} onClick={() => setDraft({ ...draft, components: [...draft.components, { component_tag: '', display_name: '', qty: 1, retain_on_fail: 0, sort_order: draft.components.length }].map((item, sortOrder) => ({ ...item, sort_order: sortOrder })) })}>Añadir</Button></Stack>
            <TableContainer component={Paper} variant="outlined"><Table size="small">
              <TableHead><TableRow><TableCell>Objeto</TableCell><TableCell>Tag</TableCell><TableCell>Cantidad</TableCell><TableCell>Conservado al fallar</TableCell><TableCell /></TableRow></TableHead>
              <TableBody>{draft.components.map((row, index) => <TableRow key={`${row.component_tag}-${index}`}>
                <TableCell><TextField size="small" value={row.display_name ?? ''} onChange={(e) => setComponent(index, 'display_name', e.target.value)} /></TableCell><TableCell><TextField size="small" value={row.component_tag} onChange={(e) => setComponent(index, 'component_tag', e.target.value)} /></TableCell><TableCell><TextField size="small" type="number" value={row.qty} onChange={(e) => setComponent(index, 'qty', Number(e.target.value))} /></TableCell><TableCell><TextField size="small" type="number" value={row.retain_on_fail} onChange={(e) => setComponent(index, 'retain_on_fail', Number(e.target.value))} /></TableCell><TableCell><IconButton disabled={draft.components.length === 1} onClick={() => setDraft({ ...draft, components: draft.components.filter((_, rowIndex) => rowIndex !== index).map((item, sortOrder) => ({ ...item, sort_order: sortOrder })) })}><DeleteIcon /></IconButton></TableCell>
              </TableRow>)}</TableBody>
            </Table></TableContainer>

            <Stack direction="row" justifyContent="space-between">
              <Box>
                <Typography variant="h6">Propiedades</Typography>
                <Typography variant="body2" color="text.secondary">
                  Los nombres visibles se convierten automáticamente a los valores numéricos del juego.
                </Typography>
              </Box>
              <Button
                startIcon={<AddIcon />}
                disabled={!propertyDefinitions.data?.items.length}
                onClick={() => {
                  const definition = propertyDefinitions.data?.items[0]
                  if (!definition) return
                  setDraft({
                    ...draft,
                    properties: [
                      ...draft.properties,
                      {
                        recipe_property_id: -Date.now(),
                        property_type: definition.property_type,
                        ...definition.defaults,
                        sort_order: draft.properties.length,
                        display_text: definition.label,
                      },
                    ].map((item, sortOrder) => ({ ...item, sort_order: sortOrder })),
                  })
                }}
              >
                Añadir
              </Button>
            </Stack>
            {propertyDefinitions.error && (
              <Alert severity="error">No se pudieron cargar las definiciones de propiedades.</Alert>
            )}
            <Stack spacing={2}>
              {draft.properties.map((row, index) => {
                const definition = propertyDefinitions.data?.items.find(
                  (item) => item.property_type === row.property_type,
                )
                return (
                  <Paper key={row.recipe_property_id} variant="outlined" className="property-card">
                    <Stack direction={{ xs: 'column', md: 'row' }} spacing={2} alignItems={{ md: 'flex-start' }}>
                      <TextField
                        select
                        label="Propiedad"
                        value={definition?.property_type ?? ''}
                        sx={{ minWidth: 260 }}
                        onChange={(event) => {
                          const next = propertyDefinitions.data?.items.find(
                            (item) => item.property_type === event.target.value,
                          )
                          if (next) changePropertyType(index, next)
                        }}
                      >
                        {propertyDefinitions.data?.items.map((item) => (
                          <MenuItem key={item.property_type} value={item.property_type}>
                            {item.label}
                          </MenuItem>
                        ))}
                      </TextField>
                      <Box className="property-control-grid">
                        {definition?.controls.map((control) => control.kind === 'select' ? (
                          <TextField
                            select
                            key={control.key}
                            label={control.label}
                            value={selectedOptionIndex(row, definition, control.key)}
                            onChange={(event) => {
                              const option = control.options[Number(event.target.value)]
                              if (option) setPropertyValues(index, option.values)
                            }}
                          >
                            {control.options.map((option, optionIndex) => (
                              <MenuItem key={`${control.key}-${optionIndex}`} value={optionIndex}>
                                {option.label}
                              </MenuItem>
                            ))}
                          </TextField>
                        ) : (
                          <TextField
                            key={control.key}
                            type="number"
                            label={control.label}
                            value={row[control.bindings[0]]}
                            slotProps={{
                              htmlInput: {
                                min: control.minimum ?? undefined,
                                max: control.maximum ?? undefined,
                              },
                            }}
                            onChange={(event) => setPropertyValues(
                              index,
                              { [control.bindings[0]]: Number(event.target.value) },
                            )}
                          />
                        ))}
                      </Box>
                      <Stack direction="row">
                        <Tooltip title="Subir propiedad">
                          <span>
                            <IconButton disabled={index === 0} onClick={() => moveProperty(index, -1)}>
                              <ArrowUpwardIcon />
                            </IconButton>
                          </span>
                        </Tooltip>
                        <Tooltip title="Bajar propiedad">
                          <span>
                            <IconButton
                              disabled={index === draft.properties.length - 1}
                              onClick={() => moveProperty(index, 1)}
                            >
                              <ArrowDownwardIcon />
                            </IconButton>
                          </span>
                        </Tooltip>
                        <Tooltip title="Eliminar propiedad">
                          <IconButton onClick={() => setDraft({
                            ...draft,
                            properties: draft.properties
                              .filter((_, rowIndex) => rowIndex !== index)
                              .map((item, sortOrder) => ({ ...item, sort_order: sortOrder })),
                          })}>
                            <DeleteIcon />
                          </IconButton>
                        </Tooltip>
                      </Stack>
                    </Stack>
                    {definition ? (
                      <Box className="property-preview">
                        <Typography variant="body2">{propertySummary(row, definition)}</Typography>
                        <Typography variant="caption" color="text.secondary">
                          Valor interno: {row.property_type} / subtipo={row.subtype} /
                          valor1={row.value1} / valor2={row.value2}
                        </Typography>
                      </Box>
                    ) : (
                      <Alert severity="error" sx={{ mt: 2 }}>
                        Tipo antiguo sin definición: {row.property_type}
                      </Alert>
                    )}
                  </Paper>
                )
              })}
            </Stack>
          </Stack>
          </Box>
        )}
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cerrar</Button>
        <Button variant="contained" disabled={!draft || !writesEnabled || !canEdit || save.isPending} onClick={() => draft && save.mutate(draft)}>Guardar receta</Button>
      </DialogActions>
    </Dialog>
  )
}


// Arcano is profession 6 in cnr_profession. It is the one trade with no
// recipes: cnr_recipe holds nothing for it, which is why this tab used to read
// "0 recetas encontradas" and the number was correct. What it sells lives in
// cnr_arcane_property, cnr_arcane_step and cnr_arcane_group, so the tab needs
// its own table and its own editor rather than a filter on the recipe query.
const ARCANE_PROFESSION_ID = 6

const emptyArcaneStep = (essences: number): ArcaneStepRow => ({
  essences,
  subtype: null,
  value1: 0,
  value2: 0,
  xp: 0,
  display_value: '',
})


function ArcaneEditor({ arcaneId, open, writesEnabled, canEdit, onClose }: {
  arcaneId: number | null
  open: boolean
  writesEnabled: boolean
  canEdit: boolean
  onClose: () => void
}) {
  const client = useQueryClient()
  const [draft, setDraft] = useState<ArcaneDetail | null>(null)
  const property = useQuery({
    queryKey: ['arcane-property', arcaneId],
    queryFn: () => api<ArcaneDetail>(`/arcane/properties/${arcaneId}`),
    enabled: open && arcaneId !== null,
  })
  const references = useQuery({
    queryKey: ['arcane-references'],
    queryFn: () => api<ArcaneReferences>('/arcane/references'),
  })
  useEffect(() => {
    setDraft(open && property.data ? structuredClone(property.data) : null)
  }, [open, property.data])

  const save = useMutation({
    mutationFn: (value: ArcaneDetail) => api<ArcaneDetail>(`/arcane/properties/${value.arcane_id}`, {
      method: 'PUT',
      body: JSON.stringify({
        fingerprint: value.fingerprint,
        section: value.section,
        display_name: value.display_name,
        group_id: value.group_id,
        tier: value.tier,
        essence_resref: value.essence_resref,
        essence_name: value.essence_name,
        crystal_resref: value.crystal_resref,
        crystal_name: value.crystal_name,
        ubicacion: value.ubicacion,
        property_type: value.property_type,
        subtype: value.subtype,
        min_level: value.min_level,
        dc: value.dc,
        supported: value.supported,
        note: value.note,
        steps: value.steps,
      }),
    }),
    onSuccess: (updated) => {
      setDraft(updated)
      client.invalidateQueries({ queryKey: ['arcane-properties'] })
      // Section and property type are editable and are what the references
      // query returns as its distinct values, so a save can leave the filters
      // offering a section nothing is in, or missing one that now exists.
      client.invalidateQueries({ queryKey: ['arcane-references'] })
      client.setQueryData(['arcane-property', updated.arcane_id], updated)
    },
  })

  const setField = <K extends keyof ArcaneDetail>(field: K, value: ArcaneDetail[K]) => {
    setDraft((current) => current ? { ...current, [field]: value } : current)
  }
  const setStep = (index: number, field: keyof ArcaneStepRow, value: string | number | null) => {
    setDraft((current) => current ? {
      ...current,
      steps: current.steps.map((row, rowIndex) => rowIndex === index ? { ...row, [field]: value } : row),
    } : current)
  }
  const addStep = () => {
    setDraft((current) => {
      if (!current) return current
      const next = current.steps.reduce((highest, row) => Math.max(highest, row.essences), 0) + 1
      return { ...current, steps: [...current.steps, emptyArcaneStep(Math.min(next, 255))] }
    })
  }
  const removeStep = (index: number) => {
    setDraft((current) => current
      ? { ...current, steps: current.steps.filter((_, rowIndex) => rowIndex !== index) }
      : current)
  }

  const group = references.data?.groups.find((item) => item.group_id === draft?.group_id)
  const duplicateEssences = draft
    ? draft.steps.length !== new Set(draft.steps.map((row) => row.essences)).size
    : false
  const canSave = Boolean(draft)
    && writesEnabled
    && canEdit
    && !save.isPending
    && !duplicateEssences
    && (draft?.steps.length ?? 0) > 0

  return (
    <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
      <DialogTitle>
        {draft ? `${draft.display_name} · ID ${draft.arcane_id}` : 'Propiedad arcana'}
      </DialogTitle>
      <DialogContent dividers>
        {property.isLoading && <CircularProgress />}
        {property.error && <Alert severity="error">{property.error.message}</Alert>}
        {save.error && <Alert severity="error">{save.error.message}</Alert>}
        {!canEdit && draft && (
          <Alert severity="info">
            No tienes permiso para editar Arcano; puedes consultar la propiedad.
          </Alert>
        )}
        {duplicateEssences && (
          <Alert severity="warning">
            Dos escalones piden el mismo número de esencias. Cada escalón debe pedir una cantidad distinta.
          </Alert>
        )}
        {draft && (
          <Stack spacing={3}>
            <Box className="field-grid">
            <TextField label="Nombre" value={draft.display_name} disabled={!canEdit}
              onChange={(e) => setField('display_name', e.target.value)} />
            <TextField label="Sección" value={draft.section} disabled={!canEdit}
              onChange={(e) => setField('section', e.target.value)} />
            <TextField select label="Grupo de objetos" value={draft.group_id} disabled={!canEdit}
              onChange={(e) => setField('group_id', Number(e.target.value))}>
              {references.data?.groups.map((item) => (
                <MenuItem key={item.group_id} value={item.group_id}>{item.display_name}</MenuItem>
              ))}
            </TextField>
            <TextField label="Tipo de propiedad" value={draft.property_type} disabled={!canEdit}
              onChange={(e) => setField('property_type', e.target.value)} />
            <TextField label="Subtipo" type="number" value={draft.subtype} disabled={!canEdit}
              onChange={(e) => setField('subtype', Number(e.target.value))} />
            <TextField label="Nivel" type="number" value={draft.tier} disabled={!canEdit}
              onChange={(e) => setField('tier', Number(e.target.value))} />
            <TextField label="Nivel de oficio mínimo" type="number" value={draft.min_level} disabled={!canEdit}
              onChange={(e) => setField('min_level', Number(e.target.value))} />
            <TextField label="CD" type="number" value={draft.dc} disabled={!canEdit}
              onChange={(e) => setField('dc', Number(e.target.value))} />
            <TextField label="Resref de la esencia" value={draft.essence_resref} disabled={!canEdit}
              onChange={(e) => setField('essence_resref', e.target.value)} />
            <TextField label="Nombre de la esencia" value={draft.essence_name} disabled={!canEdit}
              onChange={(e) => setField('essence_name', e.target.value)} />
            <TextField label="Resref del cristal" value={draft.crystal_resref} disabled={!canEdit}
              onChange={(e) => setField('crystal_resref', e.target.value)} />
            <TextField label="Nombre del cristal" value={draft.crystal_name} disabled={!canEdit}
              onChange={(e) => setField('crystal_name', e.target.value)} />
            <TextField label="Dónde cae la esencia" value={draft.ubicacion} disabled={!canEdit}
              onChange={(e) => setField('ubicacion', e.target.value)} />
            <TextField label="Nota" value={draft.note ?? ''} disabled={!canEdit}
              onChange={(e) => setField('note', e.target.value === '' ? null : e.target.value)} />
            <FormControlLabel
              control={<Switch checked={draft.supported} disabled={!canEdit}
                onChange={(e) => setField('supported', e.target.checked)} />}
              label="Disponible en la ventana"
            />
            </Box>

            <Box>
              <Typography variant="subtitle1">
                Objetos admitidos · {group?.display_name ?? '—'}
              </Typography>
              <Typography variant="caption" color="text.secondary">
                {group?.any_base
                  ? 'Este grupo admite cualquier objeto base; la lista de bases no se lee.'
                  : `${group?.bases.length ?? 0} tipos base. El coste en cristales lo fija el objeto, no la propiedad.`}
              </Typography>
              {!group?.any_base && (group?.bases.length ?? 0) > 0 && (
                <Box className="arcane-base-list">
                  {group?.bases.map((base) => (
                    <Chip
                      key={base.base_item}
                      size="small"
                      label={`Base ${base.base_item} · ${base.crystal_cost} cristal${base.crystal_cost === 1 ? '' : 'es'}`}
                    />
                  ))}
                </Box>
              )}
            </Box>

            <Box>
              <Typography variant="subtitle1">Escalones</Typography>
              <Typography variant="caption" color="text.secondary">
                Cada fila es una cantidad que el jugador puede comprar. El subtipo vacío usa el de la propiedad;
                sólo la reducción de daño lo sobreescribe.
              </Typography>
              <Table size="small">
                <TableHead><TableRow>
                  <TableCell>Esencias</TableCell><TableCell>Valor mostrado</TableCell>
                  <TableCell>Subtipo</TableCell><TableCell>Valor 1</TableCell>
                  <TableCell>Valor 2</TableCell><TableCell>XP</TableCell><TableCell /></TableRow></TableHead>
                <TableBody>
                  {draft.steps.map((row, index) => (
                    <TableRow key={index}>
                      <TableCell><TextField size="small" type="number" value={row.essences} disabled={!canEdit}
                        onChange={(e) => setStep(index, 'essences', Number(e.target.value))} /></TableCell>
                      <TableCell><TextField size="small" value={row.display_value} disabled={!canEdit}
                        onChange={(e) => setStep(index, 'display_value', e.target.value)} /></TableCell>
                      <TableCell><TextField size="small" type="number" value={row.subtype ?? ''} disabled={!canEdit}
                        placeholder="—"
                        onChange={(e) => setStep(index, 'subtype', e.target.value === '' ? null : Number(e.target.value))} /></TableCell>
                      <TableCell><TextField size="small" type="number" value={row.value1} disabled={!canEdit}
                        onChange={(e) => setStep(index, 'value1', Number(e.target.value))} /></TableCell>
                      <TableCell><TextField size="small" type="number" value={row.value2} disabled={!canEdit}
                        onChange={(e) => setStep(index, 'value2', Number(e.target.value))} /></TableCell>
                      <TableCell><TextField size="small" type="number" value={row.xp} disabled={!canEdit}
                        onChange={(e) => setStep(index, 'xp', Number(e.target.value))} /></TableCell>
                      <TableCell>
                        <Tooltip title="Quitar escalón">
                          <span>
                            <IconButton size="small" disabled={!canEdit || draft.steps.length <= 1}
                              onClick={() => removeStep(index)}><DeleteIcon fontSize="small" /></IconButton>
                          </span>
                        </Tooltip>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
              <Button startIcon={<AddIcon />} disabled={!canEdit} onClick={addStep}>Añadir escalón</Button>
            </Box>
          </Stack>
        )}
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cerrar</Button>
        <Button variant="contained" disabled={!canSave} onClick={() => draft && save.mutate(draft)}>
          Guardar propiedad
        </Button>
      </DialogActions>
    </Dialog>
  )
}


function ArcaneCatalogue({ writesEnabled, user }: { writesEnabled: boolean; user: User }) {
  const [search, setSearch] = useState('')
  const [section, setSection] = useState<string>('all')
  const [groupId, setGroupId] = useState<number | 'all'>('all')
  const [selected, setSelected] = useState<number | null>(null)
  const [page, setPage] = useState(0)
  const [rowsPerPage, setRowsPerPage] = useState(50)
  const references = useQuery({
    queryKey: ['arcane-references'],
    queryFn: () => api<ArcaneReferences>('/arcane/references'),
  })
  useEffect(() => setPage(0), [search, section, groupId])
  const properties = useQuery({
    queryKey: ['arcane-properties', search, section, groupId, page, rowsPerPage],
    queryFn: () => {
      const params = new URLSearchParams({
        limit: String(rowsPerPage),
        offset: String(page * rowsPerPage),
      })
      if (search) params.set('search', search)
      if (section !== 'all') params.set('section', section)
      if (groupId !== 'all') params.set('group_id', String(groupId))
      return api<ArcanePage>(`/arcane/properties?${params}`)
    },
  })
  const canEdit = canEditProfession(user, ARCANE_PROFESSION_ID)

  return (
    <Stack spacing={2}>
      <Box className="section-heading">
        <Box>
          <Typography variant="h4">Propiedades arcanas</Typography>
          <Typography color="text.secondary">
            {properties.data?.total ?? 0} propiedades encontradas
          </Typography>
        </Box>
        <Stack direction="row" spacing={1}>
          <TextField select size="small" label="Sección" value={section}
            onChange={(e) => setSection(e.target.value)} sx={{ minWidth: 180 }}>
            <MenuItem value="all">Todas</MenuItem>
            {references.data?.sections.map((item) => (
              <MenuItem key={item} value={item}>{item}</MenuItem>
            ))}
          </TextField>
          <TextField select size="small" label="Grupo" value={groupId}
            onChange={(e) => setGroupId(e.target.value === 'all' ? 'all' : Number(e.target.value))}
            sx={{ minWidth: 180 }}>
            <MenuItem value="all">Todos</MenuItem>
            {references.data?.groups.map((item) => (
              <MenuItem key={item.group_id} value={item.group_id}>{item.display_name}</MenuItem>
            ))}
          </TextField>
          <TextField size="small" label="Buscar por nombre o ID" value={search}
            onChange={(e) => setSearch(e.target.value)} />
        </Stack>
      </Box>
      <Alert severity="info">
        Arcano no tiene recetas: no hay componentes ni objeto de salida. El jugador trae un objeto que el
        grupo admita y compra una cantidad de una propiedad, pagando las esencias del escalón y los cristales
        que cueste el objeto base.
      </Alert>
      {(properties.error || references.error) && (
        <Alert severity="error">{(properties.error || references.error)?.message}</Alert>
      )}
      <TableContainer component={Paper}>
        <Table stickyHeader size="small">
          <TableHead><TableRow>
            <TableCell>Estado</TableCell><TableCell>ID</TableCell><TableCell>Nombre</TableCell>
            <TableCell>Sección</TableCell><TableCell>Objetos admitidos</TableCell>
            <TableCell>Esencia / cristal</TableCell><TableCell>Nivel</TableCell>
            <TableCell>Oficio</TableCell><TableCell>CD</TableCell>
            <TableCell>Escalones</TableCell><TableCell />
          </TableRow></TableHead>
          <TableBody>{properties.data?.items.map((row) => (
            <TableRow hover key={row.arcane_id}>
              <TableCell>
                <Chip size="small" label={row.supported ? 'Disponible' : 'Oculta'}
                  color={row.supported ? 'success' : 'default'} />
              </TableCell>
              <TableCell>{row.arcane_id}</TableCell>
              <TableCell>{row.display_name}<br /><small>{row.property_type}</small></TableCell>
              <TableCell>{row.section}</TableCell>
              <TableCell>
                {row.group_name}<br />
                <small>{row.any_base ? 'cualquier objeto' : `${row.base_item_count} tipos base`}</small>
              </TableCell>
              <TableCell>{row.essence_name}<br /><small>{row.crystal_name}</small></TableCell>
              <TableCell>{row.tier}</TableCell>
              <TableCell>{row.min_level}</TableCell>
              <TableCell>{row.dc}</TableCell>
              <TableCell>{row.step_count}</TableCell>
              <TableCell>
                <Tooltip title={canEdit ? 'Editar propiedad' : 'Consultar propiedad'}>
                  <IconButton onClick={() => setSelected(row.arcane_id)}><EditIcon /></IconButton>
                </Tooltip>
              </TableCell>
            </TableRow>
          ))}</TableBody>
        </Table>
        <TablePagination
          component="div"
          count={properties.data?.total ?? 0}
          page={page}
          rowsPerPage={rowsPerPage}
          rowsPerPageOptions={[25, 50, 100, 250]}
          labelRowsPerPage="Propiedades por página"
          labelDisplayedRows={({ from, to, count }) => (
            `${from}–${to} de ${count === -1 ? `más de ${to}` : count}`
          )}
          getItemAriaLabel={(type) => ({
            first: 'Ir a la primera página',
            last: 'Ir a la última página',
            next: 'Ir a la página siguiente',
            previous: 'Ir a la página anterior',
          })[type]}
          onPageChange={(_, nextPage) => setPage(nextPage)}
          onRowsPerPageChange={(event) => {
            setRowsPerPage(Number(event.target.value))
            setPage(0)
          }}
        />
      </TableContainer>
      <ArcaneEditor
        arcaneId={selected}
        open={selected !== null}
        writesEnabled={writesEnabled}
        canEdit={canEdit}
        onClose={() => setSelected(null)}
      />
    </Stack>
  )
}


function Recipes({ writesEnabled, user }: { writesEnabled: boolean; user: User }) {
  const [search, setSearch] = useState('')
  const [selected, setSelected] = useState<{ recipeId: number; professionId: number } | null>(null)
  const [professionId, setProfessionId] = useState<number | null>(null)
  const [page, setPage] = useState(0)
  const [rowsPerPage, setRowsPerPage] = useState(50)
  const references = useQuery({ queryKey: ['references'], queryFn: () => api<References>('/references') })
  useEffect(() => setPage(0), [search, professionId])
  const showArcane = professionId === ARCANE_PROFESSION_ID
  const recipes = useQuery({
    queryKey: ['recipes', search, professionId, page, rowsPerPage],
    // Arcano has no rows in cnr_recipe, so asking for them only ever produced
    // the empty table this tab used to show. Its own catalogue replaces it.
    enabled: !showArcane,
    queryFn: () => {
      const params = new URLSearchParams({
        limit: String(rowsPerPage),
        offset: String(page * rowsPerPage),
      })
      if (search) params.set('search', search)
      if (professionId !== null) params.set('profession_id', String(professionId))
      return api<RecipePage>(`/recipes?${params}`)
    },
  })
  return (
    <Stack spacing={2}>
      <Tabs
        className="feature-tabs"
        value={professionId ?? 'all'}
        onChange={(_, value: number | 'all') => setProfessionId(value === 'all' ? null : value)}
        variant="scrollable"
        scrollButtons="auto"
        aria-label="Filtrar recetas por oficio"
      >
        <Tab label="Todos" value="all" />
        {references.data?.professions.map((profession) => (
          <Tab
            key={profession.id}
            label={canEditProfession(user, profession.id)
              ? profession.display_name
              : `${profession.display_name} · solo lectura`}
            value={profession.id}
          />
        ))}
      </Tabs>
      {showArcane ? <ArcaneCatalogue writesEnabled={writesEnabled} user={user} /> : <>
      <Box className="section-heading">
        <Box><Typography variant="h4">Catálogo de recetas</Typography><Typography color="text.secondary">{recipes.data?.total ?? 0} recetas encontradas</Typography></Box>
        <TextField size="small" label="Buscar por nombre o ID" value={search} onChange={(e) => setSearch(e.target.value)} />
      </Box>
      {(recipes.error || references.error) && (
        <Alert severity="error">{(recipes.error || references.error)?.message}</Alert>
      )}
      <TableContainer component={Paper}>
        <Table stickyHeader size="small">
          <TableHead><TableRow><TableCell>Estado</TableCell><TableCell>ID</TableCell><TableCell>Nombre</TableCell><TableCell>Oficio / estación</TableCell><TableCell>Material</TableCell><TableCell>Nivel</TableCell><TableCell>CD</TableCell><TableCell>Componentes / propiedades</TableCell><TableCell /></TableRow></TableHead>
          <TableBody>{recipes.data?.items.map((row) => <TableRow hover key={row.recipe_id}>
            <TableCell><Chip size="small" label={row.enabled ? 'Activa' : 'Inactiva'} color={row.enabled ? 'success' : 'default'} /></TableCell>
            <TableCell>{row.public_id}</TableCell><TableCell>{row.display_name}</TableCell><TableCell>{row.profession_name}<br /><small>{row.station_name}</small></TableCell><TableCell>{row.material_name ?? '—'}</TableCell><TableCell>{row.tier}</TableCell><TableCell>{row.dc}</TableCell><TableCell>{row.component_count} / {row.property_count}</TableCell>
            <TableCell><Tooltip title={canEditProfession(user, row.profession_id) ? 'Editar receta' : 'Consultar receta'}><IconButton onClick={() => setSelected({ recipeId: row.recipe_id, professionId: row.profession_id })}><EditIcon /></IconButton></Tooltip></TableCell>
          </TableRow>)}</TableBody>
        </Table>
        <TablePagination
          component="div"
          count={recipes.data?.total ?? 0}
          page={page}
          rowsPerPage={rowsPerPage}
          rowsPerPageOptions={[25, 50, 100, 250]}
          labelRowsPerPage="Recetas por página"
          labelDisplayedRows={({ from, to, count }) => (
            `${from}–${to} de ${count === -1 ? `más de ${to}` : count}`
          )}
          getItemAriaLabel={(type) => ({
            first: 'Ir a la primera página',
            last: 'Ir a la última página',
            next: 'Ir a la página siguiente',
            previous: 'Ir a la página anterior',
          })[type]}
          onPageChange={(_, nextPage) => setPage(nextPage)}
          onRowsPerPageChange={(event) => {
            setRowsPerPage(Number(event.target.value))
            setPage(0)
          }}
        />
      </TableContainer>
      <RecipeEditor
        recipeId={selected?.recipeId ?? null}
        open={selected !== null}
        writesEnabled={writesEnabled}
        canEdit={selected ? canEditProfession(user, selected.professionId) : false}
        onClose={() => setSelected(null)}
      />
      </>}
    </Stack>
  )
}


type UserChanges = {
  username?: string
  email?: string | null
  password?: string
  role?: Role
  editable_profession_ids?: number[]
  permissions?: Permission[]
  active?: boolean
}


function ProfessionChecklist({ professions, selected, disabled = false, onChange }: {
  professions: References['professions']
  selected: number[]
  disabled?: boolean
  onChange: (professionIds: number[]) => void
}) {
  return (
    <Box className="profession-permission-section">
      <Typography variant="subtitle2">Oficios editables</Typography>
      <Typography variant="caption" color="text.secondary">
        Limita en qué oficios funciona el permiso «Editar recetas».
      </Typography>
      <FormGroup className="profession-toggle-grid">
        {professions.map((profession) => <FormControlLabel
          key={profession.id}
          className="user-toggle-option"
          control={<Switch
            checked={selected.includes(profession.id)}
            disabled={disabled}
            onChange={(event) => onChange(event.target.checked
              ? [...selected, profession.id]
              : selected.filter((id) => id !== profession.id))}
          />}
          label={profession.display_name}
        />)}
      </FormGroup>
    </Box>
  )
}


function PermissionChecklist({ permissions, disabled, onChange }: {
  permissions: Permission[]
  disabled: boolean
  onChange: (permissions: Permission[]) => void
}) {
  return (
    <Box className="system-permission-section">
      <Typography variant="subtitle2">Permisos del sistema</Typography>
      <Typography variant="caption" color="text.secondary">
        Los permisos de edición incluyen automáticamente el permiso de consulta necesario.
      </Typography>
      <Box className="permission-group-grid">
        {permissionGroups.map((group) => (
          <Paper key={group.label} variant="outlined" className="permission-group">
            <Typography variant="subtitle2">{group.label}</Typography>
            <Typography variant="caption" color="text.secondary">
              {group.description}
            </Typography>
            <FormGroup>
              {group.permissions.map((permission) => <FormControlLabel
                key={permission}
                className="user-toggle-option"
                control={<Switch
                  checked={permissions.includes(permission)}
                  disabled={disabled}
                  onChange={(event) => onChange(togglePermission(
                    permissions,
                    permission,
                    event.target.checked,
                  ))}
                />}
                label={permissionLabels[permission]}
              />)}
            </FormGroup>
          </Paper>
        ))}
      </Box>
      {disabled && (
        <Typography variant="caption" color="text.secondary" display="block" mt={1}>
          Solo un administrador puede cambiar los permisos del sistema.
        </Typography>
      )}
    </Box>
  )
}


function UserEditorDialog({
  user,
  professions,
  canEditUsers,
  canGrantSystemPermissions,
  canDelete,
  canResetMfa,
  deleteDisabledReason,
  open,
  error,
  onClose,
  onDelete,
  onResetMfa,
  onSave,
  saving,
}: {
  user: User | null
  professions: References['professions']
  canEditUsers: boolean
  canGrantSystemPermissions: boolean
  canDelete: boolean
  canResetMfa: boolean
  deleteDisabledReason: string | null
  open: boolean
  error: Error | null
  onClose: () => void
  onDelete: () => void
  onResetMfa: () => void
  onSave: (changes: UserChanges) => void
  saving: boolean
}) {
  const [username, setUsername] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [role, setRole] = useState<Role>('editor')
  const [active, setActive] = useState(true)
  const [editableProfessionIds, setEditableProfessionIds] = useState<number[]>([])
  const [permissions, setPermissions] = useState<Permission[]>([])

  useEffect(() => {
    if (!user) return
    setUsername(user.username)
    setEmail(user.email ?? '')
    setPassword('')
    setRole(user.role)
    setActive(user.active)
    setEditableProfessionIds(user.editable_profession_ids)
    setPermissions(user.permissions)
  }, [user])

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle>Editar usuario</DialogTitle>
      <DialogContent dividers>
        <Stack spacing={2.5} mt={1}>
          {error && <Alert severity="error">{error.message}</Alert>}
          <Box className="field-grid">
            <TextField
              label="Nombre de usuario"
              value={username}
              disabled={!canEditUsers}
              onChange={(event) => setUsername(event.target.value)}
              autoFocus
            />
            <TextField
              label="Correo electrónico"
              type="email"
              value={email}
              disabled={!canEditUsers}
              onChange={(event) => setEmail(event.target.value)}
              helperText="Opcional"
            />
            <TextField
              label="Nueva contraseña"
              type="password"
              value={password}
              disabled={!canEditUsers}
              onChange={(event) => setPassword(event.target.value)}
              helperText="Vacía conserva la actual; mínimo 12 caracteres."
            />
            <TextField
              select
              label="Rol descriptivo"
              value={role}
              disabled={!canEditUsers}
              onChange={(event) => setRole(event.target.value as Role)}
            >
              {Object.entries(roleLabels)
                .filter(([value]) => canGrantSystemPermissions || value !== 'admin')
                .map(([value, label]) => (
                <MenuItem key={value} value={value}>{label}</MenuItem>
                ))}
            </TextField>
          </Box>
          <FormControlLabel
            className="user-active-toggle"
            control={<Switch
              checked={active}
              disabled={!canEditUsers}
              onChange={(event) => setActive(event.target.checked)}
            />}
            label="Usuario activo"
          />
          <ProfessionChecklist
            professions={professions}
            selected={editableProfessionIds}
            disabled={!canEditUsers}
            onChange={setEditableProfessionIds}
          />
          <PermissionChecklist
            permissions={permissions}
            disabled={!canGrantSystemPermissions}
            onChange={setPermissions}
          />
          {user?.mfa_enabled && <Box className="user-danger-zone">
            <Box>
              <Typography variant="subtitle2">Restablecer segundo factor</Typography>
              <Typography variant="caption" color="text.secondary">
                Retira el segundo factor y cierra todas las sesiones de este usuario.
              </Typography>
            </Box>
            <Tooltip title={canResetMfa
              ? 'Restablecer el segundo factor de este usuario'
              : 'Solo otro administrador puede restablecerlo'}>
              <span>
                <Button
                  color="warning"
                  variant="outlined"
                  disabled={!canResetMfa}
                  onClick={onResetMfa}
                >
                  Restablecer MFA
                </Button>
              </span>
            </Tooltip>
          </Box>}
          {canEditUsers && <Box className="user-danger-zone">
            <Box>
              <Typography variant="subtitle2">Eliminar usuario</Typography>
              <Typography variant="caption" color="text.secondary">
                Elimina permanentemente el perfil, sus sesiones y sus permisos del panel.
              </Typography>
            </Box>
            <Tooltip title={deleteDisabledReason ?? 'Eliminar permanentemente este usuario'}>
              <span>
                <Button
                  color="error"
                  variant="outlined"
                  disabled={!canDelete}
                  onClick={onDelete}
                >
                  Eliminar usuario
                </Button>
              </span>
            </Tooltip>
          </Box>}
        </Stack>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancelar</Button>
        <Button
          variant="contained"
          disabled={
            !canEditUsers
            || saving
            || username.length < 3
            || (password.length > 0 && password.length < 12)
          }
          onClick={() => onSave({
            username,
            email: email.trim() || null,
            role,
            active,
            editable_profession_ids: editableProfessionIds,
            ...(canGrantSystemPermissions ? { permissions } : {}),
            ...(password ? { password } : {}),
          })}
        >
          Guardar
        </Button>
      </DialogActions>
    </Dialog>
  )
}


function Users({
  currentUserId,
  currentUserRole,
  canEditUsers,
}: {
  currentUserId: number
  currentUserRole: Role
  canEditUsers: boolean
}) {
  const client = useQueryClient()
  const users = useQuery({ queryKey: ['users'], queryFn: () => api<User[]>('/admin/users') })
  const references = useQuery({
    queryKey: ['references'],
    queryFn: () => api<References>('/references'),
  })
  const [username, setUsername] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [role, setRole] = useState<Role>('editor')
  const [editableProfessionIds, setEditableProfessionIds] = useState<number[]>([])
  const [creatingUser, setCreatingUser] = useState(false)
  const canGrantSystemPermissions = currentUserRole === 'admin'
  const [permissions, setPermissions] = useState<Permission[]>(
    canGrantSystemPermissions ? rolePermissionPresets.editor : [],
  )
  const [editingUser, setEditingUser] = useState<User | null>(null)
  const [deletingUser, setDeletingUser] = useState<User | null>(null)
  const [resettingMfaUser, setResettingMfaUser] = useState<User | null>(null)

  const openCreateUser = () => {
    create.reset()
    setUsername('')
    setEmail('')
    setPassword('')
    setRole('editor')
    setEditableProfessionIds(
      (references.data?.professions ?? []).map((profession) => profession.id),
    )
    setPermissions(canGrantSystemPermissions ? rolePermissionPresets.editor : [])
    setCreatingUser(true)
  }

  const applyRolePreset = (nextRole: Role) => {
    setRole(nextRole)
    if (canGrantSystemPermissions) setPermissions(rolePermissionPresets[nextRole])
    setEditableProfessionIds(
      ['admin', 'technical', 'editor'].includes(nextRole)
        ? (references.data?.professions ?? []).map((profession) => profession.id)
        : [],
    )
  }
  const create = useMutation({
    mutationFn: () => api<User>('/admin/users', {
      method: 'POST',
      body: JSON.stringify({
        username,
        email: email.trim() || null,
        password,
        role,
        active: true,
        editable_profession_ids: editableProfessionIds,
        ...(canGrantSystemPermissions ? { permissions } : {}),
      }),
    }),
    onSuccess: () => {
      setCreatingUser(false)
      client.invalidateQueries({ queryKey: ['users'] })
    },
  })
  const update = useMutation({
    mutationFn: ({ userId, changes }: { userId: number; changes: UserChanges }) => api<User>(
      `/admin/users/${userId}`,
      { method: 'PATCH', body: JSON.stringify(changes) },
    ),
    onSuccess: (_, variables) => {
      setEditingUser(null)
      client.invalidateQueries({ queryKey: ['users'] })
      if (variables.userId === currentUserId) {
        client.invalidateQueries({ queryKey: ['session'] })
      }
    },
  })
  const remove = useMutation({
    mutationFn: (userId: number) => api<void>(`/admin/users/${userId}`, {
      method: 'DELETE',
    }),
    onSuccess: () => {
      setDeletingUser(null)
      setEditingUser(null)
      client.invalidateQueries({ queryKey: ['users'] })
    },
  })
  const resetMfa = useMutation({
    mutationFn: (userId: number) => api<void>(`/admin/users/${userId}/mfa`, {
      method: 'DELETE',
    }),
    onSuccess: () => {
      setResettingMfaUser(null)
      setEditingUser(null)
      client.invalidateQueries({ queryKey: ['users'] })
    },
  })
  return (
    <Stack spacing={3}>
      <Box className="section-heading">
        <Box>
          <Typography variant="h4">Usuarios del sistema</Typography>
          <Typography color="text.secondary">
            Los roles son descriptivos; el acceso efectivo depende de los permisos asignados.
          </Typography>
        </Box>
        {canEditUsers && <Button
          variant="contained"
          startIcon={<AddIcon />}
          disabled={references.isLoading}
          onClick={openCreateUser}
        >
          Crear usuario
        </Button>}
      </Box>
      {(users.error || references.error) && (
        <Alert severity="error">
          {(users.error || references.error)?.message}
        </Alert>
      )}
      <TableContainer component={Paper}>
        <Table size="small">
          <TableHead><TableRow>
            <TableCell>Usuario</TableCell><TableCell>Correo</TableCell><TableCell>Rol</TableCell>
            <TableCell>Permisos</TableCell><TableCell>Oficios editables</TableCell>
            <TableCell>Estado</TableCell><TableCell>MFA</TableCell>
            <TableCell>Fecha de creación</TableCell>
            {canEditUsers && <TableCell align="right">Acciones</TableCell>}
          </TableRow></TableHead>
          <TableBody>{users.data?.map((user) => <TableRow key={user.user_id}>
            <TableCell>{user.username}</TableCell>
            <TableCell>{user.email ?? '—'}</TableCell>
            <TableCell>{roleLabels[user.role]}</TableCell>
            <TableCell>
              <Tooltip title={user.permissions.map(
                (permission) => permissionLabels[permission],
              ).join(', ') || 'Sin permisos'}>
                <span>{user.permissions.length} permisos</span>
              </Tooltip>
            </TableCell>
            <TableCell>
              {references.data?.professions
                .filter((profession) => user.editable_profession_ids.includes(profession.id))
                .map((profession) => profession.display_name)
                .join(', ') || 'Ninguno'}
            </TableCell>
            <TableCell>
              <Chip
                size="small"
                label={user.active ? 'Activo' : 'Inactivo'}
                color={user.active ? 'success' : 'default'}
                variant="outlined"
              />
            </TableCell>
            <TableCell>
              <Chip
                size="small"
                label={user.mfa_enabled ? 'Activado' : 'No activado'}
                color={user.mfa_enabled ? 'success' : 'default'}
                variant="outlined"
              />
            </TableCell>
            <TableCell>{new Date(user.created_at).toLocaleString('es-ES')}</TableCell>
            {canEditUsers && <TableCell align="right">
              <Tooltip title={
                user.role === 'admin' && !canGrantSystemPermissions
                  ? 'Solo un administrador puede modificar este perfil'
                  : 'Editar usuario'
              }>
                <span><IconButton
                  disabled={user.role === 'admin' && !canGrantSystemPermissions}
                  onClick={() => {
                    update.reset()
                    remove.reset()
                    setEditingUser(user)
                  }}
                ><EditIcon /></IconButton></span>
              </Tooltip>
            </TableCell>}
          </TableRow>)}</TableBody>
        </Table>
      </TableContainer>
      <Dialog
        open={creatingUser}
        onClose={() => !create.isPending && setCreatingUser(false)}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>Crear usuario</DialogTitle>
        <DialogContent dividers>
          <Stack spacing={2.5} mt={1}>
            {create.error && <Alert severity="error">{create.error.message}</Alert>}
            <Box className="field-grid user-field-grid">
              <TextField
                label="Nombre de usuario"
                value={username}
                onChange={(event) => setUsername(event.target.value)}
                autoFocus
              />
              <TextField
                label="Correo electrónico"
                type="email"
                value={email}
                onChange={(event) => setEmail(event.target.value)}
                helperText="Opcional"
              />
              <TextField
                label="Contraseña temporal"
                type="password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                helperText="Mínimo 12 caracteres."
              />
              <TextField
                select
                label="Rol descriptivo"
                value={role}
                onChange={(event) => applyRolePreset(event.target.value as Role)}
              >
                {Object.entries(roleLabels)
                  .filter(([value]) => canGrantSystemPermissions || value !== 'admin')
                  .map(([value, label]) => (
                    <MenuItem key={value} value={value}>{label}</MenuItem>
                  ))}
              </TextField>
            </Box>
            <ProfessionChecklist
              professions={references.data?.professions ?? []}
              selected={editableProfessionIds}
              onChange={setEditableProfessionIds}
            />
            <PermissionChecklist
              permissions={permissions}
              disabled={!canGrantSystemPermissions}
              onChange={setPermissions}
            />
          </Stack>
        </DialogContent>
        <DialogActions>
          <Button disabled={create.isPending} onClick={() => setCreatingUser(false)}>
            Cancelar
          </Button>
          <Button
            variant="contained"
            disabled={create.isPending || username.length < 3 || password.length < 12}
            onClick={() => create.mutate()}
          >
            Crear usuario
          </Button>
        </DialogActions>
      </Dialog>
      <UserEditorDialog
        user={editingUser}
        professions={references.data?.professions ?? []}
        canEditUsers={canEditUsers}
        canGrantSystemPermissions={canGrantSystemPermissions}
        canDelete={Boolean(
          editingUser
          && editingUser.user_id !== currentUserId
          && (editingUser.role !== 'admin' || canGrantSystemPermissions)
        )}
        canResetMfa={Boolean(
          editingUser?.mfa_enabled
          && currentUserRole === 'admin'
          && editingUser.user_id !== currentUserId
        )}
        deleteDisabledReason={editingUser?.user_id === currentUserId
          ? 'No puedes eliminar tu propio usuario'
          : editingUser?.role === 'admin' && !canGrantSystemPermissions
            ? 'Solo un administrador puede eliminar otro administrador'
            : null}
        open={editingUser !== null}
        error={update.error}
        onClose={() => {
          update.reset()
          setEditingUser(null)
        }}
        onDelete={() => {
          remove.reset()
          if (editingUser) setDeletingUser(editingUser)
        }}
        onResetMfa={() => {
          resetMfa.reset()
          if (editingUser) setResettingMfaUser(editingUser)
        }}
        onSave={(changes) => editingUser
          && update.mutate({ userId: editingUser.user_id, changes })}
        saving={update.isPending}
      />
      <Dialog
        open={resettingMfaUser !== null}
        onClose={() => !resetMfa.isPending && setResettingMfaUser(null)}
        maxWidth="xs"
        fullWidth
      >
        <DialogTitle>Restablecer segundo factor</DialogTitle>
        <DialogContent dividers>
          <Stack spacing={2}>
            <Alert severity="warning">
              El usuario tendrá que configurar de nuevo su aplicación de autenticación.
            </Alert>
            <Typography>
              Se retirará el segundo factor de <strong>{resettingMfaUser?.username}</strong> y se
              cerrarán todas sus sesiones.
            </Typography>
            {resetMfa.error && <Alert severity="error">{resetMfa.error.message}</Alert>}
          </Stack>
        </DialogContent>
        <DialogActions>
          <Button disabled={resetMfa.isPending} onClick={() => setResettingMfaUser(null)}>
            Cancelar
          </Button>
          <Button
            color="warning"
            variant="contained"
            disabled={!resettingMfaUser || resetMfa.isPending}
            onClick={() => resettingMfaUser && resetMfa.mutate(resettingMfaUser.user_id)}
          >
            Restablecer
          </Button>
        </DialogActions>
      </Dialog>
      <Dialog
        open={deletingUser !== null}
        onClose={() => {
          if (!remove.isPending) {
            remove.reset()
            setDeletingUser(null)
          }
        }}
        maxWidth="xs"
        fullWidth
      >
        <DialogTitle>Eliminar usuario</DialogTitle>
        <DialogContent dividers>
          <Stack spacing={2}>
            <Alert severity="error">
              Esta acción es permanente y no puede deshacerse.
            </Alert>
            <Typography>
              Se eliminará el usuario <strong>{deletingUser?.username}</strong>, junto con sus
              sesiones, permisos y oficios asignados.
            </Typography>
            {remove.error && <Alert severity="error">{remove.error.message}</Alert>}
          </Stack>
        </DialogContent>
        <DialogActions>
          <Button
            disabled={remove.isPending}
            onClick={() => {
              remove.reset()
              setDeletingUser(null)
            }}
          >
            Cancelar
          </Button>
          <Button
            color="error"
            variant="contained"
            disabled={!deletingUser || remove.isPending}
            onClick={() => deletingUser && remove.mutate(deletingUser.user_id)}
          >
            Eliminar definitivamente
          </Button>
        </DialogActions>
      </Dialog>
    </Stack>
  )
}


function AuditLog() {
  const [page, setPage] = useState(0)
  const [rowsPerPage, setRowsPerPage] = useState(50)
  const [selectedEntry, setSelectedEntry] = useState<AuditEntry | null>(null)
  const audit = useQuery({
    queryKey: ['audit', page, rowsPerPage],
    queryFn: () => api<AuditPage>(
      `/admin/audit?offset=${page * rowsPerPage}&limit=${rowsPerPage}`,
    ),
  })

  return (
    <Stack spacing={3}>
      <Box className="section-heading">
        <Box>
          <Typography variant="h4">Auditoría</Typography>
          <Typography color="text.secondary">
            Historial administrativo de recetas, cuentas, personajes y usuarios del sistema.
          </Typography>
        </Box>
      </Box>
      {audit.error && <Alert severity="error">{audit.error.message}</Alert>}
      <TableContainer component={Paper}>
        <Table size="small">
          <TableHead>
            <TableRow>
              <TableCell>Fecha</TableCell>
              <TableCell>Área</TableCell>
              <TableCell>Elemento</TableCell>
              <TableCell>Acción</TableCell>
              <TableCell>Realizada por</TableCell>
              <TableCell align="right">Detalle</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {audit.isLoading && <TableRow>
              <TableCell colSpan={6} align="center"><CircularProgress size={24} /></TableCell>
            </TableRow>}
            {!audit.isLoading && audit.data?.items.length === 0 && <TableRow>
              <TableCell colSpan={6} align="center">No hay cambios registrados.</TableCell>
            </TableRow>}
            {audit.data?.items.map((entry) => <TableRow key={entry.revision_key} hover>
              <TableCell>{new Date(entry.changed_at).toLocaleString('es-ES')}</TableCell>
              <TableCell>
                <Chip
                  size="small"
                  variant="outlined"
                  label={auditDomainLabels[entry.domain]}
                />
              </TableCell>
              <TableCell>{entry.target_label}</TableCell>
              <TableCell>{auditActionLabels[entry.action] ?? entry.action}</TableCell>
              <TableCell>
                {entry.actor_username ?? 'Usuario eliminado'}
              </TableCell>
              <TableCell align="right">
                <Button size="small" variant="outlined" onClick={() => setSelectedEntry(entry)}>
                  Ver cambio
                </Button>
              </TableCell>
            </TableRow>)}
          </TableBody>
        </Table>
        <TablePagination
          component="div"
          count={audit.data?.total ?? 0}
          page={page}
          rowsPerPage={rowsPerPage}
          rowsPerPageOptions={[25, 50, 100]}
          labelRowsPerPage="Filas por página"
          onPageChange={(_, nextPage) => setPage(nextPage)}
          onRowsPerPageChange={(event) => {
            setRowsPerPage(Number(event.target.value))
            setPage(0)
          }}
        />
      </TableContainer>
      <Dialog
        open={selectedEntry !== null}
        onClose={() => setSelectedEntry(null)}
        maxWidth="lg"
        fullWidth
      >
        <DialogTitle>Detalle de auditoría</DialogTitle>
        <DialogContent dividers>
          {selectedEntry && <Stack spacing={2.5}>
            <Box className="audit-detail-summary">
              <Box>
                <Typography variant="caption" color="text.secondary">Elemento</Typography>
                <Typography>{selectedEntry.target_label}</Typography>
              </Box>
              <Box>
                <Typography variant="caption" color="text.secondary">Acción</Typography>
                <Typography>
                  {auditActionLabels[selectedEntry.action] ?? selectedEntry.action}
                </Typography>
              </Box>
              <Box>
                <Typography variant="caption" color="text.secondary">Realizada por</Typography>
                <Typography>{selectedEntry.actor_username ?? 'Usuario eliminado'}</Typography>
              </Box>
              <Box>
                <Typography variant="caption" color="text.secondary">Fecha</Typography>
                <Typography>
                  {new Date(selectedEntry.changed_at).toLocaleString('es-ES')}
                </Typography>
              </Box>
            </Box>
            {selectedEntry.note && <Alert severity="info">{selectedEntry.note}</Alert>}
            <Box className="audit-snapshot-grid">
              <Paper className="audit-snapshot" variant="outlined">
                <Typography variant="subtitle2">Estado anterior</Typography>
                <Box component="pre" className="audit-json">
                  {Object.keys(selectedEntry.before).length
                    ? JSON.stringify(selectedEntry.before, null, 2)
                    : 'Sin estado anterior'}
                </Box>
              </Paper>
              <Paper className="audit-snapshot" variant="outlined">
                <Typography variant="subtitle2">Estado posterior</Typography>
                <Box component="pre" className="audit-json">
                  {Object.keys(selectedEntry.after).length
                    ? JSON.stringify(selectedEntry.after, null, 2)
                    : 'Sin estado posterior'}
                </Box>
              </Paper>
            </Box>
          </Stack>}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setSelectedEntry(null)}>Cerrar</Button>
        </DialogActions>
      </Dialog>
    </Stack>
  )
}


export default function App() {
  const client = useQueryClient()
  const session = useQuery<Session | null>({
    queryKey: ['session'],
    queryFn: () => api<Session>('/auth/me'),
  })
  const [activeTab, setActiveTab] = useState<
    'recipes' | 'identity' | 'users' | 'dm-access' | 'audit'
  >('recipes')
  const [securityOpen, setSecurityOpen] = useState(false)
  const logout = useMutation({
    mutationFn: () => api<void>('/auth/logout', { method: 'POST' }),
    onSuccess: () => client.setQueryData<Session | null>(['session'], null),
  })
  useEffect(() => {
    const permissions = session.data?.user.permissions ?? []
    const availableTabs = [
      permissions.includes('view_recipes') ? 'recipes' : null,
      permissions.includes('view_accounts') ? 'identity' : null,
      permissions.includes('view_users') ? 'users' : null,
      ['admin', 'technical'].includes(session.data?.user.role ?? '') ? 'dm-access' : null,
      session.data?.user.role === 'admin' ? 'audit' : null,
    ].filter(
      (value): value is 'recipes' | 'identity' | 'users' | 'dm-access' | 'audit' => (
        value !== null
      ),
    )
    if (availableTabs.length > 0 && !availableTabs.includes(activeTab)) {
      setActiveTab(availableTabs[0])
    }
  }, [activeTab, session.data])
  if (session.isLoading) return <Box className="center"><CircularProgress /></Box>
  if (!session.data) return <Login onLogin={(value) => client.setQueryData(['session'], value)} />
  const { user } = session.data
  const canViewRecipes = user.permissions.includes('view_recipes')
  const canViewIdentity = user.permissions.includes('view_accounts')
  const canViewUsers = user.permissions.includes('view_users')
  const canEditUsers = user.permissions.includes('edit_users')
  const canManageDmAccess = user.role === 'admin' || user.role === 'technical'
  const canViewAudit = user.role === 'admin'
  return (
    <Box className="app-shell">
      <AppBar position="static" color="transparent" elevation={0} className="control-bar"><Toolbar className="control-toolbar">
        <Box className="compact-brand">
          <Box className="brand-mark brand-mark-small" aria-hidden="true"><span /></Box>
          <Box>
            <Typography variant="h6">{panelTitle}</Typography>
            <Typography variant="caption" color="text.secondary">{panelSubtitle}</Typography>
          </Box>
        </Box>
        <Box className="session-summary">
          <Chip size="small" label={roleLabels[session.data.user.role]} color="primary" variant="outlined" />
          <Typography>{session.data.user.username}</Typography>
        </Box>
        <Tooltip title="Seguridad de la cuenta">
          <IconButton aria-label="Seguridad de la cuenta" onClick={() => setSecurityOpen(true)}>
            <SecurityIcon />
          </IconButton>
        </Tooltip>
        <Tooltip title="Cerrar sesión"><IconButton onClick={() => logout.mutate()}><LogoutIcon /></IconButton></Tooltip>
      </Toolbar></AppBar>
      <Container maxWidth="xl" className="content-shell">
        <Paper className="primary-nav" elevation={0}>
        <Tabs
          value={activeTab}
          onChange={(_, value) => setActiveTab(value)}
          variant="scrollable"
          scrollButtons={false}
        >
          {canViewRecipes && <Tab value="recipes" label="Recetas" />}
          {canViewIdentity && <Tab value="identity" label="Cuentas y personajes" />}
          {canViewUsers && <Tab value="users" label="Usuarios del sistema" />}
          {canManageDmAccess && <Tab value="dm-access" label="Administración DM" />}
          {canViewAudit && <Tab value="audit" label="Auditoría" />}
        </Tabs>
        </Paper>
        <Box className="workspace-scroll">
          {activeTab === 'recipes' && canViewRecipes ? (
            <Recipes writesEnabled={session.data.writes_enabled} user={user} />
          ) : activeTab === 'identity' && canViewIdentity ? (
            <Accounts permissions={user.permissions} role={user.role} />
          ) : activeTab === 'users' && canViewUsers ? (
            <Users
              currentUserId={user.user_id}
              currentUserRole={user.role}
              canEditUsers={canEditUsers}
            />
          ) : activeTab === 'audit' && canViewAudit ? (
            <AuditLog />
          ) : activeTab === 'dm-access' && canManageDmAccess ? (
            <DmAccess />
          ) : (
            <Alert severity="warning">Tu perfil no tiene secciones visibles asignadas.</Alert>
          )}
        </Box>
      </Container>
      <SecurityDialog
        open={securityOpen}
        user={user}
        onClose={() => setSecurityOpen(false)}
        onEnabled={() => client.setQueryData<Session>(['session'], (current) => current ? {
          ...current,
          user: { ...current.user, mfa_enabled: true },
        } : current)}
        onDisabled={() => {
          setSecurityOpen(false)
          client.setQueryData<Session | null>(['session'], null)
        }}
      />
    </Box>
  )
}
