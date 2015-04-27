/*
Title: Motion detection and scoring in Carrom
Authors (alphabetical order): Mohak Sukhwani, Suriya Singh, Vishakh Duggal
Details: For detailed project report pls. contact the authors 
*/


#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
#include <stdio.h>
#define FRAME_SKIP 5	//number of frames to skip
#define WINDOW 30	//number of frames after which score is being updated
using namespace cv;
using namespace std;

//int p1_score=0, p2_score=0;
int black_count[WINDOW]={0},white_count[WINDOW]={0},mag_count[WINDOW]={0}; //number of pieces of each color for every frame in the window
int frame =0;
int f=1;
int max_w=0,max_b=0,max_m=0; // use to store score to uodate the score board
Mat score; 	//image to show score
Mat img;	//input image is extracted into this matrix
int raani_flag=0;	//flag whether the queen has been taken
int prev_p1=0,prev_p2=0;	// scores scored by players in previous updation
int p=0,duration=0;		// duration after which queen has been taken
//VideoWriter outputVideo=VideoWriter("Movie.mpg", CV_FOURCC('P','I','M','1') , 25, Size(984,655));  // write VDO output

void init()	// function to update score
{
  rectangle(score,Point(0,0),Point(300,score.rows),Scalar(0,0,0),CV_FILLED);

  if(raani_flag==1 && duration==2)
  {
    if(prev_p1>max_w)
    {
      p=2;
    }    
    else if(prev_p2>max_b)
    {
      p=3;
    }
  }
  else if(duration<2)
  {
    p=0;
  }

  line(score,Point(0,50),Point(score.cols,50),Scalar(255,255,255),1,8);
  putText(score,"Natraj",Point(50,30),FONT_HERSHEY_SIMPLEX,0.80,Scalar(255,255,255));
  putText(score,"Praveen",Point(175,30),FONT_HERSHEY_SIMPLEX,0.80,Scalar(255,255,255));
  line(score,Point(150,0),Point(150,score.rows),Scalar(255,255,255),1,8);
  for(int i=0;i<max_b;i++)
  {
    char a[20];
    sprintf(a,"%d",i+1);
    putText(score,a,Point(195,125+40*i),FONT_HERSHEY_SIMPLEX,0.50,Scalar(255,255,255));
    circle( score, Point(200,120+40*i), 15, Scalar(255,0,0), 3, 8, 0 );
  }
  prev_p2=max_b;

  for(int i=0;i<max_w;i++)
  {
    char a[20];
    sprintf(a,"%d",i+1);
    putText(score,a,Point(70,125+40*i),FONT_HERSHEY_SIMPLEX,0.50,Scalar(255,255,255));
    circle( score, Point(75,120+40*i), 15, Scalar(0,255,0), 3, 8, 0 );
  }

  if(p==2)
  {
    rectangle(score,Point(50,530),Point(100,score.rows),Scalar(120,100,240),CV_FILLED);
  }
  else if(p==3)
  {
    rectangle(score,Point(175,530),Point(225,score.rows),Scalar(120,100,240),CV_FILLED);
  }

  prev_p1=max_w;

  if(max_m==0)		// set flag that queen has been taken
  {
    raani_flag=1;
    duration++;
  }
  else if(duration <2)
  {
    raani_flag=0;
  }

  imshow("score",score);

  waitKey(1);
}


void get_max_count()	//get count of each color used to update score
{
  max_w=0,max_b=0,max_m=0;
  for(int i=0;i<WINDOW;i++)
  {
   
      max_w=max_w+0.5+((float)(white_count[i]-max_w))/(i+1);
      
     max_b=max_b+0.5+((float)(black_count[i]-max_b))/(i+1);
   
       if(mag_count[i]>0)
    {
      max_m=1;
    }

    white_count[i]=0;
    black_count[i]=0;
    mag_count[i]=0;
  }
  return;
}



int on_board(int row, int col) 	//function to decide whether the passes coordinate of the circle is present inside the playing area
{
  int left_margin=60;
  int right_margin=610;
  int top_margin=55;
  int bottom_margin=610;
  if(col<left_margin || col>right_margin)
  {
    if(row<top_margin || row > bottom_margin)
    {
      return 0;
    }
  }
  return 1;
} 

int is_white(int row,int col)	// check whether the current piece is white or not
{
  Mat img_white;
  char name[100];
  sprintf(name,"../N1/white/%d.jpg",f);
  img_white=imread(name,0);
  if(img_white.at<uchar>(Point(col,row)) < 50)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}


int is_not_skin(int r, int g, int b)	//check whether the current pixel intensity corresponds to skin color
{
  float min1, max1, delta;
  float h,s,v;

  min1 = min( r, min(g, b) );
  max1 = max( r, max(g, b) );
  v = max1;       // v
  delta = max1 - min1;
  
  if( max1 != 0 )
    s = delta / max1;   
  else {
    s = 0;
    h = -1;
  }
  if( r == max1 )
    h = ( g - b ) / delta;   
  else if( g == max1 )
    h = 2 + ( b - r ) / delta; 
  else
    h = 4 + ( r - g ) / delta; 
  h=h* 60;      
  if( h < 0 )
    h += 360;

  if(((h >=0 && h <=50) && (s >=0.23 && s <0.68)))
  {
    printf("\nCircle on skin\n");
    return 0;
  }
  else
  {
    return 1;
  }
}

int is_magenta(int row,int col)		//check whether the circle detected is of magenta color
{
  Mat img_raani;
  char name[100];
  sprintf(name,"../N1/red/%d.jpg",f);
  img_raani=imread(name,0);
  int red=img.at<Vec3b>(row,col)[2];
  int green=img.at<Vec3b>(row,col)[1];
  int blue=img.at<Vec3b>(row,col)[0];
  if(img_raani.at<uchar>(Point(col,row)) < 50 && is_not_skin(red,green,blue))
  {
    return 1;
  }
  else
  {
    return 0;
  }
}


int is_black(int row,int col)	//check whether the circle detected belongs to black piece
{
  Mat img_black, img_skin;
  char name[100];
  int red=img.at<Vec3b>(row,col)[2];
  int green=img.at<Vec3b>(row,col)[1];
  int blue=img.at<Vec3b>(row,col)[0];
  int condition=red>15 && red<60 && green>15 && green<60 && blue>20 && blue<75;
  if( condition && is_not_skin(red,green,blue))
  {
    return 1;
  }
  else
  {
    return 0;
  }
}

void get_count(Mat src)		// find circles and get count of circle each color
{
  Mat src1=src;
  Mat src_gray;

  cvtColor( src, src_gray, CV_BGR2GRAY );
  GaussianBlur( src_gray, src_gray, Size(9, 9), 5, 5 );
  vector<Vec3f> circles;

  HoughCircles( src_gray, circles, CV_HOUGH_GRADIENT, 1, 20, 20, 12, 10, 15 );	//apply hough circle transform
  
  for( size_t i = 0; i < circles.size(); i++ )
  {

    Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
    int radius = cvRound(circles[i][2]);
   // circle( src, center, radius, Scalar(100,100,100), 3, 8, 0 );	//color all the circles
    if(on_board(center.y, center.x))
    {
      if(is_white(center.y,center.x))
      {
        circle( src, center, radius, Scalar(255,255,255), 3, 8, 0 );
        white_count[frame]=white_count[frame]+1;
      }
    if(is_black(center.y, center.x))
      {
        circle( src, center, radius, Scalar(0,0,0), 3, 8, 0 );
        black_count[frame]=black_count[frame]+1;
      }

      else if(is_magenta(center.y,center.x))
      {
        circle( src, center, radius, Scalar(0,0,255), 3, 8, 0 );
        mag_count[frame]=mag_count[frame]+1;
      }
      
    }
   
    
  }


  hconcat(src,score,src);
  //resize(src,src,Size(src.cols/2,src.rows/2));	//resize the output window
  imshow("src",src);
//outputVideo<<src;		//write output to video
  waitKey(1);
}

int main(int argc, char **argv)
{
  VideoCapture vid=VideoCapture(argv[1]);
 
  vid>>img;	//read first frame
  int update=0;
  score=Mat(655,300,CV_8UC3);
  init();			//initiate score board
  while(img.data &&f<4000)	//while vdo has frames to read
  {
    for(int i=0;i<=FRAME_SKIP;i++,f++)	//skip FRAME_SKIP number of frames
    {
      vid>>img;				
    }

    Mat future;
     char name[100];
    sprintf(name,"../N1/board/%d.jpg",f);
    future=imread(name);
    resize(future,future,Size(future.cols/2,future.rows/2));
    imshow("future",future); 	//display result after removing skin

    //Mat input;
    //resize(img,input,Size(img.cols/2,img.rows/2));
    //imshow("input",input);

    img=img(Rect(Point(346,15),Point(img.cols-250,img.rows-50)));	//crop the input frame
    get_count(img);
    
    frame=(frame+1)%WINDOW;

    if(frame==0)		//after WINDOW number of frames update the score
    {
      get_max_count();
      if(max_b>9)
      {
        max_b=9;
      }

      if(max_w>9)
      {
        max_w=9;
      }

      if(max_m>1)
      {
        max_m=1;
      }

      printf("\nBlack : %d\tWhite : %d\tMag : %d\n",max_b,max_w,max_m);

      
      update++;
      score=Mat(img.rows,300,CV_8UC3);
      init();
    }
    
   // f++;
  }
  vid.release();

  return 0;
}

