#include <iostream>
#include <map>
using namespace std;
void MapComplic(string source_data);

//map一个元素只可以插入一次，插入多次会覆盖，所以需要处理冲突，利用相应的数据结构
//map的关键字如果是int类型的，将会默认排序
int main()
{

    //声明
    map<int,string> lsmap;
    //插入
    lsmap.insert(map<int,string>::value_type(1,"lishuai"));
    lsmap[2] = "wangwenjing";   //这种方式会存在一定的问题
    lsmap.insert(pair<int,string>(3,"shenzimo"));
    //删除
    lsmap.erase(3);
    //遍历 查询
    for(map<int,string>::iterator it = lsmap.begin();it != lsmap.end(); it++)
    {
        cout<<it->second<<endl;
    }
    //单项查询
    map<int,string>::iterator it1 = lsmap.find(2);
    if(it1!=lsmap.end())
        cout<<"find "<<lsmap[2]<<endl;
    //判断map为空
    if(!lsmap.empty())
    	cout<<"ls is successful!"<<endl;
    lsmap.clear(); //释放了指针
}

//冲突解决的一个实例
void MapComplic(string source_data)
{
	map<int, Data>source_data_map;  
	typedef struct Item
	{
		string type;
		string oid;
	}Item;
	typedef struct Data
	{
		ong uid;
		vector<Item> item_set; //用于处理map冲突的内容
	}Data;
	
	ifstream fin;
	fin.open(source_data, ios::in);
	if (!fin)
	{
		cout << "open file faild" << endl;
		return;
	}
	string line;
	getline(fin, line);  //扔掉第一行
	int num = 0,diff = 0;
	while (getline(fin,line))  //一行一行读取
	{
		//第一行不读 未完成
		int pos = line.find(",");
		Data data_line;
		Item item;
		item.type = line.substr(0, pos);
		line = line.substr(pos + 1);
		pos = line.find(",");
		data_line.uid = stol(line.substr(0, pos));
		item.oid = line.substr(pos + 1);
		data_line.item_set.push_back(item);
		//构造data1_map 以及hash冲突的解决 map如果以int为key则会对其进行排序
		map<int, Data>::iterator it = source_data_map.find(data_line.uid);
		if (it == source_data_map.end())
			source_data_map.insert(pair<int, Data>(data_line.uid, data_line));
		else
		{
			vector<Item>::iterator it_item_set = it->second.item_set.begin();
			while (it_item_set!=it->second.item_set.end())
			{
				if (item.type == it_item_set->type  && item.oid == it_item_set->oid)
				{
					num++;  //相同的数据项 数目
					break;
				}	
				it_item_set++;
			}
			if (it_item_set == it->second.item_set.end())
			{
				it->second.item_set.push_back(item);
				diff++;
			}
		}
	}	
	//测试用例
	cout <<"the map size: "<<source_data_map.size()<<"  the same: "<<num<<" the diff: "<<diff << endl;
	fin.close();
}