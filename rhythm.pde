import hypermedia.net.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.serial.*;
Serial serial;
int bar_quant = 4, csv_length, csvWidth, ball_quant, select = 0, score = 0;
int[] chara_pos = {0, 0, 0, 0}, set_line;
String set_song = "none";
String[][] csv, songs;
float bpm, time, start_time;
float[] set_offset;
Boolean game = true, menu = true, mode = false;
ArrayList input_list = new ArrayList();
PrintWriter output;
PFont menu_font;
FFT fft;
int rb = -1;

Bar[] bars = new Bar[bar_quant];
Character[] charas = new Character[bar_quant];
Ball[] balls;

PImage character_image1, character_image2;

Minim minim;
AudioPlayer music, menu_music;
AudioSample c_select, enter;

void setup()
{
  fill(255, 255, 255);
  size(400, 500);
  //serial = new Serial(this, "/dev/tty.usbmodem1421", 9600);
  
  /*** songs_list setup -> */
  csvWidth = 6;
  String lines[] = loadStrings("./score/score_list.csv");

  //calculate max width of csv file
  for (int i=0; i<lines.length; i++)
  {
    String [] chars=split(lines[i], ',');
    if (csvWidth < chars.length)
    {
      csvWidth=chars.length;
    }
  }

  //create csv array based on # of rows and columns in csv file
  songs = new String [lines.length][csvWidth];
  //parse values into 2d array
  for (int i=0; i<lines.length; i++)
  {
    String [] temp = new String [lines.length];
    temp = split(lines[i], ',');
    for (int j=0; j<temp.length; j++)
    {
      songs[i][j] = temp[j];
    }
  }
  /* <- songs_list setup ***/

  character_image1 = loadImage("img/inv1.png");
  character_image2 = loadImage("img/inv2.png");
  minim = new Minim(this);
  
  c_select = minim.loadSample("sounds/select.mp3");
  enter = minim.loadSample("sounds/enter.mp3");
  menu_music = minim.loadFile("songs/Timetrip.mp3", 1024);
  fft = new FFT(menu_music.bufferSize(), menu_music.sampleRate());
  menu_music.loop();
}

void draw()
{
  background(114, 177, 229);
  menu_font = loadFont("Bauhaus93-48.vlw");
  if(menu)
  {
    fft.forward(menu_music.mix);
    for(int i = 5; i < fft.specSize(); i++)
    {
      stroke(38, 87, 127);
      strokeWeight(8);
      line((i - 5) * 8 + 1, height, (i - 5) * 8 + 1, height - (fft.getBand(i)));
    }
    
    //hist_circle_drow();
  
    stroke(38, 87, 127);
    strokeWeight(4);
    for (int i=0; i<4; i++)
    {
      float ay = height/2 + (i * 20 *atan(millis()/1000.0)) + 150 * sin(millis()/1000.0);
      float by = height/2 - 200 + (i * 40 *atan(millis()/1000.0)) + 150 * cos(millis()/1000.0);
      line(0, ay, width, by);
      ellipse(width/2 + 100 * sin(millis()/1000.0) + 60 * sin(i*millis()/1000.0), height/2 + 80 * sin(millis()/1000.0) + 50 * sin(i*millis()/1000.0), 10, 10);
    }
  }

  if (game)
  {
    if (menu)
    {
      menu();

      if (set_song != "none")
      { 
        song_init();
      }
    }
    else
    {// playing ->
      time = millis() / 1000.0 - start_time;
      input_timing();
      /*if(!mode && time > 30)
      {
        enter_menu();
      }*/

      /*** Game ACTION -> */
      for (int i=0; i<bar_quant; i++)
      {
        bars[i].draw();
        charas[i].draw();
        bars[i].flush();
      }
      
      for (int i=0; i<ball_quant; i++)
      {
        if (!balls[i].del)
        {
          balls[i].tap_test(charas[balls[i].line]);
          balls[i].move();
          balls[i].draw();
        }
      }
      
      // player text
      fill(255, 255, 255);
      textSize(20);
      textAlign(RIGHT);
      text(score, width - 10, 20);
      
      textAlign(CENTER);
      text(time, 35, 20);
      
      textAlign(LEFT);
      text("timing line", 10, charas[0].y + charas[0].h - 5);
      /* <- Game ACTION ***/
      
      start_blink("Game Start");
      
      // <- playing
    }
  }
  else
  {
    result_screen();
  }
}

void keyReleased()
{
  key = 0;
  keyCode = 0;
}

void music_stop()
{
  menu_music.close();
  music.close();
  minim.stop();
}

void menu()
{
  fill(255, 255, 255);

  textFont(menu_font, 35);
  textAlign(CENTER);
  text("music select", width/2, 40);

  textSize(20);
  textAlign(RIGHT);
  for (int i=0; i<songs.length; i++)
  {
    text(songs[i][0] +" ("+ songs[i][1] +")", width - 20, height/(songs.length+1) * (i+1) + 30);
  }
  textAlign(LEFT);
  float cursor = height/(songs.length+1) * (select+1) - 7 + 30;
  float cursor_bar = height/(songs.length+1) * (select+1) + 20 + 30;

  strokeWeight(2);
  triangle(20, cursor-10, 35, cursor, 20, cursor + 10);
  stroke(255, 255, 255);
  strokeWeight(3);
  line(20, cursor_bar - 10, width - 20, cursor_bar - 10);

  switch(keyCode)
  {
  case DOWN:
    keyCode = 0;
    if (select < songs.length - 1)
    {
      select += 1;
      c_select.trigger();
    }
    break;

  case UP:
    keyCode = 0;
    if (0 < select)
    {
      select -= 1;
      c_select.trigger();
    }
    break;

  default:
    switch(key)
    {
      case ' ':
        key = 0;
        enter.trigger();
        set_song = songs[select][3];
        bpm = Float.parseFloat(songs[select][4]);
        music = minim.loadFile("songs/"+ songs[select][2] +"");
      break;
      
      case 'r':
        
      break;
    }
    break;
  }

  fill(255, 255, 255);
}

void song_init()
{
  /*** score setup -> */
  csvWidth = 2;
  String[] lines = loadStrings("./score/"+set_song);

  //calculate max width of csv file
  for (int i=0; i<lines.length; i++)
  {
    String [] chars=split(lines[i], ',');
    if (csvWidth < chars.length)
    {
      csvWidth=chars.length;
    }
  }

  //create csv array based on # of rows and columns in csv file
  csv = new String [lines.length][csvWidth];
  csv_length = ball_quant = lines.length;
  set_offset = new float[csv_length];
  set_line = new int[csv_length];
  //parse values into 2d array
  for (int i=0; i<lines.length; i++)
  {
    String [] temp = new String [lines.length];
    temp = split(lines[i], ',');
    for (int j=0; j<temp.length; j++)
    {
      csv[i][j] = temp[j];
    }
  }

  for (int i=0; i<csv_length; i++)
  {
    set_offset[i] = Float.parseFloat(csv[i][0]);
    set_line[i] = Integer.parseInt(csv[i][1]);
  }
  /* <- score setup ***/

  /*** bar and chara init. -> */
  for (int i=0; i<bar_quant; i++)
  {
    bars[i] = new Bar(float(width / 5 * (i+1)), 0, 10, height);
    charas[i] = new Character(float(width / 5 * (i+1) - 29/2), height * 0.75 + chara_pos[i], 33, 24);
  }
  /* <- bar and chara init. ***/

  /*** ball init -> */
  balls = new Ball[ball_quant];
  for (int i=0; i<ball_quant; i++)
  {
    balls[i] = new Ball(float(width / 2), 0, 20, 0, bpm / 30, set_offset[i], set_line[i]);
  } 
  /* <- ball init ***/

  menu_music.close();
  menu = false;
  music.play();
  start_time = millis() / 1000.0;
}

void result_screen()
{
  textSize(30);
  textAlign(CENTER);
  text("Game Over", width/2, height/2 -30);
  String scr = "Score : " + score;
  text(scr, width/2, height/2);
  text("Press R to Retry.", width/2, height/2 + 30);

  if (key == 'r' || key == 'R')
  {
    score = 0;
    game = true;
  }
}

void input_timing()
{
  switch(key)
  {
  case'a':
    key = 0;
    mode = true;
    println(time+",0");
    input_list.add(time+",0");
    break;
  case's':
    key = 0;
    mode = true;
    println(time+",1");
    input_list.add(time+",1");
    break;
  case'd':
    key = 0;
    mode = true;
    println(time+",2");
    input_list.add(time+",2");
    break;
  case'f':
    key = 0;
    mode = true;
    println(time+",3");
    input_list.add(time+",3");
    break;
  case'w':
    key = 0;
    output = createWriter("input/"+songs[select][3]);
    for (int i=0; i<input_list.size (); i++) output.println(input_list.get(i));
    output.flush(); 
    output.close(); 
    println("timing saved.");
    break;
  case'q':
    key = 0;
    
    enter_menu();
    break;
  }
}

void start_blink(String m)
{
  /*** start action -> */
  fill(255, 255, 255);
  textSize(40);
  textAlign(CENTER, CENTER);
  if (time < 0.5)
  {
    text(m, width/2, height/2 - 50);
  } else if (1.0 < time && time < 1.5)
  {
    text(m, width/2, height/2 - 50);
  }
  /* <- start action ***/
}

void enter_menu()
{
  score = 0;
  menu = true;
  set_song = "none";
  music_stop();
  c_select = minim.loadSample("sounds/select.mp3");
  enter = minim.loadSample("sounds/enter.mp3");
  menu_music = minim.loadFile("songs/Timetrip.mp3");
  menu_music.loop();
}

void hist_circle_drow()
{
  for(int i = 0; i < fft.specSize(); i++)
  {
    stroke(38, 87, 127, 32);
    strokeWeight(5);
    float ct = PI/64 * i;
    float hh = log(fft.getBand(i))* 50;
    line(width/2 + 0*cos(ct), height/2 + 0*sin(ct), width/2 + hh*cos(ct), height/2 + hh*sin(ct));
  }
}

/* byte[] to int(OMAJINAI) */
int byteArrayToInt(byte[] b)
{
  return b[3] & 0xFF | (b[2] & 0xFF) << 8 | (b[1] & 0xFF) << 16 | (b[0] & 0xFF) << 24;
}

void serialEvent(Serial whichPort)
{
  //delay(100);
  //whichPort.readBytes(receiveBuffer);
  rb = serial.read();
  //println(rb);
}
