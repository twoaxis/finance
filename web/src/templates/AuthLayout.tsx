import React from 'react'
import styled, { keyframes } from 'styled-components'
import { Logo } from '../atoms/Logo'
import { PrivacyNote } from '../atoms/PrivacyNote'

const fadeIn = keyframes`
  from { opacity: 0; transform: translateY(16px); }
  to   { opacity: 1; transform: translateY(0); }
`

const Page = styled.div`
  min-height: 100vh;
  background: ${({ theme }) => theme.colors.bg};
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  padding: 24px;
  padding-top: 114px;
 
  position: relative;
  overflow: hidden;

  /* Subtle background glow */
  &::before {
    content: '';
    position: absolute;
    top: -20%;
    left: 50%;
    transform: translateX(-50%);
    width: 600px;
    height: 600px;
    background: radial-gradient(circle, rgba(192, 57, 43, 0.06) 0%, transparent 70%);
    pointer-events: none;
  }
`

const Card = styled.div`
  width: 100%;
  max-width: 360px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 32px;
  animation: ${fadeIn} 0.4s ease;
`

const ContentArea = styled.div`
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
 
`

const Footer = styled.div`
  display: flex;
  justify-content: center;
  bottom: 70px;
  position: absolute;
  min-width:360px;
`

interface AuthLayoutProps {
  subtitle?: string
  children: React.ReactNode
}

export const AuthLayout: React.FC<AuthLayoutProps> = ({ subtitle, children }) => (
  <Page>
    <Card>
      <Logo subtitle={subtitle} />
      <ContentArea>{children}</ContentArea>
      <Footer>
        <PrivacyNote />
      </Footer>
    </Card>
  </Page>
)
