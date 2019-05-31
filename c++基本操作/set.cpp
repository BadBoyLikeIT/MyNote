#include <iostream>
#include <set>
using namespace std;

//SET集合在插入的过程中就在排序，所以SET的最后的结果就是有序的
//SET有两个作用：去重、排序
void test_sort ()
{
	set<char>set_char;
    set_char.insert('b');
    set_char.insert('z');
    set_char.insert('f');
    set_char.insert('h');
    for(set<char>::iterator it = set_char.begin();it!=set_char.end();it++)
        cout<<*it<<endl;

}
//SET比较函数的重载，可以实现部分内容相同，仍然可以插入的效果
void OverloadSetCom()
{
    typedef struct Item
    {
        string type;
        string oid;
        bool operator < (Item item) const {
            if(type == item.type)
                return oid < item.oid;
            return type < item.type;
        }
        /*
        //同type的数据无法插入
        bool operator < (Item f) const {
		return type < (f.type);
        }
        */
    };
    Item item1 = {"ls","123"};
    Item item2 = {"ls","456"};
    Item item3 = {"wwj","123"};
    set<Item>setItem;
    setItem.insert(item1);
    setItem.insert(item2);
    setItem.insert(item3);
    for(set<Item>::iterator it = setItem.begin();it!=setItem.end();it++)
        cout<<it->type<<" "<<it->oid<<endl;
    cout<<setItem.size()<<endl;
}
int main()
{
//	SET集合同一个元素只能出现一次，因此可以利用这个特性进行重复元素的过滤

   set<int> set_int;
   //增加
   for(int i=0;i<10;i++)
     set_int.insert(i);
   //删除
    set_int.erase(4);
   //查询 容器中查询的过程基本上都是这种方式 比较迭代器指针与集合的末尾指针
    if(set_int.size()!=0)
    {
        set<int>::iterator it = set_int.find(8);
        if(it!=set_int.end())
            cout<<"find 8"<<endl;
    }
    //循环遍历
    for(set<int>::iterator it = set_int.begin();it!=set_int.end();it++)
        cout<<*it<<"\t";
    cout<<"\n"<<endl;
	test_sort();
}


