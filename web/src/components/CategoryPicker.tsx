import { getCategoryIcon } from '../utils/categories';

interface CategoryPickerProps {
  categories: Record<string, string>;
  selected: string | null;
  onSelect: (cat: string) => void;
}

export function CategoryPicker({ categories, selected, onSelect }: CategoryPickerProps) {
  return (
    <div className="flex overflow-x-auto gap-2 pb-2 -mx-4 px-4 sm:mx-0 sm:px-0 scrollbar-hide">
      {Object.keys(categories).map((category) => {
        const isSelected = selected === category;
        const icon = getCategoryIcon(category, 'category');
        
        return (
          <button
            key={category}
            onClick={() => onSelect(category)}
            className={`flex items-center gap-2 whitespace-nowrap px-4 py-2.5 rounded-full transition-colors ${
              isSelected 
                ? 'bg-primary text-white font-bold' 
                : 'bg-container-light dark:bg-container-dark border border-gray-300 dark:border-gray-700 hover:bg-bright-light dark:hover:bg-bright-dark'
            }`}
            type="button"
          >
            <span className="material-symbols-outlined text-[18px]">{icon}</span>
            <span>{category}</span>
          </button>
        );
      })}
    </div>
  );
}
