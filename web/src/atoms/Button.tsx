import React from 'react'
import styled, { css, keyframes } from 'styled-components'

const spin = keyframes`
  to { transform: rotate(360deg); }
`

type Variant = 'primary' | 'secondary' | 'google'

interface StyledButtonProps {
  $variant: Variant
  $fullWidth?: boolean
  

}

const StyledButton = styled.button<StyledButtonProps>`
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  width: ${({ $fullWidth }) => ($fullWidth ? '100%' : '173px')};
  padding: 12px 24px;
  border-radius: ${({ theme }) => theme.radii.md};
  font-size: 0.875rem;
  font-weight: 500;
  letter-spacing: 0.02em;
  transition: all ${({ theme }) => theme.transitions.normal};
  position: relative;
  overflow: hidden;

  &:disabled {
    opacity: 0.55;
    cursor: not-allowed;
  }

  &::after {
    content: '';
    position: absolute;
    inset: 0;
    background: white;
    opacity: 0;
    transition: opacity ${({ theme }) => theme.transitions.fast};
  }

  &:not(:disabled):hover::after {
    opacity: 0.06;
  }

  &:not(:disabled):active::after {
    opacity: 0.1;
  }

  ${({ $variant, theme }) =>
    $variant === 'primary' &&
    css`
      background: ${theme.colors.red};
      color: ${theme.colors.white};
      box-shadow: 0 4px 20px hsla(6, 63%, 46%, 0.35);

      &:not(:disabled):hover {
        background: ${theme.colors.redHover};
         box-shadow: 0 8px 20px rgba(94, 25, 25, 0.35);
        
        transform: translateY(-1px);
      }
    `}

  ${({ $variant, theme }) =>
    $variant === 'secondary' &&
    css`
      background: ${theme.colors.bgInput};
      color: ${theme.colors.text};
      border: 1px solid ${theme.colors.border};

      &:not(:disabled):hover {
        border-color: ${theme.colors.muted};
        transform: translateY(-1px);
      }
    `}

  ${({ $variant, theme }) =>
    $variant === 'google' &&
    css`
      background: ${theme.colors.google};
      color: ${theme.colors.text};
      border: 1px solid ${theme.colors.border};

      &:not(:disabled):hover {
        border-color: ${theme.colors.muted};
        transform: translateY(-1px);
      }
    `}
`

const Spinner = styled.span`
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: ${spin} 0.7s linear infinite;
  display: inline-block;
`

interface ButtonProps {
  variant?: Variant
  fullWidth?: boolean
  loading?: boolean
  disabled?: boolean
  onClick?: () => void
  type?: 'button' | 'submit' | 'reset'
  children: React.ReactNode
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  fullWidth = false,
  loading = false,
  disabled,
  onClick,
  type = 'button',
  children,
}) => {
  return (
    <StyledButton
      $variant={variant}
      $fullWidth={fullWidth}
      disabled={disabled || loading}
      onClick={onClick}
      type={type}
    >
      {loading ? <Spinner /> : children}
    </StyledButton>
  )
}
