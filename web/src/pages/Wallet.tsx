import { Link } from "react-router-dom";
import { Card, CardContent } from "../components/ui/Card";

const walletItems = [
  {
    name: "Income sources",
    description: "Manage your various income sources.",
    icon: "/assets/images/income.png",
    href: "/income",
  },
  {
    name: "Balances",
    description: "Manage your balances.",
    icon: "/assets/images/balances.png",
    href: "/balances",
  },
  {
    name: "Receivables",
    description: "Manage money owed to you.",
    icon: "/assets/images/receivables.png",
    href: "/receivables",
  },
  {
    name: "Assets",
    description: "Manage everything you own.",
    icon: "/assets/images/assets.png",
    href: "/assets",
  },
];

export const Wallet = () => {
  return (
    <div className="space-y-8">
      <h1 className="text-3xl font-bold text-white">Wallet</h1>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-1">
        {walletItems.map((item) => (
          <Link key={item.name} to={item.href}>
            <Card className="group hover:bg-surface-bright transition-colors border-none bg-surface-container">
              <CardContent className="flex items-center p-6 space-x-4">
                <div className="flex-1">
                  <h2 className="text-xl font-bold text-white group-hover:text-primary transition-colors">
                    {item.name}
                  </h2>
                  <p className="text-sm text-on-surface-variant">
                    {item.description}
                  </p>
                </div>
                <img
                  src={item.icon}
                  alt={item.name}
                  className="h-16 w-16 object-contain opacity-80 group-hover:opacity-100 transition-opacity"
                />
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
};
