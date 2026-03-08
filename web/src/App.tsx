import { RouterProvider } from 'react-router';
import router from './routes/routes';
import { AuthProvider } from './context/AuthContext';
const App: React.FC = () => {
	return (
		<AuthProvider>
			<RouterProvider router={router} />;
		</AuthProvider>
	);
};

export default App;
