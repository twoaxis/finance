import { Link } from 'react-router-dom';

export function OnboardingPage() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6 bg-surface-light dark:bg-surface-dark relative">
      {/* Dark mode radial gradient */}
      <div className="hidden dark:block absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[800px] opacity-30 pointer-events-none" 
           style={{ background: 'radial-gradient(circle, var(--color-secondary) 0%, transparent 70%)' }} />
      
      <div className="flex-1 flex flex-col items-center justify-center w-full max-w-sm z-10">
        <div className="w-32 h-32 flex items-center justify-center mb-10 drop-shadow-xl">
          <img src="/logo.png" alt="TwoAxis Finance" className="w-full h-full object-contain drop-shadow-md" />
        </div>
        
        <h1 className="text-3xl font-bold mb-3">TwoAxis Finance</h1>
        <p className="text-xl text-gray-600 dark:text-gray-400 mb-14">Your key to riches.</p>
        
        <div className="w-full flex items-center justify-center mb-10">
          <div className="h-px bg-gray-300 dark:bg-gray-700 flex-1" />
          <span className="px-4 text-gray-500">Or</span>
          <div className="h-px bg-gray-300 dark:bg-gray-700 flex-1" />
        </div>
        
        <Link to="/login" className="w-full block mb-4">
          <button className="w-full h-12 bg-primary text-white rounded-xl font-semibold hover:bg-primary-hover transition-colors shadow-sm">
            Login to your account
          </button>
        </Link>
        
        <Link to="/signup" className="w-full block mb-12">
          <button className="w-full h-12 bg-container-light dark:bg-container-dark text-black dark:text-white rounded-xl font-semibold hover:bg-bright-light dark:hover:bg-bright-dark transition-colors shadow-sm">
            Create an account
          </button>
        </Link>
        
        <p className="text-sm text-center text-gray-500">
          By using our app, you're subject to our <a href="https://finance.twoaxis.org/privacy.html" target="_blank" rel="noreferrer" className="underline decoration-2 decoration-gray-400 dark:decoration-gray-600">Privacy Policy</a>.
        </p>
      </div>
    </div>
  );
}
