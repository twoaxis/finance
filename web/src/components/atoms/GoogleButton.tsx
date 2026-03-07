import React from 'react';
import { Button } from './Button';

const GoogleIcon: React.FC = () => (
	<svg
		width="18"
		height="18"
		viewBox="0 0 18 18"
		xmlns="http://www.w3.org/2000/svg"
	>
		<path
			d="M17.64 9.2c0-.637-.057-1.251-.164-1.84H9v3.481h4.844c-.209 1.125-.843 2.078-1.796 2.717v2.258h2.908c1.702-1.567 2.684-3.874 2.684-6.615z"
			fill="#4285F4"
		/>
		<path
			d="M9 18c2.43 0 4.467-.806 5.956-2.184l-2.908-2.258c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332C2.438 15.983 5.482 18 9 18z"
			fill="#34A853"
		/>
		<path
			d="M3.964 10.707c-.18-.54-.282-1.117-.282-1.707s.102-1.167.282-1.707V4.961H.957C.347 6.175 0 7.55 0 9s.348 2.826.957 4.039l3.007-2.332z"
			fill="#FBBC05"
		/>
		<path
			d="M9 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.463.891 11.426 0 9 0 5.482 0 2.438 2.017.957 4.961L3.964 7.293C4.672 5.163 6.656 3.58 9 3.58z"
			fill="#EA4335"
		/>
	</svg>
);

interface GoogleButtonProps {
	onClick: () => void;
	loading?: boolean;
}

export const GoogleButton: React.FC<GoogleButtonProps> = ({
	onClick,
	loading,
}) => (
	<Button variant="google" fullWidth loading={loading} onClick={onClick}>
		<GoogleIcon />
		Continue with Google
	</Button>
);
