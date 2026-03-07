import React from 'react';
import styled from 'styled-components';

const Text = styled.p`
	font-size: 15px;

	text-align: center;
	line-height: 100%;
	font-weight: 400;
	color: var(--color-on-surface-variant);
	a {
		text-decoration: underline;
		color: var(--color-on-surface-variant);
	}
`;

export const PrivacyNote: React.FC = () => (
	<Text>
		By continuing, you agree to our{' '}
		<a href="#" target="_blank" rel="noopener noreferrer">
			Privacy Policy
		</a>
	</Text>
);
