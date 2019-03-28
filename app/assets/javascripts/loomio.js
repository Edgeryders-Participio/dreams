document.querySelectorAll("[loomio-thread]").forEach(function(el) {
    Elm.Main.init({ // TODO rename module from main
        node: el,
        flags: { endpoint: "https://talk.theborderland.se"
                 , discussionKey: el.getAttribute('loomio-thread') }
    });
});
