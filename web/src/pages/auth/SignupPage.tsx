import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import { PrimaryButton } from '../../components/PrimaryButton';
import { InputField } from '../../components/InputField';
import { Modal } from '../../components/Modal';

export function SignupPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [repeatPassword, setRepeatPassword] = useState('');
  const [pending, setPending] = useState(false);
  const [errorModalOpen, setErrorModalOpen] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  
  const { signup } = useAuth();

  const handleSignup = async () => {
    if (!email || !password || !repeatPassword) {
      setErrorMessage("Please fill all fields");
      setErrorModalOpen(true);
      return;
    }
    
    if (password !== repeatPassword) {
      setErrorMessage("Passwords don't match");
      setErrorModalOpen(true);
      return;
    }
    
    setPending(true);
    try {
      await signup(email, password);
      // Navigation happens automatically via ProtectedRoute
    } catch (err: any) {
      setErrorMessage(err.message || "An error occurred");
      setErrorModalOpen(true);
      setPending(false);
    }
  };

  return (
    <div className="min-h-screen flex flex-col items-center p-6 bg-surface-light dark:bg-surface-dark relative">
      <div className="hidden dark:block absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[800px] opacity-30 pointer-events-none" 
           style={{ background: 'radial-gradient(circle, var(--color-secondary) 0%, transparent 70%)' }} />
      
      <div className="absolute top-6 left-6 z-20">
        <Link to="/onboarding" className="p-2 -ml-2 inline-block rounded-lg hover:bg-container-light dark:hover:bg-container-dark transition-colors">
          <span className="material-symbols-outlined">arrow_back</span>
        </Link>
      </div>
      
      <div className="w-full max-w-sm mx-auto flex-1 flex flex-col justify-center z-10 py-12">
        <div className="flex flex-col items-center mb-10 text-center">
          <div className="w-24 h-24 flex items-center justify-center mb-6 drop-shadow-xl">
            <img src="/logo.png" alt="TwoAxis Finance" className="w-full h-full object-contain drop-shadow-md" />
          </div>
          
          <h1 className="text-3xl font-bold mb-2">The next step to riches!</h1>
          <p className="text-xl text-gray-600 dark:text-gray-400">Create your account now!</p>
        </div>
        
        <div className="space-y-6 mb-8">
          <InputField 
            label="E-mail" 
            value={email} 
            onChange={setEmail} 
            placeholder="john@hotmail.com"
            type="email"
            disabled={pending}
          />
          <InputField 
            label="Password" 
            value={password} 
            onChange={setPassword} 
            placeholder="•••••••••••"
            type="password"
            disabled={pending}
          />
          <InputField 
            label="Repeat Password" 
            value={repeatPassword} 
            onChange={setRepeatPassword} 
            placeholder="•••••••••••"
            type="password"
            disabled={pending}
          />
        </div>
        
        <div className="pt-2 space-y-6">
          <PrimaryButton 
            text="Create your account" 
            onClick={handleSignup} 
            disabled={pending}
          />
          <p className="text-center text-sm text-gray-500">
            Already have an account? <Link to="/login" className="text-primary font-medium hover:underline">Login</Link>
          </p>
        </div>
      </div>

      <Modal isOpen={errorModalOpen} onClose={() => setErrorModalOpen(false)} title="Error">
        <p>{errorMessage}</p>
        <div className="mt-6 flex justify-end">
          <PrimaryButton text="Okay" onClick={() => setErrorModalOpen(false)} />
        </div>
      </Modal>
    </div>
  );
}
