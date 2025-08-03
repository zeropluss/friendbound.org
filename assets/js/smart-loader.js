/**
 * 智能脚本加载器 - 开发环境友好版本
 * 只在生产环境加载外部分析和广告脚本，避免本地开发时的错误
 */

(function() {
  'use strict';
  
  // 检测是否为本地开发环境
  const isLocalDev = location.protocol === 'file:' || 
                    location.hostname === 'localhost' || 
                    location.hostname === '127.0.0.1' ||
                    location.hostname === '' ||
                    location.hostname.includes('192.168.') ||
                    location.hostname.includes('10.0.') ||
                    location.hostname.includes('172.16.');
  
  // 开发环境提示
  if (isLocalDev) {
    console.log('🚀 开发环境检测：已跳过外部分析和广告脚本加载');
    console.log('📍 当前环境:', {
      protocol: location.protocol,
      hostname: location.hostname,
      port: location.port
    });
    return;
  }
  
  // 生产环境：加载外部脚本
  console.log('🌐 生产环境：正在加载外部分析和广告脚本');
  
  // 1. Click Analytics (Plausible)
  try {
    const clickScript = document.createElement('script');
    clickScript.defer = true;
    clickScript.setAttribute('data-domain', 'friendbound.org');
    clickScript.src = 'https://click.pageview.click/js/script.js';
    clickScript.onerror = function() {
      console.warn('⚠️ 点击分析脚本加载失败');
    };
    document.head.appendChild(clickScript);
  } catch (error) {
    console.warn('⚠️ 点击分析脚本初始化失败:', error);
  }
  
  // 2. Google Analytics
  try {
    const gtagScript = document.createElement('script');
    gtagScript.async = true;
    gtagScript.src = 'https://www.googletagmanager.com/gtag/js?id=G-RPMXFWKW5R';
    gtagScript.onload = function() {
      // 初始化 Google Analytics
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'G-RPMXFWKW5R');
      window.gtag = gtag;
      console.log('✅ Google Analytics 已加载');
    };
    gtagScript.onerror = function() {
      console.warn('⚠️ Google Analytics 脚本加载失败');
    };
    document.head.appendChild(gtagScript);
  } catch (error) {
    console.warn('⚠️ Google Analytics 初始化失败:', error);
  }
  
  // 3. Google AdSense
  try {
    const adsenseScript = document.createElement('script');
    adsenseScript.async = true;
    adsenseScript.src = 'https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-6762879731814955';
    adsenseScript.crossOrigin = 'anonymous';
    adsenseScript.onload = function() {
      console.log('✅ Google AdSense 已加载');
    };
    adsenseScript.onerror = function() {
      console.warn('⚠️ Google AdSense 脚本加载失败');
    };
    document.head.appendChild(adsenseScript);
  } catch (error) {
    console.warn('⚠️ Google AdSense 初始化失败:', error);
  }
  
})();