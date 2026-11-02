
Table table;

int[][] dataSet = new int[5][4];
String[] playerNames = new String[5];

int currentView = 0;

void setup() {
  size(800, 800);

  table = loadTable(
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vTF5aG4bOKab2P6bsAeACMO0ntrYMI-UzbqLlxQUP-HStLvf3xi2Yua0AP8k2YBiFN-YHU-hlWoeWFM/pub?output=csv",
    "header,csv"
  );

  if (table == null || table.getRowCount() < 5) {
    println("Error loading CSV or not enough players.");
    return;
  }

  // Load data from Google Sheets
  for (int i = 0; i < 5; i++) {
    TableRow row = table.getRow(i);

    playerNames[i] = row.getString("Player");

    dataSet[i][0] = row.getInt("Games Played");
    dataSet[i][1] = row.getInt("Goals");
    dataSet[i][2] = row.getInt("Assists");
    dataSet[i][3] = row.getInt("Shots");
  }
}

void draw() {
  background(255);

  // Calculate maximum value
  float maxValue = 1;

  for (int i = 0; i < 5; i++) {
    float value = getValue(i);
    maxValue = max(maxValue, value);
  }

  float maxScale = ceil(maxValue * 1.1);

  // Draw grid lines and Y-axis labels
  textSize(12);
  textAlign(RIGHT, CENTER);

  for (int i = 0; i <= 5; i++) {
    float value = maxScale * i / 5;
    float y = map(value, 0, maxScale, 650, 100);

    stroke(220);
    line(50, y, 750, y);

    fill(0);

    if (currentView == 2) {
      text(nf(value, 1, 2), 40, y);
    } else {
      text(nf(value, 1, 1), 40, y);
    }
  }

  // Draw axes
  stroke(0);
  line(50, 100, 50, 650);
  line(50, 650, 750, 650);

  // Draw title
  fill(0);
  textAlign(CENTER);
  textSize(24);
  text(getTitle(), width / 2, 50);

  // Draw bars
  for (int i = 0; i < 5; i++) {
    float x = 90 + i * 130;

    if (currentView == 0) {

      // Goals
      float h1 = map(dataSet[i][1], 0, maxScale, 0, 550);

      fill(230, 25, 75);
      rect(x, 650 - h1, 35, h1);

      // Assists
      float h2 = map(dataSet[i][2], 0, maxScale, 0, 550);

      fill(60, 180, 75);
      rect(x + 35, 650 - h2, 35, h2);

    } else {

      // Derived data
      float value = getValue(i);

      float h = map(value, 0, maxScale, 0, 550);

      fill(60, 120, 220);
      rect(x + 17, 650 - h, 55, h);

      // Display value above bar
      fill(0);
      textAlign(CENTER);
      textSize(12);

      if (currentView == 1) {
        text(nf(value, 1, 2) + "%", x + 45, 650 - h - 15);
      } else {
        text(nf(value, 1, 2), x + 45, 650 - h - 15);
      }
    }

    // Player names
    fill(0);
    textAlign(CENTER);
    textSize(10);
    text(playerNames[i], x + 35, 675);
  }

  // Legend
  if (currentView == 0) {

    fill(230, 25, 75);
    rect(530, 75, 15, 15);

    fill(0);
    textAlign(LEFT);
    textSize(14);
    text("Goals", 550, 88);

    fill(60, 180, 75);
    rect(620, 75, 15, 15);

    fill(0);
    text("Assists", 640, 88);

  } else {

    fill(60, 120, 220);
    rect(350, 75, 15, 15);

    fill(0);
    textAlign(LEFT);
    textSize(14);

    if (currentView == 1) {
      text("Shooting Percentage", 375, 88);
    } else {
      text("Points Per Game", 375, 88);
    }
  }

  // Instructions
  fill(100);
  textAlign(CENTER);
  textSize(14);
  text("Click anywhere to switch graphs", width / 2, 740);

  textSize(12);
  text("Graph " + (currentView + 1) + " / 3", width / 2, 765);
}

// Calculate derived data
float getValue(int i) {

  if (currentView == 1) {

    // Shooting Percentage = Goals / Shots * 100
    if (dataSet[i][3] == 0) {
      return 0;
    }

    return (float)dataSet[i][1] / dataSet[i][3] * 100;

  } else if (currentView == 2) {

    // Points Per Game = (Goals + Assists) / Games Played
    if (dataSet[i][0] == 0) {
      return 0;
    }

    return (float)(dataSet[i][1] + dataSet[i][2])
           / dataSet[i][0];
  }

  return max(dataSet[i][1], dataSet[i][2]);
}

// Get graph title
String getTitle() {

  if (currentView == 0) {
    return "Hockey Goals vs. Assists";
  } else if (currentView == 1) {
    return "Hockey Shooting Percentage";
  } else {
    return "Hockey Points Per Game";
  }
}

// Interactivity
void mousePressed() {

  currentView++;

  if (currentView > 2) {
    currentView = 0;
  }
}
