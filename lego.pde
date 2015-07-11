final int WINDOW_SIZE[] = {800, 600};
final color BG_COLOR = color(128, 128, 192);

final int ORIGIN[] = {20, 500};

final int B_GROUND = 0;
final int B_VALID = 1;
final int B_INVALID = 2;

final int BLOCK_SIZE[] = {20, 40};
final int BLOCK_NUM[] = {30, 13};
final color BLOCK_COLOR[] = {color(255, 96, 0), color(128, 128, 255), color(255, 128, 128)};

int getMi() {
  return mouseX >= ORIGIN[0] ? (mouseX - ORIGIN[0]) / BLOCK_SIZE[0] : -1;
}

int getMj() {
  return mouseY <= ORIGIN[1] + BLOCK_SIZE[1] ?
    (ORIGIN[1] + BLOCK_SIZE[1] - mouseY) / BLOCK_SIZE[1] : -1;
}

int getX(int i) {
  return ORIGIN[0] + BLOCK_SIZE[0] * i;
}

int getY(int j) {
  return ORIGIN[1] - BLOCK_SIZE[1] * j;
}

void setup() {
  size(WINDOW_SIZE[0], WINDOW_SIZE[1]);
}

void drawBlock(int i, int j, int w, int state) {
  fill(BLOCK_COLOR[state]);
  stroke(0);
  strokeWeight(1);
  for(int k=0; k<w; k++) {
    rect(getX(i+k) + 5, getY(j) - 5, 9, 5);
  }
  rect(getX(i), getY(j), BLOCK_SIZE[0] * w - 1, BLOCK_SIZE[1] - 1);
}

void draw() {
  background(BG_COLOR);
  // grid
  fill(255);
  stroke(128);
  strokeWeight(1);
  for(int i=0; i<BLOCK_NUM[0]; i++) {
    for(int j=0; j<BLOCK_NUM[1]; j++) {
      rect(getX(i), getY(j), BLOCK_SIZE[0] - 1, BLOCK_SIZE[1] - 1);
    }
  }
  // ground
  drawBlock(0, -1, BLOCK_NUM[0], B_GROUND);
  // blocks
  drawBlock(4, 4, 2, B_VALID);
  drawBlock(0, 5, 4, B_VALID);
  drawBlock(4, 5, 4, B_INVALID);
  drawBlock(8, 5, 4, B_INVALID);

  int mi = getMi();
  int mj = getMj();
  if(mi >= 0 && mi < BLOCK_NUM[0] &&
     mj >= 0 && mj < BLOCK_NUM[1]) {
    stroke(0);
    strokeWeight(3);
    noFill();
    rect(getX(mi), getY(mj), BLOCK_SIZE[0] - 1, BLOCK_SIZE[1] - 1);
    cursor(CROSS);
  } else {
    cursor(ARROW);
  }
  //
}
