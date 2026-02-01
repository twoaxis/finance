import { useState } from "react";
import { signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../lib/firebase";
import { useNavigate } from "react-router-dom";

export const Login = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await signInWithEmailAndPassword(auth, email, password);
      navigate("/");
    } catch (err: any) {
      setError(err.message);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-surface px-4">
      <div className="w-full max-w-md p-8 space-y-6 bg-surface-container rounded-lg shadow-lg">
        <div className="flex flex-col items-center">
          <img src="/assets/images/logo.png" alt="Logo" className="w-20 mb-4" />
          <h1 className="text-3xl font-bold text-white">Login</h1>
        </div>
        {error && <p className="text-red-500 text-center">{error}</p>}
        <form onSubmit={handleLogin} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-on-surface-variant">Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full px-4 py-2 mt-1 text-white bg-surface-bright border border-outline rounded-md focus:ring-primary focus:border-primary outline-none"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-on-surface-variant">Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full px-4 py-2 mt-1 text-white bg-surface-bright border border-outline rounded-md focus:ring-primary focus:border-primary outline-none"
              required
            />
          </div>
          <button
            type="submit"
            className="w-full px-4 py-2 font-bold text-white bg-primary rounded-md hover:bg-secondary focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2"
          >
            Sign In
          </button>
        </form>
        <div className="text-center text-on-surface-variant">
          Don't have an account?{" "}
          <a href="/signup" className="text-primary hover:underline">
            Sign up
          </a>
        </div>
      </div>
    </div>
  );
};
