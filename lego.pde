import java.util.*;

final int WINDOW_SIZE[] = {1000, 605};
final color BG_COLOR = color(255, 255, 224);

final int ORIGIN[] = {20, 515};

final int B_GROUND = 0;
final int B_VALID = 1;
final int B_INVALID = 2;
final int B_UNGROUND = 3;
final int B_VALID_S = 4;
final int B_INVALID_S = 5;
final int B_UNGROUND_S = 6;

final int BLOCK_SIZE[] = {27, 35};
final int BLOCK_NUM[] = {28, 15};
final color BLOCK_COLOR[] = {color(192, 128, 64, 255),
                             color(128, 128, 255, 255),
                             color(255, 128, 128, 255),
                             color(128, 128, 160, 255),
                             color(128, 128, 255, 160),
                             color(255, 128, 128, 160),
                             color(128, 128, 160, 160)};

ArrayList<LinkedList<Block>> blk;

final int BLOCK_SET[] = {0, 0, 6, 6, 4, 0, 4};
final int BLOCK_SET_POS[] = {0, 0, 11, 8, 5, 0, 2};
int blockCount[];

int mi;
int mj;
int mi0;
int mj0;

class Block {
  public int i, j;
  public int w;
  public int state;
  public boolean visited;
  public Block(int i, int j, int w, int state) {
    this.i = i;
    this.j = j;
    this.w = w;
    this.state = state;
  }
  public void draw() {
    drawBlock(i, j, w, state);
  }
  public void dfs() {
    if(visited) {
      return;
    }
    visited = true;
    state = B_VALID;
    for(int k = j-1; k <= j+1; k += 2) {
      if(k < 0 || k >= BLOCK_NUM[1]) {
        continue;
      }
      for(Iterator<Block> p=blk.get(k).iterator(); p.hasNext(); ) {
        Block b = p.next();
        if(i + w > b.i && i < b.i + b.w) {
          b.dfs();
        }
      }
    }
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
  blockCount = new int[BLOCK_SET.length];
}

void drawBlock(int i, int j, int w, int state) {
  fill(BLOCK_COLOR[state]);
  stroke(0);
  strokeWeight(1);
  for(int k=0; k<w; k++) {
    rect(getX(i+k) + 6, getY(j) - 5, 13, 5);
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
  for(int i=0; i < blockCount.length; i++) {
    blockCount[i] = 0;
  }
  for(int j=0; j<BLOCK_NUM[1]; j++) {
    for(Iterator<Block> p=blk.get(j).iterator(); p.hasNext(); ) {
      Block b = p.next();
      b.visited = false;
      b.state = B_UNGROUND;
      if(b.w < blockCount.length) {
        blockCount[b.w]++;
      }
    }
  }
  // for(int j=0; j<BLOCK_NUM[1]; j++) {
  //   for(Iterator<Block> p=blk.get(j).iterator(); p.hasNext(); ) {
  //     Block b = p.next();
  //     b.state = b.w < blockCount.length && blockCount[b.w] <= BLOCK_SET[b.w] ?
  //       B_UNGROUND : B_INVALID;
  //   }
  // }
  for(Iterator<Block> p=blk.get(0).iterator(); p.hasNext(); ) {
    Block b = p.next();
    b.dfs();
  }
  for(int j=0; j<BLOCK_NUM[1]; j++) {
    for(Iterator<Block> p=blk.get(j).iterator(); p.hasNext(); ) {
      Block b = p.next();
      b.state = b.w < blockCount.length && blockCount[b.w] <= BLOCK_SET[b.w] ?
        b.state : B_INVALID;
      b.draw();
    }
  }

  // side pane
  textSize(24);
  textAlign(RIGHT);
  for(int i=0; i<blockCount.length; i++) {
    if(BLOCK_SET[i] > 0) {
      boolean valid = blockCount[i] <= BLOCK_SET[i];
      drawBlock(BLOCK_NUM[0] + 1, BLOCK_SET_POS[i], i, valid ? B_VALID : B_INVALID);
      fill(valid ? color(0, 0, 0) : color(255, 0, 0));
      text(blockCount[i] + " / " + BLOCK_SET[i],
           getX(BLOCK_NUM[0] + 6), getY(BLOCK_SET_POS[i]-1) + 35);
    }
  }

  mi = getMi();
  mj = getMj();
  if(mi >= 0 && mi < BLOCK_NUM[0] &&
     mj >= 0 && mj < BLOCK_NUM[1] &&
     mi0 >= 0 && mi0 < BLOCK_NUM[0]) {
    if(mousePressed) {
      int i = mi < mi0 ? mi : mi0;
      int w = mi < mi0 ? mi0 - mi + 1 : mi - mi0 + 1;
      if(w < BLOCK_SET.length && BLOCK_SET[w] > 0) {
        stroke(64, 64, 64);
        strokeWeight(3);
        noFill();
        rect(getX(BLOCK_NUM[0] + 1) - 10, getY(BLOCK_SET_POS[w]) - 15,
             BLOCK_SIZE[0] * w + 20, BLOCK_SIZE[1] + 25);
      }
      if(w != 1) {
        int s = mj0 == 0 ? B_VALID_S : B_UNGROUND_S;
        if(w < blockCount.length && blockCount[w] < BLOCK_SET[w]) {
          for(int k = mj0-1; k <= mj0+1; k += 2) {
            if(s == B_VALID_S) {
              break;
            }
            if(k < 0 || k >= BLOCK_NUM[1]) {
              continue;
            }
            for(Iterator<Block> p=blk.get(k).iterator(); p.hasNext(); ) {
              Block b = p.next();
              if(b.visited && i + w > b.i && i < b.i + b.w) {
                s = B_VALID_S;
                break;
              }
            }
          }
        } else {
          s = B_INVALID_S;
        }
        drawBlock(i, mj0, w, s);
      }
      // draw arrow
      stroke(64, 64, 64);
      strokeWeight(3);
      int x1 = getX(0);
      int x2 = getX(BLOCK_NUM[0]);
      int y = getY(mj0) + BLOCK_SIZE[1] / 2;
      line(x1 + 10, y, x2 - 8, y);
      noStroke();
      fill(64, 64, 64);
      triangle(x1, y + 1, x1 + 20, y - 5, x1 + 20, y + 7);
      triangle(x2, y + 1, x2 - 20, y - 5, x2 - 20, y + 7);
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
  if(mi0 >= 0 && mi0 < BLOCK_NUM[0] &&
     mj0 >= 0 && mj0 < BLOCK_NUM[1]) {
    int i = mi < mi0 ? mi : mi0;
    int w = mi < mi0 ? mi0 - mi + 1 : mi - mi0 + 1;
    for(int k=i; k<i+w; k++) {
      Iterator<Block> p = blockUnderCursor(k, mj0);
      if(p != null) {
        p.remove();
      }
    }
    if(w != 1) {
      blk.get(mj0).add(new Block(i, mj0, w, B_VALID));
    }
    cursor(ARROW);
  }
}

