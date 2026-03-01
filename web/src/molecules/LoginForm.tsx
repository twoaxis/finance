import React, { useRef } from 'react'
import styled from 'styled-components'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Input } from '../atoms/Input'
import { Button } from '../atoms/Button'
import { ErrorMessage } from '../atoms/ErrorMessage'
import { useAuth } from '../context/AuthContext'

const schema = z.object({
  email: z.email('Enter a valid email'),
  password: z.string().min(1, 'Password is required')
})

type LoginFields = z.infer<typeof schema>

const Form = styled.form`
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  width: 100%;
  & > :last-child {
    margin-top: 20px;
  }
`

interface LoginFormProps {
  onSuccess?: () => void
}

export const LoginForm: React.FC<LoginFormProps> = ({ onSuccess }) => {
  const { loginWithEmail, error, clearError } = useAuth()
  
  // Track whether user has attempted a failed submit
  const hasFailedSubmit = useRef(false)

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting, isValid },
  } = useForm<LoginFields>({
    resolver: zodResolver(schema),
    mode: 'onChange', // only active after a failed submit 
  })

  // Re-validate live only after user hit submit with bad data
  // so the button can unlock as soon as fields are corrected
  const isLockedOut = hasFailedSubmit.current && !isValid

  const onSubmit = async (data: LoginFields) => {
    clearError()
    try {
      await loginWithEmail(data.email, data.password)
      onSuccess?.()
    } catch (err) {
      // error handled by context
      console.error('Login failed', err)
    }
  }

  const onError = () => {
    // User tried to submit invalid data — now we lock until fixed
    hasFailedSubmit.current = true
  }

  return (
    <Form onSubmit={handleSubmit(onSubmit, onError)} noValidate>
      {error && <ErrorMessage message={error} />}

      <Input
        type="email"
        placeholder="E-mail"
        autoComplete="email"
        {...register('email')}
      />
      {errors.email && <ErrorMessage message={errors.email.message!} />}

      <Input
        type="password"
        placeholder="Password"
        autoComplete="current-password"
        {...register('password')}
      />
      {errors.password && <ErrorMessage message={errors.password.message!} />}

      <Button
        variant="primary"
        fullWidth={false}
        loading={isSubmitting}
        disabled={isLockedOut || isSubmitting}
        type="submit"
      >
        Login
      </Button>
    </Form>
  )
}