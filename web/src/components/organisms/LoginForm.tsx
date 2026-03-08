import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import { LoginFields } from '../molecules/LoginFields';
import { Button } from '../atoms/Button';
import { ErrorMessage } from '../atoms/ErrorMessage';
import { useAuth } from '../../context/AuthContext';
import { useNavigate } from 'react-router-dom';

const Form = styled.form`
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 8px;
	width: 100%;
	& > :last-child {
		margin-top: 20px;
	}
`;

interface LoginFieldsState {
	email: string;
	password: string;
}

export const LoginForm: React.FC = () => {
	const { login, error, clearError, user, loading } = useAuth();
	const navigate = useNavigate();
	const [form, setForm] = useState<LoginFieldsState>({
		email: '',
		password: '',
	});
	const [errors, setErrors] = useState<Partial<LoginFieldsState>>({});
	const [isSubmitting, setIsSubmitting] = useState(false);
	const [hasFailedSubmit, setHasFailedSubmit] = useState(false);

	// Handle input change
	const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
		const { name, value } = e.target;
		setForm((prev) => ({ ...prev, [name]: value }));
		if (hasFailedSubmit)
			validateField(name as keyof LoginFieldsState, value);
	};

	const validateField = (field: keyof LoginFieldsState, value: string) => {
		let message = '';
		if (field === 'email') {
			if (!value) message = 'Email is required';
			else if (!/\S+@\S+\.\S+/.test(value))
				message = 'Enter a valid email';
		}
		if (field === 'password') {
			if (!value) message = 'Password is required';
		}
		setErrors((prev) => ({ ...prev, [field]: message }));
	};

	const validateForm = () => {
		const newErrors: Partial<LoginFieldsState> = {};
		if (!form.email) newErrors.email = 'Email is required';
		else if (!/\S+@\S+\.\S+/.test(form.email))
			newErrors.email = 'Enter a valid email';
		if (!form.password) newErrors.password = 'Password is required';
		setErrors(newErrors);
		return Object.keys(newErrors).length === 0;
	};

	const onSubmit = async (e: React.SubmitEvent<HTMLFormElement>) => {
		e.preventDefault();
		clearError();
		const isValid = validateForm();
		if (!isValid) {
			setHasFailedSubmit(true);
			return;
		}
		try {
			setIsSubmitting(true);
			await login(form.email, form.password);
		} catch (err) {
			console.error('Login failed', err);
		} finally {
			setIsSubmitting(false);
		}
	};

	const isLockedOut =
		hasFailedSubmit && (!!errors.email || !!errors.password);

  useEffect(() => {
		if (user && !loading) {
			navigate('/dashboard');
		}
	}, [user, loading]);

	return (
		<Form onSubmit={onSubmit} noValidate>
			{error && <ErrorMessage message={error} />}

			<LoginFields
				email={form.email}
				password={form.password}
				errors={errors}
				onChange={handleChange}
			/>

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
	);
};
