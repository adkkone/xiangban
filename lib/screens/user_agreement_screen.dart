import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_theme.dart';

class UserAgreementScreen extends StatefulWidget {
  const UserAgreementScreen({super.key});

  @override
  State<UserAgreementScreen> createState() => _UserAgreementScreenState();
}

class _UserAgreementScreenState extends State<UserAgreementScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _opacity = 0.0;
            });
          },
          onPageFinished: (String url) {
            // 延迟隐藏加载指示器，确保内容已渲染
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _opacity = 1.0;
                });
              }
            });
            
            // 注入CSS隐藏标题和左下角图标
            _controller.runJavaScript('''
              (function() {
                function hideElements() {
                  // 添加CSS样式
                  var style = document.createElement('style');
                  style.innerHTML = `
                    .sites-header-cell-buffer-wrapper { display: none !important; }
                    [role="banner"] { display: none !important; }
                    .sites-footer-wrapper { display: none !important; }
                    a[href*="sites.google.com"] { display: none !important; }
                    a[target="_blank"] { display: none !important; }
                    div[style*="z-index: 2000000000"] { display: none !important; }
                    div[style*="position: fixed"] { display: none !important; }
                  `;
                  document.head.appendChild(style);
                  
                  // 删除所有包含Google Sites链接的元素
                  setTimeout(function() {
                    document.querySelectorAll('a').forEach(function(link) {
                      if (link.href && (link.href.includes('sites.google.com') || link.target === '_blank')) {
                        var parent = link.parentElement;
                        if (parent) parent.remove();
                      }
                    });
                    
                    // 删除所有固定定位的div
                    document.querySelectorAll('div').forEach(function(div) {
                      var style = window.getComputedStyle(div);
                      if (style.position === 'fixed' || style.zIndex > 1000000) {
                        div.remove();
                      }
                    });
                  }, 200);
                }
                
                hideElements();
                setTimeout(hideElements, 800);
                setTimeout(hideElements, 1500);
              })();
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://sites.google.com/view/xiangbanyonghuxy'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkGray),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '用户协议',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 300),
            child: WebViewWidget(controller: _controller),
          ),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.vitalOrange,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
