import React from 'react'
import styled from 'styled-components'
import { useAuth } from '../../context/AuthContext'
import { Button } from '../atoms/Button'

const Page = styled.div`
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 24px;
  padding: 24px;
`

const Title = styled.h1`
  font-size: 3rem;
  letter-spacing: 0.04em;
`

const Subtitle = styled.p`
  font-size: 1rem;
`

const Badge = styled.span`
  background: rgba(192, 57, 43, 0.15);
  border: 1px solid rgba(192, 57, 43, 0.3);
  color: #e57373;
 
  padding: 4px 14px;
  font-size: 0.8rem;
  font-weight: 500;
`

export const DashboardPage: React.FC = () => {
  const { user, signOut } = useAuth()

  return (
    <Page>
      <Badge>✓ Authenticated</Badge>
      <Title>TwoAxis Finance</Title>
      <Subtitle>
        Welcome, {user?.email ?? 'User'}
      </Subtitle>
      <Button variant="secondary" onClick={signOut}>
        Sign out
      </Button>
    </Page>
  )
}
