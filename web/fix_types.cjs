const fs = require('fs');

function replaceFile(path, regex, replacement) {
  const content = fs.readFileSync(path, 'utf8');
  fs.writeFileSync(path, content.replace(regex, replacement));
}

// 1. AppLayout.tsx
replaceFile('src/components/AppLayout.tsx', /import \{ ReactNode, useState \} from 'react';/, "import { useState } from 'react';\nimport type { ReactNode } from 'react';");

// 2. InputField.tsx
replaceFile('src/components/InputField.tsx', /import \{ ChangeEvent \} from 'react';/, "import type { ChangeEvent } from 'react';");

// 3. Modal.tsx
replaceFile('src/components/Modal.tsx', /import \{ ReactNode \} from 'react';/, "import type { ReactNode } from 'react';");

// 4. PrimaryButton.tsx
replaceFile('src/components/PrimaryButton.tsx', /import \{ ReactNode \} from 'react';/, "import type { ReactNode } from 'react';");

// 5. AuthContext.tsx
replaceFile('src/contexts/AuthContext.tsx', /import \{ createContext, useContext, useEffect, useState, ReactNode \} from 'react';/, "import { createContext, useContext, useEffect, useState } from 'react';\nimport type { ReactNode } from 'react';");
replaceFile('src/contexts/AuthContext.tsx', /import \{(.*?)User,(.*?)from 'firebase\/auth';/s, "import type { User } from 'firebase/auth';\nimport {$1$2from 'firebase/auth';");

// 6. ThemeContext.tsx
replaceFile('src/contexts/ThemeContext.tsx', /import \{ createContext, useContext, useEffect, useState, ReactNode \} from 'react';/, "import { createContext, useContext, useEffect, useState } from 'react';\nimport type { ReactNode } from 'react';");

// 7. UserDataContext.tsx
replaceFile('src/contexts/UserDataContext.tsx', /import \{ createContext, useContext, useEffect, useState, ReactNode \} from 'react';/, "import { createContext, useContext, useEffect, useState } from 'react';\nimport type { ReactNode } from 'react';");
replaceFile('src/contexts/UserDataContext.tsx', /import \{ UserData, Balance, Income, Asset, Bill, Receivable, Liability, Budget \} from '\.\.\/types';/, "import type { UserData, Balance, Income, Asset, Bill, Receivable, Liability, Budget } from '../types';");
replaceFile('src/contexts/UserDataContext.tsx', /import \{ doc, onSnapshot, setDoc, updateDoc, arrayUnion, arrayRemove \} from 'firebase\/firestore';/, "import { doc, onSnapshot, updateDoc, arrayUnion, arrayRemove } from 'firebase/firestore';");

// 8. useTransactions.ts
replaceFile('src/hooks/useTransactions.ts', /import \{ Transaction \} from '\.\.\/types';/, "import type { Transaction } from '../types';");

// 9. AnalyticsPage.tsx
replaceFile('src/pages/AnalyticsPage.tsx', /ChartOptions\n\} from 'chart\.js';/, "} from 'chart.js';\nimport type { ChartOptions } from 'chart.js';");
replaceFile('src/pages/AnalyticsPage.tsx', /label: \(context\) => formatMoney\(context\.parsed\.y, userData\?\.currency\)/, "label: (context) => formatMoney(context.parsed.y || 0, userData?.currency)");

// 10. AssetsPage.tsx
replaceFile('src/pages/AssetsPage.tsx', /import \{ Asset \} from '\.\.\/types';/, "import type { Asset } from '../types';");

// 11. LoginPage.tsx
replaceFile('src/pages/auth/LoginPage.tsx', /import \{ Link, useNavigate \} from 'react-router-dom';/, "import { Link } from 'react-router-dom';");

// 12. BalancesPage.tsx
replaceFile('src/pages/BalancesPage.tsx', /import \{ Balance \} from '\.\.\/types';/, "import type { Balance } from '../types';");

// 13. BillsPage.tsx
replaceFile('src/pages/BillsPage.tsx', /import \{ Bill \} from '\.\.\/types';/, "import type { Bill } from '../types';");

// 14. IncomePage.tsx
replaceFile('src/pages/IncomePage.tsx', /import \{ Income \} from '\.\.\/types';/, "import type { Income } from '../types';");

// 15. LiabilitiesPage.tsx
replaceFile('src/pages/LiabilitiesPage.tsx', /import \{ Liability \} from '\.\.\/types';/, "import type { Liability } from '../types';");

// 16. ReceivablesPage.tsx
replaceFile('src/pages/ReceivablesPage.tsx', /import \{ Receivable \} from '\.\.\/types';/, "import type { Receivable } from '../types';");
