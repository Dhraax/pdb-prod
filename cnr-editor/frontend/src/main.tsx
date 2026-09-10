import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { CssBaseline, ThemeProvider, createTheme } from '@mui/material'
import App from './App'
import './styles.css'

const theme = createTheme({
  palette: {
    mode: 'dark',
    primary: { main: '#d47a43', light: '#efaa78', dark: '#9f4e2d' },
    secondary: { main: '#b7654f' },
    success: { main: '#72b28c' },
    warning: { main: '#df9b58' },
    error: { main: '#dc716a' },
    info: { main: '#c77b50' },
    background: { default: '#0d0b0b', paper: '#181414' },
    text: { primary: '#f2ece8', secondary: '#aaa09a' },
    divider: 'rgba(238, 184, 145, 0.11)',
  },
  typography: {
    fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Text", "Segoe UI", sans-serif',
    h2: { fontWeight: 680, letterSpacing: '-0.04em' },
    h4: { fontWeight: 680, letterSpacing: '-0.035em' },
    h5: { fontWeight: 650, letterSpacing: '-0.025em' },
    h6: { fontWeight: 650, letterSpacing: '-0.015em' },
    button: { textTransform: 'none', fontWeight: 650, letterSpacing: '-0.01em' },
  },
  shape: { borderRadius: 10 },
  components: {
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundImage: 'none',
          border: '1px solid rgba(238, 184, 145, 0.1)',
          boxShadow: '0 14px 38px rgba(0, 0, 0, 0.24)',
        },
      },
    },
    MuiButton: {
      defaultProps: { disableElevation: true },
      styleOverrides: { root: { borderRadius: 8, minHeight: 36 } },
    },
    MuiTextField: {
      defaultProps: { size: 'small' },
    },
    MuiOutlinedInput: {
      styleOverrides: {
        root: {
          borderRadius: 7,
          backgroundColor: 'rgba(255, 228, 207, 0.032)',
        },
      },
    },
    MuiDialog: {
      styleOverrides: {
        paper: {
          borderRadius: 14,
          backgroundColor: 'rgba(24, 20, 19, 0.97)',
          backdropFilter: 'blur(24px) saturate(112%)',
        },
      },
    },
    MuiChip: {
      styleOverrides: { root: { borderRadius: 6, fontWeight: 650 } },
    },
    MuiTableCell: {
      styleOverrides: {
        head: {
          color: '#cbbdb4',
          fontSize: '0.72rem',
          fontWeight: 700,
          letterSpacing: '0.055em',
          textTransform: 'uppercase',
          backgroundColor: 'rgba(20, 17, 16, 0.96)',
        },
        root: { borderColor: 'rgba(238, 184, 145, 0.08)' },
      },
    },
    MuiTab: {
      styleOverrides: { root: { minHeight: 40, textTransform: 'none', fontWeight: 650 } },
    },
  },
})

const queryClient = new QueryClient({
  defaultOptions: { queries: { retry: false, staleTime: 15_000 } },
})

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <App />
      </ThemeProvider>
    </QueryClientProvider>
  </StrictMode>,
)
