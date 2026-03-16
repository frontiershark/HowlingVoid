import { saveChatToStorage } from '../../../panels/chat/helpers';
import { roundRestartedAtAtom } from '../../game/atoms';
import { store } from '../store';

export function roundrestart() {
  store.set(roundRestartedAtAtom, Date.now());
  saveChatToStorage();
}
