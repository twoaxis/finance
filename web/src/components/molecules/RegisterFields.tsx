import React from 'react'
import { Input } from '../atoms/Input'
import { ErrorMessage } from '../atoms/ErrorMessage'

interface RegisterFieldsProps {
  email: string
  password: string
  repeatPassword: string
  errors: {
    email?: string
    password?: string
    repeatPassword?: string
  }
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void
}

export const RegisterFields: React.FC<RegisterFieldsProps> = ({
  email,
  password,
  repeatPassword,
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
      autoComplete="new-password"
      value={password}
      onChange={onChange}
    />
    {errors.password && <ErrorMessage message={errors.password} />}

    <Input
      type="password"
      name="repeatPassword"
      placeholder="Repeat Password"
      autoComplete="new-password"
      value={repeatPassword}
      onChange={onChange}
    />
    {errors.repeatPassword && <ErrorMessage message={errors.repeatPassword} />}
  </>
)