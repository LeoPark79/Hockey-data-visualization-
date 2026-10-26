
Table table;
int[][] dataSet = new int[5][2];
String[] playerNames = new String[5];

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

  for (int i = 0; i < 5; i++) {
    TableRow row = table.getRow(i);
    playerNames[i] = row.getString("Player");
    dataSet[i][0] = row.getInt("Goals");
    dataSet[i][1] = row.getInt("Assists");
  }
}

void draw() {
  background(255);

  // Draw horizontal grid lines and Y-axis labels
  textSize(12);
  textAlign(RIGHT, CENTER);

  for (int i = 0; i <= 100; i += 10) {
    float y = map(i, 0, 100, 650, 100);

    stroke(220);
    line(50, y, 750, y);

    fill(0);
    text(i, 40, y);
  }

  // Draw axes
  stroke(0);
  line(50, 100, 50, 650);
  line(50, 650, 750, 650);

  // Title
  fill(0);
  textAlign(CENTER);
  textSize(24);
  text("Hockey Goals vs. Assists", width / 2, 50);

  // Legend
  fill(230, 25, 75);
  rect(530, 75, 15, 15);

  fill(0);
  textSize(14);
  textAlign(LEFT);
  text("Goals", 550, 88);

  fill(60, 180, 75);
  rect(620, 75, 15, 15);

  fill(0);
  text("Assists", 640, 88);

  // Draw bars
  for (int i = 0; i < dataSet.length; i++) {
    float x = 90 + i * 130;

    float h1 = map(dataSet[i][0], 0, 100, 0, 550);
    float h2 = map(dataSet[i][1], 0, 100, 0, 550);

    // Goals bar
    fill(230, 25, 75);
    rect(x, 650 - h1, 35, h1);

    // Assists bar
    fill(60, 180, 75);
    rect(x + 35, 650 - h2, 35, h2);

    // Player names
    fill(0);
    textAlign(CENTER);
    textSize(11);
    text(playerNames[i], x + 35, 675);
  }
}
