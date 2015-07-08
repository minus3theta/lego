final int WINDOW_SIZE[] = {640, 480};
final color BG_COLOR = color(128, 128, 192);

final int BLOCK_SIZE[] = {20, 40};
final color BLOCK_COLOR[] = {color(80, 80, 80)};

void setup() {
  size(WINDOW_SIZE[0], WINDOW_SIZE[1]);
}

void draw() {
  background(BG_COLOR);
  noStroke();
  fill(BLOCK_COLOR[0]);
  rect(50, 50, BLOCK_SIZE[0], BLOCK_SIZE[1]);
}
