module ArrayTool
  #将所有指定元素添加到指定 collection 中
  def ArrayTool.add(array, *objs)
	objs.each do |obj|
		array.push(obj)
	end
  end

  #删除数组指定位置处的元素
  def ArrayTool.delete_at(array, index)
	array.delete_at(index)
  end
  #从数组中删除等于obj的所有元素
  def ArrayTool.delete(array, obj)
	array.delete(obj)
  end
  #从数组中删除等于obj的第一个元素
  def ArrayTool.delete_obj(array, obj)
	index = array.index(obj)
	array.delete_at(index)
  end

  #返回数组中第一个等于obj的元素的角标
  def ArrayTool.index(array, obj)
	return array.index(obj)
  end
  #返回索引为index的元素
  def ArrayTool.at(array, index)
	return array.at(index)
  end

  #把array的内容替换为other_array的内容
  def ArrayTool.replace(array, other_array)
	array.replace(other_array)
  end
  #把array的index角标下的元素替换为new_obj
  def ArrayTool.replace_at(array, index, new_obj)
	array[index] = new_obj
  end
  #使用另一个元素替换数组中出现的所有某一指定元素
  def ArrayTool.replace_all(array, old_obj, new_obj)
	array.collect!{|obj| if obj==old_obj then new_obj else obj end}
  end

  #对数组进行排序,按照id,age和name首字母排序(升序),具体的比较方式由comparator指定
  def ArrayTool.sort!(array, comparator)
 	#如果array无元素或只有一个元素则返回数组本身
	size = array.size
	if size ==0 || size == 1
      return array
	end

	(0..size-2).each do |i|
	  (i+1..size-1).each do |j|
		if comparator.compare(array[i], array[j]) > 0
		  temp = array[i]
		  array[i] = array[j]
		  array[j] = temp
		end
	  end		
	end
  end
  #创建原数组的一个副本，对副本进行排序并返回副本（原数组不变）
  def ArrayTool.sort(array, comparator)
	new_array = array.clone()	#创建array的一个副本
	ArrayTool.sort!(new_array, comparator)	#直接对副本按name排序
	return new_array	#返回排序后的副本
  end

  #判断数组是否为空
  def ArrayTool.empty?(array)
	return array.empty?
  end
end