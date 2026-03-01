import React from 'react'
import styled from 'styled-components'
import { RegisterForm } from '../molecules/RegisterForm'
import type { AuthView } from '../types'



const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  gap: 16px;
  width: 100%;
`

interface RegisterCardProps {
  onViewChange: (view: AuthView) => void
}

export const RegisterCard: React.FC<RegisterCardProps> = ({ onViewChange }) => (
  <Wrapper>
    <RegisterForm />
  </Wrapper>
)
