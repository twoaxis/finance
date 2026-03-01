import React from 'react'
import styled, { keyframes } from 'styled-components'

const slideIn = keyframes`
  from { opacity: 0; transform: translateY(-6px); }
  to   { opacity: 1; transform: translateY(0); }
`

const Wrapper = styled.span`
  font-size: 0.75rem;
  color: #e57373;
  animation: ${slideIn} 0.2s ease;
  line-height: 0.5;
`

export const ErrorMessage: React.FC<{ message: string }> = ({ message }) => (
  <Wrapper role="alert">{message}</Wrapper>
)
