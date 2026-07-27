import { Link } from 'react-router-dom';

export function WalletPage() {
  const cards = [
    {
      to: '/income',
      title: 'Income sources',
      subtitle: 'Manage your various income sources.',
      image: '/income.png',
      color: 'text-primary',
      bg: 'bg-primary/10'
    },
    {
      to: '/balances',
      title: 'Balances',
      subtitle: 'Manage your balances.',
      image: '/balances.png',
      color: 'text-primary',
      bg: 'bg-primary/10'
    },
    {
      to: '/receivables',
      title: 'Receivables',
      subtitle: 'Manage money owed to you.',
      image: '/receivables.png',
      color: 'text-primary',
      bg: 'bg-primary/10'
    },
    {
      to: '/assets',
      title: 'Assets',
      subtitle: 'Manage everything you own.',
      image: '/assets.png',
      color: 'text-primary',
      bg: 'bg-primary/10'
    }
  ];

  return (
    <div className="p-6 max-w-4xl mx-auto space-y-6">
      <h1 className="text-4xl font-bold mb-8">Wallet</h1>

      <div className="grid grid-cols-1 gap-4">
        {cards.map((card) => (
          <Link 
            key={card.to}
            to={card.to} 
            className="flex items-center gap-6 bg-container-light dark:bg-container-dark hover:bg-bright-light dark:hover:bg-bright-dark transition-colors rounded-3xl p-6 shadow-sm border border-gray-200 dark:border-gray-800 group"
          >
            <div className={`w-20 h-20 rounded-2xl flex items-center justify-center bg-transparent group-hover:scale-110 transition-transform`}>
              <img src={card.image} alt={card.title} className="w-full h-full object-contain drop-shadow-md" />
            </div>
            <div className="flex-1">
              <h2 className="text-2xl font-bold mb-1">{card.title}</h2>
              <p className="text-gray-500">{card.subtitle}</p>
            </div>
            <div className="w-10 h-10 rounded-full flex items-center justify-center bg-gray-100 dark:bg-gray-800 group-hover:bg-primary group-hover:text-white transition-colors">
              <span className="material-symbols-outlined">chevron_right</span>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
