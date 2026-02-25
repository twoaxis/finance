import { createBrowserRouter, RouterProvider } from "react-router";

const router = createBrowserRouter([{path: "/", element: <div>Hello World</div>}]);


export default function App() {
	

	return <RouterProvider router={router}></RouterProvider>;
}