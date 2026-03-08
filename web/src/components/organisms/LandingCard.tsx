import React, { useEffect, useState } from 'react'
import styled from 'styled-components'
import { Button } from '../atoms/Button'
import { Divider } from '../atoms/Divider'
import { GoogleButton } from '../atoms/GoogleButton'
import { useAuth } from '../../context/AuthContext'
import { ErrorMessage } from '../atoms/ErrorMessage'
import { useNavigate } from 'react-router-dom'
import { AUTH_ROUTES } from '../../routes/authRoutes'

const Actions = styled.div`
  display: flex;
  flex-direction: column;
  gap: 10px;
  
`

export const LandingCard: React.FC = () => {
  const { googleLogin, error, clearError } = useAuth()
  const navigate = useNavigate()
  const [googleLoading, setGoogleLoading] = useState(false)
  const{loading,user}=useAuth()

  const handleGoogle = async () => {
    try {
      setGoogleLoading(true)
      clearError()
      await googleLogin()
    } catch {
      // handled by context
    } finally {
      setGoogleLoading(false)
    }
  }
 useEffect(() => {
  if (user && !loading) {
    navigate("/dashboard"); 
  }
}, [user, loading]);
  return (
    <Actions>
      {error && <ErrorMessage message={error} />}
      <Button variant="primary" fullWidth onClick={() => navigate(AUTH_ROUTES.login)}>
        Login to your account
      </Button>
      <Button variant="secondary" fullWidth onClick={() => navigate(AUTH_ROUTES.register)}>
        Create an account
      </Button>
      <Divider label="Or" />
      <GoogleButton onClick={handleGoogle} loading={googleLoading} />
    </Actions>
  )
}
