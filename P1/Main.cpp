#include<iostream>
#include"Fibonacci.h"

using namespace std;

int main()
{
	cout<<"请输入需要的斐波那契数列的数字个数。请输入：";
	int num; //需要的斐波那契数列的数字个数
	do
	{
		cin>>num;
		if(num<2) //个数小于2，则重新输入 
			cout<<"个数不能小于1！请重新输入：";
		else //满足则跳出循环 
			break;
	}while(true); //当个数小于1时一直循环 
	
	Fibonacci* fibonacci = new Fibonacci(num); //创建斐波那契数列对象 
	fibonacci->createFibonacci(); //产生num个斐波那契数列数字 
	vector<char*>* vec =  fibonacci->getFibonacci(); //获取产生的斐波那契数列数字
	
	//输出产生的斐波那契数列数字,每输出10个换一行 
	vector<char*>::iterator it;
	int i = 1;
	for(it=vec->begin(); it!=vec->end(); it++)
	{
		cout<<(*it);
		
		if(i == 10)
		{
			cout<<endl;
			i = 1;
		}
		else
		{
			cout<<' ';
			i++;
		}	
	}
	
	return 0;
}
