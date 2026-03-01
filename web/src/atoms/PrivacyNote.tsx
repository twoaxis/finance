import React from 'react'
import styled from 'styled-components'

const Text = styled.p`
  font-size: 15px;
  color: ${({ theme }) => theme.colors.overmuted};
  text-align: center;
  line-height: 1.5;

  a {
    color: ${({ theme }) => theme.colors.overmuted};
    text-decoration: underline;
    text-underline-offset: 2px;

    &:hover {
      color: ${({ theme }) => theme.colors.white};
    }
  }
`

export const PrivacyNote: React.FC = () => (
  <Text>
    By continuing, you agree to our{' '}
    <a href="#" target="_blank" rel="noopener noreferrer">
      Privacy Policy
    </a>
  </Text>
)
