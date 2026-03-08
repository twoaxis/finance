export const AUTH_ROUTES = {
  base: '/auth',
  login: '/auth/login',
  register: '/auth/register',
} as const

export const AUTH_ROUTE_SEGMENTS = {
  login: 'login',
  register: 'register',
} as const

export const AUTH_SUBTITLES: Record<(typeof AUTH_ROUTES)[keyof typeof AUTH_ROUTES], string> = {
  [AUTH_ROUTES.base]: 'Your key to riches.',
  [AUTH_ROUTES.login]: 'Login to your account',
  [AUTH_ROUTES.register]: 'Create an Account',
}
