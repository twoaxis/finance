import React from 'react'
import styled from 'styled-components'
import { LoginForm } from '../molecules/LoginForm'
import type { AuthView } from '../types'



const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
`

interface LoginCardProps {
  onViewChange: (view: AuthView) => void
}

export const LoginCard: React.FC<LoginCardProps> = ({ onViewChange }) => (
  <Wrapper>
    <LoginForm />
  </Wrapper>
)
