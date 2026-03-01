import React, { useState } from 'react'
import styled from 'styled-components'
import { Button } from '../atoms/Button'
import { Divider } from '../atoms/Divider'
import { GoogleButton } from '../molecules/GoogleButton'
import { useAuth } from '../context/AuthContext'
import { ErrorMessage } from '../atoms/ErrorMessage'
import type { AuthView } from '../types'

const Actions = styled.div`
  display: flex;
  flex-direction: column;
  gap: 10px;
  
`

interface LandingCardProps {
  onViewChange: (view: AuthView) => void
}

export const LandingCard: React.FC<LandingCardProps> = ({ onViewChange }) => {
  const { loginWithGoogle, error, clearError } = useAuth()
  const [googleLoading, setGoogleLoading] = useState(false)

  const handleGoogle = async () => {
    try {
      setGoogleLoading(true)
      clearError()
      await loginWithGoogle()
    } catch {
      // handled by context
    } finally {
      setGoogleLoading(false)
    }
  }

  return (
    <Actions>
      {error && <ErrorMessage message={error} />}
      <Button variant="primary" fullWidth onClick={() => onViewChange('login')}>
        Login to your account
      </Button>
      <Button variant="secondary" fullWidth onClick={() => onViewChange('register')}>
        Create an account
      </Button>
      <Divider label="Or" />
      <GoogleButton onClick={handleGoogle} loading={googleLoading} />
    </Actions>
  )
}
