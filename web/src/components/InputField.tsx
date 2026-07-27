import type { ChangeEvent } from 'react';

interface InputFieldProps {
  label: string;
  value: string;
  onChange?: (val: string) => void;
  placeholder?: string;
  type?: string;
  disabled?: boolean;
  readOnly?: boolean;
  onFieldClick?: () => void;
  className?: string;
}

export function InputField({
  label,
  value,
  onChange,
  placeholder,
  type = 'text',
  disabled = false,
  readOnly = false,
  onFieldClick,
  className = ''
}: InputFieldProps) {
  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    if (onChange) {
      onChange(e.target.value);
    }
  };

  return (
    <div className={`w-full ${className}`}>
      <label className="block text-sm text-gray-500 mb-1 pl-1">{label}</label>
      <div 
        onClick={onFieldClick} 
        className={onFieldClick ? 'cursor-pointer' : ''}
      >
        <input
          type={type}
          value={value}
          onChange={handleChange}
          placeholder={placeholder}
          disabled={disabled}
          readOnly={readOnly || !!onFieldClick}
          className={`w-full bg-container-light dark:bg-container-dark text-black dark:text-white rounded-xl px-4 py-3 outline-none focus:ring-2 focus:ring-primary transition-all duration-200 ${
            (disabled || readOnly) && !onFieldClick ? 'opacity-70 cursor-not-allowed' : ''
          } ${onFieldClick ? 'cursor-pointer pointer-events-none' : ''}`}
        />
      </div>
    </div>
  );
}
