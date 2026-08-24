export function formatMoney(value: number, currency: string = 'USD'): string {
  const num = typeof value === 'number' && !isNaN(value) ? value : (parseFloat(String(value)) || 0);
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: currency || 'USD',
  }).format(num);
}
