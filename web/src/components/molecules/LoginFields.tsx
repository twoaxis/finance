import React from 'react'
import { Input } from '../atoms/Input'
import { ErrorMessage } from '../atoms/ErrorMessage'

interface LoginFieldsProps {
  email: string
  password: string
  errors: { email?: string; password?: string }
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void
}

export const LoginFields: React.FC<LoginFieldsProps> = ({
  email,
  password,
  errors,
  onChange,
}) => (
  <>
    <Input
      type="email"
      name="email"
      placeholder="E-mail"
      autoComplete="email"
      value={email}
      onChange={onChange}
    />
    {errors.email && <ErrorMessage message={errors.email} />}

    <Input
      type="password"
      name="password"
      placeholder="Password"
      autoComplete="current-password"
      value={password}
      onChange={onChange}
    />
    {errors.password && <ErrorMessage message={errors.password} />}
  </>
)