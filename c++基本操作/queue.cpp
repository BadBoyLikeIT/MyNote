#include <stdio.h>
#include <iostream>
#include <queue>
using namespace std;
int main()
{
   queue<int>queue1;
   for(int i=0;i<10;i++)
    queue1.push(i);//入队
    cout<<queue1.size()<<endl;
   while(!queue1.empty())
   {
       cout<<queue1.front()<<" "<<queue1.back()<<endl;  //队首、尾元素
       queue1.pop();//出队
   }
}

