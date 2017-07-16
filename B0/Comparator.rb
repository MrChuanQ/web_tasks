#Comparator(比较器):自定义模板,包含一个虚函数，用于比较两个对象，可由具体实例实现
module Comparator
	def compare(one,another)
end

#继承Comparator,实现compare方法，学生信息通过id进行比较
class CompareWithId
	include Comparator
	def compare(one,another)
		return one.get_id() - another.get_id()
	end
end

#继承Comparator,实现compare方法，学生信息通过age进行比较
class CompareWithAge
	include Comparator
	def compare(one,another)
		return one.get_age() - another.get_age()
	end
end

#继承Comparator,实现compare方法，学生信息通过name进行比较
class CompareWithName
	include Comparator
	def compare(one,another)
		return one.get_name() <=> another.get_name()
	end
end