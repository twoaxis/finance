import React, { useState } from 'react'
import styled from 'styled-components'
import { Input } from '../atoms/Input'
import { Button } from '../atoms/Button'
import { ErrorMessage } from '../atoms/ErrorMessage'
import { useAuth } from '../../context/AuthContext'

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

interface RegisterFields {
  email: string
  password: string
  repeatPassword: string
}

export const RegisterForm: React.FC = () => {
  const { registerWithEmail, error, clearError } = useAuth()

  const [form, setForm] = useState<RegisterFields>({
    email: '',
    password: '',
    repeatPassword: '',
  })

  const [errors, setErrors] = useState<Partial<RegisterFields>>({})
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [hasFailedSubmit, setHasFailedSubmit] = useState(false)

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target

    setForm(prev => ({
      ...prev,
      [name]: value,
    }))

    if (hasFailedSubmit) {
      validateField(name as keyof RegisterFields, value)
    }
  }

  const validateField = (
    field: keyof RegisterFields,
    value: string
  ) => {
    let message = ''

    if (field === 'email') {
      if (!value) message = 'Email is required'
      else if (!/\S+@\S+\.\S+/.test(value))
        message = 'Enter a valid email'
    }

    if (field === 'password') {
      if (!value) message = 'Password is required'
      else if (value.length < 8)
        message = 'Password must be at least 8 characters'
    }

    if (field === 'repeatPassword') {
      if (!value) message = 'Please confirm your password'
      else if (value !== form.password)
        message = 'Passwords do not match'
    }

    setErrors(prev => ({
      ...prev,
      [field]: message,
    }))
  }

  const validateForm = () => {
    const newErrors: Partial<RegisterFields> = {}

    if (!form.email) newErrors.email = 'Email is required'
    else if (!/\S+@\S+\.\S+/.test(form.email))
      newErrors.email = 'Enter a valid email'

    if (!form.password)
      newErrors.password = 'Password is required'
    else if (form.password.length < 8)
      newErrors.password =
        'Password must be at least 8 characters'

    if (!form.repeatPassword)
      newErrors.repeatPassword =
        'Please confirm your password'
    else if (form.password !== form.repeatPassword)
      newErrors.repeatPassword =
        'Passwords do not match'

    setErrors(newErrors)

    return Object.keys(newErrors).length === 0
  }

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    clearError()

    const isValid = validateForm()

    if (!isValid) {
      setHasFailedSubmit(true)
      return
    }

    try {
      setIsSubmitting(true)
      await registerWithEmail(form.email, form.password)
    } catch (err) {
      console.error('Registration failed', err)
    } finally {
      setIsSubmitting(false)
    }
  }

  const isLockedOut =
    hasFailedSubmit &&
    (!!errors.email ||
      !!errors.password ||
      !!errors.repeatPassword)

  return (
    <Form onSubmit={onSubmit} noValidate>
      {error && <ErrorMessage message={error} />}

      <Input
        type="email"
        name="email"
        placeholder="E-mail"
        autoComplete="email"
        value={form.email}
        onChange={handleChange}
      />
      {errors.email && <ErrorMessage message={errors.email} />}

      <Input
        type="password"
        name="password"
        placeholder="Password"
        autoComplete="new-password"
        value={form.password}
        onChange={handleChange}
      />
      {errors.password && <ErrorMessage message={errors.password} />}

      <Input
        type="password"
        name="repeatPassword"
        placeholder="Repeat Password"
        autoComplete="new-password"
        value={form.repeatPassword}
        onChange={handleChange}
      />
      {errors.repeatPassword && (
        <ErrorMessage message={errors.repeatPassword} />
      )}

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