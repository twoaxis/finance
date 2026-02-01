import { type ButtonHTMLAttributes, forwardRef } from "react";
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "outline" | "ghost";
  size?: "default" | "sm" | "lg" | "icon";
}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = "primary", size = "default", ...props }, ref) => {
    return (
      <button
        ref={ref}
        className={cn(
          "inline-flex items-center justify-center rounded-md font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none",
          {
            "bg-primary text-white hover:bg-secondary focus:ring-primary":
              variant === "primary",
            "bg-surface-container text-white hover:bg-surface-bright focus:ring-surface-container":
              variant === "secondary",
            "border border-outline text-on-surface-variant hover:bg-surface-container focus:ring-outline":
              variant === "outline",
            "bg-transparent text-on-surface-variant hover:bg-surface-container hover:text-white":
              variant === "ghost",
          },
          {
            "px-4 py-2": size === "default",
            "px-2 py-1 text-sm": size === "sm",
            "px-6 py-3 text-lg": size === "lg",
            "h-10 w-10 p-0": size === "icon",
          },
          className
        )}
        {...props}
      />
    );
  }
);

Button.displayName = "Button";

export { Button, cn };
