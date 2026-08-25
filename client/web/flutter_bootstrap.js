{{flutter_js}}
{{flutter_build_config}}

function hideAppLoader() {
  var loader = document.getElementById('loading-container');
  if (loader) {
    loader.style.opacity = '0';
    setTimeout(function() {
      if (loader && loader.parentNode) {
        loader.parentNode.removeChild(loader);
      }
    }, 250);
  }
}

_flutter.loader.load({
  serviceWorkerSettings: null,
  onEntrypointLoaded: async function(engineInitializer) {
    try {
      var appRunner = await engineInitializer.initializeEngine();
      hideAppLoader();
      await appRunner.runApp();
    } catch (err) {
      console.error('Flutter engine initialization error:', err);
      hideAppLoader();
    }
  }
});
