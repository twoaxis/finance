import React from 'react';
import styled, { css, keyframes } from 'styled-components';

const spin = keyframes`
  to { transform: rotate(360deg); }
`;

type Variant = 'primary' | 'secondary' | 'google';

interface StyledButtonProps {
	$variant: Variant;
	$fullWidth?: boolean;
}

const StyledButton = styled.button<StyledButtonProps>`
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	width: ${({ $fullWidth }) => ($fullWidth ? '100%' : '173px')};
	height: 42px;
	padding: 12px 24px;
	font-size: 15px;
	font-weight: 400;
	letter-spacing: 0px;
	position: relative;
	overflow: hidden;
	border: none;
	border-radius: 10px;

	&:disabled {
		opacity: 0.55;
		cursor: not-allowed;
	}
	${({ $variant }) =>
		$variant === 'primary' &&
		css`
			background-color: var(--color-primary);
			color: var(--color-on-primary);
			&:not(:disabled):hover {
				transform: translateY(-1px);
			}
			box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.25);
		`}

	${({ $variant }) =>
		$variant === 'secondary' &&
		css`
			background-color: var(--color-surface-bright);
			color: var(--color-on-secondary);
			box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.25);

			&:not(:disabled):hover {
				transform: translateY(-1px);
			}
		`}

  ${({ $variant }) =>
		$variant === 'google' &&
		css`
			background-color: var(--color-surface);
			border: 1px solid var(--color-outline);
			color: var(--color-on-surface);

			&:not(:disabled):hover {
				transform: translateY(-1px);
			}
		`}
`;

const Spinner = styled.span`
	width: 16px;
	height: 16px;
	border: 2px solid var(--color-surface-bright);
	border-top-color: var(--color-on-surface);
	border-radius: 50%;
	animation: ${spin} 0.7s linear infinite;
	display: inline-block;
`;

interface ButtonProps {
	variant?: Variant;
	fullWidth?: boolean;
	loading?: boolean;
	disabled?: boolean;
	onClick?: () => void;
	type?: 'button' | 'submit' | 'reset';
	children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
	variant = 'primary',
	fullWidth = false,
	loading = false,
	disabled,
	onClick,
	type = 'button',
	children,
}) => {
	return (
		<StyledButton
			$variant={variant}
			$fullWidth={fullWidth}
			disabled={disabled || loading}
			onClick={onClick}
			type={type}
		>
			{loading ? <Spinner /> : children}
		</StyledButton>
	);
};
