import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { useUserData } from '../contexts/UserDataContext';
import { PrimaryButton } from '../components/PrimaryButton';
import { InputField } from '../components/InputField';
import { Modal } from '../components/Modal';
import { EmailAuthProvider, reauthenticateWithCredential, deleteUser } from 'firebase/auth';

export function AccountSettingsPage() {
  const { currentUser } = useAuth();
  const { userData, updateName } = useUserData();
  const navigate = useNavigate();
  
  const [name, setName] = useState('');
  const [password, setPassword] = useState('');
  const [pending, setPending] = useState(false);
  
  const [deleteModalOpen, setDeleteModalOpen] = useState(false);
  const [errorModalOpen, setErrorModalOpen] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  useEffect(() => {
    if (userData?.name) {
      setName(userData.name);
    }
  }, [userData]);

  const handleUpdate = async () => {
    if (!name.trim()) {
      setErrorMessage("Please enter a name.");
      setErrorModalOpen(true);
      return;
    }
    
    setPending(true);
    try {
      await updateName(name);
      navigate('/account');
    } catch (err: any) {
      setErrorMessage(err.message || "Failed to update details.");
      setErrorModalOpen(true);
    } finally {
      setPending(false);
    }
  };

  const handleDelete = async () => {
    if (!currentUser?.email) return;
    if (!password) {
      setErrorMessage("Please enter your password to confirm.");
      setDeleteModalOpen(false);
      setTimeout(() => setErrorModalOpen(true), 300);
      return;
    }

    setPending(true);
    try {
      const credential = EmailAuthProvider.credential(currentUser.email, password);
      await reauthenticateWithCredential(currentUser, credential);
      await deleteUser(currentUser);
      // Navigation to login happens via ProtectedRoute
    } catch (err: any) {
      setDeleteModalOpen(false);
      setTimeout(() => {
        setErrorMessage("Invalid E-mail or password.");
        setErrorModalOpen(true);
      }, 300);
    } finally {
      setPending(false);
    }
  };

  return (
    <div className="p-6 max-w-2xl mx-auto space-y-6">
      <div className="flex items-center gap-4 mb-8">
        <button onClick={() => navigate('/account')} className="p-2 -ml-2 rounded-lg hover:bg-container-light dark:hover:bg-container-dark">
          <span className="material-symbols-outlined">arrow_back</span>
        </button>
        <h1 className="text-3xl font-bold">Account settings</h1>
      </div>

      <div className="space-y-6">
        <InputField 
          label="Display Name" 
          value={name} 
          onChange={setName} 
          placeholder="John Doe"
          disabled={pending}
        />
        
        <div className="pt-4">
          <PrimaryButton 
            text="Update account details" 
            onClick={handleUpdate} 
            disabled={pending}
          />
        </div>

        <div className="pt-12 text-center">
          <button 
            onClick={() => setDeleteModalOpen(true)}
            className="text-red-500 font-medium hover:underline p-2"
          >
            Delete your account
          </button>
        </div>
      </div>

      <Modal isOpen={deleteModalOpen} onClose={() => setDeleteModalOpen(false)} title="Confirm Deletion">
        <p className="text-gray-600 dark:text-gray-400 mb-4">
          Please enter your password to confirm account deletion. This action cannot be undone.
        </p>
        <InputField 
          label="Password" 
          value={password} 
          onChange={setPassword} 
          placeholder="•••••••••••"
          type="password"
          disabled={pending}
        />
        <div className="mt-6 flex justify-end gap-3">
          <PrimaryButton 
            text="Cancel" 
            variant="secondary" 
            onClick={() => setDeleteModalOpen(false)} 
            className="flex-1"
          />
          <PrimaryButton 
            text="Delete" 
            onClick={handleDelete} 
            disabled={pending}
            className="flex-1 !bg-red-600 hover:!bg-red-700"
          />
        </div>
      </Modal>

      <Modal isOpen={errorModalOpen} onClose={() => setErrorModalOpen(false)} title="Error">
        <p>{errorMessage}</p>
        <div className="mt-6 flex justify-end">
          <PrimaryButton text="Okay" onClick={() => setErrorModalOpen(false)} />
        </div>
      </Modal>
    </div>
  );
}
