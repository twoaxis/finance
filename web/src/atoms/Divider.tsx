import React from 'react'
import styled from 'styled-components'

const Wrapper = styled.div`
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
`

const Line = styled.div`
  flex: 1;
  height: 2px;
  margin: 15px 0;
  background: ${({ theme }) => theme.colors.overmuted};
`

const Label = styled.span`
  font-size: 15px;
  color: ${({ theme }) => theme.colors.white};
  font-weight: 400;
`

interface DividerProps {
  label?: string
}

export const Divider: React.FC<DividerProps> = ({ label = 'Or' }) => (
  <Wrapper>
    <Line />
    <Label>{label}</Label>
    <Line />
  </Wrapper>
)
