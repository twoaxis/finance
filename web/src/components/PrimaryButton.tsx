import type { ReactNode } from 'react';

interface PrimaryButtonProps {
  text: string;
  onClick?: () => void;
  disabled?: boolean;
  type?: 'button' | 'submit' | 'reset';
  variant?: 'primary' | 'secondary';
  className?: string;
  children?: ReactNode;
}

export function PrimaryButton({
  text,
  onClick,
  disabled = false,
  type = 'button',
  variant = 'primary',
  className = '',
  children
}: PrimaryButtonProps) {
  const baseClasses = 'h-12 w-full rounded-xl font-semibold transition-all duration-200 flex items-center justify-center gap-2';
  
  const variantClasses = variant === 'primary'
    ? 'bg-primary text-white hover:bg-primary-hover disabled:opacity-50 disabled:hover:bg-primary'
    : 'bg-container-light dark:bg-container-dark text-black dark:text-white hover:bg-bright-light dark:hover:bg-bright-dark';
    
  const cursorClass = disabled ? 'cursor-not-allowed opacity-50' : 'cursor-pointer';

  return (
    <button
      type={type}
      onClick={onClick}
      disabled={disabled}
      className={`${baseClasses} ${variantClasses} ${cursorClass} ${className}`}
    >
      {text}
      {children}
    </button>
  );
}
