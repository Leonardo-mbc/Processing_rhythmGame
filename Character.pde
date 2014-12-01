class Character
{
    float x, y, w, h;
    float step;
    
    Character(float x, float y, float w, float h)
    {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
    }
    
    void draw()
    {
      stroke(41, 70, 102);
      strokeWeight(h);
      line(0, this.y + this.h / 2, width, this.y + this.h / 2);
    }
}
