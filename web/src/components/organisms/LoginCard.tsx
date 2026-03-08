import React from 'react'
import styled from 'styled-components'
import { LoginForm } from './LoginForm'

const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  gap: 16px;
  width: 100%;
`

export const LoginCard: React.FC = () => (
  <Wrapper>
    <LoginForm/>
  </Wrapper>
)