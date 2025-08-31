import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tamago/presentation/viewmodels/anime_detail/anime_detail_bloc.dart';

class AnimeScrapingWebView extends StatefulWidget {
  final int malId;
  final String animeTitle;
  final bool isVisible;

  const AnimeScrapingWebView({
    super.key,
    required this.malId,
    required this.animeTitle,
    this.isVisible = false,
  });

  @override
  State<AnimeScrapingWebView> createState() => _AnimeScrapingWebViewState();
}

class _AnimeScrapingWebViewState extends State<AnimeScrapingWebView> {
  late final WebViewController _controller;
  bool _isInitialized = false;
  bool _hasStartedScraping = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Page started loading
          },
          onPageFinished: (String url) {
            // Page finished loading
            if (_isInitialized && !_hasStartedScraping) {
              _startScraping();
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse('about:blank')); // Start with blank page

    setState(() {
      _isInitialized = true;
    });
  }

  void _startScraping() {
    if (!_hasStartedScraping && mounted) {
      _hasStartedScraping = true;

      // Trigger the scraping process
      context.read<AnimeDetailBloc>().add(
            ScrapeAnimeProviders(
              malId: widget.malId,
              animeTitle: widget.animeTitle,
              webViewController: _controller,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return BlocListener<AnimeDetailBloc, AnimeDetailState>(
      listener: (context, state) {
        if (state is AnimeDetailLoaded) {
          if (state.scrapingInProgress &&
              _isInitialized &&
              !_hasStartedScraping) {
            _startScraping();
          }
        }
      },
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    Icon(
                      Icons.web,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Scraping anime providers...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
                      builder: (context, state) {
                        if (state is AnimeDetailLoaded &&
                            state.scrapingInProgress) {
                          return const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isInitialized
                    ? WebViewWidget(controller: _controller)
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
