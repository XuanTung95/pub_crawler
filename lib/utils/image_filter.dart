

class ImageFilter {
  static bool shouldIgnoreImage(String url) {
    return url.startsWith('https://img.shields.io')
        || url.contains('buymeacoffee.com')
        || url.contains('badge.svg')
        || (url.startsWith('https://avatars') && url.contains('.githubusercontent.com/'))
        || url.contains('become_a_patron_button.png')
        || url.contains('flutter_favorite.png')
        || url.contains('Stream-logo-with-background')
        || url.startsWith('https://tinyurl.com')
        || url.startsWith('https://badges.bar')
        || (url.startsWith('https://github.com') && url.contains('badge.svg'));
  }
}