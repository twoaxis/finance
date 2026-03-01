import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import "@fontsource/sen/400.css";
import "@fontsource/sen/800.css";
import App from './App.tsx'

createRoot(document.getElementById('root')!).render(
	<StrictMode>
		<App />
	</StrictMode>,
)
