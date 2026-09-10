import { FormEvent, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  Alert,
  Box,
  Button,
  Chip,
  CircularProgress,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Paper,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
  Typography,
} from '@mui/material'
import DeleteIcon from '@mui/icons-material/Delete'
import { api } from './api'
import type { DmCdKeyWhitelistEntry } from './types'


export function DmAccess() {
  const queryClient = useQueryClient()
  const [cdKey, setCdKey] = useState('')
  const [displayName, setDisplayName] = useState('')
  const [removing, setRemoving] = useState<DmCdKeyWhitelistEntry | null>(null)
  const whitelist = useQuery({
    queryKey: ['dm-access-whitelist'],
    queryFn: () => api<DmCdKeyWhitelistEntry[]>('/admin/dm-access/whitelist'),
  })
  const addEntry = useMutation({
    mutationFn: () => api<DmCdKeyWhitelistEntry>('/admin/dm-access/whitelist', {
      method: 'POST',
      body: JSON.stringify({ cd_key: cdKey, display_name: displayName || null }),
    }),
    onSuccess: async () => {
      setCdKey('')
      setDisplayName('')
      await queryClient.invalidateQueries({ queryKey: ['dm-access-whitelist'] })
      await queryClient.invalidateQueries({ queryKey: ['audit'] })
    },
  })
  const removeEntry = useMutation({
    mutationFn: (entry: DmCdKeyWhitelistEntry) => api<void>(
      `/admin/dm-access/whitelist/${encodeURIComponent(entry.cd_key)}`,
      { method: 'DELETE' },
    ),
    onSuccess: async () => {
      setRemoving(null)
      await queryClient.invalidateQueries({ queryKey: ['dm-access-whitelist'] })
      await queryClient.invalidateQueries({ queryKey: ['audit'] })
    },
  })

  function submit(event: FormEvent) {
    event.preventDefault()
    addEntry.mutate()
  }

  return (
    <Stack spacing={3}>
      <Box className="section-heading">
        <Box>
          <Typography variant="h4">Administración DM</Typography>
          <Typography color="text.secondary">
            CD keys autorizadas para conectar como Dungeon Master.
          </Typography>
        </Box>
      </Box>
      <Alert severity="warning">
        La contraseña DM no basta por sí sola. Una conexión DM solo recibe la lista de
        avatares si su CD key figura aquí y no tiene un baneo global activo. Una lista vacía
        bloquea todas las conexiones DM.
      </Alert>
      <Paper variant="outlined">
        <Box component="form" onSubmit={submit} p={3}>
          <Stack direction={{ xs: 'column', md: 'row' }} spacing={2} alignItems="start">
            <TextField
              label="CD key pública"
              value={cdKey}
              onChange={(event) => setCdKey(event.target.value.toUpperCase())}
              inputProps={{ maxLength: 16 }}
              required
              helperText="Entre 1 y 16 caracteres alfanuméricos."
            />
            <TextField
              label="Identificación"
              value={displayName}
              onChange={(event) => setDisplayName(event.target.value)}
              inputProps={{ maxLength: 64 }}
              helperText="Nombre interno opcional del DM."
            />
            <Button
              type="submit"
              variant="contained"
              disabled={addEntry.isPending || !cdKey.trim()}
            >
              Autorizar CD key
            </Button>
          </Stack>
          {addEntry.error && <Alert severity="error" sx={{ mt: 2 }}>
            {addEntry.error.message}
          </Alert>}
        </Box>
      </Paper>
      {whitelist.error && <Alert severity="error">{whitelist.error.message}</Alert>}
      <TableContainer component={Paper}>
        <Table size="small">
          <TableHead>
            <TableRow>
              <TableCell>CD key</TableCell>
              <TableCell>Identificación</TableCell>
              <TableCell>Estado</TableCell>
              <TableCell>Autorizada</TableCell>
              <TableCell align="right">Acción</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {whitelist.isLoading && <TableRow>
              <TableCell colSpan={5} align="center"><CircularProgress size={24} /></TableCell>
            </TableRow>}
            {!whitelist.isLoading && whitelist.data?.length === 0 && <TableRow>
              <TableCell colSpan={5} align="center">
                No hay ninguna CD key autorizada. Todas las conexiones DM quedan bloqueadas.
              </TableCell>
            </TableRow>}
            {whitelist.data?.map((entry) => <TableRow key={entry.cd_key} hover>
              <TableCell><strong>{entry.cd_key}</strong></TableCell>
              <TableCell>{entry.display_name ?? 'Sin identificación'}</TableCell>
              <TableCell>
                <Chip
                  size="small"
                  color={entry.globally_banned ? 'error' : 'success'}
                  label={entry.globally_banned ? 'Baneada globalmente' : 'Autorizada'}
                />
              </TableCell>
              <TableCell>{new Date(entry.added_at).toLocaleString('es-ES')}</TableCell>
              <TableCell align="right">
                <Button
                  color="error"
                  size="small"
                  startIcon={<DeleteIcon />}
                  onClick={() => {
                    removeEntry.reset()
                    setRemoving(entry)
                  }}
                >
                  Retirar
                </Button>
              </TableCell>
            </TableRow>)}
          </TableBody>
        </Table>
      </TableContainer>
      <Dialog
        open={removing !== null}
        onClose={() => !removeEntry.isPending && setRemoving(null)}
        maxWidth="xs"
        fullWidth
      >
        <DialogTitle>Retirar acceso DM</DialogTitle>
        <DialogContent dividers>
          <Stack spacing={2}>
            <Alert severity="warning">
              La CD key dejará de poder conectar como DM de inmediato en su siguiente intento.
              Si retiras la última, ningún DM podrá acceder.
            </Alert>
            <Typography>
              ¿Retirar <strong>{removing?.cd_key}</strong> de la whitelist?
            </Typography>
            {removeEntry.error && <Alert severity="error">{removeEntry.error.message}</Alert>}
          </Stack>
        </DialogContent>
        <DialogActions>
          <Button disabled={removeEntry.isPending} onClick={() => setRemoving(null)}>
            Cancelar
          </Button>
          <Button
            color="error"
            variant="contained"
            disabled={!removing || removeEntry.isPending}
            onClick={() => removing && removeEntry.mutate(removing)}
          >
            Retirar acceso
          </Button>
        </DialogActions>
      </Dialog>
    </Stack>
  )
}
