#使用 $LOAD_PATH<<'.' 让Ruby知道必须在当前目录中搜索被引用的文件
$LOAD_PATH<<'.'
require "Student.rb"
require "ArrayTool.rb"
require "Comparator.rb"


#随机产生n个学生
def create_stus_by_rand(num)
  array_stu = Array.new
  (1..num).each do |i|
    id = i
    name = ""	#姓名的姓和名要以大写开头，其余为小写字母.姓和名都由6个字母组成，中间用空格分隔
    #姓名可由字母(含大小写)和空格组成
    lower_case_letters = ('a'..'z').to_a
    upper_case_letters = ('A'..'Z').to_a
    #随机产生名
    (1..6).each do |n|
      if n == 1
        name<<upper_case_letters[rand(26).to_i]
      else
        name<<lower_case_letters[rand(26).to_i]
      end
    end
    name<<" "
    #随机产生姓
    (1..6).each do |n|
      if n == 1
        name<<upper_case_letters[rand(26).to_i]
      else
        name<<lower_case_letters[rand(26).to_i]
      end	
    end

    gender = rand(2).to_i == 0?"男":"女"
    age = rand(6).to_i + 15
    #创建一个学生对象
    stu = Student.new(id, name, gender, age)
    #将此学生对象添加到数组中
    array_stu.push(stu)
  end
  #返回生成的学生数组
  return array_stu
end

#从文件读取并生成学生信息
def create_stus_from_file(filename)
  if !File.exist?(filename)	#磁盘文件不存在
    return nil
  end
  #磁盘文件存在
  array_stu = Array.new()
  IO.foreach(filename) do |str_stu|
    if str_stu[0] != "#"
      list_inf = str_stu.split("\t")
      stu = Student.new(list_inf[0].to_i, list_inf[1], list_inf[2], list_inf[3].to_i)
      array_stu.push(stu)
    end
  end
  return array_stu
end

#在标准输出设备输出所有学生信息
def output_to_std(array_stu)
  puts "#学号\t\t姓名\t性别\t年龄"
  array_stu.each do |stu|
    puts stu.to_string()
  end
end

#将所有学生信息存储到磁盘文件中
def output_to_file(array_stu, filename)
  file = File.new(filename, "w")
  file.write("#学号\t\t姓名\t性别\t年龄\n")
  array_stu.each do |stu|
    str_stu = stu.to_string() + "\n"
    file.write(str_stu)
  end
  file.close()
end

#创建学生，如果保存学生信息的文件不存在，则随机产生学生的信息并保存到磁盘文件中
array_stu = create_stus_from_file("student_inf.txt")
if array_stu == nil
  array_stu = create_stus_by_rand(100)
  output_to_file(array_stu, "student_inf.txt")
end

#输出创建的所有学生信息
output_to_std(array_stu)

#将产生的学生信息按姓名排序然后输出到磁盘文件中(若文件名相同则覆盖之前的文件)
ArrayTool.sort!(array_stu, CompareWithName.new)
output_to_file(array_stu, "student_inf.txt")

#将排序后的学生信息依次打印到标准输出设备
output_to_std(array_stu)