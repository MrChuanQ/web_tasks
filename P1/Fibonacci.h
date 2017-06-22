#ifndef _FIBONACCI_H_
#define _FIBONACCI_H_
#include<iostream>
#include<vector>
using namespace std;

/*
Fibonacci为斐波那契数列类，用于生成斐波那契数列
因为当斐波那契数列项数过多时无法用基本数据类型来保存每一项数字，所以通过字符数组来存储数字。
因此此斐波那契数列可以保存无限多的项（如果内存够的话） 
*/
class Fibonacci
{
	/*
	num：斐波那契数列的项数
	fibonacci：存储斐波那契数列的所有项
	add，length方法为公工方法提供辅助，因此将其私有化 
	*/
	private:
		int num;
		vector<char*>* fibonacci; //容器的一个元素代表的是斐波那契数列的一项
	
		char* add(char const *ch1, char const *ch2, int len1, int len2)//将斐波那契数列的两项以字符串表示的数字，进行相加得到下一项的以字符串表示的数字
		{
			//因为斐波那契数列为递增的数列，所以后一项的位数不小于前一项的位数。 
			int len = len1+1; //默认下一项的数字位数比前一项多一位，且第一位即最高位为预留位 
			int count = len; //用于保存len的值 
			char *sum = new char[len+1]; //创建用于保存下一项数字的字符数组 
			sum[0] = sum[len] = '\0'; //设置数组的结束标识 
			
			while(--len2>=0) //按普通的加法运算从低位向高位将前两项都有的数字位依次相加，并将结果存储在结果的相应数字位上 
			{
				sum[--len] = ch1[--len1] + ch2[len2] - '0';
			}
			while(--len1>=0) //将将数字位较长的前一项没有进行运算的高位赋值到结果的相应数字位上 
			{
				sum[--len] = ch1[len1];
			}
			
			int remainder; //余数
			int integer; //整数部分 
			while(--count>=1)//将结果的所有数字位用十进制表示
			{
				remainder = (sum[count] - '0') % 10; 
				integer = (sum[count] - '0') / 10;
				if(integer != 0)//如果数字位超过9，则进位，即前一位加1 
				{
					sum[count] = remainder + '0';//存储余数 
					if(count == 1) //如果要进位的数字位为预留位，及最高位，则预留位为1 
						sum[count-1] = 1 + '0';
					else //否则，要进位的数字位加1 
						sum[count-1] = sum[count-1] + 1;
				}	
			}
			
			if(sum[0]=='\0') //如果预留位及最高位没有用到，则将所有的数字位前移一位 
			{
				int i=1;
				for(; sum[i]!='\0'; i++)
					sum[i-1] = sum[i];
				sum[i-1] = '\0'; //在数字位的最后加上结束标志符 
			}
			
			return sum; //返回下一项 
		}
		
		int length(char const *ch) //返回斐波那契数列的一项数字的位数 
		{
			int i=0;
			for(; ch[i]!='\0';)
				i++;
			return i;
		}
	public:
		Fibonacci() //默认初始化构造函数 
		{
			this->num = 0;
			this->fibonacci = NULL;
		}
		Fibonacci(int num) //初始函数，斐波那契数列含有num个数字 
		{
			this->num = num;
			this->fibonacci = NULL;
		}
		void createFibonacci() //产生num个斐波那契数列数字
		{
			vector<char*>* vec = new vector<char*>(); //新建一个vector容器用来存放斐波那契数列数字 
			
			//产生num个斐波那契数列数字的策略：f(n)=f(n-1)+F(n-2) (n>2) 
			
			//斐波那契数列前两项都为1
			char* ch = new char[2];
			ch[0] = '1';
			ch[1] = '\0';
			vec->push_back(ch);
			vec->push_back(ch);
			 
			 //斐波那契数列的后n项
			char *f1,*f2;//分别为斐波那契数列的最后一项，倒数第二项 
			int len1=0,len2=0; //分别记录最后两项数字的位数 
			char *f; //记录产生的下一项斐波那契数列数字 
			for(int i=2; i<this->num; i++) 
			{
				f1 = (*vec)[i-1]; //斐波那契数列的最后一项
				f2 = (*vec)[i-2]; //斐波那契数列的倒数第二项
				
				len1 = length(f1);
				len2 = length(f2);
			
				f = add(f1,f2,len1,len2); //下一项数字为前两项数字之和
				vec->push_back(f); //添加产生的下一项斐波那契数列数字
			}
			
			this->fibonacci = vec;//记录产生的斐波那契数列
		}
		vector<char*>* getFibonacci() //获取斐波那契数列 
		{
			return this->fibonacci;
		}
};

#endif
