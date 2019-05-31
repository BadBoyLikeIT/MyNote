#include <stdio.h>
#include <iostream>
#include <vector>
#include <iterator>
using namespace std;
int main()
{
//vector 可以插入重复的数据,且是顺序排序的
    vector <int> vec;
    //插入
    for(int i=0; i<10;i++)
        vec.push_back(i);
    //删除
    vec.pop_back();//删除最后一个元素
	for(vector<int>::iterator it = vec.begin();it!=vec.end();it++)
    {
        if(*it == 5)
            vec.erase(it);
        vec.erase(vec.begin()+1);
    } //删除特定的元素 erase必须删除指针
	vec.erase(vec.begin()+2,vec.begin()+4); //删除一个第三、四个元素
    //查询
    cout<<vec.front()<<endl;
    cout<<vec.back()<<endl;
    cout<<vec[1]<<endl;
    //遍历查询 注意迭代器使用的变量如何使用
    for(vector<int>::iterator it = vec.begin();it!=vec.end();it++)
        cout<<*it<<endl;
    for(int i=0;i<vec.size();i++)
        cout<<vec[i]<<endl;
    vec.clear(); //释放了指针
}
