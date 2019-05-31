#include <stdio.h>
#include <iostream>
#include <stack>
using namespace std;
int main()
{
    stack<int>stack1;
    //入栈
    for(int i=0;i<10;i++)
        stack1.push(i);
    while(!stack1.empty())
    {
        //取栈顶元素
        cout<<stack1.size()<<" "<<stack1.top()<<endl;
        //出栈
        stack1.pop();
    }
}
