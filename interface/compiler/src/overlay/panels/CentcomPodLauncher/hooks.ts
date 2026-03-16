import { useLocalState } from '../../core/backend';

export function useCompact() {
  return useLocalState('compact', false);
}

export function useTab() {
  return useLocalState('tab', 1);
}
