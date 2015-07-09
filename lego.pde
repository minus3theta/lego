final int WINDOW_SIZE[] = {800, 600};
final color BG_COLOR = color(128, 128, 192);

final int ORIGIN[] = {20, 20};
final color GROUND_COLOR = color(255, 96, 0);

final int B_VALID = 0;
final int B_INVALID = 1;

final int BLOCK_SIZE[] = {20, 40};
final int BLOCK_NUM[] = {30, 13};
final color BLOCK_COLOR[] = {color(128, 128, 255), color(255, 128, 128)};

int getMi() {
  return mouseX >= ORIGIN[0] ? (mouseX - ORIGIN[0]) / BLOCK_SIZE[0] : -1;
}

int getMj() {
  return mouseY >= ORIGIN[1] ? (mouseY - ORIGIN[1]) / BLOCK_SIZE[1] : -1;
}

int getX(int i) {
  return ORIGIN[0] + BLOCK_SIZE[0] * i;
}

int getY(int j) {
  return ORIGIN[1] + BLOCK_SIZE[1] * j;
}

void setup() {
  size(WINDOW_SIZE[0], WINDOW_SIZE[1]);
}

void drawUnitBlock(int i, int j, int state) {
  noStroke();
  fill(BLOCK_COLOR[state]);
  rect(getX(i), getY(j), BLOCK_SIZE[0], BLOCK_SIZE[1]);
  rect(getX(i) + 5, getY(j) - 5, 9, 5);
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
  noStroke();
  fill(GROUND_COLOR);
  rect(ORIGIN[0], ORIGIN[1] + BLOCK_SIZE[1] * BLOCK_NUM[1],
       BLOCK_SIZE[0] * BLOCK_NUM[0] - 1, BLOCK_SIZE[1] - 1);
  for(int i=0; i<BLOCK_NUM[0]; i++) {
    rect(getX(i) + 5, getY(BLOCK_NUM[1]) - 5, 9, 5);
  }
  // blocks
  drawUnitBlock(4, 5, B_INVALID);
  drawUnitBlock(5, 5, B_INVALID);
  drawUnitBlock(4, 4, B_VALID);

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
