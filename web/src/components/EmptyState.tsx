interface EmptyStateProps {
  message: string;
  icon?: string;
  className?: string;
}

export function EmptyState({ message, icon = 'folder_open', className = '' }: EmptyStateProps) {
  return (
    <div className={`flex flex-col items-center justify-center p-8 opacity-30 ${className}`}>
      <span className="material-symbols-outlined text-6xl mb-4">{icon}</span>
      <p className="text-xl text-center">{message}</p>
    </div>
  );
}
