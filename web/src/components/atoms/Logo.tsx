import React from 'react';
import styled from 'styled-components';

const Wrapper = styled.div`
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 12px;
	@media (max-width: 393px) {
		gap: 6px;
	}
`;
const LogoImage = styled.img`
	margin-bottom: 30px;
	@media (max-width: 393px) {
		margin-bottom: 15px;
	}
`;

const Title = styled.h1`
	font-size: 2.4rem;
	letter-spacing: 0.04em;
	line-height: 1;
`;

const Subtitle = styled.p`
	font-size: 20px;
	letter-spacing: 0.02em;
`;

interface LogoProps {
	subtitle?: string;
}

export const Logo: React.FC<LogoProps> = ({
	subtitle = 'Your key to riches.',
}) => {
	return (
		<Wrapper>
			<LogoImage src="./logo.webp" alt="TwoAxis Finance Logo" />

			<div style={{ textAlign: 'center' }}>
				<Title>TwoAxis Finance</Title>
				<Subtitle>{subtitle}</Subtitle>
			</div>
		</Wrapper>
	);
};
