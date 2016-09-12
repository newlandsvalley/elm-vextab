myapp.ports.initialise.subscribe(initialise);

function initialise(vexDivName) {
    init(vexDivName);
}

myapp.ports.requestRender.subscribe(render);


// IMPLEMENTATION

// Load VexTab module.
vextab = VexTabDiv;
vexDiv = null;

function init(vexDivName) {
  console.log(vexDivName);

  VexTab = vextab.VexTab;
  Artist = vextab.Artist;
  Renderer = Vex.Flow.Renderer;

  Artist.DEBUG = true;
  VexTab.DEBUG = false;
  
  try {
     vexDiv = $(vexDivName)[0];
     // Create VexFlow Renderer from canvas element with id vexDiv
     renderer = new Renderer(vexDiv, Renderer.Backends.CANVAS);

     // Initialize VexTab artist and parser.
     artist = new Artist(10, 10, 600, {scale: 0.8});
     vextab = new VexTab(artist);
     myapp.ports.initialised.send(null);
   } catch (e) {
      myapp.ports.rendered.send(e.message);
   }
}

function render(text) {
   try {
      vextab.reset();
      artist.reset();
      vextab.parse(text);
      artist.render(renderer);
      myapp.ports.rendered.send(null);
   } catch (e) {
      myapp.ports.rendered.send(e.message);
   }
}

