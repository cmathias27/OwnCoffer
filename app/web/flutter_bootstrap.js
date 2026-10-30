{{flutter_js}}
{{flutter_build_config}}

// No request to Google: fallback fonts (Roboto) are served by OwnCoffer
// itself, and the CanvasKit renderer is bundled (--no-web-resources-cdn).
_flutter.loader.load({
  config: {
    fontFallbackBaseUrl: "fonts-fallback/",
  },
});
