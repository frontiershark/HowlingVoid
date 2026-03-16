import { mock } from 'bun:test';

import './byond';
import './layouts';

const logger = {
  debug: () => {},
  error: () => {},
  info: () => {},
  log: () => {},
  warn: () => {},
};

mock.module('../../core/logging', () => ({
  createLogger: () => logger,
  logger,
}));

mock.module('../../core/events/act', () => ({
  sendAct: () => ({}),
}));
