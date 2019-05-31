#include <iostream>
#include <fstream>
#include <string>
using namespace std;

//读写文件的操作
//函数默认参数的一种写法
void ReadAndWriteFile(string sourcePath,string destPath = "")
{
    ifstream fin;
    fin.open(sourcePath,ios::in);
    //异常处理
    if(!fin)
    {
        cout<<"can't read "<<sourcePath<<endl;
        return ;
    }
    string line;
	//集中输出,节省时间
    string res; 
    //舍弃第一行
    //getline(fin,line);
    while(getline(fin,line))
    {
        cout<<line<<endl;
        res += line + '\n';
    }
    fin.close();
    if(destPath!="")
    {
        ofstream fout;
        fout.open(destPath,ios::out);
        if(!fout)
        {
            cout<<"can't read "<<sourcePath<<endl;
            return ;
        }
        //删除最后一行的空行
        res = res.substr(0, res.length() - 1);
        //res.erase(res.end() - 1);
        fout<<res;
        fout.close();
    }
    return ;
}
//读取一行的操作
void ReadSingleRow()
{
	char str1[20];
    char str2[20];
    cin.clear();
    //get不会丢弃\n
    cin.get(str1,19);
    cin.get();
    cin.get(str2,19);
    cout<<"str1 : "<<str1<<endl;
    cout<<"str2 : "<<str2<<endl;

    char str3[20];
    char str4[20];
    //getline是会将\n丢弃的
    cin.get();
    cin.getline(str3,19);
    cin.getline(str4,19);
    cout<<"str3 :"<<str3<<endl;
    cout<<"str4 : "<<str4<<endl;
}
int main()
{
    //注意windows下的路径书写格式
    string sourcePath = "D:/kit/codeblocks/test/c++_test/data1.txt";
    string destPath = "C:/Users/handsomeli/Desktop/a.txt";
    ReadAndWrite(sourcePath,destPath);
    return 0;
}


//利用sstream来切割字符串 以空格为切割符
#include <iostream>
#include <string>
#include <sstream>
using namespace std;
//istringstream 是以空格为切割符的
int main()
{
    string line,word;
    while(getline(cin,line))
    {
        istringstream stream(line);
        while(stream >> word)
            cout<<word<<endl;
    }
    return 0;

}

