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
  gap: 8px;
  width: 100%;
  & > :last-child {
    margin-top: 20px;
  }
`

interface LoginFormProps {
  onSuccess?: () => void
}

interface LoginFields {
  email: string
  password: string
}

export const LoginForm: React.FC<LoginFormProps> = ({ onSuccess }) => {
  const { loginWithEmail, error, clearError } = useAuth()

  const [form, setForm] = useState<LoginFields>({
    email: '',
    password: '',
  })

  const [errors, setErrors] = useState<Partial<LoginFields>>({})
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [hasFailedSubmit, setHasFailedSubmit] = useState(false)

  // Handle input change
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target

    setForm(prev => ({
      ...prev,
      [name]: value,
    }))

    // If user previously failed submit → revalidate live
    if (hasFailedSubmit) {
      validateField(name as keyof LoginFields, value)
    }
  }

  const validateField = (field: keyof LoginFields, value: string) => {
    let message = ''

    if (field === 'email') {
      if (!value) message = 'Email is required'
      else if (!/\S+@\S+\.\S+/.test(value)) message = 'Enter a valid email'
    }

    if (field === 'password') {
      if (!value) message = 'Password is required'
    }

    setErrors(prev => ({
      ...prev,
      [field]: message,
    }))
  }

  const validateForm = () => {
    const newErrors: Partial<LoginFields> = {}

    if (!form.email) newErrors.email = 'Email is required'
    else if (!/\S+@\S+\.\S+/.test(form.email))
      newErrors.email = 'Enter a valid email'

    if (!form.password) newErrors.password = 'Password is required'

    setErrors(newErrors)

    return Object.keys(newErrors).length === 0
  }

  const onSubmit = async (e: React.SubmitEvent<HTMLFormElement>) => {
    e.preventDefault()
    clearError()

    const isValid = validateForm()

    if (!isValid) {
      setHasFailedSubmit(true)
      return
    }

    try {
      setIsSubmitting(true)
      await loginWithEmail(form.email, form.password)
      onSuccess?.()
    } catch (err) {
      console.error('Login failed', err)
    } finally {
      setIsSubmitting(false)
    }
  }

  const isLockedOut =
    hasFailedSubmit &&
    (!!errors.email || !!errors.password)

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
        autoComplete="current-password"
        value={form.password}
        onChange={handleChange}
      />
      {errors.password && <ErrorMessage message={errors.password} />}

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