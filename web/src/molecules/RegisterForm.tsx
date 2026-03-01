import React, { useRef } from 'react'
import styled from 'styled-components'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Input } from '../atoms/Input'
import { Button } from '../atoms/Button'
import { ErrorMessage } from '../atoms/ErrorMessage'
import { useAuth } from '../context/AuthContext'

const schema = z
  .object({
    email: z.email('Enter a valid email'),
    password: z.string().min(8, 'Password must be at least 8 characters'),
    repeatPassword: z.string().min(1, 'Please confirm your password'),
  })
  .refine((data) => data.password === data.repeatPassword, {
    message: 'Passwords do not match',
    path: ['repeatPassword'], // attach error to repeatPassword field
  })

type RegisterFields = z.infer<typeof schema>

const Form = styled.form`
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  width: 100%;
  & > :last-child {
    margin-top: 16px;
  }
`

export const RegisterForm: React.FC = () => {
  const { registerWithEmail, error, clearError } = useAuth()
  const hasFailedSubmit = useRef(false)

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting, isValid },
  } = useForm<RegisterFields>({
    resolver: zodResolver(schema),
    mode: 'onChange',
  })

  const isLockedOut = hasFailedSubmit.current && !isValid

  const onSubmit = async (data: RegisterFields) => {
    clearError()
    try {
      await registerWithEmail(data.email, data.password)
    } catch(err) {
      console.error('Registration failed', err);
      // handled by context
    }
  }

  const onError = () => {
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
        autoComplete="new-password"
        {...register('password')}
      />
      {errors.password && <ErrorMessage message={errors.password.message!} />}

      <Input
        type="password"
        placeholder="Repeat Password"
        autoComplete="new-password"
        {...register('repeatPassword')}
      />
      {errors.repeatPassword && <ErrorMessage message={errors.repeatPassword.message!} />}

      <Button
        variant="primary"
        fullWidth={false}
        loading={isSubmitting}
        disabled={isLockedOut || isSubmitting}
        type="submit"
      >
        Register
      </Button>
    </Form>
  )
}