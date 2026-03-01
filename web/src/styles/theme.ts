import { createGlobalStyle } from 'styled-components'

export const theme = {
  colors: {
    bg: '#111111',
    bgCard: '#1a1a1a',
    bgInput: '#1E1E1E',
    red: '#A72222',
    redHover: 'rgb(94, 25, 25)',
    
    white: '#ffffff',
    border: '#2a2a2a',
    muted: '#646464',
    overmuted:'#626262',
    borderFocus: '#c0392b',
    text: '#e8e8e8',
    google: '#141414',
  },
  fonts: {
    display: "'Sen', sans-serif",
    body: "'Sen', sans-serif",
  },
  radii: {
    sm: '6px',
    md: '10px',
    lg: '14px',
    full: '999px',
  },
  transitions: {
    fast: '0.15s ease',
    normal: '0.25s ease',
  },
}

export type Theme = typeof theme

export const GlobalStyles = createGlobalStyle<{ theme: Theme }>`
  *, *::before, *::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  html, body, #root {
    height: 100%;
    width: 100%;
  }

  body {
    font-family: ${({ theme }) => theme.fonts.body};
    background: ${({ theme }) => theme.colors.bg};
    color: ${({ theme }) => theme.colors.text};
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  a {
    color: inherit;
    text-decoration: none;
  }

  button {
    font-family: inherit;
    cursor: pointer;
    border: none;
    outline: none;
    background: none;
  }

  input {
    font-family: inherit;
    outline: none;
    border: none;
    background: none;
  }
`
