import { Link } from "react-router-dom";

export const Onboarding = () => {
  return (
    <div className="relative flex flex-col items-center justify-center min-h-screen bg-surface overflow-hidden">
      {/* Background Gradient */}
      <div
        className="absolute top-0 left-0 w-full h-full pointer-events-none"
        style={{
          background: "radial-gradient(circle at top, var(--color-secondary), transparent 70%)"
        }}
      />

      <div className="z-10 flex flex-col items-center max-w-md px-6 text-center">
        <img src="/assets/images/logo.png" alt="Logo" className="w-32 mb-6" />
        <h1 className="text-4xl font-bold text-white mb-2">TwoAxis Finance</h1>
        <p className="text-xl text-on-surface-variant mb-12">Your key to riches.</p>

        <div className="w-full space-y-4">
          <Link
            to="/login"
            className="block w-full py-3 text-center font-bold text-white bg-primary rounded-lg hover:bg-secondary transition-colors"
          >
            Login to your account
          </Link>

          <div className="flex items-center justify-center space-x-2 text-on-surface-variant">
            <span className="h-px w-full bg-outline"></span>
            <span>Or</span>
            <span className="h-px w-full bg-outline"></span>
          </div>

          <Link
            to="/signup"
            className="block w-full py-3 text-center font-bold text-white bg-surface-container rounded-lg hover:bg-surface-bright transition-colors shadow-md"
          >
            Create an account
          </Link>
        </div>

        <div className="mt-8 text-sm text-on-surface-variant">
          By using our app, you're subject to our{" "}
          <a href="https://finance.twoaxis.org/privacy.html" target="_blank" rel="noopener noreferrer" className="underline hover:text-white">
            Privacy Policy
          </a>.
        </div>
      </div>
    </div>
  );
};
