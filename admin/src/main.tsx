import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import { App as AntApp, ConfigProvider } from 'antd';
import './i18n';
import App from './App';
import { AuthProvider } from './auth/AuthContext';

const root = document.getElementById('root');
if (!root) throw new Error('root element not found');

ReactDOM.createRoot(root).render(
  <React.StrictMode>
    <ConfigProvider>
      {/* AntApp 提供 message/notification 上下文(避免静态调用脱离主题) */}
      <AntApp>
        <BrowserRouter>
          <AuthProvider>
            <App />
          </AuthProvider>
        </BrowserRouter>
      </AntApp>
    </ConfigProvider>
  </React.StrictMode>,
);
