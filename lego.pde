import java.util.*;

final int WINDOW_SIZE[] = {1000, 600};
final color BG_COLOR = color(128, 128, 192);

final int ORIGIN[] = {20, 500};

final int B_GROUND = 0;
final int B_VALID = 1;
final int B_INVALID = 2;
final int B_VALID_S = 3;
final int B_INVALID_S = 4;

final int BLOCK_SIZE[] = {25, 40};
final int BLOCK_NUM[] = {30, 13};
final color BLOCK_COLOR[] = {color(255, 96, 0, 255),
                             color(128, 128, 255, 255),
                             color(255, 128, 128, 255),
                             color(128, 128, 255, 160),
                             color(255, 128, 128, 160)};

ArrayList<LinkedList<Block>> blk;

int mi;
int mj;
int mi0;
int mj0;

class Block {
  public int i, j;
  public int w;
  public int state;
  public Block(int i, int j, int w, int state) {
    this.i = i;
    this.j = j;
    this.w = w;
    this.state = state;
  }
  public void draw() {
    drawBlock(i, j, w, state);
  }
}

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
  mi0 = mj0 = -1;
  blk = new ArrayList<LinkedList<Block>>(BLOCK_NUM[1]);
  for(int i=0; i<BLOCK_NUM[1]; i++) {
    blk.add(new LinkedList<Block>());
  }
}

void drawBlock(int i, int j, int w, int state) {
  fill(BLOCK_COLOR[state]);
  stroke(0);
  strokeWeight(1);
  for(int k=0; k<w; k++) {
    rect(getX(i+k) + 6, getY(j) - 5, 11, 5);
  }
  rect(getX(i), getY(j), BLOCK_SIZE[0] * w - 1, BLOCK_SIZE[1] - 1);
}

Iterator<Block> blockUnderCursor(int i, int j) {
  for(Iterator<Block> p=blk.get(j).iterator(); p.hasNext(); ){
    Block b = p.next();
    if(i >= b.i && i < b.i + b.w) {
      return p;
    }
  }
  return null;
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
  for(int j=0; j<BLOCK_NUM[1]; j++) {
    for(Iterator<Block> p=blk.get(j).iterator(); p.hasNext(); ) {
      Block b = p.next();
      b.draw();
    }
  }

  mi = getMi();
  mj = getMj();
  if(mi >= 0 && mi < BLOCK_NUM[0] &&
     mj >= 0 && mj < BLOCK_NUM[1]) {
    if(mousePressed) {
      int i = mi < mi0 ? mi : mi0;
      int w = mi < mi0 ? mi0 - mi + 1 : mi - mi0 + 1;
      int s = (w==2 || w==3 || w==4 || w==6) ? B_VALID_S : B_INVALID_S;
      if(w != 1) {
        drawBlock(i, mj0, w, s);
      }
    } else {
      stroke(0);
      strokeWeight(3);
      noFill();
      rect(getX(mi), getY(mj), BLOCK_SIZE[0] - 1, BLOCK_SIZE[1] - 1);
    }
  }
}

void mousePressed() {
  mi0 = getMi();
  mj0 = getMj();
  if(mi >= 0 && mi < BLOCK_NUM[0] &&
     mj >= 0 && mj < BLOCK_NUM[1]) {
    cursor(CROSS);
    Iterator<Block> p = blockUnderCursor(mi, mj);
    if(p != null) {
      p.remove();
    }
  }
}

void mouseReleased() {
  if(mi < 0) {
    mi = 0;
  } else if(mi >= BLOCK_NUM[0]) {
    mi = BLOCK_NUM[0] - 1;
  }
  int i = mi < mi0 ? mi : mi0;
  int w = mi < mi0 ? mi0 - mi + 1 : mi - mi0 + 1;
  for(int k=i; k<i+w; k++) {
    Iterator<Block> p = blockUnderCursor(k, mj0);
    if(p != null) {
      p.remove();
    }
  }
  int s = (w==2 || w==3 || w==4 || w==6) ? B_VALID : B_INVALID;
  if(w != 1) {
    blk.get(mj0).add(new Block(i, mj0, w, s));
  }
  cursor(ARROW);
}

