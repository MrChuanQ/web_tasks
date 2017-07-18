$LOAD_PATH<<'.'
class Student
  attr_accessor:id,:name,:gender,:age	#通过访问器实现成员变量的set、get功能

  def initialize(id, name, gender, age)
	@id = id	#id:学号
	@name = name	#@name:姓名
	@gender = gender	#@gender:性别
	@age = age	#age:年龄
  end

  #学生信息的字符串表示形式
  def to_string()
	#"学号：" + "#{@id}" + "\t姓名：" + "#{@name}" + "\t性别：" + "#{@gender}" + "\t年龄：" + "#{@age}"
	return "#{@id}" + "\t#{@name}" + "\t#{@gender}" + "\t#{@age}"
  end
end
