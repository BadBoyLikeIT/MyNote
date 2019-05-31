#include <iostream>
#include <malloc.h>
using namespace std;
typedef struct item
{
    int data;
    char word;
    item * next;
    item(int x,char y):data(x),word(y),next(NULL){}
}Item;
typedef struct node
{
    int data;
    node * next;
}Node,*pNode;

int main()
{
    //利用构造函数的初始化
    Item it(5,'v');
    cout<<it.data<<" "<<it.word<<endl;

    //构造pNode1 malloc
    Node * pNode1 = (Node *)malloc(sizeof(Node));
    pNode1->data = 1;
    pNode1->next = NULL;
    //构造pNode2 new
    pNode pNode2 = new Node;
    pNode2->next = pNode1;
    pNode2->data = 2;
    //构造pNode3
    Node node3 = {3,pNode2};
    pNode pNodeTemp=&node3;
    while(pNodeTemp->next!=NULL)
    {
        pNodeTemp = pNodeTemp->next;
    }
    cout<<"the lastest node data is "<<pNodeTemp->data<<endl;


    return 0;
}

//示例二:重载结构体<操作
//set集合中会做两个事情：1.排序。2.去重(因为它只定义了<的操作)
#include <iostream>
#include <string.h>
#include <set>
using namespace std;

typedef struct Item
{
    string type;
    string oid;
    bool operator < (Item item) const {
        if(type == item.type)
            return oid < item.oid;
		return type < (item.type);
	}
}Item;


int main()
{
    set<Item>setTest;
    Item item1;
    item1.type = "123";
    item1.oid = "lsls";
    setTest.insert(item1);
    Item item2 = {"456","meiqi"};
    setTest.insert(item2);
    Item item3 = {"123","lslslss"};
    setTest.insert(item3);
    for(set<Item>::iterator itSet = setTest.begin();itSet!=setTest.end();itSet++)
        cout<<itSet->type<<" "<<itSet->oid<<endl;
    return 0;
}
