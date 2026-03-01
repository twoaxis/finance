import React from 'react'
import styled, { keyframes } from 'styled-components'

const spin = keyframes`
  to { transform: rotate(360deg); }
`

const Wrapper = styled.div`
  height: 100vh;
  width: 100vw;
  background: ${({ theme }) => theme.colors.bg};
  display: flex;
  align-items: center;
  justify-content: center;
`

const Ring = styled.div`
  width: 40px;
  height: 40px;
  border: 3px solid ${({ theme }) => theme.colors.border};
  border-top-color: ${({ theme }) => theme.colors.red};
  border-radius: 50%;
  animation: ${spin} 0.8s linear infinite;
`

export const LoadingScreen: React.FC = () => (
  <Wrapper>
    <Ring />
  </Wrapper>
)
