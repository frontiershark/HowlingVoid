/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import './common/styles/main.scss';
import './common/styles/themes/light.scss';

import { createRoot } from 'react-dom/client';
import { setupGlobalEvents } from 'tgui-core/events';
import { captureExternalLinks } from 'tgui-core/links';
import { App } from './core/app';
import { bus } from './core/events/listeners';
import { setupPanelFocusHacks } from './layout/panel/panelFocus';

const root = createRoot(document.getElementById('react-root')!);

function render(component: React.ReactElement) {
  root.render(component);
}

function setupApp() {
  // Delay setup
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', setupApp);
    return;
  }

  setupGlobalEvents({
    ignoreWindowFocus: true,
  });

  setupPanelFocusHacks();
  captureExternalLinks();

  render(<App />);

  // Dispatch incoming messages as store actions
  Byond.subscribe((type, payload) => bus.dispatch({ type, payload }));

  // Unhide the panel
  Byond.winset('output_selector.legacy_output_selector', {
    left: 'output_browser',
  });

  // Resize the panel to match the non-browser output
  Byond.winget('output').then((output: { size: string }) => {
    Byond.winset('browseroutput', {
      size: output.size,
    });
  });

  // Enable hot module reloading
  if (import.meta.webpackHot) {
    import.meta.webpackHot.accept(['./core/app'], () => {
      render(<App />);
    });
  }
}

setupApp();
