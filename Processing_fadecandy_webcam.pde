import gohai.glvideo.*;
GLCapture video;
OPC opc;

final int boxesAcross = 2;
final int boxesDown = 2;
final int ledsAcross = 8;
final int ledsDown = 8;
// initialized in setup()
float spacing;
int x0;
int y0;

void setup()
{
  size(720, 480, P2D); // Important to note the renderer

  // String[] devices = GLCapture.list(); // Get the list of cameras connected to the Pi

  // Get the resolutions and framerates supported by the first camera
  // if (0 < devices.length) {
  //  String[] configs = GLCapture.configs(devices[0]);
  // }

  video = new GLCapture(this);  // this will use the first recognized camera by default
  // you could be more specific also, e.g.
  //video = new GLCapture(this, devices[0], configs[0]);

  video.start();

  opc = new OPC(this, "127.0.0.1", 7890); // Connect to the local instance of fcserver

  spacing = (float)min(height / (boxesDown * ledsDown + 1), width / (boxesAcross * ledsAcross + 1));
  x0 = (int)(width - spacing * (boxesAcross * ledsAcross - 1)) / 2;
  y0 = (int)(height - spacing * (boxesDown * ledsDown - 1)) / 2;

  final int boxCentre = (int)((ledsAcross - 1) / 2.0 * spacing); // probably using the centre in the ledGrid8x8 method
  int ledCount = 0;
  for (int y = 0; y < boxesDown; y++) {
    for (int x = 0; x < boxesAcross; x++) {
      opc.ledGrid8x8(ledCount, x0 + spacing * x * ledsAcross + boxCentre, y0 + spacing * y * ledsDown + boxCentre, spacing, 0, false, false);
      ledCount += ledsAcross * ledsDown;
    }
  }
}

void draw()
{
  background(0);

  if (video.available()) {   // If the camera is sending new data, capture that data
    video.read();
  }

  image(video, 0, 0, width, height);
}
