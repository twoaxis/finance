import React, { useState } from 'react'
import { AuthLayout } from '../templates/AuthLayout'
import { LandingCard } from '../organisms/LandingCard'
import { LoginCard } from '../organisms/LoginCard'
import { RegisterCard } from '../organisms/RegisterCard'
import type { AuthView } from '../types'

const subtitleMap: Record<AuthView, string> = {
  landing: 'Your key to riches.',
  login: 'Login to your account',
  register: 'Create an Account',
}

export const AuthPage: React.FC = () => {
  const [view, setView] = useState<AuthView>('landing')

  return (
    <AuthLayout subtitle={subtitleMap[view]}>
      {view === 'landing' && <LandingCard onViewChange={setView} />}
      {view === 'login' && <LoginCard onViewChange={setView} />}
      {view === 'register' && <RegisterCard onViewChange={setView} />}
    </AuthLayout>
  )
}
