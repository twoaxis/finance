import React from 'react'
import styled from 'styled-components'

const Wrapper = styled.div`
  position: relative;
  width: 100%;
  display: flex;
  justify-content: center;
  
`

const StyledInput = styled.input`
  width: 100%;
  max-width: 273px;
  background: ${({ theme }) => theme.colors.bgInput};
  border: 1px solid ${({ theme }) => theme.colors.border};
  border-radius: ${({ theme }) => theme.radii.md};
  padding: 14px 16px;
  font-size: 0.9rem;
  color: ${({ theme }) => theme.colors.text};
  transition: border-color ${({ theme }) => theme.transitions.normal},
  box-shadow ${({ theme }) => theme.transitions.normal};

  &::placeholder {
    color: ${({ theme }) => theme.colors.muted};
  }

 

  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
`

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  error?: boolean
}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ error: _error, ...rest }, ref) => {
    return (
      <Wrapper>
        <StyledInput ref={ref} {...rest} />
      </Wrapper>
    )
  }
)

Input.displayName = 'Input'
