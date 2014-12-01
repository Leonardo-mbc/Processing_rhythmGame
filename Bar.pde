class Bar
{
    float x, y, w, h;
    int fls_color, fls = 255;
    
    Bar(float x, float y, float w, float h)
    {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
    }
    
    void draw()
    {
      stroke(41, 70, 102);
      strokeWeight(3);
      line(this.x, this.y, this.x, height);
      //rect(this.x, this.y, this.w, this.h);
    }
    
    void set_fls(int s)
    {
      this.fls_color = s;
      this.fls = 255;
    }
    
    void flush()
    {
      if(this.fls > 0) this.fls -= 10;
      
      if(this.fls_color == 10)
      {
        stroke(255, 140, 0, this.fls);
        strokeWeight(3);
        line(this.x, 0, this.x, height);
        
        fill(255, 140, 0, this.fls);
        textSize(20);
        textAlign(LEFT);
        text("+"+this.fls_color, this.x + 10, height * 0.7 - 20);
        fill(255, 255, 255);
      }
      else if(this.fls_color == 8)
      {
        stroke(173, 255, 47, this.fls);
        strokeWeight(3);
        line(this.x, 0, this.x, height);
        
        fill(173, 255, 47, this.fls);
        textSize(20);
        textAlign(LEFT);
        text("+"+this.fls_color, this.x + 10, height * 0.7 - 20);
        fill(255, 255, 255);
           
      }
    }
}
