import React from 'react';
import styled from 'styled-components';

const Wrapper = styled.div`
	position: relative;
	width: 100%;
	display: flex;
	justify-content: center;
`;

const StyledInput = styled.input`
	width: 100%;
	max-width: 273px;
  height: 42px;
	padding: 21px 11px;
	font-size: 15px;
  font-weight: 400;
  background-color:var(--color-surface-container);
  border:none;
  placeholder-color:rgba(75, 75, 75, 1);
  color:var(--color-on-surface);
  outline:none;
  &:focus {
  outline: 1px solid var(--color-primary);
}
  border-radius:10px;
	&:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}
`;

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
	error?: boolean;
}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(
	({ error: _error, ...rest }, ref) => {
		return (
			<Wrapper>
				<StyledInput ref={ref} {...rest} />
			</Wrapper>
		);
	},
);

Input.displayName = 'Input';
