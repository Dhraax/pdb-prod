import type { Permission, Role } from './types'


export const permissionLabels: Record<Permission, string> = {
  view_recipes: 'Ver recetas',
  edit_recipes: 'Editar recetas',
  view_users: 'Ver usuarios del panel',
  edit_users: 'Editar usuarios del panel',
  view_accounts: 'Ver cuentas de juego',
  edit_accounts: 'Editar cuentas de juego',
  activate_cd_keys: 'Gestionar recapturas de CD key',
  view_characters: 'Ver personajes',
  view_character_identity: 'Ver identidad y estado',
  edit_character_identity: 'Editar identidad y estado',
  view_character_timestamps: 'Ver fechas y accesos',
  view_character_abilities: 'Ver características base',
  view_character_classes: 'Ver clases y niveles',
  view_character_level_unlocks: 'Ver cortes de nivel',
  edit_character_level_unlocks: 'Conceder cortes de nivel',
  view_character_profile: 'Ver perfil técnico',
  edit_character_profile: 'Editar perfil técnico',
  view_character_tradeskills: 'Ver oficios del personaje',
  edit_character_tradeskills: 'Editar oficios del personaje',
}

export const permissionGroups: Array<{
  label: string
  description: string
  permissions: Permission[]
}> = [
  {
    label: 'Recetas',
    description: 'Acceso al catálogo y autorización de escritura.',
    permissions: ['view_recipes', 'edit_recipes'],
  },
  {
    label: 'Usuarios del panel',
    description: 'Consulta y mantenimiento de los perfiles que acceden al panel.',
    permissions: ['view_users', 'edit_users'],
  },
  {
    label: 'Cuentas de juego',
    description: 'Consulta, bloqueo y recuperación controlada de claves.',
    permissions: ['view_accounts', 'edit_accounts', 'activate_cd_keys'],
  },
  {
    label: 'Personajes: acceso general',
    description: 'Habilita la lista de personajes dentro de cada cuenta.',
    permissions: ['view_characters'],
  },
  {
    label: 'Personajes: secciones de la ficha',
    description: 'Cada bloque se oculta o se habilita de forma independiente.',
    permissions: [
      'view_character_identity',
      'edit_character_identity',
      'view_character_timestamps',
      'view_character_abilities',
      'view_character_classes',
      'view_character_level_unlocks',
      'edit_character_level_unlocks',
      'view_character_profile',
      'edit_character_profile',
      'view_character_tradeskills',
      'edit_character_tradeskills',
    ],
  },
]

export const permissionDependencies: Partial<Record<Permission, Permission[]>> = {
  edit_recipes: ['view_recipes'],
  edit_users: ['view_users'],
  edit_accounts: ['view_accounts'],
  activate_cd_keys: ['view_accounts'],
  view_characters: ['view_accounts'],
  view_character_identity: ['view_accounts', 'view_characters'],
  edit_character_identity: ['view_character_identity'],
  view_character_timestamps: ['view_accounts', 'view_characters'],
  view_character_abilities: ['view_accounts', 'view_characters'],
  view_character_classes: ['view_accounts', 'view_characters'],
  view_character_level_unlocks: ['view_accounts', 'view_characters'],
  edit_character_level_unlocks: ['view_character_level_unlocks'],
  view_character_profile: ['view_accounts', 'view_characters'],
  edit_character_profile: ['view_character_profile'],
  view_character_tradeskills: ['view_accounts', 'view_characters'],
  edit_character_tradeskills: ['view_character_tradeskills'],
}

const allPermissions = Object.keys(permissionLabels) as Permission[]

export const rolePermissionPresets: Record<Role, Permission[]> = {
  admin: allPermissions.filter((permission) => permission !== 'activate_cd_keys'),
  technical: [...allPermissions],
  dungeon_master: allPermissions.filter(
    (permission) => permission.startsWith('view_') || permission === 'activate_cd_keys',
  ),
  editor: ['view_recipes', 'edit_recipes'],
  collaborator: ['view_recipes', 'edit_recipes'],
}


export function togglePermission(
  currentPermissions: Permission[],
  permission: Permission,
  checked: boolean,
): Permission[] {
  const selected = new Set(currentPermissions)
  if (checked) {
    const addWithDependencies = (candidate: Permission) => {
      selected.add(candidate)
      permissionDependencies[candidate]?.forEach(addWithDependencies)
    }
    addWithDependencies(permission)
  } else {
    selected.delete(permission)
    let changed = true
    while (changed) {
      changed = false
      for (const candidate of [...selected]) {
        if (permissionDependencies[candidate]?.some((required) => !selected.has(required))) {
          selected.delete(candidate)
          changed = true
        }
      }
    }
  }
  return allPermissions.filter((candidate) => selected.has(candidate))
}
