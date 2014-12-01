class Ball
{
   float x, y, r, vx, vy;
   int line;
   boolean tapped = false;
   boolean del = false;
   
   Ball(float x, float y, float r, float vx, float vy, float ofs, int line)
   {
     this.x = float(width / 5 * (line + 1));
     this.y = ofs * -bpm * 2  + height * 0.75   + Float.parseFloat(songs[select][5]);
     this.r = r;
     this.vx = vx;
     this.vy = vy;
     this.line = line;
   }
   
   void move()
   {
     if(height < this.y)
     {
       this.tapped = true;
       this.del = true;
     }
     else
     {// move down.
       this.x += this.vx;
       this.y += this.vy;
     }
     
     if(this.x < 0 || width < this.x)
     {
       this.del = true;
     }
   }
   
   void tap_test(Character chara)
   {
     if(!this.tapped && chara.y - chara.h < this.y)
     {
       boolean line_check = false;
       if(this.line == 0 && (key == 'z' || rb == 0)) line_check = true;
       if(this.line == 1 && (key == 'x' || rb == 1)) line_check = true;
       if(this.line == 2 && (key == 'c' || rb == 2)) line_check = true;
       if(this.line == 3 && (key == 'v' || rb == 3)) line_check = true;
        
       if(line_check)
       {
         if(chara.y <= this.y && this.y <= chara.y + chara.h)
         {
           score += 10;
           this.vx = +5;
           this.vy = 0;
           
           bars[this.line].set_fls(10);
           
         }
         else if(chara.y - chara.h <= this.y && this.y <= chara.y + 2*chara.h)
         {
           score += 8;
           this.vx = -5;
           this.vy = 0;
           
           bars[this.line].set_fls(8);
         }
         
         this.tapped = true;
       }
     }
   }
   
   void draw()
   {
      strokeWeight(3);
      stroke(41, 70, 102);
      fill(255, 255, 255);
      ellipse(this.x, this.y, this.r, this.r);
   }
}
